"use client";

import { useMemo, useState } from "react";
import { Rarity, Variant } from "@/lib/types";
import { rarityAccent, rarityLabel } from "@/lib/rarity";
import { variantLabel } from "@/lib/variant";
import CardZoomImage from "@/components/CardZoomImage";

interface VariantRow {
  id: string;
  variant: Variant;
}

interface CardRow {
  id: string;
  number: number;
  name: string;
  rarity: Rarity;
  image_url: string | null;
  card_variants: VariantRow[];
}

type Status = "have" | "want";
type EntryKey = string; // `${cardId}:${variant}:${status}`
type IntentKey = string; // `${cardId}:${variant}`

function key(cardId: string, variant: Variant, status: Status): EntryKey {
  return `${cardId}:${variant}:${status}`;
}

function intentKey(cardId: string, variant: Variant): IntentKey {
  return `${cardId}:${variant}`;
}

interface Intent {
  sellable: boolean;
  tradeable: boolean;
}

export default function PortfolioChecklist({
  setName,
  cards,
  initialEntries,
}: {
  setName: string;
  cards: CardRow[];
  initialEntries: {
    card_id: string;
    variant: Variant;
    status: Status;
    sellable?: boolean;
    tradeable?: boolean;
  }[];
}) {
  const [entries, setEntries] = useState<Set<EntryKey>>(
    () => new Set(initialEntries.map((e) => key(e.card_id, e.variant, e.status)))
  );
  const [intents, setIntents] = useState<Map<IntentKey, Intent>>(
    () =>
      new Map(
        initialEntries
          .filter((e) => e.status === "have")
          .map((e) => [
            intentKey(e.card_id, e.variant),
            { sellable: !!e.sellable, tradeable: !!e.tradeable },
          ])
      )
  );
  const [pending, setPending] = useState<Set<EntryKey>>(new Set());
  const [query, setQuery] = useState("");

  const filteredCards = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return cards;
    return cards.filter(
      (c) =>
        c.name.toLowerCase().includes(q) ||
        String(c.number).padStart(3, "0").includes(q)
    );
  }, [cards, query]);

  const haveCount = Array.from(entries).filter((k) => k.endsWith(":have")).length;
  const wantCount = Array.from(entries).filter((k) => k.endsWith(":want")).length;

  async function toggle(cardId: string, variant: Variant, status: Status) {
    const k = key(cardId, variant, status);
    const isActive = entries.has(k);
    setPending((p) => new Set(p).add(k));

    if (isActive) {
      await fetch("/api/member/portfolio", {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ cardId, variant, status }),
      });
      setEntries((e) => {
        const next = new Set(e);
        next.delete(k);
        return next;
      });
      if (status === "have") {
        setIntents((m) => {
          const next = new Map(m);
          next.delete(intentKey(cardId, variant));
          return next;
        });
      }
    } else {
      await fetch("/api/member/portfolio", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ cardId, variant, status }),
      });
      setEntries((e) => new Set(e).add(k));
      if (status === "have") {
        setIntents((m) =>
          new Map(m).set(intentKey(cardId, variant), { sellable: false, tradeable: false })
        );
      }
    }

    setPending((p) => {
      const next = new Set(p);
      next.delete(k);
      return next;
    });
  }

  async function toggleIntent(cardId: string, variant: Variant, field: "sellable" | "tradeable") {
    const ik = intentKey(cardId, variant);
    const current = intents.get(ik) ?? { sellable: false, tradeable: false };
    const next = { ...current, [field]: !current[field] };
    setIntents((m) => new Map(m).set(ik, next));
    await fetch("/api/member/portfolio", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ cardId, variant, status: "have", ...next }),
    });
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-4 flex-wrap gap-2">
        <h2 className="font-display text-lg font-semibold text-paper">
          {setName}
        </h2>
        <p className="text-xs text-mute font-mono">
          {haveCount} har · {wantCount} vill ha
        </p>
      </div>

      <p className="text-xs text-mute mb-3">
        Sälja/Byta = öppen för det nu. Annars är kortet bara med i din
        egen översikt.
      </p>

      <input
        type="text"
        placeholder="Sök kort efter namn eller nummer…"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper text-sm mb-4"
      />

      <div className="space-y-2">
        {filteredCards.map((card) => (
          <div
            key={card.id}
            className={`border-l-4 ${rarityAccent[card.rarity]} border-y border-r border-line rounded-sm bg-panel p-3 flex items-center gap-3`}
          >
            <CardZoomImage
              src={card.image_url}
              alt={card.name}
              number={card.number}
              rarity={card.rarity}
              className="w-12 aspect-[3/4] rounded-sm shrink-0"
            />
            <div className="min-w-0 flex-1">
              <div className="font-mono text-xs text-mute">
                #{String(card.number).padStart(3, "0")} · {rarityLabel[card.rarity]}
              </div>
              <div className="font-display text-sm font-medium text-paper truncate">
                {card.name}
              </div>
              <div className="mt-2 flex flex-wrap gap-2">
                {card.card_variants.map((v) => {
                  const hasIt = entries.has(key(card.id, v.variant, "have"));
                  const intent = intents.get(intentKey(card.id, v.variant));
                  return (
                    <div
                      key={v.id}
                      className="flex items-center gap-1 border border-line rounded-sm px-2 py-1 flex-wrap"
                    >
                      <span className="text-xs text-mute mr-1">
                        {variantLabel[v.variant]}
                      </span>
                      <button
                        onClick={() => toggle(card.id, v.variant, "have")}
                        disabled={pending.has(key(card.id, v.variant, "have"))}
                        className={`focus-ring text-xs rounded-sm px-2 py-0.5 disabled:opacity-50 ${
                          hasIt
                            ? "bg-gold text-ink font-semibold"
                            : "border border-line text-mute hover:border-gold"
                        }`}
                      >
                        Har
                      </button>
                      {hasIt && (
                        <>
                          <button
                            onClick={() => toggleIntent(card.id, v.variant, "sellable")}
                            className={`focus-ring text-xs rounded-sm px-2 py-0.5 ${
                              intent?.sellable
                                ? "bg-emerald-500/20 text-emerald-400 font-semibold border border-emerald-500/50"
                                : "border border-line text-mute hover:border-emerald-500/50"
                            }`}
                            title="Öppen för att sälja det här kortet"
                          >
                            Sälja
                          </button>
                          <button
                            onClick={() => toggleIntent(card.id, v.variant, "tradeable")}
                            className={`focus-ring text-xs rounded-sm px-2 py-0.5 ${
                              intent?.tradeable
                                ? "bg-sky-500/20 text-sky-400 font-semibold border border-sky-500/50"
                                : "border border-line text-mute hover:border-sky-500/50"
                            }`}
                            title="Öppen för att byta bort det här kortet"
                          >
                            Byta
                          </button>
                        </>
                      )}
                      <button
                        onClick={() => toggle(card.id, v.variant, "want")}
                        disabled={pending.has(key(card.id, v.variant, "want"))}
                        className={`focus-ring text-xs rounded-sm px-2 py-0.5 disabled:opacity-50 ${
                          entries.has(key(card.id, v.variant, "want"))
                            ? "bg-gold/20 text-gold font-semibold border border-gold"
                            : "border border-line text-mute hover:border-gold"
                        }`}
                      >
                        ★ Vill ha
                      </button>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
