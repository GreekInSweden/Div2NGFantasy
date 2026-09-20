import { createServerSupabase } from "@/lib/supabase/server";
import NewSetForm from "@/components/admin/NewSetForm";

export const dynamic = "force-dynamic";

export default async function NewSetPage() {
  const supabase = createServerSupabase();
  const { data: sets } = await supabase
    .from("sets")
    .select("category_slug, category_name");

  const categoryMap = new Map<string, string>();
  for (const s of sets ?? []) categoryMap.set(s.category_slug, s.category_name);
  const categories = Array.from(categoryMap, ([slug, name]) => ({ slug, name }));

  return (
    <div className="max-w-lg mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Nytt set
      </h1>
      <p className="text-mute text-sm mb-8">
        Skapa en ny kategori och/eller ett nytt set — bra för t.ex. lösa
        bonus- och promokort som inte hör till något huvudsets numrering.
      </p>
      <NewSetForm existingCategories={categories} />
    </div>
  );
}
