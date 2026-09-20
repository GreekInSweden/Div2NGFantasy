"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";
import { Variant } from "@/lib/types";
import { variantLabel } from "@/lib/variant";

interface SetOption {
  id: string;
  slug: string;
  name: string;
}

interface VariantOption {
  id: string;
  variant: Variant;
  stock: number;
}

interface CardOption {
  id: string;
  number: number;
  name: string;
  variants: VariantOption[];
}

export default function NewAuctionForm({ sets }: { sets: SetOption[] }) {
  const router = useRouter();
  const [setId, setSetId] = useState("");
  const [cards, setCards] = useState<CardOption[]>([]);
  const [cardId, setCardId] = useState("");
  const [variantId, setVariantId] = useState("");
  const [startingPrice, setStartingPrice] = useState(100);
  const [reservePrice, setReservePrice] = useState<number | "">("");
  const [minIncrement, setMinIncrement] = useState(10);
  const [endsAt, setEndsAt] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  useEffect(() => {
    if (!setId) {
      setCards([]);
      return;
    }
    (async () => {
      const supabase = createBrowserSupabase();
      const { data } = await supabase
        .from("cards")
        .select("id, number, name, card_variants(id, variant, stock)")
        .eq("set_id", setId)
        .order("number");
      const normalized: CardOption[] = (data ?? []).map((c: any) => ({
        id: c.id,
        number: c.number,
        name: c.name,
        variants: c.card_variants ?? [],
      }));
      setCards(normalized);
      setCardId("");
      setVariantId("");
    })();
  }, [setId]);

  const selectedCard = cards.find((c) => c.id === cardId);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!variantId || !endsAt) {
      setError("Fyll i alla fält.");
      return;
    }
    setSubmitting(true);
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: insertError } = await supabase.from("auctions").insert({
      card_variant_id: variantId,
      starting_price_sek: startingPrice,
      reserve_price_sek: reservePrice === "" ? null : reservePrice,
      min_increment_sek: minIncrement,
      ends_at: new Date(endsAt).toISOString(),
      status: "open",
    });
    setSubmitting(false);
    if (insertError) {
      setError(`Kunde inte skapa auktionen: ${insertError.message}`);
      return;
    }
    setSuccess(true);
    setTimeout(() => router.push("/admin/auktioner"), 1000);
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <label className="block">
        <span className="text-sm text-mute mb-1 block">Set</span>
        <select
          value={setId}
          onChange={(e) => setSetId(e.target.value)}
          required
          className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
        >
          <option value="">Välj set…</option>
          {sets.map((s) => (
            <option key={s.id} value={s.id}>
              {s.name}
            </option>
          ))}
        </select>
      </label>

      {setId && (
        <label className="block">
          <span className="text-sm text-mute mb-1 block">Kort</span>
          <select
            value={cardId}
            onChange={(e) => {
              setCardId(e.target.value);
              setVariantId("");
            }}
            required
            className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
          >
            <option value="">Välj kort…</option>
            {cards.map((c) => (
              <option key={c.id} value={c.id}>
                #{String(c.number).padStart(3, "0")} {c.name}
              </option>
            ))}
          </select>
        </label>
      )}

      {selectedCard && (
        <label className="block">
          <span className="text-sm text-mute mb-1 block">Variant</span>
          <select
            value={variantId}
            onChange={(e) => setVariantId(e.target.value)}
            required
            className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
          >
            <option value="">Välj variant…</option>
            {selectedCard.variants.map((v) => (
              <option key={v.id} value={v.id}>
                {variantLabel[v.variant]} (lager: {v.stock})
              </option>
            ))}
          </select>
        </label>
      )}

      <label className="block">
        <span className="text-sm text-mute mb-1 block">Utropspris (kr)</span>
        <input
          type="number"
          min={0}
          value={startingPrice}
          onChange={(e) => setStartingPrice(Number(e.target.value))}
          className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
        />
        <span className="text-xs text-mute mt-1 block">
          Visas publikt — det budgivningen börjar från.
        </span>
      </label>

      <label className="block">
        <span className="text-sm text-mute mb-1 block">
          Reservationspris / dolt minimipris (kr) — valfritt
        </span>
        <input
          type="number"
          min={1}
          value={reservePrice}
          onChange={(e) =>
            setReservePrice(e.target.value === "" ? "" : Number(e.target.value))
          }
          placeholder="Lämna tomt om du säljer till högsta bud oavsett"
          className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
        />
        <span className="text-xs text-mute mt-1 block">
          Syns aldrig för kunder — bara du ser exakt siffra. Om högsta budet
          hamnar under den här gränsen visas bara "minimipris ej uppnått"
          publikt, och du väljer själv om du ändå vill sälja.
        </span>
      </label>

      <label className="block">
        <span className="text-sm text-mute mb-1 block">
          Minsta höjning per bud (kr)
        </span>
        <input
          type="number"
          min={1}
          value={minIncrement}
          onChange={(e) => setMinIncrement(Number(e.target.value))}
          className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
        />
      </label>

      <label className="block">
        <span className="text-sm text-mute mb-1 block">Slutar</span>
        <input
          type="datetime-local"
          value={endsAt}
          onChange={(e) => setEndsAt(e.target.value)}
          required
          className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
        />
        <span className="text-xs text-mute mt-1 block">
          Kommer bud in inom sista 3 minuterna innan sluttid förlängs
          auktionen automatiskt med 3 minuter, så ingen snor vinsten i
          sista sekunden.
        </span>
      </label>

      <p className="text-xs text-mute">
        Bild på kortet (fram- och baksida) laddar du upp på nästa sida, direkt
        efter att auktionen skapats — det är bilden av det faktiska
        exemplaret som säljs, inte lagerbilden från butiken.
      </p>

      {error && <p className="text-sm text-red-400">{error}</p>}
      {success && <p className="text-sm text-gold">Auktion skapad ✓</p>}

      <button
        type="submit"
        disabled={submitting}
        className="focus-ring w-full rounded-sm bg-gold text-ink font-semibold py-3 disabled:opacity-50"
      >
        {submitting ? "Skapar…" : "Skapa auktion"}
      </button>
    </form>
  );
}
