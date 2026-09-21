-- Run this in the Supabase SQL editor after the earlier migrations.
-- Orders and order_items were originally written only via the service-role
-- key in app/api/checkout (so the anon/public role never got any policy on
-- them). This adds the missing piece: letting the logged-in admin actually
-- SEE and manage orders in /admin/bestallningar — view pending ones, mark
-- them paid, or cancel and restore stock if a customer never completes
-- payment.

create policy "Authenticated can read orders"
  on orders for select
  using (auth.role() = 'authenticated');

create policy "Authenticated can update orders"
  on orders for update
  using (auth.role() = 'authenticated');

create policy "Authenticated can read order_items"
  on order_items for select
  using (auth.role() = 'authenticated');
