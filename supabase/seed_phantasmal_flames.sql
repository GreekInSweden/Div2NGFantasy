-- Seed data for Mega Evolution > Phantasmal Flames, 130 cards.
-- Run this once in the Supabase SQL editor after schema.sql AND
-- set_visibility.sql (this seed sets the new set to hidden by default).
-- Stock defaults to 0 for every variant -- cards stay greyed out on the
-- storefront (and the whole set stays hidden) until you set real stock
-- numbers and flip visibility on in /admin. Prices are rough starting
-- defaults by rarity tier (SEK) -- edit any of them later.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('mega-evolution', 'Mega Evolution', 'phantasmal-flames', 'Phantasmal Flames', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Oddish', 'common'),
  (2, 'Gloom', 'common'),
  (3, 'Vileplume', 'common'),
  (4, 'Mega Heracross ex', 'common'),
  (5, 'Lotad', 'common'),
  (6, 'Lombre', 'common'),
  (7, 'Ludicolo', 'common'),
  (8, 'Genesect', 'common'),
  (9, 'Nymble', 'common'),
  (10, 'Lokix', 'common'),
  (11, 'Charmander', 'common'),
  (12, 'Charmeleon', 'common'),
  (13, 'Mega Charizard X ex', 'common'),
  (14, 'Moltres', 'common'),
  (15, 'Darumaka', 'common'),
  (16, 'Darmanitan', 'common'),
  (17, 'Reshiram', 'common'),
  (18, 'Oricorio ex', 'common'),
  (19, 'Charcadet', 'common'),
  (20, 'Ceruledge', 'common'),
  (21, 'Seel', 'common'),
  (22, 'Dewgong', 'common'),
  (23, 'Swinub', 'common'),
  (24, 'Piloswine', 'common'),
  (25, 'Mamoswine', 'common'),
  (26, 'Suicune', 'common'),
  (27, 'Piplup', 'common'),
  (28, 'Prinplup', 'common'),
  (29, 'Rotom ex', 'common'),
  (30, 'Yamper', 'common'),
  (31, 'Boltund', 'common'),
  (32, 'Pawmi', 'common'),
  (33, 'Pawmo', 'common'),
  (34, 'Pawmot', 'common'),
  (35, 'Misdreavus', 'common'),
  (36, 'Mismagius ex', 'common'),
  (37, 'Snubbull', 'common'),
  (38, 'Granbull', 'common'),
  (39, 'Cresselia', 'common'),
  (40, 'Meloetta', 'common'),
  (41, 'Mega Diancie ex', 'common'),
  (42, 'Mimikyu', 'common'),
  (43, 'Milcery', 'common'),
  (44, 'Alcremie', 'common'),
  (45, 'Zacian', 'common'),
  (46, 'Bramblin', 'common'),
  (47, 'Brambleghast', 'common'),
  (48, 'Paldean Tauros', 'common'),
  (49, 'Gligar', 'common'),
  (50, 'Gliscor', 'common'),
  (51, 'Trapinch', 'common'),
  (52, 'Vibrava', 'common'),
  (53, 'Flygon', 'common'),
  (54, 'Gastly', 'common'),
  (55, 'Haunter', 'common'),
  (56, 'Mega Gengar ex', 'common'),
  (57, 'Murkrow', 'common'),
  (58, 'Honchkrow', 'common'),
  (59, 'Sableye', 'common'),
  (60, 'Carvanha', 'common'),
  (61, 'Mega Sharpedo ex', 'common'),
  (62, 'Seviper', 'common'),
  (63, 'Absol', 'common'),
  (64, 'Sandile', 'common'),
  (65, 'Krokorok', 'common'),
  (66, 'Krookodile', 'common'),
  (67, 'Toxel', 'common'),
  (68, 'Toxtricity', 'common'),
  (69, 'Eternatus', 'common'),
  (70, 'Empoleon ex', 'common'),
  (71, 'Bronzor', 'common'),
  (72, 'Bronzong', 'common'),
  (73, 'Togedemaru', 'common'),
  (74, 'Duraludon', 'common'),
  (75, 'Archaludon', 'common'),
  (76, 'Jigglypuff', 'common'),
  (77, 'Wigglytuff', 'common'),
  (78, 'Aipom', 'common'),
  (79, 'Ambipom', 'common'),
  (80, 'Smeargle', 'common'),
  (81, 'Zigzagoon', 'common'),
  (82, 'Linoone', 'common'),
  (83, 'Buneary', 'common'),
  (84, 'Mega Lopunny ex', 'common'),
  (85, 'Battle Cage', 'common'),
  (86, 'Blowtorch', 'common'),
  (87, 'Dawn', 'common'),
  (88, 'Dizzying Valley', 'common'),
  (89, 'Firebreather', 'common'),
  (90, 'Grimsley''s Move', 'common'),
  (91, 'Jumbo Ice Cream', 'common'),
  (92, 'Punk Helmet', 'common'),
  (93, 'Sacred Charm', 'common'),
  (94, 'Wondrous Patch', 'common'),
  (95, 'Ludicolo', 'illustration_rare'),
  (96, 'Nymble', 'illustration_rare'),
  (97, 'Dewgong', 'illustration_rare'),
  (98, 'Piplup', 'illustration_rare'),
  (99, 'Yamper', 'illustration_rare'),
  (100, 'Zacian', 'illustration_rare'),
  (101, 'Flygon', 'illustration_rare'),
  (102, 'Paldean Wooper', 'illustration_rare'),
  (103, 'Toxtricity', 'illustration_rare'),
  (104, 'Togedemaru', 'illustration_rare'),
  (105, 'Wigglytuff', 'illustration_rare'),
  (106, 'Meowth', 'illustration_rare'),
  (107, 'Ambipom', 'illustration_rare'),
  (108, 'Mega Heracross ex', 'ultra_rare'),
  (109, 'Mega Charizard X ex', 'ultra_rare'),
  (110, 'Oricorio ex', 'ultra_rare'),
  (111, 'Rotom ex', 'ultra_rare'),
  (112, 'Mismagius ex', 'ultra_rare'),
  (113, 'Mega Sharpedo ex', 'ultra_rare'),
  (114, 'Empoleon ex', 'ultra_rare'),
  (115, 'Mega Lopunny ex', 'ultra_rare'),
  (116, 'Battle Cage', 'ultra_rare'),
  (117, 'Blowtorch', 'ultra_rare'),
  (118, 'Dawn', 'ultra_rare'),
  (119, 'Firebreather', 'ultra_rare'),
  (120, 'Grimsley''s Move', 'ultra_rare'),
  (121, 'Punk Helmet', 'ultra_rare'),
  (122, 'Sacred Charm', 'ultra_rare'),
  (123, 'Switch', 'ultra_rare'),
  (124, 'Ignition Energy', 'ultra_rare'),
  (125, 'Mega Charizard X ex', 'special_illustration_rare'),
  (126, 'Rotom ex', 'special_illustration_rare'),
  (127, 'Mega Sharpedo ex', 'special_illustration_rare'),
  (128, 'Mega Lopunny ex', 'special_illustration_rare'),
  (129, 'Dawn', 'special_illustration_rare'),
  (130, 'Mega Charizard X ex', 'mega_hyper_rare')
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
