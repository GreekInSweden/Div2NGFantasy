-- Run this in the Supabase SQL editor after auctions.sql.
-- Adds a hidden reserve price: the real minimum you're willing to accept,
-- separate from the public starting price. Bidding still works exactly the
-- same, but the storefront shows "reserve not met" instead of the actual
-- number whenever the current highest bid is below it — so you can see what
-- the market offers without ever being nudged to sell under value.

alter table auctions add column if not exists reserve_price_sek numeric(10, 2);

comment on column auctions.reserve_price_sek is
  'Hidden minimum acceptable sale price. NULL means no reserve — any winning bid is acceptable. Never exposed to the public API, only to the admin panel.';
