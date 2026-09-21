-- Seed data for Topps Premier League 2026/27 > Perfect Storm, 20 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'perfect-storm', 'Perfect Storm', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Declan Rice (Arsenal)', 'insert'),
  (2, 'Brian Madjo (Aston Villa)', 'insert'),
  (3, 'Junior Kroupi (AFC Bournemouth)', 'insert'),
  (4, 'Kaye Furo (Brentford)', 'insert'),
  (5, 'Diego Gómez (Brighton)', 'insert'),
  (6, 'Cole Palmer (Chelsea)', 'insert'),
  (7, 'Yéremy Pino (Crystal Palace)', 'insert'),
  (8, 'Tyler Dibling (Everton)', 'insert'),
  (9, 'Oscar Bobb (Fulham)', 'insert'),
  (10, 'Dominic Calvert-Lewin (Leeds United)', 'insert'),
  (11, 'Florian Wirtz (Liverpool FC)', 'insert'),
  (12, 'Fernando Torres (Liverpool FC)', 'insert'),
  (13, 'Antoine Semenyo (Manchester City)', 'insert'),
  (14, 'Matheus Cunha (Manchester United)', 'insert'),
  (15, 'Eric Cantona (Manchester United)', 'insert'),
  (16, 'Nick Woltemade (Newcastle United)', 'insert'),
  (17, 'Morgan Gibbs-White (Nottingham Forest)', 'insert'),
  (18, 'Brian Brobbey (Sunderland)', 'insert'),
  (19, 'Xavi Simons (Tottenham)', 'insert'),
  (20, 'Haji Wright (Coventry City)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 25, 0
from inserted_cards ic;
