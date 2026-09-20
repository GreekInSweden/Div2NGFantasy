"use client";

import { useMemo, useState } from "react";
import { CardRow, Rarity } from "@/lib/types";
import { rarityAccent, rarityLabel } from "@/lib/rarity";
import CardModal from "@/components/CardModal";
import CardImage from "@/components/CardImage";

const rarityOptions: Rarity[] = [
  "common",
  "illustration_rare",
  "ultra_rare",
  "special_illustration_rare",
  "mega_hyper_rare",
  "promo",
  "base",
  "insert",
];

export default function CardGrid({
  cards,
  setSlug,
  setName,
}: {
  cards: CardRow[];
  setSlug: string;
  setName: string;
}) {
  const [activeCard, setActiveCard] = useState<CardRow | null>(null);
  const [query, setQuery] = useState("");
  const [rarityFilter, setRarityFilter] = useState<Rarity | "all">("all");
  const [onlyInStock, setOnlyInStock] = useState(false);

  const filteredCards = useMemo(() => {
    const q = query.trim().toLowerCase();
    return cards.filter((card) => {
      if (q) {
        const matchesQuery =
          card.name.toLowerCase().includes(q) ||
          String(card.number).padStart(3, "0").includes(q);
        if (!matchesQuery) return false;
      }
      if (rarityFilter !== "all" && card.rarity !== rarityFilter) return false;
      if (onlyInStock && !card.variants.some((v) => v.stock > 0)) return false;
      return true;
    });
  }, [cards, query, rarityFilter, onlyInStock]);

  return (
    <>
      <div className="sticky top-16 z-20 bg-ink py-3 mb-6 border-b border-line flex flex-col sm:flex-row gap-3">
        <input
          type="text"
          placeholder="Sök kort efter namn eller nummer…"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          className="focus-ring flex-1 bg-panel border border-line rounded-sm px-3 py-2 text-paper text-sm"
        />
        <select
          value={rarityFilter}
          onChange={(e) => setRarityFilter(e.target.value as Rarity | "all")}
          className="focus-ring bg-panel border border-line rounded-sm px-3 py-2 text-paper text-sm"
        >
          <option value="all">Alla sällsyntheter</option>
          {rarityOptions.map((r) => (
            <option key={r} value={r}>
              {rarityLabel[r]}
            </option>
          ))}
        </select>
        <label className="flex items-center gap-2 text-sm text-paper whitespace-nowrap px-1">
          <input
            type="checkbox"
            checked={onlyInStock}
            onChange={(e) => setOnlyInStock(e.target.checked)}
            className="focus-ring accent-gold w-4 h-4"
          />
          Bara i lager
        </label>
      </div>

      {filteredCards.length === 0 ? (
        <p className="text-mute">Inga kort matchar sökningen.</p>
      ) : (
        <p className="text-xs text-mute font-mono mb-3">
          Visar {filteredCards.length} av {cards.length} kort
        </p>
      )}

      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
        {filteredCards.map((card) => {
          const inStock = card.variants.some((v) => v.stock > 0);
          return (
            <button
              key={card.id}
              disabled={!inStock}
              onClick={() => setActiveCard(card)}
              className={`focus-ring text-left border-l-4 ${rarityAccent[card.rarity]} border-y border-r border-line rounded-sm overflow-hidden transition-colors ${
                inStock
                  ? "bg-panel hover:bg-panelLight cursor-pointer"
                  : "bg-ink/60 opacity-40 cursor-not-allowed grayscale"
              }`}
            >
              <CardImage
                src={card.image_url}
                alt={card.name}
                number={card.number}
                rarity={card.rarity}
                className="w-full aspect-[3/4]"
              />
              <div className="p-3">
                <div className="font-mono text-xs text-mute mb-1">
                  #{String(card.number).padStart(3, "0")}
                </div>
                <div className="font-display text-sm font-medium text-paper leading-snug">
                  {card.name}
                </div>
                <div className="mt-2 text-xs font-mono">
                  {inStock ? (
                    <span className="text-gold">I lager</span>
                  ) : (
                    <span className="text-mute">Slut i lager</span>
                  )}
                </div>
              </div>
            </button>
          );
        })}
      </div>

      {activeCard && (
        <CardModal
          card={activeCard}
          setSlug={setSlug}
          setName={setName}
          onClose={() => setActiveCard(null)}
        />
      )}
    </>
  );
}
