-- Seed data for Topps Premier League 2026/27 > Nitro Boost, 25 cards.
-- Run this once in the Supabase SQL editor (same migrations as the other
-- Topps PL seed files: schema.sql, set_visibility.sql, topps_rarity.sql).
-- Adds to the EXISTING "Topps Premier League 2026/27" category/set group.
-- Stock defaults to 0 -- cards stay greyed out (and the set hidden) until
-- you set real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'nitro-boost', 'Nitro Boost', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Noni Madueke (Arsenal)', 'insert'),
  (2, 'Brando Bailey-Joseph (Arsenal)', 'insert'),
  (3, 'Alysson (Aston Villa)', 'insert'),
  (4, 'Marcus Tavernier (AFC Bournemouth)', 'insert'),
  (5, 'Michael Kayode (Brentford)', 'insert'),
  (6, 'Yankuba Minteh (Brighton)', 'insert'),
  (7, 'Pedro Neto (Chelsea)', 'insert'),
  (8, 'Jamie Gittens (Chelsea)', 'insert'),
  (9, 'Daniel Muñoz (Crystal Palace)', 'insert'),
  (10, 'Thierno Barry (Everton)', 'insert'),
  (11, 'Oscar Bobb (Fulham)', 'insert'),
  (12, 'Wilfried Gnonto (Leeds United)', 'insert'),
  (13, 'Jeremie Frimpong (Liverpool FC)', 'insert'),
  (14, 'Rio Ngumoha (Liverpool FC)', 'insert'),
  (15, 'Savinho (Manchester City)', 'insert'),
  (16, 'Omar Marmoush (Manchester City)', 'insert'),
  (17, 'Amad (Manchester United)', 'insert'),
  (18, 'Jacob Murphy (Newcastle United)', 'insert'),
  (19, 'Anthony Elanga (Newcastle United)', 'insert'),
  (20, 'Omari Hutchinson (Nottingham Forest)', 'insert'),
  (21, 'Chemsdine Talbi (Sunderland)', 'insert'),
  (22, 'Micky van de Ven (Tottenham)', 'insert'),
  (23, 'Ephron Mason-Clark (Coventry City)', 'insert'),
  (24, 'Sindre Walle Egeli (Ipswich Town)', 'insert'),
  (25, 'Matt Crooks (Hull City)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 15, 0
from inserted_cards ic;
