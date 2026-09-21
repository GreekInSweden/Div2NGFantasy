-- Seed data for Topps Premier League 2026/27 > Diamond Rookies, 5 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'diamond-rookies', 'Diamond Rookies', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Brian Madjo (Aston Villa)', 'insert'),
  (2, 'Rayan (AFC Bournemouth)', 'insert'),
  (3, 'Jesse Derry (Chelsea)', 'insert'),
  (4, 'Jérémy Jacquet (Liverpool FC)', 'insert'),
  (5, 'JJ Gabriel (Manchester United)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 40, 0
from inserted_cards ic;
