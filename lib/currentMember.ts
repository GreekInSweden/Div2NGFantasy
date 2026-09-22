import { cookies } from "next/headers";
import { MEMBER_SESSION_COOKIE, verifyMemberSession } from "@/lib/memberSession";
import { supabaseAdmin } from "@/lib/supabaseAdmin";

export interface MemberProfile {
  id: string;
  memberNumber: number;
  username: string | null;
  name: string;
  email: string;
  phone: string | null;
  address: string | null;
  postalCode: string | null;
  city: string | null;
  contactMessenger: string | null;
  contactWhatsapp: string | null;
  contactOther: string | null;
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

  const { data, error } = await supabaseAdmin
    .from("members")
    .select(
      "id, member_number, username, name, email, phone, address, postal_code, city, contact_messenger, contact_whatsapp, contact_other"
    )
    .eq("id", memberId)
    .single();

  // A real query failure (e.g. a pending migration) must not look like
  // "not logged in" — that's what causes an endless redirect back to
  // the login page even with a valid session/cookie and correct
  // password. Throwing surfaces the actual error instead of a silent
  // loop.
  if (error && error.code !== "PGRST116") {
    throw new Error(`Kunde inte hämta medlemsprofilen: ${error.message}`);
  }

  if (!data) return null;

  return {
    id: data.id,
    memberNumber: data.member_number,
    username: data.username,
    name: data.name,
    email: data.email,
    phone: data.phone,
    address: data.address,
    postalCode: data.postal_code,
    city: data.city,
    contactMessenger: data.contact_messenger,
    contactWhatsapp: data.contact_whatsapp,
    contactOther: data.contact_other,
  };
}
