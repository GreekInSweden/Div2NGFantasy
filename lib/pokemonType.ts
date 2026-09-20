import { PokemonType } from "./types";

// Pokémon TCG energy types — samma "färger" som korten fysiskt sorteras
// efter innan de läggs i fack. Ordningen matchar hur energisymbolerna
// vanligtvis radas upp.
export const pokemonTypeOptions: PokemonType[] = [
  "grass",
  "fire",
  "water",
  "lightning",
  "psychic",
  "fighting",
  "darkness",
  "metal",
  "fairy",
  "dragon",
  "colorless",
];

export const pokemonTypeLabel: Record<PokemonType, string> = {
  grass: "Grass",
  fire: "Fire",
  water: "Water",
  lightning: "Lightning",
  psychic: "Psychic",
  fighting: "Fighting",
  darkness: "Darkness",
  metal: "Metal",
  fairy: "Fairy",
  dragon: "Dragon",
  colorless: "Colorless",
};

// Ungefärlig energifärg per typ, används för en liten färgprick i admin så
// det går snabbt att känna igen typen visuellt — samma sätt korten känns
// igen när de ligger i högar.
export const pokemonTypeColor: Record<PokemonType, string> = {
  grass: "#4e9a51",
  fire: "#e0693f",
  water: "#4f92d6",
  lightning: "#f0c93b",
  psychic: "#b06bc9",
  fighting: "#c1622d",
  darkness: "#4a4258",
  metal: "#9aa6ad",
  fairy: "#e896c4",
  dragon: "#b99a3e",
  colorless: "#c9c4b8",
};
