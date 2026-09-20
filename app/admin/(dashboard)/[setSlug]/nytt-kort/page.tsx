import Link from "next/link";
import { notFound } from "next/navigation";
import { createServerSupabase } from "@/lib/supabase/server";
import NewCardForm from "@/components/admin/NewCardForm";

export const dynamic = "force-dynamic";

export default async function NewCardPage({
  params,
}: {
  params: { setSlug: string };
}) {
  const supabase = createServerSupabase();

  const { data: set } = await supabase
    .from("sets")
    .select("id, slug, name")
    .eq("slug", params.setSlug)
    .single();

  if (!set) notFound();

  const { data: existingCards } = await supabase
    .from("cards")
    .select("number")
    .eq("set_id", set.id)
    .order("number", { ascending: false })
    .limit(1);

  const suggestedNumber = (existingCards?.[0]?.number ?? 0) + 1;

  return (
    <div className="max-w-lg mx-auto px-4 py-12">
      <div className="text-sm text-mute font-mono mb-2">
        <Link href="/admin" className="hover:text-gold">
          Lager
        </Link>{" "}
        /{" "}
        <Link href={`/admin/${set.slug}`} className="hover:text-gold">
          {set.name}
        </Link>{" "}
        / Nytt kort
      </div>
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Nytt kort — {set.name}
      </h1>
      <p className="text-mute text-sm mb-8">
        Bra för lösa bonus- eller promokort som följt med en ETB, blister
        eller tenn-box och inte hör till setets ordinarie numrering.
      </p>
      <NewCardForm setId={set.id} setSlug={set.slug} suggestedNumber={suggestedNumber} />
    </div>
  );
}
