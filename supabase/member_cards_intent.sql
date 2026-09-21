-- Run after member_portfolio.sql.
--
-- Adds an optional intent to a "have" entry: is the member actually open
-- to selling and/or trading this specific card, or are they just
-- tracking their own collection? Both default to false, so existing
-- "have" rows (and anything marked have without touching these) simply
-- don't show up as available in matches until the member opts in.
-- Meaningless for "want" rows, but harmless to leave false there too.

alter table member_cards add column if not exists sellable boolean not null default false;
alter table member_cards add column if not exists tradeable boolean not null default false;

notify pgrst, 'reload schema';
