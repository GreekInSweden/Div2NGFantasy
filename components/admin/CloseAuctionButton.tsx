"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";

export default function CloseAuctionButton({ auctionId }: { auctionId: string }) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);

  async function handleClose() {
    setLoading(true);
    const supabase = createBrowserSupabase();
    await supabase.from("auctions").update({ status: "closed" }).eq("id", auctionId);
    setLoading(false);
    router.refresh();
  }

  return (
    <button
      onClick={handleClose}
      disabled={loading}
      className="focus-ring text-xs rounded-sm border border-line px-3 py-1.5 text-paper hover:border-gold disabled:opacity-50"
    >
      {loading ? "Markerar…" : "Markera som avslutad"}
    </button>
  );
}
