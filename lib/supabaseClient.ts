import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL ?? "";
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? "";

// Public client — used in Server Components and the browser for read-only
// catalog data. Row Level Security policies (see supabase/schema.sql)
// restrict this key to reading sets/cards/variants and inserting orders.
//
// The explicit `cache: "no-store"` below forces every request through this
// client to always fetch fresh data from Supabase, bypassing Next.js's
// fetch cache entirely. Without this, stock numbers you just changed in
// admin can appear stale on the storefront for a while after saving.
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  global: {
    fetch: (url: RequestInfo | URL, options?: RequestInit) =>
      fetch(url, { ...options, cache: "no-store" }),
  },
});

