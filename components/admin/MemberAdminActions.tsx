"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";

async function generateResetToken(): Promise<{ token: string; hash: string }> {
  const bytes = crypto.getRandomValues(new Uint8Array(32));
  const token = Array.from(bytes)
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
  const hashBuffer = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(token));
  const hash = Array.from(new Uint8Array(hashBuffer))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
  return { token, hash };
}

export default function MemberAdminActions({
  memberId,
  isLocked,
}: {
  memberId: string;
  isLocked: boolean;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState<"link" | "unlock" | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [resetLink, setResetLink] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);

  async function handleGenerateLink() {
    setLoading("link");
    setError(null);
    setCopied(false);
    const { token, hash } = await generateResetToken();
    const supabase = createBrowserSupabase();
    const { error: updateError } = await supabase
      .from("members")
      .update({
        password_reset_token_hash: hash,
        password_reset_expires_at: new Date(Date.now() + 60 * 60 * 1000).toISOString(),
        password_reset_requested_at: null,
      })
      .eq("id", memberId);
    setLoading(null);
    if (updateError) {
      setError(updateError.message);
      return;
    }
    setResetLink(`${window.location.origin}/konto/aterstall-losenord?token=${token}`);
    router.refresh();
  }

  async function handleUnlock() {
    setLoading("unlock");
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: updateError } = await supabase
      .from("members")
      .update({ locked_until: null, failed_login_attempts: 0 })
      .eq("id", memberId);
    setLoading(null);
    if (updateError) {
      setError(updateError.message);
      return;
    }
    router.refresh();
  }

  function handleCopy() {
    if (!resetLink) return;
    navigator.clipboard.writeText(resetLink).then(() => setCopied(true));
  }

  return (
    <div className="mt-2">
      <div className="flex gap-2 flex-wrap">
        <button
          onClick={handleGenerateLink}
          disabled={loading !== null}
          className="focus-ring text-xs rounded-sm border border-line px-3 py-1.5 text-paper hover:border-gold disabled:opacity-50"
        >
          {loading === "link" ? "Skapar…" : "Skapa återställningslänk"}
        </button>
        {isLocked && (
          <button
            onClick={handleUnlock}
            disabled={loading !== null}
            className="focus-ring text-xs rounded-sm border border-line px-3 py-1.5 text-paper hover:border-gold disabled:opacity-50"
          >
            {loading === "unlock" ? "Låser upp…" : "Lås upp konto"}
          </button>
        )}
      </div>
      {error && <p className="text-xs text-red-400 mt-2">{error}</p>}
      {resetLink && (
        <div className="mt-2 flex items-center gap-2">
          <input
            readOnly
            value={resetLink}
            onFocus={(e) => e.target.select()}
            className="focus-ring flex-1 bg-ink border border-line rounded-sm px-2 py-1 text-xs text-paper font-mono"
          />
          <button
            onClick={handleCopy}
            className="focus-ring text-xs rounded-sm bg-gold text-ink font-semibold px-2 py-1 shrink-0"
          >
            {copied ? "Kopierad ✓" : "Kopiera"}
          </button>
        </div>
      )}
      {resetLink && (
        <p className="text-xs text-mute mt-1">
          Giltig i 1 timme. Skicka länken till medlemmen själv (t.ex. sms
          eller e-post) — den visas bara här, en gång.
        </p>
      )}
    </div>
  );
}
