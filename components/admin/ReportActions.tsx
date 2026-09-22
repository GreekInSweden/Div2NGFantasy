"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";

export default function ReportActions({
  reportId,
  reportedMemberId,
  reportedEmail,
}: {
  reportId: string;
  reportedMemberId: string;
  reportedEmail: string;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState<"block" | "dismiss" | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [confirmingBlock, setConfirmingBlock] = useState(false);

  async function handleDismiss() {
    setLoading("dismiss");
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: updateError } = await supabase
      .from("member_reports")
      .update({ status: "resolved" })
      .eq("id", reportId);
    setLoading(null);
    if (updateError) {
      setError(updateError.message);
      return;
    }
    router.refresh();
  }

  async function handleBlockAndDelete() {
    setLoading("block");
    setError(null);
    const supabase = createBrowserSupabase();

    const { error: blockError } = await supabase.from("blocked_emails").insert({
      email: reportedEmail.trim().toLowerCase(),
      reason: "Anmäld och borttagen av admin",
    });
    if (blockError) {
      setLoading(null);
      setError(blockError.message);
      return;
    }

    const { error: deleteError } = await supabase
      .from("members")
      .delete()
      .eq("id", reportedMemberId);
    if (deleteError) {
      setLoading(null);
      setError(deleteError.message);
      return;
    }

    await supabase.from("member_reports").update({ status: "resolved" }).eq("id", reportId);

    setLoading(null);
    router.refresh();
  }

  return (
    <div>
      <div className="flex gap-2 flex-wrap">
        <button
          onClick={handleDismiss}
          disabled={loading !== null}
          className="focus-ring text-xs rounded-sm border border-line px-3 py-1.5 text-paper hover:border-gold disabled:opacity-50"
        >
          {loading === "dismiss" ? "Sparar…" : "Avfärda (inget fel)"}
        </button>
        {!confirmingBlock ? (
          <button
            onClick={() => setConfirmingBlock(true)}
            disabled={loading !== null}
            className="focus-ring text-xs rounded-sm border border-red-400/40 px-3 py-1.5 text-red-400 hover:border-red-400 disabled:opacity-50"
          >
            Blockera & radera medlem
          </button>
        ) : (
          <span className="flex items-center gap-2">
            <span className="text-xs text-red-400">Säker? Går inte att ångra.</span>
            <button
              onClick={handleBlockAndDelete}
              disabled={loading !== null}
              className="focus-ring text-xs rounded-sm bg-red-400 text-ink font-semibold px-3 py-1.5 disabled:opacity-50"
            >
              {loading === "block" ? "Blockerar…" : "Ja, blockera & radera"}
            </button>
            <button
              onClick={() => setConfirmingBlock(false)}
              disabled={loading !== null}
              className="focus-ring text-xs rounded-sm border border-line px-3 py-1.5 text-paper hover:border-gold disabled:opacity-50"
            >
              Avbryt
            </button>
          </span>
        )}
      </div>
      {error && <p className="text-xs text-red-400 mt-2">{error}</p>}
    </div>
  );
}
