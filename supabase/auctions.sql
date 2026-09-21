-- Run this in the Supabase SQL editor after the earlier migrations.
-- Adds auction support for high-value single cards, alongside the regular
-- fixed-price shop.
--
-- Design notes:
-- * Bids are never exposed directly to anonymous visitors — the storefront
--   only ever talks to app/api/auctions and app/api/bid, which use the
--   service-role key server-side. That keeps bidder name/email/phone away
--   from anyone just browsing, and lets us validate "is this actually the
--   highest bid?" safely on the server instead of trusting the browser.
-- * The admin panel (already behind login) gets full SELECT access so you
--   can see who's winning and their contact details, to arrange payment
--   the same manual-Swish way as regular orders.

create table if not exists auctions (
  id uuid primary key default gen_random_uuid(),
  card_variant_id uuid not null references card_variants(id),
  starting_price_sek numeric(10, 2) not null,
  min_increment_sek numeric(10, 2) not null default 10,
  ends_at timestamptz not null,
  status text not null default 'open' check (status in ('open', 'closed')),
  created_at timestamptz not null default now()
);

create table if not exists bids (
  id uuid primary key default gen_random_uuid(),
  auction_id uuid not null references auctions(id) on delete cascade,
  bidder_name text not null,
  email text not null,
  phone text not null,
  amount_sek numeric(10, 2) not null,
  created_at timestamptz not null default now()
);

create index if not exists idx_bids_auction_id on bids(auction_id);

alter table auctions enable row level security;
alter table bids enable row level security;

-- No anon policies at all on either table on purpose — the storefront reads
-- and writes exclusively through the API routes (service role). Only the
-- logged-in admin gets direct access, for the admin auctions dashboard.
create policy "Authenticated can read auctions" on auctions for select using (auth.role() = 'authenticated');
create policy "Authenticated can insert auctions" on auctions for insert with check (auth.role() = 'authenticated');
create policy "Authenticated can update auctions" on auctions for update using (auth.role() = 'authenticated');
create policy "Authenticated can read bids" on bids for select using (auth.role() = 'authenticated');
