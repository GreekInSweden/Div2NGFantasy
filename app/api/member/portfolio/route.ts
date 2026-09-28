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
      "card_id, variant, status, quantity, sellable, tradeable, parallel_tier_id, cards(id, number, name, set_id)"
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
  const { cardId, variant, status, quantity, sellable, tradeable, parallelTierId } = body as {
    cardId: string;
    variant: Variant;
    status: "have" | "want";
    quantity?: number;
    sellable?: boolean;
    tradeable?: boolean;
    // Optional — vilken Topps-parallel (t.ex. "Gold Rainbow Foil /50")
    // det gäller. null/saknas = det vanliga/standardkortet, utan parallel.
    // Pokémon-kort har aldrig detta.
    parallelTierId?: string | null;
  };

  if (!cardId || !variant || !status) {
    return NextResponse.json({ error: "Något saknas." }, { status: 400 });
  }

  const normalizedParallelTierId = parallelTierId ?? null;
  const row = {
    member_id: member.id,
    card_id: cardId,
    variant,
    status,
    quantity: quantity && quantity > 0 ? quantity : 1,
    // Only meaningful for "have" rows — whether the member is actually
    // open to selling/trading this specific card, not just tracking it.
    sellable: status === "have" ? !!sellable : false,
    tradeable: status === "have" ? !!tradeable : false,
    parallel_tier_id: normalizedParallelTierId,
  };

  // Postgres treats NULL as distinct from NULL in a unique constraint, so
  // upsert's onConflict can't catch "same card+status, both with no
  // parallel" — it would just insert a second row. When there's no
  // specific parallel, look for an existing row by hand first and update
  // it instead of inserting a duplicate. When a parallel IS specified,
  // the unique constraint (member_cards_parallel.sql) makes a plain
  // upsert safe and simple.
  if (normalizedParallelTierId === null) {
    const { data: existing } = await supabaseAdmin
      .from("member_cards")
      .select("id")
      .eq("member_id", member.id)
      .eq("card_id", cardId)
      .eq("variant", variant)
      .eq("status", status)
      .is("parallel_tier_id", null)
      .maybeSingle();

    const { error } = existing
      ? await supabaseAdmin.from("member_cards").update(row).eq("id", existing.id)
      : await supabaseAdmin.from("member_cards").insert(row);

    if (error) {
      return NextResponse.json({ error: "Kunde inte spara." }, { status: 500 });
    }
    return NextResponse.json({ ok: true });
  }

  const { error } = await supabaseAdmin
    .from("member_cards")
    .upsert(row, { onConflict: "member_id,card_id,variant,status,parallel_tier_id" });

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
  const { cardId, variant, status, parallelTierId } = body as {
    cardId: string;
    variant: Variant;
    status: "have" | "want";
    parallelTierId?: string | null;
  };

  if (!cardId || !variant || !status) {
    return NextResponse.json({ error: "Något saknas." }, { status: 400 });
  }

  let query = supabaseAdmin
    .from("member_cards")
    .delete()
    .eq("member_id", member.id)
    .eq("card_id", cardId)
    .eq("variant", variant)
    .eq("status", status);

  query = parallelTierId ? query.eq("parallel_tier_id", parallelTierId) : query.is("parallel_tier_id", null);

  const { error } = await query;

  if (error) {
    return NextResponse.json({ error: "Kunde inte ta bort." }, { status: 500 });
  }
  return NextResponse.json({ ok: true });
}
