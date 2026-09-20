"use client";

import { useState } from "react";
import { variantLabel } from "@/lib/variant";
import OrderActions from "@/components/admin/OrderActions";
import DeleteOrderButton from "@/components/admin/DeleteOrderButton";

interface OrderItem {
  card_variant_id: string;
  card_name: string;
  card_number: number;
  variant: string;
  quantity: number;
  unit_price_sek: number;
}

interface OrderRow {
  id: string;
  order_number: string;
  customer_name: string;
  email: string;
  phone: string;
  address: string;
  postal_code: string;
  city: string;
  subtotal_sek: number;
  shipping_sek: number;
  total_sek: number;
  status: string;
  created_at: string;
  items: OrderItem[];
}

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

export default function ArchivedOrders({ orders }: { orders: OrderRow[] }) {
  const [expanded, setExpanded] = useState(false);

  if (orders.length === 0) return null;

  return (
    <div className="mt-8 pt-6 border-t border-line">
      <button
        onClick={() => setExpanded((e) => !e)}
        className="focus-ring text-sm text-mute hover:text-paper flex items-center gap-2"
      >
        <span>{expanded ? "▾" : "▸"}</span>
        Äldre beställningar ({orders.length}, mer än 30 dagar gamla)
      </button>

      {expanded && (
        <div className="space-y-4 mt-4">
          {orders.map((o) => (
            <div key={o.id} className="border border-line rounded-md p-4 bg-panel opacity-80">
              <div className="flex items-start justify-between mb-2 gap-3">
                <div>
                  <div className="font-mono text-sm text-paper">{o.order_number}</div>
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
                    <span className="font-mono">{item.unit_price_sek * item.quantity} kr</span>
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
    </div>
  );
}
