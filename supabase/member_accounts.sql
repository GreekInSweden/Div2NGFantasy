-- Run this in the Supabase SQL editor after all earlier migrations.
--
-- Adds real member accounts: registration, login, a member number, a
-- saved profile (contact + shipping info), order history and bid/auction
-- history.
--
-- IMPORTANT — read before running: this deliberately does NOT use
-- Supabase Auth (auth.users), which is what the admin login already
-- uses. Every RLS policy elsewhere in this project checks
-- `auth.role() = 'authenticated'` to mean "the logged-in admin" (see
-- middleware.ts). If members authenticated through Supabase Auth too,
-- any registered member would satisfy that same check and could read or
-- write orders, stock, cards etc. directly, bypassing the admin panel
-- entirely. So members get their own table with their own password hash,
-- and every member-facing feature goes exclusively through this
-- project's API routes (app/api/member/*, app/api/bid, app/api/checkout)
-- using the service-role key — never a direct RLS-governed query from
-- the browser. Nothing here changes how the admin logs in.
--
-- Safe to run more than once.

create sequence if not exists member_number_seq start 1001;

create table if not exists members (
  id uuid primary key default gen_random_uuid(),
  member_number integer not null default nextval('member_number_seq') unique,
  name text not null,
  email text not null unique,
  phone text,
  address text,
  postal_code text,
  city text,
  password_hash text not null,
  created_at timestamptz not null default now()
);

alter table members enable row level security;

-- No select/insert/update policies for anon — this table is reachable
-- only via the service-role key from API routes (signup/login/profile).
-- The admin's own (Supabase Auth) login can read member rows, so the
-- admin panel can show who's behind a member number when arranging
-- payment or shipping.
create policy "Admin can read members" on members for select using (auth.role() = 'authenticated');

-- Link orders, bids and auction wins to a member when they were logged
-- in — all nullable, so nothing about existing guest orders/bids breaks.
alter table orders add column if not exists member_id uuid references members(id);
alter table bids add column if not exists member_id uuid references members(id);
alter table auction_wins add column if not exists member_id uuid references members(id);

create index if not exists idx_orders_member_id on orders(member_id);
create index if not exists idx_bids_member_id on bids(member_id);
create index if not exists idx_auction_wins_member_id on auction_wins(member_id);

notify pgrst, 'reload schema';
