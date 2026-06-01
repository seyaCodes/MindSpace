// Embeddings via Supabase AI built-in model (gte-small, 384 dims).
// Available in Supabase Edge Runtime ≥ 1.30 with no external API key.

// TypeScript type shim for the runtime-injected global.
declare const Supabase: {
  ai: {
    Session: new (model: string) => {
      run(
        input: string,
        options?: { mean_pool?: boolean; normalize?: boolean },
      ): Promise<{ data: Float32Array }>;
    };
  };
};

let _session: InstanceType<typeof Supabase.ai.Session> | null = null;

export async function generateEmbedding(text: string): Promise<number[]> {
  console.log(`[embedding] generating for text (${text.length} chars)`);

  // Guard: detect missing Supabase.ai before trying to use it.
  if (
    // deno-lint-ignore no-explicit-any
    typeof (globalThis as any).Supabase === "undefined" ||
    // deno-lint-ignore no-explicit-any
    !(globalThis as any).Supabase?.ai?.Session
  ) {
    throw new Error(
      "Supabase.ai.Session is not available in this runtime. " +
        "Ensure the function is deployed to the Supabase platform (not local Docker) " +
        "and the edge runtime version is ≥ 1.30.",
    );
  }

  if (!_session) {
    console.log("[embedding] initialising gte-small session...");
    _session = new Supabase.ai.Session("gte-small");
  }

  // session.run() returns the Float32Array directly — not wrapped in { data }.
  const output = await _session.run(text.slice(0, 4_000), {
    mean_pool: true,
    normalize: true,
  });

  // Log exact runtime shape so we can diagnose "undefined is not iterable".
  // deno-lint-ignore no-explicit-any
  const raw = output as any;
  console.log("[embedding] raw output typeof:", typeof raw);
  console.log("[embedding] raw output is null/undefined:", raw == null);
  if (raw != null) {
    console.log("[embedding] raw output constructor:", raw?.constructor?.name);
    console.log("[embedding] raw output keys:", Object.keys(raw));
    console.log(
      "[embedding] raw.data typeof:",
      typeof raw.data,
      "| value:",
      raw.data,
    );
    console.log(
      "[embedding] Symbol.iterator present:",
      typeof raw[Symbol.iterator] === "function",
    );
  }

  // deno-lint-ignore no-explicit-any
  const embedding = Array.from(output as any);
  console.log(`[embedding] success — ${embedding.length} dims`);

  if (embedding.length === 0) {
    throw new Error("gte-small returned an empty vector");
  }

  return embedding as number[];
}

// Parse a pgvector value as returned by PostgREST.
// Arrives as "[0.1,0.2,…]" string, number[], or null.
export function parseVector(
  v: string | number[] | null | undefined,
): number[] | null {
  if (v === null || v === undefined) return null;
  if (Array.isArray(v)) return v as number[];
  try {
    const parsed = JSON.parse(v as string);
    return Array.isArray(parsed) ? (parsed as number[]) : null;
  } catch {
    return null;
  }
}

export function cosineSimilarity(a: number[], b: number[]): number {
  if (a.length !== b.length) {
    console.warn(
      `[embedding] dimension mismatch in similarity: ${a.length} vs ${b.length}`,
    );
    return 0;
  }
  let dot = 0, normA = 0, normB = 0;
  for (let i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }
  const denom = Math.sqrt(normA) * Math.sqrt(normB);
  return denom === 0 ? 0 : dot / denom;
}

// Running-mean centroid update. sessionCount is the count BEFORE this session.
export function updateCentroid(
  oldCentroid: number[] | null,
  sessionCount: number,
  newVector: number[],
): number[] {
  if (!oldCentroid || sessionCount === 0) return newVector;
  return oldCentroid.map((v, i) =>
    (v * sessionCount + newVector[i]) / (sessionCount + 1)
  );
}

// True if an error message indicates a pgvector dimension mismatch.
export function isDimensionMismatch(msg: string): boolean {
  const lower = msg.toLowerCase();
  return lower.includes("dimension") ||
    (lower.includes("expected") && lower.includes("not"));
}

export const MIGRATION_SQL = `
-- Run this in the Supabase SQL Editor to fix the dimension mismatch:
ALTER TABLE reflections ALTER COLUMN embedding TYPE vector(384);
ALTER TABLE arcs        ALTER COLUMN centroid  TYPE vector(384);
`.trim();
