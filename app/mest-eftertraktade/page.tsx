"use client";

import { useEffect, useState } from "react";
import { Rarity, Variant } from "@/lib/types";
import { rarityAccent, rarityLabel } from "@/lib/rarity";
import { variantLabel } from "@/lib/variant";
import CardZoomImage from "@/components/CardZoomImage";

interface WantedCard {
  cardId: string;
  cardNumber: number;
  cardName: string;
  rarity: Rarity;
  imageUrl: string | null;
  setName: string;
  categoryName: string;
  variant: Variant;
  wantCount: number;
}

export default function MestEftertraktadePage() {
  const [cards, setCards] = useState<WantedCard[] | null>(null);

  useEffect(() => {
    fetch("/api/mest-eftertraktade")
      .then((res) => res.json())
      .then((data) => setCards(data.cards ?? []));
  }, []);

  return (
    <div className="max-w-4xl mx-auto px-4 py-14">
      <h1 className="font-display text-3xl font-bold text-paper mb-2">
        Mest eftertraktade kort
      </h1>
      <p className="text-mute mb-8 max-w-prose">
        De kort flest medlemmar har i sin önskelista just nu. Har du något
        av de här kan det vara värt att lägga upp det i din portfölj —
        andra medlemmar söker det.
      </p>

      {cards === null ? (
        <p className="text-mute">Laddar…</p>
      ) : cards.length === 0 ? (
        <div className="border border-line rounded-md p-8 text-mute max-w-xl">
          Ingen har lagt något i sin önskelista ännu.
        </div>
      ) : (
        <div className="space-y-2">
          {cards.map((c, i) => (
            <div
              key={`${c.cardId}:${c.variant}`}
              className={`border-l-4 ${rarityAccent[c.rarity]} border-y border-r border-line rounded-sm bg-panel p-3 flex items-center gap-3`}
            >
              <span className="font-mono text-mute text-sm w-6 text-right shrink-0">
                {i + 1}
              </span>
              <CardZoomImage
                src={c.imageUrl}
                alt={c.cardName}
                number={c.cardNumber}
                rarity={c.rarity}
                className="w-12 aspect-[3/4] rounded-sm shrink-0"
              />
              <div className="min-w-0 flex-1">
                <div className="font-mono text-xs text-mute">
                  #{String(c.cardNumber).padStart(3, "0")} · {c.setName} ·{" "}
                  {rarityLabel[c.rarity]}
                </div>
                <div className="font-display text-sm font-medium text-paper truncate">
                  {c.cardName}{" "}
                  <span className="text-mute text-xs font-body">
                    ({variantLabel[c.variant]})
                  </span>
                </div>
              </div>
              <div className="text-right shrink-0">
                <div className="font-mono text-gold font-semibold">
                  {c.wantCount}
                </div>
                <div className="text-xs text-mute">
                  {c.wantCount === 1 ? "medlem söker" : "medlemmar söker"}
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
