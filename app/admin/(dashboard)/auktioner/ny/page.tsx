import { createServerSupabase } from "@/lib/supabase/server";
import NewAuctionForm from "@/components/admin/NewAuctionForm";

export const dynamic = "force-dynamic";

export default async function NewAuctionPage() {
  const supabase = createServerSupabase();
  // Only real shop sets — the imported reference catalog (is_visible =
  // false, stock always 0) has nothing sellable in it, so it would just
  // clutter this dropdown with sets no auction could ever start from.
  const { data: sets } = await supabase
    .from("sets")
    .select("id, slug, name")
    .eq("is_visible", true)
    .order("name");

  return (
    <div className="max-w-lg mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Ny auktion
      </h1>
      <p className="text-mute text-sm mb-8">
        Välj vilket kort och vilken variant som ska auktioneras ut.
      </p>
      <NewAuctionForm sets={sets ?? []} />
    </div>
  );
}
