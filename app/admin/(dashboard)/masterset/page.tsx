import { createServerSupabase } from "@/lib/supabase/server";
import { Rarity, Variant, ParallelTier } from "@/lib/types";
import { baseVariantByRarity, reverseHoloEligibleRarities } from "@/lib/rarity";
import MasterSetChecklist from "@/components/admin/MasterSetChecklist";
import SetPicker from "@/components/SetPicker";

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
  product_line?: "pokemon" | "sportkort";
}

export default async function MasterSetPage({
  searchParams,
}: {
  searchParams: { set?: string };
}) {
  const supabase = createServerSupabase();

  const { data: setsData } = await supabase
    .from("sets")
    .select("id, slug, name, category_name, product_line")
    .order("category_name")
    .order("name");
  const sets = (setsData as SetOption[]) ?? [];

  // Default to Pitch Black for the first test run if nothing picked yet.
  const selectedSlug =
    searchParams.set ?? (sets.some((s) => s.slug === "pitch-black") ? "pitch-black" : sets[0]?.slug);
  const selectedSet = sets.find((s) => s.slug === selectedSlug) ?? null;

  let cards: CardRow[] = [];
  let owned: { card_id: string; variant: Variant }[] = [];
  let ownedParallels: { card_id: string; parallel_tier_id: string }[] = [];
  let wanted: { card_id: string; variant: Variant }[] = [];
  let wantedParallels: { card_id: string; parallel_tier_id: string }[] = [];
  let duplicatesForSale: { card_id: string; variant: Variant }[] = [];
  let parallelTiers: ParallelTier[] = [];
  let parallelTiersLoadError: string | null = null;

  // Vilket medlemskonto dubbletter-till-salu ska bokas på -- satt via
  // inställningsrutan högst upp i checklistan (admin_settings-tabellen).
  // Inget konto valt än betyder bara att "Dubblett – till salu"-knappen
  // inte visas förrän ett är valt.
  const { data: sellerSetting } = await supabase
    .from("admin_settings")
    .select("value")
    .eq("key", "duplicate_seller_username")
    .maybeSingle();
  const duplicateSellerUsername = (sellerSetting?.value as string | null) ?? null;

  let duplicateSellerMemberId: string | null = null;
  if (duplicateSellerUsername) {
    const { data: sellerMember } = await supabase
      .from("members")
      .select("id")
      .ilike("username", duplicateSellerUsername)
      .maybeSingle();
    duplicateSellerMemberId = (sellerMember?.id as string | undefined) ?? null;
  }

  if (selectedSet) {
    const { data: cardsData } = await supabase
      .from("cards")
      .select("id, number, name, rarity, image_url, card_variants(variant, price_sek, stock)")
      .eq("set_id", selectedSet.id)
      .order("number");
    cards = (cardsData as unknown as CardRow[]) ?? [];

    const { data: parallelTiersData, error: parallelTiersError } = await supabase
      .from("parallel_tiers")
      .select("id, set_id, name, channel, print_run, sort_order, image_url")
      .eq("set_id", selectedSet.id)
      .order("sort_order");
    if (parallelTiersError) {
      // Tidigare hände det här helt tyst (parallelTiers blev bara [])
      // om t.ex. en kolumn som image_url saknades -- hela
      // Parallels-sektionen försvann då spårlöst utan förklaring. Nu
      // syns felet i UI:t istället (se sidans return-block nedan).
      parallelTiersLoadError = parallelTiersError.message;
    }
    parallelTiers = (parallelTiersData as ParallelTier[]) ?? [];

    if (cards.length > 0) {
      const { data: ownedData } = await supabase
        .from("master_set_progress")
        .select("card_id, variant, parallel_tier_id")
        .in("card_id", cards.map((c) => c.id));
      const allProgressRows =
        (ownedData as { card_id: string; variant: Variant; parallel_tier_id: string | null }[]) ?? [];
      // Kravsatt master-progress (parallel_tier_id null) och den valfria
      // parallel-bonusloggen (parallel_tier_id satt) delar samma tabell
      // men hålls isär från varandra härifrån och nedåt.
      owned = allProgressRows
        .filter((r) => r.parallel_tier_id === null)
        .map((r) => ({ card_id: r.card_id, variant: r.variant }));
      ownedParallels = allProgressRows
        .filter((r) => r.parallel_tier_id !== null)
        .map((r) => ({ card_id: r.card_id, parallel_tier_id: r.parallel_tier_id as string }));

      const { data: wantedData } = await supabase
        .from("master_set_wants")
        .select("card_id, variant, parallel_tier_id")
        .in("card_id", cards.map((c) => c.id));
      const allWantedRows =
        (wantedData as { card_id: string; variant: Variant; parallel_tier_id: string | null }[]) ?? [];
      wanted = allWantedRows
        .filter((r) => r.parallel_tier_id === null)
        .map((r) => ({ card_id: r.card_id, variant: r.variant }));
      wantedParallels = allWantedRows
        .filter((r) => r.parallel_tier_id !== null)
        .map((r) => ({ card_id: r.card_id, parallel_tier_id: r.parallel_tier_id as string }));

      if (duplicateSellerMemberId) {
        const { data: duplicatesData } = await supabase
          .from("member_cards")
          .select("card_id, variant, parallel_tier_id")
          .eq("member_id", duplicateSellerMemberId)
          .eq("status", "have")
          .eq("sellable", true)
          .in("card_id", cards.map((c) => c.id));
        duplicatesForSale = (
          (duplicatesData as { card_id: string; variant: Variant; parallel_tier_id: string | null }[]) ?? []
        )
          .filter((r) => r.parallel_tier_id === null)
          .map((r) => ({ card_id: r.card_id, variant: r.variant }));
      }
    }
  }

  // Work out, per card, which variants actually count toward a Master
  // Set — driven by rarity, not just "does a row happen to exist": a
  // Rare-tier card's base print IS the holo row (it never got a plain
  // normal print), while everything from Double Rare up is single-print
  // with no reverse holo, regardless of any stray rows a bulk seed may
  // have left behind.
  //
  // Definitionsnot: en Master Set räknas som ett av varje nummer i
  // setet PLUS reverse holo-varianten för de kort som har en — det är
  // hobbyns egen definition (se t.ex. tcgmartlondon.com/articles/
  // master-sets-vs-grand-master-sets), inte något extra steg ovanpå.
  // "Grand Master Set" (promo-stämplar, olika tryckomgångar osv.) finns
  // inte som spårbar data i det här systemet, så den nivån visas inte
  // här — den här checklistan mäter bara det som faktiskt går att mäta.
  const checklistCards = cards.map((c) => {
    const hasVariant = (v: Variant) => c.card_variants.some((cv) => cv.variant === v);
    const baseVariant = baseVariantByRarity[c.rarity];
    const reverseEligible = reverseHoloEligibleRarities.includes(c.rarity);

    const masterVariants: Variant[] = hasVariant(baseVariant) ? [baseVariant] : [];
    if (reverseEligible && hasVariant("reverse_holo")) masterVariants.push("reverse_holo");

    const ownedVariants = owned
      .filter((o) => o.card_id === c.id)
      .map((o) => o.variant);

    const ownedParallelTierIds = ownedParallels
      .filter((o) => o.card_id === c.id)
      .map((o) => o.parallel_tier_id);

    const wantedVariants = wanted
      .filter((w) => w.card_id === c.id)
      .map((w) => w.variant);

    const duplicateVariants = duplicatesForSale
      .filter((d) => d.card_id === c.id)
      .map((d) => d.variant);

    const wantedParallelTierIds = wantedParallels
      .filter((w) => w.card_id === c.id)
      .map((w) => w.parallel_tier_id);

    return {
      id: c.id,
      number: c.number,
      name: c.name,
      rarity: c.rarity,
      imageUrl: c.image_url,
      masterVariants,
      ownedVariants,
      ownedParallelTierIds,
      wantedVariants,
      wantedParallelTierIds,
      duplicateVariants,
    };
  });

  const masterTotal = checklistCards.reduce((n, c) => n + c.masterVariants.length, 0);
  const masterOwned = checklistCards.reduce(
    (n, c) => n + c.masterVariants.filter((v) => c.ownedVariants.includes(v)).length,
    0
  );

  // Completion status for EVERY set (not just the one currently open), so
  // SetPicker can grönmarkera each finished set and guldmarkera a whole
  // era/kategori (t.ex. "Mega Evolution") once every set inside it —
  // "Pitch Black", "Perfect Order" osv — is itself complete.
  //
  // Both tables are bigger than PostgREST's default 1000-row response
  // cap — the catalogimporten alone is ~19 250 kort — so a plain
  // .select() silently truncates and sets whose cards happen to sort
  // past row 1000 would never show as complete no matter how many
  // cards you check off. Page through with .range() until a page comes
  // back short of the page size.
  async function fetchAllRows<T>(
    table: string,
    columns: string
  ): Promise<T[]> {
    const pageSize = 1000;
    let from = 0;
    const rows: T[] = [];
    for (;;) {
      const { data, error } = await supabase
        .from(table)
        .select(columns)
        .range(from, from + pageSize - 1);
      if (error || !data) break;
      rows.push(...(data as unknown as T[]));
      if (data.length < pageSize) break;
      from += pageSize;
    }
    return rows;
  }

  const allCards = await fetchAllRows<{
    id: string;
    set_id: string;
    rarity: Rarity;
    card_variants: { variant: Variant }[];
  }>("cards", "id, set_id, rarity, card_variants(variant)");

  const allProgress = await fetchAllRows<{
    card_id: string;
    variant: Variant;
    parallel_tier_id: string | null;
  }>("master_set_progress", "card_id, variant, parallel_tier_id");
  // Bara det kravsatta kravet (parallel_tier_id null) räknas mot
  // set-completion — parallel-bonusrader ska inte kunna grönmarkera ett
  // set av misstag.
  const ownedKeys = new Set(
    allProgress.filter((p) => p.parallel_tier_id === null).map((p) => `${p.card_id}:${p.variant}`)
  );

  const setTotals = new Map<string, { total: number; owned: number }>();
  for (const c of allCards) {
    const hasVariant = (v: Variant) => c.card_variants.some((cv) => cv.variant === v);
    const baseVariant = baseVariantByRarity[c.rarity];
    const reverseEligible = reverseHoloEligibleRarities.includes(c.rarity);
    const need: Variant[] = hasVariant(baseVariant) ? [baseVariant] : [];
    if (reverseEligible && hasVariant("reverse_holo")) need.push("reverse_holo");

    const entry = setTotals.get(c.set_id) ?? { total: 0, owned: 0 };
    entry.total += need.length;
    entry.owned += need.filter((v) => ownedKeys.has(`${c.id}:${v}`)).length;
    setTotals.set(c.set_id, entry);
  }

  const completeSetIds = Array.from(setTotals.entries())
    .filter(([, t]) => t.total > 0 && t.owned === t.total)
    .map(([id]) => id);

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Master Set
      </h1>
      <p className="text-mute mb-8">
        Privat checklista för att bygga ett eget master set — ett av varje
        nummer i setet plus reverse holo-varianten för de kort som har en.
        Helt separat från butikens lager — att kryssa i ett kort här
        säljer det inte, och att sälja slut ett kort i butiken avkryssar
        det inte härifrån.
      </p>

      <SetPicker
        sets={sets}
        selectedSlug={selectedSlug}
        baseHref="/admin/masterset"
        completeSetIds={completeSetIds}
      />

      {parallelTiersLoadError && (
        <p className="text-sm text-red-400 border border-red-400/40 rounded-md p-3 mb-6">
          Kunde inte hämta parallels för det här setet, så
          Parallels-sektionen visas inte just nu: {parallelTiersLoadError}.
          Har du kört <code className="font-mono">parallel_tiers_image.sql</code> i
          Supabase SQL Editor?
        </p>
      )}

      {!selectedSet ? (
        <p className="text-mute">Inga set upplagda ännu.</p>
      ) : (
        <MasterSetChecklist
          setName={selectedSet.name}
          cards={checklistCards}
          masterProgress={{ owned: masterOwned, total: masterTotal }}
          parallelTiers={parallelTiers}
          duplicateSellerUsername={duplicateSellerUsername}
          duplicateSellerMemberId={duplicateSellerMemberId}
        />
      )}
    </div>
  );
}
