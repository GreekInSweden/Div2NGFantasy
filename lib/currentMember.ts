import { cookies } from "next/headers";
import { MEMBER_SESSION_COOKIE, verifyMemberSession } from "@/lib/memberSession";
import { supabaseAdmin } from "@/lib/supabaseAdmin";

export interface MemberProfile {
  id: string;
  memberNumber: number;
  name: string;
  email: string;
  phone: string | null;
  address: string | null;
  postalCode: string | null;
  city: string | null;
}

// Reads the member session cookie (server-side only) and looks the member
// up with the service-role key — never through RLS, since members aren't
// Supabase Auth users. Returns null if not logged in or the session is
// invalid/expired. Safe to call from Server Components and Route Handlers.
export async function getCurrentMember(): Promise<MemberProfile | null> {
  const token = cookies().get(MEMBER_SESSION_COOKIE)?.value;
  if (!token) return null;

  const memberId = await verifyMemberSession(token);
  if (!memberId) return null;

  const { data } = await supabaseAdmin
    .from("members")
    .select("id, member_number, name, email, phone, address, postal_code, city")
    .eq("id", memberId)
    .single();

  if (!data) return null;

  return {
    id: data.id,
    memberNumber: data.member_number,
    name: data.name,
    email: data.email,
    phone: data.phone,
    address: data.address,
    postalCode: data.postal_code,
    city: data.city,
  };
}
