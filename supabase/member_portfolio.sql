-- Run this in the Supabase SQL editor after member_accounts.sql and
-- member_security.sql.
--
-- Adds the portfolio/wishlist/matching feature discussed in chat:
--   * Members mark cards (per variant) as "har" (own) or "vill ha" (want).
--   * A public "Mest eftertraktade kort" page aggregates want-counts
--     across everyone — no member identity in that view, just counts.
--   * A "Mina matchningar" page shows a member their own wants that line
--     up with another member's haves. Nobody's contact details are ever
--     exposed by that listing itself — a match only shows a card + that
--     the other side is anonymous "en annan medlem" until the viewer
--     explicitly asks to reveal, which the API re-verifies server-side
--     before returning anything (see app/api/member/matchningar/reveal).
--   * Each member chooses, in their own profile, which contact channels
--     (if any) to show when that reveal happens — nothing is shared by
--     default.
--
-- Safe to run more than once.

alter table members add column if not exists contact_messenger text;
alter table members add column if not exists contact_whatsapp text;
alter table members add column if not exists contact_other text;

create table if not exists member_cards (
  id uuid primary key default gen_random_uuid(),
  member_id uuid not null references members(id) on delete cascade,
  card_id uuid not null references cards(id) on delete cascade,
  variant text not null check (variant in ('normal', 'holo', 'reverse_holo')),
  status text not null check (status in ('have', 'want')),
  quantity integer not null default 1,
  created_at timestamptz not null default now(),
  unique (member_id, card_id, variant, status)
);

create index if not exists idx_member_cards_member on member_cards(member_id);
create index if not exists idx_member_cards_card_variant_status
  on member_cards(card_id, variant, status);

alter table member_cards enable row level security;

-- Same pattern as the rest of the member system: no anon/browser access
-- at all — every read/write goes through the API routes (service role).
-- The admin login can still read it directly for troubleshooting.
create policy "Admin can read member_cards" on member_cards for select using (auth.role() = 'authenticated');

notify pgrst, 'reload schema';
