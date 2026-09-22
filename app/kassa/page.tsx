"use client";

import { useState, useMemo, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useCart } from "@/lib/CartContext";
import { calculateShippingSek } from "@/lib/shipping";
import { variantLabel } from "@/lib/variant";

export default function KassaPage() {
  const { items, updateQuantity, removeItem, subtotalSek, itemCount, clear } =
    useCart();
  const router = useRouter();

  const [form, setForm] = useState({
    name: "",
    email: "",
    phone: "",
    address: "",
    postalCode: "",
    city: "",
  });
  const [submitting, setSubmitting] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  // Pre-fill from the member's saved profile if they're logged in, so
  // they don't have to retype their details on every purchase — still
  // editable, and guest checkout (no account) works exactly as before.
  useEffect(() => {
    fetch("/api/member/me")
      .then((res) => res.json())
      .then((data) => {
        if (!data.member) return;
        setForm((f) => ({
          name: f.name || data.member.name || "",
          email: f.email || data.member.email || "",
          phone: f.phone || data.member.phone || "",
          address: f.address || data.member.address || "",
          postalCode: f.postalCode || data.member.postalCode || "",
          city: f.city || data.member.city || "",
        }));
      })
      .catch(() => {});
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const shippingSek = useMemo(() => calculateShippingSek(itemCount), [itemCount]);
  const totalSek = subtotalSek + shippingSek;

  function updateField(field: keyof typeof form, value: string) {
    setForm((f) => ({ ...f, [field]: value }));
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setErrorMsg(null);
    setSubmitting(true);
    try {
      const res = await fetch("/api/checkout", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          customer: form,
          items: items.map((i) => ({
            variantId: i.variantId,
            cardName: i.cardName,
            cardNumber: i.cardNumber,
            variant: i.variant,
            quantity: i.quantity,
            unitPriceSek: i.unitPriceSek,
          })),
          subtotalSek,
          shippingSek,
          totalSek,
        }),
      });
      const data = await res.json();
      if (!res.ok) {
        setErrorMsg(data.error ?? "Något gick fel. Försök igen.");
        setSubmitting(false);
        return;
      }
      clear();
      router.push(
        `/order-confirmed?order=${data.orderNumber}&total=${totalSek}`
      );
    } catch {
      setErrorMsg("Kunde inte skicka ordern. Kontrollera din internetuppkoppling.");
      setSubmitting(false);
    }
  }

  if (items.length === 0) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-20 text-center">
        <h1 className="font-display text-3xl font-bold text-paper mb-3">
          Varukorgen är tom
        </h1>
        <p className="text-mute mb-6">Hitta kort att lägga till först.</p>
        <Link
          href="/lager"
          className="focus-ring inline-block rounded-sm bg-gold text-ink font-semibold px-6 py-3"
        >
          Bläddra bland kort
        </Link>
      </div>
    );
  }

  return (
    <div className="max-w-3xl mx-auto px-4 py-14">
      <h1 className="font-display text-4xl font-bold text-paper mb-10">
        Kassa
      </h1>

      <div className="border border-line rounded-md divide-y divide-line mb-8">
        {items.map((item) => (
          <div
            key={item.variantId}
            className="flex items-center justify-between p-4 gap-4"
          >
            <div className="min-w-0">
              <div className="font-mono text-xs text-mute">
                #{String(item.cardNumber).padStart(3, "0")} · {item.setName}
              </div>
              <div className="font-display font-medium text-paper">
                {item.cardName}{" "}
                <span className="text-mute text-sm font-body">
                  ({variantLabel[item.variant]})
                </span>
              </div>
            </div>
            <div className="flex items-center gap-3 shrink-0">
              <input
                type="number"
                min={1}
                value={item.quantity}
                onChange={(e) =>
                  updateQuantity(item.variantId, Number(e.target.value))
                }
                className="focus-ring w-14 bg-ink border border-line rounded-sm px-2 py-1 text-center font-mono text-paper"
              />
              <span className="font-mono text-sm w-16 text-right text-paper">
                {item.unitPriceSek * item.quantity} kr
              </span>
              <button
                onClick={() => removeItem(item.variantId)}
                className="focus-ring text-mute hover:text-paper text-sm"
                aria-label={`Ta bort ${item.cardName}`}
              >
                ✕
              </button>
            </div>
          </div>
        ))}
      </div>

      <div className="border border-line rounded-md p-4 mb-10 space-y-2 font-mono text-sm">
        <div className="flex justify-between text-mute">
          <span>Delsumma ({itemCount} kort)</span>
          <span>{subtotalSek} kr</span>
        </div>
        <div className="flex justify-between text-mute">
          <span>Frakt</span>
          <span>{shippingSek} kr</span>
        </div>
        <div className="flex justify-between text-paper font-semibold text-base pt-2 border-t border-line">
          <span>Totalt</span>
          <span>{totalSek} kr</span>
        </div>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        <h2 className="font-display text-xl font-semibold text-paper mb-2">
          Leveransuppgifter
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <Field
            label="Namn"
            value={form.name}
            onChange={(v) => updateField("name", v)}
            required
          />
          <Field
            label="E-post"
            type="email"
            value={form.email}
            onChange={(v) => updateField("email", v)}
            required
          />
          <Field
            label="Telefon"
            value={form.phone}
            onChange={(v) => updateField("phone", v)}
            required
          />
          <Field
            label="Postnummer"
            value={form.postalCode}
            onChange={(v) => updateField("postalCode", v)}
            required
          />
          <Field
            label="Ort"
            value={form.city}
            onChange={(v) => updateField("city", v)}
            required
          />
          <Field
            label="Adress"
            value={form.address}
            onChange={(v) => updateField("address", v)}
            required
          />
        </div>

        {errorMsg && (
          <p className="text-sm text-red-400 font-mono">{errorMsg}</p>
        )}

        <button
          type="submit"
          disabled={submitting}
          className="focus-ring w-full rounded-sm bg-gold text-ink font-semibold py-3 hover:bg-gold/90 transition-colors disabled:opacity-50"
        >
          {submitting ? "Skickar order…" : `Beställ — betala ${totalSek} kr med Swish`}
        </button>
        <p className="text-xs text-mute text-center">
          Nästa steg visar vårt Swish-nummer och ett ordernummer att skriva
          som meddelande. Vi skickar när betalningen kommit in.
        </p>
        <p className="text-xs text-mute text-center border-t border-line pt-3 mt-3">
          Vi reserverar oss för eventuella prisfel och slutförsäljning. Om
          ett kort visar sig ha fått fel pris eller redan är sålt kontaktar
          vi dig och betalningen återbetalas i sin helhet — du är aldrig
          skyldig att fullfölja köpet till fel pris.
        </p>
      </form>
    </div>
  );
}

function Field({
  label,
  value,
  onChange,
  type = "text",
  required,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
  type?: string;
  required?: boolean;
}) {
  return (
    <label className="block">
      <span className="text-sm text-mute mb-1 block">{label}</span>
      <input
        type={type}
        required={required}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="focus-ring w-full bg-ink border border-line rounded-sm px-3 py-2 text-paper"
      />
    </label>
  );
}
