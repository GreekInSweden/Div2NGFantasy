-- Seed data for Topps Premier League 2026/27 > Retro Threads, 25 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'retro-threads', 'Retro Threads', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Paul Merson (Arsenal)', 'insert'),
  (2, 'Dwight Yorke (Aston Villa)', 'insert'),
  (3, 'Dion Dublin (Aston Villa)', 'insert'),
  (4, 'Glenn Murray (AFC Bournemouth)', 'insert'),
  (5, 'Mathias Jensen (Brentford)', 'insert'),
  (6, 'Danny Welbeck (Brighton)', 'insert'),
  (7, 'Marcel Desailly (Chelsea)', 'insert'),
  (8, 'Ruud Gullit (Chelsea)', 'insert'),
  (9, 'Gábor Király (Crystal Palace)', 'insert'),
  (10, 'Attilio Lombardo (Crystal Palace)', 'insert'),
  (11, 'James Rodríguez (Everton)', 'insert'),
  (12, 'Duncan Ferguson (Everton)', 'insert'),
  (13, 'Bobby Zamora (Fulham)', 'insert'),
  (14, 'Dimitar Berbatov (Fulham)', 'insert'),
  (15, 'Steve McManaman (Liverpool FC)', 'insert'),
  (16, 'Robbie Fowler (Liverpool FC)', 'insert'),
  (17, 'Samir Nasri (Manchester City)', 'insert'),
  (18, 'Shaun Wright-Phillips (Manchester City)', 'insert'),
  (19, 'Craig Bellamy (Manchester City)', 'insert'),
  (20, 'Gary Pallister (Manchester United)', 'insert'),
  (21, 'Ryan Giggs (Manchester United)', 'insert'),
  (22, 'Federico Macheda (Manchester United)', 'insert'),
  (23, 'Les Ferdinand (Newcastle United)', 'insert'),
  (24, 'Claudio Reyna (Sunderland)', 'insert'),
  (25, 'Djibril Cissé (Sunderland)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 20, 0
from inserted_cards ic;
