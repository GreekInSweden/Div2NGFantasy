"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";

export default function DeleteAuctionButton({ auctionId }: { auctionId: string }) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleDelete() {
    if (
      !confirm(
        "Radera den här avslutade auktionen permanent, inklusive alla bud? Går inte att ångra."
      )
    ) {
      return;
    }
    setLoading(true);
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: deleteError } = await supabase
      .from("auctions")
      .delete()
      .eq("id", auctionId);

    setLoading(false);
    if (deleteError) {
      setError(deleteError.message);
      return;
    }
    router.refresh();
  }

  return (
    <div>
      <button
        onClick={handleDelete}
        disabled={loading}
        className="focus-ring text-xs rounded-sm border border-line text-mute px-3 py-1.5 hover:border-red-400 hover:text-red-400 disabled:opacity-50"
      >
        {loading ? "Raderar…" : "Radera permanent"}
      </button>
      {error && <p className="text-xs text-red-400 mt-2">{error}</p>}
    </div>
  );
}
