import { redirect } from "next/navigation";
import { getCurrentMember } from "@/lib/currentMember";
import { createServerSupabase } from "@/lib/supabase/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { Variant, Rarity } from "@/lib/types";
import PortfolioChecklist from "@/components/PortfolioChecklist";
import SetPicker from "@/components/SetPicker";

export const dynamic = "force-dynamic";

interface SetOption {
  id: string;
  slug: string;
  name: string;
  category_name: string;
  product_line?: "pokemon" | "sportkort";
}

interface VariantRow {
  id: string;
  variant: Variant;
}

interface CardRow {
  id: string;
  number: number;
  name: string;
  rarity: Rarity;
  image_url: string | null;
  card_variants: VariantRow[];
}

export default async function PortfolioPage({
  searchParams,
}: {
  searchParams: { set?: string };
}) {
  const member = await getCurrentMember();
  if (!member) {
    redirect("/konto/logga-in?next=/konto/portfolj");
  }

  const supabase = createServerSupabase();

  // Note: no is_visible filter here on purpose — the full historical
  // card catalog is imported with is_visible = false (it's not for sale,
  // just reference data), but members still need to be able to log cards
  // from any of it in their portfolio/wishlist.
  const { data: setsData } = await supabase
    .from("sets")
    .select("id, slug, name, category_name, product_line")
    .order("category_name")
    .order("name");
  const sets = (setsData as SetOption[]) ?? [];

  const selectedSlug = searchParams.set ?? sets[0]?.slug;
  const selectedSet = sets.find((s) => s.slug === selectedSlug) ?? null;

  let cards: CardRow[] = [];
  let ownEntries: {
    card_id: string;
    variant: Variant;
    status: "have" | "want";
    sellable: boolean;
    tradeable: boolean;
  }[] = [];

  if (selectedSet) {
    const { data: cardsData } = await supabase
      .from("cards")
      .select("id, number, name, rarity, image_url, card_variants(id, variant)")
      .eq("set_id", selectedSet.id)
      .order("number");
    cards = (cardsData as unknown as CardRow[]) ?? [];

    // member_cards is only readable by the admin login under RLS — a
    // member isn't a Supabase Auth user — so this has to go through the
    // service-role client, same as the /api/member/* routes, not the
    // anon-cookie client used for the public sets/cards above.
    const { data: entriesData } = await supabaseAdmin
      .from("member_cards")
      .select("card_id, variant, status, sellable, tradeable")
      .eq("member_id", member.id);
    ownEntries = (entriesData as any[]) ?? [];
  }

  return (
    <div className="max-w-4xl mx-auto px-4 py-14">
      <h1 className="font-display text-3xl font-bold text-paper mb-1">
        Min portfölj
      </h1>
      <p className="text-mute mb-8 max-w-prose text-sm">
        Markera kort du äger och söker. Din lista är privat — andra ser
        bara aggregat på{" "}
        <a href="/mest-eftertraktade" className="text-gold hover:underline">
          Mest eftertraktade
        </a>{" "}
        och{" "}
        <a href="/konto/matchningar" className="text-gold hover:underline">
          Mina matchningar
        </a>
        .
      </p>

      <SetPicker sets={sets} selectedSlug={selectedSlug} baseHref="/konto/portfolj" />

      {!selectedSet ? (
        <p className="text-mute">Inga set upplagda ännu.</p>
      ) : (
        <PortfolioChecklist
          setName={selectedSet.name}
          cards={cards}
          initialEntries={ownEntries}
        />
      )}
    </div>
  );
}
