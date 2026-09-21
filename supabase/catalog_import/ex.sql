-- Katalogimport: EX (20 set)
-- Endast katalogdata (lager 0, pris 0) för portfölj/önskelista-funktionen.

-- Set: Ruby & Sapphire (ex1) -- 2003/07/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'ruby-sapphire', 'Ruby & Sapphire', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'ruby-sapphire'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Aggron', 'rare', 'https://images.pokemontcg.io/ex1/1_hires.png', 'metal'),
    (2, 'Beautifly', 'rare', 'https://images.pokemontcg.io/ex1/2_hires.png', 'grass'),
    (3, 'Blaziken', 'rare', 'https://images.pokemontcg.io/ex1/3_hires.png', 'fire'),
    (4, 'Camerupt', 'rare', 'https://images.pokemontcg.io/ex1/4_hires.png', 'fire'),
    (5, 'Delcatty', 'rare', 'https://images.pokemontcg.io/ex1/5_hires.png', 'colorless'),
    (6, 'Dustox', 'rare', 'https://images.pokemontcg.io/ex1/6_hires.png', 'grass'),
    (7, 'Gardevoir', 'rare', 'https://images.pokemontcg.io/ex1/7_hires.png', 'psychic'),
    (8, 'Hariyama', 'rare', 'https://images.pokemontcg.io/ex1/8_hires.png', 'fighting'),
    (9, 'Manectric', 'rare', 'https://images.pokemontcg.io/ex1/9_hires.png', 'lightning'),
    (10, 'Mightyena', 'rare', 'https://images.pokemontcg.io/ex1/10_hires.png', 'darkness'),
    (11, 'Sceptile', 'rare', 'https://images.pokemontcg.io/ex1/11_hires.png', 'grass'),
    (12, 'Slaking', 'rare', 'https://images.pokemontcg.io/ex1/12_hires.png', 'colorless'),
    (13, 'Swampert', 'rare', 'https://images.pokemontcg.io/ex1/13_hires.png', 'water'),
    (14, 'Wailord', 'rare', 'https://images.pokemontcg.io/ex1/14_hires.png', 'water'),
    (15, 'Blaziken', 'rare', 'https://images.pokemontcg.io/ex1/15_hires.png', 'fire'),
    (16, 'Breloom', 'rare', 'https://images.pokemontcg.io/ex1/16_hires.png', 'grass'),
    (17, 'Donphan', 'rare', 'https://images.pokemontcg.io/ex1/17_hires.png', 'fighting'),
    (18, 'Nosepass', 'rare', 'https://images.pokemontcg.io/ex1/18_hires.png', 'fighting'),
    (19, 'Pelipper', 'rare', 'https://images.pokemontcg.io/ex1/19_hires.png', 'water'),
    (20, 'Sceptile', 'rare', 'https://images.pokemontcg.io/ex1/20_hires.png', 'grass'),
    (21, 'Seaking', 'rare', 'https://images.pokemontcg.io/ex1/21_hires.png', 'water'),
    (22, 'Sharpedo', 'rare', 'https://images.pokemontcg.io/ex1/22_hires.png', 'water'),
    (23, 'Swampert', 'rare', 'https://images.pokemontcg.io/ex1/23_hires.png', 'water'),
    (24, 'Weezing', 'rare', 'https://images.pokemontcg.io/ex1/24_hires.png', 'grass'),
    (25, 'Aron', 'common', 'https://images.pokemontcg.io/ex1/25_hires.png', 'metal'),
    (26, 'Cascoon', 'common', 'https://images.pokemontcg.io/ex1/26_hires.png', 'grass'),
    (27, 'Combusken', 'common', 'https://images.pokemontcg.io/ex1/27_hires.png', 'fire'),
    (28, 'Combusken', 'common', 'https://images.pokemontcg.io/ex1/28_hires.png', 'fire'),
    (29, 'Delcatty', 'common', 'https://images.pokemontcg.io/ex1/29_hires.png', 'colorless'),
    (30, 'Electrike', 'common', 'https://images.pokemontcg.io/ex1/30_hires.png', 'lightning'),
    (31, 'Grovyle', 'common', 'https://images.pokemontcg.io/ex1/31_hires.png', 'grass'),
    (32, 'Grovyle', 'common', 'https://images.pokemontcg.io/ex1/32_hires.png', 'grass'),
    (33, 'Hariyama', 'common', 'https://images.pokemontcg.io/ex1/33_hires.png', 'fighting'),
    (34, 'Kirlia', 'common', 'https://images.pokemontcg.io/ex1/34_hires.png', 'psychic'),
    (35, 'Kirlia', 'common', 'https://images.pokemontcg.io/ex1/35_hires.png', 'psychic'),
    (36, 'Lairon', 'common', 'https://images.pokemontcg.io/ex1/36_hires.png', 'metal'),
    (37, 'Lairon', 'common', 'https://images.pokemontcg.io/ex1/37_hires.png', 'metal'),
    (38, 'Linoone', 'common', 'https://images.pokemontcg.io/ex1/38_hires.png', 'colorless'),
    (39, 'Manectric', 'common', 'https://images.pokemontcg.io/ex1/39_hires.png', 'lightning'),
    (40, 'Marshtomp', 'common', 'https://images.pokemontcg.io/ex1/40_hires.png', 'water'),
    (41, 'Marshtomp', 'common', 'https://images.pokemontcg.io/ex1/41_hires.png', 'water'),
    (42, 'Mightyena', 'common', 'https://images.pokemontcg.io/ex1/42_hires.png', 'darkness'),
    (43, 'Silcoon', 'common', 'https://images.pokemontcg.io/ex1/43_hires.png', 'grass'),
    (44, 'Skitty', 'common', 'https://images.pokemontcg.io/ex1/44_hires.png', 'colorless'),
    (45, 'Slakoth', 'common', 'https://images.pokemontcg.io/ex1/45_hires.png', 'colorless'),
    (46, 'Swellow', 'common', 'https://images.pokemontcg.io/ex1/46_hires.png', 'colorless'),
    (47, 'Vigoroth', 'common', 'https://images.pokemontcg.io/ex1/47_hires.png', 'colorless'),
    (48, 'Wailmer', 'common', 'https://images.pokemontcg.io/ex1/48_hires.png', 'water'),
    (49, 'Aron', 'common', 'https://images.pokemontcg.io/ex1/49_hires.png', 'metal'),
    (50, 'Aron', 'common', 'https://images.pokemontcg.io/ex1/50_hires.png', 'metal'),
    (51, 'Carvanha', 'common', 'https://images.pokemontcg.io/ex1/51_hires.png', 'water'),
    (52, 'Electrike', 'common', 'https://images.pokemontcg.io/ex1/52_hires.png', 'lightning'),
    (53, 'Electrike', 'common', 'https://images.pokemontcg.io/ex1/53_hires.png', 'lightning'),
    (54, 'Koffing', 'common', 'https://images.pokemontcg.io/ex1/54_hires.png', 'grass'),
    (55, 'Goldeen', 'common', 'https://images.pokemontcg.io/ex1/55_hires.png', 'water'),
    (56, 'Makuhita', 'common', 'https://images.pokemontcg.io/ex1/56_hires.png', 'fighting'),
    (57, 'Makuhita', 'common', 'https://images.pokemontcg.io/ex1/57_hires.png', 'fighting'),
    (58, 'Makuhita', 'common', 'https://images.pokemontcg.io/ex1/58_hires.png', 'fighting'),
    (59, 'Mudkip', 'common', 'https://images.pokemontcg.io/ex1/59_hires.png', 'water'),
    (60, 'Mudkip', 'common', 'https://images.pokemontcg.io/ex1/60_hires.png', 'water'),
    (61, 'Numel', 'common', 'https://images.pokemontcg.io/ex1/61_hires.png', 'fire'),
    (62, 'Phanpy', 'common', 'https://images.pokemontcg.io/ex1/62_hires.png', 'fighting'),
    (63, 'Poochyena', 'common', 'https://images.pokemontcg.io/ex1/63_hires.png', 'darkness'),
    (64, 'Poochyena', 'common', 'https://images.pokemontcg.io/ex1/64_hires.png', 'darkness'),
    (65, 'Poochyena', 'common', 'https://images.pokemontcg.io/ex1/65_hires.png', 'darkness'),
    (66, 'Ralts', 'common', 'https://images.pokemontcg.io/ex1/66_hires.png', 'psychic'),
    (67, 'Ralts', 'common', 'https://images.pokemontcg.io/ex1/67_hires.png', 'psychic'),
    (68, 'Ralts', 'common', 'https://images.pokemontcg.io/ex1/68_hires.png', 'psychic'),
    (69, 'Shroomish', 'common', 'https://images.pokemontcg.io/ex1/69_hires.png', 'grass'),
    (70, 'Skitty', 'common', 'https://images.pokemontcg.io/ex1/70_hires.png', 'colorless'),
    (71, 'Skitty', 'common', 'https://images.pokemontcg.io/ex1/71_hires.png', 'colorless'),
    (72, 'Taillow', 'common', 'https://images.pokemontcg.io/ex1/72_hires.png', 'colorless'),
    (73, 'Torchic', 'common', 'https://images.pokemontcg.io/ex1/73_hires.png', 'fire'),
    (74, 'Torchic', 'common', 'https://images.pokemontcg.io/ex1/74_hires.png', 'fire'),
    (75, 'Treecko', 'common', 'https://images.pokemontcg.io/ex1/75_hires.png', 'grass'),
    (76, 'Treecko', 'common', 'https://images.pokemontcg.io/ex1/76_hires.png', 'grass'),
    (77, 'Wingull', 'common', 'https://images.pokemontcg.io/ex1/77_hires.png', 'water'),
    (78, 'Wurmple', 'common', 'https://images.pokemontcg.io/ex1/78_hires.png', 'grass'),
    (79, 'Zigzagoon', 'common', 'https://images.pokemontcg.io/ex1/79_hires.png', 'colorless'),
    (80, 'Energy Removal 2', 'common', 'https://images.pokemontcg.io/ex1/80_hires.png', NULL),
    (81, 'Energy Restore', 'common', 'https://images.pokemontcg.io/ex1/81_hires.png', NULL),
    (82, 'Energy Switch', 'common', 'https://images.pokemontcg.io/ex1/82_hires.png', NULL),
    (83, 'Lady Outing', 'common', 'https://images.pokemontcg.io/ex1/83_hires.png', NULL),
    (84, 'Lum Berry', 'common', 'https://images.pokemontcg.io/ex1/84_hires.png', NULL),
    (85, 'Oran Berry', 'common', 'https://images.pokemontcg.io/ex1/85_hires.png', NULL),
    (86, 'Poké Ball', 'common', 'https://images.pokemontcg.io/ex1/86_hires.png', NULL),
    (87, 'Pokémon Reversal', 'common', 'https://images.pokemontcg.io/ex1/87_hires.png', NULL),
    (88, 'PokéNav', 'common', 'https://images.pokemontcg.io/ex1/88_hires.png', NULL),
    (89, 'Professor Birch', 'common', 'https://images.pokemontcg.io/ex1/89_hires.png', NULL),
    (90, 'Energy Search', 'common', 'https://images.pokemontcg.io/ex1/90_hires.png', NULL),
    (91, 'Potion', 'common', 'https://images.pokemontcg.io/ex1/91_hires.png', NULL),
    (92, 'Switch', 'common', 'https://images.pokemontcg.io/ex1/92_hires.png', NULL),
    (93, 'Darkness Energy', 'rare', 'https://images.pokemontcg.io/ex1/93_hires.png', NULL),
    (94, 'Metal Energy', 'rare', 'https://images.pokemontcg.io/ex1/94_hires.png', NULL),
    (95, 'Rainbow Energy', 'rare', 'https://images.pokemontcg.io/ex1/95_hires.png', NULL),
    (96, 'Chansey ex', 'double_rare', 'https://images.pokemontcg.io/ex1/96_hires.png', 'colorless'),
    (97, 'Electabuzz ex', 'double_rare', 'https://images.pokemontcg.io/ex1/97_hires.png', 'lightning'),
    (98, 'Hitmonchan ex', 'double_rare', 'https://images.pokemontcg.io/ex1/98_hires.png', 'fighting'),
    (99, 'Lapras ex', 'double_rare', 'https://images.pokemontcg.io/ex1/99_hires.png', 'water'),
    (100, 'Magmar ex', 'double_rare', 'https://images.pokemontcg.io/ex1/100_hires.png', 'fire'),
    (101, 'Mewtwo ex', 'double_rare', 'https://images.pokemontcg.io/ex1/101_hires.png', 'psychic'),
    (102, 'Scyther ex', 'double_rare', 'https://images.pokemontcg.io/ex1/102_hires.png', 'grass'),
    (103, 'Sneasel ex', 'double_rare', 'https://images.pokemontcg.io/ex1/103_hires.png', 'darkness'),
    (104, 'Grass Energy', 'common', 'https://images.pokemontcg.io/ex1/104_hires.png', NULL),
    (105, 'Fighting Energy', 'common', 'https://images.pokemontcg.io/ex1/105_hires.png', NULL),
    (106, 'Water Energy', 'common', 'https://images.pokemontcg.io/ex1/106_hires.png', NULL),
    (107, 'Psychic Energy', 'common', 'https://images.pokemontcg.io/ex1/107_hires.png', NULL),
    (108, 'Fire Energy', 'common', 'https://images.pokemontcg.io/ex1/108_hires.png', NULL),
    (109, 'Lightning Energy', 'common', 'https://images.pokemontcg.io/ex1/109_hires.png', NULL)
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

-- Set: Sandstorm (ex2) -- 2003/09/18
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'sandstorm', 'Sandstorm', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'sandstorm'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Armaldo', 'rare', 'https://images.pokemontcg.io/ex2/1_hires.png', 'fighting'),
    (2, 'Cacturne', 'rare', 'https://images.pokemontcg.io/ex2/2_hires.png', 'grass'),
    (3, 'Cradily', 'rare', 'https://images.pokemontcg.io/ex2/3_hires.png', 'grass'),
    (4, 'Dusclops', 'rare', 'https://images.pokemontcg.io/ex2/4_hires.png', 'psychic'),
    (5, 'Flareon', 'rare', 'https://images.pokemontcg.io/ex2/5_hires.png', 'fire'),
    (6, 'Jolteon', 'rare', 'https://images.pokemontcg.io/ex2/6_hires.png', 'lightning'),
    (7, 'Ludicolo', 'rare', 'https://images.pokemontcg.io/ex2/7_hires.png', 'water'),
    (8, 'Lunatone', 'rare', 'https://images.pokemontcg.io/ex2/8_hires.png', 'psychic'),
    (9, 'Mawile', 'rare', 'https://images.pokemontcg.io/ex2/9_hires.png', 'metal'),
    (10, 'Sableye', 'rare', 'https://images.pokemontcg.io/ex2/10_hires.png', 'darkness'),
    (11, 'Seviper', 'rare', 'https://images.pokemontcg.io/ex2/11_hires.png', 'grass'),
    (12, 'Shiftry', 'rare', 'https://images.pokemontcg.io/ex2/12_hires.png', 'grass'),
    (13, 'Solrock', 'rare', 'https://images.pokemontcg.io/ex2/13_hires.png', 'fighting'),
    (14, 'Zangoose', 'rare', 'https://images.pokemontcg.io/ex2/14_hires.png', 'colorless'),
    (15, 'Arcanine', 'rare', 'https://images.pokemontcg.io/ex2/15_hires.png', 'fire'),
    (16, 'Espeon', 'rare', 'https://images.pokemontcg.io/ex2/16_hires.png', 'psychic'),
    (17, 'Golduck', 'rare', 'https://images.pokemontcg.io/ex2/17_hires.png', 'water'),
    (18, 'Kecleon', 'rare', 'https://images.pokemontcg.io/ex2/18_hires.png', 'colorless'),
    (19, 'Omastar', 'rare', 'https://images.pokemontcg.io/ex2/19_hires.png', 'water'),
    (20, 'Pichu', 'rare', 'https://images.pokemontcg.io/ex2/20_hires.png', 'lightning'),
    (21, 'Sandslash', 'rare', 'https://images.pokemontcg.io/ex2/21_hires.png', 'fighting'),
    (22, 'Shiftry', 'rare', 'https://images.pokemontcg.io/ex2/22_hires.png', 'grass'),
    (23, 'Steelix', 'rare', 'https://images.pokemontcg.io/ex2/23_hires.png', 'metal'),
    (24, 'Umbreon', 'rare', 'https://images.pokemontcg.io/ex2/24_hires.png', 'darkness'),
    (25, 'Vaporeon', 'rare', 'https://images.pokemontcg.io/ex2/25_hires.png', 'water'),
    (26, 'Wobbuffet', 'rare', 'https://images.pokemontcg.io/ex2/26_hires.png', 'psychic'),
    (27, 'Anorith', 'common', 'https://images.pokemontcg.io/ex2/27_hires.png', 'fighting'),
    (28, 'Anorith', 'common', 'https://images.pokemontcg.io/ex2/28_hires.png', 'fighting'),
    (29, 'Arbok', 'common', 'https://images.pokemontcg.io/ex2/29_hires.png', 'grass'),
    (30, 'Azumarill', 'common', 'https://images.pokemontcg.io/ex2/30_hires.png', 'water'),
    (31, 'Azurill', 'common', 'https://images.pokemontcg.io/ex2/31_hires.png', 'colorless'),
    (32, 'Baltoy', 'common', 'https://images.pokemontcg.io/ex2/32_hires.png', 'fighting'),
    (33, 'Breloom', 'common', 'https://images.pokemontcg.io/ex2/33_hires.png', 'grass'),
    (34, 'Delcatty', 'common', 'https://images.pokemontcg.io/ex2/34_hires.png', 'colorless'),
    (35, 'Electabuzz', 'common', 'https://images.pokemontcg.io/ex2/35_hires.png', 'lightning'),
    (36, 'Elekid', 'common', 'https://images.pokemontcg.io/ex2/36_hires.png', 'lightning'),
    (37, 'Fearow', 'common', 'https://images.pokemontcg.io/ex2/37_hires.png', 'colorless'),
    (38, 'Illumise', 'common', 'https://images.pokemontcg.io/ex2/38_hires.png', 'grass'),
    (39, 'Kabuto', 'common', 'https://images.pokemontcg.io/ex2/39_hires.png', 'water'),
    (40, 'Kirlia', 'common', 'https://images.pokemontcg.io/ex2/40_hires.png', 'psychic'),
    (41, 'Lairon', 'common', 'https://images.pokemontcg.io/ex2/41_hires.png', 'metal'),
    (42, 'Lileep', 'common', 'https://images.pokemontcg.io/ex2/42_hires.png', 'grass'),
    (43, 'Lileep', 'common', 'https://images.pokemontcg.io/ex2/43_hires.png', 'grass'),
    (44, 'Linoone', 'common', 'https://images.pokemontcg.io/ex2/44_hires.png', 'colorless'),
    (45, 'Lombre', 'common', 'https://images.pokemontcg.io/ex2/45_hires.png', 'water'),
    (46, 'Lombre', 'common', 'https://images.pokemontcg.io/ex2/46_hires.png', 'water'),
    (47, 'Murkrow', 'common', 'https://images.pokemontcg.io/ex2/47_hires.png', 'darkness'),
    (48, 'Nuzleaf', 'common', 'https://images.pokemontcg.io/ex2/48_hires.png', 'grass'),
    (49, 'Nuzleaf', 'common', 'https://images.pokemontcg.io/ex2/49_hires.png', 'grass'),
    (50, 'Pelipper', 'common', 'https://images.pokemontcg.io/ex2/50_hires.png', 'water'),
    (51, 'Quilava', 'common', 'https://images.pokemontcg.io/ex2/51_hires.png', 'fire'),
    (52, 'Vigoroth', 'common', 'https://images.pokemontcg.io/ex2/52_hires.png', 'colorless'),
    (53, 'Volbeat', 'common', 'https://images.pokemontcg.io/ex2/53_hires.png', 'grass'),
    (54, 'Wynaut', 'common', 'https://images.pokemontcg.io/ex2/54_hires.png', 'psychic'),
    (55, 'Xatu', 'common', 'https://images.pokemontcg.io/ex2/55_hires.png', 'psychic'),
    (56, 'Aron', 'common', 'https://images.pokemontcg.io/ex2/56_hires.png', 'metal'),
    (57, 'Cacnea', 'common', 'https://images.pokemontcg.io/ex2/57_hires.png', 'grass'),
    (58, 'Cacnea', 'common', 'https://images.pokemontcg.io/ex2/58_hires.png', 'grass'),
    (59, 'Cyndaquil', 'common', 'https://images.pokemontcg.io/ex2/59_hires.png', 'fire'),
    (60, 'Dunsparce', 'common', 'https://images.pokemontcg.io/ex2/60_hires.png', 'colorless'),
    (61, 'Duskull', 'common', 'https://images.pokemontcg.io/ex2/61_hires.png', 'psychic'),
    (62, 'Duskull', 'common', 'https://images.pokemontcg.io/ex2/62_hires.png', 'psychic'),
    (63, 'Eevee', 'common', 'https://images.pokemontcg.io/ex2/63_hires.png', 'colorless'),
    (64, 'Ekans', 'common', 'https://images.pokemontcg.io/ex2/64_hires.png', 'grass'),
    (65, 'Growlithe', 'common', 'https://images.pokemontcg.io/ex2/65_hires.png', 'fire'),
    (66, 'Lotad', 'common', 'https://images.pokemontcg.io/ex2/66_hires.png', 'water'),
    (67, 'Lotad', 'common', 'https://images.pokemontcg.io/ex2/67_hires.png', 'water'),
    (68, 'Marill', 'common', 'https://images.pokemontcg.io/ex2/68_hires.png', 'water'),
    (69, 'Natu', 'common', 'https://images.pokemontcg.io/ex2/69_hires.png', 'psychic'),
    (70, 'Omanyte', 'common', 'https://images.pokemontcg.io/ex2/70_hires.png', 'water'),
    (71, 'Onix', 'common', 'https://images.pokemontcg.io/ex2/71_hires.png', 'fighting'),
    (72, 'Pikachu', 'common', 'https://images.pokemontcg.io/ex2/72_hires.png', 'lightning'),
    (73, 'Psyduck', 'common', 'https://images.pokemontcg.io/ex2/73_hires.png', 'water'),
    (74, 'Ralts', 'common', 'https://images.pokemontcg.io/ex2/74_hires.png', 'psychic'),
    (75, 'Sandshrew', 'common', 'https://images.pokemontcg.io/ex2/75_hires.png', 'fighting'),
    (76, 'Seedot', 'common', 'https://images.pokemontcg.io/ex2/76_hires.png', 'grass'),
    (77, 'Seedot', 'common', 'https://images.pokemontcg.io/ex2/77_hires.png', 'grass'),
    (78, 'Shroomish', 'common', 'https://images.pokemontcg.io/ex2/78_hires.png', 'grass'),
    (79, 'Skitty', 'common', 'https://images.pokemontcg.io/ex2/79_hires.png', 'colorless'),
    (80, 'Slakoth', 'common', 'https://images.pokemontcg.io/ex2/80_hires.png', 'colorless'),
    (81, 'Spearow', 'common', 'https://images.pokemontcg.io/ex2/81_hires.png', 'colorless'),
    (82, 'Trapinch', 'common', 'https://images.pokemontcg.io/ex2/82_hires.png', 'fighting'),
    (83, 'Wailmer', 'common', 'https://images.pokemontcg.io/ex2/83_hires.png', 'water'),
    (84, 'Wingull', 'common', 'https://images.pokemontcg.io/ex2/84_hires.png', 'water'),
    (85, 'Zigzagoon', 'common', 'https://images.pokemontcg.io/ex2/85_hires.png', 'colorless'),
    (86, 'Double Full Heal', 'common', 'https://images.pokemontcg.io/ex2/86_hires.png', NULL),
    (87, 'Lanette''s Net Search', 'common', 'https://images.pokemontcg.io/ex2/87_hires.png', NULL),
    (88, 'Rare Candy', 'common', 'https://images.pokemontcg.io/ex2/88_hires.png', NULL),
    (89, 'Wally''s Training', 'common', 'https://images.pokemontcg.io/ex2/89_hires.png', NULL),
    (90, 'Claw Fossil', 'common', 'https://images.pokemontcg.io/ex2/90_hires.png', NULL),
    (91, 'Mysterious Fossil', 'common', 'https://images.pokemontcg.io/ex2/91_hires.png', NULL),
    (92, 'Root Fossil', 'common', 'https://images.pokemontcg.io/ex2/92_hires.png', NULL),
    (93, 'Multi Energy', 'rare', 'https://images.pokemontcg.io/ex2/93_hires.png', NULL),
    (94, 'Aerodactyl ex', 'double_rare', 'https://images.pokemontcg.io/ex2/94_hires.png', 'colorless'),
    (95, 'Aggron ex', 'double_rare', 'https://images.pokemontcg.io/ex2/95_hires.png', 'metal'),
    (96, 'Gardevoir ex', 'double_rare', 'https://images.pokemontcg.io/ex2/96_hires.png', 'psychic'),
    (97, 'Kabutops ex', 'double_rare', 'https://images.pokemontcg.io/ex2/97_hires.png', 'water'),
    (98, 'Raichu ex', 'double_rare', 'https://images.pokemontcg.io/ex2/98_hires.png', 'lightning'),
    (99, 'Typhlosion ex', 'double_rare', 'https://images.pokemontcg.io/ex2/99_hires.png', 'fire'),
    (100, 'Wailord ex', 'double_rare', 'https://images.pokemontcg.io/ex2/100_hires.png', 'water')
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

-- Set: Dragon (ex3) -- 2003/11/24
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'dragon', 'Dragon', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'dragon'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Absol', 'rare', 'https://images.pokemontcg.io/ex3/1_hires.png', 'darkness'),
    (2, 'Altaria', 'rare', 'https://images.pokemontcg.io/ex3/2_hires.png', 'colorless'),
    (3, 'Crawdaunt', 'rare', 'https://images.pokemontcg.io/ex3/3_hires.png', 'water'),
    (4, 'Flygon', 'rare', 'https://images.pokemontcg.io/ex3/4_hires.png', 'colorless'),
    (5, 'Golem', 'rare', 'https://images.pokemontcg.io/ex3/5_hires.png', 'fighting'),
    (6, 'Grumpig', 'rare', 'https://images.pokemontcg.io/ex3/6_hires.png', 'psychic'),
    (7, 'Minun', 'rare', 'https://images.pokemontcg.io/ex3/7_hires.png', 'lightning'),
    (8, 'Plusle', 'rare', 'https://images.pokemontcg.io/ex3/8_hires.png', 'lightning'),
    (9, 'Roselia', 'rare', 'https://images.pokemontcg.io/ex3/9_hires.png', 'grass'),
    (10, 'Salamence', 'rare', 'https://images.pokemontcg.io/ex3/10_hires.png', 'colorless'),
    (11, 'Shedinja', 'rare', 'https://images.pokemontcg.io/ex3/11_hires.png', 'grass'),
    (12, 'Torkoal', 'rare', 'https://images.pokemontcg.io/ex3/12_hires.png', 'fire'),
    (13, 'Crawdaunt', 'rare', 'https://images.pokemontcg.io/ex3/13_hires.png', 'water'),
    (14, 'Dragonair', 'rare', 'https://images.pokemontcg.io/ex3/14_hires.png', 'colorless'),
    (15, 'Flygon', 'rare', 'https://images.pokemontcg.io/ex3/15_hires.png', 'colorless'),
    (16, 'Girafarig', 'rare', 'https://images.pokemontcg.io/ex3/16_hires.png', 'psychic'),
    (17, 'Magneton', 'rare', 'https://images.pokemontcg.io/ex3/17_hires.png', 'lightning'),
    (18, 'Ninjask', 'rare', 'https://images.pokemontcg.io/ex3/18_hires.png', 'grass'),
    (19, 'Salamence', 'rare', 'https://images.pokemontcg.io/ex3/19_hires.png', 'colorless'),
    (20, 'Shelgon', 'rare', 'https://images.pokemontcg.io/ex3/20_hires.png', 'colorless'),
    (21, 'Skarmory', 'rare', 'https://images.pokemontcg.io/ex3/21_hires.png', 'metal'),
    (22, 'Vibrava', 'rare', 'https://images.pokemontcg.io/ex3/22_hires.png', 'colorless'),
    (23, 'Bagon', 'common', 'https://images.pokemontcg.io/ex3/23_hires.png', 'colorless'),
    (24, 'Camerupt', 'common', 'https://images.pokemontcg.io/ex3/24_hires.png', 'fire'),
    (25, 'Combusken', 'common', 'https://images.pokemontcg.io/ex3/25_hires.png', 'fire'),
    (26, 'Dratini', 'common', 'https://images.pokemontcg.io/ex3/26_hires.png', 'colorless'),
    (27, 'Flaaffy', 'common', 'https://images.pokemontcg.io/ex3/27_hires.png', 'lightning'),
    (28, 'Forretress', 'common', 'https://images.pokemontcg.io/ex3/28_hires.png', 'metal'),
    (29, 'Graveler', 'common', 'https://images.pokemontcg.io/ex3/29_hires.png', 'fighting'),
    (30, 'Graveler', 'common', 'https://images.pokemontcg.io/ex3/30_hires.png', 'fighting'),
    (31, 'Grovyle', 'common', 'https://images.pokemontcg.io/ex3/31_hires.png', 'grass'),
    (32, 'Gyarados', 'common', 'https://images.pokemontcg.io/ex3/32_hires.png', 'water'),
    (33, 'Horsea', 'common', 'https://images.pokemontcg.io/ex3/33_hires.png', 'water'),
    (34, 'Houndoom', 'common', 'https://images.pokemontcg.io/ex3/34_hires.png', 'darkness'),
    (35, 'Magneton', 'common', 'https://images.pokemontcg.io/ex3/35_hires.png', 'lightning'),
    (36, 'Marshtomp', 'common', 'https://images.pokemontcg.io/ex3/36_hires.png', 'water'),
    (37, 'Meditite', 'common', 'https://images.pokemontcg.io/ex3/37_hires.png', 'fighting'),
    (38, 'Ninjask', 'common', 'https://images.pokemontcg.io/ex3/38_hires.png', 'grass'),
    (39, 'Seadra', 'common', 'https://images.pokemontcg.io/ex3/39_hires.png', 'water'),
    (40, 'Seadra', 'common', 'https://images.pokemontcg.io/ex3/40_hires.png', 'water'),
    (41, 'Shelgon', 'common', 'https://images.pokemontcg.io/ex3/41_hires.png', 'colorless'),
    (42, 'Shelgon', 'common', 'https://images.pokemontcg.io/ex3/42_hires.png', 'colorless'),
    (43, 'Shuppet', 'common', 'https://images.pokemontcg.io/ex3/43_hires.png', 'psychic'),
    (44, 'Snorunt', 'common', 'https://images.pokemontcg.io/ex3/44_hires.png', 'water'),
    (45, 'Swellow', 'common', 'https://images.pokemontcg.io/ex3/45_hires.png', 'colorless'),
    (46, 'Vibrava', 'common', 'https://images.pokemontcg.io/ex3/46_hires.png', 'colorless'),
    (47, 'Vibrava', 'common', 'https://images.pokemontcg.io/ex3/47_hires.png', 'colorless'),
    (48, 'Whiscash', 'common', 'https://images.pokemontcg.io/ex3/48_hires.png', 'water'),
    (49, 'Bagon', 'common', 'https://images.pokemontcg.io/ex3/49_hires.png', 'colorless'),
    (50, 'Bagon', 'common', 'https://images.pokemontcg.io/ex3/50_hires.png', 'colorless'),
    (51, 'Barboach', 'common', 'https://images.pokemontcg.io/ex3/51_hires.png', 'water'),
    (52, 'Corphish', 'common', 'https://images.pokemontcg.io/ex3/52_hires.png', 'water'),
    (53, 'Corphish', 'common', 'https://images.pokemontcg.io/ex3/53_hires.png', 'water'),
    (54, 'Corphish', 'common', 'https://images.pokemontcg.io/ex3/54_hires.png', 'water'),
    (55, 'Geodude', 'common', 'https://images.pokemontcg.io/ex3/55_hires.png', 'fighting'),
    (56, 'Geodude', 'common', 'https://images.pokemontcg.io/ex3/56_hires.png', 'fighting'),
    (57, 'Grimer', 'common', 'https://images.pokemontcg.io/ex3/57_hires.png', 'grass'),
    (58, 'Horsea', 'common', 'https://images.pokemontcg.io/ex3/58_hires.png', 'water'),
    (59, 'Houndour', 'common', 'https://images.pokemontcg.io/ex3/59_hires.png', 'darkness'),
    (60, 'Magikarp', 'common', 'https://images.pokemontcg.io/ex3/60_hires.png', 'water'),
    (61, 'Magnemite', 'common', 'https://images.pokemontcg.io/ex3/61_hires.png', 'lightning'),
    (62, 'Magnemite', 'common', 'https://images.pokemontcg.io/ex3/62_hires.png', 'lightning'),
    (63, 'Magnemite', 'common', 'https://images.pokemontcg.io/ex3/63_hires.png', 'lightning'),
    (64, 'Mareep', 'common', 'https://images.pokemontcg.io/ex3/64_hires.png', 'lightning'),
    (65, 'Mudkip', 'common', 'https://images.pokemontcg.io/ex3/65_hires.png', 'water'),
    (66, 'Nincada', 'common', 'https://images.pokemontcg.io/ex3/66_hires.png', 'grass'),
    (67, 'Nincada', 'common', 'https://images.pokemontcg.io/ex3/67_hires.png', 'grass'),
    (68, 'Nincada', 'common', 'https://images.pokemontcg.io/ex3/68_hires.png', 'grass'),
    (69, 'Numel', 'common', 'https://images.pokemontcg.io/ex3/69_hires.png', 'fire'),
    (70, 'Numel', 'common', 'https://images.pokemontcg.io/ex3/70_hires.png', 'fire'),
    (71, 'Pineco', 'common', 'https://images.pokemontcg.io/ex3/71_hires.png', 'grass'),
    (72, 'Slugma', 'common', 'https://images.pokemontcg.io/ex3/72_hires.png', 'fire'),
    (73, 'Spoink', 'common', 'https://images.pokemontcg.io/ex3/73_hires.png', 'psychic'),
    (74, 'Spoink', 'common', 'https://images.pokemontcg.io/ex3/74_hires.png', 'psychic'),
    (75, 'Swablu', 'common', 'https://images.pokemontcg.io/ex3/75_hires.png', 'colorless'),
    (76, 'Taillow', 'common', 'https://images.pokemontcg.io/ex3/76_hires.png', 'colorless'),
    (77, 'Torchic', 'common', 'https://images.pokemontcg.io/ex3/77_hires.png', 'fire'),
    (78, 'Trapinch', 'common', 'https://images.pokemontcg.io/ex3/78_hires.png', 'fighting'),
    (79, 'Trapinch', 'common', 'https://images.pokemontcg.io/ex3/79_hires.png', 'fighting'),
    (80, 'Treecko', 'common', 'https://images.pokemontcg.io/ex3/80_hires.png', 'grass'),
    (81, 'Wurmple', 'common', 'https://images.pokemontcg.io/ex3/81_hires.png', 'grass'),
    (82, 'Balloon Berry', 'common', 'https://images.pokemontcg.io/ex3/82_hires.png', NULL),
    (83, 'Buffer Piece', 'common', 'https://images.pokemontcg.io/ex3/83_hires.png', NULL),
    (84, 'Energy Recycle System', 'common', 'https://images.pokemontcg.io/ex3/84_hires.png', NULL),
    (85, 'High Pressure System', 'common', 'https://images.pokemontcg.io/ex3/85_hires.png', NULL),
    (86, 'Low Pressure System', 'common', 'https://images.pokemontcg.io/ex3/86_hires.png', NULL),
    (87, 'Mr. Briney''s Compassion', 'common', 'https://images.pokemontcg.io/ex3/87_hires.png', NULL),
    (88, 'TV Reporter', 'common', 'https://images.pokemontcg.io/ex3/88_hires.png', NULL),
    (89, 'Ampharos ex', 'double_rare', 'https://images.pokemontcg.io/ex3/89_hires.png', 'lightning'),
    (90, 'Dragonite ex', 'double_rare', 'https://images.pokemontcg.io/ex3/90_hires.png', 'colorless'),
    (91, 'Golem ex', 'double_rare', 'https://images.pokemontcg.io/ex3/91_hires.png', 'fighting'),
    (92, 'Kingdra ex', 'double_rare', 'https://images.pokemontcg.io/ex3/92_hires.png', 'water'),
    (93, 'Latias ex', 'double_rare', 'https://images.pokemontcg.io/ex3/93_hires.png', 'colorless'),
    (94, 'Latios ex', 'double_rare', 'https://images.pokemontcg.io/ex3/94_hires.png', 'colorless'),
    (95, 'Magcargo ex', 'double_rare', 'https://images.pokemontcg.io/ex3/95_hires.png', 'fire'),
    (96, 'Muk ex', 'double_rare', 'https://images.pokemontcg.io/ex3/96_hires.png', 'grass'),
    (97, 'Rayquaza ex', 'double_rare', 'https://images.pokemontcg.io/ex3/97_hires.png', 'colorless'),
    (98, 'Charmander', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex3/98_hires.png', 'fire'),
    (99, 'Charmeleon', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex3/99_hires.png', 'fire'),
    (100, 'Charizard', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex3/100_hires.png', 'fire')
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

-- Set: Team Magma vs Team Aqua (ex4) -- 2004/03/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'team-magma-vs-team-aqua', 'Team Magma vs Team Aqua', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'team-magma-vs-team-aqua'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Team Aqua''s Cacturne', 'rare', 'https://images.pokemontcg.io/ex4/1_hires.png', 'grass'),
    (2, 'Team Aqua''s Crawdaunt', 'rare', 'https://images.pokemontcg.io/ex4/2_hires.png', 'water'),
    (3, 'Team Aqua''s Kyogre', 'rare', 'https://images.pokemontcg.io/ex4/3_hires.png', 'water'),
    (4, 'Team Aqua''s Manectric', 'rare', 'https://images.pokemontcg.io/ex4/4_hires.png', 'lightning'),
    (5, 'Team Aqua''s Sharpedo', 'rare', 'https://images.pokemontcg.io/ex4/5_hires.png', 'water'),
    (6, 'Team Aqua''s Walrein', 'rare', 'https://images.pokemontcg.io/ex4/6_hires.png', 'water'),
    (7, 'Team Magma''s Aggron', 'rare', 'https://images.pokemontcg.io/ex4/7_hires.png', 'fighting'),
    (8, 'Team Magma''s Claydol', 'rare', 'https://images.pokemontcg.io/ex4/8_hires.png', 'psychic'),
    (9, 'Team Magma''s Groudon', 'rare', 'https://images.pokemontcg.io/ex4/9_hires.png', 'fighting'),
    (10, 'Team Magma''s Houndoom', 'rare', 'https://images.pokemontcg.io/ex4/10_hires.png', 'fire'),
    (11, 'Team Magma''s Rhydon', 'rare', 'https://images.pokemontcg.io/ex4/11_hires.png', 'fighting'),
    (12, 'Team Magma''s Torkoal', 'rare', 'https://images.pokemontcg.io/ex4/12_hires.png', 'fire'),
    (13, 'Raichu', 'rare', 'https://images.pokemontcg.io/ex4/13_hires.png', 'lightning'),
    (14, 'Team Aqua''s Crawdaunt', 'rare', 'https://images.pokemontcg.io/ex4/14_hires.png', 'water'),
    (15, 'Team Aqua''s Mightyena', 'rare', 'https://images.pokemontcg.io/ex4/15_hires.png', 'darkness'),
    (16, 'Team Aqua''s Sealeo', 'rare', 'https://images.pokemontcg.io/ex4/16_hires.png', 'water'),
    (17, 'Team Aqua''s Seviper', 'rare', 'https://images.pokemontcg.io/ex4/17_hires.png', 'grass'),
    (18, 'Team Aqua''s Sharpedo', 'rare', 'https://images.pokemontcg.io/ex4/18_hires.png', 'water'),
    (19, 'Team Magma''s Camerupt', 'rare', 'https://images.pokemontcg.io/ex4/19_hires.png', 'fire'),
    (20, 'Team Magma''s Lairon', 'rare', 'https://images.pokemontcg.io/ex4/20_hires.png', 'fighting'),
    (21, 'Team Magma''s Mightyena', 'rare', 'https://images.pokemontcg.io/ex4/21_hires.png', 'darkness'),
    (22, 'Team Magma''s Rhydon', 'rare', 'https://images.pokemontcg.io/ex4/22_hires.png', 'fighting'),
    (23, 'Team Magma''s Zangoose', 'rare', 'https://images.pokemontcg.io/ex4/23_hires.png', 'colorless'),
    (24, 'Team Aqua''s Cacnea', 'common', 'https://images.pokemontcg.io/ex4/24_hires.png', 'grass'),
    (25, 'Team Aqua''s Carvanha', 'common', 'https://images.pokemontcg.io/ex4/25_hires.png', 'water'),
    (26, 'Team Aqua''s Corphish', 'common', 'https://images.pokemontcg.io/ex4/26_hires.png', 'water'),
    (27, 'Team Aqua''s Electrike', 'common', 'https://images.pokemontcg.io/ex4/27_hires.png', 'lightning'),
    (28, 'Team Aqua''s Lanturn', 'common', 'https://images.pokemontcg.io/ex4/28_hires.png', 'lightning'),
    (29, 'Team Aqua''s Manectric', 'common', 'https://images.pokemontcg.io/ex4/29_hires.png', 'lightning'),
    (30, 'Team Aqua''s Mightyena', 'common', 'https://images.pokemontcg.io/ex4/30_hires.png', 'darkness'),
    (31, 'Team Aqua''s Sealeo', 'common', 'https://images.pokemontcg.io/ex4/31_hires.png', 'water'),
    (32, 'Team Magma''s Baltoy', 'common', 'https://images.pokemontcg.io/ex4/32_hires.png', 'psychic'),
    (33, 'Team Magma''s Claydol', 'common', 'https://images.pokemontcg.io/ex4/33_hires.png', 'fighting'),
    (34, 'Team Magma''s Houndoom', 'common', 'https://images.pokemontcg.io/ex4/34_hires.png', 'fire'),
    (35, 'Team Magma''s Houndour', 'common', 'https://images.pokemontcg.io/ex4/35_hires.png', 'fire'),
    (36, 'Team Magma''s Lairon', 'common', 'https://images.pokemontcg.io/ex4/36_hires.png', 'fighting'),
    (37, 'Team Magma''s Mightyena', 'common', 'https://images.pokemontcg.io/ex4/37_hires.png', 'darkness'),
    (38, 'Team Magma''s Rhyhorn', 'common', 'https://images.pokemontcg.io/ex4/38_hires.png', 'fighting'),
    (39, 'Bulbasaur', 'common', 'https://images.pokemontcg.io/ex4/39_hires.png', 'grass'),
    (40, 'Cubone', 'common', 'https://images.pokemontcg.io/ex4/40_hires.png', 'fighting'),
    (41, 'Jigglypuff', 'common', 'https://images.pokemontcg.io/ex4/41_hires.png', 'colorless'),
    (42, 'Meowth', 'common', 'https://images.pokemontcg.io/ex4/42_hires.png', 'colorless'),
    (43, 'Pikachu', 'common', 'https://images.pokemontcg.io/ex4/43_hires.png', 'lightning'),
    (44, 'Psyduck', 'common', 'https://images.pokemontcg.io/ex4/44_hires.png', 'water'),
    (45, 'Slowpoke', 'common', 'https://images.pokemontcg.io/ex4/45_hires.png', 'psychic'),
    (46, 'Squirtle', 'common', 'https://images.pokemontcg.io/ex4/46_hires.png', 'water'),
    (47, 'Team Aqua''s Carvanha', 'common', 'https://images.pokemontcg.io/ex4/47_hires.png', 'water'),
    (48, 'Team Aqua''s Carvanha', 'common', 'https://images.pokemontcg.io/ex4/48_hires.png', 'water'),
    (49, 'Team Aqua''s Chinchou', 'common', 'https://images.pokemontcg.io/ex4/49_hires.png', 'lightning'),
    (50, 'Team Aqua''s Corphish', 'common', 'https://images.pokemontcg.io/ex4/50_hires.png', 'water'),
    (51, 'Team Aqua''s Corphish', 'common', 'https://images.pokemontcg.io/ex4/51_hires.png', 'water'),
    (52, 'Team Aqua''s Electrike', 'common', 'https://images.pokemontcg.io/ex4/52_hires.png', 'lightning'),
    (53, 'Team Aqua''s Electrike', 'common', 'https://images.pokemontcg.io/ex4/53_hires.png', 'lightning'),
    (54, 'Team Aqua''s Poochyena', 'common', 'https://images.pokemontcg.io/ex4/54_hires.png', 'darkness'),
    (55, 'Team Aqua''s Poochyena', 'common', 'https://images.pokemontcg.io/ex4/55_hires.png', 'darkness'),
    (56, 'Team Aqua''s Spheal', 'common', 'https://images.pokemontcg.io/ex4/56_hires.png', 'water'),
    (57, 'Team Aqua''s Spheal', 'common', 'https://images.pokemontcg.io/ex4/57_hires.png', 'water'),
    (58, 'Team Magma''s Aron', 'common', 'https://images.pokemontcg.io/ex4/58_hires.png', 'fighting'),
    (59, 'Team Magma''s Aron', 'common', 'https://images.pokemontcg.io/ex4/59_hires.png', 'fighting'),
    (60, 'Team Magma''s Baltoy', 'common', 'https://images.pokemontcg.io/ex4/60_hires.png', 'fighting'),
    (61, 'Team Magma''s Baltoy', 'common', 'https://images.pokemontcg.io/ex4/61_hires.png', 'fighting'),
    (62, 'Team Magma''s Houndour', 'common', 'https://images.pokemontcg.io/ex4/62_hires.png', 'fire'),
    (63, 'Team Magma''s Houndour', 'common', 'https://images.pokemontcg.io/ex4/63_hires.png', 'fire'),
    (64, 'Team Magma''s Numel', 'common', 'https://images.pokemontcg.io/ex4/64_hires.png', 'fire'),
    (65, 'Team Magma''s Poochyena', 'common', 'https://images.pokemontcg.io/ex4/65_hires.png', 'darkness'),
    (66, 'Team Magma''s Poochyena', 'common', 'https://images.pokemontcg.io/ex4/66_hires.png', 'darkness'),
    (67, 'Team Magma''s Rhyhorn', 'common', 'https://images.pokemontcg.io/ex4/67_hires.png', 'fighting'),
    (68, 'Team Magma''s Rhyhorn', 'common', 'https://images.pokemontcg.io/ex4/68_hires.png', 'fighting'),
    (69, 'Team Aqua Schemer', 'common', 'https://images.pokemontcg.io/ex4/69_hires.png', NULL),
    (70, 'Team Magma Schemer', 'common', 'https://images.pokemontcg.io/ex4/70_hires.png', NULL),
    (71, 'Archie', 'common', 'https://images.pokemontcg.io/ex4/71_hires.png', NULL),
    (72, 'Dual Ball', 'common', 'https://images.pokemontcg.io/ex4/72_hires.png', NULL),
    (73, 'Maxie', 'common', 'https://images.pokemontcg.io/ex4/73_hires.png', NULL),
    (74, 'Strength Charm', 'common', 'https://images.pokemontcg.io/ex4/74_hires.png', NULL),
    (75, 'Team Aqua Ball', 'common', 'https://images.pokemontcg.io/ex4/75_hires.png', NULL),
    (76, 'Team Aqua Belt', 'common', 'https://images.pokemontcg.io/ex4/76_hires.png', NULL),
    (77, 'Team Aqua Conspirator', 'common', 'https://images.pokemontcg.io/ex4/77_hires.png', NULL),
    (78, 'Team Aqua Hideout', 'common', 'https://images.pokemontcg.io/ex4/78_hires.png', NULL),
    (79, 'Team Aqua Technical Machine 01', 'common', 'https://images.pokemontcg.io/ex4/79_hires.png', NULL),
    (80, 'Team Magma Ball', 'common', 'https://images.pokemontcg.io/ex4/80_hires.png', NULL),
    (81, 'Team Magma Belt', 'common', 'https://images.pokemontcg.io/ex4/81_hires.png', NULL),
    (82, 'Team Magma Conspirator', 'common', 'https://images.pokemontcg.io/ex4/82_hires.png', NULL),
    (83, 'Team Magma Hideout', 'common', 'https://images.pokemontcg.io/ex4/83_hires.png', NULL),
    (84, 'Team Magma Technical Machine 01', 'common', 'https://images.pokemontcg.io/ex4/84_hires.png', NULL),
    (85, 'Warp Point', 'common', 'https://images.pokemontcg.io/ex4/85_hires.png', NULL),
    (86, 'Aqua Energy', 'common', 'https://images.pokemontcg.io/ex4/86_hires.png', NULL),
    (87, 'Magma Energy', 'common', 'https://images.pokemontcg.io/ex4/87_hires.png', NULL),
    (88, 'Double Rainbow Energy', 'rare', 'https://images.pokemontcg.io/ex4/88_hires.png', NULL),
    (89, 'Blaziken ex', 'double_rare', 'https://images.pokemontcg.io/ex4/89_hires.png', 'fire'),
    (90, 'Cradily ex', 'double_rare', 'https://images.pokemontcg.io/ex4/90_hires.png', 'grass'),
    (91, 'Entei ex', 'double_rare', 'https://images.pokemontcg.io/ex4/91_hires.png', 'fire'),
    (92, 'Raikou ex', 'double_rare', 'https://images.pokemontcg.io/ex4/92_hires.png', 'lightning'),
    (93, 'Sceptile ex', 'double_rare', 'https://images.pokemontcg.io/ex4/93_hires.png', 'grass'),
    (94, 'Suicune ex', 'double_rare', 'https://images.pokemontcg.io/ex4/94_hires.png', 'water'),
    (95, 'Swampert ex', 'double_rare', 'https://images.pokemontcg.io/ex4/95_hires.png', 'fighting'),
    (96, 'Absol', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex4/96_hires.png', 'darkness'),
    (97, 'Jirachi', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex4/97_hires.png', 'psychic')
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

-- Set: EX Trainer Kit Latias (tk1a) -- 2004/06/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'ex-trainer-kit-latias', 'EX Trainer Kit Latias', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'ex-trainer-kit-latias'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Bagon', 'base', 'https://images.pokemontcg.io/tk1a/1_hires.png', 'colorless'),
    (2, 'Combusken', 'base', 'https://images.pokemontcg.io/tk1a/2_hires.png', 'fire'),
    (3, 'Delcatty', 'base', 'https://images.pokemontcg.io/tk1a/3_hires.png', 'colorless'),
    (4, 'Latias', 'base', 'https://images.pokemontcg.io/tk1a/4_hires.png', 'colorless'),
    (5, 'Numel', 'base', 'https://images.pokemontcg.io/tk1a/5_hires.png', 'fire'),
    (6, 'Skitty', 'base', 'https://images.pokemontcg.io/tk1a/6_hires.png', 'colorless'),
    (7, 'Torchic', 'base', 'https://images.pokemontcg.io/tk1a/7_hires.png', 'fire'),
    (8, 'Potion', 'base', 'https://images.pokemontcg.io/tk1a/8_hires.png', NULL),
    (9, 'Energy Search', 'base', 'https://images.pokemontcg.io/tk1a/9_hires.png', NULL),
    (10, 'Fire Energy', 'base', 'https://images.pokemontcg.io/tk1a/10_hires.png', NULL)
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

-- Set: EX Trainer Kit Latios (tk1b) -- 2004/06/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'ex-trainer-kit-latios', 'EX Trainer Kit Latios', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'ex-trainer-kit-latios'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Electrike', 'base', 'https://images.pokemontcg.io/tk1b/1_hires.png', 'lightning'),
    (2, 'Latios', 'base', 'https://images.pokemontcg.io/tk1b/2_hires.png', 'colorless'),
    (3, 'Linoone', 'base', 'https://images.pokemontcg.io/tk1b/3_hires.png', 'colorless'),
    (4, 'Magnemite', 'base', 'https://images.pokemontcg.io/tk1b/4_hires.png', 'lightning'),
    (5, 'Magneton', 'base', 'https://images.pokemontcg.io/tk1b/5_hires.png', 'lightning'),
    (6, 'Pikachu', 'base', 'https://images.pokemontcg.io/tk1b/6_hires.png', 'lightning'),
    (7, 'Zigzagoon', 'base', 'https://images.pokemontcg.io/tk1b/7_hires.png', 'colorless'),
    (8, 'Potion', 'base', 'https://images.pokemontcg.io/tk1b/8_hires.png', NULL),
    (9, 'Energy Search', 'base', 'https://images.pokemontcg.io/tk1b/9_hires.png', NULL),
    (10, 'Lightning Energy', 'base', 'https://images.pokemontcg.io/tk1b/10_hires.png', NULL)
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

-- Set: Hidden Legends (ex5) -- 2004/06/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'hidden-legends', 'Hidden Legends', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'hidden-legends'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Banette', 'rare', 'https://images.pokemontcg.io/ex5/1_hires.png', 'psychic'),
    (2, 'Claydol', 'rare', 'https://images.pokemontcg.io/ex5/2_hires.png', 'psychic'),
    (3, 'Crobat', 'rare', 'https://images.pokemontcg.io/ex5/3_hires.png', 'grass'),
    (4, 'Dark Celebi', 'rare', 'https://images.pokemontcg.io/ex5/4_hires.png', 'grass'),
    (5, 'Electrode', 'rare', 'https://images.pokemontcg.io/ex5/5_hires.png', 'lightning'),
    (6, 'Exploud', 'rare', 'https://images.pokemontcg.io/ex5/6_hires.png', 'colorless'),
    (7, 'Heracross', 'rare', 'https://images.pokemontcg.io/ex5/7_hires.png', 'grass'),
    (8, 'Jirachi', 'rare', 'https://images.pokemontcg.io/ex5/8_hires.png', 'psychic'),
    (9, 'Machamp', 'rare', 'https://images.pokemontcg.io/ex5/9_hires.png', 'fighting'),
    (10, 'Medicham', 'rare', 'https://images.pokemontcg.io/ex5/10_hires.png', 'fighting'),
    (11, 'Metagross', 'rare', 'https://images.pokemontcg.io/ex5/11_hires.png', 'psychic'),
    (12, 'Milotic', 'rare', 'https://images.pokemontcg.io/ex5/12_hires.png', 'water'),
    (13, 'Pinsir', 'rare', 'https://images.pokemontcg.io/ex5/13_hires.png', 'grass'),
    (14, 'Shiftry', 'rare', 'https://images.pokemontcg.io/ex5/14_hires.png', 'darkness'),
    (15, 'Walrein', 'rare', 'https://images.pokemontcg.io/ex5/15_hires.png', 'water'),
    (16, 'Bellossom', 'rare', 'https://images.pokemontcg.io/ex5/16_hires.png', 'grass'),
    (17, 'Chimecho', 'rare', 'https://images.pokemontcg.io/ex5/17_hires.png', 'psychic'),
    (18, 'Gorebyss', 'rare', 'https://images.pokemontcg.io/ex5/18_hires.png', 'water'),
    (19, 'Huntail', 'rare', 'https://images.pokemontcg.io/ex5/19_hires.png', 'water'),
    (20, 'Masquerain', 'rare', 'https://images.pokemontcg.io/ex5/20_hires.png', 'grass'),
    (21, 'Metang', 'rare', 'https://images.pokemontcg.io/ex5/21_hires.png', 'metal'),
    (22, 'Ninetales', 'rare', 'https://images.pokemontcg.io/ex5/22_hires.png', 'fire'),
    (23, 'Rain Castform', 'rare', 'https://images.pokemontcg.io/ex5/23_hires.png', 'water'),
    (24, 'Relicanth', 'rare', 'https://images.pokemontcg.io/ex5/24_hires.png', 'water'),
    (25, 'Snow-cloud Castform', 'rare', 'https://images.pokemontcg.io/ex5/25_hires.png', 'water'),
    (26, 'Sunny Castform', 'rare', 'https://images.pokemontcg.io/ex5/26_hires.png', 'fire'),
    (27, 'Tropius', 'rare', 'https://images.pokemontcg.io/ex5/27_hires.png', 'grass'),
    (28, 'Beldum', 'common', 'https://images.pokemontcg.io/ex5/28_hires.png', 'metal'),
    (29, 'Beldum', 'common', 'https://images.pokemontcg.io/ex5/29_hires.png', 'metal'),
    (30, 'Castform', 'common', 'https://images.pokemontcg.io/ex5/30_hires.png', 'colorless'),
    (31, 'Claydol', 'common', 'https://images.pokemontcg.io/ex5/31_hires.png', 'fighting'),
    (32, 'Corsola', 'common', 'https://images.pokemontcg.io/ex5/32_hires.png', 'water'),
    (33, 'Dodrio', 'common', 'https://images.pokemontcg.io/ex5/33_hires.png', 'colorless'),
    (34, 'Glalie', 'common', 'https://images.pokemontcg.io/ex5/34_hires.png', 'water'),
    (35, 'Gloom', 'common', 'https://images.pokemontcg.io/ex5/35_hires.png', 'grass'),
    (36, 'Golbat', 'common', 'https://images.pokemontcg.io/ex5/36_hires.png', 'grass'),
    (37, 'Igglybuff', 'common', 'https://images.pokemontcg.io/ex5/37_hires.png', 'colorless'),
    (38, 'Lanturn', 'common', 'https://images.pokemontcg.io/ex5/38_hires.png', 'lightning'),
    (39, 'Loudred', 'common', 'https://images.pokemontcg.io/ex5/39_hires.png', 'colorless'),
    (40, 'Luvdisc', 'common', 'https://images.pokemontcg.io/ex5/40_hires.png', 'water'),
    (41, 'Machoke', 'common', 'https://images.pokemontcg.io/ex5/41_hires.png', 'fighting'),
    (42, 'Medicham', 'common', 'https://images.pokemontcg.io/ex5/42_hires.png', 'fighting'),
    (43, 'Metang', 'common', 'https://images.pokemontcg.io/ex5/43_hires.png', 'psychic'),
    (44, 'Metang', 'common', 'https://images.pokemontcg.io/ex5/44_hires.png', 'metal'),
    (45, 'Nuzleaf', 'common', 'https://images.pokemontcg.io/ex5/45_hires.png', 'darkness'),
    (46, 'Rhydon', 'common', 'https://images.pokemontcg.io/ex5/46_hires.png', 'fighting'),
    (47, 'Sealeo', 'common', 'https://images.pokemontcg.io/ex5/47_hires.png', 'water'),
    (48, 'Spinda', 'common', 'https://images.pokemontcg.io/ex5/48_hires.png', 'colorless'),
    (49, 'Starmie', 'common', 'https://images.pokemontcg.io/ex5/49_hires.png', 'psychic'),
    (50, 'Swalot', 'common', 'https://images.pokemontcg.io/ex5/50_hires.png', 'grass'),
    (51, 'Tentacruel', 'common', 'https://images.pokemontcg.io/ex5/51_hires.png', 'water'),
    (52, 'Baltoy', 'common', 'https://images.pokemontcg.io/ex5/52_hires.png', 'psychic'),
    (53, 'Baltoy', 'common', 'https://images.pokemontcg.io/ex5/53_hires.png', 'fighting'),
    (54, 'Beldum', 'common', 'https://images.pokemontcg.io/ex5/54_hires.png', 'psychic'),
    (55, 'Chikorita', 'common', 'https://images.pokemontcg.io/ex5/55_hires.png', 'grass'),
    (56, 'Chinchou', 'common', 'https://images.pokemontcg.io/ex5/56_hires.png', 'lightning'),
    (57, 'Chinchou', 'common', 'https://images.pokemontcg.io/ex5/57_hires.png', 'lightning'),
    (58, 'Clamperl', 'common', 'https://images.pokemontcg.io/ex5/58_hires.png', 'water'),
    (59, 'Cyndaquil', 'common', 'https://images.pokemontcg.io/ex5/59_hires.png', 'fire'),
    (60, 'Doduo', 'common', 'https://images.pokemontcg.io/ex5/60_hires.png', 'colorless'),
    (61, 'Feebas', 'common', 'https://images.pokemontcg.io/ex5/61_hires.png', 'water'),
    (62, 'Gulpin', 'common', 'https://images.pokemontcg.io/ex5/62_hires.png', 'grass'),
    (63, 'Jigglypuff', 'common', 'https://images.pokemontcg.io/ex5/63_hires.png', 'colorless'),
    (64, 'Machop', 'common', 'https://images.pokemontcg.io/ex5/64_hires.png', 'fighting'),
    (65, 'Meditite', 'common', 'https://images.pokemontcg.io/ex5/65_hires.png', 'psychic'),
    (66, 'Meditite', 'common', 'https://images.pokemontcg.io/ex5/66_hires.png', 'fighting'),
    (67, 'Minun', 'common', 'https://images.pokemontcg.io/ex5/67_hires.png', 'lightning'),
    (68, 'Oddish', 'common', 'https://images.pokemontcg.io/ex5/68_hires.png', 'grass'),
    (69, 'Plusle', 'common', 'https://images.pokemontcg.io/ex5/69_hires.png', 'lightning'),
    (70, 'Rhyhorn', 'common', 'https://images.pokemontcg.io/ex5/70_hires.png', 'fighting'),
    (71, 'Seedot', 'common', 'https://images.pokemontcg.io/ex5/71_hires.png', 'grass'),
    (72, 'Shuppet', 'common', 'https://images.pokemontcg.io/ex5/72_hires.png', 'psychic'),
    (73, 'Snorunt', 'common', 'https://images.pokemontcg.io/ex5/73_hires.png', 'water'),
    (74, 'Spheal', 'common', 'https://images.pokemontcg.io/ex5/74_hires.png', 'water'),
    (75, 'Staryu', 'common', 'https://images.pokemontcg.io/ex5/75_hires.png', 'water'),
    (76, 'Surskit', 'common', 'https://images.pokemontcg.io/ex5/76_hires.png', 'grass'),
    (77, 'Tentacool', 'common', 'https://images.pokemontcg.io/ex5/77_hires.png', 'water'),
    (78, 'Togepi', 'common', 'https://images.pokemontcg.io/ex5/78_hires.png', 'colorless'),
    (79, 'Totodile', 'common', 'https://images.pokemontcg.io/ex5/79_hires.png', 'water'),
    (80, 'Voltorb', 'common', 'https://images.pokemontcg.io/ex5/80_hires.png', 'lightning'),
    (81, 'Vulpix', 'common', 'https://images.pokemontcg.io/ex5/81_hires.png', 'fire'),
    (82, 'Whismur', 'common', 'https://images.pokemontcg.io/ex5/82_hires.png', 'colorless'),
    (83, 'Zubat', 'common', 'https://images.pokemontcg.io/ex5/83_hires.png', 'grass'),
    (84, 'Ancient Technical Machine [Ice]', 'common', 'https://images.pokemontcg.io/ex5/84_hires.png', NULL),
    (85, 'Ancient Technical Machine [Rock]', 'common', 'https://images.pokemontcg.io/ex5/85_hires.png', NULL),
    (86, 'Ancient Technical Machine [Steel]', 'common', 'https://images.pokemontcg.io/ex5/86_hires.png', NULL),
    (87, 'Ancient Tomb', 'common', 'https://images.pokemontcg.io/ex5/87_hires.png', NULL),
    (88, 'Desert Ruins', 'common', 'https://images.pokemontcg.io/ex5/88_hires.png', NULL),
    (89, 'Island Cave', 'common', 'https://images.pokemontcg.io/ex5/89_hires.png', NULL),
    (90, 'Life Herb', 'common', 'https://images.pokemontcg.io/ex5/90_hires.png', NULL),
    (91, 'Magnetic Storm', 'common', 'https://images.pokemontcg.io/ex5/91_hires.png', NULL),
    (92, 'Steven''s Advice', 'common', 'https://images.pokemontcg.io/ex5/92_hires.png', NULL),
    (93, 'Groudon ex', 'double_rare', 'https://images.pokemontcg.io/ex5/93_hires.png', 'fighting'),
    (94, 'Kyogre ex', 'double_rare', 'https://images.pokemontcg.io/ex5/94_hires.png', 'water'),
    (95, 'Metagross ex', 'double_rare', 'https://images.pokemontcg.io/ex5/95_hires.png', 'metal'),
    (96, 'Ninetales ex', 'double_rare', 'https://images.pokemontcg.io/ex5/96_hires.png', 'fire'),
    (97, 'Regice ex', 'double_rare', 'https://images.pokemontcg.io/ex5/97_hires.png', 'water'),
    (98, 'Regirock ex', 'double_rare', 'https://images.pokemontcg.io/ex5/98_hires.png', 'fighting'),
    (99, 'Registeel ex', 'double_rare', 'https://images.pokemontcg.io/ex5/99_hires.png', 'metal'),
    (100, 'Vileplume ex', 'double_rare', 'https://images.pokemontcg.io/ex5/100_hires.png', 'grass'),
    (101, 'Wigglytuff ex', 'double_rare', 'https://images.pokemontcg.io/ex5/101_hires.png', 'colorless'),
    (102, 'Groudon', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex5/102_hires.png', 'fighting')
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

-- Set: FireRed & LeafGreen (ex6) -- 2004/09/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'firered-leafgreen', 'FireRed & LeafGreen', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'firered-leafgreen'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Beedrill', 'rare', 'https://images.pokemontcg.io/ex6/1_hires.png', 'grass'),
    (2, 'Butterfree', 'rare', 'https://images.pokemontcg.io/ex6/2_hires.png', 'grass'),
    (3, 'Dewgong', 'rare', 'https://images.pokemontcg.io/ex6/3_hires.png', 'water'),
    (4, 'Ditto', 'rare', 'https://images.pokemontcg.io/ex6/4_hires.png', 'colorless'),
    (5, 'Exeggutor', 'rare', 'https://images.pokemontcg.io/ex6/5_hires.png', 'psychic'),
    (6, 'Kangaskhan', 'rare', 'https://images.pokemontcg.io/ex6/6_hires.png', 'colorless'),
    (7, 'Marowak', 'rare', 'https://images.pokemontcg.io/ex6/7_hires.png', 'fighting'),
    (8, 'Nidoking', 'rare', 'https://images.pokemontcg.io/ex6/8_hires.png', 'fighting'),
    (9, 'Nidoqueen', 'rare', 'https://images.pokemontcg.io/ex6/9_hires.png', 'fighting'),
    (10, 'Pidgeot', 'rare', 'https://images.pokemontcg.io/ex6/10_hires.png', 'colorless'),
    (11, 'Poliwrath', 'rare', 'https://images.pokemontcg.io/ex6/11_hires.png', 'water'),
    (12, 'Raichu', 'rare', 'https://images.pokemontcg.io/ex6/12_hires.png', 'lightning'),
    (13, 'Rapidash', 'rare', 'https://images.pokemontcg.io/ex6/13_hires.png', 'fire'),
    (14, 'Slowbro', 'rare', 'https://images.pokemontcg.io/ex6/14_hires.png', 'psychic'),
    (15, 'Snorlax', 'rare', 'https://images.pokemontcg.io/ex6/15_hires.png', 'colorless'),
    (16, 'Tauros', 'rare', 'https://images.pokemontcg.io/ex6/16_hires.png', 'colorless'),
    (17, 'Victreebel', 'rare', 'https://images.pokemontcg.io/ex6/17_hires.png', 'grass'),
    (18, 'Arcanine', 'rare', 'https://images.pokemontcg.io/ex6/18_hires.png', 'fire'),
    (19, 'Chansey', 'rare', 'https://images.pokemontcg.io/ex6/19_hires.png', 'colorless'),
    (20, 'Cloyster', 'rare', 'https://images.pokemontcg.io/ex6/20_hires.png', 'water'),
    (21, 'Dodrio', 'rare', 'https://images.pokemontcg.io/ex6/21_hires.png', 'colorless'),
    (22, 'Dugtrio', 'rare', 'https://images.pokemontcg.io/ex6/22_hires.png', 'fighting'),
    (23, 'Farfetch''d', 'rare', 'https://images.pokemontcg.io/ex6/23_hires.png', 'colorless'),
    (24, 'Fearow', 'rare', 'https://images.pokemontcg.io/ex6/24_hires.png', 'colorless'),
    (25, 'Hypno', 'rare', 'https://images.pokemontcg.io/ex6/25_hires.png', 'psychic'),
    (26, 'Kingler', 'rare', 'https://images.pokemontcg.io/ex6/26_hires.png', 'water'),
    (27, 'Magneton', 'rare', 'https://images.pokemontcg.io/ex6/27_hires.png', 'lightning'),
    (28, 'Primeape', 'rare', 'https://images.pokemontcg.io/ex6/28_hires.png', 'fighting'),
    (29, 'Scyther', 'rare', 'https://images.pokemontcg.io/ex6/29_hires.png', 'grass'),
    (30, 'Tangela', 'rare', 'https://images.pokemontcg.io/ex6/30_hires.png', 'grass'),
    (31, 'Charmeleon', 'common', 'https://images.pokemontcg.io/ex6/31_hires.png', 'fire'),
    (32, 'Drowzee', 'common', 'https://images.pokemontcg.io/ex6/32_hires.png', 'psychic'),
    (33, 'Exeggcute', 'common', 'https://images.pokemontcg.io/ex6/33_hires.png', 'psychic'),
    (34, 'Haunter', 'common', 'https://images.pokemontcg.io/ex6/34_hires.png', 'psychic'),
    (35, 'Ivysaur', 'common', 'https://images.pokemontcg.io/ex6/35_hires.png', 'grass'),
    (36, 'Kakuna', 'common', 'https://images.pokemontcg.io/ex6/36_hires.png', 'grass'),
    (37, 'Lickitung', 'common', 'https://images.pokemontcg.io/ex6/37_hires.png', 'colorless'),
    (38, 'Mankey', 'common', 'https://images.pokemontcg.io/ex6/38_hires.png', 'fighting'),
    (39, 'Metapod', 'common', 'https://images.pokemontcg.io/ex6/39_hires.png', 'grass'),
    (40, 'Nidorina', 'common', 'https://images.pokemontcg.io/ex6/40_hires.png', 'grass'),
    (41, 'Nidorino', 'common', 'https://images.pokemontcg.io/ex6/41_hires.png', 'grass'),
    (42, 'Onix', 'common', 'https://images.pokemontcg.io/ex6/42_hires.png', 'fighting'),
    (43, 'Parasect', 'common', 'https://images.pokemontcg.io/ex6/43_hires.png', 'grass'),
    (44, 'Persian', 'common', 'https://images.pokemontcg.io/ex6/44_hires.png', 'colorless'),
    (45, 'Pidgeotto', 'common', 'https://images.pokemontcg.io/ex6/45_hires.png', 'colorless'),
    (46, 'Poliwhirl', 'common', 'https://images.pokemontcg.io/ex6/46_hires.png', 'water'),
    (47, 'Porygon', 'common', 'https://images.pokemontcg.io/ex6/47_hires.png', 'colorless'),
    (48, 'Raticate', 'common', 'https://images.pokemontcg.io/ex6/48_hires.png', 'colorless'),
    (49, 'Venomoth', 'common', 'https://images.pokemontcg.io/ex6/49_hires.png', 'grass'),
    (50, 'Wartortle', 'common', 'https://images.pokemontcg.io/ex6/50_hires.png', 'water'),
    (51, 'Weepinbell', 'common', 'https://images.pokemontcg.io/ex6/51_hires.png', 'grass'),
    (52, 'Wigglytuff', 'common', 'https://images.pokemontcg.io/ex6/52_hires.png', 'colorless'),
    (53, 'Bellsprout', 'common', 'https://images.pokemontcg.io/ex6/53_hires.png', 'grass'),
    (54, 'Bulbasaur', 'common', 'https://images.pokemontcg.io/ex6/54_hires.png', 'grass'),
    (55, 'Bulbasaur', 'common', 'https://images.pokemontcg.io/ex6/55_hires.png', 'grass'),
    (56, 'Caterpie', 'common', 'https://images.pokemontcg.io/ex6/56_hires.png', 'grass'),
    (57, 'Charmander', 'common', 'https://images.pokemontcg.io/ex6/57_hires.png', 'fire'),
    (58, 'Charmander', 'common', 'https://images.pokemontcg.io/ex6/58_hires.png', 'fire'),
    (59, 'Clefairy', 'common', 'https://images.pokemontcg.io/ex6/59_hires.png', 'colorless'),
    (60, 'Cubone', 'common', 'https://images.pokemontcg.io/ex6/60_hires.png', 'fighting'),
    (61, 'Diglett', 'common', 'https://images.pokemontcg.io/ex6/61_hires.png', 'fighting'),
    (62, 'Doduo', 'common', 'https://images.pokemontcg.io/ex6/62_hires.png', 'colorless'),
    (63, 'Gastly', 'common', 'https://images.pokemontcg.io/ex6/63_hires.png', 'psychic'),
    (64, 'Growlithe', 'common', 'https://images.pokemontcg.io/ex6/64_hires.png', 'fire'),
    (65, 'Jigglypuff', 'common', 'https://images.pokemontcg.io/ex6/65_hires.png', 'colorless'),
    (66, 'Krabby', 'common', 'https://images.pokemontcg.io/ex6/66_hires.png', 'water'),
    (67, 'Magikarp', 'common', 'https://images.pokemontcg.io/ex6/67_hires.png', 'water'),
    (68, 'Magnemite', 'common', 'https://images.pokemontcg.io/ex6/68_hires.png', 'lightning'),
    (69, 'Meowth', 'common', 'https://images.pokemontcg.io/ex6/69_hires.png', 'colorless'),
    (70, 'Nidoran ♀', 'common', 'https://images.pokemontcg.io/ex6/70_hires.png', 'grass'),
    (71, 'Nidoran ♂', 'common', 'https://images.pokemontcg.io/ex6/71_hires.png', 'grass'),
    (72, 'Paras', 'common', 'https://images.pokemontcg.io/ex6/72_hires.png', 'grass'),
    (73, 'Pidgey', 'common', 'https://images.pokemontcg.io/ex6/73_hires.png', 'colorless'),
    (74, 'Pikachu', 'common', 'https://images.pokemontcg.io/ex6/74_hires.png', 'lightning'),
    (75, 'Poliwag', 'common', 'https://images.pokemontcg.io/ex6/75_hires.png', 'water'),
    (76, 'Ponyta', 'common', 'https://images.pokemontcg.io/ex6/76_hires.png', 'fire'),
    (77, 'Rattata', 'common', 'https://images.pokemontcg.io/ex6/77_hires.png', 'colorless'),
    (78, 'Seel', 'common', 'https://images.pokemontcg.io/ex6/78_hires.png', 'water'),
    (79, 'Shellder', 'common', 'https://images.pokemontcg.io/ex6/79_hires.png', 'water'),
    (80, 'Slowpoke', 'common', 'https://images.pokemontcg.io/ex6/80_hires.png', 'psychic'),
    (81, 'Spearow', 'common', 'https://images.pokemontcg.io/ex6/81_hires.png', 'colorless'),
    (82, 'Squirtle', 'common', 'https://images.pokemontcg.io/ex6/82_hires.png', 'water'),
    (83, 'Squirtle', 'common', 'https://images.pokemontcg.io/ex6/83_hires.png', 'water'),
    (84, 'Venonat', 'common', 'https://images.pokemontcg.io/ex6/84_hires.png', 'grass'),
    (85, 'Voltorb', 'common', 'https://images.pokemontcg.io/ex6/85_hires.png', 'lightning'),
    (86, 'Weedle', 'common', 'https://images.pokemontcg.io/ex6/86_hires.png', 'grass'),
    (87, 'Bill''s Maintenance', 'common', 'https://images.pokemontcg.io/ex6/87_hires.png', NULL),
    (88, 'Celio''s Network', 'common', 'https://images.pokemontcg.io/ex6/88_hires.png', NULL),
    (89, 'Energy Removal 2', 'common', 'https://images.pokemontcg.io/ex6/89_hires.png', NULL),
    (90, 'Energy Switch', 'common', 'https://images.pokemontcg.io/ex6/90_hires.png', NULL),
    (91, 'EXP.ALL', 'common', 'https://images.pokemontcg.io/ex6/91_hires.png', NULL),
    (92, 'Great Ball', 'common', 'https://images.pokemontcg.io/ex6/92_hires.png', NULL),
    (93, 'Life Herb', 'common', 'https://images.pokemontcg.io/ex6/93_hires.png', NULL),
    (94, 'Mt. Moon', 'common', 'https://images.pokemontcg.io/ex6/94_hires.png', NULL),
    (95, 'Poké Ball', 'common', 'https://images.pokemontcg.io/ex6/95_hires.png', NULL),
    (96, 'PokéDex HANDY909', 'common', 'https://images.pokemontcg.io/ex6/96_hires.png', NULL),
    (97, 'Pokémon Reversal', 'common', 'https://images.pokemontcg.io/ex6/97_hires.png', NULL),
    (98, 'Prof. Oak''s Research', 'common', 'https://images.pokemontcg.io/ex6/98_hires.png', NULL),
    (99, 'Super Scoop Up', 'common', 'https://images.pokemontcg.io/ex6/99_hires.png', NULL),
    (100, 'VS Seeker', 'common', 'https://images.pokemontcg.io/ex6/100_hires.png', NULL),
    (101, 'Potion', 'common', 'https://images.pokemontcg.io/ex6/101_hires.png', NULL),
    (102, 'Switch', 'common', 'https://images.pokemontcg.io/ex6/102_hires.png', NULL),
    (103, 'Multi Energy', 'rare', 'https://images.pokemontcg.io/ex6/103_hires.png', NULL),
    (104, 'Blastoise ex', 'double_rare', 'https://images.pokemontcg.io/ex6/104_hires.png', 'water'),
    (105, 'Charizard ex', 'double_rare', 'https://images.pokemontcg.io/ex6/105_hires.png', 'fire'),
    (106, 'Clefable ex', 'double_rare', 'https://images.pokemontcg.io/ex6/106_hires.png', 'colorless'),
    (107, 'Electrode ex', 'double_rare', 'https://images.pokemontcg.io/ex6/107_hires.png', 'lightning'),
    (108, 'Gengar ex', 'double_rare', 'https://images.pokemontcg.io/ex6/108_hires.png', 'psychic'),
    (109, 'Gyarados ex', 'double_rare', 'https://images.pokemontcg.io/ex6/109_hires.png', 'water'),
    (110, 'Mr. Mime ex', 'double_rare', 'https://images.pokemontcg.io/ex6/110_hires.png', 'psychic'),
    (111, 'Mr. Mime ex', 'double_rare', 'https://images.pokemontcg.io/ex6/111_hires.png', 'psychic'),
    (112, 'Venusaur ex', 'double_rare', 'https://images.pokemontcg.io/ex6/112_hires.png', 'grass'),
    (113, 'Charmander', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex6/113_hires.png', 'fire'),
    (114, 'Articuno ex', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex6/114_hires.png', 'water'),
    (115, 'Moltres ex', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex6/115_hires.png', 'fire'),
    (116, 'Zapdos ex', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex6/116_hires.png', 'lightning')
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

-- Set: Team Rocket Returns (ex7) -- 2004/11/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'team-rocket-returns', 'Team Rocket Returns', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'team-rocket-returns'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Azumarill', 'rare', 'https://images.pokemontcg.io/ex7/1_hires.png', 'water'),
    (2, 'Dark Ampharos', 'rare', 'https://images.pokemontcg.io/ex7/2_hires.png', 'lightning'),
    (3, 'Dark Crobat', 'rare', 'https://images.pokemontcg.io/ex7/3_hires.png', 'grass'),
    (4, 'Dark Electrode', 'rare', 'https://images.pokemontcg.io/ex7/4_hires.png', 'lightning'),
    (5, 'Dark Houndoom', 'rare', 'https://images.pokemontcg.io/ex7/5_hires.png', 'fire'),
    (6, 'Dark Hypno', 'rare', 'https://images.pokemontcg.io/ex7/6_hires.png', 'psychic'),
    (7, 'Dark Marowak', 'rare', 'https://images.pokemontcg.io/ex7/7_hires.png', 'fighting'),
    (8, 'Dark Octillery', 'rare', 'https://images.pokemontcg.io/ex7/8_hires.png', 'water'),
    (9, 'Dark Slowking', 'rare', 'https://images.pokemontcg.io/ex7/9_hires.png', 'psychic'),
    (10, 'Dark Steelix', 'rare', 'https://images.pokemontcg.io/ex7/10_hires.png', 'darkness'),
    (11, 'Jumpluff', 'rare', 'https://images.pokemontcg.io/ex7/11_hires.png', 'grass'),
    (12, 'Kingdra', 'rare', 'https://images.pokemontcg.io/ex7/12_hires.png', 'water'),
    (13, 'Piloswine', 'rare', 'https://images.pokemontcg.io/ex7/13_hires.png', 'fighting'),
    (14, 'Togetic', 'rare', 'https://images.pokemontcg.io/ex7/14_hires.png', 'colorless'),
    (15, 'Dark Dragonite', 'rare', 'https://images.pokemontcg.io/ex7/15_hires.png', 'darkness'),
    (16, 'Dark Muk', 'rare', 'https://images.pokemontcg.io/ex7/16_hires.png', 'grass'),
    (17, 'Dark Raticate', 'rare', 'https://images.pokemontcg.io/ex7/17_hires.png', 'darkness'),
    (18, 'Dark Sandslash', 'rare', 'https://images.pokemontcg.io/ex7/18_hires.png', 'fighting'),
    (19, 'Dark Tyranitar', 'rare', 'https://images.pokemontcg.io/ex7/19_hires.png', 'darkness'),
    (20, 'Dark Tyranitar', 'rare', 'https://images.pokemontcg.io/ex7/20_hires.png', 'fighting'),
    (21, 'Delibird', 'rare', 'https://images.pokemontcg.io/ex7/21_hires.png', 'water'),
    (22, 'Furret', 'rare', 'https://images.pokemontcg.io/ex7/22_hires.png', 'colorless'),
    (23, 'Ledian', 'rare', 'https://images.pokemontcg.io/ex7/23_hires.png', 'grass'),
    (24, 'Magby', 'rare', 'https://images.pokemontcg.io/ex7/24_hires.png', 'fire'),
    (25, 'Misdreavus', 'rare', 'https://images.pokemontcg.io/ex7/25_hires.png', 'psychic'),
    (26, 'Quagsire', 'rare', 'https://images.pokemontcg.io/ex7/26_hires.png', 'water'),
    (27, 'Qwilfish', 'rare', 'https://images.pokemontcg.io/ex7/27_hires.png', 'water'),
    (28, 'Yanma', 'rare', 'https://images.pokemontcg.io/ex7/28_hires.png', 'grass'),
    (29, 'Dark Arbok', 'common', 'https://images.pokemontcg.io/ex7/29_hires.png', 'grass'),
    (30, 'Dark Ariados', 'common', 'https://images.pokemontcg.io/ex7/30_hires.png', 'grass'),
    (31, 'Dark Dragonair', 'common', 'https://images.pokemontcg.io/ex7/31_hires.png', 'darkness'),
    (32, 'Dark Dragonair', 'common', 'https://images.pokemontcg.io/ex7/32_hires.png', 'darkness'),
    (33, 'Dark Flaaffy', 'common', 'https://images.pokemontcg.io/ex7/33_hires.png', 'lightning'),
    (34, 'Dark Golbat', 'common', 'https://images.pokemontcg.io/ex7/34_hires.png', 'grass'),
    (35, 'Dark Golduck', 'common', 'https://images.pokemontcg.io/ex7/35_hires.png', 'water'),
    (36, 'Dark Gyarados', 'common', 'https://images.pokemontcg.io/ex7/36_hires.png', 'water'),
    (37, 'Dark Houndoom', 'common', 'https://images.pokemontcg.io/ex7/37_hires.png', 'fire'),
    (38, 'Dark Magcargo', 'common', 'https://images.pokemontcg.io/ex7/38_hires.png', 'fire'),
    (39, 'Dark Magneton', 'common', 'https://images.pokemontcg.io/ex7/39_hires.png', 'lightning'),
    (40, 'Dark Pupitar', 'common', 'https://images.pokemontcg.io/ex7/40_hires.png', 'fighting'),
    (41, 'Dark Pupitar', 'common', 'https://images.pokemontcg.io/ex7/41_hires.png', 'fighting'),
    (42, 'Dark Weezing', 'common', 'https://images.pokemontcg.io/ex7/42_hires.png', 'grass'),
    (43, 'Heracross', 'common', 'https://images.pokemontcg.io/ex7/43_hires.png', 'fighting'),
    (44, 'Magmar', 'common', 'https://images.pokemontcg.io/ex7/44_hires.png', 'fire'),
    (45, 'Mantine', 'common', 'https://images.pokemontcg.io/ex7/45_hires.png', 'water'),
    (46, 'Rocket''s Meowth', 'common', 'https://images.pokemontcg.io/ex7/46_hires.png', 'darkness'),
    (47, 'Rocket''s Wobbuffet', 'common', 'https://images.pokemontcg.io/ex7/47_hires.png', 'darkness'),
    (48, 'Seadra', 'common', 'https://images.pokemontcg.io/ex7/48_hires.png', 'water'),
    (49, 'Skiploom', 'common', 'https://images.pokemontcg.io/ex7/49_hires.png', 'grass'),
    (50, 'Togepi', 'common', 'https://images.pokemontcg.io/ex7/50_hires.png', 'colorless'),
    (51, 'Cubone', 'common', 'https://images.pokemontcg.io/ex7/51_hires.png', 'fighting'),
    (52, 'Dratini', 'common', 'https://images.pokemontcg.io/ex7/52_hires.png', 'colorless'),
    (53, 'Dratini', 'common', 'https://images.pokemontcg.io/ex7/53_hires.png', 'colorless'),
    (54, 'Drowzee', 'common', 'https://images.pokemontcg.io/ex7/54_hires.png', 'psychic'),
    (55, 'Ekans', 'common', 'https://images.pokemontcg.io/ex7/55_hires.png', 'grass'),
    (56, 'Grimer', 'common', 'https://images.pokemontcg.io/ex7/56_hires.png', 'grass'),
    (57, 'Hoppip', 'common', 'https://images.pokemontcg.io/ex7/57_hires.png', 'grass'),
    (58, 'Horsea', 'common', 'https://images.pokemontcg.io/ex7/58_hires.png', 'water'),
    (59, 'Houndour', 'common', 'https://images.pokemontcg.io/ex7/59_hires.png', 'fire'),
    (60, 'Houndour', 'common', 'https://images.pokemontcg.io/ex7/60_hires.png', 'fire'),
    (61, 'Koffing', 'common', 'https://images.pokemontcg.io/ex7/61_hires.png', 'grass'),
    (62, 'Larvitar', 'common', 'https://images.pokemontcg.io/ex7/62_hires.png', 'fighting'),
    (63, 'Larvitar', 'common', 'https://images.pokemontcg.io/ex7/63_hires.png', 'fighting'),
    (64, 'Ledyba', 'common', 'https://images.pokemontcg.io/ex7/64_hires.png', 'grass'),
    (65, 'Magikarp', 'common', 'https://images.pokemontcg.io/ex7/65_hires.png', 'water'),
    (66, 'Magnemite', 'common', 'https://images.pokemontcg.io/ex7/66_hires.png', 'lightning'),
    (67, 'Mareep', 'common', 'https://images.pokemontcg.io/ex7/67_hires.png', 'lightning'),
    (68, 'Marill', 'common', 'https://images.pokemontcg.io/ex7/68_hires.png', 'water'),
    (69, 'Onix', 'common', 'https://images.pokemontcg.io/ex7/69_hires.png', 'fighting'),
    (70, 'Psyduck', 'common', 'https://images.pokemontcg.io/ex7/70_hires.png', 'water'),
    (71, 'Rattata', 'common', 'https://images.pokemontcg.io/ex7/71_hires.png', 'colorless'),
    (72, 'Rattata', 'common', 'https://images.pokemontcg.io/ex7/72_hires.png', 'colorless'),
    (73, 'Remoraid', 'common', 'https://images.pokemontcg.io/ex7/73_hires.png', 'water'),
    (74, 'Sandshrew', 'common', 'https://images.pokemontcg.io/ex7/74_hires.png', 'fighting'),
    (75, 'Sentret', 'common', 'https://images.pokemontcg.io/ex7/75_hires.png', 'colorless'),
    (76, 'Slowpoke', 'common', 'https://images.pokemontcg.io/ex7/76_hires.png', 'psychic'),
    (77, 'Slugma', 'common', 'https://images.pokemontcg.io/ex7/77_hires.png', 'fire'),
    (78, 'Spinarak', 'common', 'https://images.pokemontcg.io/ex7/78_hires.png', 'grass'),
    (79, 'Swinub', 'common', 'https://images.pokemontcg.io/ex7/79_hires.png', 'fighting'),
    (80, 'Voltorb', 'common', 'https://images.pokemontcg.io/ex7/80_hires.png', 'lightning'),
    (81, 'Wooper', 'common', 'https://images.pokemontcg.io/ex7/81_hires.png', 'water'),
    (82, 'Zubat', 'common', 'https://images.pokemontcg.io/ex7/82_hires.png', 'grass'),
    (83, 'Copycat', 'common', 'https://images.pokemontcg.io/ex7/83_hires.png', NULL),
    (84, 'Pokémon Retriever', 'common', 'https://images.pokemontcg.io/ex7/84_hires.png', NULL),
    (85, 'Pow! Hand Extension', 'common', 'https://images.pokemontcg.io/ex7/85_hires.png', NULL),
    (86, 'Rocket''s Admin.', 'common', 'https://images.pokemontcg.io/ex7/86_hires.png', NULL),
    (87, 'Rocket''s Hideout', 'common', 'https://images.pokemontcg.io/ex7/87_hires.png', NULL),
    (88, 'Rocket''s Mission', 'common', 'https://images.pokemontcg.io/ex7/88_hires.png', NULL),
    (89, 'Rocket''s Poké Ball', 'common', 'https://images.pokemontcg.io/ex7/89_hires.png', NULL),
    (90, 'Rocket''s Tricky Gym', 'common', 'https://images.pokemontcg.io/ex7/90_hires.png', NULL),
    (91, 'Surprise! Time Machine', 'common', 'https://images.pokemontcg.io/ex7/91_hires.png', NULL),
    (92, 'Swoop! Teleporter', 'common', 'https://images.pokemontcg.io/ex7/92_hires.png', NULL),
    (93, 'Venture Bomb', 'common', 'https://images.pokemontcg.io/ex7/93_hires.png', NULL),
    (94, 'Dark Metal Energy', 'common', 'https://images.pokemontcg.io/ex7/94_hires.png', NULL),
    (95, 'R Energy', 'common', 'https://images.pokemontcg.io/ex7/95_hires.png', NULL),
    (96, 'Rocket''s Articuno ex', 'double_rare', 'https://images.pokemontcg.io/ex7/96_hires.png', 'darkness'),
    (97, 'Rocket''s Entei ex', 'double_rare', 'https://images.pokemontcg.io/ex7/97_hires.png', 'darkness'),
    (98, 'Rocket''s Hitmonchan ex', 'double_rare', 'https://images.pokemontcg.io/ex7/98_hires.png', 'darkness'),
    (99, 'Rocket''s Mewtwo ex', 'double_rare', 'https://images.pokemontcg.io/ex7/99_hires.png', 'darkness'),
    (100, 'Rocket''s Moltres ex', 'double_rare', 'https://images.pokemontcg.io/ex7/100_hires.png', 'darkness'),
    (101, 'Rocket''s Scizor ex', 'double_rare', 'https://images.pokemontcg.io/ex7/101_hires.png', 'darkness'),
    (102, 'Rocket''s Scyther ex', 'double_rare', 'https://images.pokemontcg.io/ex7/102_hires.png', 'darkness'),
    (103, 'Rocket''s Sneasel ex', 'double_rare', 'https://images.pokemontcg.io/ex7/103_hires.png', 'darkness'),
    (104, 'Rocket''s Snorlax ex', 'double_rare', 'https://images.pokemontcg.io/ex7/104_hires.png', 'darkness'),
    (105, 'Rocket''s Suicune ex', 'double_rare', 'https://images.pokemontcg.io/ex7/105_hires.png', 'darkness'),
    (106, 'Rocket''s Zapdos ex', 'double_rare', 'https://images.pokemontcg.io/ex7/106_hires.png', 'darkness'),
    (107, 'Mudkip ★', 'ultra_rare', 'https://images.pokemontcg.io/ex7/107_hires.png', 'water'),
    (108, 'Torchic ★', 'ultra_rare', 'https://images.pokemontcg.io/ex7/108_hires.png', 'fire'),
    (109, 'Treecko ★', 'ultra_rare', 'https://images.pokemontcg.io/ex7/109_hires.png', 'grass'),
    (110, 'Charmeleon', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex7/110_hires.png', 'fire'),
    (111, 'Here Comes Team Rocket!', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex7/111_hires.png', NULL)
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

-- Set: Deoxys (ex8) -- 2005/02/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'deoxys', 'Deoxys', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'deoxys'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Altaria', 'rare', 'https://images.pokemontcg.io/ex8/1_hires.png', 'colorless'),
    (2, 'Beautifly', 'rare', 'https://images.pokemontcg.io/ex8/2_hires.png', 'grass'),
    (3, 'Breloom', 'rare', 'https://images.pokemontcg.io/ex8/3_hires.png', 'fighting'),
    (4, 'Camerupt', 'rare', 'https://images.pokemontcg.io/ex8/4_hires.png', 'fire'),
    (5, 'Claydol', 'rare', 'https://images.pokemontcg.io/ex8/5_hires.png', 'fighting'),
    (6, 'Crawdaunt', 'rare', 'https://images.pokemontcg.io/ex8/6_hires.png', 'darkness'),
    (7, 'Dusclops', 'rare', 'https://images.pokemontcg.io/ex8/7_hires.png', 'psychic'),
    (8, 'Gyarados', 'rare', 'https://images.pokemontcg.io/ex8/8_hires.png', 'water'),
    (9, 'Jirachi', 'rare', 'https://images.pokemontcg.io/ex8/9_hires.png', 'metal'),
    (10, 'Ludicolo', 'rare', 'https://images.pokemontcg.io/ex8/10_hires.png', 'water'),
    (11, 'Metagross', 'rare', 'https://images.pokemontcg.io/ex8/11_hires.png', 'psychic'),
    (12, 'Mightyena', 'rare', 'https://images.pokemontcg.io/ex8/12_hires.png', 'darkness'),
    (13, 'Ninjask', 'rare', 'https://images.pokemontcg.io/ex8/13_hires.png', 'grass'),
    (14, 'Shedinja', 'rare', 'https://images.pokemontcg.io/ex8/14_hires.png', 'psychic'),
    (15, 'Slaking', 'rare', 'https://images.pokemontcg.io/ex8/15_hires.png', 'colorless'),
    (16, 'Deoxys', 'rare', 'https://images.pokemontcg.io/ex8/16_hires.png', 'psychic'),
    (17, 'Deoxys', 'rare', 'https://images.pokemontcg.io/ex8/17_hires.png', 'psychic'),
    (18, 'Deoxys', 'rare', 'https://images.pokemontcg.io/ex8/18_hires.png', 'psychic'),
    (19, 'Ludicolo', 'rare', 'https://images.pokemontcg.io/ex8/19_hires.png', 'water'),
    (20, 'Magcargo', 'rare', 'https://images.pokemontcg.io/ex8/20_hires.png', 'fire'),
    (21, 'Pelipper', 'rare', 'https://images.pokemontcg.io/ex8/21_hires.png', 'water'),
    (22, 'Rayquaza', 'rare', 'https://images.pokemontcg.io/ex8/22_hires.png', 'colorless'),
    (23, 'Sableye', 'rare', 'https://images.pokemontcg.io/ex8/23_hires.png', 'darkness'),
    (24, 'Seaking', 'rare', 'https://images.pokemontcg.io/ex8/24_hires.png', 'water'),
    (25, 'Shiftry', 'rare', 'https://images.pokemontcg.io/ex8/25_hires.png', 'grass'),
    (26, 'Skarmory', 'rare', 'https://images.pokemontcg.io/ex8/26_hires.png', 'metal'),
    (27, 'Tropius', 'rare', 'https://images.pokemontcg.io/ex8/27_hires.png', 'grass'),
    (28, 'Whiscash', 'rare', 'https://images.pokemontcg.io/ex8/28_hires.png', 'fighting'),
    (29, 'Xatu', 'rare', 'https://images.pokemontcg.io/ex8/29_hires.png', 'psychic'),
    (30, 'Donphan', 'common', 'https://images.pokemontcg.io/ex8/30_hires.png', 'fighting'),
    (31, 'Golbat', 'common', 'https://images.pokemontcg.io/ex8/31_hires.png', 'grass'),
    (32, 'Grumpig', 'common', 'https://images.pokemontcg.io/ex8/32_hires.png', 'psychic'),
    (33, 'Lombre', 'common', 'https://images.pokemontcg.io/ex8/33_hires.png', 'water'),
    (34, 'Lombre', 'common', 'https://images.pokemontcg.io/ex8/34_hires.png', 'water'),
    (35, 'Lotad', 'common', 'https://images.pokemontcg.io/ex8/35_hires.png', 'water'),
    (36, 'Lunatone', 'common', 'https://images.pokemontcg.io/ex8/36_hires.png', 'fighting'),
    (37, 'Magcargo', 'common', 'https://images.pokemontcg.io/ex8/37_hires.png', 'fire'),
    (38, 'Manectric', 'common', 'https://images.pokemontcg.io/ex8/38_hires.png', 'lightning'),
    (39, 'Masquerain', 'common', 'https://images.pokemontcg.io/ex8/39_hires.png', 'grass'),
    (40, 'Metang', 'common', 'https://images.pokemontcg.io/ex8/40_hires.png', 'psychic'),
    (41, 'Minun', 'common', 'https://images.pokemontcg.io/ex8/41_hires.png', 'lightning'),
    (42, 'Nosepass', 'common', 'https://images.pokemontcg.io/ex8/42_hires.png', 'fighting'),
    (43, 'Nuzleaf', 'common', 'https://images.pokemontcg.io/ex8/43_hires.png', 'grass'),
    (44, 'Plusle', 'common', 'https://images.pokemontcg.io/ex8/44_hires.png', 'lightning'),
    (45, 'Shelgon', 'common', 'https://images.pokemontcg.io/ex8/45_hires.png', 'colorless'),
    (46, 'Silcoon', 'common', 'https://images.pokemontcg.io/ex8/46_hires.png', 'grass'),
    (47, 'Solrock', 'common', 'https://images.pokemontcg.io/ex8/47_hires.png', 'psychic'),
    (48, 'Starmie', 'common', 'https://images.pokemontcg.io/ex8/48_hires.png', 'water'),
    (49, 'Swellow', 'common', 'https://images.pokemontcg.io/ex8/49_hires.png', 'colorless'),
    (50, 'Vigoroth', 'common', 'https://images.pokemontcg.io/ex8/50_hires.png', 'colorless'),
    (51, 'Weezing', 'common', 'https://images.pokemontcg.io/ex8/51_hires.png', 'grass'),
    (52, 'Bagon', 'common', 'https://images.pokemontcg.io/ex8/52_hires.png', 'colorless'),
    (53, 'Baltoy', 'common', 'https://images.pokemontcg.io/ex8/53_hires.png', 'fighting'),
    (54, 'Barboach', 'common', 'https://images.pokemontcg.io/ex8/54_hires.png', 'water'),
    (55, 'Beldum', 'common', 'https://images.pokemontcg.io/ex8/55_hires.png', 'psychic'),
    (56, 'Carvanha', 'common', 'https://images.pokemontcg.io/ex8/56_hires.png', 'darkness'),
    (57, 'Corphish', 'common', 'https://images.pokemontcg.io/ex8/57_hires.png', 'water'),
    (58, 'Duskull', 'common', 'https://images.pokemontcg.io/ex8/58_hires.png', 'psychic'),
    (59, 'Electrike', 'common', 'https://images.pokemontcg.io/ex8/59_hires.png', 'lightning'),
    (60, 'Electrike', 'common', 'https://images.pokemontcg.io/ex8/60_hires.png', 'lightning'),
    (61, 'Goldeen', 'common', 'https://images.pokemontcg.io/ex8/61_hires.png', 'water'),
    (62, 'Koffing', 'common', 'https://images.pokemontcg.io/ex8/62_hires.png', 'grass'),
    (63, 'Lotad', 'common', 'https://images.pokemontcg.io/ex8/63_hires.png', 'water'),
    (64, 'Magikarp', 'common', 'https://images.pokemontcg.io/ex8/64_hires.png', 'water'),
    (65, 'Makuhita', 'common', 'https://images.pokemontcg.io/ex8/65_hires.png', 'fighting'),
    (66, 'Natu', 'common', 'https://images.pokemontcg.io/ex8/66_hires.png', 'psychic'),
    (67, 'Nincada', 'common', 'https://images.pokemontcg.io/ex8/67_hires.png', 'grass'),
    (68, 'Numel', 'common', 'https://images.pokemontcg.io/ex8/68_hires.png', 'fire'),
    (69, 'Phanpy', 'common', 'https://images.pokemontcg.io/ex8/69_hires.png', 'fighting'),
    (70, 'Poochyena', 'common', 'https://images.pokemontcg.io/ex8/70_hires.png', 'darkness'),
    (71, 'Seedot', 'common', 'https://images.pokemontcg.io/ex8/71_hires.png', 'grass'),
    (72, 'Shroomish', 'common', 'https://images.pokemontcg.io/ex8/72_hires.png', 'grass'),
    (73, 'Slakoth', 'common', 'https://images.pokemontcg.io/ex8/73_hires.png', 'colorless'),
    (74, 'Slugma', 'common', 'https://images.pokemontcg.io/ex8/74_hires.png', 'fire'),
    (75, 'Slugma', 'common', 'https://images.pokemontcg.io/ex8/75_hires.png', 'fire'),
    (76, 'Spoink', 'common', 'https://images.pokemontcg.io/ex8/76_hires.png', 'psychic'),
    (77, 'Staryu', 'common', 'https://images.pokemontcg.io/ex8/77_hires.png', 'water'),
    (78, 'Surskit', 'common', 'https://images.pokemontcg.io/ex8/78_hires.png', 'grass'),
    (79, 'Swablu', 'common', 'https://images.pokemontcg.io/ex8/79_hires.png', 'colorless'),
    (80, 'Taillow', 'common', 'https://images.pokemontcg.io/ex8/80_hires.png', 'colorless'),
    (81, 'Wingull', 'common', 'https://images.pokemontcg.io/ex8/81_hires.png', 'water'),
    (82, 'Wurmple', 'common', 'https://images.pokemontcg.io/ex8/82_hires.png', 'grass'),
    (83, 'Zubat', 'common', 'https://images.pokemontcg.io/ex8/83_hires.png', 'grass'),
    (84, 'Balloon Berry', 'common', 'https://images.pokemontcg.io/ex8/84_hires.png', NULL),
    (85, 'Crystal Shard', 'common', 'https://images.pokemontcg.io/ex8/85_hires.png', NULL),
    (86, 'Energy Charge', 'common', 'https://images.pokemontcg.io/ex8/86_hires.png', NULL),
    (87, 'Lady Outing', 'common', 'https://images.pokemontcg.io/ex8/87_hires.png', NULL),
    (88, 'Master Ball', 'common', 'https://images.pokemontcg.io/ex8/88_hires.png', NULL),
    (89, 'Meteor Falls', 'common', 'https://images.pokemontcg.io/ex8/89_hires.png', NULL),
    (90, 'Professor Cozmo''s Discovery', 'common', 'https://images.pokemontcg.io/ex8/90_hires.png', NULL),
    (91, 'Space Center', 'common', 'https://images.pokemontcg.io/ex8/91_hires.png', NULL),
    (92, 'Strength Charm', 'common', 'https://images.pokemontcg.io/ex8/92_hires.png', NULL),
    (93, 'Boost Energy', 'common', 'https://images.pokemontcg.io/ex8/93_hires.png', NULL),
    (94, 'Heal Energy', 'common', 'https://images.pokemontcg.io/ex8/94_hires.png', NULL),
    (95, 'Scramble Energy', 'common', 'https://images.pokemontcg.io/ex8/95_hires.png', NULL),
    (96, 'Crobat ex', 'double_rare', 'https://images.pokemontcg.io/ex8/96_hires.png', 'grass'),
    (97, 'Deoxys ex', 'double_rare', 'https://images.pokemontcg.io/ex8/97_hires.png', 'psychic'),
    (98, 'Deoxys ex', 'double_rare', 'https://images.pokemontcg.io/ex8/98_hires.png', 'psychic'),
    (99, 'Deoxys ex', 'double_rare', 'https://images.pokemontcg.io/ex8/99_hires.png', 'psychic'),
    (100, 'Hariyama ex', 'double_rare', 'https://images.pokemontcg.io/ex8/100_hires.png', 'fighting'),
    (101, 'Manectric ex', 'double_rare', 'https://images.pokemontcg.io/ex8/101_hires.png', 'lightning'),
    (102, 'Rayquaza ex', 'double_rare', 'https://images.pokemontcg.io/ex8/102_hires.png', 'colorless'),
    (103, 'Salamence ex', 'double_rare', 'https://images.pokemontcg.io/ex8/103_hires.png', 'colorless'),
    (104, 'Sharpedo ex', 'double_rare', 'https://images.pokemontcg.io/ex8/104_hires.png', 'darkness'),
    (105, 'Latias ★', 'ultra_rare', 'https://images.pokemontcg.io/ex8/105_hires.png', 'colorless'),
    (106, 'Latios ★', 'ultra_rare', 'https://images.pokemontcg.io/ex8/106_hires.png', 'colorless'),
    (107, 'Rayquaza ★', 'ultra_rare', 'https://images.pokemontcg.io/ex8/107_hires.png', 'colorless'),
    (108, 'Rocket''s Raikou ex', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex8/108_hires.png', 'darkness')
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

-- Set: Emerald (ex9) -- 2005/05/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'emerald', 'Emerald', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'emerald'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Blaziken', 'rare', 'https://images.pokemontcg.io/ex9/1_hires.png', 'fire'),
    (2, 'Deoxys', 'rare', 'https://images.pokemontcg.io/ex9/2_hires.png', 'psychic'),
    (3, 'Exploud', 'rare', 'https://images.pokemontcg.io/ex9/3_hires.png', 'colorless'),
    (4, 'Gardevoir', 'rare', 'https://images.pokemontcg.io/ex9/4_hires.png', 'psychic'),
    (5, 'Groudon', 'rare', 'https://images.pokemontcg.io/ex9/5_hires.png', 'fighting'),
    (6, 'Kyogre', 'rare', 'https://images.pokemontcg.io/ex9/6_hires.png', 'water'),
    (7, 'Manectric', 'rare', 'https://images.pokemontcg.io/ex9/7_hires.png', 'lightning'),
    (8, 'Milotic', 'rare', 'https://images.pokemontcg.io/ex9/8_hires.png', 'water'),
    (9, 'Rayquaza', 'rare', 'https://images.pokemontcg.io/ex9/9_hires.png', 'colorless'),
    (10, 'Sceptile', 'rare', 'https://images.pokemontcg.io/ex9/10_hires.png', 'grass'),
    (11, 'Swampert', 'rare', 'https://images.pokemontcg.io/ex9/11_hires.png', 'water'),
    (12, 'Chimecho', 'rare', 'https://images.pokemontcg.io/ex9/12_hires.png', 'psychic'),
    (13, 'Glalie', 'rare', 'https://images.pokemontcg.io/ex9/13_hires.png', 'water'),
    (14, 'Groudon', 'rare', 'https://images.pokemontcg.io/ex9/14_hires.png', 'fighting'),
    (15, 'Kyogre', 'rare', 'https://images.pokemontcg.io/ex9/15_hires.png', 'water'),
    (16, 'Manectric', 'rare', 'https://images.pokemontcg.io/ex9/16_hires.png', 'lightning'),
    (17, 'Nosepass', 'rare', 'https://images.pokemontcg.io/ex9/17_hires.png', 'fighting'),
    (18, 'Relicanth', 'rare', 'https://images.pokemontcg.io/ex9/18_hires.png', 'water'),
    (19, 'Rhydon', 'rare', 'https://images.pokemontcg.io/ex9/19_hires.png', 'fighting'),
    (20, 'Seviper', 'rare', 'https://images.pokemontcg.io/ex9/20_hires.png', 'grass'),
    (21, 'Zangoose', 'rare', 'https://images.pokemontcg.io/ex9/21_hires.png', 'colorless'),
    (22, 'Breloom', 'common', 'https://images.pokemontcg.io/ex9/22_hires.png', 'grass'),
    (23, 'Camerupt', 'common', 'https://images.pokemontcg.io/ex9/23_hires.png', 'fire'),
    (24, 'Claydol', 'common', 'https://images.pokemontcg.io/ex9/24_hires.png', 'fighting'),
    (25, 'Combusken', 'common', 'https://images.pokemontcg.io/ex9/25_hires.png', 'fire'),
    (26, 'Dodrio', 'common', 'https://images.pokemontcg.io/ex9/26_hires.png', 'colorless'),
    (27, 'Electrode', 'common', 'https://images.pokemontcg.io/ex9/27_hires.png', 'lightning'),
    (28, 'Grovyle', 'common', 'https://images.pokemontcg.io/ex9/28_hires.png', 'grass'),
    (29, 'Grumpig', 'common', 'https://images.pokemontcg.io/ex9/29_hires.png', 'psychic'),
    (30, 'Grumpig', 'common', 'https://images.pokemontcg.io/ex9/30_hires.png', 'psychic'),
    (31, 'Hariyama', 'common', 'https://images.pokemontcg.io/ex9/31_hires.png', 'fighting'),
    (32, 'Illumise', 'common', 'https://images.pokemontcg.io/ex9/32_hires.png', 'grass'),
    (33, 'Kirlia', 'common', 'https://images.pokemontcg.io/ex9/33_hires.png', 'psychic'),
    (34, 'Linoone', 'common', 'https://images.pokemontcg.io/ex9/34_hires.png', 'colorless'),
    (35, 'Loudred', 'common', 'https://images.pokemontcg.io/ex9/35_hires.png', 'colorless'),
    (36, 'Marshtomp', 'common', 'https://images.pokemontcg.io/ex9/36_hires.png', 'water'),
    (37, 'Minun', 'common', 'https://images.pokemontcg.io/ex9/37_hires.png', 'lightning'),
    (38, 'Ninetales', 'common', 'https://images.pokemontcg.io/ex9/38_hires.png', 'fire'),
    (39, 'Plusle', 'common', 'https://images.pokemontcg.io/ex9/39_hires.png', 'lightning'),
    (40, 'Swalot', 'common', 'https://images.pokemontcg.io/ex9/40_hires.png', 'grass'),
    (41, 'Swellow', 'common', 'https://images.pokemontcg.io/ex9/41_hires.png', 'colorless'),
    (42, 'Volbeat', 'common', 'https://images.pokemontcg.io/ex9/42_hires.png', 'grass'),
    (43, 'Baltoy', 'common', 'https://images.pokemontcg.io/ex9/43_hires.png', 'fighting'),
    (44, 'Cacnea', 'common', 'https://images.pokemontcg.io/ex9/44_hires.png', 'grass'),
    (45, 'Doduo', 'common', 'https://images.pokemontcg.io/ex9/45_hires.png', 'colorless'),
    (46, 'Duskull', 'common', 'https://images.pokemontcg.io/ex9/46_hires.png', 'psychic'),
    (47, 'Electrike', 'common', 'https://images.pokemontcg.io/ex9/47_hires.png', 'lightning'),
    (48, 'Electrike', 'common', 'https://images.pokemontcg.io/ex9/48_hires.png', 'lightning'),
    (49, 'Feebas', 'common', 'https://images.pokemontcg.io/ex9/49_hires.png', 'water'),
    (50, 'Feebas', 'common', 'https://images.pokemontcg.io/ex9/50_hires.png', 'water'),
    (51, 'Gulpin', 'common', 'https://images.pokemontcg.io/ex9/51_hires.png', 'grass'),
    (52, 'Larvitar', 'common', 'https://images.pokemontcg.io/ex9/52_hires.png', 'fighting'),
    (53, 'Luvdisc', 'common', 'https://images.pokemontcg.io/ex9/53_hires.png', 'water'),
    (54, 'Makuhita', 'common', 'https://images.pokemontcg.io/ex9/54_hires.png', 'fighting'),
    (55, 'Meditite', 'common', 'https://images.pokemontcg.io/ex9/55_hires.png', 'fighting'),
    (56, 'Mudkip', 'common', 'https://images.pokemontcg.io/ex9/56_hires.png', 'water'),
    (57, 'Numel', 'common', 'https://images.pokemontcg.io/ex9/57_hires.png', 'fire'),
    (58, 'Numel', 'common', 'https://images.pokemontcg.io/ex9/58_hires.png', 'fire'),
    (59, 'Pichu', 'common', 'https://images.pokemontcg.io/ex9/59_hires.png', 'lightning'),
    (60, 'Pikachu', 'common', 'https://images.pokemontcg.io/ex9/60_hires.png', 'lightning'),
    (61, 'Ralts', 'common', 'https://images.pokemontcg.io/ex9/61_hires.png', 'psychic'),
    (62, 'Rhyhorn', 'common', 'https://images.pokemontcg.io/ex9/62_hires.png', 'fighting'),
    (63, 'Shroomish', 'common', 'https://images.pokemontcg.io/ex9/63_hires.png', 'grass'),
    (64, 'Snorunt', 'common', 'https://images.pokemontcg.io/ex9/64_hires.png', 'water'),
    (65, 'Spoink', 'common', 'https://images.pokemontcg.io/ex9/65_hires.png', 'psychic'),
    (66, 'Spoink', 'common', 'https://images.pokemontcg.io/ex9/66_hires.png', 'psychic'),
    (67, 'Swablu', 'common', 'https://images.pokemontcg.io/ex9/67_hires.png', 'colorless'),
    (68, 'Taillow', 'common', 'https://images.pokemontcg.io/ex9/68_hires.png', 'colorless'),
    (69, 'Torchic', 'common', 'https://images.pokemontcg.io/ex9/69_hires.png', 'fire'),
    (70, 'Treecko', 'common', 'https://images.pokemontcg.io/ex9/70_hires.png', 'grass'),
    (71, 'Voltorb', 'common', 'https://images.pokemontcg.io/ex9/71_hires.png', 'lightning'),
    (72, 'Vulpix', 'common', 'https://images.pokemontcg.io/ex9/72_hires.png', 'fire'),
    (73, 'Whismur', 'common', 'https://images.pokemontcg.io/ex9/73_hires.png', 'colorless'),
    (74, 'Zigzagoon', 'common', 'https://images.pokemontcg.io/ex9/74_hires.png', 'colorless'),
    (75, 'Battle Frontier', 'common', 'https://images.pokemontcg.io/ex9/75_hires.png', NULL),
    (76, 'Double Full Heal', 'common', 'https://images.pokemontcg.io/ex9/76_hires.png', NULL),
    (77, 'Lanette''s Net Search', 'common', 'https://images.pokemontcg.io/ex9/77_hires.png', NULL),
    (78, 'Lum Berry', 'common', 'https://images.pokemontcg.io/ex9/78_hires.png', NULL),
    (79, 'Mr. Stone''s Project', 'common', 'https://images.pokemontcg.io/ex9/79_hires.png', NULL),
    (80, 'Oran Berry', 'common', 'https://images.pokemontcg.io/ex9/80_hires.png', NULL),
    (81, 'PokéNav', 'common', 'https://images.pokemontcg.io/ex9/81_hires.png', NULL),
    (82, 'Professor Birch', 'common', 'https://images.pokemontcg.io/ex9/82_hires.png', NULL),
    (83, 'Rare Candy', 'common', 'https://images.pokemontcg.io/ex9/83_hires.png', NULL),
    (84, 'Scott', 'common', 'https://images.pokemontcg.io/ex9/84_hires.png', NULL),
    (85, 'Wally''s Training', 'common', 'https://images.pokemontcg.io/ex9/85_hires.png', NULL),
    (86, 'Darkness Energy', 'rare', 'https://images.pokemontcg.io/ex9/86_hires.png', NULL),
    (87, 'Double Rainbow Energy', 'rare', 'https://images.pokemontcg.io/ex9/87_hires.png', NULL),
    (88, 'Metal Energy', 'rare', 'https://images.pokemontcg.io/ex9/88_hires.png', NULL),
    (89, 'Multi Energy', 'rare', 'https://images.pokemontcg.io/ex9/89_hires.png', NULL),
    (90, 'Altaria ex', 'double_rare', 'https://images.pokemontcg.io/ex9/90_hires.png', 'colorless'),
    (91, 'Cacturne ex', 'double_rare', 'https://images.pokemontcg.io/ex9/91_hires.png', 'grass'),
    (92, 'Camerupt ex', 'double_rare', 'https://images.pokemontcg.io/ex9/92_hires.png', 'fire'),
    (93, 'Deoxys ex', 'double_rare', 'https://images.pokemontcg.io/ex9/93_hires.png', 'psychic'),
    (94, 'Dusclops ex', 'double_rare', 'https://images.pokemontcg.io/ex9/94_hires.png', 'psychic'),
    (95, 'Medicham ex', 'double_rare', 'https://images.pokemontcg.io/ex9/95_hires.png', 'fighting'),
    (96, 'Milotic ex', 'double_rare', 'https://images.pokemontcg.io/ex9/96_hires.png', 'water'),
    (97, 'Raichu ex', 'double_rare', 'https://images.pokemontcg.io/ex9/97_hires.png', 'lightning'),
    (98, 'Regice ex', 'double_rare', 'https://images.pokemontcg.io/ex9/98_hires.png', 'water'),
    (99, 'Regirock ex', 'double_rare', 'https://images.pokemontcg.io/ex9/99_hires.png', 'fighting'),
    (100, 'Registeel ex', 'double_rare', 'https://images.pokemontcg.io/ex9/100_hires.png', 'metal'),
    (101, 'Grass Energy', 'rare', 'https://images.pokemontcg.io/ex9/101_hires.png', NULL),
    (102, 'Fire Energy', 'rare', 'https://images.pokemontcg.io/ex9/102_hires.png', NULL),
    (103, 'Water Energy', 'rare', 'https://images.pokemontcg.io/ex9/103_hires.png', NULL),
    (104, 'Lightning Energy', 'rare', 'https://images.pokemontcg.io/ex9/104_hires.png', NULL),
    (105, 'Psychic Energy', 'rare', 'https://images.pokemontcg.io/ex9/105_hires.png', NULL),
    (106, 'Fighting Energy', 'rare', 'https://images.pokemontcg.io/ex9/106_hires.png', NULL),
    (107, 'Farfetch''d', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex9/107_hires.png', 'colorless')
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

-- Set: Unseen Forces (ex10) -- 2005/08/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'unseen-forces', 'Unseen Forces', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'unseen-forces'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Ampharos', 'rare', 'https://images.pokemontcg.io/ex10/1_hires.png', 'lightning'),
    (2, 'Ariados', 'rare', 'https://images.pokemontcg.io/ex10/2_hires.png', 'grass'),
    (3, 'Bellossom', 'rare', 'https://images.pokemontcg.io/ex10/3_hires.png', 'grass'),
    (4, 'Feraligatr', 'rare', 'https://images.pokemontcg.io/ex10/4_hires.png', 'water'),
    (5, 'Flareon', 'rare', 'https://images.pokemontcg.io/ex10/5_hires.png', 'fire'),
    (6, 'Forretress', 'rare', 'https://images.pokemontcg.io/ex10/6_hires.png', 'metal'),
    (7, 'Houndoom', 'rare', 'https://images.pokemontcg.io/ex10/7_hires.png', 'fire'),
    (8, 'Jolteon', 'rare', 'https://images.pokemontcg.io/ex10/8_hires.png', 'lightning'),
    (9, 'Meganium', 'rare', 'https://images.pokemontcg.io/ex10/9_hires.png', 'grass'),
    (10, 'Octillery', 'rare', 'https://images.pokemontcg.io/ex10/10_hires.png', 'water'),
    (11, 'Poliwrath', 'rare', 'https://images.pokemontcg.io/ex10/11_hires.png', 'fighting'),
    (12, 'Porygon2', 'rare', 'https://images.pokemontcg.io/ex10/12_hires.png', 'colorless'),
    (13, 'Slowbro', 'rare', 'https://images.pokemontcg.io/ex10/13_hires.png', 'water'),
    (14, 'Slowking', 'rare', 'https://images.pokemontcg.io/ex10/14_hires.png', 'psychic'),
    (15, 'Sudowoodo', 'rare', 'https://images.pokemontcg.io/ex10/15_hires.png', 'fighting'),
    (16, 'Sunflora', 'rare', 'https://images.pokemontcg.io/ex10/16_hires.png', 'grass'),
    (17, 'Typhlosion', 'rare', 'https://images.pokemontcg.io/ex10/17_hires.png', 'fire'),
    (18, 'Ursaring', 'rare', 'https://images.pokemontcg.io/ex10/18_hires.png', 'colorless'),
    (19, 'Vaporeon', 'rare', 'https://images.pokemontcg.io/ex10/19_hires.png', 'water'),
    (20, 'Chansey', 'rare', 'https://images.pokemontcg.io/ex10/20_hires.png', 'colorless'),
    (21, 'Cleffa', 'rare', 'https://images.pokemontcg.io/ex10/21_hires.png', 'colorless'),
    (22, 'Electabuzz', 'rare', 'https://images.pokemontcg.io/ex10/22_hires.png', 'lightning'),
    (23, 'Elekid', 'rare', 'https://images.pokemontcg.io/ex10/23_hires.png', 'lightning'),
    (24, 'Hitmonchan', 'rare', 'https://images.pokemontcg.io/ex10/24_hires.png', 'fighting'),
    (25, 'Hitmonlee', 'rare', 'https://images.pokemontcg.io/ex10/25_hires.png', 'fighting'),
    (26, 'Hitmontop', 'rare', 'https://images.pokemontcg.io/ex10/26_hires.png', 'fighting'),
    (27, 'Ho-Oh', 'rare', 'https://images.pokemontcg.io/ex10/27_hires.png', 'fire'),
    (28, 'Jynx', 'rare', 'https://images.pokemontcg.io/ex10/28_hires.png', 'water'),
    (29, 'Lugia', 'rare', 'https://images.pokemontcg.io/ex10/29_hires.png', 'psychic'),
    (30, 'Murkrow', 'rare', 'https://images.pokemontcg.io/ex10/30_hires.png', 'darkness'),
    (31, 'Smoochum', 'rare', 'https://images.pokemontcg.io/ex10/31_hires.png', 'water'),
    (32, 'Stantler', 'rare', 'https://images.pokemontcg.io/ex10/32_hires.png', 'colorless'),
    (33, 'Tyrogue', 'rare', 'https://images.pokemontcg.io/ex10/33_hires.png', 'fighting'),
    (34, 'Aipom', 'common', 'https://images.pokemontcg.io/ex10/34_hires.png', 'colorless'),
    (35, 'Bayleef', 'common', 'https://images.pokemontcg.io/ex10/35_hires.png', 'grass'),
    (36, 'Clefable', 'common', 'https://images.pokemontcg.io/ex10/36_hires.png', 'colorless'),
    (37, 'Corsola', 'common', 'https://images.pokemontcg.io/ex10/37_hires.png', 'water'),
    (38, 'Croconaw', 'common', 'https://images.pokemontcg.io/ex10/38_hires.png', 'water'),
    (39, 'Granbull', 'common', 'https://images.pokemontcg.io/ex10/39_hires.png', 'colorless'),
    (40, 'Lanturn', 'common', 'https://images.pokemontcg.io/ex10/40_hires.png', 'lightning'),
    (41, 'Magcargo', 'common', 'https://images.pokemontcg.io/ex10/41_hires.png', 'fire'),
    (42, 'Miltank', 'common', 'https://images.pokemontcg.io/ex10/42_hires.png', 'colorless'),
    (43, 'Noctowl', 'common', 'https://images.pokemontcg.io/ex10/43_hires.png', 'colorless'),
    (44, 'Quagsire', 'common', 'https://images.pokemontcg.io/ex10/44_hires.png', 'fighting'),
    (45, 'Quilava', 'common', 'https://images.pokemontcg.io/ex10/45_hires.png', 'fire'),
    (46, 'Scyther', 'common', 'https://images.pokemontcg.io/ex10/46_hires.png', 'grass'),
    (47, 'Shuckle', 'common', 'https://images.pokemontcg.io/ex10/47_hires.png', 'grass'),
    (48, 'Smeargle', 'common', 'https://images.pokemontcg.io/ex10/48_hires.png', 'colorless'),
    (49, 'Xatu', 'common', 'https://images.pokemontcg.io/ex10/49_hires.png', 'psychic'),
    (50, 'Yanma', 'common', 'https://images.pokemontcg.io/ex10/50_hires.png', 'grass'),
    (51, 'Chikorita', 'common', 'https://images.pokemontcg.io/ex10/51_hires.png', 'grass'),
    (52, 'Chinchou', 'common', 'https://images.pokemontcg.io/ex10/52_hires.png', 'lightning'),
    (53, 'Clefairy', 'common', 'https://images.pokemontcg.io/ex10/53_hires.png', 'colorless'),
    (54, 'Cyndaquil', 'common', 'https://images.pokemontcg.io/ex10/54_hires.png', 'fire'),
    (55, 'Eevee', 'common', 'https://images.pokemontcg.io/ex10/55_hires.png', 'colorless'),
    (56, 'Flaaffy', 'common', 'https://images.pokemontcg.io/ex10/56_hires.png', 'lightning'),
    (57, 'Gligar', 'common', 'https://images.pokemontcg.io/ex10/57_hires.png', 'fighting'),
    (58, 'Gloom', 'common', 'https://images.pokemontcg.io/ex10/58_hires.png', 'grass'),
    (59, 'Hoothoot', 'common', 'https://images.pokemontcg.io/ex10/59_hires.png', 'colorless'),
    (60, 'Houndour', 'common', 'https://images.pokemontcg.io/ex10/60_hires.png', 'fire'),
    (61, 'Larvitar', 'common', 'https://images.pokemontcg.io/ex10/61_hires.png', 'fighting'),
    (62, 'Mareep', 'common', 'https://images.pokemontcg.io/ex10/62_hires.png', 'lightning'),
    (63, 'Natu', 'common', 'https://images.pokemontcg.io/ex10/63_hires.png', 'psychic'),
    (64, 'Oddish', 'common', 'https://images.pokemontcg.io/ex10/64_hires.png', 'grass'),
    (65, 'Onix', 'common', 'https://images.pokemontcg.io/ex10/65_hires.png', 'fighting'),
    (66, 'Pineco', 'common', 'https://images.pokemontcg.io/ex10/66_hires.png', 'grass'),
    (67, 'Poliwag', 'common', 'https://images.pokemontcg.io/ex10/67_hires.png', 'water'),
    (68, 'Poliwhirl', 'common', 'https://images.pokemontcg.io/ex10/68_hires.png', 'water'),
    (69, 'Porygon', 'common', 'https://images.pokemontcg.io/ex10/69_hires.png', 'colorless'),
    (70, 'Pupitar', 'common', 'https://images.pokemontcg.io/ex10/70_hires.png', 'fighting'),
    (71, 'Remoraid', 'common', 'https://images.pokemontcg.io/ex10/71_hires.png', 'water'),
    (72, 'Slowpoke', 'common', 'https://images.pokemontcg.io/ex10/72_hires.png', 'psychic'),
    (73, 'Slugma', 'common', 'https://images.pokemontcg.io/ex10/73_hires.png', 'fire'),
    (74, 'Snubbull', 'common', 'https://images.pokemontcg.io/ex10/74_hires.png', 'colorless'),
    (75, 'Spinarak', 'common', 'https://images.pokemontcg.io/ex10/75_hires.png', 'grass'),
    (76, 'Sunkern', 'common', 'https://images.pokemontcg.io/ex10/76_hires.png', 'grass'),
    (77, 'Teddiursa', 'common', 'https://images.pokemontcg.io/ex10/77_hires.png', 'colorless'),
    (78, 'Totodile', 'common', 'https://images.pokemontcg.io/ex10/78_hires.png', 'water'),
    (79, 'Wooper', 'common', 'https://images.pokemontcg.io/ex10/79_hires.png', 'fighting'),
    (80, 'Curse Powder', 'common', 'https://images.pokemontcg.io/ex10/80_hires.png', NULL),
    (81, 'Energy Recycle System', 'common', 'https://images.pokemontcg.io/ex10/81_hires.png', NULL),
    (82, 'Energy Removal 2', 'common', 'https://images.pokemontcg.io/ex10/82_hires.png', NULL),
    (83, 'Energy Root', 'common', 'https://images.pokemontcg.io/ex10/83_hires.png', NULL),
    (84, 'Energy Switch', 'common', 'https://images.pokemontcg.io/ex10/84_hires.png', NULL),
    (85, 'Fluffy Berry', 'common', 'https://images.pokemontcg.io/ex10/85_hires.png', NULL),
    (86, 'Mary''s Request', 'common', 'https://images.pokemontcg.io/ex10/86_hires.png', NULL),
    (87, 'Poké Ball', 'common', 'https://images.pokemontcg.io/ex10/87_hires.png', NULL),
    (88, 'Pokémon Reversal', 'common', 'https://images.pokemontcg.io/ex10/88_hires.png', NULL),
    (89, 'Professor Elm''s Training Method', 'common', 'https://images.pokemontcg.io/ex10/89_hires.png', NULL),
    (90, 'Protective Orb', 'common', 'https://images.pokemontcg.io/ex10/90_hires.png', NULL),
    (91, 'Sitrus Berry', 'common', 'https://images.pokemontcg.io/ex10/91_hires.png', NULL),
    (92, 'Solid Rage', 'common', 'https://images.pokemontcg.io/ex10/92_hires.png', NULL),
    (93, 'Warp Point', 'common', 'https://images.pokemontcg.io/ex10/93_hires.png', NULL),
    (94, 'Energy Search', 'common', 'https://images.pokemontcg.io/ex10/94_hires.png', NULL),
    (95, 'Potion', 'common', 'https://images.pokemontcg.io/ex10/95_hires.png', NULL),
    (96, 'Darkness Energy', 'rare', 'https://images.pokemontcg.io/ex10/96_hires.png', NULL),
    (97, 'Metal Energy', 'rare', 'https://images.pokemontcg.io/ex10/97_hires.png', NULL),
    (98, 'Boost Energy', 'common', 'https://images.pokemontcg.io/ex10/98_hires.png', NULL),
    (99, 'Cyclone Energy', 'common', 'https://images.pokemontcg.io/ex10/99_hires.png', NULL),
    (100, 'Warp Energy', 'common', 'https://images.pokemontcg.io/ex10/100_hires.png', NULL),
    (101, 'Blissey ex', 'double_rare', 'https://images.pokemontcg.io/ex10/101_hires.png', 'colorless'),
    (102, 'Espeon ex', 'double_rare', 'https://images.pokemontcg.io/ex10/102_hires.png', 'psychic'),
    (103, 'Feraligatr ex', 'double_rare', 'https://images.pokemontcg.io/ex10/103_hires.png', 'water'),
    (104, 'Ho-Oh ex', 'double_rare', 'https://images.pokemontcg.io/ex10/104_hires.png', 'fire'),
    (105, 'Lugia ex', 'double_rare', 'https://images.pokemontcg.io/ex10/105_hires.png', 'colorless'),
    (106, 'Meganium ex', 'double_rare', 'https://images.pokemontcg.io/ex10/106_hires.png', 'grass'),
    (107, 'Politoed ex', 'double_rare', 'https://images.pokemontcg.io/ex10/107_hires.png', 'water'),
    (108, 'Scizor ex', 'double_rare', 'https://images.pokemontcg.io/ex10/108_hires.png', 'metal'),
    (109, 'Steelix ex', 'double_rare', 'https://images.pokemontcg.io/ex10/109_hires.png', 'metal'),
    (110, 'Typhlosion ex', 'double_rare', 'https://images.pokemontcg.io/ex10/110_hires.png', 'fire'),
    (111, 'Tyranitar ex', 'double_rare', 'https://images.pokemontcg.io/ex10/111_hires.png', 'darkness'),
    (112, 'Umbreon ex', 'double_rare', 'https://images.pokemontcg.io/ex10/112_hires.png', 'darkness'),
    (113, 'Entei ★', 'ultra_rare', 'https://images.pokemontcg.io/ex10/113_hires.png', 'fire'),
    (114, 'Raikou ★', 'ultra_rare', 'https://images.pokemontcg.io/ex10/114_hires.png', 'lightning'),
    (115, 'Suicune ★', 'ultra_rare', 'https://images.pokemontcg.io/ex10/115_hires.png', 'water'),
    (116, 'Rocket''s Persian ex', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex10/116_hires.png', 'darkness'),
    (117, 'Celebi ex', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex10/117_hires.png', 'grass'),
    (501000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/A_hires.png', 'psychic'),
    (502000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/B_hires.png', 'psychic'),
    (503000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/C_hires.png', 'psychic'),
    (504000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/D_hires.png', 'psychic'),
    (505000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/E_hires.png', 'psychic'),
    (506000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/F_hires.png', 'psychic'),
    (507000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/G_hires.png', 'psychic'),
    (508000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/H_hires.png', 'psychic'),
    (509000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/I_hires.png', 'psychic'),
    (510000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/J_hires.png', 'psychic'),
    (511000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/K_hires.png', 'psychic'),
    (512000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/L_hires.png', 'psychic'),
    (513000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/M_hires.png', 'psychic'),
    (514000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/N_hires.png', 'psychic'),
    (515000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/O_hires.png', 'psychic'),
    (516000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/P_hires.png', 'psychic'),
    (517000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/Q_hires.png', 'psychic'),
    (518000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/R_hires.png', 'psychic'),
    (519000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/S_hires.png', 'psychic'),
    (520000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/T_hires.png', 'psychic'),
    (521000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/U_hires.png', 'psychic'),
    (522000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/V_hires.png', 'psychic'),
    (523000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/W_hires.png', 'psychic'),
    (524000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/X_hires.png', 'psychic'),
    (525000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/Y_hires.png', 'psychic'),
    (526000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/Z_hires.png', 'psychic'),
    (527000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/!_hires.png', 'psychic'),
    (528000, 'Unown', 'rare', 'https://images.pokemontcg.io/ex10/question_hires.png', 'psychic')
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

-- Set: Delta Species (ex11) -- 2005/10/31
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'delta-species', 'Delta Species', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'delta-species'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Beedrill δ', 'rare', 'https://images.pokemontcg.io/ex11/1_hires.png', 'grass'),
    (2, 'Crobat δ', 'rare', 'https://images.pokemontcg.io/ex11/2_hires.png', 'grass'),
    (3, 'Dragonite δ', 'rare', 'https://images.pokemontcg.io/ex11/3_hires.png', 'lightning'),
    (4, 'Espeon δ', 'rare', 'https://images.pokemontcg.io/ex11/4_hires.png', 'psychic'),
    (5, 'Flareon δ', 'rare', 'https://images.pokemontcg.io/ex11/5_hires.png', 'fire'),
    (6, 'Gardevoir δ', 'rare', 'https://images.pokemontcg.io/ex11/6_hires.png', 'psychic'),
    (7, 'Jolteon δ', 'rare', 'https://images.pokemontcg.io/ex11/7_hires.png', 'lightning'),
    (8, 'Latias δ', 'rare', 'https://images.pokemontcg.io/ex11/8_hires.png', 'lightning'),
    (9, 'Latios δ', 'rare', 'https://images.pokemontcg.io/ex11/9_hires.png', 'lightning'),
    (10, 'Marowak δ', 'rare', 'https://images.pokemontcg.io/ex11/10_hires.png', 'fighting'),
    (11, 'Metagross δ', 'rare', 'https://images.pokemontcg.io/ex11/11_hires.png', 'lightning'),
    (12, 'Mewtwo δ', 'rare', 'https://images.pokemontcg.io/ex11/12_hires.png', 'fire'),
    (13, 'Rayquaza δ', 'rare', 'https://images.pokemontcg.io/ex11/13_hires.png', 'lightning'),
    (14, 'Salamence δ', 'rare', 'https://images.pokemontcg.io/ex11/14_hires.png', 'fire'),
    (15, 'Starmie δ', 'rare', 'https://images.pokemontcg.io/ex11/15_hires.png', 'water'),
    (16, 'Tyranitar δ', 'rare', 'https://images.pokemontcg.io/ex11/16_hires.png', 'fire'),
    (17, 'Umbreon δ', 'rare', 'https://images.pokemontcg.io/ex11/17_hires.png', 'darkness'),
    (18, 'Vaporeon δ', 'rare', 'https://images.pokemontcg.io/ex11/18_hires.png', 'water'),
    (19, 'Azumarill δ', 'rare', 'https://images.pokemontcg.io/ex11/19_hires.png', 'water'),
    (20, 'Azurill', 'rare', 'https://images.pokemontcg.io/ex11/20_hires.png', 'colorless'),
    (21, 'Holon''s Electrode', 'rare', 'https://images.pokemontcg.io/ex11/21_hires.png', 'lightning'),
    (22, 'Holon''s Magneton', 'rare', 'https://images.pokemontcg.io/ex11/22_hires.png', 'metal'),
    (23, 'Hypno', 'rare', 'https://images.pokemontcg.io/ex11/23_hires.png', 'psychic'),
    (24, 'Mightyena δ', 'rare', 'https://images.pokemontcg.io/ex11/24_hires.png', 'darkness'),
    (25, 'Porygon2', 'rare', 'https://images.pokemontcg.io/ex11/25_hires.png', 'colorless'),
    (26, 'Rain Castform', 'rare', 'https://images.pokemontcg.io/ex11/26_hires.png', 'water'),
    (27, 'Sandslash δ', 'rare', 'https://images.pokemontcg.io/ex11/27_hires.png', 'fighting'),
    (28, 'Slowking', 'rare', 'https://images.pokemontcg.io/ex11/28_hires.png', 'water'),
    (29, 'Snow-cloud Castform', 'rare', 'https://images.pokemontcg.io/ex11/29_hires.png', 'water'),
    (30, 'Starmie δ', 'rare', 'https://images.pokemontcg.io/ex11/30_hires.png', 'water'),
    (31, 'Sunny Castform', 'rare', 'https://images.pokemontcg.io/ex11/31_hires.png', 'fire'),
    (32, 'Swellow', 'rare', 'https://images.pokemontcg.io/ex11/32_hires.png', 'colorless'),
    (33, 'Weezing', 'rare', 'https://images.pokemontcg.io/ex11/33_hires.png', 'grass'),
    (34, 'Castform', 'common', 'https://images.pokemontcg.io/ex11/34_hires.png', 'colorless'),
    (35, 'Ditto', 'common', 'https://images.pokemontcg.io/ex11/35_hires.png', 'colorless'),
    (36, 'Ditto', 'common', 'https://images.pokemontcg.io/ex11/36_hires.png', 'grass'),
    (37, 'Ditto', 'common', 'https://images.pokemontcg.io/ex11/37_hires.png', 'fire'),
    (38, 'Ditto', 'common', 'https://images.pokemontcg.io/ex11/38_hires.png', 'psychic'),
    (39, 'Ditto', 'common', 'https://images.pokemontcg.io/ex11/39_hires.png', 'lightning'),
    (40, 'Ditto', 'common', 'https://images.pokemontcg.io/ex11/40_hires.png', 'water'),
    (41, 'Dragonair δ', 'common', 'https://images.pokemontcg.io/ex11/41_hires.png', 'lightning'),
    (42, 'Dragonair δ', 'common', 'https://images.pokemontcg.io/ex11/42_hires.png', 'lightning'),
    (43, 'Golbat', 'common', 'https://images.pokemontcg.io/ex11/43_hires.png', 'grass'),
    (44, 'Hariyama', 'common', 'https://images.pokemontcg.io/ex11/44_hires.png', 'fighting'),
    (45, 'Illumise', 'common', 'https://images.pokemontcg.io/ex11/45_hires.png', 'grass'),
    (46, 'Kakuna', 'common', 'https://images.pokemontcg.io/ex11/46_hires.png', 'grass'),
    (47, 'Kirlia', 'common', 'https://images.pokemontcg.io/ex11/47_hires.png', 'psychic'),
    (48, 'Magneton', 'common', 'https://images.pokemontcg.io/ex11/48_hires.png', 'lightning'),
    (49, 'Metang δ', 'common', 'https://images.pokemontcg.io/ex11/49_hires.png', 'lightning'),
    (50, 'Persian', 'common', 'https://images.pokemontcg.io/ex11/50_hires.png', 'colorless'),
    (51, 'Pupitar δ', 'common', 'https://images.pokemontcg.io/ex11/51_hires.png', 'fire'),
    (52, 'Rapidash', 'common', 'https://images.pokemontcg.io/ex11/52_hires.png', 'fire'),
    (53, 'Shelgon δ', 'common', 'https://images.pokemontcg.io/ex11/53_hires.png', 'fire'),
    (54, 'Shelgon δ', 'common', 'https://images.pokemontcg.io/ex11/54_hires.png', 'fire'),
    (55, 'Skarmory', 'common', 'https://images.pokemontcg.io/ex11/55_hires.png', 'metal'),
    (56, 'Volbeat', 'common', 'https://images.pokemontcg.io/ex11/56_hires.png', 'grass'),
    (57, 'Bagon δ', 'common', 'https://images.pokemontcg.io/ex11/57_hires.png', 'fire'),
    (58, 'Bagon δ', 'common', 'https://images.pokemontcg.io/ex11/58_hires.png', 'fire'),
    (59, 'Beldum δ', 'common', 'https://images.pokemontcg.io/ex11/59_hires.png', 'lightning'),
    (60, 'Cubone', 'common', 'https://images.pokemontcg.io/ex11/60_hires.png', 'fighting'),
    (61, 'Ditto', 'common', 'https://images.pokemontcg.io/ex11/61_hires.png', 'fire'),
    (62, 'Ditto', 'common', 'https://images.pokemontcg.io/ex11/62_hires.png', 'fighting'),
    (63, 'Ditto', 'common', 'https://images.pokemontcg.io/ex11/63_hires.png', 'lightning'),
    (64, 'Ditto', 'common', 'https://images.pokemontcg.io/ex11/64_hires.png', 'water'),
    (65, 'Dratini δ', 'common', 'https://images.pokemontcg.io/ex11/65_hires.png', 'lightning'),
    (66, 'Dratini δ', 'common', 'https://images.pokemontcg.io/ex11/66_hires.png', 'lightning'),
    (67, 'Drowzee', 'common', 'https://images.pokemontcg.io/ex11/67_hires.png', 'psychic'),
    (68, 'Eevee δ', 'common', 'https://images.pokemontcg.io/ex11/68_hires.png', 'metal'),
    (69, 'Eevee', 'common', 'https://images.pokemontcg.io/ex11/69_hires.png', 'colorless'),
    (70, 'Holon''s Magnemite', 'common', 'https://images.pokemontcg.io/ex11/70_hires.png', 'metal'),
    (71, 'Holon''s Voltorb', 'common', 'https://images.pokemontcg.io/ex11/71_hires.png', 'lightning'),
    (72, 'Koffing', 'common', 'https://images.pokemontcg.io/ex11/72_hires.png', 'grass'),
    (73, 'Larvitar δ', 'common', 'https://images.pokemontcg.io/ex11/73_hires.png', 'fire'),
    (74, 'Magnemite', 'common', 'https://images.pokemontcg.io/ex11/74_hires.png', 'lightning'),
    (75, 'Makuhita', 'common', 'https://images.pokemontcg.io/ex11/75_hires.png', 'fighting'),
    (76, 'Marill', 'common', 'https://images.pokemontcg.io/ex11/76_hires.png', 'water'),
    (77, 'Meowth', 'common', 'https://images.pokemontcg.io/ex11/77_hires.png', 'colorless'),
    (78, 'Ponyta', 'common', 'https://images.pokemontcg.io/ex11/78_hires.png', 'fire'),
    (79, 'Poochyena', 'common', 'https://images.pokemontcg.io/ex11/79_hires.png', 'darkness'),
    (80, 'Porygon', 'common', 'https://images.pokemontcg.io/ex11/80_hires.png', 'colorless'),
    (81, 'Ralts', 'common', 'https://images.pokemontcg.io/ex11/81_hires.png', 'psychic'),
    (82, 'Sandshrew', 'common', 'https://images.pokemontcg.io/ex11/82_hires.png', 'fighting'),
    (83, 'Slowpoke', 'common', 'https://images.pokemontcg.io/ex11/83_hires.png', 'water'),
    (84, 'Staryu', 'common', 'https://images.pokemontcg.io/ex11/84_hires.png', 'water'),
    (85, 'Staryu', 'common', 'https://images.pokemontcg.io/ex11/85_hires.png', 'water'),
    (86, 'Taillow', 'common', 'https://images.pokemontcg.io/ex11/86_hires.png', 'colorless'),
    (87, 'Weedle', 'common', 'https://images.pokemontcg.io/ex11/87_hires.png', 'grass'),
    (88, 'Zubat', 'common', 'https://images.pokemontcg.io/ex11/88_hires.png', 'grass'),
    (89, 'Dual Ball', 'common', 'https://images.pokemontcg.io/ex11/89_hires.png', NULL),
    (90, 'Great Ball', 'common', 'https://images.pokemontcg.io/ex11/90_hires.png', NULL),
    (91, 'Holon Farmer', 'common', 'https://images.pokemontcg.io/ex11/91_hires.png', NULL),
    (92, 'Holon Lass', 'common', 'https://images.pokemontcg.io/ex11/92_hires.png', NULL),
    (93, 'Holon Mentor', 'common', 'https://images.pokemontcg.io/ex11/93_hires.png', NULL),
    (94, 'Holon Research Tower', 'common', 'https://images.pokemontcg.io/ex11/94_hires.png', NULL),
    (95, 'Holon Researcher', 'common', 'https://images.pokemontcg.io/ex11/95_hires.png', NULL),
    (96, 'Holon Ruins', 'common', 'https://images.pokemontcg.io/ex11/96_hires.png', NULL),
    (97, 'Holon Scientist', 'common', 'https://images.pokemontcg.io/ex11/97_hires.png', NULL),
    (98, 'Holon Transceiver', 'common', 'https://images.pokemontcg.io/ex11/98_hires.png', NULL),
    (99, 'Master Ball', 'common', 'https://images.pokemontcg.io/ex11/99_hires.png', NULL),
    (100, 'Super Scoop Up', 'common', 'https://images.pokemontcg.io/ex11/100_hires.png', NULL),
    (101, 'Potion', 'common', 'https://images.pokemontcg.io/ex11/101_hires.png', NULL),
    (102, 'Switch', 'common', 'https://images.pokemontcg.io/ex11/102_hires.png', NULL),
    (103, 'Darkness Energy', 'rare', 'https://images.pokemontcg.io/ex11/103_hires.png', NULL),
    (104, 'Holon Energy FF', 'rare', 'https://images.pokemontcg.io/ex11/104_hires.png', NULL),
    (105, 'Holon Energy GL', 'rare', 'https://images.pokemontcg.io/ex11/105_hires.png', NULL),
    (106, 'Holon Energy WP', 'rare', 'https://images.pokemontcg.io/ex11/106_hires.png', NULL),
    (107, 'Metal Energy', 'rare', 'https://images.pokemontcg.io/ex11/107_hires.png', NULL),
    (108, 'Flareon ex', 'double_rare', 'https://images.pokemontcg.io/ex11/108_hires.png', 'fire'),
    (109, 'Jolteon ex', 'double_rare', 'https://images.pokemontcg.io/ex11/109_hires.png', 'lightning'),
    (110, 'Vaporeon ex', 'double_rare', 'https://images.pokemontcg.io/ex11/110_hires.png', 'water'),
    (111, 'Groudon ★', 'ultra_rare', 'https://images.pokemontcg.io/ex11/111_hires.png', 'fighting'),
    (112, 'Kyogre ★', 'ultra_rare', 'https://images.pokemontcg.io/ex11/112_hires.png', 'water'),
    (113, 'Metagross ★', 'ultra_rare', 'https://images.pokemontcg.io/ex11/113_hires.png', 'metal'),
    (114, 'Azumarill', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex11/114_hires.png', 'water')
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

-- Set: Legend Maker (ex12) -- 2006/02/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'legend-maker', 'Legend Maker', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'legend-maker'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Aerodactyl', 'rare', 'https://images.pokemontcg.io/ex12/1_hires.png', 'colorless'),
    (2, 'Aggron', 'rare', 'https://images.pokemontcg.io/ex12/2_hires.png', 'metal'),
    (3, 'Cradily', 'rare', 'https://images.pokemontcg.io/ex12/3_hires.png', 'grass'),
    (4, 'Delcatty', 'rare', 'https://images.pokemontcg.io/ex12/4_hires.png', 'colorless'),
    (5, 'Gengar', 'rare', 'https://images.pokemontcg.io/ex12/5_hires.png', 'psychic'),
    (6, 'Golem', 'rare', 'https://images.pokemontcg.io/ex12/6_hires.png', 'fighting'),
    (7, 'Kabutops', 'rare', 'https://images.pokemontcg.io/ex12/7_hires.png', 'fighting'),
    (8, 'Lapras', 'rare', 'https://images.pokemontcg.io/ex12/8_hires.png', 'water'),
    (9, 'Machamp', 'rare', 'https://images.pokemontcg.io/ex12/9_hires.png', 'fighting'),
    (10, 'Mew', 'rare', 'https://images.pokemontcg.io/ex12/10_hires.png', 'psychic'),
    (11, 'Muk', 'rare', 'https://images.pokemontcg.io/ex12/11_hires.png', 'grass'),
    (12, 'Shiftry', 'rare', 'https://images.pokemontcg.io/ex12/12_hires.png', 'darkness'),
    (13, 'Victreebel', 'rare', 'https://images.pokemontcg.io/ex12/13_hires.png', 'grass'),
    (14, 'Wailord', 'rare', 'https://images.pokemontcg.io/ex12/14_hires.png', 'water'),
    (15, 'Absol', 'rare', 'https://images.pokemontcg.io/ex12/15_hires.png', 'darkness'),
    (16, 'Girafarig', 'rare', 'https://images.pokemontcg.io/ex12/16_hires.png', 'psychic'),
    (17, 'Gorebyss', 'rare', 'https://images.pokemontcg.io/ex12/17_hires.png', 'water'),
    (18, 'Huntail', 'rare', 'https://images.pokemontcg.io/ex12/18_hires.png', 'water'),
    (19, 'Lanturn', 'rare', 'https://images.pokemontcg.io/ex12/19_hires.png', 'lightning'),
    (20, 'Lunatone', 'rare', 'https://images.pokemontcg.io/ex12/20_hires.png', 'psychic'),
    (21, 'Magmar', 'rare', 'https://images.pokemontcg.io/ex12/21_hires.png', 'fire'),
    (22, 'Magneton', 'rare', 'https://images.pokemontcg.io/ex12/22_hires.png', 'lightning'),
    (23, 'Omastar', 'rare', 'https://images.pokemontcg.io/ex12/23_hires.png', 'water'),
    (24, 'Pinsir', 'rare', 'https://images.pokemontcg.io/ex12/24_hires.png', 'grass'),
    (25, 'Solrock', 'rare', 'https://images.pokemontcg.io/ex12/25_hires.png', 'fighting'),
    (26, 'Spinda', 'rare', 'https://images.pokemontcg.io/ex12/26_hires.png', 'colorless'),
    (27, 'Torkoal', 'rare', 'https://images.pokemontcg.io/ex12/27_hires.png', 'fire'),
    (28, 'Wobbuffet', 'rare', 'https://images.pokemontcg.io/ex12/28_hires.png', 'psychic'),
    (29, 'Anorith', 'common', 'https://images.pokemontcg.io/ex12/29_hires.png', 'fighting'),
    (30, 'Cascoon', 'common', 'https://images.pokemontcg.io/ex12/30_hires.png', 'grass'),
    (31, 'Dunsparce', 'common', 'https://images.pokemontcg.io/ex12/31_hires.png', 'colorless'),
    (32, 'Electrode', 'common', 'https://images.pokemontcg.io/ex12/32_hires.png', 'lightning'),
    (33, 'Furret', 'common', 'https://images.pokemontcg.io/ex12/33_hires.png', 'colorless'),
    (34, 'Graveler', 'common', 'https://images.pokemontcg.io/ex12/34_hires.png', 'fighting'),
    (35, 'Haunter', 'common', 'https://images.pokemontcg.io/ex12/35_hires.png', 'psychic'),
    (36, 'Kabuto', 'common', 'https://images.pokemontcg.io/ex12/36_hires.png', 'fighting'),
    (37, 'Kecleon', 'common', 'https://images.pokemontcg.io/ex12/37_hires.png', 'colorless'),
    (38, 'Lairon', 'common', 'https://images.pokemontcg.io/ex12/38_hires.png', 'metal'),
    (39, 'Machoke', 'common', 'https://images.pokemontcg.io/ex12/39_hires.png', 'fighting'),
    (40, 'Misdreavus', 'common', 'https://images.pokemontcg.io/ex12/40_hires.png', 'psychic'),
    (41, 'Nuzleaf', 'common', 'https://images.pokemontcg.io/ex12/41_hires.png', 'darkness'),
    (42, 'Roselia', 'common', 'https://images.pokemontcg.io/ex12/42_hires.png', 'grass'),
    (43, 'Sealeo', 'common', 'https://images.pokemontcg.io/ex12/43_hires.png', 'water'),
    (44, 'Tangela', 'common', 'https://images.pokemontcg.io/ex12/44_hires.png', 'grass'),
    (45, 'Tentacruel', 'common', 'https://images.pokemontcg.io/ex12/45_hires.png', 'water'),
    (46, 'Vibrava', 'common', 'https://images.pokemontcg.io/ex12/46_hires.png', 'colorless'),
    (47, 'Weepinbell', 'common', 'https://images.pokemontcg.io/ex12/47_hires.png', 'grass'),
    (48, 'Aron', 'common', 'https://images.pokemontcg.io/ex12/48_hires.png', 'metal'),
    (49, 'Bellsprout', 'common', 'https://images.pokemontcg.io/ex12/49_hires.png', 'grass'),
    (50, 'Chinchou', 'common', 'https://images.pokemontcg.io/ex12/50_hires.png', 'lightning'),
    (51, 'Clamperl', 'common', 'https://images.pokemontcg.io/ex12/51_hires.png', 'water'),
    (52, 'Gastly', 'common', 'https://images.pokemontcg.io/ex12/52_hires.png', 'psychic'),
    (53, 'Geodude', 'common', 'https://images.pokemontcg.io/ex12/53_hires.png', 'fighting'),
    (54, 'Grimer', 'common', 'https://images.pokemontcg.io/ex12/54_hires.png', 'grass'),
    (55, 'Growlithe', 'common', 'https://images.pokemontcg.io/ex12/55_hires.png', 'fire'),
    (56, 'Lileep', 'common', 'https://images.pokemontcg.io/ex12/56_hires.png', 'grass'),
    (57, 'Machop', 'common', 'https://images.pokemontcg.io/ex12/57_hires.png', 'fighting'),
    (58, 'Magby', 'common', 'https://images.pokemontcg.io/ex12/58_hires.png', 'fire'),
    (59, 'Magnemite', 'common', 'https://images.pokemontcg.io/ex12/59_hires.png', 'lightning'),
    (60, 'Omanyte', 'common', 'https://images.pokemontcg.io/ex12/60_hires.png', 'water'),
    (61, 'Seedot', 'common', 'https://images.pokemontcg.io/ex12/61_hires.png', 'grass'),
    (62, 'Sentret', 'common', 'https://images.pokemontcg.io/ex12/62_hires.png', 'colorless'),
    (63, 'Shuppet', 'common', 'https://images.pokemontcg.io/ex12/63_hires.png', 'psychic'),
    (64, 'Skitty', 'common', 'https://images.pokemontcg.io/ex12/64_hires.png', 'colorless'),
    (65, 'Spheal', 'common', 'https://images.pokemontcg.io/ex12/65_hires.png', 'water'),
    (66, 'Tentacool', 'common', 'https://images.pokemontcg.io/ex12/66_hires.png', 'water'),
    (67, 'Trapinch', 'common', 'https://images.pokemontcg.io/ex12/67_hires.png', 'fighting'),
    (68, 'Voltorb', 'common', 'https://images.pokemontcg.io/ex12/68_hires.png', 'lightning'),
    (69, 'Wailmer', 'common', 'https://images.pokemontcg.io/ex12/69_hires.png', 'water'),
    (70, 'Wurmple', 'common', 'https://images.pokemontcg.io/ex12/70_hires.png', 'grass'),
    (71, 'Wynaut', 'common', 'https://images.pokemontcg.io/ex12/71_hires.png', 'psychic'),
    (72, 'Cursed Stone', 'common', 'https://images.pokemontcg.io/ex12/72_hires.png', NULL),
    (73, 'Fieldworker', 'common', 'https://images.pokemontcg.io/ex12/73_hires.png', NULL),
    (74, 'Full Flame', 'common', 'https://images.pokemontcg.io/ex12/74_hires.png', NULL),
    (75, 'Giant Stump', 'common', 'https://images.pokemontcg.io/ex12/75_hires.png', NULL),
    (76, 'Power Tree', 'common', 'https://images.pokemontcg.io/ex12/76_hires.png', NULL),
    (77, 'Strange Cave', 'common', 'https://images.pokemontcg.io/ex12/77_hires.png', NULL),
    (78, 'Claw Fossil', 'common', 'https://images.pokemontcg.io/ex12/78_hires.png', NULL),
    (79, 'Mysterious Fossil', 'common', 'https://images.pokemontcg.io/ex12/79_hires.png', NULL),
    (80, 'Root Fossil', 'common', 'https://images.pokemontcg.io/ex12/80_hires.png', NULL),
    (81, 'Rainbow Energy', 'rare', 'https://images.pokemontcg.io/ex12/81_hires.png', NULL),
    (82, 'React Energy', 'common', 'https://images.pokemontcg.io/ex12/82_hires.png', NULL),
    (83, 'Arcanine ex', 'double_rare', 'https://images.pokemontcg.io/ex12/83_hires.png', 'fire'),
    (84, 'Armaldo ex', 'double_rare', 'https://images.pokemontcg.io/ex12/84_hires.png', 'fighting'),
    (85, 'Banette ex', 'double_rare', 'https://images.pokemontcg.io/ex12/85_hires.png', 'psychic'),
    (86, 'Dustox ex', 'double_rare', 'https://images.pokemontcg.io/ex12/86_hires.png', 'grass'),
    (87, 'Flygon ex', 'double_rare', 'https://images.pokemontcg.io/ex12/87_hires.png', 'colorless'),
    (88, 'Mew ex', 'double_rare', 'https://images.pokemontcg.io/ex12/88_hires.png', 'psychic'),
    (89, 'Walrein ex', 'double_rare', 'https://images.pokemontcg.io/ex12/89_hires.png', 'water'),
    (90, 'Regice ★', 'ultra_rare', 'https://images.pokemontcg.io/ex12/90_hires.png', 'water'),
    (91, 'Regirock ★', 'ultra_rare', 'https://images.pokemontcg.io/ex12/91_hires.png', 'fighting'),
    (92, 'Registeel ★', 'ultra_rare', 'https://images.pokemontcg.io/ex12/92_hires.png', 'metal'),
    (93, 'Pikachu δ', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex12/93_hires.png', 'metal')
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

-- Set: EX Trainer Kit 2 Plusle (tk2a) -- 2006/03/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'ex-trainer-kit-2-plusle', 'EX Trainer Kit 2 Plusle', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'ex-trainer-kit-2-plusle'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Beldum', 'base', 'https://images.pokemontcg.io/tk2a/1_hires.png', 'psychic'),
    (2, 'Electrike', 'base', 'https://images.pokemontcg.io/tk2a/2_hires.png', 'lightning'),
    (3, 'Grumpig', 'base', 'https://images.pokemontcg.io/tk2a/3_hires.png', 'psychic'),
    (4, 'Meowth', 'base', 'https://images.pokemontcg.io/tk2a/4_hires.png', 'colorless'),
    (5, 'Metang', 'base', 'https://images.pokemontcg.io/tk2a/5_hires.png', 'psychic'),
    (6, 'Plusle', 'base', 'https://images.pokemontcg.io/tk2a/6_hires.png', 'lightning'),
    (7, 'Spoink', 'base', 'https://images.pokemontcg.io/tk2a/7_hires.png', 'psychic'),
    (8, 'Energy Search', 'base', 'https://images.pokemontcg.io/tk2a/8_hires.png', NULL),
    (9, 'Potion', 'base', 'https://images.pokemontcg.io/tk2a/9_hires.png', NULL),
    (10, 'Professor Cozmo''s Discovery', 'base', 'https://images.pokemontcg.io/tk2a/10_hires.png', NULL),
    (11, 'Lightning Energy', 'base', 'https://images.pokemontcg.io/tk2a/11_hires.png', NULL),
    (12, 'Psychic Energy', 'base', 'https://images.pokemontcg.io/tk2a/12_hires.png', NULL)
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

-- Set: EX Trainer Kit 2 Minun (tk2b) -- 2006/03/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'ex-trainer-kit-2-minun', 'EX Trainer Kit 2 Minun', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'ex-trainer-kit-2-minun'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Arcanine', 'base', 'https://images.pokemontcg.io/tk2b/1_hires.png', 'fire'),
    (2, 'Charmander', 'base', 'https://images.pokemontcg.io/tk2b/2_hires.png', 'fire'),
    (3, 'Charmeleon', 'common', 'https://images.pokemontcg.io/tk2b/3_hires.png', 'fire'),
    (4, 'Growlithe', 'base', 'https://images.pokemontcg.io/tk2b/4_hires.png', 'fire'),
    (5, 'Mareep', 'base', 'https://images.pokemontcg.io/tk2b/5_hires.png', 'lightning'),
    (6, 'Minun', 'base', 'https://images.pokemontcg.io/tk2b/6_hires.png', 'lightning'),
    (7, 'Vulpix', 'base', 'https://images.pokemontcg.io/tk2b/7_hires.png', 'fire'),
    (8, 'Celio''s Network', 'base', 'https://images.pokemontcg.io/tk2b/8_hires.png', NULL),
    (9, 'Energy Search', 'base', 'https://images.pokemontcg.io/tk2b/9_hires.png', NULL),
    (10, 'Potion', 'base', 'https://images.pokemontcg.io/tk2b/10_hires.png', NULL),
    (11, 'Fire Energy', 'base', 'https://images.pokemontcg.io/tk2b/11_hires.png', NULL),
    (12, 'Lightning Energy', 'base', 'https://images.pokemontcg.io/tk2b/12_hires.png', NULL)
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

-- Set: Holon Phantoms (ex13) -- 2006/05/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'holon-phantoms', 'Holon Phantoms', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'holon-phantoms'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Armaldo δ', 'rare', 'https://images.pokemontcg.io/ex13/1_hires.png', 'fighting'),
    (2, 'Cradily δ', 'rare', 'https://images.pokemontcg.io/ex13/2_hires.png', 'darkness'),
    (3, 'Deoxys δ', 'rare', 'https://images.pokemontcg.io/ex13/3_hires.png', 'darkness'),
    (4, 'Deoxys δ', 'rare', 'https://images.pokemontcg.io/ex13/4_hires.png', 'metal'),
    (5, 'Deoxys δ', 'rare', 'https://images.pokemontcg.io/ex13/5_hires.png', 'colorless'),
    (6, 'Deoxys δ', 'rare', 'https://images.pokemontcg.io/ex13/6_hires.png', 'lightning'),
    (7, 'Flygon δ', 'rare', 'https://images.pokemontcg.io/ex13/7_hires.png', 'grass'),
    (8, 'Gyarados δ', 'rare', 'https://images.pokemontcg.io/ex13/8_hires.png', 'lightning'),
    (9, 'Kabutops δ', 'rare', 'https://images.pokemontcg.io/ex13/9_hires.png', 'lightning'),
    (10, 'Kingdra δ', 'rare', 'https://images.pokemontcg.io/ex13/10_hires.png', 'fire'),
    (11, 'Latias δ', 'rare', 'https://images.pokemontcg.io/ex13/11_hires.png', 'fire'),
    (12, 'Latios δ', 'rare', 'https://images.pokemontcg.io/ex13/12_hires.png', 'water'),
    (13, 'Omastar δ', 'rare', 'https://images.pokemontcg.io/ex13/13_hires.png', 'psychic'),
    (14, 'Pidgeot δ', 'rare', 'https://images.pokemontcg.io/ex13/14_hires.png', 'lightning'),
    (15, 'Raichu δ', 'rare', 'https://images.pokemontcg.io/ex13/15_hires.png', 'metal'),
    (16, 'Rayquaza δ', 'rare', 'https://images.pokemontcg.io/ex13/16_hires.png', 'water'),
    (17, 'Vileplume δ', 'rare', 'https://images.pokemontcg.io/ex13/17_hires.png', 'psychic'),
    (18, 'Absol', 'rare', 'https://images.pokemontcg.io/ex13/18_hires.png', 'darkness'),
    (19, 'Bellossom δ', 'rare', 'https://images.pokemontcg.io/ex13/19_hires.png', 'water'),
    (20, 'Blaziken', 'rare', 'https://images.pokemontcg.io/ex13/20_hires.png', 'fire'),
    (21, 'Latias δ', 'rare', 'https://images.pokemontcg.io/ex13/21_hires.png', 'fire'),
    (22, 'Latios δ', 'rare', 'https://images.pokemontcg.io/ex13/22_hires.png', 'water'),
    (23, 'Mawile', 'rare', 'https://images.pokemontcg.io/ex13/23_hires.png', 'metal'),
    (24, 'Mewtwo δ', 'rare', 'https://images.pokemontcg.io/ex13/24_hires.png', 'lightning'),
    (25, 'Nosepass', 'rare', 'https://images.pokemontcg.io/ex13/25_hires.png', 'fighting'),
    (26, 'Rayquaza δ', 'rare', 'https://images.pokemontcg.io/ex13/26_hires.png', 'fire'),
    (27, 'Regice', 'rare', 'https://images.pokemontcg.io/ex13/27_hires.png', 'water'),
    (28, 'Regirock', 'rare', 'https://images.pokemontcg.io/ex13/28_hires.png', 'fighting'),
    (29, 'Registeel', 'rare', 'https://images.pokemontcg.io/ex13/29_hires.png', 'metal'),
    (30, 'Relicanth', 'rare', 'https://images.pokemontcg.io/ex13/30_hires.png', 'water'),
    (31, 'Sableye', 'rare', 'https://images.pokemontcg.io/ex13/31_hires.png', 'darkness'),
    (32, 'Seviper', 'rare', 'https://images.pokemontcg.io/ex13/32_hires.png', 'grass'),
    (33, 'Torkoal', 'rare', 'https://images.pokemontcg.io/ex13/33_hires.png', 'fire'),
    (34, 'Zangoose', 'rare', 'https://images.pokemontcg.io/ex13/34_hires.png', 'colorless'),
    (35, 'Aerodactyl δ', 'common', 'https://images.pokemontcg.io/ex13/35_hires.png', 'fire'),
    (36, 'Camerupt', 'common', 'https://images.pokemontcg.io/ex13/36_hires.png', 'fire'),
    (37, 'Chimecho δ', 'common', 'https://images.pokemontcg.io/ex13/37_hires.png', 'metal'),
    (38, 'Claydol', 'common', 'https://images.pokemontcg.io/ex13/38_hires.png', 'psychic'),
    (39, 'Combusken', 'common', 'https://images.pokemontcg.io/ex13/39_hires.png', 'fire'),
    (40, 'Donphan', 'common', 'https://images.pokemontcg.io/ex13/40_hires.png', 'fighting'),
    (41, 'Exeggutor δ', 'common', 'https://images.pokemontcg.io/ex13/41_hires.png', 'fighting'),
    (42, 'Gloom δ', 'common', 'https://images.pokemontcg.io/ex13/42_hires.png', 'psychic'),
    (43, 'Golduck δ', 'common', 'https://images.pokemontcg.io/ex13/43_hires.png', 'lightning'),
    (44, 'Holon''s Castform', 'common', 'https://images.pokemontcg.io/ex13/44_hires.png', 'colorless'),
    (45, 'Lairon', 'common', 'https://images.pokemontcg.io/ex13/45_hires.png', 'metal'),
    (46, 'Manectric', 'common', 'https://images.pokemontcg.io/ex13/46_hires.png', 'lightning'),
    (47, 'Masquerain', 'common', 'https://images.pokemontcg.io/ex13/47_hires.png', 'grass'),
    (48, 'Persian δ', 'common', 'https://images.pokemontcg.io/ex13/48_hires.png', 'darkness'),
    (49, 'Pidgeotto δ', 'common', 'https://images.pokemontcg.io/ex13/49_hires.png', 'lightning'),
    (50, 'Primeape δ', 'common', 'https://images.pokemontcg.io/ex13/50_hires.png', 'fire'),
    (51, 'Raichu', 'common', 'https://images.pokemontcg.io/ex13/51_hires.png', 'lightning'),
    (52, 'Seadra δ', 'common', 'https://images.pokemontcg.io/ex13/52_hires.png', 'fire'),
    (53, 'Sharpedo δ', 'common', 'https://images.pokemontcg.io/ex13/53_hires.png', 'fighting'),
    (54, 'Vibrava δ', 'common', 'https://images.pokemontcg.io/ex13/54_hires.png', 'grass'),
    (55, 'Whiscash', 'common', 'https://images.pokemontcg.io/ex13/55_hires.png', 'fighting'),
    (56, 'Wobbuffet', 'common', 'https://images.pokemontcg.io/ex13/56_hires.png', 'psychic'),
    (57, 'Anorith δ', 'common', 'https://images.pokemontcg.io/ex13/57_hires.png', 'metal'),
    (58, 'Aron', 'common', 'https://images.pokemontcg.io/ex13/58_hires.png', 'metal'),
    (59, 'Baltoy', 'common', 'https://images.pokemontcg.io/ex13/59_hires.png', 'psychic'),
    (60, 'Barboach', 'common', 'https://images.pokemontcg.io/ex13/60_hires.png', 'fighting'),
    (61, 'Carvanha δ', 'common', 'https://images.pokemontcg.io/ex13/61_hires.png', 'fighting'),
    (62, 'Corphish', 'common', 'https://images.pokemontcg.io/ex13/62_hires.png', 'water'),
    (63, 'Corphish', 'common', 'https://images.pokemontcg.io/ex13/63_hires.png', 'water'),
    (64, 'Electrike', 'common', 'https://images.pokemontcg.io/ex13/64_hires.png', 'lightning'),
    (65, 'Exeggcute δ', 'common', 'https://images.pokemontcg.io/ex13/65_hires.png', 'fighting'),
    (66, 'Horsea δ', 'common', 'https://images.pokemontcg.io/ex13/66_hires.png', 'fire'),
    (67, 'Kabuto δ', 'common', 'https://images.pokemontcg.io/ex13/67_hires.png', 'lightning'),
    (68, 'Lileep δ', 'common', 'https://images.pokemontcg.io/ex13/68_hires.png', 'darkness'),
    (69, 'Magikarp δ', 'common', 'https://images.pokemontcg.io/ex13/69_hires.png', 'metal'),
    (70, 'Mankey δ', 'common', 'https://images.pokemontcg.io/ex13/70_hires.png', 'fire'),
    (71, 'Meowth δ', 'common', 'https://images.pokemontcg.io/ex13/71_hires.png', 'darkness'),
    (72, 'Numel', 'common', 'https://images.pokemontcg.io/ex13/72_hires.png', 'fire'),
    (73, 'Oddish δ', 'common', 'https://images.pokemontcg.io/ex13/73_hires.png', 'water'),
    (74, 'Omanyte δ', 'common', 'https://images.pokemontcg.io/ex13/74_hires.png', 'psychic'),
    (75, 'Phanpy', 'common', 'https://images.pokemontcg.io/ex13/75_hires.png', 'fighting'),
    (76, 'Pichu δ', 'common', 'https://images.pokemontcg.io/ex13/76_hires.png', 'metal'),
    (77, 'Pidgey δ', 'common', 'https://images.pokemontcg.io/ex13/77_hires.png', 'lightning'),
    (78, 'Pikachu', 'common', 'https://images.pokemontcg.io/ex13/78_hires.png', 'lightning'),
    (79, 'Pikachu δ', 'common', 'https://images.pokemontcg.io/ex13/79_hires.png', 'metal'),
    (80, 'Poochyena', 'common', 'https://images.pokemontcg.io/ex13/80_hires.png', 'darkness'),
    (81, 'Psyduck δ', 'common', 'https://images.pokemontcg.io/ex13/81_hires.png', 'lightning'),
    (82, 'Surskit', 'common', 'https://images.pokemontcg.io/ex13/82_hires.png', 'grass'),
    (83, 'Torchic', 'common', 'https://images.pokemontcg.io/ex13/83_hires.png', 'fire'),
    (84, 'Trapinch δ', 'common', 'https://images.pokemontcg.io/ex13/84_hires.png', 'grass'),
    (85, 'Holon Adventurer', 'common', 'https://images.pokemontcg.io/ex13/85_hires.png', NULL),
    (86, 'Holon Fossil', 'common', 'https://images.pokemontcg.io/ex13/86_hires.png', NULL),
    (87, 'Holon Lake', 'common', 'https://images.pokemontcg.io/ex13/87_hires.png', NULL),
    (88, 'Mr. Stone''s Project', 'common', 'https://images.pokemontcg.io/ex13/88_hires.png', NULL),
    (89, 'Professor Cozmo''s Discovery', 'common', 'https://images.pokemontcg.io/ex13/89_hires.png', NULL),
    (90, 'Rare Candy', 'common', 'https://images.pokemontcg.io/ex13/90_hires.png', NULL),
    (91, 'Claw Fossil', 'common', 'https://images.pokemontcg.io/ex13/91_hires.png', NULL),
    (92, 'Mysterious Fossil', 'common', 'https://images.pokemontcg.io/ex13/92_hires.png', NULL),
    (93, 'Root Fossil', 'common', 'https://images.pokemontcg.io/ex13/93_hires.png', NULL),
    (94, 'Darkness Energy', 'rare', 'https://images.pokemontcg.io/ex13/94_hires.png', NULL),
    (95, 'Metal Energy', 'rare', 'https://images.pokemontcg.io/ex13/95_hires.png', NULL),
    (96, 'Multi Energy', 'rare', 'https://images.pokemontcg.io/ex13/96_hires.png', NULL),
    (97, 'Dark Metal Energy', 'common', 'https://images.pokemontcg.io/ex13/97_hires.png', NULL),
    (98, 'δ Rainbow Energy', 'common', 'https://images.pokemontcg.io/ex13/98_hires.png', NULL),
    (99, 'Crawdaunt ex', 'double_rare', 'https://images.pokemontcg.io/ex13/99_hires.png', 'water'),
    (100, 'Mew ex', 'double_rare', 'https://images.pokemontcg.io/ex13/100_hires.png', 'psychic'),
    (101, 'Mightyena ex', 'double_rare', 'https://images.pokemontcg.io/ex13/101_hires.png', 'darkness'),
    (102, 'Gyarados ★ δ', 'ultra_rare', 'https://images.pokemontcg.io/ex13/102_hires.png', 'fire'),
    (103, 'Mewtwo ★', 'ultra_rare', 'https://images.pokemontcg.io/ex13/103_hires.png', 'psychic'),
    (104, 'Pikachu ★', 'ultra_rare', 'https://images.pokemontcg.io/ex13/104_hires.png', 'lightning'),
    (105, 'Grass Energy', 'rare', 'https://images.pokemontcg.io/ex13/105_hires.png', NULL),
    (106, 'Fire Energy', 'rare', 'https://images.pokemontcg.io/ex13/106_hires.png', NULL),
    (107, 'Water Energy', 'rare', 'https://images.pokemontcg.io/ex13/107_hires.png', NULL),
    (108, 'Lightning Energy', 'rare', 'https://images.pokemontcg.io/ex13/108_hires.png', NULL),
    (109, 'Psychic Energy', 'rare', 'https://images.pokemontcg.io/ex13/109_hires.png', NULL),
    (110, 'Fighting Energy', 'rare', 'https://images.pokemontcg.io/ex13/110_hires.png', NULL),
    (111, 'Mew', 'mega_hyper_rare', 'https://images.pokemontcg.io/ex13/111_hires.png', 'psychic')
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

-- Set: Crystal Guardians (ex14) -- 2006/08/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'crystal-guardians', 'Crystal Guardians', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'crystal-guardians'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Banette', 'rare', 'https://images.pokemontcg.io/ex14/1_hires.png', 'psychic'),
    (2, 'Blastoise δ', 'rare', 'https://images.pokemontcg.io/ex14/2_hires.png', 'fighting'),
    (3, 'Camerupt', 'rare', 'https://images.pokemontcg.io/ex14/3_hires.png', 'fire'),
    (4, 'Charizard δ', 'rare', 'https://images.pokemontcg.io/ex14/4_hires.png', 'lightning'),
    (5, 'Dugtrio', 'rare', 'https://images.pokemontcg.io/ex14/5_hires.png', 'fighting'),
    (6, 'Ludicolo δ', 'rare', 'https://images.pokemontcg.io/ex14/6_hires.png', 'fire'),
    (7, 'Luvdisc', 'rare', 'https://images.pokemontcg.io/ex14/7_hires.png', 'water'),
    (8, 'Manectric', 'rare', 'https://images.pokemontcg.io/ex14/8_hires.png', 'lightning'),
    (9, 'Mawile', 'rare', 'https://images.pokemontcg.io/ex14/9_hires.png', 'metal'),
    (10, 'Sableye', 'rare', 'https://images.pokemontcg.io/ex14/10_hires.png', 'darkness'),
    (11, 'Swalot', 'rare', 'https://images.pokemontcg.io/ex14/11_hires.png', 'grass'),
    (12, 'Tauros', 'rare', 'https://images.pokemontcg.io/ex14/12_hires.png', 'colorless'),
    (13, 'Wigglytuff', 'rare', 'https://images.pokemontcg.io/ex14/13_hires.png', 'colorless'),
    (14, 'Blastoise', 'rare', 'https://images.pokemontcg.io/ex14/14_hires.png', 'water'),
    (15, 'Cacturne δ', 'rare', 'https://images.pokemontcg.io/ex14/15_hires.png', 'fighting'),
    (16, 'Combusken', 'rare', 'https://images.pokemontcg.io/ex14/16_hires.png', 'fighting'),
    (17, 'Dusclops', 'rare', 'https://images.pokemontcg.io/ex14/17_hires.png', 'psychic'),
    (18, 'Fearow δ', 'rare', 'https://images.pokemontcg.io/ex14/18_hires.png', 'lightning'),
    (19, 'Grovyle δ', 'rare', 'https://images.pokemontcg.io/ex14/19_hires.png', 'psychic'),
    (20, 'Grumpig', 'rare', 'https://images.pokemontcg.io/ex14/20_hires.png', 'psychic'),
    (21, 'Igglybuff', 'rare', 'https://images.pokemontcg.io/ex14/21_hires.png', 'colorless'),
    (22, 'Kingler δ', 'rare', 'https://images.pokemontcg.io/ex14/22_hires.png', 'fire'),
    (23, 'Loudred', 'rare', 'https://images.pokemontcg.io/ex14/23_hires.png', 'colorless'),
    (24, 'Marshtomp', 'rare', 'https://images.pokemontcg.io/ex14/24_hires.png', 'water'),
    (25, 'Medicham', 'rare', 'https://images.pokemontcg.io/ex14/25_hires.png', 'fighting'),
    (26, 'Pelipper δ', 'rare', 'https://images.pokemontcg.io/ex14/26_hires.png', 'lightning'),
    (27, 'Swampert', 'rare', 'https://images.pokemontcg.io/ex14/27_hires.png', 'fighting'),
    (28, 'Venusaur', 'rare', 'https://images.pokemontcg.io/ex14/28_hires.png', 'grass'),
    (29, 'Charmeleon', 'common', 'https://images.pokemontcg.io/ex14/29_hires.png', 'fire'),
    (30, 'Charmeleon δ', 'common', 'https://images.pokemontcg.io/ex14/30_hires.png', 'lightning'),
    (31, 'Combusken', 'common', 'https://images.pokemontcg.io/ex14/31_hires.png', 'fire'),
    (32, 'Grovyle', 'common', 'https://images.pokemontcg.io/ex14/32_hires.png', 'grass'),
    (33, 'Gulpin', 'common', 'https://images.pokemontcg.io/ex14/33_hires.png', 'grass'),
    (34, 'Ivysaur', 'common', 'https://images.pokemontcg.io/ex14/34_hires.png', 'grass'),
    (35, 'Ivysaur', 'common', 'https://images.pokemontcg.io/ex14/35_hires.png', 'grass'),
    (36, 'Lairon', 'common', 'https://images.pokemontcg.io/ex14/36_hires.png', 'metal'),
    (37, 'Lombre', 'common', 'https://images.pokemontcg.io/ex14/37_hires.png', 'water'),
    (38, 'Marshtomp', 'common', 'https://images.pokemontcg.io/ex14/38_hires.png', 'fighting'),
    (39, 'Nuzleaf', 'common', 'https://images.pokemontcg.io/ex14/39_hires.png', 'darkness'),
    (40, 'Shuppet', 'common', 'https://images.pokemontcg.io/ex14/40_hires.png', 'psychic'),
    (41, 'Skitty', 'common', 'https://images.pokemontcg.io/ex14/41_hires.png', 'colorless'),
    (42, 'Wartortle', 'common', 'https://images.pokemontcg.io/ex14/42_hires.png', 'water'),
    (43, 'Wartortle', 'common', 'https://images.pokemontcg.io/ex14/43_hires.png', 'water'),
    (44, 'Aron', 'common', 'https://images.pokemontcg.io/ex14/44_hires.png', 'metal'),
    (45, 'Bulbasaur', 'common', 'https://images.pokemontcg.io/ex14/45_hires.png', 'grass'),
    (46, 'Bulbasaur', 'common', 'https://images.pokemontcg.io/ex14/46_hires.png', 'grass'),
    (47, 'Cacnea', 'common', 'https://images.pokemontcg.io/ex14/47_hires.png', 'grass'),
    (48, 'Charmander', 'common', 'https://images.pokemontcg.io/ex14/48_hires.png', 'fire'),
    (49, 'Charmander δ', 'common', 'https://images.pokemontcg.io/ex14/49_hires.png', 'lightning'),
    (50, 'Diglett', 'common', 'https://images.pokemontcg.io/ex14/50_hires.png', 'fighting'),
    (51, 'Duskull', 'common', 'https://images.pokemontcg.io/ex14/51_hires.png', 'psychic'),
    (52, 'Electrike', 'common', 'https://images.pokemontcg.io/ex14/52_hires.png', 'lightning'),
    (53, 'Jigglypuff', 'common', 'https://images.pokemontcg.io/ex14/53_hires.png', 'colorless'),
    (54, 'Krabby', 'common', 'https://images.pokemontcg.io/ex14/54_hires.png', 'water'),
    (55, 'Lotad', 'common', 'https://images.pokemontcg.io/ex14/55_hires.png', 'water'),
    (56, 'Meditite', 'common', 'https://images.pokemontcg.io/ex14/56_hires.png', 'fighting'),
    (57, 'Mudkip', 'common', 'https://images.pokemontcg.io/ex14/57_hires.png', 'water'),
    (58, 'Mudkip', 'common', 'https://images.pokemontcg.io/ex14/58_hires.png', 'water'),
    (59, 'Numel', 'common', 'https://images.pokemontcg.io/ex14/59_hires.png', 'fire'),
    (60, 'Seedot', 'common', 'https://images.pokemontcg.io/ex14/60_hires.png', 'grass'),
    (61, 'Spearow', 'common', 'https://images.pokemontcg.io/ex14/61_hires.png', 'colorless'),
    (62, 'Spoink', 'common', 'https://images.pokemontcg.io/ex14/62_hires.png', 'psychic'),
    (63, 'Squirtle', 'common', 'https://images.pokemontcg.io/ex14/63_hires.png', 'water'),
    (64, 'Squirtle', 'common', 'https://images.pokemontcg.io/ex14/64_hires.png', 'water'),
    (65, 'Torchic', 'common', 'https://images.pokemontcg.io/ex14/65_hires.png', 'fire'),
    (66, 'Torchic', 'common', 'https://images.pokemontcg.io/ex14/66_hires.png', 'fire'),
    (67, 'Treecko', 'common', 'https://images.pokemontcg.io/ex14/67_hires.png', 'grass'),
    (68, 'Treecko δ', 'common', 'https://images.pokemontcg.io/ex14/68_hires.png', 'psychic'),
    (69, 'Whismur', 'common', 'https://images.pokemontcg.io/ex14/69_hires.png', 'colorless'),
    (70, 'Wingull', 'common', 'https://images.pokemontcg.io/ex14/70_hires.png', 'water'),
    (71, 'Bill''s Maintenance', 'common', 'https://images.pokemontcg.io/ex14/71_hires.png', NULL),
    (72, 'Castaway', 'common', 'https://images.pokemontcg.io/ex14/72_hires.png', NULL),
    (73, 'Celio''s Network', 'common', 'https://images.pokemontcg.io/ex14/73_hires.png', NULL),
    (74, 'Cessation Crystal', 'common', 'https://images.pokemontcg.io/ex14/74_hires.png', NULL),
    (75, 'Crystal Beach', 'common', 'https://images.pokemontcg.io/ex14/75_hires.png', NULL),
    (76, 'Crystal Shard', 'common', 'https://images.pokemontcg.io/ex14/76_hires.png', NULL),
    (77, 'Double Full Heal', 'common', 'https://images.pokemontcg.io/ex14/77_hires.png', NULL),
    (78, 'Dual Ball', 'common', 'https://images.pokemontcg.io/ex14/78_hires.png', NULL),
    (79, 'Holon Circle', 'common', 'https://images.pokemontcg.io/ex14/79_hires.png', NULL),
    (80, 'Memory Berry', 'common', 'https://images.pokemontcg.io/ex14/80_hires.png', NULL),
    (81, 'Mysterious Shard', 'common', 'https://images.pokemontcg.io/ex14/81_hires.png', NULL),
    (82, 'Poké Ball', 'common', 'https://images.pokemontcg.io/ex14/82_hires.png', NULL),
    (83, 'PokéNav', 'common', 'https://images.pokemontcg.io/ex14/83_hires.png', NULL),
    (84, 'Warp Point', 'common', 'https://images.pokemontcg.io/ex14/84_hires.png', NULL),
    (85, 'Windstorm', 'common', 'https://images.pokemontcg.io/ex14/85_hires.png', NULL),
    (86, 'Energy Search', 'common', 'https://images.pokemontcg.io/ex14/86_hires.png', NULL),
    (87, 'Potion', 'common', 'https://images.pokemontcg.io/ex14/87_hires.png', NULL),
    (88, 'Double Rainbow Energy', 'rare', 'https://images.pokemontcg.io/ex14/88_hires.png', NULL),
    (89, 'Aggron ex', 'double_rare', 'https://images.pokemontcg.io/ex14/89_hires.png', 'metal'),
    (90, 'Blaziken ex', 'double_rare', 'https://images.pokemontcg.io/ex14/90_hires.png', 'fighting'),
    (91, 'Delcatty ex', 'double_rare', 'https://images.pokemontcg.io/ex14/91_hires.png', 'colorless'),
    (92, 'Exploud ex', 'double_rare', 'https://images.pokemontcg.io/ex14/92_hires.png', 'colorless'),
    (93, 'Groudon ex', 'double_rare', 'https://images.pokemontcg.io/ex14/93_hires.png', 'fighting'),
    (94, 'Jirachi ex', 'double_rare', 'https://images.pokemontcg.io/ex14/94_hires.png', 'psychic'),
    (95, 'Kyogre ex', 'double_rare', 'https://images.pokemontcg.io/ex14/95_hires.png', 'water'),
    (96, 'Sceptile ex δ', 'double_rare', 'https://images.pokemontcg.io/ex14/96_hires.png', 'psychic'),
    (97, 'Shiftry ex', 'double_rare', 'https://images.pokemontcg.io/ex14/97_hires.png', 'darkness'),
    (98, 'Swampert ex', 'double_rare', 'https://images.pokemontcg.io/ex14/98_hires.png', 'water'),
    (99, 'Alakazam ★', 'ultra_rare', 'https://images.pokemontcg.io/ex14/99_hires.png', 'psychic'),
    (100, 'Celebi ★', 'ultra_rare', 'https://images.pokemontcg.io/ex14/100_hires.png', 'grass')
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

-- Set: Dragon Frontiers (ex15) -- 2006/11/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'dragon-frontiers', 'Dragon Frontiers', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'dragon-frontiers'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Ampharos δ', 'rare', 'https://images.pokemontcg.io/ex15/1_hires.png', 'colorless'),
    (2, 'Feraligatr δ', 'rare', 'https://images.pokemontcg.io/ex15/2_hires.png', 'lightning'),
    (3, 'Heracross δ', 'rare', 'https://images.pokemontcg.io/ex15/3_hires.png', 'fire'),
    (4, 'Meganium δ', 'rare', 'https://images.pokemontcg.io/ex15/4_hires.png', 'fighting'),
    (5, 'Milotic δ', 'rare', 'https://images.pokemontcg.io/ex15/5_hires.png', 'fire'),
    (6, 'Nidoking δ', 'rare', 'https://images.pokemontcg.io/ex15/6_hires.png', 'darkness'),
    (7, 'Nidoqueen δ', 'rare', 'https://images.pokemontcg.io/ex15/7_hires.png', 'metal'),
    (8, 'Ninetales δ', 'rare', 'https://images.pokemontcg.io/ex15/8_hires.png', 'psychic'),
    (9, 'Pinsir δ', 'rare', 'https://images.pokemontcg.io/ex15/9_hires.png', 'fighting'),
    (10, 'Snorlax δ', 'rare', 'https://images.pokemontcg.io/ex15/10_hires.png', 'grass'),
    (11, 'Togetic δ', 'rare', 'https://images.pokemontcg.io/ex15/11_hires.png', 'water'),
    (12, 'Typhlosion δ', 'rare', 'https://images.pokemontcg.io/ex15/12_hires.png', 'psychic'),
    (13, 'Arbok δ', 'rare', 'https://images.pokemontcg.io/ex15/13_hires.png', 'fire'),
    (14, 'Cloyster δ', 'rare', 'https://images.pokemontcg.io/ex15/14_hires.png', 'fighting'),
    (15, 'Dewgong δ', 'rare', 'https://images.pokemontcg.io/ex15/15_hires.png', 'colorless'),
    (16, 'Gligar δ', 'rare', 'https://images.pokemontcg.io/ex15/16_hires.png', 'lightning'),
    (17, 'Jynx δ', 'rare', 'https://images.pokemontcg.io/ex15/17_hires.png', 'fire'),
    (18, 'Ledian δ', 'rare', 'https://images.pokemontcg.io/ex15/18_hires.png', 'metal'),
    (19, 'Lickitung δ', 'rare', 'https://images.pokemontcg.io/ex15/19_hires.png', 'psychic'),
    (20, 'Mantine δ', 'rare', 'https://images.pokemontcg.io/ex15/20_hires.png', 'lightning'),
    (21, 'Quagsire δ', 'rare', 'https://images.pokemontcg.io/ex15/21_hires.png', 'grass'),
    (22, 'Seadra δ', 'rare', 'https://images.pokemontcg.io/ex15/22_hires.png', 'fighting'),
    (23, 'Tropius δ', 'rare', 'https://images.pokemontcg.io/ex15/23_hires.png', 'metal'),
    (24, 'Vibrava δ', 'rare', 'https://images.pokemontcg.io/ex15/24_hires.png', 'psychic'),
    (25, 'Xatu δ', 'rare', 'https://images.pokemontcg.io/ex15/25_hires.png', 'darkness'),
    (26, 'Bayleef δ', 'common', 'https://images.pokemontcg.io/ex15/26_hires.png', 'fighting'),
    (27, 'Croconaw δ', 'common', 'https://images.pokemontcg.io/ex15/27_hires.png', 'lightning'),
    (28, 'Dragonair δ', 'common', 'https://images.pokemontcg.io/ex15/28_hires.png', 'grass'),
    (29, 'Electabuzz δ', 'common', 'https://images.pokemontcg.io/ex15/29_hires.png', 'fighting'),
    (30, 'Flaaffy δ', 'common', 'https://images.pokemontcg.io/ex15/30_hires.png', 'colorless'),
    (31, 'Horsea δ', 'common', 'https://images.pokemontcg.io/ex15/31_hires.png', 'fighting'),
    (32, 'Kirlia', 'common', 'https://images.pokemontcg.io/ex15/32_hires.png', 'psychic'),
    (33, 'Kirlia δ', 'common', 'https://images.pokemontcg.io/ex15/33_hires.png', 'fire'),
    (34, 'Nidorina δ', 'common', 'https://images.pokemontcg.io/ex15/34_hires.png', 'metal'),
    (35, 'Nidorino δ', 'common', 'https://images.pokemontcg.io/ex15/35_hires.png', 'darkness'),
    (36, 'Quilava δ', 'common', 'https://images.pokemontcg.io/ex15/36_hires.png', 'psychic'),
    (37, 'Seadra δ', 'common', 'https://images.pokemontcg.io/ex15/37_hires.png', 'fighting'),
    (38, 'Shelgon δ', 'common', 'https://images.pokemontcg.io/ex15/38_hires.png', 'water'),
    (39, 'Smeargle δ', 'common', 'https://images.pokemontcg.io/ex15/39_hires.png', 'psychic'),
    (40, 'Swellow δ', 'common', 'https://images.pokemontcg.io/ex15/40_hires.png', 'fire'),
    (41, 'Togepi δ', 'common', 'https://images.pokemontcg.io/ex15/41_hires.png', 'water'),
    (42, 'Vibrava δ', 'common', 'https://images.pokemontcg.io/ex15/42_hires.png', 'psychic'),
    (43, 'Bagon δ', 'common', 'https://images.pokemontcg.io/ex15/43_hires.png', 'water'),
    (44, 'Chikorita δ', 'common', 'https://images.pokemontcg.io/ex15/44_hires.png', 'fighting'),
    (45, 'Cyndaquil δ', 'common', 'https://images.pokemontcg.io/ex15/45_hires.png', 'psychic'),
    (46, 'Dratini δ', 'common', 'https://images.pokemontcg.io/ex15/46_hires.png', 'grass'),
    (47, 'Ekans δ', 'common', 'https://images.pokemontcg.io/ex15/47_hires.png', 'fire'),
    (48, 'Elekid δ', 'common', 'https://images.pokemontcg.io/ex15/48_hires.png', 'fighting'),
    (49, 'Feebas δ', 'common', 'https://images.pokemontcg.io/ex15/49_hires.png', 'fire'),
    (50, 'Horsea δ', 'common', 'https://images.pokemontcg.io/ex15/50_hires.png', 'fighting'),
    (51, 'Larvitar', 'common', 'https://images.pokemontcg.io/ex15/51_hires.png', 'fighting'),
    (52, 'Larvitar δ', 'common', 'https://images.pokemontcg.io/ex15/52_hires.png', 'lightning'),
    (53, 'Ledyba δ', 'common', 'https://images.pokemontcg.io/ex15/53_hires.png', 'metal'),
    (54, 'Mareep δ', 'common', 'https://images.pokemontcg.io/ex15/54_hires.png', 'colorless'),
    (55, 'Natu δ', 'common', 'https://images.pokemontcg.io/ex15/55_hires.png', 'darkness'),
    (56, 'Nidoran ♀ δ', 'common', 'https://images.pokemontcg.io/ex15/56_hires.png', 'metal'),
    (57, 'Nidoran ♂ δ', 'common', 'https://images.pokemontcg.io/ex15/57_hires.png', 'darkness'),
    (58, 'Pupitar', 'common', 'https://images.pokemontcg.io/ex15/58_hires.png', 'fighting'),
    (59, 'Pupitar δ', 'common', 'https://images.pokemontcg.io/ex15/59_hires.png', 'lightning'),
    (60, 'Ralts', 'common', 'https://images.pokemontcg.io/ex15/60_hires.png', 'psychic'),
    (61, 'Ralts δ', 'common', 'https://images.pokemontcg.io/ex15/61_hires.png', 'fire'),
    (62, 'Seel δ', 'common', 'https://images.pokemontcg.io/ex15/62_hires.png', 'colorless'),
    (63, 'Shellder δ', 'common', 'https://images.pokemontcg.io/ex15/63_hires.png', 'fighting'),
    (64, 'Smoochum δ', 'common', 'https://images.pokemontcg.io/ex15/64_hires.png', 'fire'),
    (65, 'Swablu δ', 'common', 'https://images.pokemontcg.io/ex15/65_hires.png', 'water'),
    (66, 'Taillow δ', 'common', 'https://images.pokemontcg.io/ex15/66_hires.png', 'fire'),
    (67, 'Totodile δ', 'common', 'https://images.pokemontcg.io/ex15/67_hires.png', 'lightning'),
    (68, 'Trapinch δ', 'common', 'https://images.pokemontcg.io/ex15/68_hires.png', 'psychic'),
    (69, 'Trapinch δ', 'common', 'https://images.pokemontcg.io/ex15/69_hires.png', 'psychic'),
    (70, 'Vulpix δ', 'common', 'https://images.pokemontcg.io/ex15/70_hires.png', 'psychic'),
    (71, 'Wooper δ', 'common', 'https://images.pokemontcg.io/ex15/71_hires.png', 'grass'),
    (72, 'Buffer Piece', 'common', 'https://images.pokemontcg.io/ex15/72_hires.png', NULL),
    (73, 'Copycat', 'common', 'https://images.pokemontcg.io/ex15/73_hires.png', NULL),
    (74, 'Holon Legacy', 'common', 'https://images.pokemontcg.io/ex15/74_hires.png', NULL),
    (75, 'Holon Mentor', 'common', 'https://images.pokemontcg.io/ex15/75_hires.png', NULL),
    (76, 'Island Hermit', 'common', 'https://images.pokemontcg.io/ex15/76_hires.png', NULL),
    (77, 'Mr. Stone''s Project', 'common', 'https://images.pokemontcg.io/ex15/77_hires.png', NULL),
    (78, 'Old Rod', 'common', 'https://images.pokemontcg.io/ex15/78_hires.png', NULL),
    (79, 'Professor Elm''s Training Method', 'common', 'https://images.pokemontcg.io/ex15/79_hires.png', NULL),
    (80, 'Professor Oak''s Research', 'common', 'https://images.pokemontcg.io/ex15/80_hires.png', NULL),
    (81, 'Strength Charm', 'common', 'https://images.pokemontcg.io/ex15/81_hires.png', NULL),
    (82, 'TV Reporter', 'common', 'https://images.pokemontcg.io/ex15/82_hires.png', NULL),
    (83, 'Switch', 'common', 'https://images.pokemontcg.io/ex15/83_hires.png', NULL),
    (84, 'Holon Energy FF', 'rare', 'https://images.pokemontcg.io/ex15/84_hires.png', NULL),
    (85, 'Holon Energy GL', 'rare', 'https://images.pokemontcg.io/ex15/85_hires.png', NULL),
    (86, 'Holon Energy WP', 'rare', 'https://images.pokemontcg.io/ex15/86_hires.png', NULL),
    (87, 'Boost Energy', 'common', 'https://images.pokemontcg.io/ex15/87_hires.png', NULL),
    (88, 'δ Rainbow Energy', 'common', 'https://images.pokemontcg.io/ex15/88_hires.png', NULL),
    (89, 'Scramble Energy', 'common', 'https://images.pokemontcg.io/ex15/89_hires.png', NULL),
    (90, 'Altaria ex δ', 'double_rare', 'https://images.pokemontcg.io/ex15/90_hires.png', 'water'),
    (91, 'Dragonite ex δ', 'double_rare', 'https://images.pokemontcg.io/ex15/91_hires.png', 'grass'),
    (92, 'Flygon ex δ', 'double_rare', 'https://images.pokemontcg.io/ex15/92_hires.png', 'psychic'),
    (93, 'Gardevoir ex δ', 'double_rare', 'https://images.pokemontcg.io/ex15/93_hires.png', 'fire'),
    (94, 'Kingdra ex δ', 'double_rare', 'https://images.pokemontcg.io/ex15/94_hires.png', 'fighting'),
    (95, 'Latias ex δ', 'double_rare', 'https://images.pokemontcg.io/ex15/95_hires.png', 'fire'),
    (96, 'Latios ex δ', 'double_rare', 'https://images.pokemontcg.io/ex15/96_hires.png', 'water'),
    (97, 'Rayquaza ex δ', 'double_rare', 'https://images.pokemontcg.io/ex15/97_hires.png', 'lightning'),
    (98, 'Salamence ex δ', 'double_rare', 'https://images.pokemontcg.io/ex15/98_hires.png', 'water'),
    (99, 'Tyranitar ex δ', 'double_rare', 'https://images.pokemontcg.io/ex15/99_hires.png', 'lightning'),
    (100, 'Charizard ★ δ', 'ultra_rare', 'https://images.pokemontcg.io/ex15/100_hires.png', 'darkness'),
    (101, 'Mew ★ δ', 'ultra_rare', 'https://images.pokemontcg.io/ex15/101_hires.png', 'water')
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

-- Set: Power Keepers (ex16) -- 2007/02/02
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('ex', 'EX', 'power-keepers', 'Power Keepers', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'power-keepers'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Aggron', 'rare', 'https://images.pokemontcg.io/ex16/1_hires.png', 'metal'),
    (2, 'Altaria', 'rare', 'https://images.pokemontcg.io/ex16/2_hires.png', 'colorless'),
    (3, 'Armaldo', 'rare', 'https://images.pokemontcg.io/ex16/3_hires.png', 'fighting'),
    (4, 'Banette', 'rare', 'https://images.pokemontcg.io/ex16/4_hires.png', 'psychic'),
    (5, 'Blaziken', 'rare', 'https://images.pokemontcg.io/ex16/5_hires.png', 'fire'),
    (6, 'Charizard', 'rare', 'https://images.pokemontcg.io/ex16/6_hires.png', 'fire'),
    (7, 'Cradily', 'rare', 'https://images.pokemontcg.io/ex16/7_hires.png', 'grass'),
    (8, 'Delcatty', 'rare', 'https://images.pokemontcg.io/ex16/8_hires.png', 'colorless'),
    (9, 'Gardevoir', 'rare', 'https://images.pokemontcg.io/ex16/9_hires.png', 'psychic'),
    (10, 'Kabutops', 'rare', 'https://images.pokemontcg.io/ex16/10_hires.png', 'fighting'),
    (11, 'Machamp', 'rare', 'https://images.pokemontcg.io/ex16/11_hires.png', 'fighting'),
    (12, 'Raichu', 'rare', 'https://images.pokemontcg.io/ex16/12_hires.png', 'lightning'),
    (13, 'Slaking', 'rare', 'https://images.pokemontcg.io/ex16/13_hires.png', 'colorless'),
    (14, 'Dusclops', 'rare', 'https://images.pokemontcg.io/ex16/14_hires.png', 'psychic'),
    (15, 'Lanturn', 'rare', 'https://images.pokemontcg.io/ex16/15_hires.png', 'lightning'),
    (16, 'Magneton', 'rare', 'https://images.pokemontcg.io/ex16/16_hires.png', 'lightning'),
    (17, 'Mawile', 'rare', 'https://images.pokemontcg.io/ex16/17_hires.png', 'metal'),
    (18, 'Mightyena', 'rare', 'https://images.pokemontcg.io/ex16/18_hires.png', 'darkness'),
    (19, 'Ninetales', 'rare', 'https://images.pokemontcg.io/ex16/19_hires.png', 'fire'),
    (20, 'Omastar', 'rare', 'https://images.pokemontcg.io/ex16/20_hires.png', 'water'),
    (21, 'Pichu', 'rare', 'https://images.pokemontcg.io/ex16/21_hires.png', 'lightning'),
    (22, 'Sableye', 'rare', 'https://images.pokemontcg.io/ex16/22_hires.png', 'psychic'),
    (23, 'Seviper', 'rare', 'https://images.pokemontcg.io/ex16/23_hires.png', 'grass'),
    (24, 'Wobbuffet', 'rare', 'https://images.pokemontcg.io/ex16/24_hires.png', 'psychic'),
    (25, 'Zangoose', 'rare', 'https://images.pokemontcg.io/ex16/25_hires.png', 'colorless'),
    (26, 'Anorith', 'common', 'https://images.pokemontcg.io/ex16/26_hires.png', 'fighting'),
    (27, 'Cacturne', 'common', 'https://images.pokemontcg.io/ex16/27_hires.png', 'darkness'),
    (28, 'Charmeleon', 'common', 'https://images.pokemontcg.io/ex16/28_hires.png', 'fire'),
    (29, 'Combusken', 'common', 'https://images.pokemontcg.io/ex16/29_hires.png', 'fire'),
    (30, 'Glalie', 'common', 'https://images.pokemontcg.io/ex16/30_hires.png', 'water'),
    (31, 'Kirlia', 'common', 'https://images.pokemontcg.io/ex16/31_hires.png', 'psychic'),
    (32, 'Lairon', 'common', 'https://images.pokemontcg.io/ex16/32_hires.png', 'metal'),
    (33, 'Machoke', 'common', 'https://images.pokemontcg.io/ex16/33_hires.png', 'fighting'),
    (34, 'Medicham', 'common', 'https://images.pokemontcg.io/ex16/34_hires.png', 'fighting'),
    (35, 'Metang', 'common', 'https://images.pokemontcg.io/ex16/35_hires.png', 'metal'),
    (36, 'Nuzleaf', 'common', 'https://images.pokemontcg.io/ex16/36_hires.png', 'darkness'),
    (37, 'Sealeo', 'common', 'https://images.pokemontcg.io/ex16/37_hires.png', 'water'),
    (38, 'Sharpedo', 'common', 'https://images.pokemontcg.io/ex16/38_hires.png', 'darkness'),
    (39, 'Shelgon', 'common', 'https://images.pokemontcg.io/ex16/39_hires.png', 'colorless'),
    (40, 'Vibrava', 'common', 'https://images.pokemontcg.io/ex16/40_hires.png', 'colorless'),
    (41, 'Vigoroth', 'common', 'https://images.pokemontcg.io/ex16/41_hires.png', 'colorless'),
    (42, 'Aron', 'common', 'https://images.pokemontcg.io/ex16/42_hires.png', 'metal'),
    (43, 'Bagon', 'common', 'https://images.pokemontcg.io/ex16/43_hires.png', 'colorless'),
    (44, 'Baltoy', 'common', 'https://images.pokemontcg.io/ex16/44_hires.png', 'psychic'),
    (45, 'Beldum', 'common', 'https://images.pokemontcg.io/ex16/45_hires.png', 'metal'),
    (46, 'Cacnea', 'common', 'https://images.pokemontcg.io/ex16/46_hires.png', 'grass'),
    (47, 'Carvanha', 'common', 'https://images.pokemontcg.io/ex16/47_hires.png', 'darkness'),
    (48, 'Charmander', 'common', 'https://images.pokemontcg.io/ex16/48_hires.png', 'fire'),
    (49, 'Chinchou', 'common', 'https://images.pokemontcg.io/ex16/49_hires.png', 'lightning'),
    (50, 'Duskull', 'common', 'https://images.pokemontcg.io/ex16/50_hires.png', 'psychic'),
    (51, 'Kabuto', 'common', 'https://images.pokemontcg.io/ex16/51_hires.png', 'fighting'),
    (52, 'Lileep', 'common', 'https://images.pokemontcg.io/ex16/52_hires.png', 'grass'),
    (53, 'Machop', 'common', 'https://images.pokemontcg.io/ex16/53_hires.png', 'fighting'),
    (54, 'Magnemite', 'common', 'https://images.pokemontcg.io/ex16/54_hires.png', 'lightning'),
    (55, 'Meditite', 'common', 'https://images.pokemontcg.io/ex16/55_hires.png', 'fighting'),
    (56, 'Omanyte', 'common', 'https://images.pokemontcg.io/ex16/56_hires.png', 'water'),
    (57, 'Pikachu', 'common', 'https://images.pokemontcg.io/ex16/57_hires.png', 'lightning'),
    (58, 'Poochyena', 'common', 'https://images.pokemontcg.io/ex16/58_hires.png', 'darkness'),
    (59, 'Ralts', 'common', 'https://images.pokemontcg.io/ex16/59_hires.png', 'psychic'),
    (60, 'Seedot', 'common', 'https://images.pokemontcg.io/ex16/60_hires.png', 'grass'),
    (61, 'Shuppet', 'common', 'https://images.pokemontcg.io/ex16/61_hires.png', 'psychic'),
    (62, 'Skitty', 'common', 'https://images.pokemontcg.io/ex16/62_hires.png', 'colorless'),
    (63, 'Slakoth', 'common', 'https://images.pokemontcg.io/ex16/63_hires.png', 'colorless'),
    (64, 'Snorunt', 'common', 'https://images.pokemontcg.io/ex16/64_hires.png', 'water'),
    (65, 'Spheal', 'common', 'https://images.pokemontcg.io/ex16/65_hires.png', 'water'),
    (66, 'Swablu', 'common', 'https://images.pokemontcg.io/ex16/66_hires.png', 'colorless'),
    (67, 'Torchic', 'common', 'https://images.pokemontcg.io/ex16/67_hires.png', 'fire'),
    (68, 'Trapinch', 'common', 'https://images.pokemontcg.io/ex16/68_hires.png', 'fighting'),
    (69, 'Vulpix', 'common', 'https://images.pokemontcg.io/ex16/69_hires.png', 'fire'),
    (70, 'Wynaut', 'common', 'https://images.pokemontcg.io/ex16/70_hires.png', 'psychic'),
    (71, 'Battle Frontier', 'common', 'https://images.pokemontcg.io/ex16/71_hires.png', NULL),
    (72, 'Drake''s Stadium', 'common', 'https://images.pokemontcg.io/ex16/72_hires.png', NULL),
    (73, 'Energy Recycle System', 'common', 'https://images.pokemontcg.io/ex16/73_hires.png', NULL),
    (74, 'Energy Removal 2', 'common', 'https://images.pokemontcg.io/ex16/74_hires.png', NULL),
    (75, 'Energy Switch', 'common', 'https://images.pokemontcg.io/ex16/75_hires.png', NULL),
    (76, 'Glacia''s Stadium', 'common', 'https://images.pokemontcg.io/ex16/76_hires.png', NULL),
    (77, 'Great Ball', 'common', 'https://images.pokemontcg.io/ex16/77_hires.png', NULL),
    (78, 'Master Ball', 'common', 'https://images.pokemontcg.io/ex16/78_hires.png', NULL),
    (79, 'Phoebe''s Stadium', 'common', 'https://images.pokemontcg.io/ex16/79_hires.png', NULL),
    (80, 'Professor Birch', 'common', 'https://images.pokemontcg.io/ex16/80_hires.png', NULL),
    (81, 'Scott', 'common', 'https://images.pokemontcg.io/ex16/81_hires.png', NULL),
    (82, 'Sidney''s Stadium', 'common', 'https://images.pokemontcg.io/ex16/82_hires.png', NULL),
    (83, 'Steven''s Advice', 'common', 'https://images.pokemontcg.io/ex16/83_hires.png', NULL),
    (84, 'Claw Fossil', 'common', 'https://images.pokemontcg.io/ex16/84_hires.png', NULL),
    (85, 'Mysterious Fossil', 'common', 'https://images.pokemontcg.io/ex16/85_hires.png', NULL),
    (86, 'Root Fossil', 'common', 'https://images.pokemontcg.io/ex16/86_hires.png', NULL),
    (87, 'Darkness Energy', 'rare', 'https://images.pokemontcg.io/ex16/87_hires.png', NULL),
    (88, 'Metal Energy', 'rare', 'https://images.pokemontcg.io/ex16/88_hires.png', NULL),
    (89, 'Multi Energy', 'rare', 'https://images.pokemontcg.io/ex16/89_hires.png', NULL),
    (90, 'Cyclone Energy', 'common', 'https://images.pokemontcg.io/ex16/90_hires.png', NULL),
    (91, 'Warp Energy', 'common', 'https://images.pokemontcg.io/ex16/91_hires.png', NULL),
    (92, 'Absol ex', 'double_rare', 'https://images.pokemontcg.io/ex16/92_hires.png', 'darkness'),
    (93, 'Claydol ex', 'double_rare', 'https://images.pokemontcg.io/ex16/93_hires.png', 'psychic'),
    (94, 'Flygon ex', 'double_rare', 'https://images.pokemontcg.io/ex16/94_hires.png', 'colorless'),
    (95, 'Metagross ex', 'double_rare', 'https://images.pokemontcg.io/ex16/95_hires.png', 'metal'),
    (96, 'Salamence ex', 'double_rare', 'https://images.pokemontcg.io/ex16/96_hires.png', 'colorless'),
    (97, 'Shiftry ex', 'double_rare', 'https://images.pokemontcg.io/ex16/97_hires.png', 'darkness'),
    (98, 'Skarmory ex', 'double_rare', 'https://images.pokemontcg.io/ex16/98_hires.png', 'metal'),
    (99, 'Walrein ex', 'double_rare', 'https://images.pokemontcg.io/ex16/99_hires.png', 'water'),
    (100, 'Flareon ★', 'ultra_rare', 'https://images.pokemontcg.io/ex16/100_hires.png', 'fire'),
    (101, 'Jolteon ★', 'ultra_rare', 'https://images.pokemontcg.io/ex16/101_hires.png', 'lightning'),
    (102, 'Vaporeon ★', 'ultra_rare', 'https://images.pokemontcg.io/ex16/102_hires.png', 'water'),
    (103, 'Grass Energy', 'rare', 'https://images.pokemontcg.io/ex16/103_hires.png', NULL),
    (104, 'Fire Energy', 'rare', 'https://images.pokemontcg.io/ex16/104_hires.png', NULL),
    (105, 'Water Energy', 'rare', 'https://images.pokemontcg.io/ex16/105_hires.png', NULL),
    (106, 'Lightning Energy', 'rare', 'https://images.pokemontcg.io/ex16/106_hires.png', NULL),
    (107, 'Psychic Energy', 'rare', 'https://images.pokemontcg.io/ex16/107_hires.png', NULL),
    (108, 'Fighting Energy', 'rare', 'https://images.pokemontcg.io/ex16/108_hires.png', NULL)
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
