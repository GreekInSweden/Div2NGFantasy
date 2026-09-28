import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";
import { checkRateLimit, getClientIp } from "@/lib/rateLimit";
import { Variant } from "@/lib/types";
import { memberLabel } from "@/lib/memberLabel";

export const dynamic = "force-dynamic";

// Ett enkelt brevlåde-system, inte en chatt -- se member_messages.sql.
// GET: alla meddelanden till/från den inloggade medlemmen, nyast först.
export async function GET() {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const { data, error } = await supabaseAdmin
    .from("member_messages")
    .select(
      "id, from_member_id, to_member_id, card_id, variant, parallel_tier_id, body, front_image_url, back_image_url, created_at, read_at, deleted_by_from, deleted_by_to, " +
        "from_member:members!member_messages_from_member_id_fkey(member_number, username), " +
        "to_member:members!member_messages_to_member_id_fkey(member_number, username), " +
        "cards(number, name, image_url), parallel_tiers(name)"
    )
    .or(`from_member_id.eq.${member.id},to_member_id.eq.${member.id}`)
    .order("created_at", { ascending: false });

  if (error) {
    return NextResponse.json({ error: "Kunde inte hämta meddelanden." }, { status: 500 });
  }

  // Ett meddelande man själv raderat ska inte dyka upp igen i ens egen
  // brevlåda -- men den andra partens kopia påverkas inte här.
  const visible = (data ?? []).filter(
    (m: any) =>
      !(m.from_member_id === member.id && m.deleted_by_from) &&
      !(m.to_member_id === member.id && m.deleted_by_to)
  );

  // Läst-markering görs tyst här -- första gången mottagaren hämtar sin
  // brevlåda räknas allt som redan hämtats som läst. Ingen realtid, bara
  // en enkel "har du sett det" nästa gång sidan laddas.
  const unreadIds = visible
    .filter((m: any) => m.to_member_id === member.id && !m.read_at)
    .map((m: any) => m.id);
  if (unreadIds.length > 0) {
    await supabaseAdmin
      .from("member_messages")
      .update({ read_at: new Date().toISOString() })
      .in("id", unreadIds);
  }

  const messages = visible.map((m: any) => ({
    id: m.id,
    fromMemberId: m.from_member_id,
    toMemberId: m.to_member_id,
    outgoing: m.from_member_id === member.id,
    otherMemberLabel: (() => {
      const other = m.from_member_id === member.id ? m.to_member : m.from_member;
      return other ? memberLabel(other.member_number, other.username) : "Okänd medlem";
    })(),
    cardId: m.card_id,
    cardNumber: m.cards?.number ?? null,
    cardName: m.cards?.name ?? null,
    cardImageUrl: m.cards?.image_url ?? null,
    variant: m.variant,
    parallelTierName: m.parallel_tiers?.name ?? null,
    body: m.body,
    frontImageUrl: m.front_image_url ?? null,
    backImageUrl: m.back_image_url ?? null,
    createdAt: m.created_at,
    wasUnread: unreadIds.includes(m.id),
  }));

  return NextResponse.json({ messages });
}

// POST: skicka ett nytt meddelande. Precis som /reveal går det bara att
// nå i kontexten av en genuin matchning -- kollas här på samma sätt
// (avsändaren måste ha kortet i sin önskelista, mottagaren måste ha det
// till salu/byte), så det här inte blir en fri "skriv till vem som
// helst"-kanal för spam.
export async function POST(req: NextRequest) {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const ip = getClientIp(req);
  const withinLimit = await checkRateLimit(`message:member:${member.id}`, 30, 60 * 60);
  const withinIpLimit = await checkRateLimit(`message:ip:${ip}`, 60, 60 * 60);
  if (!withinLimit || !withinIpLimit) {
    return NextResponse.json(
      { error: "För många meddelanden. Försök igen senare." },
      { status: 429 }
    );
  }

  const body = await req.json();
  const {
    toMemberId,
    cardId,
    variant,
    parallelTierId,
    body: text,
    frontImageUrl,
    backImageUrl,
  } = body as {
    toMemberId: string;
    cardId: string;
    variant: Variant;
    parallelTierId?: string | null;
    body: string;
    frontImageUrl?: string | null;
    backImageUrl?: string | null;
  };

  if (!toMemberId || !cardId || !variant || !text?.trim()) {
    return NextResponse.json({ error: "Något saknas." }, { status: 400 });
  }
  if (toMemberId === member.id) {
    return NextResponse.json({ error: "Du kan inte skicka till dig själv." }, { status: 400 });
  }

  // Bilder måste komma från vår egen uppladdningsroute (och den bucketen
  // specifikt) -- annars skulle fältet kunna missbrukas som en gratis
  // "visa vilken bild-URL som helst"-kanal.
  const imageUrlPrefix = `${process.env.NEXT_PUBLIC_SUPABASE_URL ?? ""}/storage/v1/object/public/member-message-images/`;
  for (const url of [frontImageUrl, backImageUrl]) {
    if (url && !url.startsWith(imageUrlPrefix)) {
      return NextResponse.json({ error: "Ogiltig bild-URL." }, { status: 400 });
    }
  }

  // Genuin matchning krävs i NÅGON riktning -- annars skulle den som
  // fick ett meddelande (säljaren/bytaren) inte kunna svara, eftersom
  // det är den som SÖKER kortet som har det i sin önskelista, inte den
  // som har det. Så: antingen (jag vill ha + mottagaren har till salu/
  // byte) eller (jag har till salu/byte + mottagaren vill ha) -- exakt
  // samma par av rader som /matchningar/reveal redan kollar, bara i
  // valfri riktning.
  async function hasRow(memberId: string, status: "want" | "have", requireSellOrTrade: boolean) {
    let q = supabaseAdmin
      .from("member_cards")
      .select("id")
      .eq("member_id", memberId)
      .eq("card_id", cardId)
      .eq("variant", variant)
      .eq("status", status);
    if (requireSellOrTrade) q = q.or("sellable.eq.true,tradeable.eq.true");
    q = parallelTierId ? q.eq("parallel_tier_id", parallelTierId) : q.is("parallel_tier_id", null);
    const { data } = await q.maybeSingle();
    return !!data;
  }

  const [iWant, theyHave, iHave, theyWant] = await Promise.all([
    hasRow(member.id, "want", false),
    hasRow(toMemberId, "have", true),
    hasRow(member.id, "have", true),
    hasRow(toMemberId, "want", false),
  ]);
  const genuineMatch = (iWant && theyHave) || (iHave && theyWant);
  if (!genuineMatch) {
    return NextResponse.json(
      { error: "Ingen genuin matchning hittades för det här kortet." },
      { status: 403 }
    );
  }

  const { error } = await supabaseAdmin.from("member_messages").insert({
    from_member_id: member.id,
    to_member_id: toMemberId,
    card_id: cardId,
    variant,
    parallel_tier_id: parallelTierId ?? null,
    body: text.trim().slice(0, 2000),
    front_image_url: frontImageUrl ?? null,
    back_image_url: backImageUrl ?? null,
  });

  if (error) {
    return NextResponse.json({ error: "Kunde inte skicka meddelandet." }, { status: 500 });
  }

  return NextResponse.json({ ok: true });
}

// DELETE: ta bort ett meddelande ur EN egen brevlåda. Sätter bara den
// egna sidans flagga -- raden försvinner helt (physical delete) först när
// båda sidor har raderat sin kopia, så motparten inte tappar sin syn på
// konversationen bara för att jag städar min egen inkorg.
export async function DELETE(req: NextRequest) {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const body = await req.json().catch(() => ({}));
  const { id } = body as { id?: string };
  if (!id) {
    return NextResponse.json({ error: "Något saknas." }, { status: 400 });
  }

  const { data: msg, error: fetchError } = await supabaseAdmin
    .from("member_messages")
    .select("id, from_member_id, to_member_id, deleted_by_from, deleted_by_to")
    .eq("id", id)
    .maybeSingle();

  if (fetchError || !msg) {
    return NextResponse.json({ error: "Meddelandet hittades inte." }, { status: 404 });
  }
  if (msg.from_member_id !== member.id && msg.to_member_id !== member.id) {
    return NextResponse.json({ error: "Inte tillåtet." }, { status: 403 });
  }

  const isFrom = msg.from_member_id === member.id;
  const nowDeletedByFrom = isFrom ? true : msg.deleted_by_from;
  const nowDeletedByTo = isFrom ? msg.deleted_by_to : true;

  if (nowDeletedByFrom && nowDeletedByTo) {
    await supabaseAdmin.from("member_messages").delete().eq("id", id);
  } else {
    await supabaseAdmin
      .from("member_messages")
      .update(isFrom ? { deleted_by_from: true } : { deleted_by_to: true })
      .eq("id", id);
  }

  return NextResponse.json({ ok: true });
}
