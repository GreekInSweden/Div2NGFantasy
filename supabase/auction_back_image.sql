-- Run after auctions.sql / reserve_price.sql.
--
-- Auctions get their own front AND back image, separate from the card's
-- regular shop image. This matters because an auction is for one specific
-- physical copy (with its own condition/centering/edge wear) — bidders
-- need to see exactly what they'd be buying, not the generic stock photo
-- used for the whole print run in the regular shop.

alter table auctions add column if not exists front_image_url text;
alter table auctions add column if not exists back_image_url text;
