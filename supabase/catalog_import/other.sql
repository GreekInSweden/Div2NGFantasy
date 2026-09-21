-- Katalogimport: Other (15 set)
-- Endast katalogdata (lager 0, pris 0) för portfölj/önskelista-funktionen.

-- Set: Southern Islands (si1) -- 2001/07/31
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'southern-islands', 'Southern Islands', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'southern-islands'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Mew', 'base', 'https://images.pokemontcg.io/si1/1_hires.png', 'psychic'),
    (2, 'Pidgeot', 'base', 'https://images.pokemontcg.io/si1/2_hires.png', 'colorless'),
    (3, 'Onix', 'base', 'https://images.pokemontcg.io/si1/3_hires.png', 'fighting'),
    (4, 'Togepi', 'base', 'https://images.pokemontcg.io/si1/4_hires.png', 'colorless'),
    (5, 'Ivysaur', 'base', 'https://images.pokemontcg.io/si1/5_hires.png', 'grass'),
    (6, 'Raticate', 'base', 'https://images.pokemontcg.io/si1/6_hires.png', 'colorless'),
    (7, 'Ledyba', 'base', 'https://images.pokemontcg.io/si1/7_hires.png', 'grass'),
    (8, 'Jigglypuff', 'base', 'https://images.pokemontcg.io/si1/8_hires.png', 'colorless'),
    (9, 'Butterfree', 'base', 'https://images.pokemontcg.io/si1/9_hires.png', 'grass'),
    (10, 'Tentacruel', 'base', 'https://images.pokemontcg.io/si1/10_hires.png', 'water'),
    (11, 'Marill', 'base', 'https://images.pokemontcg.io/si1/11_hires.png', 'water'),
    (12, 'Lapras', 'base', 'https://images.pokemontcg.io/si1/12_hires.png', 'water'),
    (13, 'Exeggutor', 'base', 'https://images.pokemontcg.io/si1/13_hires.png', 'grass'),
    (14, 'Slowking', 'base', 'https://images.pokemontcg.io/si1/14_hires.png', 'psychic'),
    (15, 'Wartortle', 'base', 'https://images.pokemontcg.io/si1/15_hires.png', 'water'),
    (16, 'Lickitung', 'base', 'https://images.pokemontcg.io/si1/16_hires.png', 'colorless'),
    (17, 'Vileplume', 'base', 'https://images.pokemontcg.io/si1/17_hires.png', 'grass'),
    (18, 'Primeape', 'base', 'https://images.pokemontcg.io/si1/18_hires.png', 'fighting')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: Legendary Collection (base6) -- 2002/05/24
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'legendary-collection', 'Legendary Collection', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'legendary-collection'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Alakazam', 'rare', 'https://images.pokemontcg.io/base6/1_hires.png', 'psychic'),
    (2, 'Articuno', 'rare', 'https://images.pokemontcg.io/base6/2_hires.png', 'water'),
    (3, 'Charizard', 'rare', 'https://images.pokemontcg.io/base6/3_hires.png', 'fire'),
    (4, 'Dark Blastoise', 'rare', 'https://images.pokemontcg.io/base6/4_hires.png', 'water'),
    (5, 'Dark Dragonite', 'rare', 'https://images.pokemontcg.io/base6/5_hires.png', 'colorless'),
    (6, 'Dark Persian', 'rare', 'https://images.pokemontcg.io/base6/6_hires.png', 'colorless'),
    (7, 'Dark Raichu', 'rare', 'https://images.pokemontcg.io/base6/7_hires.png', 'lightning'),
    (8, 'Dark Slowbro', 'rare', 'https://images.pokemontcg.io/base6/8_hires.png', 'psychic'),
    (9, 'Dark Vaporeon', 'rare', 'https://images.pokemontcg.io/base6/9_hires.png', 'water'),
    (10, 'Flareon', 'rare', 'https://images.pokemontcg.io/base6/10_hires.png', 'fire'),
    (11, 'Gengar', 'rare', 'https://images.pokemontcg.io/base6/11_hires.png', 'psychic'),
    (12, 'Gyarados', 'rare', 'https://images.pokemontcg.io/base6/12_hires.png', 'water'),
    (13, 'Hitmonlee', 'rare', 'https://images.pokemontcg.io/base6/13_hires.png', 'fighting'),
    (14, 'Jolteon', 'rare', 'https://images.pokemontcg.io/base6/14_hires.png', 'lightning'),
    (15, 'Machamp', 'rare', 'https://images.pokemontcg.io/base6/15_hires.png', 'fighting'),
    (16, 'Muk', 'rare', 'https://images.pokemontcg.io/base6/16_hires.png', 'grass'),
    (17, 'Ninetales', 'rare', 'https://images.pokemontcg.io/base6/17_hires.png', 'fire'),
    (18, 'Venusaur', 'rare', 'https://images.pokemontcg.io/base6/18_hires.png', 'grass'),
    (19, 'Zapdos', 'rare', 'https://images.pokemontcg.io/base6/19_hires.png', 'lightning'),
    (20, 'Beedrill', 'rare', 'https://images.pokemontcg.io/base6/20_hires.png', 'grass'),
    (21, 'Butterfree', 'rare', 'https://images.pokemontcg.io/base6/21_hires.png', 'grass'),
    (22, 'Electrode', 'rare', 'https://images.pokemontcg.io/base6/22_hires.png', 'lightning'),
    (23, 'Exeggutor', 'rare', 'https://images.pokemontcg.io/base6/23_hires.png', 'grass'),
    (24, 'Golem', 'rare', 'https://images.pokemontcg.io/base6/24_hires.png', 'fighting'),
    (25, 'Hypno', 'rare', 'https://images.pokemontcg.io/base6/25_hires.png', 'psychic'),
    (26, 'Jynx', 'rare', 'https://images.pokemontcg.io/base6/26_hires.png', 'psychic'),
    (27, 'Kabutops', 'rare', 'https://images.pokemontcg.io/base6/27_hires.png', 'fighting'),
    (28, 'Magneton', 'rare', 'https://images.pokemontcg.io/base6/28_hires.png', 'lightning'),
    (29, 'Mewtwo', 'rare', 'https://images.pokemontcg.io/base6/29_hires.png', 'psychic'),
    (30, 'Moltres', 'rare', 'https://images.pokemontcg.io/base6/30_hires.png', 'fire'),
    (31, 'Nidoking', 'rare', 'https://images.pokemontcg.io/base6/31_hires.png', 'grass'),
    (32, 'Nidoqueen', 'rare', 'https://images.pokemontcg.io/base6/32_hires.png', 'grass'),
    (33, 'Pidgeot', 'rare', 'https://images.pokemontcg.io/base6/33_hires.png', 'colorless'),
    (34, 'Pidgeotto', 'rare', 'https://images.pokemontcg.io/base6/34_hires.png', 'colorless'),
    (35, 'Rhydon', 'rare', 'https://images.pokemontcg.io/base6/35_hires.png', 'fighting'),
    (36, 'Arcanine', 'common', 'https://images.pokemontcg.io/base6/36_hires.png', 'fire'),
    (37, 'Charmeleon', 'common', 'https://images.pokemontcg.io/base6/37_hires.png', 'fire'),
    (38, 'Dark Dragonair', 'common', 'https://images.pokemontcg.io/base6/38_hires.png', 'colorless'),
    (39, 'Dark Wartortle', 'common', 'https://images.pokemontcg.io/base6/39_hires.png', 'water'),
    (40, 'Dewgong', 'common', 'https://images.pokemontcg.io/base6/40_hires.png', 'water'),
    (41, 'Dodrio', 'common', 'https://images.pokemontcg.io/base6/41_hires.png', 'colorless'),
    (42, 'Fearow', 'common', 'https://images.pokemontcg.io/base6/42_hires.png', 'colorless'),
    (43, 'Golduck', 'common', 'https://images.pokemontcg.io/base6/43_hires.png', 'water'),
    (44, 'Graveler', 'common', 'https://images.pokemontcg.io/base6/44_hires.png', 'fighting'),
    (45, 'Growlithe', 'common', 'https://images.pokemontcg.io/base6/45_hires.png', 'fire'),
    (46, 'Haunter', 'common', 'https://images.pokemontcg.io/base6/46_hires.png', 'psychic'),
    (47, 'Ivysaur', 'common', 'https://images.pokemontcg.io/base6/47_hires.png', 'grass'),
    (48, 'Kabuto', 'common', 'https://images.pokemontcg.io/base6/48_hires.png', 'fighting'),
    (49, 'Kadabra', 'common', 'https://images.pokemontcg.io/base6/49_hires.png', 'psychic'),
    (50, 'Kakuna', 'common', 'https://images.pokemontcg.io/base6/50_hires.png', 'grass'),
    (51, 'Machoke', 'common', 'https://images.pokemontcg.io/base6/51_hires.png', 'fighting'),
    (52, 'Magikarp', 'common', 'https://images.pokemontcg.io/base6/52_hires.png', 'water'),
    (53, 'Meowth', 'common', 'https://images.pokemontcg.io/base6/53_hires.png', 'colorless'),
    (54, 'Metapod', 'common', 'https://images.pokemontcg.io/base6/54_hires.png', 'grass'),
    (55, 'Nidorina', 'common', 'https://images.pokemontcg.io/base6/55_hires.png', 'grass'),
    (56, 'Nidorino', 'common', 'https://images.pokemontcg.io/base6/56_hires.png', 'grass'),
    (57, 'Omanyte', 'common', 'https://images.pokemontcg.io/base6/57_hires.png', 'water'),
    (58, 'Omastar', 'common', 'https://images.pokemontcg.io/base6/58_hires.png', 'water'),
    (59, 'Primeape', 'common', 'https://images.pokemontcg.io/base6/59_hires.png', 'fighting'),
    (60, 'Rapidash', 'common', 'https://images.pokemontcg.io/base6/60_hires.png', 'fire'),
    (61, 'Raticate', 'common', 'https://images.pokemontcg.io/base6/61_hires.png', 'colorless'),
    (62, 'Sandslash', 'common', 'https://images.pokemontcg.io/base6/62_hires.png', 'fighting'),
    (63, 'Seadra', 'common', 'https://images.pokemontcg.io/base6/63_hires.png', 'water'),
    (64, 'Snorlax', 'common', 'https://images.pokemontcg.io/base6/64_hires.png', 'colorless'),
    (65, 'Tauros', 'common', 'https://images.pokemontcg.io/base6/65_hires.png', 'colorless'),
    (66, 'Tentacruel', 'common', 'https://images.pokemontcg.io/base6/66_hires.png', 'water'),
    (67, 'Abra', 'common', 'https://images.pokemontcg.io/base6/67_hires.png', 'psychic'),
    (68, 'Bulbasaur', 'common', 'https://images.pokemontcg.io/base6/68_hires.png', 'grass'),
    (69, 'Caterpie', 'common', 'https://images.pokemontcg.io/base6/69_hires.png', 'grass'),
    (70, 'Charmander', 'common', 'https://images.pokemontcg.io/base6/70_hires.png', 'fire'),
    (71, 'Doduo', 'common', 'https://images.pokemontcg.io/base6/71_hires.png', 'colorless'),
    (72, 'Dratini', 'common', 'https://images.pokemontcg.io/base6/72_hires.png', 'colorless'),
    (73, 'Drowzee', 'common', 'https://images.pokemontcg.io/base6/73_hires.png', 'psychic'),
    (74, 'Eevee', 'common', 'https://images.pokemontcg.io/base6/74_hires.png', 'colorless'),
    (75, 'Exeggcute', 'common', 'https://images.pokemontcg.io/base6/75_hires.png', 'grass'),
    (76, 'Gastly', 'common', 'https://images.pokemontcg.io/base6/76_hires.png', 'psychic'),
    (77, 'Geodude', 'common', 'https://images.pokemontcg.io/base6/77_hires.png', 'fighting'),
    (78, 'Grimer', 'common', 'https://images.pokemontcg.io/base6/78_hires.png', 'grass'),
    (79, 'Machop', 'common', 'https://images.pokemontcg.io/base6/79_hires.png', 'fighting'),
    (80, 'Magnemite', 'common', 'https://images.pokemontcg.io/base6/80_hires.png', 'lightning'),
    (81, 'Mankey', 'common', 'https://images.pokemontcg.io/base6/81_hires.png', 'fighting'),
    (82, 'Nidoran ♀', 'common', 'https://images.pokemontcg.io/base6/82_hires.png', 'grass'),
    (83, 'Nidoran ♂', 'common', 'https://images.pokemontcg.io/base6/83_hires.png', 'grass'),
    (84, 'Onix', 'common', 'https://images.pokemontcg.io/base6/84_hires.png', 'fighting'),
    (85, 'Pidgey', 'common', 'https://images.pokemontcg.io/base6/85_hires.png', 'colorless'),
    (86, 'Pikachu', 'common', 'https://images.pokemontcg.io/base6/86_hires.png', 'lightning'),
    (87, 'Ponyta', 'common', 'https://images.pokemontcg.io/base6/87_hires.png', 'fire'),
    (88, 'Psyduck', 'common', 'https://images.pokemontcg.io/base6/88_hires.png', 'water'),
    (89, 'Rattata', 'common', 'https://images.pokemontcg.io/base6/89_hires.png', 'colorless'),
    (90, 'Rhyhorn', 'common', 'https://images.pokemontcg.io/base6/90_hires.png', 'fighting'),
    (91, 'Sandshrew', 'common', 'https://images.pokemontcg.io/base6/91_hires.png', 'fighting'),
    (92, 'Seel', 'common', 'https://images.pokemontcg.io/base6/92_hires.png', 'water'),
    (93, 'Slowpoke', 'common', 'https://images.pokemontcg.io/base6/93_hires.png', 'psychic'),
    (94, 'Spearow', 'common', 'https://images.pokemontcg.io/base6/94_hires.png', 'colorless'),
    (95, 'Squirtle', 'common', 'https://images.pokemontcg.io/base6/95_hires.png', 'water'),
    (96, 'Tentacool', 'common', 'https://images.pokemontcg.io/base6/96_hires.png', 'water'),
    (97, 'Voltorb', 'common', 'https://images.pokemontcg.io/base6/97_hires.png', 'lightning'),
    (98, 'Vulpix', 'common', 'https://images.pokemontcg.io/base6/98_hires.png', 'fire'),
    (99, 'Weedle', 'common', 'https://images.pokemontcg.io/base6/99_hires.png', 'grass'),
    (100, 'Full Heal Energy', 'common', 'https://images.pokemontcg.io/base6/100_hires.png', NULL),
    (101, 'Potion Energy', 'common', 'https://images.pokemontcg.io/base6/101_hires.png', NULL),
    (102, 'Pokémon Breeder', 'rare', 'https://images.pokemontcg.io/base6/102_hires.png', NULL),
    (103, 'Pokémon Trader', 'rare', 'https://images.pokemontcg.io/base6/103_hires.png', NULL),
    (104, 'Scoop Up', 'rare', 'https://images.pokemontcg.io/base6/104_hires.png', NULL),
    (105, 'The Boss''s Way', 'common', 'https://images.pokemontcg.io/base6/105_hires.png', NULL),
    (106, 'Challenge!', 'common', 'https://images.pokemontcg.io/base6/106_hires.png', NULL),
    (107, 'Energy Retrieval', 'common', 'https://images.pokemontcg.io/base6/107_hires.png', NULL),
    (108, 'Bill', 'common', 'https://images.pokemontcg.io/base6/108_hires.png', NULL),
    (109, 'Mysterious Fossil', 'common', 'https://images.pokemontcg.io/base6/109_hires.png', NULL),
    (110, 'Potion', 'common', 'https://images.pokemontcg.io/base6/110_hires.png', NULL)
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: Best of Game (bp) -- 2002/12/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'best-of-game', 'Best of Game', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'best-of-game'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Electabuzz', 'promo', 'https://images.pokemontcg.io/bp/1_hires.png', 'lightning'),
    (2, 'Hitmonchan', 'promo', 'https://images.pokemontcg.io/bp/2_hires.png', 'fighting'),
    (3, 'Professor Elm', 'promo', 'https://images.pokemontcg.io/bp/3_hires.png', NULL),
    (4, 'Rocket''s Scizor', 'promo', 'https://images.pokemontcg.io/bp/4_hires.png', 'metal'),
    (5, 'Rocket''s Sneasel', 'promo', 'https://images.pokemontcg.io/bp/5_hires.png', 'darkness'),
    (6, 'Dark Ivysaur', 'promo', 'https://images.pokemontcg.io/bp/6_hires.png', 'grass'),
    (7, 'Dark Venusaur', 'promo', 'https://images.pokemontcg.io/bp/7_hires.png', 'grass'),
    (8, 'Rocket''s Mewtwo', 'promo', 'https://images.pokemontcg.io/bp/8_hires.png', 'psychic'),
    (9, 'Rocket''s Hitmonchan', 'promo', 'https://images.pokemontcg.io/bp/9_hires.png', 'fighting')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: Pokémon Rumble (ru1) -- 2009/12/02
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'pok-mon-rumble', 'Pokémon Rumble', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pok-mon-rumble'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Venusaur', 'base', 'https://images.pokemontcg.io/ru1/1_hires.png', 'grass'),
    (2, 'Cherrim', 'base', 'https://images.pokemontcg.io/ru1/2_hires.png', 'grass'),
    (3, 'Ninetales', 'base', 'https://images.pokemontcg.io/ru1/3_hires.png', 'fire'),
    (4, 'Heatran', 'base', 'https://images.pokemontcg.io/ru1/4_hires.png', 'fire'),
    (5, 'Starmie', 'base', 'https://images.pokemontcg.io/ru1/5_hires.png', 'water'),
    (6, 'Gyarados', 'base', 'https://images.pokemontcg.io/ru1/6_hires.png', 'water'),
    (7, 'Pikachu', 'base', 'https://images.pokemontcg.io/ru1/7_hires.png', 'lightning'),
    (8, 'Zapdos', 'base', 'https://images.pokemontcg.io/ru1/8_hires.png', 'lightning'),
    (9, 'Mewtwo', 'base', 'https://images.pokemontcg.io/ru1/9_hires.png', 'psychic'),
    (10, 'Mew', 'base', 'https://images.pokemontcg.io/ru1/10_hires.png', 'psychic'),
    (11, 'Diglett', 'base', 'https://images.pokemontcg.io/ru1/11_hires.png', 'fighting'),
    (12, 'Lucario', 'base', 'https://images.pokemontcg.io/ru1/12_hires.png', 'fighting'),
    (13, 'Skuntank', 'base', 'https://images.pokemontcg.io/ru1/13_hires.png', 'darkness'),
    (14, 'Bastiodon', 'base', 'https://images.pokemontcg.io/ru1/14_hires.png', 'metal'),
    (15, 'Rattata', 'base', 'https://images.pokemontcg.io/ru1/15_hires.png', 'colorless'),
    (16, 'Bibarel', 'base', 'https://images.pokemontcg.io/ru1/16_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: McDonald's Collection 2011 (mcd11) -- 2011/06/17
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'mcdonald-s-collection-2011', 'McDonald''s Collection 2011', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'mcdonald-s-collection-2011'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Snivy', 'base', 'https://images.pokemontcg.io/mcd11/1_hires.png', 'grass'),
    (2, 'Maractus', 'base', 'https://images.pokemontcg.io/mcd11/2_hires.png', 'grass'),
    (3, 'Tepig', 'base', 'https://images.pokemontcg.io/mcd11/3_hires.png', 'fire'),
    (4, 'Oshawott', 'base', 'https://images.pokemontcg.io/mcd11/4_hires.png', 'water'),
    (5, 'Alomomola', 'base', 'https://images.pokemontcg.io/mcd11/5_hires.png', 'water'),
    (6, 'Blitzle', 'base', 'https://images.pokemontcg.io/mcd11/6_hires.png', 'lightning'),
    (7, 'Munna', 'base', 'https://images.pokemontcg.io/mcd11/7_hires.png', 'psychic'),
    (8, 'Sandile', 'base', 'https://images.pokemontcg.io/mcd11/8_hires.png', 'fighting'),
    (9, 'Zorua', 'base', 'https://images.pokemontcg.io/mcd11/9_hires.png', 'darkness'),
    (10, 'Klink', 'base', 'https://images.pokemontcg.io/mcd11/10_hires.png', 'metal'),
    (11, 'Pidove', 'base', 'https://images.pokemontcg.io/mcd11/11_hires.png', 'colorless'),
    (12, 'Audino', 'base', 'https://images.pokemontcg.io/mcd11/12_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: McDonald's Collection 2012 (mcd12) -- 2012/06/15
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'mcdonald-s-collection-2012', 'McDonald''s Collection 2012', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'mcdonald-s-collection-2012'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Servine', 'base', 'https://images.pokemontcg.io/mcd12/1_hires.png', 'grass'),
    (2, 'Pansage', 'base', 'https://images.pokemontcg.io/mcd12/2_hires.png', 'grass'),
    (3, 'Dwebble', 'base', 'https://images.pokemontcg.io/mcd12/3_hires.png', 'grass'),
    (4, 'Pignite', 'base', 'https://images.pokemontcg.io/mcd12/4_hires.png', 'fire'),
    (5, 'Dewott', 'base', 'https://images.pokemontcg.io/mcd12/5_hires.png', 'water'),
    (6, 'Emolga', 'base', 'https://images.pokemontcg.io/mcd12/6_hires.png', 'lightning'),
    (7, 'Woobat', 'base', 'https://images.pokemontcg.io/mcd12/7_hires.png', 'psychic'),
    (8, 'Drilbur', 'base', 'https://images.pokemontcg.io/mcd12/8_hires.png', 'fighting'),
    (9, 'Purrloin', 'base', 'https://images.pokemontcg.io/mcd12/9_hires.png', 'darkness'),
    (10, 'Scraggy', 'base', 'https://images.pokemontcg.io/mcd12/10_hires.png', 'darkness'),
    (11, 'Klang', 'base', 'https://images.pokemontcg.io/mcd12/11_hires.png', 'metal'),
    (12, 'Axew', 'base', 'https://images.pokemontcg.io/mcd12/12_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: McDonald's Collection 2014 (mcd14) -- 2014/05/23
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'mcdonald-s-collection-2014', 'McDonald''s Collection 2014', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'mcdonald-s-collection-2014'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Weedle', 'base', 'https://images.pokemontcg.io/mcd14/1_hires.png', 'grass'),
    (2, 'Chespin', 'base', 'https://images.pokemontcg.io/mcd14/2_hires.png', 'grass'),
    (3, 'Fennekin', 'base', 'https://images.pokemontcg.io/mcd14/3_hires.png', 'fire'),
    (4, 'Froakie', 'base', 'https://images.pokemontcg.io/mcd14/4_hires.png', 'water'),
    (5, 'Pikachu', 'base', 'https://images.pokemontcg.io/mcd14/5_hires.png', 'lightning'),
    (6, 'Inkay', 'base', 'https://images.pokemontcg.io/mcd14/6_hires.png', 'darkness'),
    (7, 'Honedge', 'base', 'https://images.pokemontcg.io/mcd14/7_hires.png', 'metal'),
    (8, 'Snubbull', 'base', 'https://images.pokemontcg.io/mcd14/8_hires.png', 'fairy'),
    (9, 'Swirlix', 'base', 'https://images.pokemontcg.io/mcd14/9_hires.png', 'fairy'),
    (10, 'Bunnelby', 'base', 'https://images.pokemontcg.io/mcd14/10_hires.png', 'colorless'),
    (11, 'Fletchling', 'base', 'https://images.pokemontcg.io/mcd14/11_hires.png', 'colorless'),
    (12, 'Furfrou', 'base', 'https://images.pokemontcg.io/mcd14/12_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: McDonald's Collection 2015 (mcd15) -- 2015/11/27
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'mcdonald-s-collection-2015', 'McDonald''s Collection 2015', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'mcdonald-s-collection-2015'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Treecko', 'base', 'https://images.pokemontcg.io/mcd15/1_hires.png', 'grass'),
    (2, 'Lotad', 'base', 'https://images.pokemontcg.io/mcd15/2_hires.png', 'grass'),
    (3, 'Torchic', 'base', 'https://images.pokemontcg.io/mcd15/3_hires.png', 'fire'),
    (4, 'Staryu', 'base', 'https://images.pokemontcg.io/mcd15/4_hires.png', 'water'),
    (5, 'Mudkip', 'base', 'https://images.pokemontcg.io/mcd15/5_hires.png', 'water'),
    (6, 'Pikachu', 'base', 'https://images.pokemontcg.io/mcd15/6_hires.png', 'lightning'),
    (7, 'Electrike', 'base', 'https://images.pokemontcg.io/mcd15/7_hires.png', 'lightning'),
    (8, 'Rhyhorn', 'common', 'https://images.pokemontcg.io/mcd15/8_hires.png', 'fighting'),
    (9, 'Meditite', 'base', 'https://images.pokemontcg.io/mcd15/9_hires.png', 'fighting'),
    (10, 'Marill', 'base', 'https://images.pokemontcg.io/mcd15/10_hires.png', 'fairy'),
    (11, 'Zigzagoon', 'base', 'https://images.pokemontcg.io/mcd15/11_hires.png', 'colorless'),
    (12, 'Skitty', 'base', 'https://images.pokemontcg.io/mcd15/12_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: McDonald's Collection 2016 (mcd16) -- 2016/08/19
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'mcdonald-s-collection-2016', 'McDonald''s Collection 2016', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'mcdonald-s-collection-2016'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Vulpix', 'base', 'https://images.pokemontcg.io/mcd16/1_hires.png', 'fire'),
    (2, 'Torchic', 'base', 'https://images.pokemontcg.io/mcd16/2_hires.png', 'fire'),
    (3, 'Fennekin', 'base', 'https://images.pokemontcg.io/mcd16/3_hires.png', 'fire'),
    (4, 'Magikarp', 'base', 'https://images.pokemontcg.io/mcd16/4_hires.png', 'water'),
    (5, 'Totodile', 'base', 'https://images.pokemontcg.io/mcd16/5_hires.png', 'water'),
    (6, 'Pikachu', 'base', 'https://images.pokemontcg.io/mcd16/6_hires.png', 'lightning'),
    (7, 'Scraggy', 'base', 'https://images.pokemontcg.io/mcd16/7_hires.png', 'darkness'),
    (8, 'Jigglypuff', 'base', 'https://images.pokemontcg.io/mcd16/8_hires.png', 'fairy'),
    (9, 'Togepi', 'base', 'https://images.pokemontcg.io/mcd16/9_hires.png', 'fairy'),
    (10, 'Dedenne', 'base', 'https://images.pokemontcg.io/mcd16/10_hires.png', 'fairy'),
    (11, 'Meowth', 'base', 'https://images.pokemontcg.io/mcd16/11_hires.png', 'colorless'),
    (12, 'Eevee', 'base', 'https://images.pokemontcg.io/mcd16/12_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: McDonald's Collection 2017 (mcd17) -- 2017/11/07
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'mcdonald-s-collection-2017', 'McDonald''s Collection 2017', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'mcdonald-s-collection-2017'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Rowlet', 'base', 'https://images.pokemontcg.io/mcd17/1_hires.png', 'grass'),
    (2, 'Grubbin', 'base', 'https://images.pokemontcg.io/mcd17/2_hires.png', 'grass'),
    (3, 'Litten', 'base', 'https://images.pokemontcg.io/mcd17/3_hires.png', 'fire'),
    (4, 'Popplio', 'base', 'https://images.pokemontcg.io/mcd17/4_hires.png', 'water'),
    (5, 'Pikachu', 'base', 'https://images.pokemontcg.io/mcd17/5_hires.png', 'lightning'),
    (6, 'Cosmog', 'base', 'https://images.pokemontcg.io/mcd17/6_hires.png', 'psychic'),
    (7, 'Crabrawler', 'base', 'https://images.pokemontcg.io/mcd17/7_hires.png', 'fighting'),
    (8, 'Alolan Meowth', 'base', 'https://images.pokemontcg.io/mcd17/8_hires.png', 'darkness'),
    (9, 'Alolan Diglett', 'base', 'https://images.pokemontcg.io/mcd17/9_hires.png', 'metal'),
    (10, 'Cutiefly', 'base', 'https://images.pokemontcg.io/mcd17/10_hires.png', 'fairy'),
    (11, 'Pikipek', 'base', 'https://images.pokemontcg.io/mcd17/11_hires.png', 'colorless'),
    (12, 'Yungoos', 'base', 'https://images.pokemontcg.io/mcd17/12_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: McDonald's Collection 2018 (mcd18) -- 2018/10/16
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'mcdonald-s-collection-2018', 'McDonald''s Collection 2018', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'mcdonald-s-collection-2018'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Growlithe', 'base', 'https://images.pokemontcg.io/mcd18/1_hires.png', 'fire'),
    (2, 'Psyduck', 'base', 'https://images.pokemontcg.io/mcd18/2_hires.png', 'water'),
    (3, 'Horsea', 'base', 'https://images.pokemontcg.io/mcd18/3_hires.png', 'water'),
    (4, 'Pikachu', 'base', 'https://images.pokemontcg.io/mcd18/4_hires.png', 'lightning'),
    (5, 'Slowpoke', 'base', 'https://images.pokemontcg.io/mcd18/5_hires.png', 'psychic'),
    (6, 'Machop', 'base', 'https://images.pokemontcg.io/mcd18/6_hires.png', 'fighting'),
    (7, 'Cubone', 'base', 'https://images.pokemontcg.io/mcd18/7_hires.png', 'fighting'),
    (8, 'Magnemite', 'base', 'https://images.pokemontcg.io/mcd18/8_hires.png', 'metal'),
    (9, 'Dratini', 'base', 'https://images.pokemontcg.io/mcd18/9_hires.png', 'dragon'),
    (10, 'Chansey', 'base', 'https://images.pokemontcg.io/mcd18/10_hires.png', 'colorless'),
    (11, 'Eevee', 'base', 'https://images.pokemontcg.io/mcd18/11_hires.png', 'colorless'),
    (12, 'Porygon', 'base', 'https://images.pokemontcg.io/mcd18/12_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: McDonald's Collection 2019 (mcd19) -- 2019/10/15
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'mcdonald-s-collection-2019', 'McDonald''s Collection 2019', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'mcdonald-s-collection-2019'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Caterpie', 'base', 'https://images.pokemontcg.io/mcd19/1_hires.png', 'grass'),
    (2, 'Alolan Exeggutor', 'base', 'https://images.pokemontcg.io/mcd19/2_hires.png', 'grass'),
    (3, 'Magmar', 'base', 'https://images.pokemontcg.io/mcd19/3_hires.png', 'fire'),
    (4, 'Alolan Sandshrew', 'base', 'https://images.pokemontcg.io/mcd19/4_hires.png', 'water'),
    (5, 'Lapras', 'base', 'https://images.pokemontcg.io/mcd19/5_hires.png', 'water'),
    (6, 'Pikachu', 'base', 'https://images.pokemontcg.io/mcd19/6_hires.png', 'lightning'),
    (7, 'Gastly', 'base', 'https://images.pokemontcg.io/mcd19/7_hires.png', 'psychic'),
    (8, 'Mankey', 'base', 'https://images.pokemontcg.io/mcd19/8_hires.png', 'fighting'),
    (9, 'Onix', 'base', 'https://images.pokemontcg.io/mcd19/9_hires.png', 'fighting'),
    (10, 'Alolan Meowth', 'base', 'https://images.pokemontcg.io/mcd19/10_hires.png', 'darkness'),
    (11, 'Alolan Dugtrio', 'base', 'https://images.pokemontcg.io/mcd19/11_hires.png', 'metal'),
    (12, 'Eevee', 'base', 'https://images.pokemontcg.io/mcd19/12_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: Pokémon Futsal Collection (fut20) -- 2020/09/11
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'pok-mon-futsal-collection', 'Pokémon Futsal Collection', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pok-mon-futsal-collection'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Pikachu on the Ball', 'base', 'https://images.pokemontcg.io/fut20/1_hires.png', 'lightning'),
    (2, 'Eevee on the Ball', 'base', 'https://images.pokemontcg.io/fut20/2_hires.png', 'colorless'),
    (3, 'Grookey on the Ball', 'base', 'https://images.pokemontcg.io/fut20/3_hires.png', 'grass'),
    (4, 'Scorbunny on the Ball', 'base', 'https://images.pokemontcg.io/fut20/4_hires.png', 'fire'),
    (5, 'Sobble on the Ball', 'base', 'https://images.pokemontcg.io/fut20/5_hires.png', 'water')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: McDonald's Collection 2021 (mcd21) -- 2021/02/09
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'mcdonald-s-collection-2021', 'McDonald''s Collection 2021', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'mcdonald-s-collection-2021'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Bulbasaur', 'base', 'https://images.pokemontcg.io/mcd21/1_hires.png', 'grass'),
    (2, 'Chikorita', 'base', 'https://images.pokemontcg.io/mcd21/2_hires.png', 'grass'),
    (3, 'Treecko', 'base', 'https://images.pokemontcg.io/mcd21/3_hires.png', 'grass'),
    (4, 'Turtwig', 'base', 'https://images.pokemontcg.io/mcd21/4_hires.png', 'grass'),
    (5, 'Snivy', 'base', 'https://images.pokemontcg.io/mcd21/5_hires.png', 'grass'),
    (6, 'Chespin', 'base', 'https://images.pokemontcg.io/mcd21/6_hires.png', 'grass'),
    (7, 'Rowlet', 'base', 'https://images.pokemontcg.io/mcd21/7_hires.png', 'grass'),
    (8, 'Grookey', 'base', 'https://images.pokemontcg.io/mcd21/8_hires.png', 'grass'),
    (9, 'Charmander', 'base', 'https://images.pokemontcg.io/mcd21/9_hires.png', 'fire'),
    (10, 'Cyndaquil', 'base', 'https://images.pokemontcg.io/mcd21/10_hires.png', 'fire'),
    (11, 'Torchic', 'base', 'https://images.pokemontcg.io/mcd21/11_hires.png', 'fire'),
    (12, 'Chimchar', 'base', 'https://images.pokemontcg.io/mcd21/12_hires.png', 'fire'),
    (13, 'Tepig', 'base', 'https://images.pokemontcg.io/mcd21/13_hires.png', 'fire'),
    (14, 'Fennekin', 'base', 'https://images.pokemontcg.io/mcd21/14_hires.png', 'fire'),
    (15, 'Litten', 'base', 'https://images.pokemontcg.io/mcd21/15_hires.png', 'fire'),
    (16, 'Scorbunny', 'base', 'https://images.pokemontcg.io/mcd21/16_hires.png', 'fire'),
    (17, 'Squirtle', 'base', 'https://images.pokemontcg.io/mcd21/17_hires.png', 'water'),
    (18, 'Totodile', 'base', 'https://images.pokemontcg.io/mcd21/18_hires.png', 'water'),
    (19, 'Mudkip', 'base', 'https://images.pokemontcg.io/mcd21/19_hires.png', 'water'),
    (20, 'Piplup', 'base', 'https://images.pokemontcg.io/mcd21/20_hires.png', 'water'),
    (21, 'Oshawott', 'base', 'https://images.pokemontcg.io/mcd21/21_hires.png', 'water'),
    (22, 'Froakie', 'base', 'https://images.pokemontcg.io/mcd21/22_hires.png', 'water'),
    (23, 'Popplio', 'base', 'https://images.pokemontcg.io/mcd21/23_hires.png', 'water'),
    (24, 'Sobble', 'base', 'https://images.pokemontcg.io/mcd21/24_hires.png', 'water'),
    (25, 'Pikachu', 'base', 'https://images.pokemontcg.io/mcd21/25_hires.png', 'lightning')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: McDonald's Collection 2022 (mcd22) -- 2022/08/03
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('other', 'Other', 'mcdonald-s-collection-2022', 'McDonald''s Collection 2022', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'mcdonald-s-collection-2022'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Ledyba', 'base', 'https://images.pokemontcg.io/mcd22/1_hires.png', 'grass'),
    (2, 'Rowlet', 'base', 'https://images.pokemontcg.io/mcd22/2_hires.png', 'grass'),
    (3, 'Gossifleur', 'base', 'https://images.pokemontcg.io/mcd22/3_hires.png', 'grass'),
    (4, 'Growlithe', 'base', 'https://images.pokemontcg.io/mcd22/4_hires.png', 'fire'),
    (5, 'Victini', 'base', 'https://images.pokemontcg.io/mcd22/5_hires.png', 'fire'),
    (6, 'Lapras', 'base', 'https://images.pokemontcg.io/mcd22/6_hires.png', 'water'),
    (7, 'Pikachu', 'base', 'https://images.pokemontcg.io/mcd22/7_hires.png', 'lightning'),
    (8, 'Chinchou', 'base', 'https://images.pokemontcg.io/mcd22/8_hires.png', 'lightning'),
    (9, 'Flaaffy', 'base', 'https://images.pokemontcg.io/mcd22/9_hires.png', 'lightning'),
    (10, 'Tynamo', 'base', 'https://images.pokemontcg.io/mcd22/10_hires.png', 'lightning'),
    (11, 'Cutiefly', 'base', 'https://images.pokemontcg.io/mcd22/11_hires.png', 'psychic'),
    (12, 'Bewear', 'base', 'https://images.pokemontcg.io/mcd22/12_hires.png', 'fighting'),
    (13, 'Pangoro', 'base', 'https://images.pokemontcg.io/mcd22/13_hires.png', 'darkness'),
    (14, 'Drampa', 'base', 'https://images.pokemontcg.io/mcd22/14_hires.png', 'dragon'),
    (15, 'Smeargle', 'base', 'https://images.pokemontcg.io/mcd22/15_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;
