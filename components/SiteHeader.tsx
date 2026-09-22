"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter, usePathname } from "next/navigation";
import { useCart } from "@/lib/CartContext";
import { Member } from "@/lib/types";
import { memberLabel } from "@/lib/memberLabel";

export default function SiteHeader() {
  const { itemCount, subtotalSek } = useCart();
  const [member, setMember] = useState<Member | null | undefined>(undefined);
  const [loggingOut, setLoggingOut] = useState(false);
  const pathname = usePathname();
  const router = useRouter();

  // SiteHeader lives in the root layout and never unmounts across
  // client-side navigations (router.push after login/register/logout
  // doesn't remount it) — so an effect with an empty dependency array
  // would only ever check login state once, on the very first page
  // load, and then show that stale state forever even after logging
  // in. Re-checking on every pathname change catches the redirect that
  // follows login/register/logout.
  useEffect(() => {
    fetch("/api/member/me")
      .then((res) => res.json())
      .then((data) => setMember(data.member ?? null))
      .catch(() => setMember(null));
  }, [pathname]);

  async function handleLogout() {
    setLoggingOut(true);
    try {
      await fetch("/api/member/logout", { method: "POST" });
    } finally {
      setLoggingOut(false);
      setMember(null);
      router.push("/lager");
      router.refresh();
    }
  }

  return (
    <header className="border-b border-line sticky top-0 z-30 bg-ink/95 backdrop-blur">
      <div className="max-w-6xl mx-auto px-4 h-16 flex items-center justify-between gap-4">
        <Link href="/" className="font-display text-xl font-bold tracking-tight text-paper shrink-0">
          Kortlagret
        </Link>

        {/* Vänster grupp: sånt man jobbar med som medlem — döljs tills du
            är inloggad, eftersom Min portfölj/Mina matchningar annars
            bara studsar vidare till inloggningen. Mest eftertraktade är
            publik och visas alltid. */}
        <nav className="hidden md:flex items-center gap-4 flex-1">
          {member && (
            <Link
              href="/konto/portfolj"
              className="focus-ring text-sm text-paper hover:text-gold"
            >
              Min portfölj
            </Link>
          )}
          <Link
            href="/mest-eftertraktade"
            className="focus-ring text-sm text-paper hover:text-gold"
          >
            Mest eftertraktade
          </Link>
          {member && (
            <Link
              href="/konto/matchningar"
              className="focus-ring text-sm text-paper hover:text-gold"
            >
              Mina matchningar
            </Link>
          )}
        </nav>

        {/* Höger grupp: auktioner/butik + konto. */}
        <nav className="flex items-center gap-4 shrink-0">
          <Link
            href="/auktioner"
            className="focus-ring text-sm text-paper hover:text-gold"
          >
            Auktioner
          </Link>
          <Link
            href="/lager"
            className="focus-ring text-sm text-paper hover:text-gold"
          >
            Vårt lager
          </Link>
          {member === undefined ? null : member ? (
            <>
              <Link
                href="/konto"
                className="focus-ring text-sm text-paper hover:text-gold"
              >
                {memberLabel(member.memberNumber, member.username)}
              </Link>
              <button
                onClick={handleLogout}
                disabled={loggingOut}
                className="focus-ring text-sm text-mute hover:text-paper disabled:opacity-50"
              >
                {loggingOut ? "Loggar ut…" : "Logga ut"}
              </button>
            </>
          ) : (
            <Link
              href="/konto/logga-in"
              className="focus-ring text-sm text-paper hover:text-gold"
            >
              Logga in
            </Link>
          )}
          <Link
            href="/kassa"
            className="focus-ring flex items-center gap-3 rounded-md border border-line px-4 py-2 hover:border-gold transition-colors"
          >
            <span className="font-mono text-sm text-mute">{itemCount} kort</span>
            <span className="font-mono text-sm font-medium text-gold">
              {subtotalSek} kr
            </span>
          </Link>
        </nav>
      </div>
    </header>
  );
}
