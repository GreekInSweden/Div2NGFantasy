"use client";

import { Suspense, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import Link from "next/link";

export default function LoginPage() {
  return (
    <Suspense fallback={<div className="max-w-md mx-auto px-4 py-20 text-mute">Laddar…</div>}>
      <LoginForm />
    </Suspense>
  );
}

function LoginForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const next = searchParams.get("next") || "/konto/portfolj";

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      const res = await fetch("/api/member/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        setError(data.error ?? `Något gick fel (${res.status}).`);
        setSubmitting(false);
        return;
      }
      router.push(next);
      router.refresh();
    } catch {
      setError("Kunde inte nå servern. Kontrollera internetuppkopplingen och försök igen.");
      setSubmitting(false);
    }
  }

  return (
    <div className="max-w-md mx-auto px-4 py-20">
      <h1 className="font-display text-3xl font-bold text-paper mb-8">
        Logga in
      </h1>
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
        <label className="block">
          <span className="text-sm text-mute mb-1 block">Lösenord</span>
          <input
            type="password"
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
          />
        </label>
        {error && <p className="text-sm text-red-400">{error}</p>}
        <button
          type="submit"
          disabled={submitting}
          className="focus-ring w-full rounded-sm bg-gold text-ink font-semibold py-3 disabled:opacity-50"
        >
          {submitting ? "Loggar in…" : "Logga in"}
        </button>
      </form>
      <p className="text-sm text-mute mt-4">
        <Link href="/konto/glomt-losenord" className="text-gold hover:underline">
          Glömt lösenordet?
        </Link>
      </p>
      <p className="text-sm text-mute mt-2">
        Nytt hos oss?{" "}
        <Link href="/konto/registrera" className="text-gold hover:underline">
          Skapa ett konto
        </Link>
      </p>
    </div>
  );
}
