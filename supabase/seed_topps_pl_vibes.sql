-- Seed data for Topps Premier League 2026/27 > Vibes, 10 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'vibes', 'Vibes', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Viktor Gyökeres (Arsenal)', 'insert'),
  (2, 'Ollie Watkins (Aston Villa)', 'insert'),
  (3, 'Charalampos Kostoulas (Brighton)', 'insert'),
  (4, 'Marc Cucurella (Chelsea)', 'insert'),
  (5, 'Jean-Philippe Mateta (Crystal Palace)', 'insert'),
  (6, 'Alex Iwobi (Fulham)', 'insert'),
  (7, 'Hugo Ekitike (Liverpool FC)', 'insert'),
  (8, 'Erling Haaland (Manchester City)', 'insert'),
  (9, 'Patrick Dorgu (Manchester United)', 'insert'),
  (10, 'Chemsdine Talbi (Sunderland)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 15, 0
from inserted_cards ic;
