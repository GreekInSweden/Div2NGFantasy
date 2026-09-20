"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";
import { Rarity, PokemonType } from "@/lib/types";
import { rarityLabel } from "@/lib/rarity";
import { pokemonTypeOptions, pokemonTypeLabel } from "@/lib/pokemonType";

const rarityOptions: Rarity[] = [
  "promo",
  "base",
  "insert",
  "common",
  "rare",
  "double_rare",
  "illustration_rare",
  "ultra_rare",
  "special_illustration_rare",
  "mega_hyper_rare",
];

export default function NewCardForm({
  setId,
  setSlug,
  suggestedNumber,
}: {
  setId: string;
  setSlug: string;
  suggestedNumber: number;
}) {
  const router = useRouter();
  const [number, setNumber] = useState(suggestedNumber);
  const [name, setName] = useState("");
  const [rarity, setRarity] = useState<Rarity>("promo");
  const [pokemonType, setPokemonType] = useState<PokemonType | "">("");
  const [normalPrice, setNormalPrice] = useState(20);
  const [normalStock, setNormalStock] = useState(1);
  const [includeHolo, setIncludeHolo] = useState(false);
  const [holoPrice, setHoloPrice] = useState(30);
  const [holoStock, setHoloStock] = useState(0);
  const [includeReverseHolo, setIncludeReverseHolo] = useState(false);
  const [reverseHoloPrice, setReverseHoloPrice] = useState(30);
  const [reverseHoloStock, setReverseHoloStock] = useState(0);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    if (!name.trim()) {
      setError("Ange ett kortnamn.");
      return;
    }
    setSubmitting(true);
    const supabase = createBrowserSupabase();

    const { data: card, error: cardError } = await supabase
      .from("cards")
      .insert({
        set_id: setId,
        number,
        name: name.trim(),
        rarity,
        pokemon_type: pokemonType || null,
      })
      .select()
      .single();

    if (cardError || !card) {
      setSubmitting(false);
      setError(
        cardError?.message.includes("duplicate")
          ? `Kortnummer ${number} finns redan i det här setet.`
          : `Kunde inte skapa kortet: ${cardError?.message}`
      );
      return;
    }

    const variantRows = [
      { card_id: card.id, variant: "normal", price_sek: normalPrice, stock: normalStock },
    ];
    if (includeHolo) {
      variantRows.push({
        card_id: card.id,
        variant: "holo",
        price_sek: holoPrice,
        stock: holoStock,
      });
    }
    if (includeReverseHolo) {
      variantRows.push({
        card_id: card.id,
        variant: "reverse_holo",
        price_sek: reverseHoloPrice,
        stock: reverseHoloStock,
      });
    }

    const { error: variantError } = await supabase
      .from("card_variants")
      .insert(variantRows);

    setSubmitting(false);
    if (variantError) {
      setError(`Kortet skapades men varianten kunde inte sparas: ${variantError.message}`);
      return;
    }
    setSuccess(true);
    setTimeout(() => router.push(`/admin/${setSlug}`), 900);
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="grid grid-cols-2 gap-4">
        <label className="block">
          <span className="text-sm text-mute mb-1 block">Nummer</span>
          <input
            type="number"
            min={1}
            value={number}
            onChange={(e) => setNumber(Number(e.target.value))}
            className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
          />
        </label>
        <label className="block">
          <span className="text-sm text-mute mb-1 block">Typ</span>
          <select
            value={rarity}
            onChange={(e) => setRarity(e.target.value as Rarity)}
            className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
          >
            {rarityOptions.map((r) => (
              <option key={r} value={r}>
                {rarityLabel[r]}
              </option>
            ))}
          </select>
        </label>
        <label className="block col-span-2">
          <span className="text-sm text-mute mb-1 block">
            Pokémon-typ (färg)
          </span>
          <select
            value={pokemonType}
            onChange={(e) => setPokemonType(e.target.value as PokemonType | "")}
            className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
          >
            <option value="">Ingen / Trainer / Topps</option>
            {pokemonTypeOptions.map((t) => (
              <option key={t} value={t}>
                {pokemonTypeLabel[t]}
              </option>
            ))}
          </select>
        </label>
      </div>

      <label className="block">
        <span className="text-sm text-mute mb-1 block">Kortnamn</span>
        <input
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="t.ex. Zarude (ETB-promo)"
          required
          className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
        />
      </label>

      <div className="border border-line rounded-md p-3">
        <p className="text-sm text-paper mb-2 font-medium">Vanlig variant</p>
        <div className="grid grid-cols-2 gap-3">
          <label className="block">
            <span className="text-xs text-mute mb-1 block">Pris (kr)</span>
            <input
              type="number"
              min={0}
              value={normalPrice}
              onChange={(e) => setNormalPrice(Number(e.target.value))}
              className="focus-ring w-full bg-ink border border-line rounded-sm px-2 py-1.5 text-paper text-sm"
            />
          </label>
          <label className="block">
            <span className="text-xs text-mute mb-1 block">Antal i lager</span>
            <input
              type="number"
              min={0}
              value={normalStock}
              onChange={(e) => setNormalStock(Number(e.target.value))}
              className="focus-ring w-full bg-ink border border-line rounded-sm px-2 py-1.5 text-paper text-sm"
            />
          </label>
        </div>
      </div>

      <label className="flex items-center gap-2 text-sm text-paper">
        <input
          type="checkbox"
          checked={includeHolo}
          onChange={(e) => setIncludeHolo(e.target.checked)}
          className="focus-ring accent-gold w-4 h-4"
        />
        Det här kortet finns även i en holo-variant
      </label>

      {includeHolo && (
        <div className="border border-line rounded-md p-3">
          <p className="text-sm text-paper mb-2 font-medium">Holo-variant</p>
          <div className="grid grid-cols-2 gap-3">
            <label className="block">
              <span className="text-xs text-mute mb-1 block">Pris (kr)</span>
              <input
                type="number"
                min={0}
                value={holoPrice}
                onChange={(e) => setHoloPrice(Number(e.target.value))}
                className="focus-ring w-full bg-ink border border-line rounded-sm px-2 py-1.5 text-paper text-sm"
              />
            </label>
            <label className="block">
              <span className="text-xs text-mute mb-1 block">Antal i lager</span>
              <input
                type="number"
                min={0}
                value={holoStock}
                onChange={(e) => setHoloStock(Number(e.target.value))}
                className="focus-ring w-full bg-ink border border-line rounded-sm px-2 py-1.5 text-paper text-sm"
              />
            </label>
          </div>
        </div>
      )}

      <label className="flex items-center gap-2 text-sm text-paper">
        <input
          type="checkbox"
          checked={includeReverseHolo}
          onChange={(e) => setIncludeReverseHolo(e.target.checked)}
          className="focus-ring accent-gold w-4 h-4"
        />
        Det här kortet finns även i en reverse holo-variant
      </label>

      {includeReverseHolo && (
        <div className="border border-line rounded-md p-3">
          <p className="text-sm text-paper mb-2 font-medium">
            Reverse holo-variant
          </p>
          <div className="grid grid-cols-2 gap-3">
            <label className="block">
              <span className="text-xs text-mute mb-1 block">Pris (kr)</span>
              <input
                type="number"
                min={0}
                value={reverseHoloPrice}
                onChange={(e) => setReverseHoloPrice(Number(e.target.value))}
                className="focus-ring w-full bg-ink border border-line rounded-sm px-2 py-1.5 text-paper text-sm"
              />
            </label>
            <label className="block">
              <span className="text-xs text-mute mb-1 block">Antal i lager</span>
              <input
                type="number"
                min={0}
                value={reverseHoloStock}
                onChange={(e) => setReverseHoloStock(Number(e.target.value))}
                className="focus-ring w-full bg-ink border border-line rounded-sm px-2 py-1.5 text-paper text-sm"
              />
            </label>
          </div>
        </div>
      )}

      {error && <p className="text-sm text-red-400">{error}</p>}
      {success && <p className="text-sm text-gold">Kort skapat ✓</p>}

      <button
        type="submit"
        disabled={submitting}
        className="focus-ring w-full rounded-sm bg-gold text-ink font-semibold py-3 disabled:opacity-50"
      >
        {submitting ? "Skapar…" : "Skapa kort"}
      </button>
    </form>
  );
}
