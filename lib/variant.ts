import { Variant } from "./types";

// Enda stället variant-etiketterna definieras, så "Reverse Holo" dyker upp
// konsekvent överallt (kassan, orderhistorik, auktioner, admin) istället för
// att varje ställe gissar med en egen ?:-sats.
export const variantLabel: Record<Variant, string> = {
  normal: "Vanligt",
  holo: "Holo",
  reverse_holo: "Reverse Holo",
};

export const variantShortLabel: Record<Variant, string> = {
  normal: "Van.",
  holo: "Holo",
  reverse_holo: "Rev. Holo",
};
