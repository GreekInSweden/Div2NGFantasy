-- Run this BEFORE the catalog import (and before re-running any of the
-- catalog_import/*.sql files that just failed).
--
-- What happened: pitch_black_rarity_fix.sql widened cards_rarity_check to
-- include 'rare' and 'double_rare'. But two later migrations
-- (promo_rarity.sql and topps_rarity.sql) each do their own
-- "drop constraint, then re-add" — and neither of their versions include
-- 'rare'/'double_rare'. Whichever of those ran last silently narrowed the
-- constraint back down, which is why the catalog import (which uses
-- 'rare' for holo-tier cards) just failed on the very first card.
--
-- This sets the constraint to its final, complete form — every rarity
-- value used anywhere in the project — so this doesn't happen again.
-- Safe to run more than once.

alter table cards drop constraint if exists cards_rarity_check;

alter table cards add constraint cards_rarity_check check (
  rarity in (
    'common', 'rare', 'double_rare', 'illustration_rare', 'ultra_rare',
    'special_illustration_rare', 'mega_hyper_rare', 'promo', 'base', 'insert'
  )
);
