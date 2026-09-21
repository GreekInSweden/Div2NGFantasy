-- Seed data for Topps Premier League 2026/27 > 8-Bit Ballers, 20 cards.
-- Run this once in the Supabase SQL editor after schema.sql AND
-- set_visibility.sql AND topps_rarity.sql.
-- Stock defaults to 0 -- cards stay greyed out (and the set stays hidden)
-- until you set real stock in /admin. Price defaults to a flat placeholder
-- -- edit per card once you know actual values.
-- Only a 'normal' variant is created (no holo) since Topps football cards
-- don't use that concept -- parallels/autos would need their own card rows
-- if you want to sell those separately later.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', '8-bit-ballers', '8-Bit Ballers', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Santi Cazorla (Arsenal)', 'insert'),
  (2, 'Olivier Giroud (Arsenal)', 'insert'),
  (3, 'Darren Bent (Aston Villa)', 'insert'),
  (4, 'Simon Francis (AFC Bournemouth)', 'insert'),
  (5, 'James Milner (Brighton)', 'insert'),
  (6, 'Petr Čech (Chelsea)', 'insert'),
  (7, 'David Luiz (Chelsea)', 'insert'),
  (8, 'Daniel Sturridge (Chelsea)', 'insert'),
  (9, 'Yannick Bolasie (Crystal Palace)', 'insert'),
  (10, 'Yakubu (Everton)', 'insert'),
  (11, 'Clint Dempsey (Fulham)', 'insert'),
  (12, 'Steven Gerrard (Liverpool FC)', 'insert'),
  (13, 'Fernando Torres (Liverpool FC)', 'insert'),
  (14, 'David Silva (Manchester City)', 'insert'),
  (15, 'Yaya Touré (Manchester City)', 'insert'),
  (16, 'Nani (Manchester United)', 'insert'),
  (17, 'Kevin Nolan (Newcastle United)', 'insert'),
  (18, 'Papiss Cissé (Newcastle United)', 'insert'),
  (19, 'Obafemi Martins (Newcastle United)', 'insert'),
  (20, 'John O''Shea (Sunderland)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 15, 0
from inserted_cards ic;
