"use client";

import { useMemo, useState } from "react";
import { ParallelTier, Rarity, Variant } from "@/lib/types";
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
// "" i parallel-delen = standardkortet, ingen parallel — precis som innan
// den här funktionen fanns. En riktig parallel (Topps-sportkort) har sitt
// parallel_tiers.id där istället.
type EntryKey = string; // `${cardId}:${variant}:${parallelTierId}:${status}`
type IntentKey = string; // `${cardId}:${variant}:${parallelTierId}`

function key(cardId: string, variant: Variant, parallelTierId: string, status: Status): EntryKey {
  return `${cardId}:${variant}:${parallelTierId}:${status}`;
}

function intentKey(cardId: string, variant: Variant, parallelTierId: string): IntentKey {
  return `${cardId}:${variant}:${parallelTierId}`;
}

interface Intent {
  sellable: boolean;
  tradeable: boolean;
}

export default function PortfolioChecklist({
  setName,
  cards,
  initialEntries,
  parallelTiers = [],
}: {
  setName: string;
  cards: CardRow[];
  initialEntries: {
    card_id: string;
    variant: Variant;
    status: Status;
    sellable?: boolean;
    tradeable?: boolean;
    parallel_tier_id?: string | null;
  }[];
  // Bara satt för Topps-set som har egna definierade parallels (se
  // supabase/parallel_tiers.sql) — tom lista för Pokémon och alla andra
  // set, då visas ingen parallel-väljare alls.
  parallelTiers?: ParallelTier[];
}) {
  const [entries, setEntries] = useState<Set<EntryKey>>(
    () =>
      new Set(
        initialEntries.map((e) => key(e.card_id, e.variant, e.parallel_tier_id ?? "", e.status))
      )
  );
  const [intents, setIntents] = useState<Map<IntentKey, Intent>>(
    () =>
      new Map(
        initialEntries
          .filter((e) => e.status === "have")
          .map((e) => [
            intentKey(e.card_id, e.variant, e.parallel_tier_id ?? ""),
            { sellable: !!e.sellable, tradeable: !!e.tradeable },
          ])
      )
  );
  const [pending, setPending] = useState<Set<EntryKey>>(new Set());
  const [query, setQuery] = useState("");
  const [error, setError] = useState<string | null>(null);
  // Vilken parallel som just nu är vald per kort+variant, innan man
  // klickar Har/Vill ha — "" = standardkortet, ingen parallel.
  //
  // VIKTIGT: måste initieras från initialEntries, inte bara tom Map().
  // Annars visar rullgardinen "Standard" igen efter en omladdning även
  // för ett kort som faktiskt sparats med en specifik parallel — då
  // pekar Har/Vill ha-knapparna på fel rad (parallelTierId=""), och ett
  // klick för att "ta bort" en sådan post skapar av misstag en NY,
  // separat standard-rad istället för att ta bort den riktiga (som blir
  // osynlig och kvarstår i databasen, t.ex. fortsätter synas på Mest
  // eftertraktade trots att kortet ser avbockat ut här).
  const [selectedParallel, setSelectedParallel] = useState<Map<string, string>>(() => {
    const map = new Map<string, string>();
    for (const e of initialEntries) {
      if (!e.parallel_tier_id) continue;
      const pk = `${e.card_id}:${e.variant}`;
      // "want" vinner över "have" om kortet av någon anledning har olika
      // parallel på de två (ovanligt, men dropdownen kan bara visa en
      // åt gången) -- det är oftast "vill ha"-sidan man aktivt jobbar med.
      if (e.status === "want" || !map.has(pk)) {
        map.set(pk, e.parallel_tier_id);
      }
    }
    return map;
  });

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

  async function toggle(cardId: string, variant: Variant, parallelTierId: string, status: Status) {
    const k = key(cardId, variant, parallelTierId, status);
    const isActive = entries.has(k);
    setPending((p) => new Set(p).add(k));
    setError(null);

    let ok = false;
    try {
      const res = isActive
        ? await fetch("/api/member/portfolio", {
            method: "DELETE",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              cardId,
              variant,
              status,
              parallelTierId: parallelTierId || null,
            }),
          })
        : await fetch("/api/member/portfolio", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              cardId,
              variant,
              status,
              parallelTierId: parallelTierId || null,
            }),
          });
      ok = res.ok;
    } catch {
      ok = false;
    }

    // Uppdatera bara den lokala vyn om servern faktiskt lyckades --
    // annars ser det ut som att det gick bra fast raden ligger kvar
    // (eller aldrig skapades) i databasen.
    if (ok) {
      if (isActive) {
        setEntries((e) => {
          const next = new Set(e);
          next.delete(k);
          return next;
        });
        if (status === "have") {
          setIntents((m) => {
            const next = new Map(m);
            next.delete(intentKey(cardId, variant, parallelTierId));
            return next;
          });
        }
      } else {
        setEntries((e) => new Set(e).add(k));
        if (status === "have") {
          setIntents((m) =>
            new Map(m).set(intentKey(cardId, variant, parallelTierId), {
              sellable: false,
              tradeable: false,
            })
          );
        }
      }
    } else {
      setError(
        isActive
          ? "Kunde inte ta bort kortet -- försök igen."
          : "Kunde inte spara kortet -- försök igen."
      );
    }

    setPending((p) => {
      const next = new Set(p);
      next.delete(k);
      return next;
    });
  }

  async function toggleIntent(
    cardId: string,
    variant: Variant,
    parallelTierId: string,
    field: "sellable" | "tradeable"
  ) {
    const ik = intentKey(cardId, variant, parallelTierId);
    const current = intents.get(ik) ?? { sellable: false, tradeable: false };
    const next = { ...current, [field]: !current[field] };
    setError(null);
    setIntents((m) => new Map(m).set(ik, next));
    try {
      const res = await fetch("/api/member/portfolio", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          cardId,
          variant,
          status: "have",
          parallelTierId: parallelTierId || null,
          ...next,
        }),
      });
      if (!res.ok) throw new Error();
    } catch {
      // Servern misslyckades -- backa den optimistiska ändringen så
      // knappen inte visar ett läge som aldrig sparades.
      setIntents((m) => new Map(m).set(ik, current));
      setError("Kunde inte spara ändringen -- försök igen.");
    }
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

      {error && <p className="text-xs text-red-400 mb-3">{error}</p>}

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
                  const pk = `${card.id}:${v.variant}`;
                  const parallelTierId = selectedParallel.get(pk) ?? "";
                  const hasIt = entries.has(key(card.id, v.variant, parallelTierId, "have"));
                  const intent = intents.get(intentKey(card.id, v.variant, parallelTierId));
                  return (
                    <div
                      key={v.id}
                      className="flex items-center gap-1 border border-line rounded-sm px-2 py-1 flex-wrap"
                    >
                      <span className="text-xs text-mute mr-1">
                        {variantLabel[v.variant]}
                      </span>
                      {parallelTiers.length > 0 && (
                        <select
                          value={parallelTierId}
                          onChange={(e) =>
                            setSelectedParallel((m) => new Map(m).set(pk, e.target.value))
                          }
                          className="focus-ring text-xs bg-ink border border-line rounded-sm px-1.5 py-0.5 text-paper max-w-[10rem]"
                          title="Vilken parallel/färg gäller det här?"
                        >
                          <option value="">Standard (ingen parallel)</option>
                          {parallelTiers.map((pt) => (
                            <option key={pt.id} value={pt.id}>
                              {pt.name}
                              {pt.print_run ? ` /${pt.print_run}` : ""}
                            </option>
                          ))}
                        </select>
                      )}
                      <button
                        onClick={() => toggle(card.id, v.variant, parallelTierId, "have")}
                        disabled={pending.has(key(card.id, v.variant, parallelTierId, "have"))}
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
                            onClick={() =>
                              toggleIntent(card.id, v.variant, parallelTierId, "sellable")
                            }
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
                            onClick={() =>
                              toggleIntent(card.id, v.variant, parallelTierId, "tradeable")
                            }
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
                        onClick={() => toggle(card.id, v.variant, parallelTierId, "want")}
                        disabled={pending.has(key(card.id, v.variant, parallelTierId, "want"))}
                        className={`focus-ring text-xs rounded-sm px-2 py-0.5 disabled:opacity-50 ${
                          entries.has(key(card.id, v.variant, parallelTierId, "want"))
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
