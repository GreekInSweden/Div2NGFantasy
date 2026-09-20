import Link from "next/link";
import { notFound } from "next/navigation";
import { supabase } from "@/lib/supabaseClient";
import { CardRow } from "@/lib/types";
import CardGrid from "@/components/CardGrid";

export const dynamic = "force-dynamic";
export const revalidate = 0;

async function getSetWithCards(categorySlug: string, setSlug: string) {
  const { data: set, error: setError } = await supabase
    .from("sets")
    .select("id, slug, name, category_name, category_slug")
    .eq("category_slug", categorySlug)
    .eq("slug", setSlug)
    .eq("is_visible", true)
    .single();

  if (setError || !set) return null;

  const { data: cards, error: cardsError } = await supabase
    .from("cards")
    .select("id, set_id, number, name, rarity, image_url, pokemon_type, card_variants(id, card_id, variant, price_sek, stock)")
    .eq("set_id", set.id)
    .order("number", { ascending: true });

  if (cardsError || !cards) return { set, cards: [] as CardRow[] };

  const normalized: CardRow[] = cards.map((c: any) => ({
    id: c.id,
    set_id: c.set_id,
    number: c.number,
    name: c.name,
    rarity: c.rarity,
    image_url: c.image_url,
    pokemon_type: c.pokemon_type ?? null,
    variants: c.card_variants ?? [],
  }));

  return { set, cards: normalized };
}

export default async function SetPage({
  params,
}: {
  params: { category: string; setSlug: string };
}) {
  const result = await getSetWithCards(params.category, params.setSlug);
  if (!result) notFound();
  const { set, cards } = result;

  return (
    <div className="max-w-6xl mx-auto px-4 py-14">
      <div className="text-sm text-mute font-mono mb-2">
        <Link href="/" className="hover:text-gold">
          Kategorier
        </Link>{" "}
        /{" "}
        <Link href={`/${params.category}`} className="hover:text-gold">
          {set.category_name}
        </Link>{" "}
        / {set.name}
      </div>
      <h1 className="font-display text-4xl font-bold text-paper mb-2">
        {set.name}
      </h1>
      <p className="text-mute mb-10">
        {cards.length} kort totalt. Gråa kort saknas i lager just nu.
      </p>

      {cards.length === 0 ? (
        <div className="border border-line rounded-md p-8 text-mute max-w-xl">
          Inga kort upplagda för det här setet än.
        </div>
      ) : (
        <CardGrid
          cards={cards}
          setSlug={set.slug}
          setName={set.name}
        />
      )}
    </div>
  );
}
