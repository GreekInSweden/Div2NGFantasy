"use client";

import { createBrowserClient } from "@supabase/ssr";

// Browser-side Supabase client for the admin area's Client Components
// (login form, stock editor). Shares the same auth cookies as the server
// client via @supabase/ssr, so a login here is immediately visible to
// Server Components and middleware.
export function createBrowserSupabase() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
