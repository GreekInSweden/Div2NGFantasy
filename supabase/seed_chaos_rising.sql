-- Seed data for Mega Evolution > Chaos Rising, 122 cards.
-- Run this once in the Supabase SQL editor after schema.sql AND
-- set_visibility.sql (this seed sets the new set to hidden by default).
-- Stock defaults to 0 for every variant -- cards stay greyed out on the
-- storefront (and the whole set stays hidden) until you set real stock
-- numbers and flip visibility on in /admin. Prices are rough starting
-- defaults by rarity tier (SEK) -- edit any of them later.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('mega-evolution', 'Mega Evolution', 'chaos-rising', 'Chaos Rising', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Weedle', 'common'),
  (2, 'Kakuna', 'common'),
  (3, 'Beedrill ex', 'common'),
  (4, 'Carnivine', 'common'),
  (5, 'Chespin', 'common'),
  (6, 'Quilladin', 'common'),
  (7, 'Chesnaught', 'common'),
  (8, 'Vulpix', 'common'),
  (9, 'Ninetales', 'common'),
  (10, 'Ho-Oh', 'common'),
  (11, 'Fennekin', 'common'),
  (12, 'Braixen', 'common'),
  (13, 'Delphox', 'common'),
  (14, 'Litleo', 'common'),
  (15, 'Mega Pyroar ex', 'common'),
  (16, 'Remoraid', 'common'),
  (17, 'Octillery', 'common'),
  (18, 'Delibird', 'common'),
  (19, 'Keldeo', 'common'),
  (20, 'Froakie', 'common'),
  (21, 'Frogadier', 'common'),
  (22, 'Mega Greninja ex', 'common'),
  (23, 'Bergmite', 'common'),
  (24, 'Avalugg', 'common'),
  (25, 'Wimpod', 'common'),
  (26, 'Golisopod', 'common'),
  (27, 'Mareep', 'common'),
  (28, 'Flaaffy', 'common'),
  (29, 'Ampharos', 'common'),
  (30, 'Emolga', 'common'),
  (31, 'Deoxys', 'common'),
  (32, 'Deoxys', 'common'),
  (33, 'Deoxys', 'common'),
  (34, 'Deoxys', 'common'),
  (35, 'Mega Floette ex', 'common'),
  (36, 'Espurr', 'common'),
  (37, 'Meowstic', 'common'),
  (38, 'Phantump', 'common'),
  (39, 'Trevenant', 'common'),
  (40, 'Pumpkaboo', 'common'),
  (41, 'Gourgeist ex', 'common'),
  (42, 'Xerneas', 'common'),
  (43, 'Sudowoodo', 'common'),
  (44, 'Phanpy', 'common'),
  (45, 'Donphan', 'common'),
  (46, 'Baltoy', 'common'),
  (47, 'Claydol', 'common'),
  (48, 'Mega Gallade ex', 'common'),
  (49, 'Zubat', 'common'),
  (50, 'Golbat', 'common'),
  (51, 'Crobat', 'common'),
  (52, 'Qwilfish', 'common'),
  (53, 'Stunky', 'common'),
  (54, 'Skuntank', 'common'),
  (55, 'Krookodile ex', 'common'),
  (56, 'Trubbish', 'common'),
  (57, 'Garbodor', 'common'),
  (58, 'Skrelp', 'common'),
  (59, 'Beldum', 'common'),
  (60, 'Metang', 'common'),
  (61, 'Metagross', 'common'),
  (62, 'Ferroseed', 'common'),
  (63, 'Ferrothorn', 'common'),
  (64, 'Cobalion ex', 'common'),
  (65, 'Mega Dragalge ex', 'common'),
  (66, 'Goomy', 'common'),
  (67, 'Sliggoo', 'common'),
  (68, 'Goodra', 'common'),
  (69, 'Tauros', 'common'),
  (70, 'Patrat', 'common'),
  (71, 'Watchog', 'common'),
  (72, 'Minccino', 'common'),
  (73, 'Cinccino ex', 'common'),
  (74, 'Adversity Policy', 'common'),
  (75, 'Ange Floette', 'common'),
  (76, 'AZ''s Tranquility', 'common'),
  (77, 'Emma', 'common'),
  (78, 'Great Haul Net', 'common'),
  (79, 'Philippe', 'common'),
  (80, 'Prism Tower', 'common'),
  (81, 'Roxie''s Performance', 'common'),
  (82, 'Special Red Card', 'common'),
  (83, 'Transformation Tome', 'common'),
  (84, 'Bubbly Water Energy', 'common'),
  (85, 'Magnetic Metal Energy', 'common'),
  (86, 'Nitro Fire Energy', 'common'),
  (87, 'Chespin', 'illustration_rare'),
  (88, 'Froakie', 'illustration_rare'),
  (89, 'Frogadier', 'illustration_rare'),
  (90, 'Ampharos', 'illustration_rare'),
  (91, 'Xerneas', 'illustration_rare'),
  (92, 'Claydol', 'illustration_rare'),
  (93, 'Crobat', 'illustration_rare'),
  (94, 'Metang', 'illustration_rare'),
  (95, 'Sliggoo', 'illustration_rare'),
  (96, 'Tauros', 'illustration_rare'),
  (97, 'Watchog', 'illustration_rare'),
  (98, 'Beedrill ex', 'ultra_rare'),
  (99, 'Mega Pyroar ex', 'ultra_rare'),
  (100, 'Mega Greninja ex', 'ultra_rare'),
  (101, 'Mega Floette ex', 'ultra_rare'),
  (102, 'Gourgeist ex', 'ultra_rare'),
  (103, 'Cobalion ex', 'ultra_rare'),
  (104, 'Mega Dragalge ex', 'ultra_rare'),
  (105, 'Cinccino ex', 'ultra_rare'),
  (106, 'AZ''s Tranquility', 'ultra_rare'),
  (107, 'Emma', 'ultra_rare'),
  (108, 'Energy Retrieval', 'ultra_rare'),
  (109, 'Jumbo Ice Cream', 'ultra_rare'),
  (110, 'Philippe', 'ultra_rare'),
  (111, 'Prism Tower', 'ultra_rare'),
  (112, 'Roxie''s Performance', 'ultra_rare'),
  (113, 'Special Red Card', 'ultra_rare'),
  (114, 'Surfing Beach', 'ultra_rare'),
  (115, 'Tool Scrapper', 'ultra_rare'),
  (116, 'Mega Greninja ex', 'special_illustration_rare'),
  (117, 'Mega Floette ex', 'special_illustration_rare'),
  (118, 'Mega Dragalge ex', 'special_illustration_rare'),
  (119, 'Cinccino ex', 'special_illustration_rare'),
  (120, 'AZ''s Tranquility', 'special_illustration_rare'),
  (121, 'Roxie''s Performance', 'special_illustration_rare'),
  (122, 'Mega Greninja ex', 'mega_hyper_rare')
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
