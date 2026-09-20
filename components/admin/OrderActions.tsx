"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";

interface OrderItemRef {
  cardVariantId: string;
  quantity: number;
}

export default function OrderActions({
  orderId,
  items,
}: {
  orderId: string;
  items: OrderItemRef[];
}) {
  const router = useRouter();
  const [loading, setLoading] = useState<"paid" | "cancel" | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function handleMarkPaid() {
    setLoading("paid");
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: updateError } = await supabase
      .from("orders")
      .update({ status: "paid" })
      .eq("id", orderId);
    setLoading(null);
    if (updateError) {
      setError(updateError.message);
      return;
    }
    router.refresh();
  }

  async function handleCancel() {
    if (
      !confirm(
        "Avbryta ordern och lägga tillbaka korten i lager? Gör bara det här om du är säker på att kunden aldrig betalade."
      )
    ) {
      return;
    }
    setLoading("cancel");
    setError(null);
    const supabase = createBrowserSupabase();

    // Restore stock for every item in the order before cancelling it.
    for (const item of items) {
      const { data: variant, error: fetchError } = await supabase
        .from("card_variants")
        .select("stock")
        .eq("id", item.cardVariantId)
        .single();
      if (fetchError || !variant) {
        setError(`Kunde inte återställa lager för ett kort: ${fetchError?.message}`);
        setLoading(null);
        return;
      }
      const { error: restoreError } = await supabase
        .from("card_variants")
        .update({ stock: variant.stock + item.quantity })
        .eq("id", item.cardVariantId);
      if (restoreError) {
        setError(`Kunde inte återställa lager: ${restoreError.message}`);
        setLoading(null);
        return;
      }
    }

    const { error: cancelError } = await supabase
      .from("orders")
      .update({ status: "cancelled" })
      .eq("id", orderId);

    setLoading(null);
    if (cancelError) {
      setError(cancelError.message);
      return;
    }
    router.refresh();
  }

  return (
    <div>
      <div className="flex gap-2">
        <button
          onClick={handleMarkPaid}
          disabled={loading !== null}
          className="focus-ring text-xs rounded-sm bg-gold text-ink font-semibold px-3 py-1.5 disabled:opacity-50"
        >
          {loading === "paid" ? "Markerar…" : "Markera betald"}
        </button>
        <button
          onClick={handleCancel}
          disabled={loading !== null}
          className="focus-ring text-xs rounded-sm border border-line text-paper px-3 py-1.5 hover:border-red-400 hover:text-red-400 disabled:opacity-50"
        >
          {loading === "cancel" ? "Återställer lager…" : "Avbryt & lägg tillbaka i lager"}
        </button>
      </div>
      {error && <p className="text-xs text-red-400 mt-2">{error}</p>}
    </div>
  );
}
