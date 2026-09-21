-- Run this in the Supabase SQL editor after the earlier auction migrations
-- (auctions.sql, auction_columns_fix.sql, auction_back_image.sql,
-- auction_delete_policy.sql).
--
-- Changes the bidding flow so bidders don't have to fill in namn/e-post/
-- telefon on every single bid:
--
--   * Each browser gets a random "bidder token" (generated in the browser,
--     stored in localStorage — no personal info in it) that's sent along
--     with every bid from that browser, just so the server can tell "was
--     this the same bidder as that other bid".
--   * When an auction's end time passes, the storefront (which polls
--     /api/auctions regularly) closes it automatically. If there was a
--     winning bid and any reservation price was met, an auction_wins row
--     is created for that bidder's token — the "outbox" entry. That
--     bidder's browser then recognizes its own token next time it loads
--     the auctions page and shows a banner leading to a claim page, where
--     they fill in namn/e-post/telefon (for the very first time) and see
--     the Swish payment info.
--   * A win nobody claims within 7 days flips to 'expired' automatically,
--     so the admin auction list makes it obvious the card is free to
--     re-list. Nothing is deleted.
--
-- Safe to run more than once.

alter table bids alter column bidder_name drop not null;
alter table bids alter column email drop not null;
alter table bids alter column phone drop not null;
alter table bids add column if not exists bidder_token text;
create index if not exists idx_bids_bidder_token on bids(bidder_token);

create table if not exists auction_wins (
  id uuid primary key default gen_random_uuid(),
  auction_id uuid not null references auctions(id) on delete cascade,
  bidder_token text not null,
  amount_sek numeric(10, 2) not null,
  buyer_name text,
  buyer_email text,
  buyer_phone text,
  status text not null default 'pending' check (status in ('pending', 'claimed', 'paid', 'expired')),
  claim_deadline timestamptz not null,
  claimed_at timestamptz,
  created_at timestamptz not null default now()
);

-- One win per auction — the closing sweep upserts on this, so it can
-- never accidentally create a second win row for the same auction.
create unique index if not exists idx_auction_wins_auction_id on auction_wins(auction_id);
create index if not exists idx_auction_wins_bidder_token on auction_wins(bidder_token);

alter table auction_wins enable row level security;

-- Same pattern as auctions/bids: no anon policies at all — the storefront
-- only ever reads/writes auction_wins through the API routes (service
-- role key), so a claim link can't be used to snoop on someone else's win,
-- and only the logged-in admin can see/update rows directly (e.g. to mark
-- one "paid" from the admin panel).
create policy "Authenticated can read auction_wins" on auction_wins for select using (auth.role() = 'authenticated');
create policy "Authenticated can update auction_wins" on auction_wins for update using (auth.role() = 'authenticated');

notify pgrst, 'reload schema';
