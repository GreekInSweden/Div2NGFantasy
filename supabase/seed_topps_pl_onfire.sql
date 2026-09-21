-- Seed data for Topps Premier League 2026/27 > On Fire, 15 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'on-fire', 'On Fire', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Tijjani Reijnders (Manchester City)', 'insert'),
  (2, 'Moisés Caicedo (Chelsea)', 'insert'),
  (3, 'Sandro Tonali (Newcastle United)', 'insert'),
  (4, 'Kevin Schade (Brentford)', 'insert'),
  (5, 'Gabriel Martinelli (Arsenal)', 'insert'),
  (6, 'Bryan Mbeumo (Manchester United)', 'insert'),
  (7, 'Bukayo Saka (Arsenal)', 'insert'),
  (8, 'Evanilson (AFC Bournemouth)', 'insert'),
  (9, 'João Pedro (Chelsea)', 'insert'),
  (10, 'Ezri Konsa (Aston Villa)', 'insert'),
  (11, 'Bruno Fernandes (Manchester United)', 'insert'),
  (12, 'Antoine Semenyo (Manchester City)', 'insert'),
  (13, 'Noah Okafor (Leeds United)', 'insert'),
  (14, 'Virgil van Dijk (Liverpool FC)', 'insert'),
  (15, 'Bruno Guimarães (Newcastle United)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 15, 0
from inserted_cards ic;
