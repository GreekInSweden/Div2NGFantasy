import Link from "next/link";
import { supabase } from "@/lib/supabaseClient";

export const dynamic = "force-dynamic";
export const revalidate = 0;

type ProductLine = "pokemon" | "sportkort";

interface CategoryGroup {
  slug: string;
  name: string;
  setCount: number;
  productLine: ProductLine;
}

async function getCategories(): Promise<CategoryGroup[]> {
  const { data, error } = await supabase
    .from("sets")
    .select("category_slug, category_name, product_line")
    .eq("is_visible", true);

  if (error || !data) return [];

  const map = new Map<string, CategoryGroup>();
  for (const row of data as any[]) {
    const existing = map.get(row.category_slug);
    if (existing) {
      existing.setCount += 1;
    } else {
      map.set(row.category_slug, {
        slug: row.category_slug,
        name: row.category_name,
        setCount: 1,
        productLine: (row.product_line as ProductLine) ?? "pokemon",
      });
    }
  }
  return Array.from(map.values());
}

export default async function LagerPage() {
  const categories = await getCategories();
  const pokemonCategories = categories.filter((c) => c.productLine === "pokemon");
  const sportCategories = categories.filter((c) => c.productLine === "sportkort");

  return (
    <div className="max-w-6xl mx-auto px-4 py-14">
      <h1 className="font-display text-4xl font-bold text-paper mb-2">
        Vårt lager
      </h1>
      <p className="text-mute mb-10 max-w-prose">
        Lösa kort ur egen samling, sålda styckvis. Välj vilka du vill ha, vi
        packar och skickar.
      </p>

      {categories.length === 0 ? (
        <div className="border border-line rounded-md p-8 text-mute max-w-xl">
          Inga kategorier upplagda än. Lägg till en rad i tabellen{" "}
          <code className="font-mono text-paper">sets</code> i Supabase för
          att den ska dyka upp här.
        </div>
      ) : (
        <div className="space-y-12">
          {pokemonCategories.length > 0 && (
            <CategorySection
              title="Pokémon"
              accentClass="hover:border-gold"
              titleAccentClass="text-gold"
              groupHoverAccentClass="group-hover:text-gold"
              categories={pokemonCategories}
            />
          )}
          {sportCategories.length > 0 && (
            <CategorySection
              title="Sportkort"
              accentClass="hover:border-sport-pitch"
              titleAccentClass="text-sport-pitch"
              groupHoverAccentClass="group-hover:text-sport-pitch"
              categories={sportCategories}
            />
          )}
        </div>
      )}
    </div>
  );
}

function CategorySection({
  title,
  accentClass,
  titleAccentClass,
  groupHoverAccentClass,
  categories,
}: {
  title: string;
  accentClass: string;
  titleAccentClass: string;
  groupHoverAccentClass: string;
  categories: CategoryGroup[];
}) {
  return (
    <section>
      <h2 className={`font-display text-lg font-semibold mb-4 ${titleAccentClass}`}>
        {title}
      </h2>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {categories.map((cat) => (
          <Link
            key={cat.slug}
            href={`/${cat.slug}`}
            className={`focus-ring group border border-line rounded-md p-6 transition-colors bg-panel ${accentClass}`}
          >
            <div
              className={`font-display text-xl font-semibold text-paper transition-colors ${groupHoverAccentClass}`}
            >
              {cat.name}
            </div>
            <div className="text-sm text-mute mt-1 font-mono">
              {cat.setCount} {cat.setCount === 1 ? "set" : "set"}
            </div>
          </Link>
        ))}
      </div>
    </section>
  );
}
