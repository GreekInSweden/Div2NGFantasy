import { createServerSupabase } from "@/lib/supabase/server";
import { variantLabel } from "@/lib/variant";
import OrderActions from "@/components/admin/OrderActions";
import DeleteOrderButton from "@/components/admin/DeleteOrderButton";
import ArchivedOrders from "@/components/admin/ArchivedOrders";

export const dynamic = "force-dynamic";

const statusLabel: Record<string, string> = {
  pending_payment: "Väntar på betalning",
  paid: "Betald",
  shipped: "Skickad",
  cancelled: "Avbruten",
};

const statusColor: Record<string, string> = {
  pending_payment: "bg-amber-500/10 text-amber-400",
  paid: "bg-gold/10 text-gold",
  shipped: "bg-green-500/10 text-green-400",
  cancelled: "bg-line text-mute",
};

const ARCHIVE_AFTER_DAYS = 30;

export default async function BestallningarPage() {
  const supabase = createServerSupabase();

  const { data: orders, error } = await supabase
    .from("orders")
    .select(
      "id, order_number, customer_name, email, phone, address, postal_code, city, subtotal_sek, shipping_sek, total_sek, status, created_at"
    )
    .order("created_at", { ascending: false });

  const ordersWithItems = await Promise.all(
    (orders ?? []).map(async (o) => {
      const { data: items } = await supabase
        .from("order_items")
        .select("card_variant_id, card_name, card_number, variant, quantity, unit_price_sek")
        .eq("order_id", o.id);
      return { ...o, items: items ?? [] };
    })
  );

  const cutoff = Date.now() - ARCHIVE_AFTER_DAYS * 24 * 60 * 60 * 1000;
  const recentOrders = ordersWithItems.filter(
    (o) => new Date(o.created_at).getTime() >= cutoff
  );
  const archivedOrders = ordersWithItems.filter(
    (o) => new Date(o.created_at).getTime() < cutoff
  );

  const pendingCount = ordersWithItems.filter(
    (o) => o.status === "pending_payment"
  ).length;

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Beställningar
      </h1>
      <p className="text-mute mb-8">
        {pendingCount > 0
          ? `${pendingCount} väntar på betalning — kolla ålder (datum nedan) och avbryt de som verkar övergivna för att frigöra korten igen.`
          : "Inga obetalda beställningar väntar just nu."}
      </p>

      {error ? (
        <p className="text-red-400 text-sm">Kunde inte hämta beställningar.</p>
      ) : ordersWithItems.length === 0 ? (
        <p className="text-mute">Inga beställningar ännu.</p>
      ) : (
        <>
          {recentOrders.length === 0 ? (
            <p className="text-mute">
              Inga beställningar de senaste {ARCHIVE_AFTER_DAYS} dagarna.
            </p>
          ) : (
            <div className="space-y-4">
              {recentOrders.map((o) => (
                <div key={o.id} className="border border-line rounded-md p-4 bg-panel">
                  <div className="flex items-start justify-between mb-2 gap-3">
                    <div>
                      <div className="font-mono text-sm text-paper">
                        {o.order_number}
                      </div>
                      <div className="text-xs text-mute">
                        {new Date(o.created_at).toLocaleString("sv-SE")}
                      </div>
                    </div>
                    <span
                      className={`text-xs font-mono px-2 py-1 rounded-sm shrink-0 ${statusColor[o.status]}`}
                    >
                      {statusLabel[o.status] ?? o.status}
                    </span>
                  </div>

                  <div className="text-sm text-paper mb-1">{o.customer_name}</div>
                  <div className="text-xs text-mute mb-3">
                    {o.email} · {o.phone} · {o.address}, {o.postal_code} {o.city}
                  </div>

                  <div className="space-y-1 mb-3">
                    {o.items.map((item, i) => (
                      <div key={i} className="text-sm flex justify-between text-paper">
                        <span>
                          #{String(item.card_number).padStart(3, "0")} {item.card_name}{" "}
                          <span className="text-mute">
                            ({variantLabel[item.variant as keyof typeof variantLabel] ?? "Vanligt"}) ×{item.quantity}
                          </span>
                        </span>
                        <span className="font-mono">
                          {item.unit_price_sek * item.quantity} kr
                        </span>
                      </div>
                    ))}
                  </div>

                  <div className="text-xs text-mute font-mono mb-3">
                    Delsumma {o.subtotal_sek} kr · Frakt {o.shipping_sek} kr ·{" "}
                    <span className="text-paper font-semibold">Totalt {o.total_sek} kr</span>
                  </div>

                  {o.status === "pending_payment" && (
                    <OrderActions
                      orderId={o.id}
                      items={o.items.map((i) => ({
                        cardVariantId: i.card_variant_id,
                        quantity: i.quantity,
                      }))}
                    />
                  )}
                  {o.status === "cancelled" && <DeleteOrderButton orderId={o.id} />}
                </div>
              ))}
            </div>
          )}

          <ArchivedOrders orders={archivedOrders} />
        </>
      )}
    </div>
  );
}
