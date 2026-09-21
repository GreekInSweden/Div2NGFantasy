-- Run this FIRST, before the new seed file below.
-- Deletes the old manually-built "MEP Black Star Promos Singles" set.
-- Cards and card_variants belonging to it are removed automatically
-- (cascading delete via foreign key), so any stock/price you'd already
-- set on cards like Zarude or Binacle will need to be re-entered in the
-- new, complete set that seed_mep_promos.sql creates right after this.

delete from sets where name = 'MEP Black Star Promos Singles';
