-- Katalogimport: Base (6 set)
-- Endast katalogdata (lager 0, pris 0) för portfölj/önskelista-funktionen.

-- Set: Base (base1) -- 1999/01/09
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('base', 'Base', 'base', 'Base', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'base'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Alakazam', 'rare', 'https://images.pokemontcg.io/base1/1_hires.png', 'psychic'),
    (2, 'Blastoise', 'rare', 'https://images.pokemontcg.io/base1/2_hires.png', 'water'),
    (3, 'Chansey', 'rare', 'https://images.pokemontcg.io/base1/3_hires.png', 'colorless'),
    (4, 'Charizard', 'rare', 'https://images.pokemontcg.io/base1/4_hires.png', 'fire'),
    (5, 'Clefairy', 'rare', 'https://images.pokemontcg.io/base1/5_hires.png', 'colorless'),
    (6, 'Gyarados', 'rare', 'https://images.pokemontcg.io/base1/6_hires.png', 'water'),
    (7, 'Hitmonchan', 'rare', 'https://images.pokemontcg.io/base1/7_hires.png', 'fighting'),
    (8, 'Machamp', 'rare', 'https://images.pokemontcg.io/base1/8_hires.png', 'fighting'),
    (9, 'Magneton', 'rare', 'https://images.pokemontcg.io/base1/9_hires.png', 'lightning'),
    (10, 'Mewtwo', 'rare', 'https://images.pokemontcg.io/base1/10_hires.png', 'psychic'),
    (11, 'Nidoking', 'rare', 'https://images.pokemontcg.io/base1/11_hires.png', 'grass'),
    (12, 'Ninetales', 'rare', 'https://images.pokemontcg.io/base1/12_hires.png', 'fire'),
    (13, 'Poliwrath', 'rare', 'https://images.pokemontcg.io/base1/13_hires.png', 'water'),
    (14, 'Raichu', 'rare', 'https://images.pokemontcg.io/base1/14_hires.png', 'lightning'),
    (15, 'Venusaur', 'rare', 'https://images.pokemontcg.io/base1/15_hires.png', 'grass'),
    (16, 'Zapdos', 'rare', 'https://images.pokemontcg.io/base1/16_hires.png', 'lightning'),
    (17, 'Beedrill', 'rare', 'https://images.pokemontcg.io/base1/17_hires.png', 'grass'),
    (18, 'Dragonair', 'rare', 'https://images.pokemontcg.io/base1/18_hires.png', 'colorless'),
    (19, 'Dugtrio', 'rare', 'https://images.pokemontcg.io/base1/19_hires.png', 'fighting'),
    (20, 'Electabuzz', 'rare', 'https://images.pokemontcg.io/base1/20_hires.png', 'lightning'),
    (21, 'Electrode', 'rare', 'https://images.pokemontcg.io/base1/21_hires.png', 'lightning'),
    (22, 'Pidgeotto', 'rare', 'https://images.pokemontcg.io/base1/22_hires.png', 'colorless'),
    (23, 'Arcanine', 'common', 'https://images.pokemontcg.io/base1/23_hires.png', 'fire'),
    (24, 'Charmeleon', 'common', 'https://images.pokemontcg.io/base1/24_hires.png', 'fire'),
    (25, 'Dewgong', 'common', 'https://images.pokemontcg.io/base1/25_hires.png', 'water'),
    (26, 'Dratini', 'common', 'https://images.pokemontcg.io/base1/26_hires.png', 'colorless'),
    (27, 'Farfetch''d', 'common', 'https://images.pokemontcg.io/base1/27_hires.png', 'colorless'),
    (28, 'Growlithe', 'common', 'https://images.pokemontcg.io/base1/28_hires.png', 'fire'),
    (29, 'Haunter', 'common', 'https://images.pokemontcg.io/base1/29_hires.png', 'psychic'),
    (30, 'Ivysaur', 'common', 'https://images.pokemontcg.io/base1/30_hires.png', 'grass'),
    (31, 'Jynx', 'common', 'https://images.pokemontcg.io/base1/31_hires.png', 'psychic'),
    (32, 'Kadabra', 'common', 'https://images.pokemontcg.io/base1/32_hires.png', 'psychic'),
    (33, 'Kakuna', 'common', 'https://images.pokemontcg.io/base1/33_hires.png', 'grass'),
    (34, 'Machoke', 'common', 'https://images.pokemontcg.io/base1/34_hires.png', 'fighting'),
    (35, 'Magikarp', 'common', 'https://images.pokemontcg.io/base1/35_hires.png', 'water'),
    (36, 'Magmar', 'common', 'https://images.pokemontcg.io/base1/36_hires.png', 'fire'),
    (37, 'Nidorino', 'common', 'https://images.pokemontcg.io/base1/37_hires.png', 'grass'),
    (38, 'Poliwhirl', 'common', 'https://images.pokemontcg.io/base1/38_hires.png', 'water'),
    (39, 'Porygon', 'common', 'https://images.pokemontcg.io/base1/39_hires.png', 'colorless'),
    (40, 'Raticate', 'common', 'https://images.pokemontcg.io/base1/40_hires.png', 'colorless'),
    (41, 'Seel', 'common', 'https://images.pokemontcg.io/base1/41_hires.png', 'water'),
    (42, 'Wartortle', 'common', 'https://images.pokemontcg.io/base1/42_hires.png', 'water'),
    (43, 'Abra', 'common', 'https://images.pokemontcg.io/base1/43_hires.png', 'psychic'),
    (44, 'Bulbasaur', 'common', 'https://images.pokemontcg.io/base1/44_hires.png', 'grass'),
    (45, 'Caterpie', 'common', 'https://images.pokemontcg.io/base1/45_hires.png', 'grass'),
    (46, 'Charmander', 'common', 'https://images.pokemontcg.io/base1/46_hires.png', 'fire'),
    (47, 'Diglett', 'common', 'https://images.pokemontcg.io/base1/47_hires.png', 'fighting'),
    (48, 'Doduo', 'common', 'https://images.pokemontcg.io/base1/48_hires.png', 'colorless'),
    (49, 'Drowzee', 'common', 'https://images.pokemontcg.io/base1/49_hires.png', 'psychic'),
    (50, 'Gastly', 'common', 'https://images.pokemontcg.io/base1/50_hires.png', 'psychic'),
    (51, 'Koffing', 'common', 'https://images.pokemontcg.io/base1/51_hires.png', 'grass'),
    (52, 'Machop', 'common', 'https://images.pokemontcg.io/base1/52_hires.png', 'fighting'),
    (53, 'Magnemite', 'common', 'https://images.pokemontcg.io/base1/53_hires.png', 'lightning'),
    (54, 'Metapod', 'common', 'https://images.pokemontcg.io/base1/54_hires.png', 'grass'),
    (55, 'Nidoran ♂', 'common', 'https://images.pokemontcg.io/base1/55_hires.png', 'grass'),
    (56, 'Onix', 'common', 'https://images.pokemontcg.io/base1/56_hires.png', 'fighting'),
    (57, 'Pidgey', 'common', 'https://images.pokemontcg.io/base1/57_hires.png', 'colorless'),
    (58, 'Pikachu', 'common', 'https://images.pokemontcg.io/base1/58_hires.png', 'lightning'),
    (59, 'Poliwag', 'common', 'https://images.pokemontcg.io/base1/59_hires.png', 'water'),
    (60, 'Ponyta', 'common', 'https://images.pokemontcg.io/base1/60_hires.png', 'fire'),
    (61, 'Rattata', 'common', 'https://images.pokemontcg.io/base1/61_hires.png', 'colorless'),
    (62, 'Sandshrew', 'common', 'https://images.pokemontcg.io/base1/62_hires.png', 'fighting'),
    (63, 'Squirtle', 'common', 'https://images.pokemontcg.io/base1/63_hires.png', 'water'),
    (64, 'Starmie', 'common', 'https://images.pokemontcg.io/base1/64_hires.png', 'water'),
    (65, 'Staryu', 'common', 'https://images.pokemontcg.io/base1/65_hires.png', 'water'),
    (66, 'Tangela', 'common', 'https://images.pokemontcg.io/base1/66_hires.png', 'grass'),
    (67, 'Voltorb', 'common', 'https://images.pokemontcg.io/base1/67_hires.png', 'lightning'),
    (68, 'Vulpix', 'common', 'https://images.pokemontcg.io/base1/68_hires.png', 'fire'),
    (69, 'Weedle', 'common', 'https://images.pokemontcg.io/base1/69_hires.png', 'grass'),
    (70, 'Clefairy Doll', 'rare', 'https://images.pokemontcg.io/base1/70_hires.png', NULL),
    (71, 'Computer Search', 'rare', 'https://images.pokemontcg.io/base1/71_hires.png', NULL),
    (72, 'Devolution Spray', 'rare', 'https://images.pokemontcg.io/base1/72_hires.png', NULL),
    (73, 'Impostor Professor Oak', 'rare', 'https://images.pokemontcg.io/base1/73_hires.png', NULL),
    (74, 'Item Finder', 'rare', 'https://images.pokemontcg.io/base1/74_hires.png', NULL),
    (75, 'Lass', 'rare', 'https://images.pokemontcg.io/base1/75_hires.png', NULL),
    (76, 'Pokémon Breeder', 'rare', 'https://images.pokemontcg.io/base1/76_hires.png', NULL),
    (77, 'Pokémon Trader', 'rare', 'https://images.pokemontcg.io/base1/77_hires.png', NULL),
    (78, 'Scoop Up', 'rare', 'https://images.pokemontcg.io/base1/78_hires.png', NULL),
    (79, 'Super Energy Removal', 'rare', 'https://images.pokemontcg.io/base1/79_hires.png', NULL),
    (80, 'Defender', 'common', 'https://images.pokemontcg.io/base1/80_hires.png', NULL),
    (81, 'Energy Retrieval', 'common', 'https://images.pokemontcg.io/base1/81_hires.png', NULL),
    (82, 'Full Heal', 'common', 'https://images.pokemontcg.io/base1/82_hires.png', NULL),
    (83, 'Maintenance', 'common', 'https://images.pokemontcg.io/base1/83_hires.png', NULL),
    (84, 'PlusPower', 'common', 'https://images.pokemontcg.io/base1/84_hires.png', NULL),
    (85, 'Pokémon Center', 'common', 'https://images.pokemontcg.io/base1/85_hires.png', NULL),
    (86, 'Pokémon Flute', 'common', 'https://images.pokemontcg.io/base1/86_hires.png', NULL),
    (87, 'Pokédex', 'common', 'https://images.pokemontcg.io/base1/87_hires.png', NULL),
    (88, 'Professor Oak', 'common', 'https://images.pokemontcg.io/base1/88_hires.png', NULL),
    (89, 'Revive', 'common', 'https://images.pokemontcg.io/base1/89_hires.png', NULL),
    (90, 'Super Potion', 'common', 'https://images.pokemontcg.io/base1/90_hires.png', NULL),
    (91, 'Bill', 'common', 'https://images.pokemontcg.io/base1/91_hires.png', NULL),
    (92, 'Energy Removal', 'common', 'https://images.pokemontcg.io/base1/92_hires.png', NULL),
    (93, 'Gust of Wind', 'common', 'https://images.pokemontcg.io/base1/93_hires.png', NULL),
    (94, 'Potion', 'common', 'https://images.pokemontcg.io/base1/94_hires.png', NULL),
    (95, 'Switch', 'common', 'https://images.pokemontcg.io/base1/95_hires.png', NULL),
    (96, 'Double Colorless Energy', 'common', 'https://images.pokemontcg.io/base1/96_hires.png', NULL),
    (97, 'Fighting Energy', 'base', 'https://images.pokemontcg.io/base1/97_hires.png', NULL),
    (98, 'Fire Energy', 'base', 'https://images.pokemontcg.io/base1/98_hires.png', NULL),
    (99, 'Grass Energy', 'base', 'https://images.pokemontcg.io/base1/99_hires.png', NULL),
    (100, 'Lightning Energy', 'base', 'https://images.pokemontcg.io/base1/100_hires.png', NULL),
    (101, 'Psychic Energy', 'base', 'https://images.pokemontcg.io/base1/101_hires.png', NULL),
    (102, 'Water Energy', 'base', 'https://images.pokemontcg.io/base1/102_hires.png', NULL)
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: Jungle (base2) -- 1999/06/16
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('base', 'Base', 'jungle', 'Jungle', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'jungle'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Clefable', 'rare', 'https://images.pokemontcg.io/base2/1_hires.png', 'colorless'),
    (2, 'Electrode', 'rare', 'https://images.pokemontcg.io/base2/2_hires.png', 'lightning'),
    (3, 'Flareon', 'rare', 'https://images.pokemontcg.io/base2/3_hires.png', 'fire'),
    (4, 'Jolteon', 'rare', 'https://images.pokemontcg.io/base2/4_hires.png', 'lightning'),
    (5, 'Kangaskhan', 'rare', 'https://images.pokemontcg.io/base2/5_hires.png', 'colorless'),
    (6, 'Mr. Mime', 'rare', 'https://images.pokemontcg.io/base2/6_hires.png', 'psychic'),
    (7, 'Nidoqueen', 'rare', 'https://images.pokemontcg.io/base2/7_hires.png', 'grass'),
    (8, 'Pidgeot', 'rare', 'https://images.pokemontcg.io/base2/8_hires.png', 'colorless'),
    (9, 'Pinsir', 'rare', 'https://images.pokemontcg.io/base2/9_hires.png', 'grass'),
    (10, 'Scyther', 'rare', 'https://images.pokemontcg.io/base2/10_hires.png', 'grass'),
    (11, 'Snorlax', 'rare', 'https://images.pokemontcg.io/base2/11_hires.png', 'colorless'),
    (12, 'Vaporeon', 'rare', 'https://images.pokemontcg.io/base2/12_hires.png', 'water'),
    (13, 'Venomoth', 'rare', 'https://images.pokemontcg.io/base2/13_hires.png', 'grass'),
    (14, 'Victreebel', 'rare', 'https://images.pokemontcg.io/base2/14_hires.png', 'grass'),
    (15, 'Vileplume', 'rare', 'https://images.pokemontcg.io/base2/15_hires.png', 'grass'),
    (16, 'Wigglytuff', 'rare', 'https://images.pokemontcg.io/base2/16_hires.png', 'colorless'),
    (17, 'Clefable', 'rare', 'https://images.pokemontcg.io/base2/17_hires.png', 'colorless'),
    (18, 'Electrode', 'rare', 'https://images.pokemontcg.io/base2/18_hires.png', 'lightning'),
    (19, 'Flareon', 'rare', 'https://images.pokemontcg.io/base2/19_hires.png', 'fire'),
    (20, 'Jolteon', 'rare', 'https://images.pokemontcg.io/base2/20_hires.png', 'lightning'),
    (21, 'Kangaskhan', 'rare', 'https://images.pokemontcg.io/base2/21_hires.png', 'colorless'),
    (22, 'Mr. Mime', 'rare', 'https://images.pokemontcg.io/base2/22_hires.png', 'psychic'),
    (23, 'Nidoqueen', 'rare', 'https://images.pokemontcg.io/base2/23_hires.png', 'grass'),
    (24, 'Pidgeot', 'rare', 'https://images.pokemontcg.io/base2/24_hires.png', 'colorless'),
    (25, 'Pinsir', 'rare', 'https://images.pokemontcg.io/base2/25_hires.png', 'grass'),
    (26, 'Scyther', 'rare', 'https://images.pokemontcg.io/base2/26_hires.png', 'grass'),
    (27, 'Snorlax', 'rare', 'https://images.pokemontcg.io/base2/27_hires.png', 'colorless'),
    (28, 'Vaporeon', 'rare', 'https://images.pokemontcg.io/base2/28_hires.png', 'water'),
    (29, 'Venomoth', 'rare', 'https://images.pokemontcg.io/base2/29_hires.png', 'grass'),
    (30, 'Victreebel', 'rare', 'https://images.pokemontcg.io/base2/30_hires.png', 'grass'),
    (31, 'Vileplume', 'rare', 'https://images.pokemontcg.io/base2/31_hires.png', 'grass'),
    (32, 'Wigglytuff', 'rare', 'https://images.pokemontcg.io/base2/32_hires.png', 'colorless'),
    (33, 'Butterfree', 'common', 'https://images.pokemontcg.io/base2/33_hires.png', 'grass'),
    (34, 'Dodrio', 'common', 'https://images.pokemontcg.io/base2/34_hires.png', 'colorless'),
    (35, 'Exeggutor', 'common', 'https://images.pokemontcg.io/base2/35_hires.png', 'grass'),
    (36, 'Fearow', 'common', 'https://images.pokemontcg.io/base2/36_hires.png', 'colorless'),
    (37, 'Gloom', 'common', 'https://images.pokemontcg.io/base2/37_hires.png', 'grass'),
    (38, 'Lickitung', 'common', 'https://images.pokemontcg.io/base2/38_hires.png', 'colorless'),
    (39, 'Marowak', 'common', 'https://images.pokemontcg.io/base2/39_hires.png', 'fighting'),
    (40, 'Nidorina', 'common', 'https://images.pokemontcg.io/base2/40_hires.png', 'grass'),
    (41, 'Parasect', 'common', 'https://images.pokemontcg.io/base2/41_hires.png', 'grass'),
    (42, 'Persian', 'common', 'https://images.pokemontcg.io/base2/42_hires.png', 'colorless'),
    (43, 'Primeape', 'common', 'https://images.pokemontcg.io/base2/43_hires.png', 'fighting'),
    (44, 'Rapidash', 'common', 'https://images.pokemontcg.io/base2/44_hires.png', 'fire'),
    (45, 'Rhydon', 'common', 'https://images.pokemontcg.io/base2/45_hires.png', 'fighting'),
    (46, 'Seaking', 'common', 'https://images.pokemontcg.io/base2/46_hires.png', 'water'),
    (47, 'Tauros', 'common', 'https://images.pokemontcg.io/base2/47_hires.png', 'colorless'),
    (48, 'Weepinbell', 'common', 'https://images.pokemontcg.io/base2/48_hires.png', 'grass'),
    (49, 'Bellsprout', 'common', 'https://images.pokemontcg.io/base2/49_hires.png', 'grass'),
    (50, 'Cubone', 'common', 'https://images.pokemontcg.io/base2/50_hires.png', 'fighting'),
    (51, 'Eevee', 'common', 'https://images.pokemontcg.io/base2/51_hires.png', 'colorless'),
    (52, 'Exeggcute', 'common', 'https://images.pokemontcg.io/base2/52_hires.png', 'grass'),
    (53, 'Goldeen', 'common', 'https://images.pokemontcg.io/base2/53_hires.png', 'water'),
    (54, 'Jigglypuff', 'common', 'https://images.pokemontcg.io/base2/54_hires.png', 'colorless'),
    (55, 'Mankey', 'common', 'https://images.pokemontcg.io/base2/55_hires.png', 'fighting'),
    (56, 'Meowth', 'common', 'https://images.pokemontcg.io/base2/56_hires.png', 'colorless'),
    (57, 'Nidoran ♀', 'common', 'https://images.pokemontcg.io/base2/57_hires.png', 'grass'),
    (58, 'Oddish', 'common', 'https://images.pokemontcg.io/base2/58_hires.png', 'grass'),
    (59, 'Paras', 'common', 'https://images.pokemontcg.io/base2/59_hires.png', 'grass'),
    (60, 'Pikachu', 'common', 'https://images.pokemontcg.io/base2/60_hires.png', 'lightning'),
    (61, 'Rhyhorn', 'common', 'https://images.pokemontcg.io/base2/61_hires.png', 'fighting'),
    (62, 'Spearow', 'common', 'https://images.pokemontcg.io/base2/62_hires.png', 'colorless'),
    (63, 'Venonat', 'common', 'https://images.pokemontcg.io/base2/63_hires.png', 'grass'),
    (64, 'Poké Ball', 'common', 'https://images.pokemontcg.io/base2/64_hires.png', NULL)
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: Wizards Black Star Promos (basep) -- 1999/07/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('base', 'Base', 'wizards-black-star-promos', 'Wizards Black Star Promos', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'wizards-black-star-promos'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Pikachu', 'promo', 'https://images.pokemontcg.io/basep/1_hires.png', 'lightning'),
    (2, 'Electabuzz', 'promo', 'https://images.pokemontcg.io/basep/2_hires.png', 'lightning'),
    (3, 'Mewtwo', 'promo', 'https://images.pokemontcg.io/basep/3_hires.png', 'psychic'),
    (4, 'Pikachu', 'promo', 'https://images.pokemontcg.io/basep/4_hires.png', 'lightning'),
    (5, 'Dragonite', 'promo', 'https://images.pokemontcg.io/basep/5_hires.png', 'colorless'),
    (6, 'Arcanine', 'promo', 'https://images.pokemontcg.io/basep/6_hires.png', 'fire'),
    (7, 'Jigglypuff', 'promo', 'https://images.pokemontcg.io/basep/7_hires.png', 'colorless'),
    (8, 'Mew', 'promo', 'https://images.pokemontcg.io/basep/8_hires.png', 'psychic'),
    (9, 'Mew', 'promo', 'https://images.pokemontcg.io/basep/9_hires.png', 'psychic'),
    (10, 'Meowth', 'promo', 'https://images.pokemontcg.io/basep/10_hires.png', 'colorless'),
    (11, 'Eevee', 'promo', 'https://images.pokemontcg.io/basep/11_hires.png', 'colorless'),
    (12, 'Mewtwo', 'promo', 'https://images.pokemontcg.io/basep/12_hires.png', 'psychic'),
    (13, 'Venusaur', 'promo', 'https://images.pokemontcg.io/basep/13_hires.png', 'grass'),
    (14, 'Mewtwo', 'promo', 'https://images.pokemontcg.io/basep/14_hires.png', 'psychic'),
    (15, 'Cool Porygon', 'promo', 'https://images.pokemontcg.io/basep/15_hires.png', 'colorless'),
    (16, 'Computer Error', 'promo', 'https://images.pokemontcg.io/basep/16_hires.png', NULL),
    (17, 'Dark Persian', 'promo', 'https://images.pokemontcg.io/basep/17_hires.png', 'colorless'),
    (18, 'Team Rocket''s Meowth', 'promo', 'https://images.pokemontcg.io/basep/18_hires.png', 'colorless'),
    (19, 'Sabrina''s Abra', 'promo', 'https://images.pokemontcg.io/basep/19_hires.png', 'psychic'),
    (20, 'Psyduck', 'promo', 'https://images.pokemontcg.io/basep/20_hires.png', 'water'),
    (21, 'Moltres', 'promo', 'https://images.pokemontcg.io/basep/21_hires.png', 'fire'),
    (22, 'Articuno', 'promo', 'https://images.pokemontcg.io/basep/22_hires.png', 'water'),
    (23, 'Zapdos', 'promo', 'https://images.pokemontcg.io/basep/23_hires.png', 'lightning'),
    (24, '_____''s Pikachu', 'promo', 'https://images.pokemontcg.io/basep/24_hires.png', 'lightning'),
    (25, 'Flying Pikachu', 'promo', 'https://images.pokemontcg.io/basep/25_hires.png', 'lightning'),
    (26, 'Pikachu', 'promo', 'https://images.pokemontcg.io/basep/26_hires.png', 'lightning'),
    (27, 'Pikachu', 'promo', 'https://images.pokemontcg.io/basep/27_hires.png', 'lightning'),
    (28, 'Surfing Pikachu', 'promo', 'https://images.pokemontcg.io/basep/28_hires.png', 'lightning'),
    (29, 'Marill', 'promo', 'https://images.pokemontcg.io/basep/29_hires.png', 'water'),
    (30, 'Togepi', 'promo', 'https://images.pokemontcg.io/basep/30_hires.png', 'colorless'),
    (31, 'Cleffa', 'promo', 'https://images.pokemontcg.io/basep/31_hires.png', 'colorless'),
    (32, 'Smeargle', 'promo', 'https://images.pokemontcg.io/basep/32_hires.png', 'colorless'),
    (33, 'Scizor', 'promo', 'https://images.pokemontcg.io/basep/33_hires.png', 'metal'),
    (34, 'Entei', 'promo', 'https://images.pokemontcg.io/basep/34_hires.png', 'fire'),
    (35, 'Pichu', 'promo', 'https://images.pokemontcg.io/basep/35_hires.png', 'lightning'),
    (36, 'Igglybuff', 'promo', 'https://images.pokemontcg.io/basep/36_hires.png', 'colorless'),
    (37, 'Hitmontop', 'promo', 'https://images.pokemontcg.io/basep/37_hires.png', 'fighting'),
    (38, 'Unown [J]', 'promo', 'https://images.pokemontcg.io/basep/38_hires.png', 'psychic'),
    (39, 'Misdreavus', 'promo', 'https://images.pokemontcg.io/basep/39_hires.png', 'psychic'),
    (40, 'Pokémon Center', 'promo', 'https://images.pokemontcg.io/basep/40_hires.png', NULL),
    (41, 'Lucky Stadium', 'promo', 'https://images.pokemontcg.io/basep/41_hires.png', NULL),
    (42, 'Pokémon Tower', 'promo', 'https://images.pokemontcg.io/basep/42_hires.png', NULL),
    (43, 'Machamp', 'promo', 'https://images.pokemontcg.io/basep/43_hires.png', 'fighting'),
    (44, 'Magmar', 'promo', 'https://images.pokemontcg.io/basep/44_hires.png', 'fire'),
    (45, 'Scyther', 'promo', 'https://images.pokemontcg.io/basep/45_hires.png', 'grass'),
    (46, 'Electabuzz', 'promo', 'https://images.pokemontcg.io/basep/46_hires.png', 'lightning'),
    (47, 'Mew', 'promo', 'https://images.pokemontcg.io/basep/47_hires.png', 'psychic'),
    (48, 'Articuno', 'promo', 'https://images.pokemontcg.io/basep/48_hires.png', 'water'),
    (49, 'Snorlax', 'promo', 'https://images.pokemontcg.io/basep/49_hires.png', 'colorless'),
    (50, 'Celebi', 'promo', 'https://images.pokemontcg.io/basep/50_hires.png', 'grass'),
    (51, 'Rapidash', 'promo', 'https://images.pokemontcg.io/basep/51_hires.png', 'fire'),
    (52, 'Ho-oh', 'promo', 'https://images.pokemontcg.io/basep/52_hires.png', 'fire'),
    (53, 'Suicune', 'promo', 'https://images.pokemontcg.io/basep/53_hires.png', 'water')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: Fossil (base3) -- 1999/10/10
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('base', 'Base', 'fossil', 'Fossil', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'fossil'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Aerodactyl', 'rare', 'https://images.pokemontcg.io/base3/1_hires.png', 'fighting'),
    (2, 'Articuno', 'rare', 'https://images.pokemontcg.io/base3/2_hires.png', 'water'),
    (3, 'Ditto', 'rare', 'https://images.pokemontcg.io/base3/3_hires.png', 'colorless'),
    (4, 'Dragonite', 'rare', 'https://images.pokemontcg.io/base3/4_hires.png', 'colorless'),
    (5, 'Gengar', 'rare', 'https://images.pokemontcg.io/base3/5_hires.png', 'psychic'),
    (6, 'Haunter', 'rare', 'https://images.pokemontcg.io/base3/6_hires.png', 'psychic'),
    (7, 'Hitmonlee', 'rare', 'https://images.pokemontcg.io/base3/7_hires.png', 'fighting'),
    (8, 'Hypno', 'rare', 'https://images.pokemontcg.io/base3/8_hires.png', 'psychic'),
    (9, 'Kabutops', 'rare', 'https://images.pokemontcg.io/base3/9_hires.png', 'fighting'),
    (10, 'Lapras', 'rare', 'https://images.pokemontcg.io/base3/10_hires.png', 'water'),
    (11, 'Magneton', 'rare', 'https://images.pokemontcg.io/base3/11_hires.png', 'lightning'),
    (12, 'Moltres', 'rare', 'https://images.pokemontcg.io/base3/12_hires.png', 'fire'),
    (13, 'Muk', 'rare', 'https://images.pokemontcg.io/base3/13_hires.png', 'grass'),
    (14, 'Raichu', 'rare', 'https://images.pokemontcg.io/base3/14_hires.png', 'lightning'),
    (15, 'Zapdos', 'rare', 'https://images.pokemontcg.io/base3/15_hires.png', 'lightning'),
    (16, 'Aerodactyl', 'rare', 'https://images.pokemontcg.io/base3/16_hires.png', 'fighting'),
    (17, 'Articuno', 'rare', 'https://images.pokemontcg.io/base3/17_hires.png', 'water'),
    (18, 'Ditto', 'rare', 'https://images.pokemontcg.io/base3/18_hires.png', 'colorless'),
    (19, 'Dragonite', 'rare', 'https://images.pokemontcg.io/base3/19_hires.png', 'colorless'),
    (20, 'Gengar', 'rare', 'https://images.pokemontcg.io/base3/20_hires.png', 'psychic'),
    (21, 'Haunter', 'rare', 'https://images.pokemontcg.io/base3/21_hires.png', 'psychic'),
    (22, 'Hitmonlee', 'rare', 'https://images.pokemontcg.io/base3/22_hires.png', 'fighting'),
    (23, 'Hypno', 'rare', 'https://images.pokemontcg.io/base3/23_hires.png', 'psychic'),
    (24, 'Kabutops', 'rare', 'https://images.pokemontcg.io/base3/24_hires.png', 'fighting'),
    (25, 'Lapras', 'rare', 'https://images.pokemontcg.io/base3/25_hires.png', 'water'),
    (26, 'Magneton', 'rare', 'https://images.pokemontcg.io/base3/26_hires.png', 'lightning'),
    (27, 'Moltres', 'rare', 'https://images.pokemontcg.io/base3/27_hires.png', 'fire'),
    (28, 'Muk', 'rare', 'https://images.pokemontcg.io/base3/28_hires.png', 'grass'),
    (29, 'Raichu', 'rare', 'https://images.pokemontcg.io/base3/29_hires.png', 'lightning'),
    (30, 'Zapdos', 'rare', 'https://images.pokemontcg.io/base3/30_hires.png', 'lightning'),
    (31, 'Arbok', 'common', 'https://images.pokemontcg.io/base3/31_hires.png', 'grass'),
    (32, 'Cloyster', 'common', 'https://images.pokemontcg.io/base3/32_hires.png', 'water'),
    (33, 'Gastly', 'common', 'https://images.pokemontcg.io/base3/33_hires.png', 'psychic'),
    (34, 'Golbat', 'common', 'https://images.pokemontcg.io/base3/34_hires.png', 'grass'),
    (35, 'Golduck', 'common', 'https://images.pokemontcg.io/base3/35_hires.png', 'water'),
    (36, 'Golem', 'common', 'https://images.pokemontcg.io/base3/36_hires.png', 'fighting'),
    (37, 'Graveler', 'common', 'https://images.pokemontcg.io/base3/37_hires.png', 'fighting'),
    (38, 'Kingler', 'common', 'https://images.pokemontcg.io/base3/38_hires.png', 'water'),
    (39, 'Magmar', 'common', 'https://images.pokemontcg.io/base3/39_hires.png', 'fire'),
    (40, 'Omastar', 'common', 'https://images.pokemontcg.io/base3/40_hires.png', 'water'),
    (41, 'Sandslash', 'common', 'https://images.pokemontcg.io/base3/41_hires.png', 'fighting'),
    (42, 'Seadra', 'common', 'https://images.pokemontcg.io/base3/42_hires.png', 'water'),
    (43, 'Slowbro', 'common', 'https://images.pokemontcg.io/base3/43_hires.png', 'psychic'),
    (44, 'Tentacruel', 'common', 'https://images.pokemontcg.io/base3/44_hires.png', 'water'),
    (45, 'Weezing', 'common', 'https://images.pokemontcg.io/base3/45_hires.png', 'grass'),
    (46, 'Ekans', 'common', 'https://images.pokemontcg.io/base3/46_hires.png', 'grass'),
    (47, 'Geodude', 'common', 'https://images.pokemontcg.io/base3/47_hires.png', 'fighting'),
    (48, 'Grimer', 'common', 'https://images.pokemontcg.io/base3/48_hires.png', 'grass'),
    (49, 'Horsea', 'common', 'https://images.pokemontcg.io/base3/49_hires.png', 'water'),
    (50, 'Kabuto', 'common', 'https://images.pokemontcg.io/base3/50_hires.png', 'fighting'),
    (51, 'Krabby', 'common', 'https://images.pokemontcg.io/base3/51_hires.png', 'water'),
    (52, 'Omanyte', 'common', 'https://images.pokemontcg.io/base3/52_hires.png', 'water'),
    (53, 'Psyduck', 'common', 'https://images.pokemontcg.io/base3/53_hires.png', 'water'),
    (54, 'Shellder', 'common', 'https://images.pokemontcg.io/base3/54_hires.png', 'water'),
    (55, 'Slowpoke', 'common', 'https://images.pokemontcg.io/base3/55_hires.png', 'psychic'),
    (56, 'Tentacool', 'common', 'https://images.pokemontcg.io/base3/56_hires.png', 'water'),
    (57, 'Zubat', 'common', 'https://images.pokemontcg.io/base3/57_hires.png', 'grass'),
    (58, 'Mr. Fuji', 'common', 'https://images.pokemontcg.io/base3/58_hires.png', NULL),
    (59, 'Energy Search', 'common', 'https://images.pokemontcg.io/base3/59_hires.png', NULL),
    (60, 'Gambler', 'common', 'https://images.pokemontcg.io/base3/60_hires.png', NULL),
    (61, 'Recycle', 'common', 'https://images.pokemontcg.io/base3/61_hires.png', NULL),
    (62, 'Mysterious Fossil', 'common', 'https://images.pokemontcg.io/base3/62_hires.png', NULL)
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: Base Set 2 (base4) -- 2000/02/24
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('base', 'Base', 'base-set-2', 'Base Set 2', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'base-set-2'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Alakazam', 'rare', 'https://images.pokemontcg.io/base4/1_hires.png', 'psychic'),
    (2, 'Blastoise', 'rare', 'https://images.pokemontcg.io/base4/2_hires.png', 'water'),
    (3, 'Chansey', 'rare', 'https://images.pokemontcg.io/base4/3_hires.png', 'colorless'),
    (4, 'Charizard', 'rare', 'https://images.pokemontcg.io/base4/4_hires.png', 'fire'),
    (5, 'Clefable', 'rare', 'https://images.pokemontcg.io/base4/5_hires.png', 'colorless'),
    (6, 'Clefairy', 'rare', 'https://images.pokemontcg.io/base4/6_hires.png', 'colorless'),
    (7, 'Gyarados', 'rare', 'https://images.pokemontcg.io/base4/7_hires.png', 'water'),
    (8, 'Hitmonchan', 'rare', 'https://images.pokemontcg.io/base4/8_hires.png', 'fighting'),
    (9, 'Magneton', 'rare', 'https://images.pokemontcg.io/base4/9_hires.png', 'lightning'),
    (10, 'Mewtwo', 'rare', 'https://images.pokemontcg.io/base4/10_hires.png', 'psychic'),
    (11, 'Nidoking', 'rare', 'https://images.pokemontcg.io/base4/11_hires.png', 'grass'),
    (12, 'Nidoqueen', 'rare', 'https://images.pokemontcg.io/base4/12_hires.png', 'grass'),
    (13, 'Ninetales', 'rare', 'https://images.pokemontcg.io/base4/13_hires.png', 'fire'),
    (14, 'Pidgeot', 'rare', 'https://images.pokemontcg.io/base4/14_hires.png', 'colorless'),
    (15, 'Poliwrath', 'rare', 'https://images.pokemontcg.io/base4/15_hires.png', 'water'),
    (16, 'Raichu', 'rare', 'https://images.pokemontcg.io/base4/16_hires.png', 'lightning'),
    (17, 'Scyther', 'rare', 'https://images.pokemontcg.io/base4/17_hires.png', 'grass'),
    (18, 'Venusaur', 'rare', 'https://images.pokemontcg.io/base4/18_hires.png', 'grass'),
    (19, 'Wigglytuff', 'rare', 'https://images.pokemontcg.io/base4/19_hires.png', 'colorless'),
    (20, 'Zapdos', 'rare', 'https://images.pokemontcg.io/base4/20_hires.png', 'lightning'),
    (21, 'Beedrill', 'rare', 'https://images.pokemontcg.io/base4/21_hires.png', 'grass'),
    (22, 'Dragonair', 'rare', 'https://images.pokemontcg.io/base4/22_hires.png', 'colorless'),
    (23, 'Dugtrio', 'rare', 'https://images.pokemontcg.io/base4/23_hires.png', 'fighting'),
    (24, 'Electabuzz', 'rare', 'https://images.pokemontcg.io/base4/24_hires.png', 'lightning'),
    (25, 'Electrode', 'rare', 'https://images.pokemontcg.io/base4/25_hires.png', 'lightning'),
    (26, 'Kangaskhan', 'rare', 'https://images.pokemontcg.io/base4/26_hires.png', 'colorless'),
    (27, 'Mr. Mime', 'rare', 'https://images.pokemontcg.io/base4/27_hires.png', 'psychic'),
    (28, 'Pidgeotto', 'rare', 'https://images.pokemontcg.io/base4/28_hires.png', 'colorless'),
    (29, 'Pinsir', 'rare', 'https://images.pokemontcg.io/base4/29_hires.png', 'grass'),
    (30, 'Snorlax', 'rare', 'https://images.pokemontcg.io/base4/30_hires.png', 'colorless'),
    (31, 'Venomoth', 'rare', 'https://images.pokemontcg.io/base4/31_hires.png', 'grass'),
    (32, 'Victreebel', 'rare', 'https://images.pokemontcg.io/base4/32_hires.png', 'grass'),
    (33, 'Arcanine', 'common', 'https://images.pokemontcg.io/base4/33_hires.png', 'fire'),
    (34, 'Butterfree', 'common', 'https://images.pokemontcg.io/base4/34_hires.png', 'grass'),
    (35, 'Charmeleon', 'common', 'https://images.pokemontcg.io/base4/35_hires.png', 'fire'),
    (36, 'Dewgong', 'common', 'https://images.pokemontcg.io/base4/36_hires.png', 'water'),
    (37, 'Dodrio', 'common', 'https://images.pokemontcg.io/base4/37_hires.png', 'colorless'),
    (38, 'Dratini', 'common', 'https://images.pokemontcg.io/base4/38_hires.png', 'colorless'),
    (39, 'Exeggutor', 'common', 'https://images.pokemontcg.io/base4/39_hires.png', 'grass'),
    (40, 'Farfetch''d', 'common', 'https://images.pokemontcg.io/base4/40_hires.png', 'colorless'),
    (41, 'Fearow', 'common', 'https://images.pokemontcg.io/base4/41_hires.png', 'colorless'),
    (42, 'Growlithe', 'common', 'https://images.pokemontcg.io/base4/42_hires.png', 'fire'),
    (43, 'Haunter', 'common', 'https://images.pokemontcg.io/base4/43_hires.png', 'psychic'),
    (44, 'Ivysaur', 'common', 'https://images.pokemontcg.io/base4/44_hires.png', 'grass'),
    (45, 'Jynx', 'common', 'https://images.pokemontcg.io/base4/45_hires.png', 'psychic'),
    (46, 'Kadabra', 'common', 'https://images.pokemontcg.io/base4/46_hires.png', 'psychic'),
    (47, 'Kakuna', 'common', 'https://images.pokemontcg.io/base4/47_hires.png', 'grass'),
    (48, 'Lickitung', 'common', 'https://images.pokemontcg.io/base4/48_hires.png', 'colorless'),
    (49, 'Machoke', 'common', 'https://images.pokemontcg.io/base4/49_hires.png', 'fighting'),
    (50, 'Magikarp', 'common', 'https://images.pokemontcg.io/base4/50_hires.png', 'water'),
    (51, 'Magmar', 'common', 'https://images.pokemontcg.io/base4/51_hires.png', 'fire'),
    (52, 'Marowak', 'common', 'https://images.pokemontcg.io/base4/52_hires.png', 'fighting'),
    (53, 'Nidorina', 'common', 'https://images.pokemontcg.io/base4/53_hires.png', 'grass'),
    (54, 'Nidorino', 'common', 'https://images.pokemontcg.io/base4/54_hires.png', 'grass'),
    (55, 'Parasect', 'common', 'https://images.pokemontcg.io/base4/55_hires.png', 'grass'),
    (56, 'Persian', 'common', 'https://images.pokemontcg.io/base4/56_hires.png', 'colorless'),
    (57, 'Poliwhirl', 'common', 'https://images.pokemontcg.io/base4/57_hires.png', 'water'),
    (58, 'Raticate', 'common', 'https://images.pokemontcg.io/base4/58_hires.png', 'colorless'),
    (59, 'Rhydon', 'common', 'https://images.pokemontcg.io/base4/59_hires.png', 'fighting'),
    (60, 'Seaking', 'common', 'https://images.pokemontcg.io/base4/60_hires.png', 'water'),
    (61, 'Seel', 'common', 'https://images.pokemontcg.io/base4/61_hires.png', 'water'),
    (62, 'Tauros', 'common', 'https://images.pokemontcg.io/base4/62_hires.png', 'colorless'),
    (63, 'Wartortle', 'common', 'https://images.pokemontcg.io/base4/63_hires.png', 'water'),
    (64, 'Weepinbell', 'common', 'https://images.pokemontcg.io/base4/64_hires.png', 'grass'),
    (65, 'Abra', 'common', 'https://images.pokemontcg.io/base4/65_hires.png', 'psychic'),
    (66, 'Bellsprout', 'common', 'https://images.pokemontcg.io/base4/66_hires.png', 'grass'),
    (67, 'Bulbasaur', 'common', 'https://images.pokemontcg.io/base4/67_hires.png', 'grass'),
    (68, 'Caterpie', 'common', 'https://images.pokemontcg.io/base4/68_hires.png', 'grass'),
    (69, 'Charmander', 'common', 'https://images.pokemontcg.io/base4/69_hires.png', 'fire'),
    (70, 'Cubone', 'common', 'https://images.pokemontcg.io/base4/70_hires.png', 'fighting'),
    (71, 'Diglett', 'common', 'https://images.pokemontcg.io/base4/71_hires.png', 'fighting'),
    (72, 'Doduo', 'common', 'https://images.pokemontcg.io/base4/72_hires.png', 'colorless'),
    (73, 'Drowzee', 'common', 'https://images.pokemontcg.io/base4/73_hires.png', 'psychic'),
    (74, 'Exeggcute', 'common', 'https://images.pokemontcg.io/base4/74_hires.png', 'grass'),
    (75, 'Gastly', 'common', 'https://images.pokemontcg.io/base4/75_hires.png', 'psychic'),
    (76, 'Goldeen', 'common', 'https://images.pokemontcg.io/base4/76_hires.png', 'water'),
    (77, 'Jigglypuff', 'common', 'https://images.pokemontcg.io/base4/77_hires.png', 'colorless'),
    (78, 'Machop', 'common', 'https://images.pokemontcg.io/base4/78_hires.png', 'fighting'),
    (79, 'Magnemite', 'common', 'https://images.pokemontcg.io/base4/79_hires.png', 'lightning'),
    (80, 'Meowth', 'common', 'https://images.pokemontcg.io/base4/80_hires.png', 'colorless'),
    (81, 'Metapod', 'common', 'https://images.pokemontcg.io/base4/81_hires.png', 'grass'),
    (82, 'Nidoran ♀', 'common', 'https://images.pokemontcg.io/base4/82_hires.png', 'grass'),
    (83, 'Nidoran ♂', 'common', 'https://images.pokemontcg.io/base4/83_hires.png', 'grass'),
    (84, 'Onix', 'common', 'https://images.pokemontcg.io/base4/84_hires.png', 'fighting'),
    (85, 'Paras', 'common', 'https://images.pokemontcg.io/base4/85_hires.png', 'grass'),
    (86, 'Pidgey', 'common', 'https://images.pokemontcg.io/base4/86_hires.png', 'colorless'),
    (87, 'Pikachu', 'common', 'https://images.pokemontcg.io/base4/87_hires.png', 'lightning'),
    (88, 'Poliwag', 'common', 'https://images.pokemontcg.io/base4/88_hires.png', 'water'),
    (89, 'Rattata', 'common', 'https://images.pokemontcg.io/base4/89_hires.png', 'colorless'),
    (90, 'Rhyhorn', 'common', 'https://images.pokemontcg.io/base4/90_hires.png', 'fighting'),
    (91, 'Sandshrew', 'common', 'https://images.pokemontcg.io/base4/91_hires.png', 'fighting'),
    (92, 'Spearow', 'common', 'https://images.pokemontcg.io/base4/92_hires.png', 'colorless'),
    (93, 'Squirtle', 'common', 'https://images.pokemontcg.io/base4/93_hires.png', 'water'),
    (94, 'Starmie', 'common', 'https://images.pokemontcg.io/base4/94_hires.png', 'water'),
    (95, 'Staryu', 'common', 'https://images.pokemontcg.io/base4/95_hires.png', 'water'),
    (96, 'Tangela', 'common', 'https://images.pokemontcg.io/base4/96_hires.png', 'grass'),
    (97, 'Venonat', 'common', 'https://images.pokemontcg.io/base4/97_hires.png', 'grass'),
    (98, 'Voltorb', 'common', 'https://images.pokemontcg.io/base4/98_hires.png', 'lightning'),
    (99, 'Vulpix', 'common', 'https://images.pokemontcg.io/base4/99_hires.png', 'fire'),
    (100, 'Weedle', 'common', 'https://images.pokemontcg.io/base4/100_hires.png', 'grass'),
    (101, 'Computer Search', 'rare', 'https://images.pokemontcg.io/base4/101_hires.png', NULL),
    (102, 'Imposter Professor Oak', 'rare', 'https://images.pokemontcg.io/base4/102_hires.png', NULL),
    (103, 'Item Finder', 'rare', 'https://images.pokemontcg.io/base4/103_hires.png', NULL),
    (104, 'Lass', 'rare', 'https://images.pokemontcg.io/base4/104_hires.png', NULL),
    (105, 'Pokémon Breeder', 'rare', 'https://images.pokemontcg.io/base4/105_hires.png', NULL),
    (106, 'Pokémon Trader', 'rare', 'https://images.pokemontcg.io/base4/106_hires.png', NULL),
    (107, 'Scoop Up', 'rare', 'https://images.pokemontcg.io/base4/107_hires.png', NULL),
    (108, 'Super Energy Removal', 'rare', 'https://images.pokemontcg.io/base4/108_hires.png', NULL),
    (109, 'Defender', 'common', 'https://images.pokemontcg.io/base4/109_hires.png', NULL),
    (110, 'Energy Retrieval', 'common', 'https://images.pokemontcg.io/base4/110_hires.png', NULL),
    (111, 'Full Heal', 'common', 'https://images.pokemontcg.io/base4/111_hires.png', NULL),
    (112, 'Maintenance', 'common', 'https://images.pokemontcg.io/base4/112_hires.png', NULL),
    (113, 'PlusPower', 'common', 'https://images.pokemontcg.io/base4/113_hires.png', NULL),
    (114, 'Pokémon Center', 'common', 'https://images.pokemontcg.io/base4/114_hires.png', NULL),
    (115, 'Pokédex', 'common', 'https://images.pokemontcg.io/base4/115_hires.png', NULL),
    (116, 'Professor Oak', 'common', 'https://images.pokemontcg.io/base4/116_hires.png', NULL),
    (117, 'Super Potion', 'common', 'https://images.pokemontcg.io/base4/117_hires.png', NULL),
    (118, 'Bill', 'common', 'https://images.pokemontcg.io/base4/118_hires.png', NULL),
    (119, 'Energy Removal', 'common', 'https://images.pokemontcg.io/base4/119_hires.png', NULL),
    (120, 'Gust of Wind', 'common', 'https://images.pokemontcg.io/base4/120_hires.png', NULL),
    (121, 'Poké Ball', 'common', 'https://images.pokemontcg.io/base4/121_hires.png', NULL),
    (122, 'Potion', 'common', 'https://images.pokemontcg.io/base4/122_hires.png', NULL),
    (123, 'Switch', 'common', 'https://images.pokemontcg.io/base4/123_hires.png', NULL),
    (124, 'Double Colorless Energy', 'common', 'https://images.pokemontcg.io/base4/124_hires.png', NULL),
    (125, 'Fighting Energy', 'base', 'https://images.pokemontcg.io/base4/125_hires.png', NULL),
    (126, 'Fire Energy', 'base', 'https://images.pokemontcg.io/base4/126_hires.png', NULL),
    (127, 'Grass Energy', 'base', 'https://images.pokemontcg.io/base4/127_hires.png', NULL),
    (128, 'Lightning Energy', 'base', 'https://images.pokemontcg.io/base4/128_hires.png', NULL),
    (129, 'Psychic Energy', 'base', 'https://images.pokemontcg.io/base4/129_hires.png', NULL),
    (130, 'Water Energy', 'base', 'https://images.pokemontcg.io/base4/130_hires.png', NULL)
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: Team Rocket (base5) -- 2000/04/24
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('base', 'Base', 'team-rocket', 'Team Rocket', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'team-rocket'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Dark Alakazam', 'rare', 'https://images.pokemontcg.io/base5/1_hires.png', 'psychic'),
    (2, 'Dark Arbok', 'rare', 'https://images.pokemontcg.io/base5/2_hires.png', 'grass'),
    (3, 'Dark Blastoise', 'rare', 'https://images.pokemontcg.io/base5/3_hires.png', 'water'),
    (4, 'Dark Charizard', 'rare', 'https://images.pokemontcg.io/base5/4_hires.png', 'fire'),
    (5, 'Dark Dragonite', 'rare', 'https://images.pokemontcg.io/base5/5_hires.png', 'colorless'),
    (6, 'Dark Dugtrio', 'rare', 'https://images.pokemontcg.io/base5/6_hires.png', 'fighting'),
    (7, 'Dark Golbat', 'rare', 'https://images.pokemontcg.io/base5/7_hires.png', 'grass'),
    (8, 'Dark Gyarados', 'rare', 'https://images.pokemontcg.io/base5/8_hires.png', 'water'),
    (9, 'Dark Hypno', 'rare', 'https://images.pokemontcg.io/base5/9_hires.png', 'psychic'),
    (10, 'Dark Machamp', 'rare', 'https://images.pokemontcg.io/base5/10_hires.png', 'fighting'),
    (11, 'Dark Magneton', 'rare', 'https://images.pokemontcg.io/base5/11_hires.png', 'lightning'),
    (12, 'Dark Slowbro', 'rare', 'https://images.pokemontcg.io/base5/12_hires.png', 'psychic'),
    (13, 'Dark Vileplume', 'rare', 'https://images.pokemontcg.io/base5/13_hires.png', 'grass'),
    (14, 'Dark Weezing', 'rare', 'https://images.pokemontcg.io/base5/14_hires.png', 'grass'),
    (15, 'Here Comes Team Rocket!', 'rare', 'https://images.pokemontcg.io/base5/15_hires.png', NULL),
    (16, 'Rocket''s Sneak Attack', 'rare', 'https://images.pokemontcg.io/base5/16_hires.png', NULL),
    (17, 'Rainbow Energy', 'rare', 'https://images.pokemontcg.io/base5/17_hires.png', NULL),
    (18, 'Dark Alakazam', 'rare', 'https://images.pokemontcg.io/base5/18_hires.png', 'psychic'),
    (19, 'Dark Arbok', 'rare', 'https://images.pokemontcg.io/base5/19_hires.png', 'grass'),
    (20, 'Dark Blastoise', 'rare', 'https://images.pokemontcg.io/base5/20_hires.png', 'water'),
    (21, 'Dark Charizard', 'rare', 'https://images.pokemontcg.io/base5/21_hires.png', 'fire'),
    (22, 'Dark Dragonite', 'rare', 'https://images.pokemontcg.io/base5/22_hires.png', 'colorless'),
    (23, 'Dark Dugtrio', 'rare', 'https://images.pokemontcg.io/base5/23_hires.png', 'fighting'),
    (24, 'Dark Golbat', 'rare', 'https://images.pokemontcg.io/base5/24_hires.png', 'grass'),
    (25, 'Dark Gyarados', 'rare', 'https://images.pokemontcg.io/base5/25_hires.png', 'water'),
    (26, 'Dark Hypno', 'rare', 'https://images.pokemontcg.io/base5/26_hires.png', 'psychic'),
    (27, 'Dark Machamp', 'rare', 'https://images.pokemontcg.io/base5/27_hires.png', 'fighting'),
    (28, 'Dark Magneton', 'rare', 'https://images.pokemontcg.io/base5/28_hires.png', 'lightning'),
    (29, 'Dark Slowbro', 'rare', 'https://images.pokemontcg.io/base5/29_hires.png', 'psychic'),
    (30, 'Dark Vileplume', 'rare', 'https://images.pokemontcg.io/base5/30_hires.png', 'grass'),
    (31, 'Dark Weezing', 'rare', 'https://images.pokemontcg.io/base5/31_hires.png', 'grass'),
    (32, 'Dark Charmeleon', 'common', 'https://images.pokemontcg.io/base5/32_hires.png', 'fire'),
    (33, 'Dark Dragonair', 'common', 'https://images.pokemontcg.io/base5/33_hires.png', 'colorless'),
    (34, 'Dark Electrode', 'common', 'https://images.pokemontcg.io/base5/34_hires.png', 'lightning'),
    (35, 'Dark Flareon', 'common', 'https://images.pokemontcg.io/base5/35_hires.png', 'fire'),
    (36, 'Dark Gloom', 'common', 'https://images.pokemontcg.io/base5/36_hires.png', 'grass'),
    (37, 'Dark Golduck', 'common', 'https://images.pokemontcg.io/base5/37_hires.png', 'water'),
    (38, 'Dark Jolteon', 'common', 'https://images.pokemontcg.io/base5/38_hires.png', 'lightning'),
    (39, 'Dark Kadabra', 'common', 'https://images.pokemontcg.io/base5/39_hires.png', 'psychic'),
    (40, 'Dark Machoke', 'common', 'https://images.pokemontcg.io/base5/40_hires.png', 'fighting'),
    (41, 'Dark Muk', 'common', 'https://images.pokemontcg.io/base5/41_hires.png', 'grass'),
    (42, 'Dark Persian', 'common', 'https://images.pokemontcg.io/base5/42_hires.png', 'colorless'),
    (43, 'Dark Primeape', 'common', 'https://images.pokemontcg.io/base5/43_hires.png', 'fighting'),
    (44, 'Dark Rapidash', 'common', 'https://images.pokemontcg.io/base5/44_hires.png', 'fire'),
    (45, 'Dark Vaporeon', 'common', 'https://images.pokemontcg.io/base5/45_hires.png', 'water'),
    (46, 'Dark Wartortle', 'common', 'https://images.pokemontcg.io/base5/46_hires.png', 'water'),
    (47, 'Magikarp', 'common', 'https://images.pokemontcg.io/base5/47_hires.png', 'water'),
    (48, 'Porygon', 'common', 'https://images.pokemontcg.io/base5/48_hires.png', 'colorless'),
    (49, 'Abra', 'common', 'https://images.pokemontcg.io/base5/49_hires.png', 'psychic'),
    (50, 'Charmander', 'common', 'https://images.pokemontcg.io/base5/50_hires.png', 'fire'),
    (51, 'Dark Raticate', 'common', 'https://images.pokemontcg.io/base5/51_hires.png', 'colorless'),
    (52, 'Diglett', 'common', 'https://images.pokemontcg.io/base5/52_hires.png', 'fighting'),
    (53, 'Dratini', 'common', 'https://images.pokemontcg.io/base5/53_hires.png', 'colorless'),
    (54, 'Drowzee', 'common', 'https://images.pokemontcg.io/base5/54_hires.png', 'psychic'),
    (55, 'Eevee', 'common', 'https://images.pokemontcg.io/base5/55_hires.png', 'colorless'),
    (56, 'Ekans', 'common', 'https://images.pokemontcg.io/base5/56_hires.png', 'grass'),
    (57, 'Grimer', 'common', 'https://images.pokemontcg.io/base5/57_hires.png', 'grass'),
    (58, 'Koffing', 'common', 'https://images.pokemontcg.io/base5/58_hires.png', 'grass'),
    (59, 'Machop', 'common', 'https://images.pokemontcg.io/base5/59_hires.png', 'fighting'),
    (60, 'Magnemite', 'common', 'https://images.pokemontcg.io/base5/60_hires.png', 'lightning'),
    (61, 'Mankey', 'common', 'https://images.pokemontcg.io/base5/61_hires.png', 'fighting'),
    (62, 'Meowth', 'common', 'https://images.pokemontcg.io/base5/62_hires.png', 'colorless'),
    (63, 'Oddish', 'common', 'https://images.pokemontcg.io/base5/63_hires.png', 'grass'),
    (64, 'Ponyta', 'common', 'https://images.pokemontcg.io/base5/64_hires.png', 'fire'),
    (65, 'Psyduck', 'common', 'https://images.pokemontcg.io/base5/65_hires.png', 'water'),
    (66, 'Rattata', 'common', 'https://images.pokemontcg.io/base5/66_hires.png', 'colorless'),
    (67, 'Slowpoke', 'common', 'https://images.pokemontcg.io/base5/67_hires.png', 'psychic'),
    (68, 'Squirtle', 'common', 'https://images.pokemontcg.io/base5/68_hires.png', 'water'),
    (69, 'Voltorb', 'common', 'https://images.pokemontcg.io/base5/69_hires.png', 'lightning'),
    (70, 'Zubat', 'common', 'https://images.pokemontcg.io/base5/70_hires.png', 'grass'),
    (71, 'Here Comes Team Rocket!', 'rare', 'https://images.pokemontcg.io/base5/71_hires.png', NULL),
    (72, 'Rocket''s Sneak Attack', 'rare', 'https://images.pokemontcg.io/base5/72_hires.png', NULL),
    (73, 'The Boss''s Way', 'common', 'https://images.pokemontcg.io/base5/73_hires.png', NULL),
    (74, 'Challenge!', 'common', 'https://images.pokemontcg.io/base5/74_hires.png', NULL),
    (75, 'Digger', 'common', 'https://images.pokemontcg.io/base5/75_hires.png', NULL),
    (76, 'Imposter Oak''s Revenge', 'common', 'https://images.pokemontcg.io/base5/76_hires.png', NULL),
    (77, 'Nightly Garbage Run', 'common', 'https://images.pokemontcg.io/base5/77_hires.png', NULL),
    (78, 'Goop Gas Attack', 'common', 'https://images.pokemontcg.io/base5/78_hires.png', NULL),
    (79, 'Sleep!', 'common', 'https://images.pokemontcg.io/base5/79_hires.png', NULL),
    (80, 'Rainbow Energy', 'rare', 'https://images.pokemontcg.io/base5/80_hires.png', NULL),
    (81, 'Full Heal Energy', 'common', 'https://images.pokemontcg.io/base5/81_hires.png', NULL),
    (82, 'Potion Energy', 'common', 'https://images.pokemontcg.io/base5/82_hires.png', NULL),
    (83, 'Dark Raichu', 'mega_hyper_rare', 'https://images.pokemontcg.io/base5/83_hires.png', 'lightning')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
) as x(variant)
on conflict (card_id, variant) do nothing;
