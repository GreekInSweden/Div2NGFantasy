-- Seed data for Topps Premier League 2026/27 > Stars of the Premier League, 25 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'stars-of-the-pl', 'Stars of the Premier League', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Jurriën Timber (Arsenal)', 'insert'),
  (2, 'Declan Rice (Arsenal)', 'insert'),
  (3, 'Youri Tielemans (Aston Villa)', 'insert'),
  (4, 'Justin Kluivert (AFC Bournemouth)', 'insert'),
  (5, 'Nathan Collins (Brentford)', 'insert'),
  (6, 'Pascal Groß (Brighton)', 'insert'),
  (7, 'Reece James (Chelsea)', 'insert'),
  (8, 'Enzo Fernández (Chelsea)', 'insert'),
  (9, 'Adam Wharton (Crystal Palace)', 'insert'),
  (10, 'Jarrad Branthwaite (Everton)', 'insert'),
  (11, 'Emile Smith Rowe (Fulham)', 'insert'),
  (12, 'Brenden Aaronson (Leeds United)', 'insert'),
  (13, 'Ryan Gravenberch (Liverpool FC)', 'insert'),
  (14, 'Alexis Mac Allister (Liverpool FC)', 'insert'),
  (15, 'Marc Guéhi (Manchester City)', 'insert'),
  (16, 'Rodri (Manchester City)', 'insert'),
  (17, 'Kobbie Mainoo (Manchester United)', 'insert'),
  (18, 'Bryan Mbeumo (Manchester United)', 'insert'),
  (19, 'Jacob Ramsey (Newcastle United)', 'insert'),
  (20, 'Yoane Wissa (Newcastle United)', 'insert'),
  (21, 'Elliot Anderson (Nottingham Forest)', 'insert'),
  (22, 'Granit Xhaka (Sunderland)', 'insert'),
  (23, 'Xavi Simons (Tottenham)', 'insert'),
  (24, 'Jack Rudoni (Coventry City)', 'insert'),
  (25, 'Ellis Simms (Coventry City)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 15, 0
from inserted_cards ic;
