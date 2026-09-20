"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { variantLabel } from "@/lib/variant";
import { Variant } from "@/lib/types";

interface OrderRow {
  id: string;
  order_number: string;
  status: string;
  total_sek: number;
  created_at: string;
}

interface BidRow {
  amount_sek: number;
  created_at: string;
  auctions: {
    id: string;
    status: string;
    ends_at: string;
    card_variants: { variant: Variant; cards: { number: number; name: string } | null } | null;
  } | null;
}

interface WinRow {
  id: string;
  status: string;
  amount_sek: number;
  claim_deadline: string;
  auctions: {
    card_variants: { variant: Variant; cards: { number: number; name: string } | null } | null;
  } | null;
}

const orderStatusLabel: Record<string, string> = {
  pending_payment: "Väntar på Swish",
  paid: "Betald",
  cancelled: "Avbruten",
};

const winStatusLabel: Record<string, string> = {
  pending: "Väntar på betalsidan",
  claimed: "Väntar på Swish",
  paid: "Betald",
  expired: "Utgången",
};

export default function MemberHistory() {
  const [orders, setOrders] = useState<OrderRow[] | null>(null);
  const [bids, setBids] = useState<BidRow[] | null>(null);
  const [wins, setWins] = useState<WinRow[] | null>(null);

  useEffect(() => {
    fetch("/api/member/orders")
      .then((res) => res.json())
      .then((data) => setOrders(data.orders ?? []));
    fetch("/api/member/bids")
      .then((res) => res.json())
      .then((data) => {
        setBids(data.bids ?? []);
        setWins(data.wins ?? []);
      });
  }, []);

  return (
    <div className="space-y-10">
      <section>
        <h2 className="font-display text-lg font-semibold text-paper mb-3">
          Dina vinster
        </h2>
        {wins === null ? (
          <p className="text-mute text-sm">Laddar…</p>
        ) : wins.length === 0 ? (
          <p className="text-mute text-sm">Inga vunna auktioner ännu.</p>
        ) : (
          <div className="border border-line rounded-md divide-y divide-line">
            {wins.map((w) => {
              const card = w.auctions?.card_variants?.cards;
              return (
                <div key={w.id} className="p-4 flex items-center justify-between gap-3">
                  <div>
                    <div className="text-paper font-medium">
                      {card?.name ?? "Okänt kort"}{" "}
                      {w.auctions?.card_variants && (
                        <span className="text-mute text-sm">
                          ({variantLabel[w.auctions.card_variants.variant]})
                        </span>
                      )}
                    </div>
                    <div className="text-xs text-mute">{winStatusLabel[w.status] ?? w.status}</div>
                  </div>
                  <div className="flex items-center gap-3 shrink-0">
                    <span className="font-mono text-gold">{w.amount_sek} kr</span>
                    {(w.status === "pending" || w.status === "claimed") && (
                      <Link
                        href={`/auktioner/vinst?win=${w.id}`}
                        className="focus-ring text-xs rounded-sm border border-gold text-gold px-2 py-1 hover:bg-gold/10"
                      >
                        Betala
                      </Link>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </section>

      <section>
        <h2 className="font-display text-lg font-semibold text-paper mb-3">
          Dina bud
        </h2>
        {bids === null ? (
          <p className="text-mute text-sm">Laddar…</p>
        ) : bids.length === 0 ? (
          <p className="text-mute text-sm">Inga bud lagda ännu.</p>
        ) : (
          <div className="border border-line rounded-md divide-y divide-line">
            {bids.map((b, i) => {
              const card = b.auctions?.card_variants?.cards;
              return (
                <div key={i} className="p-3 flex items-center justify-between text-sm">
                  <span className="text-paper">
                    {card?.name ?? "Okänt kort"}{" "}
                    {b.auctions && (
                      <span className="text-mute">
                        ({b.auctions.status === "open" ? "pågår" : "avslutad"})
                      </span>
                    )}
                  </span>
                  <span className="font-mono text-mute">{b.amount_sek} kr</span>
                </div>
              );
            })}
          </div>
        )}
      </section>

      <section>
        <h2 className="font-display text-lg font-semibold text-paper mb-3">
          Dina beställningar
        </h2>
        {orders === null ? (
          <p className="text-mute text-sm">Laddar…</p>
        ) : orders.length === 0 ? (
          <p className="text-mute text-sm">Inga beställningar ännu.</p>
        ) : (
          <div className="border border-line rounded-md divide-y divide-line">
            {orders.map((o) => (
              <div key={o.id} className="p-3 flex items-center justify-between text-sm">
                <span className="font-mono text-paper">{o.order_number}</span>
                <span className="text-mute">{orderStatusLabel[o.status] ?? o.status}</span>
                <span className="font-mono text-mute">{o.total_sek} kr</span>
              </div>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}
