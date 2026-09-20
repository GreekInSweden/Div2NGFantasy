import Link from "next/link";
import { createServerSupabase } from "@/lib/supabase/server";
import AdminSetGroups from "@/components/admin/AdminSetGroups";

export const dynamic = "force-dynamic";

export default async function AdminHomePage() {
  const supabase = createServerSupabase();
  const { data: sets } = await supabase
    .from("sets")
    .select("id, slug, name, category_name, is_visible")
    .order("category_name")
    .order("name");

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <div className="flex items-center justify-between mb-1">
        <h1 className="font-display text-2xl font-bold text-paper">Lager</h1>
        <Link
          href="/admin/nytt-set"
          className="focus-ring text-sm rounded-sm border border-line px-3 py-1.5 text-paper hover:border-gold"
        >
          + Nytt set
        </Link>
      </div>
      <p className="text-mute mb-8">
        Välj ett set för att fylla i antal. Dolda set syns bara här, aldrig
        i butiken. Klicka en kategorirubrik för att fälla ihop den.
      </p>

      {!sets || sets.length === 0 ? (
        <p className="text-mute">Inga set upplagda ännu.</p>
      ) : (
        <AdminSetGroups sets={sets} />
      )}
    </div>
  );
}

