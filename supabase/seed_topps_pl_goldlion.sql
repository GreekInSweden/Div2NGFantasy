-- Seed data for Topps Premier League 2026/27 > Gold Lion, 20 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'gold-lion', 'Gold Lion', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Declan Rice (Arsenal)', 'insert'),
  (2, 'Max Dowman (Arsenal)', 'insert'),
  (3, 'Thierry Henry (Arsenal)', 'insert'),
  (4, 'Morgan Rogers (Aston Villa)', 'insert'),
  (5, 'Rayan (AFC Bournemouth)', 'insert'),
  (6, 'Igor Thiago (Brentford)', 'insert'),
  (7, 'Cole Palmer (Chelsea)', 'insert'),
  (8, 'Estêvão Willian (Chelsea)', 'insert'),
  (9, 'Wayne Rooney (Everton)', 'insert'),
  (10, 'Steven Gerrard (Liverpool FC)', 'insert'),
  (11, 'Florian Wirtz (Liverpool FC)', 'insert'),
  (12, 'Kevin De Bruyne (Manchester City)', 'insert'),
  (13, 'Antoine Semenyo (Manchester City)', 'insert'),
  (14, 'Erling Haaland (Manchester City)', 'insert'),
  (15, 'Bruno Fernandes (Manchester United)', 'insert'),
  (16, 'David Beckham (Manchester United)', 'insert'),
  (17, 'JJ Gabriel (Manchester United)', 'insert'),
  (18, 'Bruno Guimarães (Newcastle United)', 'insert'),
  (19, 'Alan Shearer (Newcastle United)', 'insert'),
  (20, 'Harry Kane (Tottenham)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 30, 0
from inserted_cards ic;
