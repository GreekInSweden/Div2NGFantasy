-- Run this ONLY if you already ran the catalog import (base.sql,
-- gym.sql and/or neo.sql from supabase/catalog_import/) before this
-- fix. If you haven't run the catalog import yet, or are running it for
-- the first time now, skip this file entirely — the corrected
-- base.sql/gym.sql/neo.sql already get this right and you don't need it.
--
-- What happened: reverse holo prints didn't exist in the TCG until Neo
-- Destiny (2002/02/28). The first version of the catalog import gave
-- every common/rare-tier card a "Reverse Holo" checklist option
-- regardless of era, which incorrectly offered it for Base Set, Jungle,
-- Fossil, Team Rocket, Base Set 2, the Wizards-era promos, Gym Heroes,
-- Gym Challenge, and Neo Genesis/Discovery/Revelation (Neo Destiny
-- itself is correct — that's the set that introduced it).
--
-- This removes those specific wrongly-added rows. member_cards stores
-- its variant as plain text (not a foreign key to card_variants), so
-- this delete can't cascade into anyone's portfolio — if a member
-- already marked one of these bogus reverse-holo cards, that entry is
-- harmless leftover data rather than a broken reference; worth a quick
-- manual glance at member_cards if that matters to you, but nothing
-- breaks either way.
--
-- Safe to run more than once.

delete from card_variants
where variant = 'reverse_holo'
  and card_id in (
    select c.id
    from cards c
    join sets s on s.id = c.set_id
    where s.slug in (
      'base', 'jungle', 'fossil', 'base-set-2', 'team-rocket',
      'wizards-black-star-promos',
      'gym-heroes', 'gym-challenge',
      'neo-genesis', 'neo-discovery', 'neo-revelation'
    )
  );
