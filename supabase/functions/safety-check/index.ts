import { handleCors, jsonResponse, errorResponse } from "../_shared/cors.ts";
import { createGroqClient } from "../_shared/groq_client.ts";
import type { SafetyCheckResult } from "../_shared/types.ts";

const SYSTEM = `You are a safety classifier for MindSpace, a mental wellness app.
Determine whether the following user message is safe to process.

UNSAFE if the message contains:
- Explicit self-harm methods or instructions
- Requests for dangerous medical/drug dosage advice
- Imminent danger signals (active suicidal plan with means/timeline)
- Hate speech or violent threats toward others

SAFE if the message contains:
- General emotional distress, sadness, or anxiety
- Mental health discussions, even heavy ones
- Existential questions or life struggles
- Relationship issues
- Venting or seeking emotional support

Respond ONLY with valid JSON — no markdown, no prose:
{"safe": true}
or
{"safe": false, "reason": "one-sentence explanation"}`;

Deno.serve(async (req: Request) => {
  const cors = handleCors(req);
  if (cors) return cors;

  try {
    const body = await req.json().catch(() => null);
    const message: unknown = body?.message;

    if (typeof message !== "string" || message.trim() === "") {
      return errorResponse("message field is required and must be a non-empty string", 400);
    }

    const groq = createGroqClient();
    const raw = await groq.chat(
      [
        { role: "system", content: SYSTEM },
        { role: "user", content: message.slice(0, 1000) }, // cap to avoid prompt injection
      ],
      { model: "llama-3.1-8b-instant", temperature: 0.1, max_tokens: 80 },
    );

    let result: SafetyCheckResult;
    try {
      const jsonMatch = raw.match(/\{[\s\S]*\}/);
      result = JSON.parse(jsonMatch?.[0] ?? raw) as SafetyCheckResult;
    } catch {
      // If the LLM returns unparseable output, default to safe so we don't block legitimate users.
      console.warn("[safety-check] unparseable LLM output, defaulting safe:", raw);
      result = { safe: true };
    }

    return jsonResponse(result);
  } catch (err) {
    console.error("[safety-check]", err);
    return errorResponse(err instanceof Error ? err.message : "Internal error");
  }
});
