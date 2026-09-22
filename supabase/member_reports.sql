-- Run after member_portfolio.sql (needs the members table; independent
-- of the other migrations delivered this session).
--
-- Lets a member report another member (e.g. after a matchning reveal,
-- if someone looks like a scam attempt), and gives the admin a way to
-- block that person's email so they can't just re-register.

create table if not exists member_reports (
  id uuid primary key default gen_random_uuid(),
  reporter_member_id uuid references members(id) on delete set null,
  reported_member_id uuid not null references members(id) on delete cascade,
  reason text not null,
  status text not null default 'open' check (status in ('open', 'resolved')),
  created_at timestamptz not null default now()
);

create index if not exists idx_member_reports_reported on member_reports(reported_member_id);
create index if not exists idx_member_reports_status on member_reports(status);

alter table member_reports enable row level security;
drop policy if exists "Admin can read member_reports" on member_reports;
create policy "Admin can read member_reports" on member_reports for select using (auth.role() = 'authenticated');
drop policy if exists "Admin can update member_reports" on member_reports;
create policy "Admin can update member_reports" on member_reports for update using (auth.role() = 'authenticated');
drop policy if exists "Admin can delete member_reports" on member_reports;
create policy "Admin can delete member_reports" on member_reports for delete using (auth.role() = 'authenticated');
-- No insert policy for the browser — reports are filed through the
-- /api/member/report route with the service-role key, same pattern as
-- every other member-facing write in this project.

-- Emails that can never register again. Checked by /api/member/register
-- before creating an account.
create table if not exists blocked_emails (
  email text primary key,
  reason text,
  blocked_at timestamptz not null default now()
);

alter table blocked_emails enable row level security;
drop policy if exists "Admin can read blocked_emails" on blocked_emails;
create policy "Admin can read blocked_emails" on blocked_emails for select using (auth.role() = 'authenticated');
drop policy if exists "Admin can delete blocked_emails" on blocked_emails;
create policy "Admin can delete blocked_emails" on blocked_emails for delete using (auth.role() = 'authenticated');

notify pgrst, 'reload schema';
