-- Seed data for Bonuskort & Promos > MEP Black Star Promos, 88 cards.
-- Run this AFTER delete_old_promo_set.sql.
--
-- IMPORTANT — unlike the numbered main sets, this is an ONGOING promo line
-- that keeps growing every time a new Mega Evolution product releases.
-- This snapshot covers MEP 001-088 (ending at Zarude, the Pitch Black ETB
-- promo) as of when this was generated. One card is deliberately left out:
-- an unnumbered "Pikachu at the Museum" promo that doesn't fit a plain
-- integer card number -- add it by hand via "+ Nytt kort" if you want it.
-- When new promos release with future sets, use "+ Nytt kort" in
-- /admin/mep-black-star-promos to add them one at a time, same as you
-- already did for Zarude and Binacle.
--
-- Stock defaults to 0 for every variant -- cards stay greyed out on the
-- storefront (and the whole set stays hidden) until you set real stock
-- numbers and flip visibility on in /admin. Prices default to a modest
-- 10 kr (normal) / 15 kr (holo) placeholder -- most basic promos (starter
-- Pokemon giveaways etc.) are worth only a few kronor, while chase promos
-- like Zarude or Mega Charizard X ex are worth much more -- edit each
-- card's price individually once you know which is which.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('bonuskort-och-promos', 'Bonuskort & Promos', 'mep-black-star-promos', 'MEP Black Star Promos', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Meganium', 'promo'),
  (2, 'Inteleon', 'promo'),
  (3, 'Alakazam', 'promo'),
  (4, 'Lunatone', 'promo'),
  (5, 'Drifloon', 'promo'),
  (6, 'Drifblim', 'promo'),
  (7, 'Psyduck', 'promo'),
  (8, 'Golduck', 'promo'),
  (9, 'Alakazam', 'promo'),
  (10, 'Riolu', 'promo'),
  (11, 'Mega Latias ex', 'promo'),
  (12, 'Mega Lucario ex', 'promo'),
  (13, 'Mega Venusaur ex', 'promo'),
  (14, 'Ceruledge', 'promo'),
  (15, 'Zacian', 'promo'),
  (16, 'Flygon', 'promo'),
  (17, 'Toxtricity', 'promo'),
  (18, 'Cottonee', 'promo'),
  (19, 'Whimsicott', 'promo'),
  (20, 'Sneasel', 'promo'),
  (21, 'Weavile', 'promo'),
  (22, 'Charcadet', 'promo'),
  (23, 'Mega Charizard X ex', 'promo'),
  (24, 'Oricorio ex', 'promo'),
  (25, 'Mega Kangaskhan ex', 'promo'),
  (26, 'Meloetta', 'promo'),
  (27, 'Haunter', 'promo'),
  (28, 'Celebratory Fanfare', 'promo'),
  (29, 'Mega Charizard X ex', 'promo'),
  (30, 'Mega Charizard Y ex', 'promo'),
  (31, 'N''s Zekrom', 'promo'),
  (32, 'Mega Gardevoir ex', 'promo'),
  (33, 'Mega Lucario ex', 'promo'),
  (34, 'Mega Meganium ex', 'promo'),
  (35, 'Mega Emboar ex', 'promo'),
  (36, 'Mega Feraligatr ex', 'promo'),
  (37, 'Bulbasaur', 'promo'),
  (38, 'Charmander', 'promo'),
  (39, 'Squirtle', 'promo'),
  (40, 'Turtwig', 'promo'),
  (41, 'Chimchar', 'promo'),
  (42, 'Piplup', 'promo'),
  (43, 'Rowlet', 'promo'),
  (44, 'Litten', 'promo'),
  (45, 'Popplio', 'promo'),
  (46, 'Chikorita', 'promo'),
  (47, 'Cyndaquil', 'promo'),
  (48, 'Totodile', 'promo'),
  (49, 'Snivy', 'promo'),
  (50, 'Tepig', 'promo'),
  (51, 'Oshawott', 'promo'),
  (52, 'Grookey', 'promo'),
  (53, 'Scorbunny', 'promo'),
  (54, 'Sobble', 'promo'),
  (55, 'Treecko', 'promo'),
  (56, 'Torchic', 'promo'),
  (57, 'Mudkip', 'promo'),
  (58, 'Chespin', 'promo'),
  (59, 'Fennekin', 'promo'),
  (60, 'Froakie', 'promo'),
  (61, 'Sprigatito', 'promo'),
  (62, 'Fuecoco', 'promo'),
  (63, 'Quaxly', 'promo'),
  (64, 'Serperior', 'promo'),
  (65, 'Barbaracle', 'promo'),
  (66, 'Tyrantrum', 'promo'),
  (67, 'Doublade', 'promo'),
  (68, 'Makuhita', 'promo'),
  (69, 'Chikorita', 'promo'),
  (70, 'Tyrunt', 'promo'),
  (71, 'Mega Zygarde ex', 'promo'),
  (72, 'Mega Clefable ex', 'promo'),
  (73, 'Mega Gengar ex', 'promo'),
  (74, 'Delphox', 'promo'),
  (75, 'Ampharos', 'promo'),
  (76, 'Crobat', 'promo'),
  (77, 'Goodra', 'promo'),
  (78, 'Toxel', 'promo'),
  (79, 'Charmeleon', 'promo'),
  (80, 'Fennekin', 'promo'),
  (81, 'Mega Greninja ex', 'promo'),
  (82, 'Miraidon', 'promo'),
  (83, 'Slowbro', 'promo'),
  (84, 'Dhelmise', 'promo'),
  (85, 'Bastiodon', 'promo'),
  (86, 'Slowpoke', 'promo'),
  (87, 'Binacle', 'promo'),
  (88, 'Zarude', 'promo')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant,
  case x.variant when 'holo' then 15 else 10 end as price_sek,
  0 as stock
from inserted_cards ic
cross join (values ('normal'), ('holo')) as x(variant);
