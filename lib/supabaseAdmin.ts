import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL ?? "";
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";

// Service-role client — NEVER import this into a Client Component or expose
// the key to the browser. Only used inside app/api/* route handlers, which
// run on the server, to safely decrement stock and write orders.
export const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
});
