-- Run after member_accounts.sql (and safe to run any time after that,
-- independent of the other migrations delivered this session).
--
-- Lets the admin delete a member account from /admin/medlemmar.
--
-- Two things had to change for that to be safe:
--
-- 1. orders/bids/auction_wins.member_id had no ON DELETE behaviour at
--    all (the default is RESTRICT), so deleting a member who ever bid,
--    ordered, or won an auction would simply fail outright. This
--    switches those three to ON DELETE SET NULL instead, so the
--    historical bid/order/win rows stay intact (an auction's bid
--    history is public record) — they just stop pointing at a member
--    that no longer exists. The UI already falls back to "Okänd medlem"
--    wherever a bid's member can't be resolved, so this degrades
--    gracefully.
--
-- 2. member_cards only had an RLS *select* policy for the admin. A
--    cascade delete (member_cards has ON DELETE CASCADE on member_id)
--    still has to pass RLS on the table being cascaded into, so without
--    a delete policy there the whole deletion would be silently
--    blocked. This adds it.
--
-- Safe to run more than once.

do $$
declare
  r record;
begin
  for r in
    select tc.constraint_name, tc.table_name
    from information_schema.table_constraints tc
    join information_schema.key_column_usage kcu
      on tc.constraint_name = kcu.constraint_name and tc.table_schema = kcu.table_schema
    join information_schema.constraint_column_usage ccu
      on tc.constraint_name = ccu.constraint_name and tc.table_schema = ccu.table_schema
    where tc.constraint_type = 'FOREIGN KEY'
      and tc.table_name in ('orders', 'bids', 'auction_wins')
      and kcu.column_name = 'member_id'
      and ccu.table_name = 'members'
  loop
    execute format('alter table %I drop constraint %I', r.table_name, r.constraint_name);
  end loop;
end $$;

alter table orders
  add constraint orders_member_id_fkey
  foreign key (member_id) references members(id) on delete set null;

alter table bids
  add constraint bids_member_id_fkey
  foreign key (member_id) references members(id) on delete set null;

alter table auction_wins
  add constraint auction_wins_member_id_fkey
  foreign key (member_id) references members(id) on delete set null;

drop policy if exists "Admin can delete members" on members;
create policy "Admin can delete members" on members for delete using (auth.role() = 'authenticated');

drop policy if exists "Admin can delete member_cards" on member_cards;
create policy "Admin can delete member_cards" on member_cards for delete using (auth.role() = 'authenticated');

notify pgrst, 'reload schema';
