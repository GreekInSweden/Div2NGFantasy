import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";

export const dynamic = "force-dynamic";
export const revalidate = 0;

// Two ways this is used:
//   (no query params) — "does the logged-in member have a pending win?" —
//     used by the storefront to decide whether to show the "you won!"
//     banner at all. Returns null if not logged in or nothing pending.
//   ?id=<win id>       — the claim page itself, once the member has
//     followed the banner's link. Requires the requester to be logged in
//     as that win's member (a claim link is useless to anyone else), and
//     viewing it here is what marks a 'pending' win as 'claimed' — since
//     we already have the member's contact details on file, there's
//     nothing left to fill in.
export async function GET(req: Request) {
  const url = new URL(req.url);
  const id = url.searchParams.get("id");

  const member = await getCurrentMember();

  if (id) {
    const { data, error } = await supabaseAdmin
      .from("auction_wins")
      .select(
        "id, status, member_id, amount_sek, claim_deadline, auctions(front_image_url, back_image_url, card_variants(variant, cards(number, name, rarity)))"
      )
      .eq("id", id)
      .maybeSingle();

    if (error || !data) {
      return NextResponse.json({ win: null });
    }
    if (!member || data.member_id !== member.id) {
      return NextResponse.json({ error: "Logga in för att se den här vinsten." }, { status: 401 });
    }

    if (data.status === "pending" && new Date(data.claim_deadline) >= new Date()) {
      await supabaseAdmin
        .from("auction_wins")
        .update({ status: "claimed", claimed_at: new Date().toISOString() })
        .eq("id", data.id);
      data.status = "claimed";
    }

    const auction = (data as any).auctions;
    const card = auction?.card_variants?.cards;
    return NextResponse.json({
      win: {
        winId: data.id,
        status: data.status,
        amountSek: Number(data.amount_sek),
        claimDeadline: data.claim_deadline,
        cardName: card?.name ?? "Okänt kort",
        cardNumber: card?.number ?? 0,
        variant: auction?.card_variants?.variant ?? "normal",
        rarity: card?.rarity ?? "common",
        imageUrl: auction?.front_image_url ?? null,
        backImageUrl: auction?.back_image_url ?? null,
      },
    });
  }

  if (!member) {
    return NextResponse.json({ win: null });
  }

  const { data } = await supabaseAdmin
    .from("auction_wins")
    .select(
      "id, status, amount_sek, claim_deadline, auctions(front_image_url, back_image_url, card_variants(variant, cards(number, name, rarity)))"
    )
    .eq("member_id", member.id)
    .eq("status", "pending")
    .limit(1)
    .maybeSingle();

  if (!data) {
    return NextResponse.json({ win: null });
  }

  const auction = (data as any).auctions;
  const card = auction?.card_variants?.cards;
  return NextResponse.json({
    win: {
      winId: data.id,
      status: data.status,
      amountSek: Number(data.amount_sek),
      claimDeadline: data.claim_deadline,
      cardName: card?.name ?? "Okänt kort",
      cardNumber: card?.number ?? 0,
      variant: auction?.card_variants?.variant ?? "normal",
      rarity: card?.rarity ?? "common",
      imageUrl: auction?.front_image_url ?? null,
      backImageUrl: auction?.back_image_url ?? null,
    },
  });
}
