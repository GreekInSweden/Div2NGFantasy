-- Seed data for Topps Premier League 2026/27 > Mayhem, 20 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'mayhem', 'Mayhem', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Gabriel Magalhães (Arsenal)', 'insert'),
  (2, 'Gabriel Martinelli (Arsenal)', 'insert'),
  (3, 'Evanilson (AFC Bournemouth)', 'insert'),
  (4, 'Dango Ouattara (Brentford)', 'insert'),
  (5, 'Yasin Ayari (Brighton)', 'insert'),
  (6, 'Jesse Derry (Chelsea)', 'insert'),
  (7, 'Alejandro Garnacho (Chelsea)', 'insert'),
  (8, 'Yéremy Pino (Crystal Palace)', 'insert'),
  (9, 'Kevin (Fulham)', 'insert'),
  (10, 'Noah Okafor (Leeds United)', 'insert'),
  (11, 'Jeremie Frimpong (Liverpool FC)', 'insert'),
  (12, 'Dominik Szoboszlai (Liverpool FC)', 'insert'),
  (13, 'Jérémy Doku (Manchester City)', 'insert'),
  (14, 'Godwill Kukonki (Manchester United)', 'insert'),
  (15, 'Benjamin Šeško (Manchester United)', 'insert'),
  (16, 'Harvey Barnes (Newcastle United)', 'insert'),
  (17, 'Igor Jesus (Nottingham Forest)', 'insert'),
  (18, 'Enzo Le Fée (Sunderland)', 'insert'),
  (19, 'Lucas Bergvall (Tottenham)', 'insert'),
  (20, 'Haji Wright (Coventry City)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 15, 0
from inserted_cards ic;
