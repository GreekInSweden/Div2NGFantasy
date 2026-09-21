-- Seed data for Topps Premier League 2026/27 > Golden Boot, 9 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'golden-boot', 'Golden Boot', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Thierry Henry (Arsenal 2005-06)', 'insert'),
  (2, 'Didier Drogba (Chelsea 2006-07)', 'insert'),
  (3, 'Mohamed Salah (Liverpool FC 2024-25)', 'insert'),
  (4, 'Luis Suárez (Liverpool FC 2013-14)', 'insert'),
  (5, 'Carlos Tevez (Manchester City 2010-11)', 'insert'),
  (6, 'Erling Haaland (Manchester City 2023-24)', 'insert'),
  (7, 'Robin van Persie (Manchester United 2012-13)', 'insert'),
  (8, 'Alan Shearer (Newcastle United 1996-97)', 'insert'),
  (9, 'Kevin Phillips (Sunderland 1999-00)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 25, 0
from inserted_cards ic;
