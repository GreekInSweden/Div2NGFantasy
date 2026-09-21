-- Run this in the Supabase SQL editor after the earlier migrations.
--
-- Adds two rarity tiers that were missing from the schema, and uses them
-- to correct the Pitch Black set specifically:
--
--   'rare'        -- a holo-tier card that never gets a plain non-holo
--                     print (e.g. Armarouge, Primarina, Miraidon) — its
--                     base/ordinary print is the "holo" card_variants row,
--                     not "normal". Can still get a reverse holo print.
--   'double_rare' -- an "ex" card (e.g. Lurantis ex, Mega Delphox ex) —
--                     single print, no separate holo or reverse holo.
--
-- When Pitch Black was originally seeded, every card only had the
-- 'common' rarity available for anything that wasn't already Illustration
-- Rare/Ultra Rare/Special Illustration Rare/Hyper Rare, which mis-tagged
-- both the "ex" cards and the holo-tier "Rare" cards as plain commons.
-- This corrects those 20 cards to their real rarity. It does NOT touch
-- card_variants (existing prices/stock stay exactly as they are) — the
-- app now reads which variant is a card's "base" print from its rarity,
-- so nothing needs to be deleted for this to work correctly.
--
-- Safe to run more than once.

alter table cards drop constraint if exists cards_rarity_check;

alter table cards add constraint cards_rarity_check check (
  rarity in (
    'common', 'rare', 'double_rare', 'illustration_rare', 'ultra_rare',
    'special_illustration_rare', 'mega_hyper_rare', 'promo', 'base', 'insert'
  )
);

-- Double Rare / ex cards (single print, no holo/reverse holo distinction).
update cards
set rarity = 'double_rare'
from sets
where cards.set_id = sets.id
  and sets.slug = 'pitch-black'
  and cards.number in (4, 8, 16, 27, 38, 45, 48, 55, 65)
  and cards.rarity = 'common';

-- Rare tier: holo is the base print, reverse holo also exists for these.
update cards
set rarity = 'rare'
from sets
where cards.set_id = sets.id
  and sets.slug = 'pitch-black'
  and cards.number in (12, 20, 28, 35, 47, 56, 59, 62, 70, 83, 84)
  and cards.rarity = 'common';
