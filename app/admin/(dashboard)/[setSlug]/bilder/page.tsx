import Link from "next/link";
import { notFound } from "next/navigation";
import { createServerSupabase } from "@/lib/supabase/server";
import BulkImageUploader from "@/components/admin/BulkImageUploader";

export const dynamic = "force-dynamic";

export default async function BulkImagesPage({
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

  const { data: cards } = await supabase
    .from("cards")
    .select("id, number, name, image_url")
    .eq("set_id", set.id)
    .order("number", { ascending: true });

  return (
    <div className="max-w-5xl mx-auto px-4 py-12">
      <div className="text-sm text-mute font-mono mb-2">
        <Link href="/admin" className="hover:text-gold">
          Lager
        </Link>{" "}
        /{" "}
        <Link href={`/admin/${set.slug}`} className="hover:text-gold">
          {set.name}
        </Link>{" "}
        / Bilder
      </div>
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Massuppladdning av bilder — {set.name}
      </h1>
      <p className="text-mute mb-8 max-w-prose">
        Välj alla bilder på en gång. Filer vars namn innehåller ett
        kortnummer (t.ex. &quot;004.jpg&quot; eller &quot;IMG_017.jpg&quot;)
        paras ihop automatiskt — resten parar du ihop manuellt genom att
        klicka en bild och sedan rätt kort.
      </p>

      <BulkImageUploader cards={(cards as any) ?? []} />
    </div>
  );
}
