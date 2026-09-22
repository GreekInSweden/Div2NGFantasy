-- Katalogimport: Neo (4 set)
-- Endast katalogdata (lager 0, pris 0) för portfölj/önskelista-funktionen.

-- Set: Neo Genesis (neo1) -- 2000/12/16
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('neo', 'Neo', 'neo-genesis', 'Neo Genesis', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'neo-genesis'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Ampharos', 'rare', 'https://images.pokemontcg.io/neo1/1_hires.png', 'lightning'),
    (2, 'Azumarill', 'rare', 'https://images.pokemontcg.io/neo1/2_hires.png', 'water'),
    (3, 'Bellossom', 'rare', 'https://images.pokemontcg.io/neo1/3_hires.png', 'grass'),
    (4, 'Feraligatr', 'rare', 'https://images.pokemontcg.io/neo1/4_hires.png', 'water'),
    (5, 'Feraligatr', 'rare', 'https://images.pokemontcg.io/neo1/5_hires.png', 'water'),
    (6, 'Heracross', 'rare', 'https://images.pokemontcg.io/neo1/6_hires.png', 'grass'),
    (7, 'Jumpluff', 'rare', 'https://images.pokemontcg.io/neo1/7_hires.png', 'grass'),
    (8, 'Kingdra', 'rare', 'https://images.pokemontcg.io/neo1/8_hires.png', 'water'),
    (9, 'Lugia', 'rare', 'https://images.pokemontcg.io/neo1/9_hires.png', 'colorless'),
    (10, 'Meganium', 'rare', 'https://images.pokemontcg.io/neo1/10_hires.png', 'grass'),
    (11, 'Meganium', 'rare', 'https://images.pokemontcg.io/neo1/11_hires.png', 'grass'),
    (12, 'Pichu', 'rare', 'https://images.pokemontcg.io/neo1/12_hires.png', 'lightning'),
    (13, 'Skarmory', 'rare', 'https://images.pokemontcg.io/neo1/13_hires.png', 'metal'),
    (14, 'Slowking', 'rare', 'https://images.pokemontcg.io/neo1/14_hires.png', 'psychic'),
    (15, 'Steelix', 'rare', 'https://images.pokemontcg.io/neo1/15_hires.png', 'metal'),
    (16, 'Togetic', 'rare', 'https://images.pokemontcg.io/neo1/16_hires.png', 'colorless'),
    (17, 'Typhlosion', 'rare', 'https://images.pokemontcg.io/neo1/17_hires.png', 'fire'),
    (18, 'Typhlosion', 'rare', 'https://images.pokemontcg.io/neo1/18_hires.png', 'fire'),
    (19, 'Metal Energy', 'rare', 'https://images.pokemontcg.io/neo1/19_hires.png', NULL),
    (20, 'Cleffa', 'rare', 'https://images.pokemontcg.io/neo1/20_hires.png', 'colorless'),
    (21, 'Donphan', 'rare', 'https://images.pokemontcg.io/neo1/21_hires.png', 'fighting'),
    (22, 'Elekid', 'rare', 'https://images.pokemontcg.io/neo1/22_hires.png', 'lightning'),
    (23, 'Magby', 'rare', 'https://images.pokemontcg.io/neo1/23_hires.png', 'fire'),
    (24, 'Murkrow', 'rare', 'https://images.pokemontcg.io/neo1/24_hires.png', 'darkness'),
    (25, 'Sneasel', 'rare', 'https://images.pokemontcg.io/neo1/25_hires.png', 'darkness'),
    (26, 'Aipom', 'common', 'https://images.pokemontcg.io/neo1/26_hires.png', 'colorless'),
    (27, 'Ariados', 'common', 'https://images.pokemontcg.io/neo1/27_hires.png', 'grass'),
    (28, 'Bayleef', 'common', 'https://images.pokemontcg.io/neo1/28_hires.png', 'grass'),
    (29, 'Bayleef', 'common', 'https://images.pokemontcg.io/neo1/29_hires.png', 'grass'),
    (30, 'Clefairy', 'common', 'https://images.pokemontcg.io/neo1/30_hires.png', 'colorless'),
    (31, 'Croconaw', 'common', 'https://images.pokemontcg.io/neo1/31_hires.png', 'water'),
    (32, 'Croconaw', 'common', 'https://images.pokemontcg.io/neo1/32_hires.png', 'water'),
    (33, 'Electabuzz', 'common', 'https://images.pokemontcg.io/neo1/33_hires.png', 'lightning'),
    (34, 'Flaaffy', 'common', 'https://images.pokemontcg.io/neo1/34_hires.png', 'lightning'),
    (35, 'Furret', 'common', 'https://images.pokemontcg.io/neo1/35_hires.png', 'colorless'),
    (36, 'Gloom', 'common', 'https://images.pokemontcg.io/neo1/36_hires.png', 'grass'),
    (37, 'Granbull', 'common', 'https://images.pokemontcg.io/neo1/37_hires.png', 'colorless'),
    (38, 'Lanturn', 'common', 'https://images.pokemontcg.io/neo1/38_hires.png', 'lightning'),
    (39, 'Ledian', 'common', 'https://images.pokemontcg.io/neo1/39_hires.png', 'grass'),
    (40, 'Magmar', 'common', 'https://images.pokemontcg.io/neo1/40_hires.png', 'fire'),
    (41, 'Miltank', 'common', 'https://images.pokemontcg.io/neo1/41_hires.png', 'colorless'),
    (42, 'Noctowl', 'common', 'https://images.pokemontcg.io/neo1/42_hires.png', 'colorless'),
    (43, 'Phanpy', 'common', 'https://images.pokemontcg.io/neo1/43_hires.png', 'fighting'),
    (44, 'Piloswine', 'common', 'https://images.pokemontcg.io/neo1/44_hires.png', 'water'),
    (45, 'Quagsire', 'common', 'https://images.pokemontcg.io/neo1/45_hires.png', 'water'),
    (46, 'Quilava', 'common', 'https://images.pokemontcg.io/neo1/46_hires.png', 'fire'),
    (47, 'Quilava', 'common', 'https://images.pokemontcg.io/neo1/47_hires.png', 'fire'),
    (48, 'Seadra', 'common', 'https://images.pokemontcg.io/neo1/48_hires.png', 'water'),
    (49, 'Skiploom', 'common', 'https://images.pokemontcg.io/neo1/49_hires.png', 'grass'),
    (50, 'Sunflora', 'common', 'https://images.pokemontcg.io/neo1/50_hires.png', 'grass'),
    (51, 'Togepi', 'common', 'https://images.pokemontcg.io/neo1/51_hires.png', 'colorless'),
    (52, 'Xatu', 'common', 'https://images.pokemontcg.io/neo1/52_hires.png', 'psychic'),
    (53, 'Chikorita', 'common', 'https://images.pokemontcg.io/neo1/53_hires.png', 'grass'),
    (54, 'Chikorita', 'common', 'https://images.pokemontcg.io/neo1/54_hires.png', 'grass'),
    (55, 'Chinchou', 'common', 'https://images.pokemontcg.io/neo1/55_hires.png', 'lightning'),
    (56, 'Cyndaquil', 'common', 'https://images.pokemontcg.io/neo1/56_hires.png', 'fire'),
    (57, 'Cyndaquil', 'common', 'https://images.pokemontcg.io/neo1/57_hires.png', 'fire'),
    (58, 'Girafarig', 'common', 'https://images.pokemontcg.io/neo1/58_hires.png', 'psychic'),
    (59, 'Gligar', 'common', 'https://images.pokemontcg.io/neo1/59_hires.png', 'fighting'),
    (60, 'Hoothoot', 'common', 'https://images.pokemontcg.io/neo1/60_hires.png', 'colorless'),
    (61, 'Hoppip', 'common', 'https://images.pokemontcg.io/neo1/61_hires.png', 'grass'),
    (62, 'Horsea', 'common', 'https://images.pokemontcg.io/neo1/62_hires.png', 'water'),
    (63, 'Ledyba', 'common', 'https://images.pokemontcg.io/neo1/63_hires.png', 'grass'),
    (64, 'Mantine', 'common', 'https://images.pokemontcg.io/neo1/64_hires.png', 'water'),
    (65, 'Mareep', 'common', 'https://images.pokemontcg.io/neo1/65_hires.png', 'lightning'),
    (66, 'Marill', 'common', 'https://images.pokemontcg.io/neo1/66_hires.png', 'water'),
    (67, 'Natu', 'common', 'https://images.pokemontcg.io/neo1/67_hires.png', 'psychic'),
    (68, 'Oddish', 'common', 'https://images.pokemontcg.io/neo1/68_hires.png', 'grass'),
    (69, 'Onix', 'common', 'https://images.pokemontcg.io/neo1/69_hires.png', 'fighting'),
    (70, 'Pikachu', 'common', 'https://images.pokemontcg.io/neo1/70_hires.png', 'lightning'),
    (71, 'Sentret', 'common', 'https://images.pokemontcg.io/neo1/71_hires.png', 'colorless'),
    (72, 'Shuckle', 'common', 'https://images.pokemontcg.io/neo1/72_hires.png', 'grass'),
    (73, 'Slowpoke', 'common', 'https://images.pokemontcg.io/neo1/73_hires.png', 'psychic'),
    (74, 'Snubbull', 'common', 'https://images.pokemontcg.io/neo1/74_hires.png', 'colorless'),
    (75, 'Spinarak', 'common', 'https://images.pokemontcg.io/neo1/75_hires.png', 'grass'),
    (76, 'Stantler', 'common', 'https://images.pokemontcg.io/neo1/76_hires.png', 'colorless'),
    (77, 'Sudowoodo', 'common', 'https://images.pokemontcg.io/neo1/77_hires.png', 'fighting'),
    (78, 'Sunkern', 'common', 'https://images.pokemontcg.io/neo1/78_hires.png', 'grass'),
    (79, 'Swinub', 'common', 'https://images.pokemontcg.io/neo1/79_hires.png', 'water'),
    (80, 'Totodile', 'common', 'https://images.pokemontcg.io/neo1/80_hires.png', 'water'),
    (81, 'Totodile', 'common', 'https://images.pokemontcg.io/neo1/81_hires.png', 'water'),
    (82, 'Wooper', 'common', 'https://images.pokemontcg.io/neo1/82_hires.png', 'water'),
    (83, 'Arcade Game', 'rare', 'https://images.pokemontcg.io/neo1/83_hires.png', NULL),
    (84, 'Ecogym', 'rare', 'https://images.pokemontcg.io/neo1/84_hires.png', NULL),
    (85, 'Energy Charge', 'rare', 'https://images.pokemontcg.io/neo1/85_hires.png', NULL),
    (86, 'Focus Band', 'rare', 'https://images.pokemontcg.io/neo1/86_hires.png', NULL),
    (87, 'Mary', 'rare', 'https://images.pokemontcg.io/neo1/87_hires.png', NULL),
    (88, 'PokéGear', 'rare', 'https://images.pokemontcg.io/neo1/88_hires.png', NULL),
    (89, 'Super Energy Retrieval', 'rare', 'https://images.pokemontcg.io/neo1/89_hires.png', NULL),
    (90, 'Time Capsule', 'rare', 'https://images.pokemontcg.io/neo1/90_hires.png', NULL),
    (91, 'Bill''s Teleporter', 'common', 'https://images.pokemontcg.io/neo1/91_hires.png', NULL),
    (92, 'Card-Flip Game', 'common', 'https://images.pokemontcg.io/neo1/92_hires.png', NULL),
    (93, 'Gold Berry', 'common', 'https://images.pokemontcg.io/neo1/93_hires.png', NULL),
    (94, 'Miracle Berry', 'common', 'https://images.pokemontcg.io/neo1/94_hires.png', NULL),
    (95, 'New Pokédex', 'common', 'https://images.pokemontcg.io/neo1/95_hires.png', NULL),
    (96, 'Professor Elm', 'common', 'https://images.pokemontcg.io/neo1/96_hires.png', NULL),
    (97, 'Sprout Tower', 'common', 'https://images.pokemontcg.io/neo1/97_hires.png', NULL),
    (98, 'Super Scoop Up', 'common', 'https://images.pokemontcg.io/neo1/98_hires.png', NULL),
    (99, 'Berry', 'common', 'https://images.pokemontcg.io/neo1/99_hires.png', NULL),
    (100, 'Double Gust', 'common', 'https://images.pokemontcg.io/neo1/100_hires.png', NULL),
    (101, 'Moo-Moo Milk', 'common', 'https://images.pokemontcg.io/neo1/101_hires.png', NULL),
    (102, 'Pokémon March', 'common', 'https://images.pokemontcg.io/neo1/102_hires.png', NULL),
    (103, 'Super Rod', 'common', 'https://images.pokemontcg.io/neo1/103_hires.png', NULL),
    (104, 'Darkness Energy', 'rare', 'https://images.pokemontcg.io/neo1/104_hires.png', NULL),
    (105, 'Recycle Energy', 'rare', 'https://images.pokemontcg.io/neo1/105_hires.png', NULL),
    (106, 'Fighting Energy', 'base', 'https://images.pokemontcg.io/neo1/106_hires.png', NULL),
    (107, 'Fire Energy', 'base', 'https://images.pokemontcg.io/neo1/107_hires.png', NULL),
    (108, 'Grass Energy', 'base', 'https://images.pokemontcg.io/neo1/108_hires.png', NULL),
    (109, 'Lightning Energy', 'base', 'https://images.pokemontcg.io/neo1/109_hires.png', NULL),
    (110, 'Psychic Energy', 'base', 'https://images.pokemontcg.io/neo1/110_hires.png', NULL),
    (111, 'Water Energy', 'base', 'https://images.pokemontcg.io/neo1/111_hires.png', NULL)
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

-- Set: Neo Discovery (neo2) -- 2001/06/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('neo', 'Neo', 'neo-discovery', 'Neo Discovery', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'neo-discovery'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Espeon', 'rare', 'https://images.pokemontcg.io/neo2/1_hires.png', 'psychic'),
    (2, 'Forretress', 'rare', 'https://images.pokemontcg.io/neo2/2_hires.png', 'metal'),
    (3, 'Hitmontop', 'rare', 'https://images.pokemontcg.io/neo2/3_hires.png', 'fighting'),
    (4, 'Houndoom', 'rare', 'https://images.pokemontcg.io/neo2/4_hires.png', 'darkness'),
    (5, 'Houndour', 'rare', 'https://images.pokemontcg.io/neo2/5_hires.png', 'fire'),
    (6, 'Kabutops', 'rare', 'https://images.pokemontcg.io/neo2/6_hires.png', 'water'),
    (7, 'Magnemite', 'rare', 'https://images.pokemontcg.io/neo2/7_hires.png', 'metal'),
    (8, 'Politoed', 'rare', 'https://images.pokemontcg.io/neo2/8_hires.png', 'water'),
    (9, 'Poliwrath', 'rare', 'https://images.pokemontcg.io/neo2/9_hires.png', 'fighting'),
    (10, 'Scizor', 'rare', 'https://images.pokemontcg.io/neo2/10_hires.png', 'metal'),
    (11, 'Smeargle', 'rare', 'https://images.pokemontcg.io/neo2/11_hires.png', 'colorless'),
    (12, 'Tyranitar', 'rare', 'https://images.pokemontcg.io/neo2/12_hires.png', 'darkness'),
    (13, 'Umbreon', 'rare', 'https://images.pokemontcg.io/neo2/13_hires.png', 'darkness'),
    (14, 'Unown [A]', 'rare', 'https://images.pokemontcg.io/neo2/14_hires.png', 'psychic'),
    (15, 'Ursaring', 'rare', 'https://images.pokemontcg.io/neo2/15_hires.png', 'colorless'),
    (16, 'Wobbuffet', 'rare', 'https://images.pokemontcg.io/neo2/16_hires.png', 'psychic'),
    (17, 'Yanma', 'rare', 'https://images.pokemontcg.io/neo2/17_hires.png', 'grass'),
    (18, 'Beedrill', 'rare', 'https://images.pokemontcg.io/neo2/18_hires.png', 'grass'),
    (19, 'Butterfree', 'rare', 'https://images.pokemontcg.io/neo2/19_hires.png', 'grass'),
    (20, 'Espeon', 'rare', 'https://images.pokemontcg.io/neo2/20_hires.png', 'psychic'),
    (21, 'Forretress', 'rare', 'https://images.pokemontcg.io/neo2/21_hires.png', 'metal'),
    (22, 'Hitmontop', 'rare', 'https://images.pokemontcg.io/neo2/22_hires.png', 'fighting'),
    (23, 'Houndoom', 'rare', 'https://images.pokemontcg.io/neo2/23_hires.png', 'darkness'),
    (24, 'Houndour', 'rare', 'https://images.pokemontcg.io/neo2/24_hires.png', 'fire'),
    (25, 'Kabutops', 'rare', 'https://images.pokemontcg.io/neo2/25_hires.png', 'water'),
    (26, 'Magnemite', 'rare', 'https://images.pokemontcg.io/neo2/26_hires.png', 'metal'),
    (27, 'Politoed', 'rare', 'https://images.pokemontcg.io/neo2/27_hires.png', 'water'),
    (28, 'Poliwrath', 'rare', 'https://images.pokemontcg.io/neo2/28_hires.png', 'fighting'),
    (29, 'Scizor', 'rare', 'https://images.pokemontcg.io/neo2/29_hires.png', 'metal'),
    (30, 'Smeargle', 'rare', 'https://images.pokemontcg.io/neo2/30_hires.png', 'colorless'),
    (31, 'Tyranitar', 'rare', 'https://images.pokemontcg.io/neo2/31_hires.png', 'darkness'),
    (32, 'Umbreon', 'rare', 'https://images.pokemontcg.io/neo2/32_hires.png', 'darkness'),
    (33, 'Unown [A]', 'rare', 'https://images.pokemontcg.io/neo2/33_hires.png', 'psychic'),
    (34, 'Ursaring', 'rare', 'https://images.pokemontcg.io/neo2/34_hires.png', 'colorless'),
    (35, 'Wobbuffet', 'rare', 'https://images.pokemontcg.io/neo2/35_hires.png', 'psychic'),
    (36, 'Yanma', 'rare', 'https://images.pokemontcg.io/neo2/36_hires.png', 'grass'),
    (37, 'Corsola', 'common', 'https://images.pokemontcg.io/neo2/37_hires.png', 'water'),
    (38, 'Eevee', 'common', 'https://images.pokemontcg.io/neo2/38_hires.png', 'colorless'),
    (39, 'Houndour', 'common', 'https://images.pokemontcg.io/neo2/39_hires.png', 'darkness'),
    (40, 'Igglybuff', 'common', 'https://images.pokemontcg.io/neo2/40_hires.png', 'colorless'),
    (41, 'Kakuna', 'common', 'https://images.pokemontcg.io/neo2/41_hires.png', 'grass'),
    (42, 'Metapod', 'common', 'https://images.pokemontcg.io/neo2/42_hires.png', 'grass'),
    (43, 'Omastar', 'common', 'https://images.pokemontcg.io/neo2/43_hires.png', 'fighting'),
    (44, 'Poliwhirl', 'common', 'https://images.pokemontcg.io/neo2/44_hires.png', 'water'),
    (45, 'Pupitar', 'common', 'https://images.pokemontcg.io/neo2/45_hires.png', 'fighting'),
    (46, 'Scyther', 'common', 'https://images.pokemontcg.io/neo2/46_hires.png', 'grass'),
    (47, 'Unown [D]', 'common', 'https://images.pokemontcg.io/neo2/47_hires.png', 'psychic'),
    (48, 'Unown [F]', 'common', 'https://images.pokemontcg.io/neo2/48_hires.png', 'psychic'),
    (49, 'Unown [M]', 'common', 'https://images.pokemontcg.io/neo2/49_hires.png', 'psychic'),
    (50, 'Unown [N]', 'common', 'https://images.pokemontcg.io/neo2/50_hires.png', 'psychic'),
    (51, 'Unown [U]', 'common', 'https://images.pokemontcg.io/neo2/51_hires.png', 'psychic'),
    (52, 'Xatu', 'common', 'https://images.pokemontcg.io/neo2/52_hires.png', 'psychic'),
    (53, 'Caterpie', 'common', 'https://images.pokemontcg.io/neo2/53_hires.png', 'grass'),
    (54, 'Dunsparce', 'common', 'https://images.pokemontcg.io/neo2/54_hires.png', 'colorless'),
    (55, 'Hoppip', 'common', 'https://images.pokemontcg.io/neo2/55_hires.png', 'grass'),
    (56, 'Kabuto', 'common', 'https://images.pokemontcg.io/neo2/56_hires.png', 'water'),
    (57, 'Larvitar', 'common', 'https://images.pokemontcg.io/neo2/57_hires.png', 'fighting'),
    (58, 'Mareep', 'common', 'https://images.pokemontcg.io/neo2/58_hires.png', 'lightning'),
    (59, 'Natu', 'common', 'https://images.pokemontcg.io/neo2/59_hires.png', 'psychic'),
    (60, 'Omanyte', 'common', 'https://images.pokemontcg.io/neo2/60_hires.png', 'fighting'),
    (61, 'Pineco', 'common', 'https://images.pokemontcg.io/neo2/61_hires.png', 'grass'),
    (62, 'Poliwag', 'common', 'https://images.pokemontcg.io/neo2/62_hires.png', 'water'),
    (63, 'Sentret', 'common', 'https://images.pokemontcg.io/neo2/63_hires.png', 'colorless'),
    (64, 'Spinarak', 'common', 'https://images.pokemontcg.io/neo2/64_hires.png', 'grass'),
    (65, 'Teddiursa', 'common', 'https://images.pokemontcg.io/neo2/65_hires.png', 'colorless'),
    (66, 'Tyrogue', 'common', 'https://images.pokemontcg.io/neo2/66_hires.png', 'fighting'),
    (67, 'Unown [E]', 'common', 'https://images.pokemontcg.io/neo2/67_hires.png', 'psychic'),
    (68, 'Unown [I]', 'common', 'https://images.pokemontcg.io/neo2/68_hires.png', 'psychic'),
    (69, 'Unown [O]', 'common', 'https://images.pokemontcg.io/neo2/69_hires.png', 'psychic'),
    (70, 'Weedle', 'common', 'https://images.pokemontcg.io/neo2/70_hires.png', 'grass'),
    (71, 'Wooper', 'common', 'https://images.pokemontcg.io/neo2/71_hires.png', 'water'),
    (72, 'Fossil Egg', 'common', 'https://images.pokemontcg.io/neo2/72_hires.png', NULL),
    (73, 'Hyper Devolution Spray', 'common', 'https://images.pokemontcg.io/neo2/73_hires.png', NULL),
    (74, 'Ruin Wall', 'common', 'https://images.pokemontcg.io/neo2/74_hires.png', NULL),
    (75, 'Energy Ark', 'common', 'https://images.pokemontcg.io/neo2/75_hires.png', NULL)
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

-- Set: Neo Revelation (neo3) -- 2001/09/21
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('neo', 'Neo', 'neo-revelation', 'Neo Revelation', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'neo-revelation'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Ampharos', 'rare', 'https://images.pokemontcg.io/neo3/1_hires.png', 'lightning'),
    (2, 'Blissey', 'rare', 'https://images.pokemontcg.io/neo3/2_hires.png', 'colorless'),
    (3, 'Celebi', 'rare', 'https://images.pokemontcg.io/neo3/3_hires.png', 'psychic'),
    (4, 'Crobat', 'rare', 'https://images.pokemontcg.io/neo3/4_hires.png', 'grass'),
    (5, 'Delibird', 'rare', 'https://images.pokemontcg.io/neo3/5_hires.png', 'colorless'),
    (6, 'Entei', 'rare', 'https://images.pokemontcg.io/neo3/6_hires.png', 'fire'),
    (7, 'Ho-oh', 'rare', 'https://images.pokemontcg.io/neo3/7_hires.png', 'fire'),
    (8, 'Houndoom', 'rare', 'https://images.pokemontcg.io/neo3/8_hires.png', 'darkness'),
    (9, 'Jumpluff', 'rare', 'https://images.pokemontcg.io/neo3/9_hires.png', 'grass'),
    (10, 'Magneton', 'rare', 'https://images.pokemontcg.io/neo3/10_hires.png', 'metal'),
    (11, 'Misdreavus', 'rare', 'https://images.pokemontcg.io/neo3/11_hires.png', 'psychic'),
    (12, 'Porygon2', 'rare', 'https://images.pokemontcg.io/neo3/12_hires.png', 'colorless'),
    (13, 'Raikou', 'rare', 'https://images.pokemontcg.io/neo3/13_hires.png', 'lightning'),
    (14, 'Suicune', 'rare', 'https://images.pokemontcg.io/neo3/14_hires.png', 'water'),
    (15, 'Aerodactyl', 'rare', 'https://images.pokemontcg.io/neo3/15_hires.png', 'fighting'),
    (16, 'Celebi', 'rare', 'https://images.pokemontcg.io/neo3/16_hires.png', 'grass'),
    (17, 'Entei', 'rare', 'https://images.pokemontcg.io/neo3/17_hires.png', 'fire'),
    (18, 'Ho-oh', 'rare', 'https://images.pokemontcg.io/neo3/18_hires.png', 'colorless'),
    (19, 'Kingdra', 'rare', 'https://images.pokemontcg.io/neo3/19_hires.png', 'water'),
    (20, 'Lugia', 'rare', 'https://images.pokemontcg.io/neo3/20_hires.png', 'psychic'),
    (21, 'Raichu', 'rare', 'https://images.pokemontcg.io/neo3/21_hires.png', 'lightning'),
    (22, 'Raikou', 'rare', 'https://images.pokemontcg.io/neo3/22_hires.png', 'lightning'),
    (23, 'Skarmory', 'rare', 'https://images.pokemontcg.io/neo3/23_hires.png', 'metal'),
    (24, 'Sneasel', 'rare', 'https://images.pokemontcg.io/neo3/24_hires.png', 'darkness'),
    (25, 'Starmie', 'rare', 'https://images.pokemontcg.io/neo3/25_hires.png', 'psychic'),
    (26, 'Sudowoodo', 'rare', 'https://images.pokemontcg.io/neo3/26_hires.png', 'fighting'),
    (27, 'Suicune', 'rare', 'https://images.pokemontcg.io/neo3/27_hires.png', 'water'),
    (28, 'Flaaffy', 'common', 'https://images.pokemontcg.io/neo3/28_hires.png', 'lightning'),
    (29, 'Golbat', 'common', 'https://images.pokemontcg.io/neo3/29_hires.png', 'grass'),
    (30, 'Graveler', 'common', 'https://images.pokemontcg.io/neo3/30_hires.png', 'fighting'),
    (31, 'Jynx', 'common', 'https://images.pokemontcg.io/neo3/31_hires.png', 'water'),
    (32, 'Lanturn', 'common', 'https://images.pokemontcg.io/neo3/32_hires.png', 'lightning'),
    (33, 'Magcargo', 'common', 'https://images.pokemontcg.io/neo3/33_hires.png', 'fire'),
    (34, 'Octillery', 'common', 'https://images.pokemontcg.io/neo3/34_hires.png', 'water'),
    (35, 'Parasect', 'common', 'https://images.pokemontcg.io/neo3/35_hires.png', 'grass'),
    (36, 'Piloswine', 'common', 'https://images.pokemontcg.io/neo3/36_hires.png', 'fighting'),
    (37, 'Seaking', 'common', 'https://images.pokemontcg.io/neo3/37_hires.png', 'water'),
    (38, 'Stantler', 'common', 'https://images.pokemontcg.io/neo3/38_hires.png', 'colorless'),
    (39, 'Unown [B]', 'common', 'https://images.pokemontcg.io/neo3/39_hires.png', 'psychic'),
    (40, 'Unown [Y]', 'common', 'https://images.pokemontcg.io/neo3/40_hires.png', 'psychic'),
    (41, 'Aipom', 'common', 'https://images.pokemontcg.io/neo3/41_hires.png', 'colorless'),
    (42, 'Chinchou', 'common', 'https://images.pokemontcg.io/neo3/42_hires.png', 'lightning'),
    (43, 'Farfetch''d', 'common', 'https://images.pokemontcg.io/neo3/43_hires.png', 'colorless'),
    (44, 'Geodude', 'common', 'https://images.pokemontcg.io/neo3/44_hires.png', 'fighting'),
    (45, 'Goldeen', 'common', 'https://images.pokemontcg.io/neo3/45_hires.png', 'water'),
    (46, 'Murkrow', 'common', 'https://images.pokemontcg.io/neo3/46_hires.png', 'darkness'),
    (47, 'Paras', 'common', 'https://images.pokemontcg.io/neo3/47_hires.png', 'grass'),
    (48, 'Quagsire', 'common', 'https://images.pokemontcg.io/neo3/48_hires.png', 'water'),
    (49, 'Qwilfish', 'common', 'https://images.pokemontcg.io/neo3/49_hires.png', 'water'),
    (50, 'Remoraid', 'common', 'https://images.pokemontcg.io/neo3/50_hires.png', 'water'),
    (51, 'Shuckle', 'common', 'https://images.pokemontcg.io/neo3/51_hires.png', 'fighting'),
    (52, 'Skiploom', 'common', 'https://images.pokemontcg.io/neo3/52_hires.png', 'grass'),
    (53, 'Slugma', 'common', 'https://images.pokemontcg.io/neo3/53_hires.png', 'fire'),
    (54, 'Smoochum', 'common', 'https://images.pokemontcg.io/neo3/54_hires.png', 'psychic'),
    (55, 'Snubbull', 'common', 'https://images.pokemontcg.io/neo3/55_hires.png', 'colorless'),
    (56, 'Staryu', 'common', 'https://images.pokemontcg.io/neo3/56_hires.png', 'water'),
    (57, 'Swinub', 'common', 'https://images.pokemontcg.io/neo3/57_hires.png', 'fighting'),
    (58, 'Unown [K]', 'common', 'https://images.pokemontcg.io/neo3/58_hires.png', 'psychic'),
    (59, 'Zubat', 'common', 'https://images.pokemontcg.io/neo3/59_hires.png', 'grass'),
    (60, 'Balloon Berry', 'common', 'https://images.pokemontcg.io/neo3/60_hires.png', NULL),
    (61, 'Healing Field', 'common', 'https://images.pokemontcg.io/neo3/61_hires.png', NULL),
    (62, 'Pokémon Breeder Fields', 'common', 'https://images.pokemontcg.io/neo3/62_hires.png', NULL),
    (63, 'Rocket''s Hideout', 'common', 'https://images.pokemontcg.io/neo3/63_hires.png', NULL),
    (64, 'Old Rod', 'common', 'https://images.pokemontcg.io/neo3/64_hires.png', NULL),
    (65, 'Shining Gyarados', 'ultra_rare', 'https://images.pokemontcg.io/neo3/65_hires.png', 'water'),
    (66, 'Shining Magikarp', 'ultra_rare', 'https://images.pokemontcg.io/neo3/66_hires.png', 'water')
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

-- Set: Neo Destiny (neo4) -- 2002/02/28
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('neo', 'Neo', 'neo-destiny', 'Neo Destiny', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'neo-destiny'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Dark Ampharos', 'rare', 'https://images.pokemontcg.io/neo4/1_hires.png', 'lightning'),
    (2, 'Dark Crobat', 'rare', 'https://images.pokemontcg.io/neo4/2_hires.png', 'grass'),
    (3, 'Dark Donphan', 'rare', 'https://images.pokemontcg.io/neo4/3_hires.png', 'fighting'),
    (4, 'Dark Espeon', 'rare', 'https://images.pokemontcg.io/neo4/4_hires.png', 'psychic'),
    (5, 'Dark Feraligatr', 'rare', 'https://images.pokemontcg.io/neo4/5_hires.png', 'water'),
    (6, 'Dark Gengar', 'rare', 'https://images.pokemontcg.io/neo4/6_hires.png', 'psychic'),
    (7, 'Dark Houndoom', 'rare', 'https://images.pokemontcg.io/neo4/7_hires.png', 'fire'),
    (8, 'Dark Porygon2', 'rare', 'https://images.pokemontcg.io/neo4/8_hires.png', 'colorless'),
    (9, 'Dark Scizor', 'rare', 'https://images.pokemontcg.io/neo4/9_hires.png', 'metal'),
    (10, 'Dark Typhlosion', 'rare', 'https://images.pokemontcg.io/neo4/10_hires.png', 'fire'),
    (11, 'Dark Tyranitar', 'rare', 'https://images.pokemontcg.io/neo4/11_hires.png', 'fighting'),
    (12, 'Light Arcanine', 'rare', 'https://images.pokemontcg.io/neo4/12_hires.png', 'fire'),
    (13, 'Light Azumarill', 'rare', 'https://images.pokemontcg.io/neo4/13_hires.png', 'water'),
    (14, 'Light Dragonite', 'rare', 'https://images.pokemontcg.io/neo4/14_hires.png', 'colorless'),
    (15, 'Light Togetic', 'rare', 'https://images.pokemontcg.io/neo4/15_hires.png', 'colorless'),
    (16, 'Miracle Energy', 'rare', 'https://images.pokemontcg.io/neo4/16_hires.png', NULL),
    (17, 'Dark Ariados', 'rare', 'https://images.pokemontcg.io/neo4/17_hires.png', 'grass'),
    (18, 'Dark Magcargo', 'rare', 'https://images.pokemontcg.io/neo4/18_hires.png', 'fire'),
    (19, 'Dark Omastar', 'rare', 'https://images.pokemontcg.io/neo4/19_hires.png', 'water'),
    (20, 'Dark Slowking', 'rare', 'https://images.pokemontcg.io/neo4/20_hires.png', 'psychic'),
    (21, 'Dark Ursaring', 'rare', 'https://images.pokemontcg.io/neo4/21_hires.png', 'colorless'),
    (22, 'Light Dragonair', 'rare', 'https://images.pokemontcg.io/neo4/22_hires.png', 'colorless'),
    (23, 'Light Lanturn', 'rare', 'https://images.pokemontcg.io/neo4/23_hires.png', 'lightning'),
    (24, 'Light Ledian', 'rare', 'https://images.pokemontcg.io/neo4/24_hires.png', 'grass'),
    (25, 'Light Machamp', 'rare', 'https://images.pokemontcg.io/neo4/25_hires.png', 'fighting'),
    (26, 'Light Piloswine', 'rare', 'https://images.pokemontcg.io/neo4/26_hires.png', 'water'),
    (27, 'Unown [G]', 'rare', 'https://images.pokemontcg.io/neo4/27_hires.png', 'psychic'),
    (28, 'Unown [H]', 'rare', 'https://images.pokemontcg.io/neo4/28_hires.png', 'psychic'),
    (29, 'Unown [W]', 'rare', 'https://images.pokemontcg.io/neo4/29_hires.png', 'psychic'),
    (30, 'Unown [X]', 'rare', 'https://images.pokemontcg.io/neo4/30_hires.png', 'psychic'),
    (31, 'Chansey', 'common', 'https://images.pokemontcg.io/neo4/31_hires.png', 'colorless'),
    (32, 'Dark Croconaw', 'common', 'https://images.pokemontcg.io/neo4/32_hires.png', 'water'),
    (33, 'Dark Exeggutor', 'common', 'https://images.pokemontcg.io/neo4/33_hires.png', 'psychic'),
    (34, 'Dark Flaaffy', 'common', 'https://images.pokemontcg.io/neo4/34_hires.png', 'lightning'),
    (35, 'Dark Forretress', 'common', 'https://images.pokemontcg.io/neo4/35_hires.png', 'grass'),
    (36, 'Dark Haunter', 'common', 'https://images.pokemontcg.io/neo4/36_hires.png', 'psychic'),
    (37, 'Dark Omanyte', 'common', 'https://images.pokemontcg.io/neo4/37_hires.png', 'water'),
    (38, 'Dark Pupitar', 'common', 'https://images.pokemontcg.io/neo4/38_hires.png', 'fighting'),
    (39, 'Dark Quilava', 'common', 'https://images.pokemontcg.io/neo4/39_hires.png', 'fire'),
    (40, 'Dark Wigglytuff', 'common', 'https://images.pokemontcg.io/neo4/40_hires.png', 'colorless'),
    (41, 'Heracross', 'common', 'https://images.pokemontcg.io/neo4/41_hires.png', 'grass'),
    (42, 'Hitmonlee', 'common', 'https://images.pokemontcg.io/neo4/42_hires.png', 'fighting'),
    (43, 'Houndour', 'common', 'https://images.pokemontcg.io/neo4/43_hires.png', 'darkness'),
    (44, 'Jigglypuff', 'common', 'https://images.pokemontcg.io/neo4/44_hires.png', 'colorless'),
    (45, 'Light Dewgong', 'common', 'https://images.pokemontcg.io/neo4/45_hires.png', 'water'),
    (46, 'Light Flareon', 'common', 'https://images.pokemontcg.io/neo4/46_hires.png', 'fire'),
    (47, 'Light Golduck', 'common', 'https://images.pokemontcg.io/neo4/47_hires.png', 'water'),
    (48, 'Light Jolteon', 'common', 'https://images.pokemontcg.io/neo4/48_hires.png', 'lightning'),
    (49, 'Light Machoke', 'common', 'https://images.pokemontcg.io/neo4/49_hires.png', 'fighting'),
    (50, 'Light Ninetales', 'common', 'https://images.pokemontcg.io/neo4/50_hires.png', 'fire'),
    (51, 'Light Slowbro', 'common', 'https://images.pokemontcg.io/neo4/51_hires.png', 'psychic'),
    (52, 'Light Vaporeon', 'common', 'https://images.pokemontcg.io/neo4/52_hires.png', 'water'),
    (53, 'Light Venomoth', 'common', 'https://images.pokemontcg.io/neo4/53_hires.png', 'grass'),
    (54, 'Light Wigglytuff', 'common', 'https://images.pokemontcg.io/neo4/54_hires.png', 'colorless'),
    (55, 'Scyther', 'common', 'https://images.pokemontcg.io/neo4/55_hires.png', 'grass'),
    (56, 'Togepi', 'common', 'https://images.pokemontcg.io/neo4/56_hires.png', 'colorless'),
    (57, 'Unown [C]', 'common', 'https://images.pokemontcg.io/neo4/57_hires.png', 'psychic'),
    (58, 'Unown [P]', 'common', 'https://images.pokemontcg.io/neo4/58_hires.png', 'psychic'),
    (59, 'Unown [Q]', 'common', 'https://images.pokemontcg.io/neo4/59_hires.png', 'psychic'),
    (60, 'Unown [Z]', 'common', 'https://images.pokemontcg.io/neo4/60_hires.png', 'psychic'),
    (61, 'Cyndaquil', 'common', 'https://images.pokemontcg.io/neo4/61_hires.png', 'fire'),
    (62, 'Dark Octillery', 'common', 'https://images.pokemontcg.io/neo4/62_hires.png', 'water'),
    (63, 'Dratini', 'common', 'https://images.pokemontcg.io/neo4/63_hires.png', 'colorless'),
    (64, 'Exeggcute', 'common', 'https://images.pokemontcg.io/neo4/64_hires.png', 'psychic'),
    (65, 'Gastly', 'common', 'https://images.pokemontcg.io/neo4/65_hires.png', 'psychic'),
    (66, 'Girafarig', 'common', 'https://images.pokemontcg.io/neo4/66_hires.png', 'colorless'),
    (67, 'Gligar', 'common', 'https://images.pokemontcg.io/neo4/67_hires.png', 'fighting'),
    (68, 'Growlithe', 'common', 'https://images.pokemontcg.io/neo4/68_hires.png', 'fire'),
    (69, 'Hitmonchan', 'common', 'https://images.pokemontcg.io/neo4/69_hires.png', 'fighting'),
    (70, 'Larvitar', 'common', 'https://images.pokemontcg.io/neo4/70_hires.png', 'fighting'),
    (71, 'Ledyba', 'common', 'https://images.pokemontcg.io/neo4/71_hires.png', 'grass'),
    (72, 'Light Sunflora', 'common', 'https://images.pokemontcg.io/neo4/72_hires.png', 'grass'),
    (73, 'Machop', 'common', 'https://images.pokemontcg.io/neo4/73_hires.png', 'fighting'),
    (74, 'Mantine', 'common', 'https://images.pokemontcg.io/neo4/74_hires.png', 'water'),
    (75, 'Mareep', 'common', 'https://images.pokemontcg.io/neo4/75_hires.png', 'lightning'),
    (76, 'Phanpy', 'common', 'https://images.pokemontcg.io/neo4/76_hires.png', 'fighting'),
    (77, 'Pineco', 'common', 'https://images.pokemontcg.io/neo4/77_hires.png', 'grass'),
    (78, 'Porygon', 'common', 'https://images.pokemontcg.io/neo4/78_hires.png', 'colorless'),
    (79, 'Psyduck', 'common', 'https://images.pokemontcg.io/neo4/79_hires.png', 'water'),
    (80, 'Remoraid', 'common', 'https://images.pokemontcg.io/neo4/80_hires.png', 'water'),
    (81, 'Seel', 'common', 'https://images.pokemontcg.io/neo4/81_hires.png', 'water'),
    (82, 'Slugma', 'common', 'https://images.pokemontcg.io/neo4/82_hires.png', 'fire'),
    (83, 'Sunkern', 'common', 'https://images.pokemontcg.io/neo4/83_hires.png', 'grass'),
    (84, 'Swinub', 'common', 'https://images.pokemontcg.io/neo4/84_hires.png', 'water'),
    (85, 'Totodile', 'common', 'https://images.pokemontcg.io/neo4/85_hires.png', 'water'),
    (86, 'Unown [L]', 'common', 'https://images.pokemontcg.io/neo4/86_hires.png', 'psychic'),
    (87, 'Unown [S]', 'common', 'https://images.pokemontcg.io/neo4/87_hires.png', 'psychic'),
    (88, 'Unown [T]', 'common', 'https://images.pokemontcg.io/neo4/88_hires.png', 'psychic'),
    (89, 'Unown [V]', 'common', 'https://images.pokemontcg.io/neo4/89_hires.png', 'psychic'),
    (90, 'Venonat', 'common', 'https://images.pokemontcg.io/neo4/90_hires.png', 'grass'),
    (91, 'Vulpix', 'common', 'https://images.pokemontcg.io/neo4/91_hires.png', 'fire'),
    (92, 'Broken Ground Gym', 'rare', 'https://images.pokemontcg.io/neo4/92_hires.png', NULL),
    (93, 'EXP.ALL', 'rare', 'https://images.pokemontcg.io/neo4/93_hires.png', NULL),
    (94, 'Impostor Professor Oak''s Invention', 'rare', 'https://images.pokemontcg.io/neo4/94_hires.png', NULL),
    (95, 'Radio Tower', 'rare', 'https://images.pokemontcg.io/neo4/95_hires.png', NULL),
    (96, 'Thought Wave Machine', 'rare', 'https://images.pokemontcg.io/neo4/96_hires.png', NULL),
    (97, 'Counterattack Claws', 'common', 'https://images.pokemontcg.io/neo4/97_hires.png', NULL),
    (98, 'Energy Amplifier', 'common', 'https://images.pokemontcg.io/neo4/98_hires.png', NULL),
    (99, 'Energy Stadium', 'common', 'https://images.pokemontcg.io/neo4/99_hires.png', NULL),
    (100, 'Lucky Stadium', 'common', 'https://images.pokemontcg.io/neo4/100_hires.png', NULL),
    (101, 'Magnifier', 'common', 'https://images.pokemontcg.io/neo4/101_hires.png', NULL),
    (102, 'Pokémon Personality Test', 'common', 'https://images.pokemontcg.io/neo4/102_hires.png', NULL),
    (103, 'Team Rocket''s Evil Deeds', 'common', 'https://images.pokemontcg.io/neo4/103_hires.png', NULL),
    (104, 'Heal Powder', 'common', 'https://images.pokemontcg.io/neo4/104_hires.png', NULL),
    (105, 'Mail from Bill', 'common', 'https://images.pokemontcg.io/neo4/105_hires.png', NULL),
    (106, 'Shining Celebi', 'ultra_rare', 'https://images.pokemontcg.io/neo4/106_hires.png', 'grass'),
    (107, 'Shining Charizard', 'ultra_rare', 'https://images.pokemontcg.io/neo4/107_hires.png', 'fire'),
    (108, 'Shining Kabutops', 'ultra_rare', 'https://images.pokemontcg.io/neo4/108_hires.png', 'fighting'),
    (109, 'Shining Mewtwo', 'ultra_rare', 'https://images.pokemontcg.io/neo4/109_hires.png', 'psychic'),
    (110, 'Shining Noctowl', 'ultra_rare', 'https://images.pokemontcg.io/neo4/110_hires.png', 'colorless'),
    (111, 'Shining Raichu', 'ultra_rare', 'https://images.pokemontcg.io/neo4/111_hires.png', 'lightning'),
    (112, 'Shining Steelix', 'ultra_rare', 'https://images.pokemontcg.io/neo4/112_hires.png', 'metal'),
    (113, 'Shining Tyranitar', 'ultra_rare', 'https://images.pokemontcg.io/neo4/113_hires.png', 'darkness')
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
