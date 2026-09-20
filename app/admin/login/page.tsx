"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";

export default function AdminLoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setLoading(true);

    const supabase = createBrowserSupabase();
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      setError("Fel e-post eller lösenord.");
      setLoading(false);
      return;
    }

    router.push("/admin");
    router.refresh();
  }

  return (
    <div className="max-w-sm mx-auto px-4 py-24">
      <h1 className="font-display text-2xl font-bold text-paper mb-6">
        Admin — logga in
      </h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <label className="block">
          <span className="text-sm text-mute mb-1 block">E-post</span>
          <input
            type="email"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="focus-ring w-full bg-ink border border-line rounded-sm px-3 py-2 text-paper"
          />
        </label>
        <label className="block">
          <span className="text-sm text-mute mb-1 block">Lösenord</span>
          <input
            type="password"
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="focus-ring w-full bg-ink border border-line rounded-sm px-3 py-2 text-paper"
          />
        </label>
        {error && <p className="text-sm text-red-400">{error}</p>}
        <button
          type="submit"
          disabled={loading}
          className="focus-ring w-full rounded-sm bg-gold text-ink font-semibold py-3 hover:bg-gold/90 disabled:opacity-50"
        >
          {loading ? "Loggar in…" : "Logga in"}
        </button>
      </form>
    </div>
  );
}
