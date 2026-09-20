"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";

export default function ToggleSetVisibilityButton({
  setId,
  isVisible,
}: {
  setId: string;
  isVisible: boolean;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);

  async function handleToggle() {
    setLoading(true);
    const supabase = createBrowserSupabase();
    await supabase
      .from("sets")
      .update({ is_visible: !isVisible })
      .eq("id", setId);
    setLoading(false);
    router.refresh();
  }

  return (
    <button
      onClick={handleToggle}
      disabled={loading}
      className={`focus-ring shrink-0 text-xs rounded-sm border px-3 py-1.5 disabled:opacity-50 ${
        isVisible
          ? "border-line text-paper hover:border-gold"
          : "border-amber-500/50 text-amber-400"
      }`}
    >
      {loading ? "…" : isVisible ? "Synlig — dölj" : "Dold — visa"}
    </button>
  );
}
