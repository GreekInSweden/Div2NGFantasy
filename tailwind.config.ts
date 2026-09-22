import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        ink: "#14151A",
        panel: "#1E2028",
        panelLight: "#272A35",
        line: "#33363F",
        gold: "#E8B33D",
        goldDim: "#8A6A2A",
        paper: "#F2F1ED",
        mute: "#9A9CA8",
        rare: {
          common: "#5B5E68",
          tier: "#4FC1E9",
          double: "#F2994A",
          illustration: "#5FA8D3",
          ultra: "#B26FD1",
          special: "#E8B33D",
          gold: "#F2C94C",
          promo: "#4FBF9F",
        },
        // Sports cards (Topps m.fl.) get their own accent palette instead
        // of borrowing the Pokémon rarity colors — pitch green ties the
        // Sportkort-sektionen ihop, silver/bronze särskiljer Grundkort och
        // Insert på själva korten.
        sport: {
          base: "#98A2B3",
          insert: "#C69749",
          pitch: "#22C55E",
        },
      },
      fontFamily: {
        display: ["var(--font-display)", "sans-serif"],
        body: ["var(--font-body)", "sans-serif"],
        mono: ["var(--font-mono)", "monospace"],
      },
      borderRadius: {
        sm: "4px",
        md: "6px",
      },
    },
  },
  plugins: [],
};
export default config;
