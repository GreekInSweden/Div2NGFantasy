-- Kör det här i Supabase -> SQL Editor -> "New query" -> klistra in -> Run

create table if not exists push_subscriptions (
  id uuid primary key default gen_random_uuid(),
  member_name text not null,
  endpoint text not null unique,
  p256dh text not null,
  auth text not null,
  created_at timestamptz not null default now()
);

create index if not exists push_subscriptions_member_name_idx
  on push_subscriptions (member_name);

-- Rad-nivå-säkerhet (RLS)
alter table push_subscriptions enable row level security;

-- Appen har ingen inloggning (för att hålla det enkelt för en privat
-- familjeapp), så vi öppnar upp läs/skriv för alla som har din anon-nyckel
-- (dvs. alla som har appens URL). Det är ett medvetet avvägt val för ett
-- litet privat projekt - dela INTE appens URL offentligt.
create policy "Öppen insert för familjeappen"
  on push_subscriptions for insert
  to anon
  with check (true);

create policy "Öppen update för familjeappen"
  on push_subscriptions for update
  to anon
  using (true)
  with check (true);

create policy "Öppen select för familjeappen"
  on push_subscriptions for select
  to anon
  using (true);

-- ============================================================
-- Meddelandehistorik - så man kan se skickade meddelanden i
-- appen även om man missar själva push-notisen.
-- ============================================================

create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  from_name text not null,
  to_names text[] not null,
  body text not null,
  created_at timestamptz not null default now()
);

create index if not exists messages_created_at_idx
  on messages (created_at desc);

alter table messages enable row level security;

-- Klienten läser meddelanden med den publika (anon) nyckeln.
-- Att skriva nya meddelanden görs bara av servern (med service_role-nyckeln,
-- som kringgår RLS helt), så ingen "insert"-policy för anon behövs här.
create policy "Öppen select för meddelanden"
  on messages for select
  to anon
  using (true);

-- Aktivera realtidsuppdateringar för messages-tabellen, så nya meddelanden
-- dyker upp direkt i appen utan att man behöver ladda om sidan.
alter publication supabase_realtime add table messages;
