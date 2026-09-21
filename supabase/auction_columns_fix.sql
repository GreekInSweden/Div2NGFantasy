-- Fixes "Could not find the 'reserve_price_sek' column of 'auctions' in
-- the schema cache" when creating an auction.
--
-- That error means the column genuinely doesn't exist yet in your database
-- — reserve_price_sek was added by an older migration (reserve_price.sql)
-- that looks like it was never actually run. This script is a safe,
-- all-in-one catch-up: it adds every auctions column the app currently
-- expects (reserve price + the front/back auction images), no matter which
-- of the earlier auction SQL files you've already run, and then forces
-- Supabase's API layer to pick up the new columns immediately instead of
-- waiting for its own cache to refresh on its own.
--
-- Safe to run multiple times.

alter table auctions add column if not exists reserve_price_sek numeric(10, 2);
alter table auctions add column if not exists front_image_url text;
alter table auctions add column if not exists back_image_url text;

comment on column auctions.reserve_price_sek is
  'Hidden minimum acceptable sale price. NULL means no reserve — any winning bid is acceptable. Never exposed to the public API, only to the admin panel.';

-- Tell PostgREST (Supabase's auto-generated API) to reload its schema
-- cache right now, instead of waiting for the next automatic refresh —
-- this is what was actually causing the "not found in schema cache" error.
notify pgrst, 'reload schema';
