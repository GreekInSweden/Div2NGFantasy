"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";

export default function AuctionWinActions({ winId }: { winId: string }) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleMarkPaid() {
    setLoading(true);
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: updateError } = await supabase
      .from("auction_wins")
      .update({ status: "paid" })
      .eq("id", winId);
    setLoading(false);
    if (updateError) {
      setError(updateError.message);
      return;
    }
    router.refresh();
  }

  return (
    <div>
      <button
        onClick={handleMarkPaid}
        disabled={loading}
        className="focus-ring text-xs rounded-sm bg-gold text-ink font-semibold px-3 py-1.5 disabled:opacity-50"
      >
        {loading ? "Markerar…" : "Markera betald"}
      </button>
      {error && <p className="text-xs text-red-400 mt-2">{error}</p>}
    </div>
  );
}
