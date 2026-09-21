-- Seed data for Topps Premier League 2026/27 > Perfect 10, 10 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'perfect-10', 'Perfect 10', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Eberechi Eze (Arsenal)', 'insert'),
  (2, 'Cole Palmer (Chelsea)', 'insert'),
  (3, 'Eden Hazard (Chelsea)', 'insert'),
  (4, 'Iliman Ndiaye (Everton)', 'insert'),
  (5, 'Philippe Coutinho (Liverpool FC)', 'insert'),
  (6, 'Rayan Cherki (Manchester City)', 'insert'),
  (7, 'Sergio Agüero (Manchester City)', 'insert'),
  (8, 'Matheus Cunha (Manchester United)', 'insert'),
  (9, 'Wayne Rooney (Manchester United)', 'insert'),
  (10, 'Harry Kane (Tottenham)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 20, 0
from inserted_cards ic;
