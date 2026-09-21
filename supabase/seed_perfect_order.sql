-- Seed data for Mega Evolution > Perfect Order, 124 cards.
-- Run this once in the Supabase SQL editor after schema.sql AND
-- set_visibility.sql (this seed sets the new set to hidden by default).
-- Stock defaults to 0 for every variant -- cards stay greyed out on the
-- storefront (and the whole set stays hidden) until you set real stock
-- numbers and flip visibility on in /admin. Prices are rough starting
-- defaults by rarity tier (SEK) -- edit any of them later.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('mega-evolution', 'Mega Evolution', 'perfect-order', 'Perfect Order', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Spinarak', 'common'),
  (2, 'Ariados', 'common'),
  (3, 'Shaymin', 'common'),
  (4, 'Snivy', 'common'),
  (5, 'Servine', 'common'),
  (6, 'Serperior', 'common'),
  (7, 'Scatterbug', 'common'),
  (8, 'Spewpa', 'common'),
  (9, 'Vivillon', 'common'),
  (10, 'Rowlet', 'common'),
  (11, 'Dartrix', 'common'),
  (12, 'Decidueye ex', 'common'),
  (13, 'Fletchinder', 'common'),
  (14, 'Talonflame', 'common'),
  (15, 'Salandit', 'common'),
  (16, 'Salazzle ex', 'common'),
  (17, 'Turtonator', 'common'),
  (18, 'Seel', 'common'),
  (19, 'Dewgong', 'common'),
  (20, 'Staryu', 'common'),
  (21, 'Mega Starmie ex', 'common'),
  (22, 'Lapras ex', 'common'),
  (23, 'Amaura', 'common'),
  (24, 'Aurorus', 'common'),
  (25, 'Volcanion', 'common'),
  (26, 'Shinx', 'common'),
  (27, 'Luxio', 'common'),
  (28, 'Luxray', 'common'),
  (29, 'Dedenne', 'common'),
  (30, 'Clefairy', 'common'),
  (31, 'Mega Clefable ex', 'common'),
  (32, 'Mawile', 'common'),
  (33, 'Espurr', 'common'),
  (34, 'Meowstic', 'common'),
  (35, 'Spritzee', 'common'),
  (36, 'Aromatisse', 'common'),
  (37, 'Nosepass', 'common'),
  (38, 'Probopass', 'common'),
  (39, 'Hippopotas', 'common'),
  (40, 'Hippowdon', 'common'),
  (41, 'Landorus', 'common'),
  (42, 'Binacle', 'common'),
  (43, 'Barbaracle', 'common'),
  (44, 'Tyrunt', 'common'),
  (45, 'Tyrantrum', 'common'),
  (46, 'Hawlucha', 'common'),
  (47, 'Mega Zygarde ex', 'common'),
  (48, 'Gastly', 'common'),
  (49, 'Haunter', 'common'),
  (50, 'Gengar', 'common'),
  (51, 'Skorupi', 'common'),
  (52, 'Drapion', 'common'),
  (53, 'Yveltal ex', 'common'),
  (54, 'Chien-Pao', 'common'),
  (55, 'Mega Skarmory ex', 'common'),
  (56, 'Honedge', 'common'),
  (57, 'Doublade', 'common'),
  (58, 'Aegislash', 'common'),
  (59, 'Klefki', 'common'),
  (60, 'Rattata', 'common'),
  (61, 'Raticate', 'common'),
  (62, 'Meowth ex', 'common'),
  (63, 'Snorlax', 'common'),
  (64, 'Bunnelby', 'common'),
  (65, 'Diggersby', 'common'),
  (66, 'Fletchling', 'common'),
  (67, 'Furfrou', 'common'),
  (68, 'Antique Jaw Fossil', 'common'),
  (69, 'Antique Sail Fossil', 'common'),
  (70, 'Core Memory', 'common'),
  (71, 'Crushing Hammer', 'common'),
  (72, 'Energy Search', 'common'),
  (73, 'Energy Swatter', 'common'),
  (74, 'Hole-Digging Shovel', 'common'),
  (75, 'Jacinthe', 'common'),
  (76, 'Judge', 'common'),
  (77, 'Lumiose City', 'common'),
  (78, 'Lumiose Galette', 'common'),
  (79, 'Naveen', 'common'),
  (80, 'Poke Ball', 'common'),
  (81, 'Poke Pad', 'common'),
  (82, 'Pokemon Catcher', 'common'),
  (83, 'Potion', 'common'),
  (84, 'Rosa''s Encouragement', 'common'),
  (85, 'Tarragon', 'common'),
  (86, 'Growing Grass Energy', 'common'),
  (87, 'Rocky Fighting Energy', 'common'),
  (88, 'Telepathic Psychic Energy', 'common'),
  (89, 'Spewpa', 'illustration_rare'),
  (90, 'Rowlet', 'illustration_rare'),
  (91, 'Talonflame', 'illustration_rare'),
  (92, 'Aurorus', 'illustration_rare'),
  (93, 'Dedenne', 'illustration_rare'),
  (94, 'Clefairy', 'illustration_rare'),
  (95, 'Espurr', 'illustration_rare'),
  (96, 'Probopass', 'illustration_rare'),
  (97, 'Drapion', 'illustration_rare'),
  (98, 'Doublade', 'illustration_rare'),
  (99, 'Raticate', 'illustration_rare'),
  (100, 'Decidueye ex', 'ultra_rare'),
  (101, 'Salazzle ex', 'ultra_rare'),
  (102, 'Mega Starmie ex', 'ultra_rare'),
  (103, 'Mega Clefable ex', 'ultra_rare'),
  (104, 'Mega Zygarde ex', 'ultra_rare'),
  (105, 'Yveltal ex', 'ultra_rare'),
  (106, 'Mega Skarmory ex', 'ultra_rare'),
  (107, 'Meowth ex', 'ultra_rare'),
  (108, 'Energy Recycler', 'ultra_rare'),
  (109, 'Forest of Vitality', 'ultra_rare'),
  (110, 'Jacinthe', 'ultra_rare'),
  (111, 'Lumiose City', 'ultra_rare'),
  (112, 'Naveen', 'ultra_rare'),
  (113, 'Poke Pad', 'ultra_rare'),
  (114, 'Rosa''s Encouragement', 'ultra_rare'),
  (115, 'Sacred Ash', 'ultra_rare'),
  (116, 'Tarragon', 'ultra_rare'),
  (117, 'Wondrous Patch', 'ultra_rare'),
  (118, 'Mega Starmie ex', 'special_illustration_rare'),
  (119, 'Mega Clefable ex', 'special_illustration_rare'),
  (120, 'Mega Zygarde ex', 'special_illustration_rare'),
  (121, 'Meowth ex', 'special_illustration_rare'),
  (122, 'Jacinthe', 'special_illustration_rare'),
  (123, 'Rosa''s Encouragement', 'special_illustration_rare'),
  (124, 'Mega Zygarde ex', 'mega_hyper_rare')
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
