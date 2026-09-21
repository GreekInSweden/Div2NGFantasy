-- Seed data for Topps Premier League 2026/27 > Flying The Flag, 25 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'flying-the-flag', 'Flying The Flag', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'William Saliba (Arsenal)', 'insert'),
  (2, 'Martin Ødegaard (Arsenal)', 'insert'),
  (3, 'Amadou Onana (Aston Villa)', 'insert'),
  (4, 'Emiliano Buendía (Aston Villa)', 'insert'),
  (5, 'Amine Adli (AFC Bournemouth)', 'insert'),
  (6, 'Mikkel Damsgaard (Brentford)', 'insert'),
  (7, 'Diego Gómez (Brighton)', 'insert'),
  (8, 'Kaoru Mitoma (Brighton)', 'insert'),
  (9, 'Moisés Caicedo (Chelsea)', 'insert'),
  (10, 'João Pedro (Chelsea)', 'insert'),
  (11, 'Ismaïla Sarr (Crystal Palace)', 'insert'),
  (12, 'Jørgen Strand Larsen (Crystal Palace)', 'insert'),
  (13, 'Beto (Everton)', 'insert'),
  (14, 'Antonee Robinson (Fulham)', 'insert'),
  (15, 'Ethan Ampadu (Leeds United)', 'insert'),
  (16, 'Virgil van Dijk (Liverpool FC)', 'insert'),
  (17, 'Joško Gvardiol (Manchester City)', 'insert'),
  (18, 'Phil Foden (Manchester City)', 'insert'),
  (19, 'Diogo Dalot (Manchester United)', 'insert'),
  (20, 'Malick Thiaw (Newcastle United)', 'insert'),
  (21, 'Sandro Tonali (Newcastle United)', 'insert'),
  (22, 'Chris Wood (Nottingham Forest)', 'insert'),
  (23, 'Noah Sadiki (Sunderland)', 'insert'),
  (24, 'Pedro Porro (Tottenham)', 'insert'),
  (25, 'Brandon Thomas-Asante (Coventry City)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 15, 0
from inserted_cards ic;
