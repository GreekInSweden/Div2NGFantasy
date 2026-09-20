import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";

export const dynamic = "force-dynamic";

export async function GET() {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const { data } = await supabaseAdmin
    .from("orders")
    .select("id, order_number, status, total_sek, created_at")
    .eq("member_id", member.id)
    .order("created_at", { ascending: false });

  return NextResponse.json({ orders: data ?? [] });
}
