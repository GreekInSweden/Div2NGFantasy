import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";

export const dynamic = "force-dynamic";
export const revalidate = 0;

// Public aggregate — how many members have starred each card as "vill
// ha", grouped per card+variant. No member identity is ever part of
// this response, just counts, so it's safe to show to anyone without
// logging in.
export async function GET() {
  const { data } = await supabaseAdmin
    .from("member_cards")
    .select("card_id, variant, cards(number, name, rarity, image_url, sets(name, category_name))")
    .eq("status", "want");

  const counts = new Map<
    string,
    {
      cardId: string;
      cardNumber: number;
      cardName: string;
      rarity: string;
      imageUrl: string | null;
      setName: string;
      categoryName: string;
      variant: string;
      wantCount: number;
    }
  >();

  for (const row of (data ?? []) as any[]) {
    const key = `${row.card_id}:${row.variant}`;
    const existing = counts.get(key);
    if (existing) {
      existing.wantCount += 1;
    } else {
      counts.set(key, {
        cardId: row.card_id,
        cardNumber: row.cards?.number ?? 0,
        cardName: row.cards?.name ?? "Okänt kort",
        rarity: row.cards?.rarity ?? "common",
        imageUrl: row.cards?.image_url ?? null,
        setName: row.cards?.sets?.name ?? "",
        categoryName: row.cards?.sets?.category_name ?? "",
        variant: row.variant,
        wantCount: 1,
      });
    }
  }

  const results = Array.from(counts.values())
    .sort((a, b) => b.wantCount - a.wantCount)
    .slice(0, 100);

  return NextResponse.json({ cards: results });
}
