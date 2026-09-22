import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";
import { Variant } from "@/lib/types";

export const dynamic = "force-dynamic";

// Reveals contact details for members who have the given card/variant —
// but only after re-checking, server-side, that the requester actually
// has a matching "vill ha" entry for it. That stops someone from just
// calling this for an arbitrary card to fish for other members' contact
// info; it only ever works for a genuine match. Only members who filled
// in at least one contact channel are returned — silence means they
// haven't opted in to being reached yet.
export async function POST(req: NextRequest) {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const body = await req.json();
  const { cardId, variant } = body as { cardId: string; variant: Variant };
  if (!cardId || !variant) {
    return NextResponse.json({ error: "Något saknas." }, { status: 400 });
  }

  const { data: ownWant } = await supabaseAdmin
    .from("member_cards")
    .select("id")
    .eq("member_id", member.id)
    .eq("card_id", cardId)
    .eq("variant", variant)
    .eq("status", "want")
    .maybeSingle();

  if (!ownWant) {
    return NextResponse.json(
      { error: "Du har inte det här kortet i din önskelista." },
      { status: 403 }
    );
  }

  const { data: haves } = await supabaseAdmin
    .from("member_cards")
    .select(
      "member_id, quantity, sellable, tradeable, members(member_number, name, contact_messenger, contact_whatsapp, contact_other)"
    )
    .eq("card_id", cardId)
    .eq("variant", variant)
    .eq("status", "have")
    .or("sellable.eq.true,tradeable.eq.true")
    .neq("member_id", member.id);

  const contacts = (haves ?? [])
    .filter(
      (h: any) =>
        h.members &&
        (h.members.contact_messenger || h.members.contact_whatsapp || h.members.contact_other)
    )
    .map((h: any) => ({
      memberId: h.member_id,
      memberNumber: h.members.member_number,
      name: h.members.name,
      sellable: h.sellable,
      tradeable: h.tradeable,
      contactMessenger: h.members.contact_messenger,
      contactWhatsapp: h.members.contact_whatsapp,
      contactOther: h.members.contact_other,
    }));

  return NextResponse.json({ contacts });
}
