import { createServerSupabase } from "@/lib/supabase/server";
import { Rarity, Variant } from "@/lib/types";
import { baseVariantByRarity, reverseHoloEligibleRarities } from "@/lib/rarity";
import MasterSetChecklist from "@/components/admin/MasterSetChecklist";

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
  image_url: string | null;
  card_variants: VariantRow[];
}

interface SetOption {
  id: string;
  slug: string;
  name: string;
  category_name: string;
}

export default async function MasterSetPage({
  searchParams,
}: {
  searchParams: { set?: string };
}) {
  const supabase = createServerSupabase();

  const { data: setsData } = await supabase
    .from("sets")
    .select("id, slug, name, category_name")
    .order("category_name")
    .order("name");
  const sets = (setsData as SetOption[]) ?? [];

  // Default to Pitch Black for the first test run if nothing picked yet.
  const selectedSlug =
    searchParams.set ?? (sets.some((s) => s.slug === "pitch-black") ? "pitch-black" : sets[0]?.slug);
  const selectedSet = sets.find((s) => s.slug === selectedSlug) ?? null;

  let cards: CardRow[] = [];
  let owned: { card_id: string; variant: Variant }[] = [];

  if (selectedSet) {
    const { data: cardsData } = await supabase
      .from("cards")
      .select("id, number, name, rarity, image_url, card_variants(variant, price_sek, stock)")
      .eq("set_id", selectedSet.id)
      .order("number");
    cards = (cardsData as unknown as CardRow[]) ?? [];

    if (cards.length > 0) {
      const { data: ownedData } = await supabase
        .from("master_set_progress")
        .select("card_id, variant")
        .in("card_id", cards.map((c) => c.id));
      owned = (ownedData as { card_id: string; variant: Variant }[]) ?? [];
    }
  }

  // Work out, per card, which variants actually count toward each tier —
  // driven by rarity, not just "does a row happen to exist": a Rare-tier
  // card's base print IS the holo row (it never got a plain normal print),
  // while everything from Double Rare up is single-print with no reverse
  // holo, regardless of any stray rows a bulk seed may have left behind.
  const checklistCards = cards.map((c) => {
    const hasVariant = (v: Variant) => c.card_variants.some((cv) => cv.variant === v);
    const baseVariant = baseVariantByRarity[c.rarity];
    const reverseEligible = reverseHoloEligibleRarities.includes(c.rarity);

    const masterVariants: Variant[] = hasVariant(baseVariant) ? [baseVariant] : [];

    const grandMasterVariants: Variant[] = [...masterVariants];
    if (reverseEligible && hasVariant("reverse_holo")) grandMasterVariants.push("reverse_holo");

    const ownedVariants = owned
      .filter((o) => o.card_id === c.id)
      .map((o) => o.variant);

    return {
      id: c.id,
      number: c.number,
      name: c.name,
      rarity: c.rarity,
      imageUrl: c.image_url,
      masterVariants,
      grandMasterVariants,
      ownedVariants,
    };
  });

  const masterTotal = checklistCards.reduce((n, c) => n + c.masterVariants.length, 0);
  const masterOwned = checklistCards.reduce(
    (n, c) => n + c.masterVariants.filter((v) => c.ownedVariants.includes(v)).length,
    0
  );
  const grandTotal = checklistCards.reduce((n, c) => n + c.grandMasterVariants.length, 0);
  const grandOwned = checklistCards.reduce(
    (n, c) => n + c.grandMasterVariants.filter((v) => c.ownedVariants.includes(v)).length,
    0
  );

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Master Set
      </h1>
      <p className="text-mute mb-8">
        Privat checklista för att bygga ett eget master set / grand master
        set, kort för kort. Helt separat från butikens lager — att kryssa i
        ett kort här säljer det inte, och att sälja slut ett kort i butiken
        avkryssar det inte härifrån.
      </p>

      <div className="flex flex-wrap gap-2 mb-8">
        {sets.map((s) => (
          <a
            key={s.id}
            href={`/admin/masterset?set=${s.slug}`}
            className={`focus-ring text-xs rounded-sm border px-3 py-1.5 ${
              s.slug === selectedSlug
                ? "border-gold text-gold bg-gold/10"
                : "border-line text-mute hover:border-mute"
            }`}
          >
            {s.name}
          </a>
        ))}
      </div>

      {!selectedSet ? (
        <p className="text-mute">Inga set upplagda ännu.</p>
      ) : (
        <MasterSetChecklist
          setName={selectedSet.name}
          cards={checklistCards}
          masterProgress={{ owned: masterOwned, total: masterTotal }}
          grandMasterProgress={{ owned: grandOwned, total: grandTotal }}
        />
      )}
    </div>
  );
}
