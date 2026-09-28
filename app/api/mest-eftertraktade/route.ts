import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";

export const dynamic = "force-dynamic";
export const revalidate = 0;

// Public aggregate — how many members have starred each card (i en
// specifik parallel, om relevant) as "vill ha". No member identity is
// ever part of this response, just counts, so it's safe to show to
// anyone without logging in.
export async function GET() {
  const { data } = await supabaseAdmin
    .from("member_cards")
    .select(
      "card_id, variant, parallel_tier_id, cards(number, name, rarity, image_url, sets(name, category_name, product_line, is_autograph)), parallel_tiers(name)"
    )
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
      parallelTierId: string | null;
      parallelTierName: string | null;
      productLine: "pokemon" | "sportkort";
      isAutograph: boolean;
      wantCount: number;
    }
  >();

  for (const row of (data ?? []) as any[]) {
    // Två "vill ha"-rader på SAMMA kort men OLIKA parallel (t.ex. Gold
    // /50 vs Standard) är två olika saker att vara eftertraktad för —
    // annars smälter de ihop till en missvisande gemensam siffra.
    const key = `${row.card_id}:${row.variant}:${row.parallel_tier_id ?? ""}`;
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
        parallelTierId: row.parallel_tier_id ?? null,
        parallelTierName: row.parallel_tiers?.name ?? null,
        productLine: row.cards?.sets?.product_line ?? "pokemon",
        isAutograph: !!row.cards?.sets?.is_autograph,
        wantCount: 1,
      });
    }
  }

  const results = Array.from(counts.values()).sort((a, b) => b.wantCount - a.wantCount);

  // Två separata topplistor (Pokémon / Sportkort) istället för en enda
  // blandad — annars dränks det ena i det andra beroende på vilken
  // hobby som råkar ha flest aktiva medlemmar just nu. 100 vardera.
  const pokemon = results.filter((r) => r.productLine === "pokemon").slice(0, 100);
  const sportkort = results.filter((r) => r.productLine === "sportkort").slice(0, 100);

  return NextResponse.json({ pokemon, sportkort });
}
