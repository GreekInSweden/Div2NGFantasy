-- Seed data for Topps Premier League 2026/27 > Remember the Name, 5 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'remember-the-name', 'Remember the Name', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Didier Drogba (Chelsea)', 'insert'),
  (2, 'Rio Ngumoha (Liverpool FC)', 'insert'),
  (3, 'Mario Balotelli (Manchester City)', 'insert'),
  (4, 'Sergio Agüero (Manchester City)', 'insert'),
  (5, 'Wayne Rooney (Manchester United)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 35, 0
from inserted_cards ic;
