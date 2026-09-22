"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useCart } from "@/lib/CartContext";
import { Member } from "@/lib/types";
import { memberLabel } from "@/lib/memberLabel";

export default function SiteHeader() {
  const { itemCount, subtotalSek } = useCart();
  const [member, setMember] = useState<Member | null | undefined>(undefined);

  useEffect(() => {
    fetch("/api/member/me")
      .then((res) => res.json())
      .then((data) => setMember(data.member ?? null))
      .catch(() => setMember(null));
  }, []);

  return (
    <header className="border-b border-line sticky top-0 z-30 bg-ink/95 backdrop-blur">
      <div className="max-w-6xl mx-auto px-4 h-16 flex items-center justify-between">
        <Link href="/" className="font-display text-xl font-bold tracking-tight text-paper">
          Kortlagret
        </Link>
        <nav className="flex items-center gap-4">
          <Link
            href="/lager"
            className="focus-ring text-sm text-paper hover:text-gold"
          >
            Vårt lager
          </Link>
          <Link
            href="/auktioner"
            className="focus-ring text-sm text-paper hover:text-gold"
          >
            Auktioner
          </Link>
          <Link
            href="/mest-eftertraktade"
            className="focus-ring text-sm text-paper hover:text-gold hidden sm:inline"
          >
            Mest eftertraktade
          </Link>
          {member === undefined ? null : member ? (
            <Link
              href="/konto"
              className="focus-ring text-sm text-paper hover:text-gold"
            >
              {memberLabel(member.memberNumber, member.username)}
            </Link>
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
