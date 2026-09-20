import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { MEMBER_SESSION_COOKIE, verifyMemberSession } from "@/lib/memberSession";

// Anti-snipe: a bid placed inside this window before the deadline pushes
// the deadline out to "now + this window" again, so a last-second bid
// always leaves everyone else the same amount of time to respond instead
// of ending the auction on the spot.
const SNIPE_WINDOW_MS = 3 * 60 * 1000;

export const dynamic = "force-dynamic";

export async function POST(req: NextRequest) {
  // Bidding requires a member account now — that's what lets every bid
  // show a member number instead of asking for name/e-post/telefon on
  // every single bid. Once logged in, a bid only needs an amount.
  const sessionToken = req.cookies.get(MEMBER_SESSION_COOKIE)?.value;
  const memberId = sessionToken ? await verifyMemberSession(sessionToken) : null;
  if (!memberId) {
    return NextResponse.json(
      { error: "Logga in på ditt medlemskonto för att buda." },
      { status: 401 }
    );
  }

  const body = await req.json();
  const { auctionId, amountSek } = body as {
    auctionId: string;
    amountSek: number;
  };

  if (!auctionId || !amountSek) {
    return NextResponse.json({ error: "Något saknas i budet." }, { status: 400 });
  }

  const { data: auction, error: auctionError } = await supabaseAdmin
    .from("auctions")
    .select("id, starting_price_sek, min_increment_sek, ends_at, status")
    .eq("id", auctionId)
    .single();

  if (auctionError || !auction) {
    return NextResponse.json({ error: "Auktionen hittades inte." }, { status: 404 });
  }
  if (auction.status !== "open" || new Date(auction.ends_at) < new Date()) {
    return NextResponse.json({ error: "Auktionen är avslutad." }, { status: 409 });
  }

  const { data: topBid } = await supabaseAdmin
    .from("bids")
    .select("amount_sek")
    .eq("auction_id", auctionId)
    .order("amount_sek", { ascending: false })
    .limit(1);

  const currentHigh =
    topBid && topBid.length > 0
      ? Number(topBid[0].amount_sek)
      : Number(auction.starting_price_sek) - Number(auction.min_increment_sek);
  const minRequired = currentHigh + Number(auction.min_increment_sek);

  if (amountSek < minRequired) {
    return NextResponse.json(
      { error: `Budet måste vara minst ${minRequired} kr.` },
      { status: 409 }
    );
  }

  const { error: insertError } = await supabaseAdmin.from("bids").insert({
    auction_id: auctionId,
    member_id: memberId,
    amount_sek: amountSek,
  });

  if (insertError) {
    return NextResponse.json({ error: "Kunde inte spara budet." }, { status: 500 });
  }

  // If this bid landed inside the last SNIPE_WINDOW_MS before the deadline,
  // push the deadline out so it always ends at least that far in the future.
  const now = Date.now();
  const currentEndsAt = new Date(auction.ends_at).getTime();
  let newEndsAt: string | null = null;
  if (currentEndsAt - now < SNIPE_WINDOW_MS) {
    newEndsAt = new Date(now + SNIPE_WINDOW_MS).toISOString();
    await supabaseAdmin
      .from("auctions")
      .update({ ends_at: newEndsAt })
      .eq("id", auctionId);
  }

  return NextResponse.json({
    ok: true,
    amountSek,
    extendedEndsAt: newEndsAt,
  });
}
