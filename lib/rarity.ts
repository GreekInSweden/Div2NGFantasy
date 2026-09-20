import { Rarity } from "./types";

export const rarityLabel: Record<Rarity, string> = {
  common: "Vanligt",
  rare: "Rare",
  double_rare: "Double Rare / ex",
  illustration_rare: "Illustration Rare",
  ultra_rare: "Ultra Rare",
  special_illustration_rare: "Special Illustration Rare",
  mega_hyper_rare: "Hyper Rare",
  promo: "Promo",
  base: "Grundkort",
  insert: "Insert",
};

// Tailwind classes for the thin rarity edge on each card tile.
export const rarityAccent: Record<Rarity, string> = {
  common: "border-l-rare-common",
  rare: "border-l-rare-tier",
  double_rare: "border-l-rare-double",
  illustration_rare: "border-l-rare-illustration",
  ultra_rare: "border-l-rare-ultra",
  special_illustration_rare: "border-l-rare-special",
  mega_hyper_rare: "border-l-rare-gold",
  promo: "border-l-rare-promo",
  base: "border-l-rare-common",
  insert: "border-l-rare-illustration",
};

// The variant that IS a card's base/ordinary print, by rarity. Most
// rarities print a plain "normal" card first — but a "Rare" (holo-tier)
// card in this set never gets a separate non-holo print, so its own base
// print is stored as the "holo" variant instead. Everything from
// Double Rare upward is single-print with no separate holo distinction at
// all — their one print is stored as "normal" by convention.
export const baseVariantByRarity: Record<Rarity, "normal" | "holo"> = {
  common: "normal",
  rare: "holo",
  double_rare: "normal",
  illustration_rare: "normal",
  ultra_rare: "normal",
  special_illustration_rare: "normal",
  mega_hyper_rare: "normal",
  promo: "normal",
  base: "normal",
  insert: "normal",
};

// Rarities that can additionally have a reverse holo print. Everything
// from Double Rare upward is already the special/single print and never
// gets one.
export const reverseHoloEligibleRarities: Rarity[] = ["common", "rare"];
