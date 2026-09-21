-- Seed data for Topps Premier League 2026/27 > Carpe Diem, 10 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'carpe-diem', 'Carpe Diem', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Viktor Gyökeres (Arsenal)', 'insert'),
  (2, 'Thierry Henry (Arsenal)', 'insert'),
  (3, 'Morgan Rogers (Aston Villa)', 'insert'),
  (4, 'Ollie Watkins (Aston Villa)', 'insert'),
  (5, 'Frank Lampard (Chelsea)', 'insert'),
  (6, 'João Pedro (Chelsea)', 'insert'),
  (7, 'Erling Haaland (Manchester City)', 'insert'),
  (8, 'Bruno Fernandes (Manchester United)', 'insert'),
  (9, 'Wayne Rooney (Manchester United)', 'insert'),
  (10, 'Granit Xhaka (Sunderland)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 25, 0
from inserted_cards ic;
