import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";

export const dynamic = "force-dynamic";

export async function GET() {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const { data: bids } = await supabaseAdmin
    .from("bids")
    .select(
      "amount_sek, created_at, auctions(id, status, ends_at, card_variants(variant, cards(number, name)))"
    )
    .eq("member_id", member.id)
    .order("created_at", { ascending: false });

  const { data: wins } = await supabaseAdmin
    .from("auction_wins")
    .select(
      "id, status, amount_sek, claim_deadline, auctions(card_variants(variant, cards(number, name)))"
    )
    .eq("member_id", member.id)
    .order("created_at", { ascending: false });

  return NextResponse.json({ bids: bids ?? [], wins: wins ?? [] });
}
