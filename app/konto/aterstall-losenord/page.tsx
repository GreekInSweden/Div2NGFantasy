"use client";

import { Suspense, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import Link from "next/link";

export default function ResetPasswordPage() {
  return (
    <Suspense fallback={<div className="max-w-md mx-auto px-4 py-20 text-mute">Laddar…</div>}>
      <ResetPasswordForm />
    </Suspense>
  );
}

function ResetPasswordForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const token = searchParams.get("token");

  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    if (password !== confirmPassword) {
      setError("Lösenorden matchar inte.");
      return;
    }
    setSubmitting(true);
    const res = await fetch("/api/member/password-reset/confirm", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token, newPassword: password }),
    });
    const data = await res.json();
    setSubmitting(false);
    if (!res.ok) {
      setError(data.error ?? "Något gick fel.");
      return;
    }
    router.push("/konto");
    router.refresh();
  }

  if (!token) {
    return (
      <div className="max-w-md mx-auto px-4 py-20 text-center">
        <h1 className="font-display text-2xl font-bold text-paper mb-3">
          Länken saknas
        </h1>
        <p className="text-mute mb-6">
          Öppna länken du fick för att återställa lösenordet, eller begär
          en ny.
        </p>
        <Link
          href="/konto/glomt-losenord"
          className="focus-ring inline-block rounded-sm border border-line px-6 py-3 text-paper hover:border-gold"
        >
          Begär ny länk
        </Link>
      </div>
    );
  }

  return (
    <div className="max-w-md mx-auto px-4 py-20">
      <h1 className="font-display text-3xl font-bold text-paper mb-8">
        Välj nytt lösenord
      </h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <label className="block">
          <span className="text-sm text-mute mb-1 block">Nytt lösenord (minst 8 tecken)</span>
          <input
            type="password"
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
          />
        </label>
        <label className="block">
          <span className="text-sm text-mute mb-1 block">Upprepa lösenord</span>
          <input
            type="password"
            required
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
          />
        </label>
        {error && <p className="text-sm text-red-400">{error}</p>}
        <button
          type="submit"
          disabled={submitting}
          className="focus-ring w-full rounded-sm bg-gold text-ink font-semibold py-3 disabled:opacity-50"
        >
          {submitting ? "Sparar…" : "Spara nytt lösenord"}
        </button>
      </form>
    </div>
  );
}
