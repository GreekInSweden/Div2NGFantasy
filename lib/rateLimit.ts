import { supabaseAdmin } from "@/lib/supabaseAdmin";

// A small database-backed rate limiter. It has to live in the database
// (not server memory) because Vercel runs API routes across many
// short-lived serverless instances that don't share memory — an
// in-memory counter would reset on every cold start and never actually
// catch a determined attacker. Every check both records this attempt and
// reports whether the bucket is over its limit for the trailing window.
export async function checkRateLimit(
  bucket: string,
  maxEvents: number,
  windowSeconds: number
): Promise<boolean> {
  const windowStart = new Date(Date.now() - windowSeconds * 1000).toISOString();

  await supabaseAdmin.from("rate_limit_events").insert({ bucket });

  const { count } = await supabaseAdmin
    .from("rate_limit_events")
    .select("id", { count: "exact", head: true })
    .eq("bucket", bucket)
    .gte("created_at", windowStart);

  // Opportunistic cleanup so this table doesn't grow forever — skipping
  // it occasionally (e.g. if this call races another) is harmless.
  await supabaseAdmin
    .from("rate_limit_events")
    .delete()
    .eq("bucket", bucket)
    .lt("created_at", windowStart);

  return (count ?? 0) <= maxEvents;
}

export function getClientIp(req: Request): string {
  const forwarded = req.headers.get("x-forwarded-for");
  if (forwarded) return forwarded.split(",")[0].trim();
  return "unknown";
}
