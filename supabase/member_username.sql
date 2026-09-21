-- Run after member_accounts.sql / member_security.sql / member_portfolio.sql.
--
-- Adds an optional, self-chosen display username — shown instead of
-- "Medlem #47" on auction bid history/leaderboard and in the header, so
-- it's easier to recognize yourself and others without exposing any real
-- identity. Chosen once at registration; nullable so members who
-- registered before this migration just keep showing as "Medlem #X"
-- until support for changing/backfilling it is built later.

alter table members add column if not exists username text;

-- Case-insensitive uniqueness (so "PikaMaster" and "pikamaster" can't
-- both be taken) without forcing lowercase storage — we keep the
-- member's own casing for display.
create unique index if not exists members_username_unique_ci
  on members (lower(username))
  where username is not null;

alter table members drop constraint if exists members_username_format;
alter table members add constraint members_username_format check (
  username is null or (
    length(username) between 3 and 20
    and username ~ '^[A-Za-z0-9_-]+$'
  )
);
