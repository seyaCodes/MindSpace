const GROQ_BASE = "https://api.groq.com/openai/v1";

export interface GroqMessage {
  role: "system" | "user" | "assistant";
  content: string;
}

export interface GroqOptions {
  model?: string;
  temperature?: number;
  max_tokens?: number;
}

export class GroqClient {
  private readonly apiKey: string;

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  private headers(): Record<string, string> {
    return {
      Authorization: `Bearer ${this.apiKey}`,
      "Content-Type": "application/json",
    };
  }

  async chat(messages: GroqMessage[], opts: GroqOptions = {}): Promise<string> {
    const res = await fetch(`${GROQ_BASE}/chat/completions`, {
      method: "POST",
      headers: this.headers(),
      body: JSON.stringify({
        model: opts.model ?? "llama-3.1-8b-instant",
        messages,
        temperature: opts.temperature ?? 0.7,
        max_tokens: opts.max_tokens ?? 1024,
        stream: false,
      }),
    });

    if (!res.ok) {
      const body = await res.text();
      throw new Error(`Groq ${res.status}: ${body}`);
    }

    const data = await res.json();
    const content: string = data.choices?.[0]?.message?.content;
    if (!content) throw new Error("Groq returned empty content");
    return content;
  }

  async chatStream(
    messages: GroqMessage[],
    opts: GroqOptions = {},
  ): Promise<ReadableStream<Uint8Array>> {
    const res = await fetch(`${GROQ_BASE}/chat/completions`, {
      method: "POST",
      headers: this.headers(),
      body: JSON.stringify({
        model: opts.model ?? "llama-3.3-70b-versatile",
        messages,
        temperature: opts.temperature ?? 0.75,
        max_tokens: opts.max_tokens ?? 512,
        stream: true,
      }),
    });

    if (!res.ok) {
      const body = await res.text();
      throw new Error(`Groq ${res.status}: ${body}`);
    }

    if (!res.body) throw new Error("Groq returned no body");
    return res.body;
  }
}

export function createGroqClient(): GroqClient {
  const key = Deno.env.get("GROQ_API_KEY");
  if (!key) throw new Error("GROQ_API_KEY secret is not set");
  return new GroqClient(key);
}

// Extracts the delta content from a single SSE line ("data: {...}")
export function parseSseDeltaContent(line: string): string {
  if (!line.startsWith("data: ") || line === "data: [DONE]") return "";
  try {
    const parsed = JSON.parse(line.slice(6));
    return parsed.choices?.[0]?.delta?.content ?? "";
  } catch {
    return "";
  }
}
