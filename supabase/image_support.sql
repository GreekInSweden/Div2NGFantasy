-- Run this in the Supabase SQL editor AFTER admin_policies.sql.
-- Adds image support: a column to store each card's photo URL, a public
-- storage bucket to hold the uploaded files, and the policies needed for
-- the admin panel to upload photos and for the storefront to display them.

alter table cards add column if not exists image_url text;

-- The admin panel already had insert rights on `cards`, but editing an
-- existing card's image needs UPDATE too.
create policy "Authenticated can update cards"
  on cards for update
  using (auth.role() = 'authenticated');

-- Public storage bucket for card photos. "public" here means anyone can
-- VIEW a file by URL (needed so the storefront can show it) — it does not
-- mean anyone can upload; that's controlled by the policies below.
insert into storage.buckets (id, name, public)
values ('card-images', 'card-images', true)
on conflict (id) do nothing;

create policy "Public can view card images"
  on storage.objects for select
  using (bucket_id = 'card-images');

create policy "Authenticated can upload card images"
  on storage.objects for insert
  with check (bucket_id = 'card-images' and auth.role() = 'authenticated');

create policy "Authenticated can replace card images"
  on storage.objects for update
  using (bucket_id = 'card-images' and auth.role() = 'authenticated');
