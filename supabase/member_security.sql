-- Run this in the Supabase SQL editor after member_accounts.sql.
--
-- Adds:
--   * Account lockout — after too many wrong passwords in a row, a
--     member's account is locked for 15 minutes, so a script can't just
--     keep guessing passwords forever.
--   * A generic rate_limit_events table — used by the login, register
--     and password-reset API routes to cap how many attempts a single IP
--     address can make in a time window (brute force / spam protection).
--     Works across Vercel's serverless instances because it's in the
--     database, not in server memory.
--   * Self-service password reset — a member requests a reset, it shows
--     up in the admin panel (Medlemmar), and the admin generates a
--     one-time link to send them (this project has no outbound email
--     yet, so this mirrors how Swish payments are already handled here:
--     manually, by the admin, rather than a fully automated email flow).
--
-- Safe to run more than once.

alter table members add column if not exists failed_login_attempts integer not null default 0;
alter table members add column if not exists locked_until timestamptz;
alter table members add column if not exists password_reset_token_hash text;
alter table members add column if not exists password_reset_expires_at timestamptz;
alter table members add column if not exists password_reset_requested_at timestamptz;

create index if not exists idx_members_password_reset_token_hash on members(password_reset_token_hash);

create table if not exists rate_limit_events (
  id bigint generated always as identity primary key,
  bucket text not null,
  created_at timestamptz not null default now()
);
create index if not exists idx_rate_limit_events_bucket_created on rate_limit_events(bucket, created_at);

alter table rate_limit_events enable row level security;
-- No policies at all — only ever touched via the service-role key from
-- API routes, exactly like the members table itself.

-- Lets the admin panel unlock an account or generate a password-reset
-- link by writing directly through the browser client (RLS), the same
-- way every other admin action in this project already works (closing
-- an auction, marking an order paid, etc.) — no new API route needed.
create policy "Admin can update members" on members for update using (auth.role() = 'authenticated');

notify pgrst, 'reload schema';
