"use client";

import { useEffect, useMemo, useState } from "react";
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
  parallelTierId: string | null;
  parallelTierName: string | null;
  isAutograph: boolean;
  wantCount: number;
}

function WantedRow({ c, rank }: { c: WantedCard; rank: number }) {
  return (
    <div
      className={`border-l-4 ${rarityAccent[c.rarity]} border-y border-r border-line rounded-sm bg-panel p-3 flex items-center gap-3`}
    >
      <span className="font-mono text-mute text-sm w-6 text-right shrink-0">
        {rank}
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
            ({c.parallelTierName ?? variantLabel[c.variant]})
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
  );
}

function WantedColumn({
  title,
  accentClass,
  cards,
  showAutographFilter = false,
}: {
  title: string;
  accentClass: string;
  cards: WantedCard[];
  showAutographFilter?: boolean;
}) {
  const [autographsOnly, setAutographsOnly] = useState(false);

  const visible = useMemo(
    () => (autographsOnly ? cards.filter((c) => c.isAutograph) : cards),
    [cards, autographsOnly]
  );

  return (
    <div>
      <div className="flex items-center justify-between gap-2 mb-3">
        <h2 className={`text-xs font-semibold uppercase tracking-wide ${accentClass}`}>
          {title}
        </h2>
        {showAutographFilter && (
          <div className="flex gap-1 text-xs">
            <button
              onClick={() => setAutographsOnly(false)}
              className={`focus-ring rounded-sm px-2 py-1 ${
                !autographsOnly
                  ? "bg-panelLight text-paper font-medium"
                  : "text-mute hover:text-paper"
              }`}
            >
              Alla
            </button>
            <button
              onClick={() => setAutographsOnly(true)}
              className={`focus-ring rounded-sm px-2 py-1 ${
                autographsOnly
                  ? "bg-panelLight text-paper font-medium"
                  : "text-mute hover:text-paper"
              }`}
            >
              Autografer
            </button>
          </div>
        )}
      </div>

      {visible.length === 0 ? (
        <div className="border border-line rounded-md p-6 text-mute text-sm">
          {autographsOnly
            ? "Ingen söker en autograf just nu."
            : "Ingen har lagt något i sin önskelista ännu."}
        </div>
      ) : (
        <div className="space-y-2">
          {visible.map((c, i) => (
            <WantedRow
              key={`${c.cardId}:${c.variant}:${c.parallelTierId ?? ""}`}
              c={c}
              rank={i + 1}
            />
          ))}
        </div>
      )}
    </div>
  );
}

export default function MestEftertraktadePage() {
  const [pokemon, setPokemon] = useState<WantedCard[] | null>(null);
  const [sportkort, setSportkort] = useState<WantedCard[] | null>(null);

  useEffect(() => {
    fetch("/api/mest-eftertraktade")
      .then((res) => res.json())
      .then((data) => {
        setPokemon(data.pokemon ?? []);
        setSportkort(data.sportkort ?? []);
      });
  }, []);

  const loading = pokemon === null || sportkort === null;

  return (
    <div className="max-w-6xl mx-auto px-4 py-14">
      <h1 className="font-display text-3xl font-bold text-paper mb-2">
        Mest eftertraktade kort
      </h1>
      <p className="text-mute mb-8 max-w-prose">
        De kort flest medlemmar har i sin önskelista just nu. Har du något
        av de här kan det vara värt att lägga upp det i din portfölj —
        andra medlemmar söker det.
      </p>

      {loading ? (
        <p className="text-mute">Laddar…</p>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <WantedColumn title="Pokémon" accentClass="text-gold" cards={pokemon!} />
          <WantedColumn
            title="Sportkort"
            accentClass="text-sport-pitch"
            cards={sportkort!}
            showAutographFilter
          />
        </div>
      )}
    </div>
  );
}
