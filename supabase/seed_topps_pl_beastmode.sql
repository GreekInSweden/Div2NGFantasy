-- Seed data for Topps Premier League 2026/27 > Beast Mode, 25 cards.
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
  values ('topps-premier-league', 'Topps Premier League 2026/27', 'beast-mode', 'Beast Mode', false)
  returning id
),
inserted_cards as (
  insert into cards (set_id, number, name, rarity)
  select s.id, v.number, v.name, v.rarity
  from s, (values
  (1, 'Max Dowman (Arsenal)', 'insert'),
  (2, 'Bukayo Saka (Arsenal)', 'insert'),
  (3, 'Ollie Watkins (Aston Villa)', 'insert'),
  (4, 'Brian Madjo (Aston Villa)', 'insert'),
  (5, 'Junior Kroupi (AFC Bournemouth)', 'insert'),
  (6, 'Igor Thiago (Brentford)', 'insert'),
  (7, 'Charalampos Kostoulas (Brighton)', 'insert'),
  (8, 'Estêvão Willian (Chelsea)', 'insert'),
  (9, 'Dastan Satpayev (Chelsea)', 'insert'),
  (10, 'Jørgen Strand Larsen (Crystal Palace)', 'insert'),
  (11, 'Iliman Ndiaye (Everton)', 'insert'),
  (12, 'Josh King (Fulham)', 'insert'),
  (13, 'Lukas Nmecha (Leeds United)', 'insert'),
  (14, 'Dominik Szoboszlai (Liverpool FC)', 'insert'),
  (15, 'Alexander Isak (Liverpool FC)', 'insert'),
  (16, 'Gianluigi Donnarumma (Manchester City)', 'insert'),
  (17, 'Erling Haaland (Manchester City)', 'insert'),
  (18, 'Matheus Cunha (Manchester United)', 'insert'),
  (19, 'Benjamin Šeško (Manchester United)', 'insert'),
  (20, 'Bruno Guimarães (Newcastle United)', 'insert'),
  (21, 'Joelinton (Newcastle United)', 'insert'),
  (22, 'Morgan Gibbs-White (Nottingham Forest)', 'insert'),
  (23, 'Brian Brobbey (Sunderland)', 'insert'),
  (24, 'Conor Gallagher (Tottenham)', 'insert'),
  (25, 'Kasey McAteer (Ipswich Town)', 'insert')
  ) as v(number, name, rarity)
  returning id
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, 'normal', 15, 0
from inserted_cards ic;
