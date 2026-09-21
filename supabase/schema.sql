-- Kortlagret — database schema
-- Run this in the Supabase SQL editor (Project > SQL Editor > New query)
-- before running seed_pitch_black.sql.

create extension if not exists "pgcrypto";

-- One row per "set" (e.g. Pitch Black). category_slug groups sets under a
-- top-level category (e.g. "mega-evolution") for the homepage listing.
create table if not exists sets (
  id uuid primary key default gen_random_uuid(),
  category_slug text not null,
  category_name text not null,
  slug text not null unique,
  name text not null,
  created_at timestamptz not null default now()
);

create table if not exists cards (
  id uuid primary key default gen_random_uuid(),
  set_id uuid not null references sets(id) on delete cascade,
  number int not null,
  name text not null,
  rarity text not null check (
    rarity in ('common', 'illustration_rare', 'ultra_rare', 'special_illustration_rare', 'mega_hyper_rare')
  ),
  created_at timestamptz not null default now(),
  unique (set_id, number)
);

-- Each card has up to two sellable variants: normal and holo.
-- stock = 0 means "out of stock" — the storefront greys the card out.
create table if not exists card_variants (
  id uuid primary key default gen_random_uuid(),
  card_id uuid not null references cards(id) on delete cascade,
  variant text not null check (variant in ('normal', 'holo')),
  price_sek numeric(10, 2) not null default 0,
  stock int not null default 0 check (stock >= 0),
  created_at timestamptz not null default now(),
  unique (card_id, variant)
);

create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  order_number text not null unique,
  customer_name text not null,
  email text not null,
  phone text not null,
  address text not null,
  postal_code text not null,
  city text not null,
  subtotal_sek numeric(10, 2) not null,
  shipping_sek numeric(10, 2) not null,
  total_sek numeric(10, 2) not null,
  status text not null default 'pending_payment' check (
    status in ('pending_payment', 'paid', 'shipped', 'cancelled')
  ),
  created_at timestamptz not null default now()
);

create table if not exists order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references orders(id) on delete cascade,
  card_variant_id uuid not null references card_variants(id),
  card_name text not null,
  card_number int not null,
  variant text not null,
  quantity int not null check (quantity > 0),
  unit_price_sek numeric(10, 2) not null
);

-- Indexes for the storefront's main queries.
create index if not exists idx_cards_set_id on cards(set_id);
create index if not exists idx_card_variants_card_id on card_variants(card_id);
create index if not exists idx_order_items_order_id on order_items(order_id);

-- Row Level Security: the browser only ever uses the anon key.
alter table sets enable row level security;
alter table cards enable row level security;
alter table card_variants enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;

-- Anyone can read the catalog (sets/cards/variants) — it's a public shop.
create policy "Public can read sets" on sets for select using (true);
create policy "Public can read cards" on cards for select using (true);
create policy "Public can read card_variants" on card_variants for select using (true);

-- Orders and order_items are written only via the server-side service-role
-- key (app/api/checkout), never directly from the browser, so no insert
-- policy is granted to the anon role here. Reading orders back is also
-- server-only for the same reason.
