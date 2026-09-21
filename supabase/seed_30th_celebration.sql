-- Seed data for 30th Celebration, 158 cards (numbers 1-158:
-- the 128-card main set plus all 30 confirmed secret rares -- 18
-- Illustration Rare, 10 Special Illustration Rare, 2 Futuristic Rare).
--
-- NOT included here (add by hand via "+ Nytt kort" if/when you get them):
--   - The 30-card Classic Collection. These reprints keep their ORIGINAL
--     numbers from whichever old set they come from (e.g. Base Set
--     Charizard stays "4/102"), so they don't fit this set's 1-158
--     numbering and need their own numbers when added.
--   - The 8 Basic Energy cards (their own separate numbering).
--   - The 3 unconfirmed "RGB Mew" secret rares (red/green/blue), which
--     Pokémon has not officially acknowledged as of this writing.
--
-- Run this once in the Supabase SQL editor after schema.sql AND
-- set_visibility.sql. Stock defaults to 0 -- cards stay greyed out (and
-- the whole set hidden) until you set real stock in /admin. "Futuristic
-- Rare" (157-158) is filed under the existing mega_hyper_rare tier since
-- it's this set's equivalent top-tier gold rarity.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('30th-celebration', '30th Celebration', '30th-celebration', '30th Celebration', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Exeggcute', 'common'),
  (2, 'Alolan Exeggutor', 'common'),
  (3, 'Volbeat', 'common'),
  (4, 'Illumise', 'common'),
  (5, 'Tropius', 'common'),
  (6, 'Cherubi', 'common'),
  (7, 'Cherrim', 'common'),
  (8, 'Vivillon', 'common'),
  (9, 'Vulpix', 'common'),
  (10, 'Ninetales', 'common'),
  (11, 'Moltres', 'common'),
  (12, 'Ho-Oh', 'common'),
  (13, 'Victini', 'common'),
  (14, 'Reshiram', 'common'),
  (15, 'Fuecoco ex', 'common'),
  (16, 'Slowpoke', 'common'),
  (17, 'Lapras', 'common'),
  (18, 'Articuno', 'common'),
  (19, 'Kyogre', 'common'),
  (20, 'Palkia', 'common'),
  (21, 'Greninja ex', 'common'),
  (22, 'Wishiwashi', 'common'),
  (23, 'Pikachu (01/30)', 'common'),
  (24, 'Pikachu (02/30)', 'common'),
  (25, 'Pikachu (03/30)', 'common'),
  (26, 'Pikachu (04/30)', 'common'),
  (27, 'Pikachu (05/30)', 'common'),
  (28, 'Pikachu (06/30)', 'common'),
  (29, 'Pikachu (07/30)', 'common'),
  (30, 'Pikachu (08/30)', 'common'),
  (31, 'Pikachu (09/30)', 'common'),
  (32, 'Pikachu (10/30)', 'common'),
  (33, 'Pikachu (11/30)', 'common'),
  (34, 'Pikachu (12/30)', 'common'),
  (35, 'Pikachu (13/30)', 'common'),
  (36, 'Pikachu (14/30)', 'common'),
  (37, 'Pikachu (15/30)', 'common'),
  (38, 'Pikachu (16/30)', 'common'),
  (39, 'Pikachu (17/30)', 'common'),
  (40, 'Pikachu (18/30)', 'common'),
  (41, 'Pikachu (19/30)', 'common'),
  (42, 'Pikachu (20/30)', 'common'),
  (43, 'Pikachu (21/30)', 'common'),
  (44, 'Pikachu (22/30)', 'common'),
  (45, 'Pikachu (23/30)', 'common'),
  (46, 'Pikachu (24/30)', 'common'),
  (47, 'Pikachu (25/30)', 'common'),
  (48, 'Pikachu (26/30)', 'common'),
  (49, 'Pikachu (27/30)', 'common'),
  (50, 'Pikachu (28/30)', 'common'),
  (51, 'Pikachu (29/30)', 'common'),
  (52, 'Pikachu (30/30)', 'common'),
  (53, 'Pikachu ex (day)', 'common'),
  (54, 'Pikachu ex (night)', 'common'),
  (55, 'Zapdos', 'common'),
  (56, 'Zekrom', 'common'),
  (57, 'Zeraora', 'common'),
  (58, 'Toxel', 'common'),
  (59, 'Toxtricity (Low Key)', 'common'),
  (60, 'Toxtricity (Amped)', 'common'),
  (61, 'Morpeko', 'common'),
  (62, 'Miraidon', 'common'),
  (63, 'Mewtwo', 'common'),
  (64, 'Mewtwo ex', 'common'),
  (65, 'Mew', 'common'),
  (66, 'Mew ex', 'common'),
  (67, 'Marill', 'common'),
  (68, 'Azumarill', 'common'),
  (69, 'Espeon', 'common'),
  (70, 'Espeon ex', 'common'),
  (71, 'Sylveon ex', 'common'),
  (72, 'Unown', 'common'),
  (73, 'Drifloon', 'common'),
  (74, 'Cresselia', 'common'),
  (75, 'Chandelure', 'common'),
  (76, 'Xerneas', 'common'),
  (77, 'Comfey', 'common'),
  (78, 'Cosmog', 'common'),
  (79, 'Cosmoem', 'common'),
  (80, 'Lunala', 'common'),
  (81, 'Gimmighoul', 'common'),
  (82, 'Groudon', 'common'),
  (83, 'Lucario', 'common'),
  (84, 'Seismitoad', 'common'),
  (85, 'Lycanroc', 'common'),
  (86, 'Koraidon', 'common'),
  (87, 'Nidoran F', 'common'),
  (88, 'Nidorina', 'common'),
  (89, 'Alolan Meowth', 'common'),
  (90, 'Gengar ex', 'common'),
  (91, 'Umbreon', 'common'),
  (92, 'Umbreon ex', 'common'),
  (93, 'Murkrow', 'common'),
  (94, 'Scraggy', 'common'),
  (95, 'Zorua', 'common'),
  (96, 'Zoroark', 'common'),
  (97, 'Deino', 'common'),
  (98, 'Zweilous', 'common'),
  (99, 'Hydreigon', 'common'),
  (100, 'Yveltal', 'common'),
  (101, 'Galarian Meowth', 'common'),
  (102, 'Jirachi ex', 'common'),
  (103, 'Dialga', 'common'),
  (104, 'Ferrothorn', 'common'),
  (105, 'Solgaleo', 'common'),
  (106, 'Zacian', 'common'),
  (107, 'Zamazenta', 'common'),
  (108, 'Gholdengo', 'common'),
  (109, 'Salamence ex', 'common'),
  (110, 'Jangmo-o', 'common'),
  (111, 'Hakamo-o', 'common'),
  (112, 'Kommo-o', 'common'),
  (113, 'Meowth', 'common'),
  (114, 'Kangaskhan', 'common'),
  (115, 'Ditto', 'common'),
  (116, 'Eevee', 'common'),
  (117, 'Eevee', 'common'),
  (118, 'Eevee', 'common'),
  (119, 'Snorlax', 'common'),
  (120, 'Igglybuff', 'common'),
  (121, 'Lugia', 'common'),
  (122, 'Hisuian Zorua', 'common'),
  (123, 'Hisuian Zoroark', 'common'),
  (124, 'Minior', 'common'),
  (125, 'Maushold', 'common'),
  (126, 'Poke Pad', 'common'),
  (127, 'Switch', 'common'),
  (128, 'Ultra Ball', 'common'),
  (129, 'Alolan Exeggutor', 'illustration_rare'),
  (130, 'Moltres', 'illustration_rare'),
  (131, 'Lapras', 'illustration_rare'),
  (132, 'Articuno', 'illustration_rare'),
  (133, 'Zapdos', 'illustration_rare'),
  (134, 'Toxtricity', 'illustration_rare'),
  (135, 'Morpeko', 'illustration_rare'),
  (136, 'Drifloon', 'illustration_rare'),
  (137, 'Chandelure', 'illustration_rare'),
  (138, 'Lycanroc', 'illustration_rare'),
  (139, 'Alolan Meowth', 'illustration_rare'),
  (140, 'Scraggy', 'illustration_rare'),
  (141, 'Galarian Meowth', 'illustration_rare'),
  (142, 'Gholdengo', 'illustration_rare'),
  (143, 'Kommo-o', 'illustration_rare'),
  (144, 'Meowth', 'illustration_rare'),
  (145, 'Hisuian Zorua', 'illustration_rare'),
  (146, 'Maushold', 'illustration_rare'),
  (147, 'Fuecoco ex', 'special_illustration_rare'),
  (148, 'Greninja ex', 'special_illustration_rare'),
  (149, 'Pikachu ex (day)', 'special_illustration_rare'),
  (150, 'Pikachu ex (night)', 'special_illustration_rare'),
  (151, 'Mewtwo ex', 'special_illustration_rare'),
  (152, 'Mew ex', 'special_illustration_rare'),
  (153, 'Sylveon ex', 'special_illustration_rare'),
  (154, 'Gengar ex', 'special_illustration_rare'),
  (155, 'Jirachi ex', 'special_illustration_rare'),
  (156, 'Salamence ex', 'special_illustration_rare'),
  (157, 'Mewtwo ex', 'mega_hyper_rare'),
  (158, 'Mew ex', 'mega_hyper_rare')
  ) as v(number, name, rarity)
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant,
  case
      when ic.rarity = 'common' and x.variant = 'holo' then 4
      when ic.rarity = 'common' then 2
      when ic.rarity = 'illustration_rare' then 15
      when ic.rarity = 'special_illustration_rare' then 0
      when ic.rarity = 'mega_hyper_rare' then 0
    else 0
  end as price_sek,
  0 as stock
from inserted_cards ic
cross join (values ('normal'), ('holo')) as x(variant);
