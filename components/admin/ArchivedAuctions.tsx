"use client";

import { useState } from "react";
import { variantLabel } from "@/lib/variant";
import DeleteAuctionButton from "@/components/admin/DeleteAuctionButton";

interface Bid {
  amount_sek: number;
}

interface Win {
  status: string;
  members: { member_number: number; name: string; email: string; phone: string | null } | null;
}

interface AuctionRow {
  id: string;
  starting_price_sek: number;
  reserve_price_sek: number | null;
  ends_at: string;
  status: string;
  card_variants: { variant: string; cards: { number: number; name: string } | null } | null;
  bids: Bid[];
  win: Win | null;
}

export default function ArchivedAuctions({ auctions }: { auctions: AuctionRow[] }) {
  const [expanded, setExpanded] = useState(false);

  if (auctions.length === 0) return null;

  return (
    <div className="mt-8 pt-6 border-t border-line">
      <button
        onClick={() => setExpanded((e) => !e)}
        className="focus-ring text-sm text-mute hover:text-paper flex items-center gap-2"
      >
        <span>{expanded ? "▾" : "▸"}</span>
        Äldre auktioner ({auctions.length}, avslutade för mer än 30 dagar sedan)
      </button>

      {expanded && (
        <div className="space-y-4 mt-4">
          {auctions.map((a) => {
            const card = a.card_variants?.cards;
            const topBid = a.bids[0];
            return (
              <div
                key={a.id}
                className="border border-line rounded-md p-4 bg-panel opacity-80"
              >
                <div className="flex items-start justify-between mb-2 gap-3">
                  <div>
                    <div className="font-mono text-xs text-mute">
                      #{String(card?.number ?? 0).padStart(3, "0")} ·{" "}
                      {a.card_variants?.variant
                        ? variantLabel[a.card_variants.variant as keyof typeof variantLabel]
                        : "Vanligt"}
                    </div>
                    <div className="font-display font-semibold text-paper">
                      {card?.name ?? "Okänt kort"}
                    </div>
                  </div>
                  <span className="text-xs font-mono px-2 py-1 rounded-sm bg-line text-mute shrink-0">
                    Avslutad
                  </span>
                </div>

                <p className="text-xs text-mute mb-3">
                  Utrop: {a.starting_price_sek} kr
                  {a.reserve_price_sek !== null && (
                    <>
                      {" "}
                      · Reservationspris:{" "}
                      <span className="text-paper">{a.reserve_price_sek} kr</span>
                    </>
                  )}
                  {" "}· Slutade: {new Date(a.ends_at).toLocaleString("sv-SE")}
                </p>

                {topBid ? (
                  <p className="text-sm text-paper mb-3">
                    🏆 <span className="font-mono">{topBid.amount_sek} kr</span>
                    {a.win?.members && (
                      <>
                        {" "}
                        — Medlem #{a.win.members.member_number} ({a.win.members.name}) —{" "}
                        {a.win.members.email} · {a.win.members.phone ?? "inget telefonnr"}
                      </>
                    )}
                    {a.win && !a.win.members && (
                      <span className="text-mute">
                        {" "}
                        —{" "}
                        {a.win.status === "expired"
                          ? "hämtades aldrig ut"
                          : "väntar på köparen"}
                      </span>
                    )}
                  </p>
                ) : (
                  <p className="text-sm text-mute mb-3">Inga bud lades.</p>
                )}

                <DeleteAuctionButton auctionId={a.id} />
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
