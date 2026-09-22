import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";
import { Variant } from "@/lib/types";

export const dynamic = "force-dynamic";

// Returns this member's whole have/want list — used to pre-check boxes
// when they browse a set. A specific set can be requested with
// ?setId=... to keep the response small; otherwise every entry comes
// back (handy for a "my portfolio" overview).
export async function GET(req: NextRequest) {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const setId = req.nextUrl.searchParams.get("setId");

  const { data, error } = await supabaseAdmin
    .from("member_cards")
    .select(
      "card_id, variant, status, quantity, sellable, tradeable, cards(id, number, name, set_id)"
    )
    .eq("member_id", member.id);
  if (error) {
    return NextResponse.json({ error: "Kunde inte hämta din portfölj." }, { status: 500 });
  }

  const filtered = setId
    ? (data ?? []).filter((r: any) => r.cards?.set_id === setId)
    : data ?? [];

  return NextResponse.json({ entries: filtered });
}

export async function POST(req: NextRequest) {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const body = await req.json();
  const { cardId, variant, status, quantity, sellable, tradeable } = body as {
    cardId: string;
    variant: Variant;
    status: "have" | "want";
    quantity?: number;
    sellable?: boolean;
    tradeable?: boolean;
  };

  if (!cardId || !variant || !status) {
    return NextResponse.json({ error: "Något saknas." }, { status: 400 });
  }

  const { error } = await supabaseAdmin.from("member_cards").upsert(
    {
      member_id: member.id,
      card_id: cardId,
      variant,
      status,
      quantity: quantity && quantity > 0 ? quantity : 1,
      // Only meaningful for "have" rows — whether the member is actually
      // open to selling/trading this specific card, not just tracking it.
      sellable: status === "have" ? !!sellable : false,
      tradeable: status === "have" ? !!tradeable : false,
    },
    { onConflict: "member_id,card_id,variant,status" }
  );

  if (error) {
    return NextResponse.json({ error: "Kunde inte spara." }, { status: 500 });
  }
  return NextResponse.json({ ok: true });
}

export async function DELETE(req: NextRequest) {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const body = await req.json();
  const { cardId, variant, status } = body as {
    cardId: string;
    variant: Variant;
    status: "have" | "want";
  };

  if (!cardId || !variant || !status) {
    return NextResponse.json({ error: "Något saknas." }, { status: 400 });
  }

  const { error } = await supabaseAdmin
    .from("member_cards")
    .delete()
    .eq("member_id", member.id)
    .eq("card_id", cardId)
    .eq("variant", variant)
    .eq("status", status);

  if (error) {
    return NextResponse.json({ error: "Kunde inte ta bort." }, { status: 500 });
  }
  return NextResponse.json({ ok: true });
}
