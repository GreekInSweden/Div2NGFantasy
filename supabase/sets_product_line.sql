-- Distinguishes Pokémon sets from sports-card sets (Topps, and any future
-- sports-card lines/seasons) so the storefront can group and style them
-- separately instead of mixing everything into one flat category grid.
-- Safe to re-run.
--
-- Run this once in the Supabase SQL editor. After this, any NEW Topps (or
-- other sports-card) category you add should be inserted with
-- product_line = 'sportkort' explicitly — see the note at the bottom.

alter table sets add column if not exists product_line text not null default 'pokemon';

do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'sets_product_line_check'
  ) then
    alter table sets add constraint sets_product_line_check
      check (product_line in ('pokemon', 'sportkort'));
  end if;
end $$;

-- Backfill: every existing Topps category becomes 'sportkort'. Everything
-- else (all Pokémon eras) stays the default 'pokemon'.
update sets set product_line = 'sportkort' where category_slug like 'topps-%';

-- Going forward: any insert into `sets` for a new sports-card product
-- (a new Topps season, a different sport, a different manufacturer) needs
-- product_line = 'sportkort' added explicitly, e.g.:
--
--   insert into sets (category_slug, category_name, slug, name, is_visible, product_line)
--   values ('topps-premier-league-25-26', 'Topps Premier League 2025/26', 'grundset', 'Grundset', false, 'sportkort')
