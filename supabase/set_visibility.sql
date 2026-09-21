-- Run this in the Supabase SQL editor after the earlier migrations.
-- Lets you prepare a set (add all its cards) in the admin panel without it
-- showing up in the public shop yet — useful while you're still building up
-- stock and haven't got any of that set's cards in hand.

alter table sets add column if not exists is_visible boolean not null default true;

comment on column sets.is_visible is
  'When false, the set (and its cards) is hidden from the public storefront but still fully editable in /admin.';

-- The admin panel could insert new sets already, but toggling visibility on
-- an existing one needs an UPDATE policy too.
create policy "Authenticated can update sets"
  on sets for update
  using (auth.role() = 'authenticated');
