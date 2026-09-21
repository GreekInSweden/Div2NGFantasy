-- Run this in the Supabase SQL editor after the earlier migrations.
-- Lets the admin permanently delete a CLOSED auction (so old ones don't
-- sit around cluttering the list forever). Scoped to only closed auctions
-- — an auction that's still open (and might have active bidders) stays
-- protected from accidental deletion; close it first via "Markera som
-- avslutad", then it can be deleted. Bids for the auction are removed
-- automatically via the existing cascading foreign key.

create policy "Authenticated can delete closed auctions"
  on auctions for delete
  using (auth.role() = 'authenticated' and status = 'closed');
