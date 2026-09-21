-- Seed data for Topps Premier League 2026/27 > Chrome Classics, 25 cards.
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
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'chrome-classics', 'Chrome Classics', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Ian Wright (Arsenal)', 'insert'),
  (2, 'Juan Pablo Ángel (Aston Villa)', 'insert'),
  (3, 'Gabriel Agbonlahor (Aston Villa)', 'insert'),
  (4, 'Jermain Defoe (AFC Bournemouth)', 'insert'),
  (5, 'Danny Welbeck (Brighton)', 'insert'),
  (6, 'Thiago Silva (Chelsea)', 'insert'),
  (7, 'Eden Hazard (Chelsea)', 'insert'),
  (8, 'Eidur Gudjohnsen (Chelsea)', 'insert'),
  (9, 'Iain Dowie (Crystal Palace)', 'insert'),
  (10, 'Wilfried Zaha (Crystal Palace)', 'insert'),
  (11, 'Duncan Ferguson (Everton)', 'insert'),
  (12, 'Steed Malbranque (Fulham)', 'insert'),
  (13, 'Brian McBride (Fulham)', 'insert'),
  (14, 'John Barnes (Liverpool FC)', 'insert'),
  (15, 'Roberto Firmino (Liverpool FC)', 'insert'),
  (16, 'Nicolas Anelka (Liverpool FC)', 'insert'),
  (17, 'Pablo Zabaleta (Manchester City)', 'insert'),
  (18, 'Yaya Touré (Manchester City)', 'insert'),
  (19, 'Riyad Mahrez (Manchester City)', 'insert'),
  (20, 'Roy Keane (Manchester United)', 'insert'),
  (21, 'Robin van Persie (Manchester United)', 'insert'),
  (22, 'Alexis Sánchez (Manchester United)', 'insert'),
  (23, 'Alan Shearer (Newcastle United)', 'insert'),
  (24, 'Patrick Kluivert (Newcastle United)', 'insert'),
  (25, 'Kevin Phillips (Sunderland)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 15, 0
from inserted_cards ic;
