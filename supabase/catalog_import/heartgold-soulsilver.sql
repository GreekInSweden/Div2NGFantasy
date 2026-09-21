-- Katalogimport: HeartGold & SoulSilver (6 set)
-- Endast katalogdata (lager 0, pris 0) för portfölj/önskelista-funktionen.

-- Set: HeartGold & SoulSilver (hgss1) -- 2010/02/10
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('heartgold-soulsilver', 'HeartGold & SoulSilver', 'heartgold-soulsilver', 'HeartGold & SoulSilver', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'heartgold-soulsilver'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Arcanine', 'rare', 'https://images.pokemontcg.io/hgss1/1_hires.png', 'fire'),
    (2, 'Azumarill', 'rare', 'https://images.pokemontcg.io/hgss1/2_hires.png', 'water'),
    (3, 'Clefable', 'rare', 'https://images.pokemontcg.io/hgss1/3_hires.png', 'colorless'),
    (4, 'Gyarados', 'rare', 'https://images.pokemontcg.io/hgss1/4_hires.png', 'water'),
    (5, 'Hitmontop', 'rare', 'https://images.pokemontcg.io/hgss1/5_hires.png', 'fighting'),
    (6, 'Jumpluff', 'rare', 'https://images.pokemontcg.io/hgss1/6_hires.png', 'grass'),
    (7, 'Ninetales', 'rare', 'https://images.pokemontcg.io/hgss1/7_hires.png', 'fire'),
    (8, 'Noctowl', 'rare', 'https://images.pokemontcg.io/hgss1/8_hires.png', 'colorless'),
    (9, 'Quagsire', 'rare', 'https://images.pokemontcg.io/hgss1/9_hires.png', 'water'),
    (10, 'Raichu', 'rare', 'https://images.pokemontcg.io/hgss1/10_hires.png', 'lightning'),
    (11, 'Shuckle', 'rare', 'https://images.pokemontcg.io/hgss1/11_hires.png', 'grass'),
    (12, 'Slowking', 'rare', 'https://images.pokemontcg.io/hgss1/12_hires.png', 'psychic'),
    (13, 'Wobbuffet', 'rare', 'https://images.pokemontcg.io/hgss1/13_hires.png', 'psychic'),
    (14, 'Ampharos', 'rare', 'https://images.pokemontcg.io/hgss1/14_hires.png', 'lightning'),
    (15, 'Ariados', 'rare', 'https://images.pokemontcg.io/hgss1/15_hires.png', 'grass'),
    (16, 'Butterfree', 'rare', 'https://images.pokemontcg.io/hgss1/16_hires.png', 'grass'),
    (17, 'Cleffa', 'rare', 'https://images.pokemontcg.io/hgss1/17_hires.png', 'colorless'),
    (18, 'Exeggutor', 'rare', 'https://images.pokemontcg.io/hgss1/18_hires.png', 'psychic'),
    (19, 'Farfetch''d', 'rare', 'https://images.pokemontcg.io/hgss1/19_hires.png', 'colorless'),
    (20, 'Feraligatr', 'rare', 'https://images.pokemontcg.io/hgss1/20_hires.png', 'water'),
    (21, 'Furret', 'rare', 'https://images.pokemontcg.io/hgss1/21_hires.png', 'colorless'),
    (22, 'Granbull', 'rare', 'https://images.pokemontcg.io/hgss1/22_hires.png', 'colorless'),
    (23, 'Hypno', 'rare', 'https://images.pokemontcg.io/hgss1/23_hires.png', 'psychic'),
    (24, 'Lapras', 'rare', 'https://images.pokemontcg.io/hgss1/24_hires.png', 'water'),
    (25, 'Ledian', 'rare', 'https://images.pokemontcg.io/hgss1/25_hires.png', 'grass'),
    (26, 'Meganium', 'rare', 'https://images.pokemontcg.io/hgss1/26_hires.png', 'grass'),
    (27, 'Persian', 'rare', 'https://images.pokemontcg.io/hgss1/27_hires.png', 'colorless'),
    (28, 'Pichu', 'rare', 'https://images.pokemontcg.io/hgss1/28_hires.png', 'lightning'),
    (29, 'Sandslash', 'rare', 'https://images.pokemontcg.io/hgss1/29_hires.png', 'fighting'),
    (30, 'Smoochum', 'rare', 'https://images.pokemontcg.io/hgss1/30_hires.png', 'psychic'),
    (31, 'Sunflora', 'rare', 'https://images.pokemontcg.io/hgss1/31_hires.png', 'grass'),
    (32, 'Typhlosion', 'rare', 'https://images.pokemontcg.io/hgss1/32_hires.png', 'fire'),
    (33, 'Tyrogue', 'rare', 'https://images.pokemontcg.io/hgss1/33_hires.png', 'fighting'),
    (34, 'Weezing', 'rare', 'https://images.pokemontcg.io/hgss1/34_hires.png', 'psychic'),
    (35, 'Bayleef', 'common', 'https://images.pokemontcg.io/hgss1/35_hires.png', 'grass'),
    (36, 'Blissey', 'common', 'https://images.pokemontcg.io/hgss1/36_hires.png', 'colorless'),
    (37, 'Corsola', 'common', 'https://images.pokemontcg.io/hgss1/37_hires.png', 'water'),
    (38, 'Croconaw', 'common', 'https://images.pokemontcg.io/hgss1/38_hires.png', 'water'),
    (39, 'Delibird', 'common', 'https://images.pokemontcg.io/hgss1/39_hires.png', 'water'),
    (40, 'Donphan', 'common', 'https://images.pokemontcg.io/hgss1/40_hires.png', 'fighting'),
    (41, 'Dunsparce', 'common', 'https://images.pokemontcg.io/hgss1/41_hires.png', 'colorless'),
    (42, 'Flaaffy', 'common', 'https://images.pokemontcg.io/hgss1/42_hires.png', 'lightning'),
    (43, 'Heracross', 'common', 'https://images.pokemontcg.io/hgss1/43_hires.png', 'grass'),
    (44, 'Igglybuff', 'common', 'https://images.pokemontcg.io/hgss1/44_hires.png', 'colorless'),
    (45, 'Mantine', 'common', 'https://images.pokemontcg.io/hgss1/45_hires.png', 'water'),
    (46, 'Metapod', 'common', 'https://images.pokemontcg.io/hgss1/46_hires.png', 'grass'),
    (47, 'Miltank', 'common', 'https://images.pokemontcg.io/hgss1/47_hires.png', 'colorless'),
    (48, 'Parasect', 'common', 'https://images.pokemontcg.io/hgss1/48_hires.png', 'grass'),
    (49, 'Quilava', 'common', 'https://images.pokemontcg.io/hgss1/49_hires.png', 'fire'),
    (50, 'Qwilfish', 'common', 'https://images.pokemontcg.io/hgss1/50_hires.png', 'water'),
    (51, 'Skiploom', 'common', 'https://images.pokemontcg.io/hgss1/51_hires.png', 'grass'),
    (52, 'Slowbro', 'common', 'https://images.pokemontcg.io/hgss1/52_hires.png', 'water'),
    (53, 'Starmie', 'common', 'https://images.pokemontcg.io/hgss1/53_hires.png', 'water'),
    (54, 'Unown', 'common', 'https://images.pokemontcg.io/hgss1/54_hires.png', 'psychic'),
    (55, 'Unown', 'common', 'https://images.pokemontcg.io/hgss1/55_hires.png', 'psychic'),
    (56, 'Wigglytuff', 'common', 'https://images.pokemontcg.io/hgss1/56_hires.png', 'colorless'),
    (57, 'Caterpie', 'common', 'https://images.pokemontcg.io/hgss1/57_hires.png', 'grass'),
    (58, 'Chansey', 'common', 'https://images.pokemontcg.io/hgss1/58_hires.png', 'colorless'),
    (59, 'Chikorita', 'common', 'https://images.pokemontcg.io/hgss1/59_hires.png', 'grass'),
    (60, 'Clefairy', 'common', 'https://images.pokemontcg.io/hgss1/60_hires.png', 'colorless'),
    (61, 'Cyndaquil', 'common', 'https://images.pokemontcg.io/hgss1/61_hires.png', 'fire'),
    (62, 'Drowzee', 'common', 'https://images.pokemontcg.io/hgss1/62_hires.png', 'psychic'),
    (63, 'Exeggcute', 'common', 'https://images.pokemontcg.io/hgss1/63_hires.png', 'psychic'),
    (64, 'Girafarig', 'common', 'https://images.pokemontcg.io/hgss1/64_hires.png', 'colorless'),
    (65, 'Growlithe', 'common', 'https://images.pokemontcg.io/hgss1/65_hires.png', 'fire'),
    (66, 'Hoothoot', 'common', 'https://images.pokemontcg.io/hgss1/66_hires.png', 'colorless'),
    (67, 'Hoppip', 'common', 'https://images.pokemontcg.io/hgss1/67_hires.png', 'grass'),
    (68, 'Jigglypuff', 'common', 'https://images.pokemontcg.io/hgss1/68_hires.png', 'colorless'),
    (69, 'Jynx', 'common', 'https://images.pokemontcg.io/hgss1/69_hires.png', 'psychic'),
    (70, 'Koffing', 'common', 'https://images.pokemontcg.io/hgss1/70_hires.png', 'psychic'),
    (71, 'Ledyba', 'common', 'https://images.pokemontcg.io/hgss1/71_hires.png', 'grass'),
    (72, 'Magikarp', 'common', 'https://images.pokemontcg.io/hgss1/72_hires.png', 'water'),
    (73, 'Mareep', 'common', 'https://images.pokemontcg.io/hgss1/73_hires.png', 'lightning'),
    (74, 'Marill', 'common', 'https://images.pokemontcg.io/hgss1/74_hires.png', 'water'),
    (75, 'Meowth', 'common', 'https://images.pokemontcg.io/hgss1/75_hires.png', 'colorless'),
    (76, 'Paras', 'common', 'https://images.pokemontcg.io/hgss1/76_hires.png', 'grass'),
    (77, 'Phanpy', 'common', 'https://images.pokemontcg.io/hgss1/77_hires.png', 'fighting'),
    (78, 'Pikachu', 'common', 'https://images.pokemontcg.io/hgss1/78_hires.png', 'lightning'),
    (79, 'Sandshrew', 'common', 'https://images.pokemontcg.io/hgss1/79_hires.png', 'fighting'),
    (80, 'Sentret', 'common', 'https://images.pokemontcg.io/hgss1/80_hires.png', 'colorless'),
    (81, 'Slowpoke', 'common', 'https://images.pokemontcg.io/hgss1/81_hires.png', 'water'),
    (82, 'Snubbull', 'common', 'https://images.pokemontcg.io/hgss1/82_hires.png', 'colorless'),
    (83, 'Spinarak', 'common', 'https://images.pokemontcg.io/hgss1/83_hires.png', 'grass'),
    (84, 'Staryu', 'common', 'https://images.pokemontcg.io/hgss1/84_hires.png', 'water'),
    (85, 'Sunkern', 'common', 'https://images.pokemontcg.io/hgss1/85_hires.png', 'grass'),
    (86, 'Totodile', 'common', 'https://images.pokemontcg.io/hgss1/86_hires.png', 'water'),
    (87, 'Vulpix', 'common', 'https://images.pokemontcg.io/hgss1/87_hires.png', 'fire'),
    (88, 'Wooper', 'common', 'https://images.pokemontcg.io/hgss1/88_hires.png', 'water'),
    (89, 'Bill', 'common', 'https://images.pokemontcg.io/hgss1/89_hires.png', NULL),
    (90, 'Copycat', 'common', 'https://images.pokemontcg.io/hgss1/90_hires.png', NULL),
    (91, 'Energy Switch', 'common', 'https://images.pokemontcg.io/hgss1/91_hires.png', NULL),
    (92, 'Fisherman', 'common', 'https://images.pokemontcg.io/hgss1/92_hires.png', NULL),
    (93, 'Full Heal', 'common', 'https://images.pokemontcg.io/hgss1/93_hires.png', NULL),
    (94, 'Moomoo Milk', 'common', 'https://images.pokemontcg.io/hgss1/94_hires.png', NULL),
    (95, 'Poké Ball', 'common', 'https://images.pokemontcg.io/hgss1/95_hires.png', NULL),
    (96, 'Pokégear 3.0', 'common', 'https://images.pokemontcg.io/hgss1/96_hires.png', NULL),
    (97, 'Pokémon Collector', 'common', 'https://images.pokemontcg.io/hgss1/97_hires.png', NULL),
    (98, 'Pokémon Communication', 'common', 'https://images.pokemontcg.io/hgss1/98_hires.png', NULL),
    (99, 'Pokémon Reversal', 'common', 'https://images.pokemontcg.io/hgss1/99_hires.png', NULL),
    (100, 'Professor Elm''s Training Method', 'common', 'https://images.pokemontcg.io/hgss1/100_hires.png', NULL),
    (101, 'Professor Oak''s New Theory', 'common', 'https://images.pokemontcg.io/hgss1/101_hires.png', NULL),
    (102, 'Switch', 'common', 'https://images.pokemontcg.io/hgss1/102_hires.png', NULL),
    (103, 'Double Colorless Energy', 'common', 'https://images.pokemontcg.io/hgss1/103_hires.png', NULL),
    (104, 'Rainbow Energy', 'common', 'https://images.pokemontcg.io/hgss1/104_hires.png', NULL),
    (105, 'Ampharos', 'double_rare', 'https://images.pokemontcg.io/hgss1/105_hires.png', 'lightning'),
    (106, 'Blissey', 'double_rare', 'https://images.pokemontcg.io/hgss1/106_hires.png', 'colorless'),
    (107, 'Donphan', 'double_rare', 'https://images.pokemontcg.io/hgss1/107_hires.png', 'fighting'),
    (108, 'Feraligatr', 'double_rare', 'https://images.pokemontcg.io/hgss1/108_hires.png', 'water'),
    (109, 'Meganium', 'double_rare', 'https://images.pokemontcg.io/hgss1/109_hires.png', 'grass'),
    (110, 'Typhlosion', 'double_rare', 'https://images.pokemontcg.io/hgss1/110_hires.png', 'fire'),
    (111, 'Ho-Oh LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss1/111_hires.png', 'fire'),
    (112, 'Ho-Oh LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss1/112_hires.png', 'fire'),
    (113, 'Lugia LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss1/113_hires.png', 'water'),
    (114, 'Lugia LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss1/114_hires.png', 'water'),
    (115, 'Grass Energy', 'common', 'https://images.pokemontcg.io/hgss1/115_hires.png', NULL),
    (116, 'Fire Energy', 'common', 'https://images.pokemontcg.io/hgss1/116_hires.png', NULL),
    (117, 'Water Energy', 'common', 'https://images.pokemontcg.io/hgss1/117_hires.png', NULL),
    (118, 'Lightning Energy', 'common', 'https://images.pokemontcg.io/hgss1/118_hires.png', NULL),
    (119, 'Psychic Energy', 'common', 'https://images.pokemontcg.io/hgss1/119_hires.png', NULL),
    (120, 'Fighting Energy', 'common', 'https://images.pokemontcg.io/hgss1/120_hires.png', NULL),
    (121, 'Darkness Energy', 'common', 'https://images.pokemontcg.io/hgss1/121_hires.png', NULL),
    (122, 'Metal Energy', 'common', 'https://images.pokemontcg.io/hgss1/122_hires.png', NULL),
    (123, 'Gyarados', 'rare', 'https://images.pokemontcg.io/hgss1/123_hires.png', 'water'),
    (501000, 'Alph Lithograph', 'mega_hyper_rare', 'https://images.pokemontcg.io/hgss1/ONE_hires.png', NULL)
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

-- Set: HGSS Black Star Promos (hsp) -- 2010/02/10
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('heartgold-soulsilver', 'HeartGold & SoulSilver', 'hgss-black-star-promos', 'HGSS Black Star Promos', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'hgss-black-star-promos'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (501001, 'Ho-Oh', 'promo', 'https://images.pokemontcg.io/hsp/HGSS01_hires.png', 'fire'),
    (501002, 'Lugia', 'promo', 'https://images.pokemontcg.io/hsp/HGSS02_hires.png', 'water'),
    (501003, 'Pikachu', 'promo', 'https://images.pokemontcg.io/hsp/HGSS03_hires.png', 'lightning'),
    (501004, 'Wobbuffet', 'promo', 'https://images.pokemontcg.io/hsp/HGSS04_hires.png', 'psychic'),
    (501005, 'Hoothoot', 'promo', 'https://images.pokemontcg.io/hsp/HGSS05_hires.png', 'colorless'),
    (501006, 'Noctowl', 'promo', 'https://images.pokemontcg.io/hsp/HGSS06_hires.png', 'colorless'),
    (501007, 'Feraligatr', 'promo', 'https://images.pokemontcg.io/hsp/HGSS07_hires.png', 'water'),
    (501008, 'Meganium', 'promo', 'https://images.pokemontcg.io/hsp/HGSS08_hires.png', 'grass'),
    (501009, 'Typhlosion', 'promo', 'https://images.pokemontcg.io/hsp/HGSS09_hires.png', 'fire'),
    (501010, 'Latias', 'promo', 'https://images.pokemontcg.io/hsp/HGSS10_hires.png', 'colorless'),
    (501011, 'Latios', 'promo', 'https://images.pokemontcg.io/hsp/HGSS11_hires.png', 'colorless'),
    (501012, 'Cleffa', 'promo', 'https://images.pokemontcg.io/hsp/HGSS12_hires.png', 'colorless'),
    (501013, 'Smoochum', 'promo', 'https://images.pokemontcg.io/hsp/HGSS13_hires.png', 'psychic'),
    (501014, 'Lapras', 'promo', 'https://images.pokemontcg.io/hsp/HGSS14_hires.png', 'water'),
    (501015, 'Shuckle', 'promo', 'https://images.pokemontcg.io/hsp/HGSS15_hires.png', 'fighting'),
    (501016, 'Plusle', 'promo', 'https://images.pokemontcg.io/hsp/HGSS16_hires.png', 'lightning'),
    (501017, 'Minun', 'promo', 'https://images.pokemontcg.io/hsp/HGSS17_hires.png', 'lightning'),
    (501018, 'Tropical Tidal Wave', 'promo', 'https://images.pokemontcg.io/hsp/HGSS18_hires.png', NULL),
    (501019, 'Raikou', 'promo', 'https://images.pokemontcg.io/hsp/HGSS19_hires.png', 'lightning'),
    (501020, 'Entei', 'promo', 'https://images.pokemontcg.io/hsp/HGSS20_hires.png', 'fire'),
    (501021, 'Suicune', 'promo', 'https://images.pokemontcg.io/hsp/HGSS21_hires.png', 'water'),
    (501022, 'Porygon', 'promo', 'https://images.pokemontcg.io/hsp/HGSS22_hires.png', 'colorless'),
    (501023, 'Porygon2', 'promo', 'https://images.pokemontcg.io/hsp/HGSS23_hires.png', 'colorless'),
    (501024, 'Hitmonchan', 'promo', 'https://images.pokemontcg.io/hsp/HGSS24_hires.png', 'fighting'),
    (501025, 'Hitmonlee', 'promo', 'https://images.pokemontcg.io/hsp/HGSS25_hires.png', 'fighting')
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

-- Set: HS—Unleashed (hgss2) -- 2010/05/12
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('heartgold-soulsilver', 'HeartGold & SoulSilver', 'hs-unleashed', 'HS—Unleashed', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'hs-unleashed'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Jirachi', 'rare', 'https://images.pokemontcg.io/hgss2/1_hires.png', 'psychic'),
    (2, 'Magmortar', 'rare', 'https://images.pokemontcg.io/hgss2/2_hires.png', 'fire'),
    (3, 'Manaphy', 'rare', 'https://images.pokemontcg.io/hgss2/3_hires.png', 'water'),
    (4, 'Metagross', 'rare', 'https://images.pokemontcg.io/hgss2/4_hires.png', 'psychic'),
    (5, 'Mismagius', 'rare', 'https://images.pokemontcg.io/hgss2/5_hires.png', 'psychic'),
    (6, 'Octillery', 'rare', 'https://images.pokemontcg.io/hgss2/6_hires.png', 'water'),
    (7, 'Politoed', 'rare', 'https://images.pokemontcg.io/hgss2/7_hires.png', 'water'),
    (8, 'Shaymin', 'rare', 'https://images.pokemontcg.io/hgss2/8_hires.png', 'grass'),
    (9, 'Sudowoodo', 'rare', 'https://images.pokemontcg.io/hgss2/9_hires.png', 'fighting'),
    (10, 'Torterra', 'rare', 'https://images.pokemontcg.io/hgss2/10_hires.png', 'grass'),
    (11, 'Xatu', 'rare', 'https://images.pokemontcg.io/hgss2/11_hires.png', 'psychic'),
    (12, 'Beedrill', 'rare', 'https://images.pokemontcg.io/hgss2/12_hires.png', 'grass'),
    (13, 'Blastoise', 'rare', 'https://images.pokemontcg.io/hgss2/13_hires.png', 'water'),
    (14, 'Crobat', 'rare', 'https://images.pokemontcg.io/hgss2/14_hires.png', 'psychic'),
    (15, 'Fearow', 'rare', 'https://images.pokemontcg.io/hgss2/15_hires.png', 'colorless'),
    (16, 'Floatzel', 'rare', 'https://images.pokemontcg.io/hgss2/16_hires.png', 'water'),
    (17, 'Kingdra', 'rare', 'https://images.pokemontcg.io/hgss2/17_hires.png', 'water'),
    (18, 'Lanturn', 'rare', 'https://images.pokemontcg.io/hgss2/18_hires.png', 'lightning'),
    (19, 'Lucario', 'rare', 'https://images.pokemontcg.io/hgss2/19_hires.png', 'fighting'),
    (20, 'Ninetales', 'rare', 'https://images.pokemontcg.io/hgss2/20_hires.png', 'fire'),
    (21, 'Poliwrath', 'rare', 'https://images.pokemontcg.io/hgss2/21_hires.png', 'water'),
    (22, 'Primeape', 'rare', 'https://images.pokemontcg.io/hgss2/22_hires.png', 'fighting'),
    (23, 'Roserade', 'rare', 'https://images.pokemontcg.io/hgss2/23_hires.png', 'grass'),
    (24, 'Steelix', 'rare', 'https://images.pokemontcg.io/hgss2/24_hires.png', 'metal'),
    (25, 'Torkoal', 'rare', 'https://images.pokemontcg.io/hgss2/25_hires.png', 'fire'),
    (26, 'Tyranitar', 'rare', 'https://images.pokemontcg.io/hgss2/26_hires.png', 'darkness'),
    (27, 'Ursaring', 'rare', 'https://images.pokemontcg.io/hgss2/27_hires.png', 'colorless'),
    (28, 'Cherrim', 'common', 'https://images.pokemontcg.io/hgss2/28_hires.png', 'grass'),
    (29, 'Dunsparce', 'common', 'https://images.pokemontcg.io/hgss2/29_hires.png', 'colorless'),
    (30, 'Golbat', 'common', 'https://images.pokemontcg.io/hgss2/30_hires.png', 'psychic'),
    (31, 'Grotle', 'common', 'https://images.pokemontcg.io/hgss2/31_hires.png', 'grass'),
    (32, 'Kakuna', 'common', 'https://images.pokemontcg.io/hgss2/32_hires.png', 'grass'),
    (33, 'Metang', 'common', 'https://images.pokemontcg.io/hgss2/33_hires.png', 'psychic'),
    (34, 'Minun', 'common', 'https://images.pokemontcg.io/hgss2/34_hires.png', 'lightning'),
    (35, 'Numel', 'common', 'https://images.pokemontcg.io/hgss2/35_hires.png', 'fire'),
    (36, 'Plusle', 'common', 'https://images.pokemontcg.io/hgss2/36_hires.png', 'lightning'),
    (37, 'Poliwhirl', 'common', 'https://images.pokemontcg.io/hgss2/37_hires.png', 'water'),
    (38, 'Pupitar', 'common', 'https://images.pokemontcg.io/hgss2/38_hires.png', 'fighting'),
    (39, 'Pupitar', 'common', 'https://images.pokemontcg.io/hgss2/39_hires.png', 'fighting'),
    (40, 'Seadra', 'common', 'https://images.pokemontcg.io/hgss2/40_hires.png', 'water'),
    (41, 'Tauros', 'common', 'https://images.pokemontcg.io/hgss2/41_hires.png', 'colorless'),
    (42, 'Wartortle', 'common', 'https://images.pokemontcg.io/hgss2/42_hires.png', 'water'),
    (43, 'Aipom', 'common', 'https://images.pokemontcg.io/hgss2/43_hires.png', 'colorless'),
    (44, 'Beldum', 'common', 'https://images.pokemontcg.io/hgss2/44_hires.png', 'psychic'),
    (45, 'Buizel', 'common', 'https://images.pokemontcg.io/hgss2/45_hires.png', 'water'),
    (46, 'Carnivine', 'common', 'https://images.pokemontcg.io/hgss2/46_hires.png', 'grass'),
    (47, 'Cherubi', 'common', 'https://images.pokemontcg.io/hgss2/47_hires.png', 'grass'),
    (48, 'Chinchou', 'common', 'https://images.pokemontcg.io/hgss2/48_hires.png', 'lightning'),
    (49, 'Horsea', 'common', 'https://images.pokemontcg.io/hgss2/49_hires.png', 'water'),
    (50, 'Larvitar', 'common', 'https://images.pokemontcg.io/hgss2/50_hires.png', 'fighting'),
    (51, 'Larvitar', 'common', 'https://images.pokemontcg.io/hgss2/51_hires.png', 'fighting'),
    (52, 'Magmar', 'common', 'https://images.pokemontcg.io/hgss2/52_hires.png', 'fire'),
    (53, 'Mankey', 'common', 'https://images.pokemontcg.io/hgss2/53_hires.png', 'fighting'),
    (54, 'Misdreavus', 'common', 'https://images.pokemontcg.io/hgss2/54_hires.png', 'psychic'),
    (55, 'Natu', 'common', 'https://images.pokemontcg.io/hgss2/55_hires.png', 'psychic'),
    (56, 'Onix', 'common', 'https://images.pokemontcg.io/hgss2/56_hires.png', 'fighting'),
    (57, 'Onix', 'common', 'https://images.pokemontcg.io/hgss2/57_hires.png', 'fighting'),
    (58, 'Poliwag', 'common', 'https://images.pokemontcg.io/hgss2/58_hires.png', 'water'),
    (59, 'Remoraid', 'common', 'https://images.pokemontcg.io/hgss2/59_hires.png', 'water'),
    (60, 'Riolu', 'common', 'https://images.pokemontcg.io/hgss2/60_hires.png', 'fighting'),
    (61, 'Roselia', 'common', 'https://images.pokemontcg.io/hgss2/61_hires.png', 'grass'),
    (62, 'Spearow', 'common', 'https://images.pokemontcg.io/hgss2/62_hires.png', 'colorless'),
    (63, 'Squirtle', 'common', 'https://images.pokemontcg.io/hgss2/63_hires.png', 'water'),
    (64, 'Stantler', 'common', 'https://images.pokemontcg.io/hgss2/64_hires.png', 'colorless'),
    (65, 'Teddiursa', 'common', 'https://images.pokemontcg.io/hgss2/65_hires.png', 'colorless'),
    (66, 'Tropius', 'common', 'https://images.pokemontcg.io/hgss2/66_hires.png', 'grass'),
    (67, 'Turtwig', 'common', 'https://images.pokemontcg.io/hgss2/67_hires.png', 'grass'),
    (68, 'Vulpix', 'common', 'https://images.pokemontcg.io/hgss2/68_hires.png', 'fire'),
    (69, 'Weedle', 'common', 'https://images.pokemontcg.io/hgss2/69_hires.png', 'grass'),
    (70, 'Zubat', 'common', 'https://images.pokemontcg.io/hgss2/70_hires.png', 'psychic'),
    (71, 'Cheerleader''s Cheer', 'common', 'https://images.pokemontcg.io/hgss2/71_hires.png', NULL),
    (72, 'Dual Ball', 'common', 'https://images.pokemontcg.io/hgss2/72_hires.png', NULL),
    (73, 'Emcee''s Chatter', 'common', 'https://images.pokemontcg.io/hgss2/73_hires.png', NULL),
    (74, 'Energy Returner', 'common', 'https://images.pokemontcg.io/hgss2/74_hires.png', NULL),
    (75, 'Engineer''s Adjustments', 'common', 'https://images.pokemontcg.io/hgss2/75_hires.png', NULL),
    (76, 'Good Rod', 'common', 'https://images.pokemontcg.io/hgss2/76_hires.png', NULL),
    (77, 'Interviewer''s Questions', 'common', 'https://images.pokemontcg.io/hgss2/77_hires.png', NULL),
    (78, 'Judge', 'common', 'https://images.pokemontcg.io/hgss2/78_hires.png', NULL),
    (79, 'Life Herb', 'common', 'https://images.pokemontcg.io/hgss2/79_hires.png', NULL),
    (80, 'PlusPower', 'common', 'https://images.pokemontcg.io/hgss2/80_hires.png', NULL),
    (81, 'Pokémon Circulator', 'common', 'https://images.pokemontcg.io/hgss2/81_hires.png', NULL),
    (82, 'Rare Candy', 'common', 'https://images.pokemontcg.io/hgss2/82_hires.png', NULL),
    (83, 'Super Scoop Up', 'common', 'https://images.pokemontcg.io/hgss2/83_hires.png', NULL),
    (84, 'Crobat', 'double_rare', 'https://images.pokemontcg.io/hgss2/84_hires.png', 'psychic'),
    (85, 'Kingdra', 'double_rare', 'https://images.pokemontcg.io/hgss2/85_hires.png', 'water'),
    (86, 'Lanturn', 'double_rare', 'https://images.pokemontcg.io/hgss2/86_hires.png', 'lightning'),
    (87, 'Steelix', 'double_rare', 'https://images.pokemontcg.io/hgss2/87_hires.png', 'metal'),
    (88, 'Tyranitar', 'double_rare', 'https://images.pokemontcg.io/hgss2/88_hires.png', 'darkness'),
    (89, 'Ursaring', 'double_rare', 'https://images.pokemontcg.io/hgss2/89_hires.png', 'colorless'),
    (90, 'Entei & Raikou LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss2/90_hires.png', 'fire'),
    (91, 'Entei & Raikou LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss2/91_hires.png', 'fire'),
    (92, 'Raikou & Suicune LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss2/92_hires.png', 'lightning'),
    (93, 'Raikou & Suicune LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss2/93_hires.png', 'lightning'),
    (94, 'Suicune & Entei LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss2/94_hires.png', 'water'),
    (95, 'Suicune & Entei LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss2/95_hires.png', 'water'),
    (501000, 'Alph Lithograph', 'mega_hyper_rare', 'https://images.pokemontcg.io/hgss2/TWO_hires.png', NULL)
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

-- Set: HS—Undaunted (hgss3) -- 2010/08/18
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('heartgold-soulsilver', 'HeartGold & SoulSilver', 'hs-undaunted', 'HS—Undaunted', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'hs-undaunted'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Bellossom', 'rare', 'https://images.pokemontcg.io/hgss3/1_hires.png', 'grass'),
    (2, 'Espeon', 'rare', 'https://images.pokemontcg.io/hgss3/2_hires.png', 'psychic'),
    (3, 'Forretress', 'rare', 'https://images.pokemontcg.io/hgss3/3_hires.png', 'metal'),
    (4, 'Gliscor', 'rare', 'https://images.pokemontcg.io/hgss3/4_hires.png', 'fighting'),
    (5, 'Houndoom', 'rare', 'https://images.pokemontcg.io/hgss3/5_hires.png', 'darkness'),
    (6, 'Magcargo', 'rare', 'https://images.pokemontcg.io/hgss3/6_hires.png', 'fire'),
    (7, 'Scizor', 'rare', 'https://images.pokemontcg.io/hgss3/7_hires.png', 'metal'),
    (8, 'Smeargle', 'rare', 'https://images.pokemontcg.io/hgss3/8_hires.png', 'colorless'),
    (9, 'Togekiss', 'rare', 'https://images.pokemontcg.io/hgss3/9_hires.png', 'colorless'),
    (10, 'Umbreon', 'rare', 'https://images.pokemontcg.io/hgss3/10_hires.png', 'darkness'),
    (11, 'Dodrio', 'rare', 'https://images.pokemontcg.io/hgss3/11_hires.png', 'colorless'),
    (12, 'Drifblim', 'rare', 'https://images.pokemontcg.io/hgss3/12_hires.png', 'psychic'),
    (13, 'Forretress', 'rare', 'https://images.pokemontcg.io/hgss3/13_hires.png', 'metal'),
    (14, 'Hariyama', 'rare', 'https://images.pokemontcg.io/hgss3/14_hires.png', 'fighting'),
    (15, 'Honchkrow', 'rare', 'https://images.pokemontcg.io/hgss3/15_hires.png', 'darkness'),
    (16, 'Honchkrow', 'rare', 'https://images.pokemontcg.io/hgss3/16_hires.png', 'darkness'),
    (17, 'Leafeon', 'rare', 'https://images.pokemontcg.io/hgss3/17_hires.png', 'grass'),
    (18, 'Metagross', 'rare', 'https://images.pokemontcg.io/hgss3/18_hires.png', 'metal'),
    (19, 'Mismagius', 'rare', 'https://images.pokemontcg.io/hgss3/19_hires.png', 'psychic'),
    (20, 'Rotom', 'rare', 'https://images.pokemontcg.io/hgss3/20_hires.png', 'lightning'),
    (21, 'Skarmory', 'rare', 'https://images.pokemontcg.io/hgss3/21_hires.png', 'metal'),
    (22, 'Tropius', 'rare', 'https://images.pokemontcg.io/hgss3/22_hires.png', 'grass'),
    (23, 'Vespiquen', 'rare', 'https://images.pokemontcg.io/hgss3/23_hires.png', 'grass'),
    (24, 'Vileplume', 'rare', 'https://images.pokemontcg.io/hgss3/24_hires.png', 'grass'),
    (25, 'Weavile', 'rare', 'https://images.pokemontcg.io/hgss3/25_hires.png', 'darkness'),
    (26, 'Flareon', 'common', 'https://images.pokemontcg.io/hgss3/26_hires.png', 'fire'),
    (27, 'Gloom', 'common', 'https://images.pokemontcg.io/hgss3/27_hires.png', 'grass'),
    (28, 'Jolteon', 'common', 'https://images.pokemontcg.io/hgss3/28_hires.png', 'lightning'),
    (29, 'Lairon', 'common', 'https://images.pokemontcg.io/hgss3/29_hires.png', 'metal'),
    (30, 'Metang', 'common', 'https://images.pokemontcg.io/hgss3/30_hires.png', 'metal'),
    (31, 'Muk', 'common', 'https://images.pokemontcg.io/hgss3/31_hires.png', 'psychic'),
    (32, 'Pinsir', 'common', 'https://images.pokemontcg.io/hgss3/32_hires.png', 'grass'),
    (33, 'Raichu', 'common', 'https://images.pokemontcg.io/hgss3/33_hires.png', 'lightning'),
    (34, 'Raticate', 'common', 'https://images.pokemontcg.io/hgss3/34_hires.png', 'colorless'),
    (35, 'Sableye', 'common', 'https://images.pokemontcg.io/hgss3/35_hires.png', 'darkness'),
    (36, 'Scyther', 'common', 'https://images.pokemontcg.io/hgss3/36_hires.png', 'grass'),
    (37, 'Skuntank', 'common', 'https://images.pokemontcg.io/hgss3/37_hires.png', 'darkness'),
    (38, 'Slowbro', 'common', 'https://images.pokemontcg.io/hgss3/38_hires.png', 'water'),
    (39, 'Togetic', 'common', 'https://images.pokemontcg.io/hgss3/39_hires.png', 'colorless'),
    (40, 'Unown', 'common', 'https://images.pokemontcg.io/hgss3/40_hires.png', 'psychic'),
    (41, 'Vaporeon', 'common', 'https://images.pokemontcg.io/hgss3/41_hires.png', 'water'),
    (42, 'Aron', 'common', 'https://images.pokemontcg.io/hgss3/42_hires.png', 'metal'),
    (43, 'Beldum', 'common', 'https://images.pokemontcg.io/hgss3/43_hires.png', 'metal'),
    (44, 'Combee', 'common', 'https://images.pokemontcg.io/hgss3/44_hires.png', 'grass'),
    (45, 'Doduo', 'common', 'https://images.pokemontcg.io/hgss3/45_hires.png', 'colorless'),
    (46, 'Drifloon', 'common', 'https://images.pokemontcg.io/hgss3/46_hires.png', 'psychic'),
    (47, 'Eevee', 'common', 'https://images.pokemontcg.io/hgss3/47_hires.png', 'colorless'),
    (48, 'Eevee', 'common', 'https://images.pokemontcg.io/hgss3/48_hires.png', 'colorless'),
    (49, 'Gligar', 'common', 'https://images.pokemontcg.io/hgss3/49_hires.png', 'fighting'),
    (50, 'Grimer', 'common', 'https://images.pokemontcg.io/hgss3/50_hires.png', 'psychic'),
    (51, 'Hitmonchan', 'common', 'https://images.pokemontcg.io/hgss3/51_hires.png', 'fighting'),
    (52, 'Hitmonlee', 'common', 'https://images.pokemontcg.io/hgss3/52_hires.png', 'fighting'),
    (53, 'Houndour', 'common', 'https://images.pokemontcg.io/hgss3/53_hires.png', 'darkness'),
    (54, 'Houndour', 'common', 'https://images.pokemontcg.io/hgss3/54_hires.png', 'darkness'),
    (55, 'Makuhita', 'common', 'https://images.pokemontcg.io/hgss3/55_hires.png', 'fighting'),
    (56, 'Mawile', 'common', 'https://images.pokemontcg.io/hgss3/56_hires.png', 'metal'),
    (57, 'Misdreavus', 'common', 'https://images.pokemontcg.io/hgss3/57_hires.png', 'psychic'),
    (58, 'Murkrow', 'common', 'https://images.pokemontcg.io/hgss3/58_hires.png', 'darkness'),
    (59, 'Murkrow', 'common', 'https://images.pokemontcg.io/hgss3/59_hires.png', 'darkness'),
    (60, 'Oddish', 'common', 'https://images.pokemontcg.io/hgss3/60_hires.png', 'grass'),
    (61, 'Pikachu', 'common', 'https://images.pokemontcg.io/hgss3/61_hires.png', 'lightning'),
    (62, 'Pineco', 'common', 'https://images.pokemontcg.io/hgss3/62_hires.png', 'grass'),
    (63, 'Pineco', 'common', 'https://images.pokemontcg.io/hgss3/63_hires.png', 'grass'),
    (64, 'Rattata', 'common', 'https://images.pokemontcg.io/hgss3/64_hires.png', 'colorless'),
    (65, 'Scyther', 'common', 'https://images.pokemontcg.io/hgss3/65_hires.png', 'grass'),
    (66, 'Slowpoke', 'common', 'https://images.pokemontcg.io/hgss3/66_hires.png', 'water'),
    (67, 'Slugma', 'common', 'https://images.pokemontcg.io/hgss3/67_hires.png', 'fire'),
    (68, 'Sneasel', 'common', 'https://images.pokemontcg.io/hgss3/68_hires.png', 'darkness'),
    (69, 'Stunky', 'common', 'https://images.pokemontcg.io/hgss3/69_hires.png', 'darkness'),
    (70, 'Togepi', 'common', 'https://images.pokemontcg.io/hgss3/70_hires.png', 'colorless'),
    (71, 'Burned Tower', 'common', 'https://images.pokemontcg.io/hgss3/71_hires.png', NULL),
    (72, 'Defender', 'common', 'https://images.pokemontcg.io/hgss3/72_hires.png', NULL),
    (73, 'Energy Exchanger', 'common', 'https://images.pokemontcg.io/hgss3/73_hires.png', NULL),
    (74, 'Flower Shop Lady', 'common', 'https://images.pokemontcg.io/hgss3/74_hires.png', NULL),
    (75, 'Legend Box', 'common', 'https://images.pokemontcg.io/hgss3/75_hires.png', NULL),
    (76, 'Ruins of Alph', 'common', 'https://images.pokemontcg.io/hgss3/76_hires.png', NULL),
    (77, 'Sage''s Training', 'common', 'https://images.pokemontcg.io/hgss3/77_hires.png', NULL),
    (78, 'Team Rocket''s Trickery', 'common', 'https://images.pokemontcg.io/hgss3/78_hires.png', NULL),
    (79, 'Darkness Energy', 'common', 'https://images.pokemontcg.io/hgss3/79_hires.png', NULL),
    (80, 'Metal Energy', 'common', 'https://images.pokemontcg.io/hgss3/80_hires.png', NULL),
    (81, 'Espeon', 'double_rare', 'https://images.pokemontcg.io/hgss3/81_hires.png', 'psychic'),
    (82, 'Houndoom', 'double_rare', 'https://images.pokemontcg.io/hgss3/82_hires.png', 'darkness'),
    (83, 'Raichu', 'double_rare', 'https://images.pokemontcg.io/hgss3/83_hires.png', 'lightning'),
    (84, 'Scizor', 'double_rare', 'https://images.pokemontcg.io/hgss3/84_hires.png', 'metal'),
    (85, 'Slowking', 'double_rare', 'https://images.pokemontcg.io/hgss3/85_hires.png', 'psychic'),
    (86, 'Umbreon', 'double_rare', 'https://images.pokemontcg.io/hgss3/86_hires.png', 'darkness'),
    (87, 'Kyogre & Groudon LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss3/87_hires.png', 'water'),
    (88, 'Kyogre & Groudon LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss3/88_hires.png', 'water'),
    (89, 'Rayquaza & Deoxys LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss3/89_hires.png', 'colorless'),
    (90, 'Rayquaza & Deoxys LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss3/90_hires.png', 'colorless'),
    (501000, 'Alph Lithograph', 'mega_hyper_rare', 'https://images.pokemontcg.io/hgss3/THREE_hires.png', NULL)
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

-- Set: HS—Triumphant (hgss4) -- 2010/11/03
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('heartgold-soulsilver', 'HeartGold & SoulSilver', 'hs-triumphant', 'HS—Triumphant', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'hs-triumphant'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Aggron', 'rare', 'https://images.pokemontcg.io/hgss4/1_hires.png', 'metal'),
    (2, 'Altaria', 'rare', 'https://images.pokemontcg.io/hgss4/2_hires.png', 'colorless'),
    (3, 'Celebi', 'rare', 'https://images.pokemontcg.io/hgss4/3_hires.png', 'psychic'),
    (4, 'Drapion', 'rare', 'https://images.pokemontcg.io/hgss4/4_hires.png', 'darkness'),
    (5, 'Mamoswine', 'rare', 'https://images.pokemontcg.io/hgss4/5_hires.png', 'water'),
    (6, 'Nidoking', 'rare', 'https://images.pokemontcg.io/hgss4/6_hires.png', 'fighting'),
    (7, 'Porygon-Z', 'rare', 'https://images.pokemontcg.io/hgss4/7_hires.png', 'colorless'),
    (8, 'Rapidash', 'rare', 'https://images.pokemontcg.io/hgss4/8_hires.png', 'fire'),
    (9, 'Solrock', 'rare', 'https://images.pokemontcg.io/hgss4/9_hires.png', 'fighting'),
    (10, 'Spiritomb', 'rare', 'https://images.pokemontcg.io/hgss4/10_hires.png', 'psychic'),
    (11, 'Venomoth', 'rare', 'https://images.pokemontcg.io/hgss4/11_hires.png', 'grass'),
    (12, 'Victreebel', 'rare', 'https://images.pokemontcg.io/hgss4/12_hires.png', 'grass'),
    (13, 'Ambipom', 'rare', 'https://images.pokemontcg.io/hgss4/13_hires.png', 'colorless'),
    (14, 'Banette', 'rare', 'https://images.pokemontcg.io/hgss4/14_hires.png', 'psychic'),
    (15, 'Bronzong', 'rare', 'https://images.pokemontcg.io/hgss4/15_hires.png', 'metal'),
    (16, 'Carnivine', 'rare', 'https://images.pokemontcg.io/hgss4/16_hires.png', 'grass'),
    (17, 'Ditto', 'rare', 'https://images.pokemontcg.io/hgss4/17_hires.png', 'colorless'),
    (18, 'Dragonite', 'rare', 'https://images.pokemontcg.io/hgss4/18_hires.png', 'colorless'),
    (19, 'Dugtrio', 'rare', 'https://images.pokemontcg.io/hgss4/19_hires.png', 'fighting'),
    (20, 'Electivire', 'rare', 'https://images.pokemontcg.io/hgss4/20_hires.png', 'lightning'),
    (21, 'Elekid', 'rare', 'https://images.pokemontcg.io/hgss4/21_hires.png', 'lightning'),
    (22, 'Golduck', 'rare', 'https://images.pokemontcg.io/hgss4/22_hires.png', 'water'),
    (23, 'Grumpig', 'rare', 'https://images.pokemontcg.io/hgss4/23_hires.png', 'psychic'),
    (24, 'Kricketune', 'rare', 'https://images.pokemontcg.io/hgss4/24_hires.png', 'grass'),
    (25, 'Lunatone', 'rare', 'https://images.pokemontcg.io/hgss4/25_hires.png', 'fighting'),
    (26, 'Machamp', 'rare', 'https://images.pokemontcg.io/hgss4/26_hires.png', 'fighting'),
    (27, 'Magmortar', 'rare', 'https://images.pokemontcg.io/hgss4/27_hires.png', 'fire'),
    (28, 'Nidoqueen', 'rare', 'https://images.pokemontcg.io/hgss4/28_hires.png', 'psychic'),
    (29, 'Pidgeot', 'rare', 'https://images.pokemontcg.io/hgss4/29_hires.png', 'colorless'),
    (30, 'Sharpedo', 'rare', 'https://images.pokemontcg.io/hgss4/30_hires.png', 'darkness'),
    (31, 'Wailord', 'rare', 'https://images.pokemontcg.io/hgss4/31_hires.png', 'water'),
    (32, 'Dragonair', 'common', 'https://images.pokemontcg.io/hgss4/32_hires.png', 'colorless'),
    (33, 'Electabuzz', 'common', 'https://images.pokemontcg.io/hgss4/33_hires.png', 'lightning'),
    (34, 'Electrode', 'common', 'https://images.pokemontcg.io/hgss4/34_hires.png', 'lightning'),
    (35, 'Haunter', 'common', 'https://images.pokemontcg.io/hgss4/35_hires.png', 'psychic'),
    (36, 'Kangaskhan', 'common', 'https://images.pokemontcg.io/hgss4/36_hires.png', 'colorless'),
    (37, 'Lairon', 'common', 'https://images.pokemontcg.io/hgss4/37_hires.png', 'metal'),
    (38, 'Lickilicky', 'common', 'https://images.pokemontcg.io/hgss4/38_hires.png', 'colorless'),
    (39, 'Luvdisc', 'common', 'https://images.pokemontcg.io/hgss4/39_hires.png', 'water'),
    (40, 'Machoke', 'common', 'https://images.pokemontcg.io/hgss4/40_hires.png', 'fighting'),
    (41, 'Magby', 'common', 'https://images.pokemontcg.io/hgss4/41_hires.png', 'fire'),
    (42, 'Magmar', 'common', 'https://images.pokemontcg.io/hgss4/42_hires.png', 'fire'),
    (43, 'Magneton', 'common', 'https://images.pokemontcg.io/hgss4/43_hires.png', 'lightning'),
    (44, 'Marowak', 'common', 'https://images.pokemontcg.io/hgss4/44_hires.png', 'fighting'),
    (45, 'Nidorina', 'common', 'https://images.pokemontcg.io/hgss4/45_hires.png', 'psychic'),
    (46, 'Nidorino', 'common', 'https://images.pokemontcg.io/hgss4/46_hires.png', 'psychic'),
    (47, 'Pidgeotto', 'common', 'https://images.pokemontcg.io/hgss4/47_hires.png', 'colorless'),
    (48, 'Piloswine', 'common', 'https://images.pokemontcg.io/hgss4/48_hires.png', 'water'),
    (49, 'Porygon2', 'common', 'https://images.pokemontcg.io/hgss4/49_hires.png', 'colorless'),
    (50, 'Tentacruel', 'common', 'https://images.pokemontcg.io/hgss4/50_hires.png', 'water'),
    (51, 'Unown', 'common', 'https://images.pokemontcg.io/hgss4/51_hires.png', 'psychic'),
    (52, 'Wailmer', 'common', 'https://images.pokemontcg.io/hgss4/52_hires.png', 'water'),
    (53, 'Weepinbell', 'common', 'https://images.pokemontcg.io/hgss4/53_hires.png', 'grass'),
    (54, 'Yanmega', 'common', 'https://images.pokemontcg.io/hgss4/54_hires.png', 'grass'),
    (55, 'Aipom', 'common', 'https://images.pokemontcg.io/hgss4/55_hires.png', 'colorless'),
    (56, 'Aron', 'common', 'https://images.pokemontcg.io/hgss4/56_hires.png', 'metal'),
    (57, 'Bellsprout', 'common', 'https://images.pokemontcg.io/hgss4/57_hires.png', 'grass'),
    (58, 'Bronzor', 'common', 'https://images.pokemontcg.io/hgss4/58_hires.png', 'metal'),
    (59, 'Carvanha', 'common', 'https://images.pokemontcg.io/hgss4/59_hires.png', 'darkness'),
    (60, 'Cubone', 'common', 'https://images.pokemontcg.io/hgss4/60_hires.png', 'fighting'),
    (61, 'Diglett', 'common', 'https://images.pokemontcg.io/hgss4/61_hires.png', 'fighting'),
    (62, 'Dratini', 'common', 'https://images.pokemontcg.io/hgss4/62_hires.png', 'colorless'),
    (63, 'Gastly', 'common', 'https://images.pokemontcg.io/hgss4/63_hires.png', 'psychic'),
    (64, 'Illumise', 'common', 'https://images.pokemontcg.io/hgss4/64_hires.png', 'grass'),
    (65, 'Kricketot', 'common', 'https://images.pokemontcg.io/hgss4/65_hires.png', 'grass'),
    (66, 'Lickitung', 'common', 'https://images.pokemontcg.io/hgss4/66_hires.png', 'colorless'),
    (67, 'Machop', 'common', 'https://images.pokemontcg.io/hgss4/67_hires.png', 'fighting'),
    (68, 'Magnemite', 'common', 'https://images.pokemontcg.io/hgss4/68_hires.png', 'lightning'),
    (69, 'Nidoran ♀', 'common', 'https://images.pokemontcg.io/hgss4/69_hires.png', 'psychic'),
    (70, 'Nidoran ♂', 'common', 'https://images.pokemontcg.io/hgss4/70_hires.png', 'psychic'),
    (71, 'Pidgey', 'common', 'https://images.pokemontcg.io/hgss4/71_hires.png', 'colorless'),
    (72, 'Ponyta', 'common', 'https://images.pokemontcg.io/hgss4/72_hires.png', 'fire'),
    (73, 'Porygon', 'common', 'https://images.pokemontcg.io/hgss4/73_hires.png', 'colorless'),
    (74, 'Psyduck', 'common', 'https://images.pokemontcg.io/hgss4/74_hires.png', 'water'),
    (75, 'Shuppet', 'common', 'https://images.pokemontcg.io/hgss4/75_hires.png', 'psychic'),
    (76, 'Skorupi', 'common', 'https://images.pokemontcg.io/hgss4/76_hires.png', 'psychic'),
    (77, 'Spoink', 'common', 'https://images.pokemontcg.io/hgss4/77_hires.png', 'psychic'),
    (78, 'Swablu', 'common', 'https://images.pokemontcg.io/hgss4/78_hires.png', 'colorless'),
    (79, 'Swinub', 'common', 'https://images.pokemontcg.io/hgss4/79_hires.png', 'water'),
    (80, 'Tentacool', 'common', 'https://images.pokemontcg.io/hgss4/80_hires.png', 'water'),
    (81, 'Venonat', 'common', 'https://images.pokemontcg.io/hgss4/81_hires.png', 'grass'),
    (82, 'Volbeat', 'common', 'https://images.pokemontcg.io/hgss4/82_hires.png', 'grass'),
    (83, 'Voltorb', 'common', 'https://images.pokemontcg.io/hgss4/83_hires.png', 'lightning'),
    (84, 'Yanma', 'common', 'https://images.pokemontcg.io/hgss4/84_hires.png', 'grass'),
    (85, 'Black Belt', 'common', 'https://images.pokemontcg.io/hgss4/85_hires.png', NULL),
    (86, 'Indigo Plateau', 'common', 'https://images.pokemontcg.io/hgss4/86_hires.png', NULL),
    (87, 'Junk Arm', 'common', 'https://images.pokemontcg.io/hgss4/87_hires.png', NULL),
    (88, 'Seeker', 'common', 'https://images.pokemontcg.io/hgss4/88_hires.png', NULL),
    (89, 'Twins', 'common', 'https://images.pokemontcg.io/hgss4/89_hires.png', NULL),
    (90, 'Rescue Energy', 'common', 'https://images.pokemontcg.io/hgss4/90_hires.png', NULL),
    (91, 'Absol', 'double_rare', 'https://images.pokemontcg.io/hgss4/91_hires.png', 'darkness'),
    (92, 'Celebi', 'double_rare', 'https://images.pokemontcg.io/hgss4/92_hires.png', 'grass'),
    (93, 'Electrode', 'double_rare', 'https://images.pokemontcg.io/hgss4/93_hires.png', 'lightning'),
    (94, 'Gengar', 'double_rare', 'https://images.pokemontcg.io/hgss4/94_hires.png', 'psychic'),
    (95, 'Machamp', 'double_rare', 'https://images.pokemontcg.io/hgss4/95_hires.png', 'fighting'),
    (96, 'Magnezone', 'double_rare', 'https://images.pokemontcg.io/hgss4/96_hires.png', 'lightning'),
    (97, 'Mew', 'double_rare', 'https://images.pokemontcg.io/hgss4/97_hires.png', 'psychic'),
    (98, 'Yanmega', 'double_rare', 'https://images.pokemontcg.io/hgss4/98_hires.png', 'grass'),
    (99, 'Darkrai & Cresselia LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss4/99_hires.png', 'darkness'),
    (100, 'Darkrai & Cresselia LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss4/100_hires.png', 'darkness'),
    (101, 'Palkia & Dialga LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss4/101_hires.png', 'water'),
    (102, 'Palkia & Dialga LEGEND', 'ultra_rare', 'https://images.pokemontcg.io/hgss4/102_hires.png', 'water'),
    (501000, 'Alph Lithograph', 'mega_hyper_rare', 'https://images.pokemontcg.io/hgss4/FOUR_hires.png', NULL)
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

-- Set: Call of Legends (col1) -- 2011/02/09
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('heartgold-soulsilver', 'HeartGold & SoulSilver', 'call-of-legends', 'Call of Legends', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'call-of-legends'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Clefable', 'rare', 'https://images.pokemontcg.io/col1/1_hires.png', 'colorless'),
    (2, 'Deoxys', 'rare', 'https://images.pokemontcg.io/col1/2_hires.png', 'psychic'),
    (3, 'Dialga', 'rare', 'https://images.pokemontcg.io/col1/3_hires.png', 'metal'),
    (4, 'Espeon', 'rare', 'https://images.pokemontcg.io/col1/4_hires.png', 'psychic'),
    (5, 'Forretress', 'rare', 'https://images.pokemontcg.io/col1/5_hires.png', 'metal'),
    (6, 'Groudon', 'rare', 'https://images.pokemontcg.io/col1/6_hires.png', 'fighting'),
    (7, 'Gyarados', 'rare', 'https://images.pokemontcg.io/col1/7_hires.png', 'water'),
    (8, 'Hitmontop', 'rare', 'https://images.pokemontcg.io/col1/8_hires.png', 'fighting'),
    (9, 'Ho-Oh', 'rare', 'https://images.pokemontcg.io/col1/9_hires.png', 'fire'),
    (10, 'Houndoom', 'rare', 'https://images.pokemontcg.io/col1/10_hires.png', 'darkness'),
    (11, 'Jirachi', 'rare', 'https://images.pokemontcg.io/col1/11_hires.png', 'psychic'),
    (12, 'Kyogre', 'rare', 'https://images.pokemontcg.io/col1/12_hires.png', 'water'),
    (13, 'Leafeon', 'rare', 'https://images.pokemontcg.io/col1/13_hires.png', 'grass'),
    (14, 'Lucario', 'rare', 'https://images.pokemontcg.io/col1/14_hires.png', 'fighting'),
    (15, 'Lugia', 'rare', 'https://images.pokemontcg.io/col1/15_hires.png', 'water'),
    (16, 'Magmortar', 'rare', 'https://images.pokemontcg.io/col1/16_hires.png', 'fire'),
    (17, 'Ninetales', 'rare', 'https://images.pokemontcg.io/col1/17_hires.png', 'fire'),
    (18, 'Pachirisu', 'rare', 'https://images.pokemontcg.io/col1/18_hires.png', 'lightning'),
    (19, 'Palkia', 'rare', 'https://images.pokemontcg.io/col1/19_hires.png', 'water'),
    (20, 'Rayquaza', 'rare', 'https://images.pokemontcg.io/col1/20_hires.png', 'colorless'),
    (21, 'Smeargle', 'rare', 'https://images.pokemontcg.io/col1/21_hires.png', 'colorless'),
    (22, 'Umbreon', 'rare', 'https://images.pokemontcg.io/col1/22_hires.png', 'darkness'),
    (23, 'Ampharos', 'rare', 'https://images.pokemontcg.io/col1/23_hires.png', 'lightning'),
    (24, 'Cleffa', 'rare', 'https://images.pokemontcg.io/col1/24_hires.png', 'colorless'),
    (25, 'Feraligatr', 'rare', 'https://images.pokemontcg.io/col1/25_hires.png', 'water'),
    (26, 'Granbull', 'rare', 'https://images.pokemontcg.io/col1/26_hires.png', 'colorless'),
    (27, 'Meganium', 'rare', 'https://images.pokemontcg.io/col1/27_hires.png', 'grass'),
    (28, 'Mismagius', 'rare', 'https://images.pokemontcg.io/col1/28_hires.png', 'psychic'),
    (29, 'Mr. Mime', 'rare', 'https://images.pokemontcg.io/col1/29_hires.png', 'psychic'),
    (30, 'Pidgeot', 'rare', 'https://images.pokemontcg.io/col1/30_hires.png', 'colorless'),
    (31, 'Skarmory', 'rare', 'https://images.pokemontcg.io/col1/31_hires.png', 'metal'),
    (32, 'Slowking', 'rare', 'https://images.pokemontcg.io/col1/32_hires.png', 'psychic'),
    (33, 'Snorlax', 'rare', 'https://images.pokemontcg.io/col1/33_hires.png', 'colorless'),
    (34, 'Tangrowth', 'rare', 'https://images.pokemontcg.io/col1/34_hires.png', 'grass'),
    (35, 'Typhlosion', 'rare', 'https://images.pokemontcg.io/col1/35_hires.png', 'fire'),
    (36, 'Tyrogue', 'rare', 'https://images.pokemontcg.io/col1/36_hires.png', 'fighting'),
    (37, 'Ursaring', 'rare', 'https://images.pokemontcg.io/col1/37_hires.png', 'colorless'),
    (38, 'Weezing', 'rare', 'https://images.pokemontcg.io/col1/38_hires.png', 'psychic'),
    (39, 'Zangoose', 'rare', 'https://images.pokemontcg.io/col1/39_hires.png', 'colorless'),
    (40, 'Bayleef', 'common', 'https://images.pokemontcg.io/col1/40_hires.png', 'grass'),
    (41, 'Croconaw', 'common', 'https://images.pokemontcg.io/col1/41_hires.png', 'water'),
    (42, 'Donphan', 'common', 'https://images.pokemontcg.io/col1/42_hires.png', 'fighting'),
    (43, 'Flaaffy', 'common', 'https://images.pokemontcg.io/col1/43_hires.png', 'lightning'),
    (44, 'Flareon', 'common', 'https://images.pokemontcg.io/col1/44_hires.png', 'fire'),
    (45, 'Jolteon', 'common', 'https://images.pokemontcg.io/col1/45_hires.png', 'lightning'),
    (46, 'Magby', 'common', 'https://images.pokemontcg.io/col1/46_hires.png', 'fire'),
    (47, 'Mime Jr.', 'common', 'https://images.pokemontcg.io/col1/47_hires.png', 'psychic'),
    (48, 'Pidgeotto', 'common', 'https://images.pokemontcg.io/col1/48_hires.png', 'colorless'),
    (49, 'Quilava', 'common', 'https://images.pokemontcg.io/col1/49_hires.png', 'fire'),
    (50, 'Riolu', 'common', 'https://images.pokemontcg.io/col1/50_hires.png', 'fighting'),
    (51, 'Seviper', 'common', 'https://images.pokemontcg.io/col1/51_hires.png', 'psychic'),
    (52, 'Vaporeon', 'common', 'https://images.pokemontcg.io/col1/52_hires.png', 'water'),
    (53, 'Chikorita', 'common', 'https://images.pokemontcg.io/col1/53_hires.png', 'grass'),
    (54, 'Clefairy', 'common', 'https://images.pokemontcg.io/col1/54_hires.png', 'colorless'),
    (55, 'Cyndaquil', 'common', 'https://images.pokemontcg.io/col1/55_hires.png', 'fire'),
    (56, 'Eevee', 'common', 'https://images.pokemontcg.io/col1/56_hires.png', 'colorless'),
    (57, 'Hitmonchan', 'common', 'https://images.pokemontcg.io/col1/57_hires.png', 'fighting'),
    (58, 'Hitmonlee', 'common', 'https://images.pokemontcg.io/col1/58_hires.png', 'fighting'),
    (59, 'Houndour', 'common', 'https://images.pokemontcg.io/col1/59_hires.png', 'darkness'),
    (60, 'Koffing', 'common', 'https://images.pokemontcg.io/col1/60_hires.png', 'psychic'),
    (61, 'Magikarp', 'common', 'https://images.pokemontcg.io/col1/61_hires.png', 'water'),
    (62, 'Magmar', 'common', 'https://images.pokemontcg.io/col1/62_hires.png', 'fire'),
    (63, 'Mareep', 'common', 'https://images.pokemontcg.io/col1/63_hires.png', 'lightning'),
    (64, 'Mawile', 'common', 'https://images.pokemontcg.io/col1/64_hires.png', 'metal'),
    (65, 'Misdreavus', 'common', 'https://images.pokemontcg.io/col1/65_hires.png', 'psychic'),
    (66, 'Phanpy', 'common', 'https://images.pokemontcg.io/col1/66_hires.png', 'fighting'),
    (67, 'Pidgey', 'common', 'https://images.pokemontcg.io/col1/67_hires.png', 'colorless'),
    (68, 'Pineco', 'common', 'https://images.pokemontcg.io/col1/68_hires.png', 'grass'),
    (69, 'Relicanth', 'common', 'https://images.pokemontcg.io/col1/69_hires.png', 'water'),
    (70, 'Slowpoke', 'common', 'https://images.pokemontcg.io/col1/70_hires.png', 'water'),
    (71, 'Snubbull', 'common', 'https://images.pokemontcg.io/col1/71_hires.png', 'colorless'),
    (72, 'Tangela', 'common', 'https://images.pokemontcg.io/col1/72_hires.png', 'grass'),
    (73, 'Teddiursa', 'common', 'https://images.pokemontcg.io/col1/73_hires.png', 'colorless'),
    (74, 'Totodile', 'common', 'https://images.pokemontcg.io/col1/74_hires.png', 'water'),
    (75, 'Vulpix', 'common', 'https://images.pokemontcg.io/col1/75_hires.png', 'fire'),
    (76, 'Cheerleader''s Cheer', 'common', 'https://images.pokemontcg.io/col1/76_hires.png', NULL),
    (77, 'Copycat', 'common', 'https://images.pokemontcg.io/col1/77_hires.png', NULL),
    (78, 'Dual Ball', 'common', 'https://images.pokemontcg.io/col1/78_hires.png', NULL),
    (79, 'Interviewer''s Questions', 'common', 'https://images.pokemontcg.io/col1/79_hires.png', NULL),
    (80, 'Lost Remover', 'common', 'https://images.pokemontcg.io/col1/80_hires.png', NULL),
    (81, 'Lost World', 'common', 'https://images.pokemontcg.io/col1/81_hires.png', NULL),
    (82, 'Professor Elm''s Training Method', 'common', 'https://images.pokemontcg.io/col1/82_hires.png', NULL),
    (83, 'Professor Oak''s New Theory', 'common', 'https://images.pokemontcg.io/col1/83_hires.png', NULL),
    (84, 'Research Record', 'common', 'https://images.pokemontcg.io/col1/84_hires.png', NULL),
    (85, 'Sage''s Training', 'common', 'https://images.pokemontcg.io/col1/85_hires.png', NULL),
    (86, 'Darkness Energy', 'common', 'https://images.pokemontcg.io/col1/86_hires.png', NULL),
    (87, 'Metal Energy', 'common', 'https://images.pokemontcg.io/col1/87_hires.png', NULL),
    (88, 'Grass Energy', 'common', 'https://images.pokemontcg.io/col1/88_hires.png', NULL),
    (89, 'Fire Energy', 'common', 'https://images.pokemontcg.io/col1/89_hires.png', NULL),
    (90, 'Water Energy', 'common', 'https://images.pokemontcg.io/col1/90_hires.png', NULL),
    (91, 'Lightning Energy', 'common', 'https://images.pokemontcg.io/col1/91_hires.png', NULL),
    (92, 'Psychic Energy', 'common', 'https://images.pokemontcg.io/col1/92_hires.png', NULL),
    (93, 'Fighting Energy', 'common', 'https://images.pokemontcg.io/col1/93_hires.png', NULL),
    (94, 'Darkness Energy', 'common', 'https://images.pokemontcg.io/col1/94_hires.png', NULL),
    (95, 'Metal Energy', 'common', 'https://images.pokemontcg.io/col1/95_hires.png', NULL),
    (501001, 'Deoxys', 'rare', 'https://images.pokemontcg.io/col1/SL1_hires.png', 'psychic'),
    (501002, 'Dialga', 'rare', 'https://images.pokemontcg.io/col1/SL2_hires.png', 'metal'),
    (501003, 'Entei', 'rare', 'https://images.pokemontcg.io/col1/SL3_hires.png', 'fire'),
    (501004, 'Groudon', 'rare', 'https://images.pokemontcg.io/col1/SL4_hires.png', 'fighting'),
    (501005, 'Ho-Oh', 'rare', 'https://images.pokemontcg.io/col1/SL5_hires.png', 'fire'),
    (501006, 'Kyogre', 'rare', 'https://images.pokemontcg.io/col1/SL6_hires.png', 'water'),
    (501007, 'Lugia', 'rare', 'https://images.pokemontcg.io/col1/SL7_hires.png', 'water'),
    (501008, 'Palkia', 'rare', 'https://images.pokemontcg.io/col1/SL8_hires.png', 'water'),
    (501009, 'Raikou', 'rare', 'https://images.pokemontcg.io/col1/SL9_hires.png', 'lightning'),
    (501010, 'Rayquaza', 'rare', 'https://images.pokemontcg.io/col1/SL10_hires.png', 'colorless'),
    (501011, 'Suicune', 'rare', 'https://images.pokemontcg.io/col1/SL11_hires.png', 'water')
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
