import Link from "next/link";
import { createServerSupabase } from "@/lib/supabase/server";
import { Variant } from "@/lib/types";

export const dynamic = "force-dynamic";

interface VariantRow {
  variant: Variant;
  stock: number;
  price_sek: number;
  cards: {
    set_id: string;
    sets: {
      slug: string;
      name: string;
      category_name: string;
    } | null;
  } | null;
}

interface SetSummary {
  setId: string;
  setSlug: string;
  setName: string;
  categoryName: string;
  cardsInStock: number;
  unitsInStock: number;
  holoUnitsInStock: number;
  reverseHoloUnitsInStock: number;
  valueSek: number;
}

export default async function LagervardePage() {
  const supabase = createServerSupabase();

  const { data, error } = await supabase
    .from("card_variants")
    .select("variant, stock, price_sek, cards(set_id, sets(slug, name, category_name))");

  const variants = (data as unknown as VariantRow[]) ?? [];

  const bySet = new Map<string, SetSummary>();
  let grandTotalValue = 0;
  let grandTotalUnits = 0;
  let grandTotalCards = 0;
  let grandTotalHoloUnits = 0;
  let grandTotalHoloCards = 0;
  let grandTotalReverseHoloUnits = 0;
  let grandTotalReverseHoloCards = 0;

  for (const v of variants) {
    if (!v.cards || !v.cards.sets || v.stock <= 0) continue;
    const setId = v.cards.set_id;
    const existing = bySet.get(setId);
    const lineValue = v.stock * v.price_sek;
    const holoUnits = v.variant === "holo" ? v.stock : 0;
    const reverseHoloUnits = v.variant === "reverse_holo" ? v.stock : 0;

    if (existing) {
      existing.cardsInStock += 1;
      existing.unitsInStock += v.stock;
      existing.holoUnitsInStock += holoUnits;
      existing.reverseHoloUnitsInStock += reverseHoloUnits;
      existing.valueSek += lineValue;
    } else {
      bySet.set(setId, {
        setId,
        setSlug: v.cards.sets.slug,
        setName: v.cards.sets.name,
        categoryName: v.cards.sets.category_name,
        cardsInStock: 1,
        unitsInStock: v.stock,
        holoUnitsInStock: holoUnits,
        reverseHoloUnitsInStock: reverseHoloUnits,
        valueSek: lineValue,
      });
    }

    grandTotalValue += lineValue;
    grandTotalUnits += v.stock;
    grandTotalCards += 1;
    if (v.variant === "holo") {
      grandTotalHoloUnits += v.stock;
      grandTotalHoloCards += 1;
    }
    if (v.variant === "reverse_holo") {
      grandTotalReverseHoloUnits += v.stock;
      grandTotalReverseHoloCards += 1;
    }
  }

  const setSummaries = Array.from(bySet.values()).sort(
    (a, b) => b.valueSek - a.valueSek
  );

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Lagervärde
      </h1>
      <p className="text-mute mb-8">
        Vad ni skulle få in om allt som just nu finns i lager såldes till
        satta priser. Kort med 0 i lager räknas inte med.
      </p>

      {error ? (
        <p className="text-red-400 text-sm">Kunde inte hämta lagerdata.</p>
      ) : setSummaries.length === 0 ? (
        <p className="text-mute">Inget i lager just nu.</p>
      ) : (
        <>
          <div className="border border-gold rounded-md p-6 bg-gold/5 mb-8">
            <div className="text-sm text-mute mb-1">Totalt lagervärde</div>
            <div className="font-mono text-4xl font-bold text-gold mb-4">
              {grandTotalValue.toLocaleString("sv-SE")} kr
            </div>
            <div className="text-sm text-mute font-mono">
              {grandTotalUnits.toLocaleString("sv-SE")} kort i lager, fördelat
              på {grandTotalCards} olika kort/varianter
            </div>
            <div className="text-sm text-mute font-mono mt-1">
              Varav <span className="text-paper">{grandTotalHoloUnits.toLocaleString("sv-SE")} holo-kort</span> ({grandTotalHoloCards} olika holo-varianter)
            </div>
            {grandTotalReverseHoloUnits > 0 && (
              <div className="text-sm text-mute font-mono mt-1">
                Varav <span className="text-paper">{grandTotalReverseHoloUnits.toLocaleString("sv-SE")} reverse holo-kort</span> ({grandTotalReverseHoloCards} olika reverse holo-varianter)
              </div>
            )}
          </div>

          <div className="border border-line rounded-md divide-y divide-line">
            {setSummaries.map((s) => (
              <Link
                key={s.setId}
                href={`/admin/${s.setSlug}`}
                className="flex items-center justify-between p-4 hover:bg-panelLight transition-colors"
              >
                <div>
                  <div className="text-xs text-mute font-mono">
                    {s.categoryName}
                  </div>
                  <div className="font-display font-medium text-paper">
                    {s.setName}
                  </div>
                  <div className="text-xs text-mute font-mono mt-0.5">
                    {s.unitsInStock} kort i lager · {s.cardsInStock} olika
                    kort/varianter
                    {s.holoUnitsInStock > 0 && (
                      <> · {s.holoUnitsInStock} holo</>
                    )}
                    {s.reverseHoloUnitsInStock > 0 && (
                      <> · {s.reverseHoloUnitsInStock} rev. holo</>
                    )}
                  </div>
                </div>
                <div className="font-mono text-lg text-gold font-semibold shrink-0">
                  {s.valueSek.toLocaleString("sv-SE")} kr
                </div>
              </Link>
            ))}
          </div>
        </>
      )}
    </div>
  );
}
