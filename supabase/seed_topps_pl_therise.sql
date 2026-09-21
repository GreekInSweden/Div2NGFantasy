-- Seed data for Topps Premier League 2026/27 > The Rise, 10 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'the-rise', 'The Rise', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Thierry Henry (Arsenal)', 'insert'),
  (2, 'Frank Lampard (Chelsea)', 'insert'),
  (3, 'Clint Dempsey (Fulham)', 'insert'),
  (4, 'Steven Gerrard (Liverpool FC)', 'insert'),
  (5, 'Mohamed Salah (Liverpool FC)', 'insert'),
  (6, 'Kevin De Bruyne (Manchester City)', 'insert'),
  (7, 'David Beckham (Manchester United)', 'insert'),
  (8, 'Wayne Rooney (Manchester United)', 'insert'),
  (9, 'Nolberto Solano (Newcastle United)', 'insert'),
  (10, 'Gareth Bale (Tottenham)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 25, 0
from inserted_cards ic;
