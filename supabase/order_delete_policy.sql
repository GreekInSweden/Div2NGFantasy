-- Run this in the Supabase SQL editor after the earlier migrations.
-- Lets the admin permanently delete a CANCELLED order (so it doesn't sit
-- around cluttering the orders list). Scoped to only cancelled orders —
-- paid/shipped records stay protected from accidental deletion, and
-- pending orders must be explicitly cancelled first before they can be
-- removed. order_items for the order are removed automatically via the
-- existing cascading foreign key.

create policy "Authenticated can delete cancelled orders"
  on orders for delete
  using (auth.role() = 'authenticated' and status = 'cancelled');
