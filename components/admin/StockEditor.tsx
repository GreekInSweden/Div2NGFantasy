"use client";

import { useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";
import { rarityLabel } from "@/lib/rarity";
import { Rarity, PokemonType, Variant } from "@/lib/types";
import { variantShortLabel, variantLabel } from "@/lib/variant";
import {
  pokemonTypeOptions,
  pokemonTypeLabel,
  pokemonTypeColor,
} from "@/lib/pokemonType";
import CardImage from "@/components/CardImage";

interface VariantRow {
  id: string;
  variant: Variant;
  price_sek: number;
  stock: number;
}

interface CardRow {
  id: string;
  number: number;
  name: string;
  rarity: Rarity;
  image_url: string | null;
  pokemon_type: PokemonType | null;
  card_variants: VariantRow[];
}

const VARIANT_ORDER: Variant[] = ["normal", "holo", "reverse_holo"];

export default function StockEditor({ cards }: { cards: CardRow[] }) {
  const router = useRouter();
  // Local editable copy: variantId -> current stock value shown in the input.
  const initial = useMemo(() => {
    const map: Record<string, number> = {};
    for (const card of cards) {
      for (const v of card.card_variants) map[v.id] = v.stock;
    }
    return map;
  }, [cards]);

  const [values, setValues] = useState<Record<string, number>>(initial);
  const initialPrices = useMemo(() => {
    const map: Record<string, number> = {};
    for (const card of cards) {
      for (const v of card.card_variants) map[v.id] = v.price_sek;
    }
    return map;
  }, [cards]);
  const [prices, setPrices] = useState<Record<string, number>>(initialPrices);
  const initialTypes = useMemo(() => {
    const map: Record<string, PokemonType | null> = {};
    for (const card of cards) map[card.id] = card.pokemon_type;
    return map;
  }, [cards]);
  const [types, setTypes] = useState<Record<string, PokemonType | null>>(initialTypes);
  const [images, setImages] = useState<Record<string, string | null>>(() => {
    const map: Record<string, string | null> = {};
    for (const card of cards) map[card.id] = card.image_url;
    return map;
  });
  const [uploadingId, setUploadingId] = useState<string | null>(null);
  const [uploadError, setUploadError] = useState<string | null>(null);
  const [query, setQuery] = useState("");
  const [saving, setSaving] = useState(false);
  const [savedAt, setSavedAt] = useState<number | null>(null);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [addingVariantKey, setAddingVariantKey] = useState<string | null>(null);

  async function handleAddVariant(cardId: string, variant: Variant) {
    const key = `${cardId}-${variant}`;
    setAddingVariantKey(key);
    setErrorMsg(null);
    const supabase = createBrowserSupabase();

    const { error } = await supabase
      .from("card_variants")
      .insert({ card_id: cardId, variant, price_sek: 0, stock: 0 });

    setAddingVariantKey(null);
    if (error) {
      setErrorMsg(
        `Kunde inte lägga till ${variantLabel[variant].toLowerCase()}: ${error.message}`
      );
      return;
    }
    // Refetch from the server so the new row shows up with its real id.
    router.refresh();
  }

  const dirtyIds = useMemo(() => {
    const ids = new Set<string>();
    for (const id of Object.keys(values)) {
      if (values[id] !== (initial[id] ?? 0)) ids.add(id);
    }
    for (const id of Object.keys(prices)) {
      if (prices[id] !== (initialPrices[id] ?? 0)) ids.add(id);
    }
    return Array.from(ids);
  }, [values, initial, prices, initialPrices]);

  const dirtyCardIds = useMemo(() => {
    return cards
      .filter((c) => (types[c.id] ?? null) !== (initialTypes[c.id] ?? null))
      .map((c) => c.id);
  }, [cards, types, initialTypes]);

  const totalDirtyCount = dirtyIds.length + dirtyCardIds.length;

  const filteredCards = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return cards;
    return cards.filter((c) => {
      const type = types[c.id];
      const typeLabel = type ? pokemonTypeLabel[type].toLowerCase() : "";
      return (
        c.name.toLowerCase().includes(q) ||
        String(c.number).padStart(3, "0").includes(q) ||
        (type ? type.includes(q) : false) ||
        typeLabel.includes(q)
      );
    });
  }, [cards, query, types]);

  function setType(cardId: string, value: PokemonType | "") {
    setTypes((t) => ({ ...t, [cardId]: value === "" ? null : value }));
  }

  function setValue(variantId: string, value: number) {
    setValues((v) => ({ ...v, [variantId]: Math.max(0, value) }));
  }

  function setPrice(variantId: string, value: number) {
    setPrices((p) => ({ ...p, [variantId]: Math.max(0, value) }));
  }

  function bump(variantId: string, delta: number) {
    setValues((v) => ({
      ...v,
      [variantId]: Math.max(0, (v[variantId] ?? 0) + delta),
    }));
  }

  async function handleSave() {
    if (totalDirtyCount === 0) return;
    setSaving(true);
    setErrorMsg(null);
    const supabase = createBrowserSupabase();

    const variantResults = await Promise.all(
      dirtyIds.map((id) =>
        supabase
          .from("card_variants")
          .update({ stock: values[id] ?? 0, price_sek: prices[id] ?? 0 })
          .eq("id", id)
      )
    );
    const cardResults = await Promise.all(
      dirtyCardIds.map((id) =>
        supabase
          .from("cards")
          .update({ pokemon_type: types[id] ?? null })
          .eq("id", id)
      )
    );
    const failed = [...variantResults, ...cardResults].find((r) => r.error);

    setSaving(false);
    if (failed) {
      setErrorMsg(
        "Något gick fel när ändringarna skulle sparas. Kontrollera att du är inloggad och försök igen."
      );
      return;
    }
    // Treat the saved values as the new baseline.
    Object.assign(initial, values);
    Object.assign(initialPrices, prices);
    Object.assign(initialTypes, types);
    setSavedAt(Date.now());
  }

  async function handleImageUpload(cardId: string, file: File) {
    setUploadError(null);
    setUploadingId(cardId);
    const supabase = createBrowserSupabase();

    const ext = file.name.split(".").pop() || "jpg";
    const path = `${cardId}.${ext}`;

    const { error: uploadErr } = await supabase.storage
      .from("card-images")
      .upload(path, file, { upsert: true, cacheControl: "3600" });

    if (uploadErr) {
      setUploadError(
        `Kunde inte ladda upp bilden: ${uploadErr.message}. Har du kört supabase/image_support.sql?`
      );
      setUploadingId(null);
      return;
    }

    const { data: publicUrlData } = supabase.storage
      .from("card-images")
      .getPublicUrl(path);
    // Cache-bust so a replaced photo shows immediately instead of the old
    // cached version.
    const freshUrl = `${publicUrlData.publicUrl}?t=${Date.now()}`;

    const { error: updateErr } = await supabase
      .from("cards")
      .update({ image_url: freshUrl })
      .eq("id", cardId);

    setUploadingId(null);
    if (updateErr) {
      setUploadError(`Bilden laddades upp men kunde inte sparas: ${updateErr.message}`);
      return;
    }
    setImages((prev) => ({ ...prev, [cardId]: freshUrl }));
  }

  return (
    <div>
      <div className="sticky top-0 z-10 bg-ink py-3 -mx-4 px-4 mb-4 border-b border-line flex items-center gap-3">
        <input
          type="text"
          placeholder="Sök kort efter namn, nummer eller typ (t.ex. water)…"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          className="focus-ring flex-1 bg-panel border border-line rounded-sm px-3 py-2 text-paper text-sm"
        />
        <button
          onClick={handleSave}
          disabled={totalDirtyCount === 0 || saving}
          className="focus-ring shrink-0 rounded-sm bg-gold text-ink font-semibold px-4 py-2 text-sm disabled:opacity-40"
        >
          {saving
            ? "Sparar…"
            : totalDirtyCount > 0
            ? `Spara ${totalDirtyCount} ändring${totalDirtyCount === 1 ? "" : "ar"}`
            : "Inga ändringar"}
        </button>
      </div>

      {savedAt && totalDirtyCount === 0 && (
        <p className="text-sm text-gold mb-4">Sparat ✓</p>
      )}
      {errorMsg && <p className="text-sm text-red-400 mb-4">{errorMsg}</p>}
      {uploadError && <p className="text-sm text-red-400 mb-4">{uploadError}</p>}

      <div className="space-y-2">
        {filteredCards.map((card) => {
          const variantsPresent = VARIANT_ORDER
            .map((vt) => card.card_variants.find((v) => v.variant === vt))
            .filter((v): v is VariantRow => !!v);
          const missingVariants = VARIANT_ORDER.filter(
            (vt) => !card.card_variants.some((v) => v.variant === vt)
          );
          const cardType = types[card.id] ?? null;
          const isTypeDirty = cardType !== (initialTypes[card.id] ?? null);

          return (
            <div
              key={card.id}
              className="border border-line rounded-md p-3 bg-panel space-y-2"
            >
              {/* Rad 1: bild, nummer, namn */}
              <div className="flex items-center gap-4">
                <label className="shrink-0 cursor-pointer group relative">
                  <CardImage
                    src={images[card.id] ?? null}
                    alt={card.name}
                    number={card.number}
                    rarity={card.rarity}
                    className="w-12 h-16 rounded-sm"
                  />
                  <div className="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity rounded-sm">
                    <span className="text-[10px] text-paper text-center leading-tight px-1">
                      {uploadingId === card.id ? "Laddar…" : "Byt bild"}
                    </span>
                  </div>
                  <input
                    type="file"
                    accept="image/*"
                    className="hidden"
                    disabled={uploadingId === card.id}
                    onChange={(e) => {
                      const file = e.target.files?.[0];
                      if (file) handleImageUpload(card.id, file);
                      e.target.value = "";
                    }}
                  />
                </label>
                <div className="w-16 shrink-0 font-mono text-xs text-mute">
                  #{String(card.number).padStart(3, "0")}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="font-display text-sm font-medium text-paper truncate">
                    {card.name}
                  </div>
                  <div className="text-xs text-mute">{rarityLabel[card.rarity]}</div>
                </div>
                <div className="shrink-0 flex items-center gap-1.5">
                  <span
                    className="w-2.5 h-2.5 rounded-full border border-line shrink-0"
                    style={{
                      backgroundColor: cardType
                        ? pokemonTypeColor[cardType]
                        : "transparent",
                    }}
                    aria-hidden
                  />
                  <select
                    value={cardType ?? ""}
                    onChange={(e) =>
                      setType(card.id, e.target.value as PokemonType | "")
                    }
                    title="Pokémon-typ (färg)"
                    className={`focus-ring bg-ink border rounded-sm px-1.5 py-1 text-xs text-paper ${
                      isTypeDirty ? "border-gold" : "border-line"
                    }`}
                  >
                    <option value="">Typ…</option>
                    {pokemonTypeOptions.map((t) => (
                      <option key={t} value={t}>
                        {pokemonTypeLabel[t]}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              {/* Rad 2: Pris */}
              <div className="flex items-center gap-3 pl-16">
                <span className="text-xs text-mute w-12 shrink-0">Pris</span>
                {variantsPresent.map((variant) => {
                  const isPriceDirty =
                    prices[variant.id] !== (initialPrices[variant.id] ?? 0);
                  return (
                    <div key={variant.id} className="flex items-center gap-1.5 shrink-0">
                      <span className="text-xs text-mute w-10">
                        {variantShortLabel[variant.variant]}
                      </span>
                      <input
                        type="number"
                        min={0}
                        value={prices[variant.id] ?? 0}
                        onChange={(e) => setPrice(variant.id, Number(e.target.value))}
                        title="Pris (kr)"
                        className={`focus-ring w-16 bg-ink border rounded-sm px-1 py-1 text-center font-mono text-sm text-paper ${
                          isPriceDirty ? "border-gold" : "border-line"
                        }`}
                      />
                      <span className="text-xs text-mute">kr</span>
                    </div>
                  );
                })}
              </div>

              {/* Rad 3: Antal */}
              <div className="flex items-center gap-3 pl-16">
                <span className="text-xs text-mute w-12 shrink-0">Antal</span>
                {variantsPresent.map((variant) => {
                  const isStockDirty = values[variant.id] !== (initial[variant.id] ?? 0);
                  return (
                    <div key={variant.id} className="flex items-center gap-1 shrink-0">
                      <span className="text-xs text-mute w-10">
                        {variantShortLabel[variant.variant]}
                      </span>
                      <button
                        onClick={() => bump(variant.id, -1)}
                        className="focus-ring w-7 h-7 rounded-sm border border-line text-paper hover:border-gold text-sm"
                        aria-label={`Minska ${variant.variant}`}
                      >
                        −
                      </button>
                      <input
                        type="number"
                        min={0}
                        value={values[variant.id] ?? 0}
                        onChange={(e) => setValue(variant.id, Number(e.target.value))}
                        title="Antal i lager"
                        className={`focus-ring w-16 bg-ink border rounded-sm px-1 py-1 text-center font-mono text-sm text-paper ${
                          isStockDirty ? "border-gold" : "border-line"
                        }`}
                      />
                      <button
                        onClick={() => bump(variant.id, 1)}
                        className="focus-ring w-7 h-7 rounded-sm border border-line text-paper hover:border-gold text-sm"
                        aria-label={`Öka ${variant.variant}`}
                      >
                        +
                      </button>
                    </div>
                  );
                })}
              </div>

              {/* Rad 4: Lägg till saknad variant */}
              {missingVariants.length > 0 && (
                <div className="flex items-center gap-2 pl-16 flex-wrap">
                  {missingVariants.map((variant) => {
                    const key = `${card.id}-${variant}`;
                    const isAdding = addingVariantKey === key;
                    return (
                      <button
                        key={variant}
                        onClick={() => handleAddVariant(card.id, variant)}
                        disabled={isAdding}
                        className="focus-ring text-xs rounded-sm border border-dashed border-line px-2 py-1 text-mute hover:border-gold hover:text-gold disabled:opacity-40"
                      >
                        {isAdding
                          ? "Lägger till…"
                          : `+ ${variantLabel[variant]}`}
                      </button>
                    );
                  })}
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}
