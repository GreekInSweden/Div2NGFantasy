import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";

export const dynamic = "force-dynamic";

// Separat från GET /api/member/messages, som markerar allt som läst så
// fort det hämtas -- ett nav-badge som pollade den routen skulle råka
// släcka "olästa"-räknaren innan medlemmen ens öppnat sidan. Den här
// routen är read-only och rör aldrig read_at.
export async function GET() {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ unreadCount: 0 });
  }

  const { count } = await supabaseAdmin
    .from("member_messages")
    .select("id", { count: "exact", head: true })
    .eq("to_member_id", member.id)
    .is("read_at", null);

  return NextResponse.json({ unreadCount: count ?? 0 });
}
