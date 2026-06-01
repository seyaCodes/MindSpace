import { handleCors, jsonResponse, errorResponse } from "../_shared/cors.ts";
import { createGroqClient } from "../_shared/groq_client.ts";
import {
  createAdminClient,
  extractBearerToken,
  verifyUserToken,
} from "../_shared/supabase_client.ts";
import type { Message, ReflectionResult } from "../_shared/types.ts";

function buildReflectionPrompt(transcript: string): string {
  return `You are Sage, a compassionate AI companion in the MindSpace app.
Read the conversation below and produce a post-session reflection in JSON.

CONVERSATION:
${transcript}

Return ONLY a valid JSON object — no markdown, no extra text:
{
  "what_sage_heard": "2-3 sentence empathetic summary of what the user shared, written from Sage's first-person perspective",
  "question_to_sit_with": "One open-ended, gentle question for the user to reflect on",
  "shared_perspective": "2-3 sentence warm, non-judgmental insight or perspective"
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
    const chatId: unknown = body?.chat_id;
    if (typeof chatId !== "string") {
      return errorResponse("chat_id is required", 400);
    }

    // Verify ownership
    const { data: chat, error: chatErr } = await admin
      .from("chats")
      .select("id, user_id")
      .eq("id", chatId)
      .eq("user_id", userId)
      .single();

    if (chatErr || !chat) return errorResponse("Chat not found", 404);

    // Fetch messages
    const { data: messages, error: msgErr } = await admin
      .from("messages")
      .select("role, content")
      .eq("chat_id", chatId)
      .order("created_at", { ascending: true });

    if (msgErr) throw new Error(msgErr.message);
    if (!messages || messages.length === 0) {
      return errorResponse("No messages found for this chat", 404);
    }

    const transcript = (messages as Pick<Message, "role" | "content">[])
      .map((m) => `${m.role === "user" ? "User" : "Sage"}: ${m.content}`)
      .join("\n");

    const groq = createGroqClient();
    const raw = await groq.chat(
      [{ role: "user", content: buildReflectionPrompt(transcript) }],
      { model: "llama-3.3-70b-versatile", temperature: 0.6, max_tokens: 600 },
    );

    let reflection: ReflectionResult;
    try {
      const match = raw.match(/\{[\s\S]*\}/);
      reflection = JSON.parse(match?.[0] ?? raw) as ReflectionResult;
    } catch {
      throw new Error("LLM returned non-JSON response for reflection");
    }

    if (
      !reflection.what_sage_heard ||
      !reflection.question_to_sit_with ||
      !reflection.shared_perspective
    ) {
      throw new Error("LLM reflection is missing required fields");
    }

    return jsonResponse(reflection);
  } catch (err) {
    console.error("[end-chat]", err);
    return errorResponse(err instanceof Error ? err.message : "Internal error");
  }
});
