-- Seed data for Topps Premier League 2026/27 > Billboard Material, 25 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'billboard-material', 'Billboard Material', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Martin Ødegaard (Arsenal)', 'insert'),
  (2, 'Max Dowman (Arsenal)', 'insert'),
  (3, 'Morgan Rogers (Aston Villa)', 'insert'),
  (4, 'Rayan (AFC Bournemouth)', 'insert'),
  (5, 'Igor Thiago (Brentford)', 'insert'),
  (6, 'Danny Welbeck (Brighton)', 'insert'),
  (7, 'Ryan Kavuma-McQueen (Chelsea)', 'insert'),
  (8, 'Estêvão Willian (Chelsea)', 'insert'),
  (9, 'Joél Drakes-Thomas (Crystal Palace)', 'insert'),
  (10, 'Charly Alcaraz (Everton)', 'insert'),
  (11, 'Kevin (Fulham)', 'insert'),
  (12, 'Brenden Aaronson (Leeds United)', 'insert'),
  (13, 'Florian Wirtz (Liverpool FC)', 'insert'),
  (14, 'Alexander Isak (Liverpool FC)', 'insert'),
  (15, 'Phil Foden (Manchester City)', 'insert'),
  (16, 'Jérémy Doku (Manchester City)', 'insert'),
  (17, 'Benjamin Šeško (Manchester United)', 'insert'),
  (18, 'Amad (Manchester United)', 'insert'),
  (19, 'Bruno Guimarães (Newcastle United)', 'insert'),
  (20, 'Omari Hutchinson (Nottingham Forest)', 'insert'),
  (21, 'Eliezer Mayenda (Sunderland)', 'insert'),
  (22, 'Mohammed Kudus (Tottenham)', 'insert'),
  (23, 'Jack Rudoni (Coventry City)', 'insert'),
  (24, 'George Hirst (Ipswich Town)', 'insert'),
  (25, 'Oli McBurnie (Hull City)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 15, 0
from inserted_cards ic;
