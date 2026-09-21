-- Seed data for Topps Premier League 2026/27 > Black Edge, 50 cards.
-- Run this once in the Supabase SQL editor (schema.sql, set_visibility.sql,
-- topps_rarity.sql must already be run). Adds to the EXISTING
-- "Topps Premier League 2026/27" category. Only a 'normal' variant is
-- created. Stock defaults to 0 -- set stays hidden and greyed out until
-- you fill in real stock in /admin.

with s as (
  insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'black-edge', 'Black Edge', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Eberechi Eze (Arsenal)', 'insert'),
  (2, 'Max Dowman (Arsenal)', 'insert'),
  (3, 'Gabriel Martinelli (Arsenal)', 'insert'),
  (4, 'Morgan Rogers (Aston Villa)', 'insert'),
  (5, 'Tammy Abraham (Aston Villa)', 'insert'),
  (6, 'Gabriel Agbonlahor (Aston Villa)', 'insert'),
  (7, 'Evanilson (AFC Bournemouth)', 'insert'),
  (8, 'Rayan (AFC Bournemouth)', 'insert'),
  (9, 'Igor Thiago (Brentford)', 'insert'),
  (10, 'Kaye Furo (Brentford)', 'insert'),
  (11, 'Kaoru Mitoma (Brighton)', 'insert'),
  (12, 'Georginio Rutter (Brighton)', 'insert'),
  (13, 'Estêvão Willian (Chelsea)', 'insert'),
  (14, 'João Pedro (Chelsea)', 'insert'),
  (15, 'Gianfranco Zola (Chelsea)', 'insert'),
  (16, 'Diego Costa (Chelsea)', 'insert'),
  (17, 'Ismaïla Sarr (Crystal Palace)', 'insert'),
  (18, 'Brennan Johnson (Crystal Palace)', 'insert'),
  (19, 'Yannick Bolasie (Crystal Palace)', 'insert'),
  (20, 'Jean-Philippe Mateta (Crystal Palace)', 'insert'),
  (21, 'Paul Gascoigne (Everton)', 'insert'),
  (22, 'Thierno Barry (Everton)', 'insert'),
  (23, 'Iliman Ndiaye (Everton)', 'insert'),
  (24, 'Kevin (Fulham)', 'insert'),
  (25, 'Noah Okafor (Leeds United)', 'insert'),
  (26, 'Dominic Calvert-Lewin (Leeds United)', 'insert'),
  (27, 'Jérémy Jacquet (Liverpool FC)', 'insert'),
  (28, 'Philippe Coutinho (Liverpool FC)', 'insert'),
  (29, 'Luis Suárez (Liverpool FC)', 'insert'),
  (30, 'Alexander Isak (Liverpool FC)', 'insert'),
  (31, 'Hugo Ekitike (Liverpool FC)', 'insert'),
  (32, 'Kevin De Bruyne (Manchester City)', 'insert'),
  (33, 'Phil Foden (Manchester City)', 'insert'),
  (34, 'Antoine Semenyo (Manchester City)', 'insert'),
  (35, 'David Beckham (Manchester United)', 'insert'),
  (36, 'Bruno Fernandes (Manchester United)', 'insert'),
  (37, 'Amad (Manchester United)', 'insert'),
  (38, 'Zlatan Ibrahimović (Manchester United)', 'insert'),
  (39, 'JJ Gabriel (Manchester United)', 'insert'),
  (40, 'Bruno Guimarães (Newcastle United)', 'insert'),
  (41, 'Nick Woltemade (Newcastle United)', 'insert'),
  (42, 'David Ginola (Newcastle United)', 'insert'),
  (43, 'Igor Jesus (Nottingham Forest)', 'insert'),
  (44, 'Chris Rigg (Sunderland)', 'insert'),
  (45, 'Wilson Isidor (Sunderland)', 'insert'),
  (46, 'Edgar Davids (Tottenham)', 'insert'),
  (47, 'Mohammed Kudus (Tottenham)', 'insert'),
  (48, 'Harry Kane (Tottenham)', 'insert'),
  (49, 'Ellis Simms (Coventry City)', 'insert'),
  (50, 'Tatsuhiro Sakamoto (Coventry City)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 20, 0
from inserted_cards ic;
