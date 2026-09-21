-- Run this in the Supabase SQL editor AFTER schema.sql, to enable the admin
-- panel (app/admin) to save stock changes.
--
-- Why this is needed: schema.sql only granted public SELECT on the catalog
-- tables. The admin panel logs in via Supabase Auth and then updates stock
-- directly from the browser, so we need an UPDATE policy that only allows
-- this for a logged-in (authenticated) user — anonymous visitors still
-- cannot change anything.

create policy "Authenticated can update card_variants"
  on card_variants for update
  using (auth.role() = 'authenticated');

create policy "Authenticated can insert cards"
  on cards for insert
  with check (auth.role() = 'authenticated');

create policy "Authenticated can insert card_variants"
  on card_variants for insert
  with check (auth.role() = 'authenticated');

create policy "Authenticated can insert sets"
  on sets for insert
  with check (auth.role() = 'authenticated');
