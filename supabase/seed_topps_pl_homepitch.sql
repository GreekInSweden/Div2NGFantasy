-- Seed data for Topps Premier League 2026/27 > Home Pitch, 20 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'home-pitch', 'Home Pitch', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Max Dowman (Arsenal)', 'insert'),
  (2, 'Bukayo Saka (Arsenal)', 'insert'),
  (3, 'Ollie Watkins (Aston Villa)', 'insert'),
  (4, 'Tyler Adams (AFC Bournemouth)', 'insert'),
  (5, 'Kevin Schade (Brentford)', 'insert'),
  (6, 'Yankuba Minteh (Brighton)', 'insert'),
  (7, 'Eden Hazard (Chelsea)', 'insert'),
  (8, 'Brennan Johnson (Crystal Palace)', 'insert'),
  (9, 'Iliman Ndiaye (Everton)', 'insert'),
  (10, 'Alex Iwobi (Fulham)', 'insert'),
  (11, 'Brenden Aaronson (Leeds United)', 'insert'),
  (12, 'Roberto Firmino (Liverpool FC)', 'insert'),
  (13, 'Rayan Cherki (Manchester City)', 'insert'),
  (14, 'Mario Balotelli (Manchester City)', 'insert'),
  (15, 'Bryan Mbeumo (Manchester United)', 'insert'),
  (16, 'Edinson Cavani (Manchester United)', 'insert'),
  (17, 'Sandro Tonali (Newcastle United)', 'insert'),
  (18, 'Igor Jesus (Nottingham Forest)', 'insert'),
  (19, 'Granit Xhaka (Sunderland)', 'insert'),
  (20, 'Lucas Bergvall (Tottenham)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 25, 0
from inserted_cards ic;
