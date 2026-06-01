import { createClient, SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

export function createAdminClient(): SupabaseClient {
  const url = Deno.env.get("SUPABASE_URL");
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !serviceKey) {
    throw new Error("SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set");
  }
  return createClient(url, serviceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}

export function extractBearerToken(req: Request): string {
  const header = req.headers.get("Authorization") ?? "";
  if (!header.startsWith("Bearer ")) {
    throw new Error("Missing or invalid Authorization header");
  }
  return header.slice(7);
}

export async function verifyUserToken(
  admin: SupabaseClient,
  token: string,
): Promise<string> {
  const { data: { user }, error } = await admin.auth.getUser(token);
  if (error || !user) throw new Error("Invalid or expired token");
  return user.id;
}
