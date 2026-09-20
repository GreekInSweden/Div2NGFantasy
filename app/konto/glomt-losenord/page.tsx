"use client";

import { useState } from "react";
import Link from "next/link";

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [done, setDone] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setSubmitting(true);
    await fetch("/api/member/password-reset/request", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email }),
    });
    setSubmitting(false);
    setDone(true);
  }

  return (
    <div className="max-w-md mx-auto px-4 py-20">
      <h1 className="font-display text-3xl font-bold text-paper mb-2">
        Glömt lösenord?
      </h1>

      {done ? (
        <div>
          <p className="text-mute mb-6">
            Om det finns ett konto med den adressen har vi noterat din
            förfrågan. Vi hör av oss med en länk för att välja ett nytt
            lösenord.
          </p>
          <Link
            href="/konto/logga-in"
            className="focus-ring inline-block rounded-sm border border-line px-6 py-3 text-paper hover:border-gold"
          >
            Till inloggningen
          </Link>
        </div>
      ) : (
        <>
          <p className="text-mute mb-8">
            Ange din e-postadress så hör vi av oss med en länk för att
            välja ett nytt lösenord.
          </p>
          <form onSubmit={handleSubmit} className="space-y-4">
            <label className="block">
              <span className="text-sm text-mute mb-1 block">E-post</span>
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
              />
            </label>
            <button
              type="submit"
              disabled={submitting}
              className="focus-ring w-full rounded-sm bg-gold text-ink font-semibold py-3 disabled:opacity-50"
            >
              {submitting ? "Skickar…" : "Skicka"}
            </button>
          </form>
        </>
      )}
    </div>
  );
}
