-- Run this in the Supabase SQL editor after the earlier migrations.
-- Adds "promo" as a valid rarity, for Black Star Promos and other bonus
-- cards that come bundled with ETBs, blisters, tins etc. and don't belong
-- to any numbered set's official 1-120 card list.

alter table cards drop constraint if exists cards_rarity_check;

alter table cards add constraint cards_rarity_check check (
  rarity in ('common', 'illustration_rare', 'ultra_rare', 'special_illustration_rare', 'mega_hyper_rare', 'promo')
);
