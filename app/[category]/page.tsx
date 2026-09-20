import Link from "next/link";
import { notFound } from "next/navigation";
import { supabase } from "@/lib/supabaseClient";

export const dynamic = "force-dynamic";
export const revalidate = 0;

interface SetSummary {
  slug: string;
  name: string;
  categoryName: string;
  cardCount: number;
  inStockCount: number;
}

async function getSetsForCategory(categorySlug: string): Promise<SetSummary[] | null> {
  const { data: sets, error } = await supabase
    .from("sets")
    .select("id, slug, name, category_name")
    .eq("category_slug", categorySlug)
    .eq("is_visible", true);

  if (error || !sets || sets.length === 0) return null;

  const results: SetSummary[] = [];
  for (const s of sets) {
    const { data: cards } = await supabase
      .from("cards")
      .select("id, card_variants(stock)")
      .eq("set_id", s.id);

    const cardCount = cards?.length ?? 0;
    const inStockCount =
      cards?.filter((c: any) =>
        (c.card_variants ?? []).some((v: any) => v.stock > 0)
      ).length ?? 0;

    results.push({
      slug: s.slug,
      name: s.name,
      categoryName: s.category_name,
      cardCount,
      inStockCount,
    });
  }
  return results;
}

export default async function CategoryPage({
  params,
}: {
  params: { category: string };
}) {
  const sets = await getSetsForCategory(params.category);
  if (!sets) notFound();

  return (
    <div className="max-w-6xl mx-auto px-4 py-14">
      <div className="text-sm text-mute font-mono mb-2">
        <Link href="/" className="hover:text-gold">
          Kategorier
        </Link>{" "}
        / {sets[0]?.categoryName}
      </div>
      <h1 className="font-display text-4xl font-bold text-paper mb-10">
        {sets[0]?.categoryName}
      </h1>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {sets.map((s) => (
          <Link
            key={s.slug}
            href={`/${params.category}/${s.slug}`}
            className="focus-ring group border border-line rounded-md p-6 hover:border-gold transition-colors bg-panel"
          >
            <div className="font-display text-xl font-semibold text-paper group-hover:text-gold transition-colors">
              {s.name}
            </div>
            <div className="text-sm text-mute mt-1 font-mono">
              {s.inStockCount} av {s.cardCount} kort i lager
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
