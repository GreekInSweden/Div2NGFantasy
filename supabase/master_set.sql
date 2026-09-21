-- Run this in the Supabase SQL editor after the earlier migrations.
--
-- Tracks progress on a personal master/grand master set — completely
-- separate from the shop's card_variants.stock. Checking a card off here
-- never touches what's for sale, and putting a card up for sale never
-- affects this checklist. If a card you're tracking here also happens to
-- leave the shop's stock, that's handled manually (as agreed) by editing
-- the shop's stock number yourself.
--
-- One row = "I personally own this card/variant for my set." No row =
-- not owned yet. That's all this table records.
--
-- Master set = one of every card, in every variant that was actually
-- printed for it (normal, plus holo where a holo print exists).
-- Grand master set = master set + also one of every reverse holo where a
-- reverse holo print exists. Which variants "exist" for a card is read
-- from whichever card_variants rows you've already set up in the shop —
-- same source of truth the Paket page uses — so a card never asks for a
-- variant that was never printed.

create table if not exists master_set_progress (
  id uuid primary key default gen_random_uuid(),
  card_id uuid not null references cards(id) on delete cascade,
  variant text not null check (variant in ('normal', 'holo', 'reverse_holo')),
  owned_at timestamptz not null default now(),
  unique (card_id, variant)
);

create index if not exists idx_master_set_progress_card_id on master_set_progress(card_id);

alter table master_set_progress enable row level security;

-- Admin-only, same pattern as auctions/bids — nothing here is ever public.
create policy "Authenticated can read master set progress"
  on master_set_progress for select
  using (auth.role() = 'authenticated');

create policy "Authenticated can insert master set progress"
  on master_set_progress for insert
  with check (auth.role() = 'authenticated');

create policy "Authenticated can delete master set progress"
  on master_set_progress for delete
  using (auth.role() = 'authenticated');
