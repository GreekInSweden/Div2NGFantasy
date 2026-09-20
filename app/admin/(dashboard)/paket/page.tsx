import { createServerSupabase } from "@/lib/supabase/server";
import { Variant, Rarity } from "@/lib/types";
import PackageCompleteness, {
  SetPackageSummary,
} from "@/components/admin/PackageCompleteness";

export const dynamic = "force-dynamic";

interface VariantRow {
  variant: Variant;
  price_sek: number;
  stock: number;
}

interface CardRow {
  id: string;
  number: number;
  name: string;
  rarity: Rarity;
  card_variants: VariantRow[];
}

interface SetRow {
  id: string;
  slug: string;
  name: string;
  category_name: string;
  cards: CardRow[];
}

const VARIANTS: Variant[] = ["normal", "holo", "reverse_holo"];

// These rarities ARE the special print already (full-art, textured,
// gold, etc.) — they never get a separate holo or reverse holo version,
// so they're excluded from those two counts no matter what, even if a
// holo/reverse_holo row happens to exist on one by mistake. They still
// count fully toward the "normal" (vanlig) variant.
const NEVER_HOLO_RARITIES: Rarity[] = [
  "double_rare",
  "illustration_rare",
  "special_illustration_rare",
  "ultra_rare",
  "mega_hyper_rare",
];

export default async function PaketPage() {
  const supabase = createServerSupabase();

  const { data, error } = await supabase
    .from("sets")
    .select(
      "id, slug, name, category_name, cards(id, number, name, rarity, card_variants(variant, price_sek, stock))"
    )
    .order("category_name")
    .order("name");

  const sets = (data as unknown as SetRow[]) ?? [];

  const summaries: SetPackageSummary[] = sets
    .map((set) => {
      const totalCards = set.cards.length;

      const perVariant = VARIANTS.map((variant) => {
        const isHoloType = variant === "holo" || variant === "reverse_holo";
        const eligibleCards = isHoloType
          ? set.cards.filter((c) => !NEVER_HOLO_RARITIES.includes(c.rarity))
          : set.cards;

        // Only count cards that were ever given this variant — a set where
        // only rares get a holo print shouldn't be judged against cards
        // that never had one. Rarities that are already the special print
        // (full-art, gold, etc.) are excluded above regardless of whether
        // a row exists for them.
        const cardsWithVariant = eligibleCards.filter((c) =>
          c.card_variants.some((v) => v.variant === variant)
        );
        const inStock = cardsWithVariant.filter((c) =>
          c.card_variants.some((v) => v.variant === variant && v.stock > 0)
        );
        const missing = cardsWithVariant
          .filter(
            (c) => !c.card_variants.some((v) => v.variant === variant && v.stock > 0)
          )
          .map((c) => ({ number: c.number, name: c.name }))
          .sort((a, b) => a.number - b.number);
        const packagePriceSek = inStock.reduce((sum, c) => {
          const v = c.card_variants.find((vv) => vv.variant === variant);
          return sum + (v?.price_sek ?? 0);
        }, 0);

        return {
          variant,
          definedCount: cardsWithVariant.length,
          inStockCount: inStock.length,
          missing,
          packagePriceSek,
          isComplete:
            cardsWithVariant.length > 0 && inStock.length === cardsWithVariant.length,
        };
      }).filter((v) => v.definedCount > 0);

      return {
        setId: set.id,
        setSlug: set.slug,
        setName: set.name,
        categoryName: set.category_name,
        totalCards,
        variants: perVariant,
      };
    })
    // Only show sets where at least one variant type is actually used.
    .filter((s) => s.variants.length > 0 && s.totalCards > 0);

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Paket
      </h1>
      <p className="text-mute mb-8">
        Hur nära varje set är att kunna säljas komplett som paket — per
        variant (vanlig/holo/reverse holo). Bara varianter som faktiskt
        finns upplagda på minst ett kort i setet räknas med. Illustration
        Rare, Special Illustration Rare, Ultra Rare och Hyper Rare räknas
        aldrig in i holo/reverse holo — de är redan den speciella
        tryckningen.
      </p>

      {error ? (
        <p className="text-red-400 text-sm">Kunde inte hämta setdata.</p>
      ) : summaries.length === 0 ? (
        <p className="text-mute">Inga set med kort ännu.</p>
      ) : (
        <PackageCompleteness sets={summaries} />
      )}
    </div>
  );
}
