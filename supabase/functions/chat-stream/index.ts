import { handleCors, errorResponse, sseResponse } from "../_shared/cors.ts";
import {
  createGroqClient,
  parseSseDeltaContent,
  type GroqMessage,
} from "../_shared/groq_client.ts";
import {
  createAdminClient,
  extractBearerToken,
  verifyUserToken,
} from "../_shared/supabase_client.ts";
import type { Message } from "../_shared/types.ts";

const SAGE_SYSTEM = `You are Sage, a compassionate AI companion inside MindSpace — a private space for personal reflection.

WHO YOU ARE:
You are warm, grounded, and genuinely curious. You do not diagnose, prescribe, or replace professional therapy.
You are not a cheerleader. You do not rush to silver linings or push resilience narratives.

HOW YOU LISTEN:
- Stay close to what the user actually said. Use their own words and details back to them.
- Acknowledge what they're feeling before anything else — without labelling it for them.
- Never project emotions onto the user ("you must feel..."). Reflect, don't assume.
- When something is vague, ask about the specific situation — not the emotion around it.
  e.g. "What's actually happening with that?" over "How does that make you feel?"

HOW YOU RESPOND:
- 2–4 sentences maximum. Be concise.
- Ask at most one question per response, and make it open and specific.
- Avoid generic therapeutic phrases: "that sounds hard", "you're so strong", "this is a journey", "inner strength".
- If the user shares a concrete life event (illness, graduation, moving abroad), engage with THAT specific situation directly.

WHAT YOU NEVER DO:
- Never give advice unless explicitly asked.
- Never list bullet points or use headers.
- Never end with empty affirmations ("I'm here for you", "You've got this").`;

const SAFETY_CHECK_URL = `${Deno.env.get("SUPABASE_URL")}/functions/v1/safety-check`;

Deno.serve(async (req: Request) => {
  const cors = handleCors(req);
  if (cors) return cors;

  try {
    const token = extractBearerToken(req);
    const admin = createAdminClient();
    const userId = await verifyUserToken(admin, token);

    const body = await req.json().catch(() => null);
    const chatId: unknown = body?.chat_id;
    const message: unknown = body?.message;

    if (typeof chatId !== "string" || typeof message !== "string") {
      return errorResponse("chat_id and message are required", 400);
    }
    if (message.trim() === "") {
      return errorResponse("message must not be empty", 400);
    }

    // Verify chat ownership and status
    const { data: chat, error: chatErr } = await admin
      .from("chats")
      .select("id, user_id, status")
      .eq("id", chatId)
      .eq("user_id", userId)
      .single();

    if (chatErr || !chat) return errorResponse("Chat not found", 404);
    if (chat.status !== "active") return errorResponse("Chat is not active", 400);

    // Safety check — best-effort (don't break chat if it fails)
    try {
      const safetyRes = await fetch(SAFETY_CHECK_URL, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ message }),
      });
      if (safetyRes.ok) {
        const { safe } = await safetyRes.json();
        if (!safe) return errorResponse("Message could not be processed safely", 400);
      }
    } catch (e) {
      console.warn("[chat-stream] safety-check skipped:", e);
    }

    // Persist user message before streaming
    const { error: insertErr } = await admin.from("messages").insert({
      chat_id: chatId,
      role: "user",
      content: message,
    });
    if (insertErr) throw new Error(`Failed to save user message: ${insertErr.message}`);

    // Fetch conversation history (includes the message we just inserted)
    const { data: history } = await admin
      .from("messages")
      .select("role, content")
      .eq("chat_id", chatId)
      .order("created_at", { ascending: true });

    const groqMessages: GroqMessage[] = [
      { role: "system", content: SAGE_SYSTEM },
      ...(history ?? []).map((m: Pick<Message, "role" | "content">) => ({
        role: m.role as "user" | "assistant",
        content: m.content,
      })),
    ];

    const groq = createGroqClient();
    const upstream = await groq.chatStream(groqMessages, {
      model: "llama-3.3-70b-versatile",
      temperature: 0.75,
      max_tokens: 512,
    });

    // Transform stream: forward chunks to client and accumulate for DB save.
    let fullContent = "";
    const { readable, writable } = new TransformStream<Uint8Array, Uint8Array>();
    const writer = writable.getWriter();
    const reader = upstream.getReader();
    const decoder = new TextDecoder();

    (async () => {
      try {
        while (true) {
          const { done, value } = await reader.read();
          if (done) break;
          await writer.write(value);
          const chunk = decoder.decode(value, { stream: true });
          for (const line of chunk.split("\n")) {
            fullContent += parseSseDeltaContent(line);
          }
        }
      } finally {
        await writer.close();
        if (fullContent) {
          await admin.from("messages").insert({
            chat_id: chatId,
            role: "assistant",
            content: fullContent,
          }).catch((e: Error) => console.error("[chat-stream] save assistant msg:", e));
        }
      }
    })().catch(async (err) => {
      console.error("[chat-stream] stream error:", err);
      await writer.abort(err).catch(() => {});
    });

    return sseResponse(readable);
  } catch (err) {
    console.error("[chat-stream]", err);
    return errorResponse(err instanceof Error ? err.message : "Internal error");
  }
});
