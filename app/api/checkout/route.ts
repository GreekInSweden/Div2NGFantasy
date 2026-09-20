import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { MEMBER_SESSION_COOKIE, verifyMemberSession } from "@/lib/memberSession";

interface CheckoutItem {
  variantId: string;
  cardName: string;
  cardNumber: number;
  variant: "normal" | "holo";
  quantity: number;
  unitPriceSek: number;
}

function generateOrderNumber(): string {
  const now = new Date();
  const y = now.getFullYear().toString().slice(-2);
  const m = String(now.getMonth() + 1).padStart(2, "0");
  const d = String(now.getDate()).padStart(2, "0");
  const rand = Math.floor(1000 + Math.random() * 9000);
  return `KL-${y}${m}${d}-${rand}`;
}

export async function POST(req: NextRequest) {
  const body = await req.json();
  const { customer, items, subtotalSek, shippingSek, totalSek } = body as {
    customer: {
      name: string;
      email: string;
      phone: string;
      address: string;
      postalCode: string;
      city: string;
    };
    items: CheckoutItem[];
    subtotalSek: number;
    shippingSek: number;
    totalSek: number;
  };

  if (!items || items.length === 0) {
    return NextResponse.json({ error: "Varukorgen är tom." }, { status: 400 });
  }
  if (!customer?.name || !customer?.email || !customer?.address) {
    return NextResponse.json(
      { error: "Fyll i alla obligatoriska fält." },
      { status: 400 }
    );
  }

  // Re-check stock server-side before committing the order — the storefront
  // greys out sold-out cards, but two people could be checking out at once.
  for (const item of items) {
    const { data: variant, error } = await supabaseAdmin
      .from("card_variants")
      .select("stock")
      .eq("id", item.variantId)
      .single();

    if (error || !variant || variant.stock < item.quantity) {
      return NextResponse.json(
        {
          error: `"${item.cardName}" (${item.variant}) finns inte längre i tillräckligt antal. Ladda om sidan och försök igen.`,
        },
        { status: 409 }
      );
    }
  }

  const orderNumber = generateOrderNumber();

  // Link the order to a member account if the buyer happens to be logged
  // in — purely for their own order history on /konto, guest checkout
  // (no account) still works exactly as before.
  const sessionToken = req.cookies.get(MEMBER_SESSION_COOKIE)?.value;
  const memberId = sessionToken ? await verifyMemberSession(sessionToken) : null;

  const { data: order, error: orderError } = await supabaseAdmin
    .from("orders")
    .insert({
      order_number: orderNumber,
      member_id: memberId,
      customer_name: customer.name,
      email: customer.email,
      phone: customer.phone,
      address: customer.address,
      postal_code: customer.postalCode,
      city: customer.city,
      subtotal_sek: subtotalSek,
      shipping_sek: shippingSek,
      total_sek: totalSek,
      status: "pending_payment",
    })
    .select()
    .single();

  if (orderError || !order) {
    return NextResponse.json(
      { error: "Kunde inte skapa ordern. Försök igen." },
      { status: 500 }
    );
  }

  const orderItemsPayload = items.map((item) => ({
    order_id: order.id,
    card_variant_id: item.variantId,
    card_name: item.cardName,
    card_number: item.cardNumber,
    variant: item.variant,
    quantity: item.quantity,
    unit_price_sek: item.unitPriceSek,
  }));

  const { error: itemsError } = await supabaseAdmin
    .from("order_items")
    .insert(orderItemsPayload);

  if (itemsError) {
    return NextResponse.json(
      { error: "Kunde inte spara kortraderna. Försök igen." },
      { status: 500 }
    );
  }

  // Decrement stock for each purchased variant.
  for (const item of items) {
    const { data: current } = await supabaseAdmin
      .from("card_variants")
      .select("stock")
      .eq("id", item.variantId)
      .single();
    const newStock = Math.max(0, (current?.stock ?? 0) - item.quantity);
    await supabaseAdmin
      .from("card_variants")
      .update({ stock: newStock })
      .eq("id", item.variantId);
  }

  return NextResponse.json({ orderNumber });
}
