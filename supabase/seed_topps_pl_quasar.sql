-- Seed data for Topps Premier League 2026/27 > Quasar, 15 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'quasar', 'Quasar', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Eberechi Eze (Arsenal)', 'insert'),
  (2, 'Alex Tóth (AFC Bournemouth)', 'insert'),
  (3, 'Dango Ouattara (Brentford)', 'insert'),
  (4, 'Carlos Baleba (Brighton)', 'insert'),
  (5, 'Pedro Neto (Chelsea)', 'insert'),
  (6, 'Jean-Philippe Mateta (Crystal Palace)', 'insert'),
  (7, 'Kiernan Dewsbury-Hall (Everton)', 'insert'),
  (8, 'Oscar Bobb (Fulham)', 'insert'),
  (9, 'Noah Okafor (Leeds United)', 'insert'),
  (10, 'Rio Ngumoha (Liverpool FC)', 'insert'),
  (11, 'Charlie Gray (Manchester City)', 'insert'),
  (12, 'Tijjani Reijnders (Manchester City)', 'insert'),
  (13, 'Bryan Mbeumo (Manchester United)', 'insert'),
  (14, 'Sean Neave (Newcastle United)', 'insert'),
  (15, 'Dan Ndoye (Nottingham Forest)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 20, 0
from inserted_cards ic;
