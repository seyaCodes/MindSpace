import { handleCors, jsonResponse, errorResponse } from "../_shared/cors.ts";
import { createGroqClient } from "../_shared/groq_client.ts";
import {
  createAdminClient,
  extractBearerToken,
  verifyUserToken,
} from "../_shared/supabase_client.ts";
import type { Reflection, ArcInsightResult } from "../_shared/types.ts";

const MIN_REFLECTIONS = 3;

function buildInsightPrompt(arcName: string, reflections: Reflection[]): string {
  const entries = reflections
    .map(
      (r, i) =>
        `Session ${i + 1}:
  Heard: ${r.what_sage_heard}
  Perspective: ${r.shared_perspective}
  Question: ${r.question_to_sit_with}`,
    )
    .join("\n\n");

  return `You are Sage, a compassionate AI companion.
Below are reflections from multiple journaling sessions for the arc titled "${arcName}".

${entries}

Synthesize these sessions into an arc insight. Return ONLY valid JSON with no extra text:
{
  "how_it_evolved": "2-4 sentences describing how the user's emotional journey evolved across these sessions",
  "pattern_noticed": "1-3 sentences identifying a recurring theme, pattern, or growth area",
  "turning_point": "A single short sentence or phrase (ideally echoing the user's own words) that marks the moment something shifted",
  "turning_point_context": "1-2 sentences explaining why that moment mattered and what it opened up"
}`;
}

Deno.serve(async (req: Request) => {
  const cors = handleCors(req);
  if (cors) return cors;

  try {
    const token = extractBearerToken(req);
    const admin = createAdminClient();
    const userId = await verifyUserToken(admin, token);

    const body = await req.json().catch(() => null);
    const arcId: unknown = body?.arc_id;
    if (typeof arcId !== "string") {
      return errorResponse("arc_id is required", 400);
    }

    const { data: arc, error: arcErr } = await admin
      .from("arcs")
      .select("id, user_id, name, session_count")
      .eq("id", arcId)
      .eq("user_id", userId)
      .single();

    if (arcErr || !arc) return errorResponse("Arc not found", 404);

    // Primary: reflections with arc_id set directly
    const { data: directReflections, error: refErr } = await admin
      .from("reflections")
      .select("id, what_sage_heard, question_to_sit_with, shared_perspective, created_at")
      .eq("arc_id", arcId)
      .order("created_at", { ascending: true });

    if (refErr) throw new Error(refErr.message);

    let reflections = directReflections ?? [];
    console.log(`[generate-arc-insight] direct reflections: ${reflections.length}`);

    // Fallback: reflections linked via chats.arc_id (catches sessions where reflection.arc_id wasn't set)
    if (reflections.length < MIN_REFLECTIONS) {
      console.log(`[generate-arc-insight] fewer than ${MIN_REFLECTIONS} direct — trying chats fallback`);
      const { data: chatLinks } = await admin
        .from("chats")
        .select("id")
        .eq("arc_id", arcId);

      if (chatLinks && chatLinks.length > 0) {
        const chatIds = chatLinks.map((c: { id: string }) => c.id);
        const { data: viaChats } = await admin
          .from("reflections")
          .select("id, what_sage_heard, question_to_sit_with, shared_perspective, created_at")
          .in("chat_id", chatIds)
          .order("created_at", { ascending: true });

        if (viaChats) {
          const seen = new Set(reflections.map((r: { id: string }) => r.id));
          for (const r of viaChats) {
            if (!seen.has(r.id)) {
              reflections.push(r);
              seen.add(r.id);
              // Backfill arc_id so future queries find it directly
              await admin.from("reflections").update({ arc_id: arcId }).eq("id", r.id);
            }
          }
        }
      }
      console.log(`[generate-arc-insight] after fallback: ${reflections.length} reflections`);
    }

    if (reflections.length < MIN_REFLECTIONS) {
      return errorResponse(
        `Need at least ${MIN_REFLECTIONS} sessions to generate an arc insight (have ${reflections.length})`,
        422,
      );
    }

    const groq = createGroqClient();
    const raw = await groq.chat(
      [{ role: "user", content: buildInsightPrompt(arc.name, reflections as Reflection[]) }],
      { model: "llama-3.3-70b-versatile", temperature: 0.65, max_tokens: 800 },
    );

    let insight: ArcInsightResult;
    try {
      const match = raw.match(/\{[\s\S]*\}/);
      insight = JSON.parse(match?.[0] ?? raw) as ArcInsightResult;
    } catch {
      throw new Error("LLM returned non-JSON response for arc insight");
    }

    if (!insight.how_it_evolved || !insight.pattern_noticed) {
      throw new Error("LLM arc insight is missing required fields");
    }

    const { data: saved, error: saveErr } = await admin
      .from("arc_insights")
      .insert({
        arc_id: arcId,
        user_id: userId,
        how_it_evolved: insight.how_it_evolved,
        pattern_noticed: insight.pattern_noticed,
        turning_point: insight.turning_point ?? null,
        turning_point_context: insight.turning_point_context ?? null,
        session_count_at_generation: arc.session_count,
      })
      .select()
      .single();

    if (saveErr) throw new Error(`Failed to save arc insight: ${saveErr.message}`);

    return jsonResponse(saved);
  } catch (err) {
    console.error("[generate-arc-insight]", err);
    return errorResponse(err instanceof Error ? err.message : "Internal error");
  }
});