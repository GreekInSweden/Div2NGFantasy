import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";

export const dynamic = "force-dynamic";

// Lists the logged-in member's own "vill ha" cards that at least one
// other member currently has. Deliberately anonymous at this stage —
// just the card and how many other members have it — nobody's identity
// or contact details are returned here. Use
// POST /api/member/matchningar/reveal to actually see who, one card at
// a time, once the member decides they want to reach out.
export async function GET() {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const { data: wants } = await supabaseAdmin
    .from("member_cards")
    .select("card_id, variant, cards(number, name, sets(name))")
    .eq("member_id", member.id)
    .eq("status", "want");

  if (!wants || wants.length === 0) {
    return NextResponse.json({ matches: [] });
  }

  const matches = [];
  for (const w of wants as any[]) {
    // Only count "have" rows the other member actually opted in to
    // selling or trading — someone just cataloguing their own collection
    // shouldn't show up as a match.
    const { data: haves } = await supabaseAdmin
      .from("member_cards")
      .select("sellable, tradeable")
      .eq("card_id", w.card_id)
      .eq("variant", w.variant)
      .eq("status", "have")
      .or("sellable.eq.true,tradeable.eq.true")
      .neq("member_id", member.id);

    const matchCount = haves?.length ?? 0;
    if (matchCount > 0) {
      matches.push({
        cardId: w.card_id,
        cardNumber: w.cards?.number ?? 0,
        cardName: w.cards?.name ?? "Okänt kort",
        setName: w.cards?.sets?.name ?? "",
        variant: w.variant,
        matchCount,
        sellCount: haves!.filter((h: any) => h.sellable).length,
        tradeCount: haves!.filter((h: any) => h.tradeable).length,
      });
    }
  }

  return NextResponse.json({ matches });
}
