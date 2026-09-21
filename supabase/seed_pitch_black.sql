-- Seed data for Mega Evolution > Pitch Black (ME05), 120 cards.
-- Run this once in the Supabase SQL editor after schema.sql.
-- Stock defaults to 0 for every variant -- cards stay greyed out on the
-- storefront until you set real stock numbers in the Supabase table editor
-- (table: card_variants). Prices are rough starting defaults by rarity tier
-- (SEK) -- edit any of them later, they're just a starting point.

with s as (
  insert into sets (category_slug, category_name, slug, name)
  values ('mega-evolution', 'Mega Evolution', 'pitch-black', 'Pitch Black')
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Tropius', 'common'),
  (2, 'Grubbin', 'common'),
  (3, 'Fomantis', 'common'),
  (4, 'Lurantis ex', 'common'),
  (5, 'Poltchageist', 'common'),
  (6, 'Sinistcha', 'common'),
  (7, 'Heatran', 'common'),
  (8, 'Mega Delphox ex', 'common'),
  (9, 'Sizzlipede', 'common'),
  (10, 'Centiskorch', 'common'),
  (11, 'Charcadet', 'common'),
  (12, 'Armarouge', 'common'),
  (13, 'Goldeen', 'common'),
  (14, 'Seaking', 'common'),
  (15, 'Wailmer', 'common'),
  (16, 'Wailord ex', 'common'),
  (17, 'Relicanth', 'common'),
  (18, 'Popplio', 'common'),
  (19, 'Brionne', 'common'),
  (20, 'Primarina', 'common'),
  (21, 'Finizen', 'common'),
  (22, 'Palafin', 'common'),
  (23, 'Electrike', 'common'),
  (24, 'Manectric', 'common'),
  (25, 'Charjabug', 'common'),
  (26, 'Vikavolt', 'common'),
  (27, 'Mega Zeraora ex', 'common'),
  (28, 'Miraidon', 'common'),
  (29, 'Slowpoke', 'common'),
  (30, 'Slowbro', 'common'),
  (31, 'Mega Slowbro ex', 'common'),
  (32, 'Jynx', 'common'),
  (33, 'Shuppet', 'common'),
  (34, 'Banette', 'common'),
  (35, 'Spiritomb', 'common'),
  (36, 'Litwick', 'common'),
  (37, 'Lampent', 'common'),
  (38, 'Mega Chandelure ex', 'common'),
  (39, 'Dhelmise', 'common'),
  (40, 'Marshadow', 'common'),
  (41, 'Annihilape', 'common'),
  (42, 'Mankey', 'common'),
  (43, 'Primeape', 'common'),
  (44, 'Cranidos', 'common'),
  (45, 'Rampardos ex', 'common'),
  (46, 'Drilbur', 'common'),
  (47, 'Koraidon', 'common'),
  (48, 'Mega Darkrai ex', 'common'),
  (49, 'Vullaby', 'common'),
  (50, 'Mandibuzz', 'common'),
  (51, 'Inkay', 'common'),
  (52, 'Malamar', 'common'),
  (53, 'Nickit', 'common'),
  (54, 'Thievul', 'common'),
  (55, 'Morpeko ex', 'common'),
  (56, 'Zarude', 'common'),
  (57, 'Maschiff', 'common'),
  (58, 'Mabosstiff', 'common'),
  (59, 'Chi-Yu', 'common'),
  (60, 'Skarmory', 'common'),
  (61, 'Shieldon', 'common'),
  (62, 'Bastiodon', 'common'),
  (63, 'Bronzor', 'common'),
  (64, 'Bronzong', 'common'),
  (65, 'Mega Excadrill ex', 'common'),
  (66, 'Pikipek', 'common'),
  (67, 'Trumbeak', 'common'),
  (68, 'Toucannon', 'common'),
  (69, 'Type: Null', 'common'),
  (70, 'Silvally', 'common'),
  (71, 'Bombirdier', 'common'),
  (72, 'Antique Armor Fossil', 'common'),
  (73, 'Antique Skull Fossil', 'common'),
  (74, 'Backtrack Badge', 'common'),
  (75, 'Dark Bell', 'common'),
  (76, 'Fossil Quarry', 'common'),
  (77, 'Gladion''s Final Battle', 'common'),
  (78, 'Gwynn', 'common'),
  (79, 'Jett', 'common'),
  (80, 'Misty''s Vitality', 'common'),
  (81, 'Rust Syndicate Grunt', 'common'),
  (82, 'Tremendous Bomb', 'common'),
  (83, 'Shadowy Darkness Energy', 'common'),
  (84, 'Voltaic Lightning Energy', 'common'),
  (85, 'Fomantis', 'illustration_rare'),
  (86, 'Armarouge', 'illustration_rare'),
  (87, 'Goldeen', 'illustration_rare'),
  (88, 'Primarina', 'illustration_rare'),
  (89, 'Manectric', 'illustration_rare'),
  (90, 'Slowbro', 'illustration_rare'),
  (91, 'Dhelmise', 'illustration_rare'),
  (92, 'Thievul', 'illustration_rare'),
  (93, 'Bastiodon', 'illustration_rare'),
  (94, 'Toucannon', 'illustration_rare'),
  (95, 'Silvally', 'illustration_rare'),
  (96, 'Lurantis ex', 'ultra_rare'),
  (97, 'Wailord ex', 'ultra_rare'),
  (98, 'Mega Zeraora ex', 'ultra_rare'),
  (99, 'Mega Chandelure ex', 'ultra_rare'),
  (100, 'Rampardos ex', 'ultra_rare'),
  (101, 'Mega Darkrai ex', 'ultra_rare'),
  (102, 'Morpeko ex', 'ultra_rare'),
  (103, 'Mega Excadrill ex', 'ultra_rare'),
  (104, 'Brave Bangle', 'ultra_rare'),
  (105, 'Crushing Hammer', 'ultra_rare'),
  (106, 'Dark Bell', 'ultra_rare'),
  (107, 'Energy Switch', 'ultra_rare'),
  (108, 'Gladion''s Final Battle', 'ultra_rare'),
  (109, 'Gwynn', 'ultra_rare'),
  (110, 'Iron Defender', 'ultra_rare'),
  (111, 'Misty''s Vitality', 'ultra_rare'),
  (112, 'Rust Syndicate Grunt', 'ultra_rare'),
  (113, 'Tremendous Bomb', 'ultra_rare'),
  (114, 'Mega Zeraora ex', 'special_illustration_rare'),
  (115, 'Mega Chandelure ex', 'special_illustration_rare'),
  (116, 'Mega Darkrai ex', 'special_illustration_rare'),
  (117, 'Morpeko ex', 'special_illustration_rare'),
  (118, 'Gladion''s Final Battle', 'special_illustration_rare'),
  (119, 'Gwynn', 'special_illustration_rare'),
  (120, 'Mega Darkrai ex', 'mega_hyper_rare')
  ) as v(number, name, rarity)
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant,
  case
      when ic.rarity = 'common' and x.variant = 'holo' then 4
      when ic.rarity = 'common' then 2
      when ic.rarity = 'illustration_rare' then 15
      when ic.rarity = 'ultra_rare' then 20
      when ic.rarity = 'special_illustration_rare' then 0
      when ic.rarity = 'mega_hyper_rare' then 0
    else 0
  end as price_sek,
  0 as stock
from inserted_cards ic
cross join (values ('normal'), ('holo')) as x(variant);
