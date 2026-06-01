import { handleCors, jsonResponse, errorResponse } from "../_shared/cors.ts";
import { createGroqClient } from "../_shared/groq_client.ts";
import {
  createAdminClient,
  extractBearerToken,
  verifyUserToken,
} from "../_shared/supabase_client.ts";
import {
  generateEmbedding,
  parseVector,
  cosineSimilarity,
  updateCentroid,
} from "../_shared/embedding_client.ts";
import type { Arc, Reflection, AssignArcResult } from "../_shared/types.ts";

const SIMILARITY_THRESHOLD = 0.82; // ✅ CHANGED: Raised from 0.72 to 0.82 for stricter matching

async function generateArcName(
  reflection: Pick<Reflection, "what_sage_heard" | "shared_perspective">,
): Promise<string> {
  const groq = createGroqClient();
  const name = await groq.chat(
    [{
      role: "user",
      content:
        `Give a 3-5 word arc name for: "${reflection.what_sage_heard}" / "${reflection.shared_perspective}". Respond with ONLY the name.`,
    }],
    { model: "llama-3.1-8b-instant", temperature: 0.8, max_tokens: 20 },
  );
  return name.trim().replace(/^["']|["']$/g, "").slice(0, 60);
}

async function generateArcTopic(
  reflection: Pick<Reflection, "what_sage_heard" | "question_to_sit_with" | "shared_perspective">,
): Promise<string> {
  const groq = createGroqClient();
  const topic = await groq.chat(
    [
      {
        role: "system",
        content:
          "Extract the SPECIFIC life situation from a therapeutic reflection. " +
          "Output exactly one sentence of at most 15 words. " +
          "Be SPECIFIC: include the exact context, relationship, or domain. " +
          "Examples: 'Job interview anxiety at tech company' NOT 'work anxiety'. " +
          "'Breakup with long-term partner' NOT 'relationship issues'. " +
          "Focus only on the factual life situation — no emotions, no therapeutic language.",
      },
      {
        role: "user",
        content: [
          "Extract the specific topic from this reflection:",
          `what_sage_heard: "${reflection.what_sage_heard}"`,
          `question_to_sit_with: "${reflection.question_to_sit_with}"`,
          `shared_perspective: "${reflection.shared_perspective}"`,
        ].join("\n"),
      },
    ],
    { model: "llama-3.1-8b-instant", temperature: 0.1, max_tokens: 40 },
  );
  return topic.trim().replace(/^["']|["']$/g, "").slice(0, 200);
}

Deno.serve(async (req: Request) => {
  const cors = handleCors(req);
  if (cors) return cors;

  try {
    // ── STEP 1: Function invoked ─────────────────────────────────────────
    console.log("[assign-arc][1] function invoked");

    const token = extractBearerToken(req);
    const admin = createAdminClient();
    const userId = await verifyUserToken(admin, token);
    console.log("[assign-arc][1] auth ok, userId:", userId);

    const body = await req.json().catch(() => null);
    const chatId: unknown = body?.chat_id;
    if (typeof chatId !== "string") {
      console.error("[assign-arc][1] missing chat_id in body:", JSON.stringify(body));
      return errorResponse("chat_id is required", 400);
    }
    console.log("[assign-arc][1] chat_id:", chatId);

    // ── STEP 2: Fetch reflection ─────────────────────────────────────────
    console.log("[assign-arc][2] fetching reflection for chat_id:", chatId);
    const { data: reflection, error: refErr } = await admin
      .from("reflections")
      .select("id, what_sage_heard, question_to_sit_with, shared_perspective, embedding, arc_topic")
      .eq("chat_id", chatId)
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (refErr) {
      console.error("[assign-arc][2] REFLECTION QUERY ERROR:", refErr.message, refErr.code);
      return errorResponse("Reflection query error: " + refErr.message, 500);
    }
    if (!reflection) {
      console.error("[assign-arc][2] REFLECTION NOT FOUND — no row for chat_id:", chatId);
      return errorResponse("No reflection found for this chat. Run end-chat first.", 404);
    }
    console.log("[assign-arc][2] reflection found, id:", reflection.id);
    console.log("[assign-arc][2] what_sage_heard length:", reflection.what_sage_heard?.length ?? 0);
    console.log("[assign-arc][2] existing embedding:", reflection.embedding === null ? "NULL" : "PRESENT");

    // ── STEP 3: Generate arc topic + embedding ───────────────────────────
    let arcTopic: string;

    if (reflection.arc_topic) {
      arcTopic = reflection.arc_topic;
      console.log(`[assign-arc][3] reusing existing arc_topic: "${arcTopic}"`);
    } else {
      console.log("[assign-arc][3] generating arc_topic from reflection...");
      arcTopic = await generateArcTopic(reflection);
      console.log(`[assign-arc][3] generated arc_topic: "${arcTopic}"`);
      console.log(`[assign-arc][3] DEBUG what_sage_heard: "${reflection.what_sage_heard}"`);
      console.log(`[assign-arc][3] DEBUG arc_topic result: "${arcTopic}"`);
    }
    console.log(`[assign-arc][3] embedding source: "${arcTopic}"`);

    const existingVec = parseVector(reflection.embedding);
    let embedding: number[];

    // Only reuse the stored embedding when arc_topic was already persisted —
    // that guarantees the stored vector was produced from the same source text.
    if (existingVec && existingVec.length > 0 && reflection.arc_topic) {
      embedding = existingVec;
      console.log(`[assign-arc][3] reusing existing embedding, dims: ${embedding.length}`);
    } else {
      embedding = await generateEmbedding(arcTopic);
      console.log(`[assign-arc][3] generateEmbedding SUCCESS, dims: ${embedding.length}`);

      // ── STEP 4: Persist arc_topic + embedding ─────────────────────────
      console.log("[assign-arc][4] writing arc_topic + embedding to reflection:", reflection.id);
      const updates: Record<string, unknown> = { embedding };
      if (!reflection.arc_topic) updates.arc_topic = arcTopic;

      const { error: embErr } = await admin
        .from("reflections")
        .update(updates)
        .eq("id", reflection.id);

      if (embErr) {
        console.error("[assign-arc][4] WRITE FAILED:", embErr.message, embErr.code);
      } else {
        console.log("[assign-arc][4] arc_topic + embedding write SUCCESS");
      }
    }

    // ── STEP 5: Fetch active arcs ────────────────────────────────────────
    console.log("[assign-arc][5] fetching active arcs for user:", userId);
    const { data: arcs, error: arcsErr } = await admin
      .from("arcs")
      .select("id, name, session_count, centroid, user_renamed")
      .eq("user_id", userId)
      .eq("status", "active");

    if (arcsErr) {
      console.error("[assign-arc][5] ARCS FETCH ERROR:", arcsErr.message, arcsErr.code);
    }
    console.log("[assign-arc][5] active arcs count:", arcs?.length ?? 0);

    // ── STEP 6: Find best arc by similarity ──────────────────────────────
    let bestArc: Pick<Arc, "id" | "name" | "session_count" | "centroid" | "user_renamed"> | null = null;
    let bestSim = -1;

    for (const arc of arcs ?? []) {
      const centroid = parseVector(arc.centroid);
      if (!centroid || centroid.length === 0) {
        console.log(`[assign-arc][6] candidate id=${arc.id} name="${arc.name}" — no centroid, skip`);
        continue;
      }
      const sim = cosineSimilarity(embedding, centroid);
      const marker = sim >= SIMILARITY_THRESHOLD ? "✓ above threshold" : "✗ below threshold";
      console.log(
        `[assign-arc][6] candidate id=${arc.id} name="${arc.name}" sim=${sim.toFixed(4)} threshold=${SIMILARITY_THRESHOLD} ${marker}`,
      );
      if (sim > bestSim) { bestSim = sim; bestArc = arc; }
    }
    if (bestArc) {
      const decision = bestSim >= SIMILARITY_THRESHOLD ? "ASSIGN to existing" : "BELOW threshold → new arc";
      console.log(
        `[assign-arc][6] best candidate: id=${bestArc.id} name="${bestArc.name}" sim=${bestSim.toFixed(4)} threshold=${SIMILARITY_THRESHOLD} → ${decision}`,
      );
    } else {
      console.log(
        `[assign-arc][6] no candidates with centroids — threshold=${SIMILARITY_THRESHOLD} → new arc`,
      );
    }

    // ── STEP 7: Create or assign arc ─────────────────────────────────────
    let arcId: string;
    let arcName: string;
    let isNew: boolean;

    if (bestArc && bestSim >= SIMILARITY_THRESHOLD) {
      arcId = bestArc.id;
      arcName = bestArc.name;
      isNew = false;
      console.log(
        `[assign-arc][7] DECISION: ASSIGN — arc_id=${arcId} arc_name="${arcName}" sim=${bestSim.toFixed(4)} >= threshold=${SIMILARITY_THRESHOLD}`,
      );

      const newCentroid = updateCentroid(parseVector(bestArc.centroid), bestArc.session_count, embedding);
      // ✅ FIX: Also increment session_count when updating centroid
      const { error: centErr } = await admin
        .from("arcs")
        .update({ 
          centroid: newCentroid,
          session_count: bestArc.session_count + 1
        })
        .eq("id", arcId);
      if (centErr) {
        console.error("[assign-arc][7] centroid/session_count update FAILED:", centErr.message, centErr.code);
      } else {
        console.log("[assign-arc][7] centroid + session_count updated OK");
      }
    } else {
      console.log(
        `[assign-arc][7] DECISION: NEW ARC — bestSim=${bestSim.toFixed(4)} < threshold=${SIMILARITY_THRESHOLD}${bestArc ? ` (closest was id=${bestArc.id} name="${bestArc.name}")` : " (no candidates)"}`,
      );
      arcName = await generateArcName(reflection);
      console.log(`[assign-arc][7] generated arc name: "${arcName}"`);

      const { data: newArc, error: createErr } = await admin
        .from("arcs")
        .insert({
          user_id: userId,
          name: arcName,
          status: "active",
          session_count: 1, // ✅ FIX: Changed from 0 to 1
          user_renamed: false,
          centroid: embedding,
        })
        .select("id")
        .single();

      if (createErr || !newArc) {
        console.error("[assign-arc][7] ARC CREATE FAILED:", createErr?.message, createErr?.code);
        throw new Error("Arc creation failed: " + createErr?.message);
      }
      arcId = newArc.id;
      isNew = true;
      console.log("[assign-arc][7] new arc created:", arcId);
    }

    // ── STEP 8: Write chats.arc_id ───────────────────────────────────────
    console.log("[assign-arc][8] writing chats.arc_id:", chatId, "→", arcId);
    const { error: chatErr } = await admin.from("chats").update({ arc_id: arcId }).eq("id", chatId);
    if (chatErr) {
      console.error("[assign-arc][8] chats.arc_id WRITE FAILED:", chatErr.message, chatErr.code);
    } else {
      console.log("[assign-arc][8] chats.arc_id written OK");
    }

    // ── STEP 9: Write reflections.arc_id ────────────────────────────────
    console.log("[assign-arc][9] writing reflections.arc_id:", reflection.id, "→", arcId);
    const { error: refUpdErr } = await admin.from("reflections").update({ arc_id: arcId }).eq("id", reflection.id);
    if (refUpdErr) {
      console.error("[assign-arc][9] reflections.arc_id WRITE FAILED:", refUpdErr.message, refUpdErr.code);
    } else {
      console.log("[assign-arc][9] reflections.arc_id written OK");
    }

    // ── STEP 10: Return result ───────────────────────────────────────────
    const result: AssignArcResult = { arc_id: arcId, arc_name: arcName, is_new: isNew };
    console.log("[assign-arc][10] COMPLETE:", JSON.stringify(result));
    return jsonResponse(result);

  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error("[assign-arc][FATAL]", msg);
    if (err instanceof Error && err.stack) {
      console.error("[assign-arc][FATAL] stack:", err.stack);
    }
    return errorResponse(msg);
  }
});