-- Run this in the Supabase SQL editor after the earlier migrations.
-- Adds two generic rarity tiers so non-Pokemon card lines (like Topps
-- football cards, which don't use Illustration Rare/Ultra Rare etc.) fit
-- the same cards/card_variants structure:
--   'base'   -- an ordinary numbered card from the main set
--   'insert' -- a themed insert set card (Beast Mode, 8-Bit Ballers, etc.)

alter table cards drop constraint if exists cards_rarity_check;

alter table cards add constraint cards_rarity_check check (
  rarity in (
    'common', 'illustration_rare', 'ultra_rare', 'special_illustration_rare',
    'mega_hyper_rare', 'promo', 'base', 'insert'
  )
);
