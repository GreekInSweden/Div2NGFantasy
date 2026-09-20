"use client";

import { Suspense, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import Link from "next/link";

export default function RegisterPage() {
  return (
    <Suspense fallback={<div className="max-w-md mx-auto px-4 py-20 text-mute">Laddar…</div>}>
      <RegisterForm />
    </Suspense>
  );
}

function RegisterForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const next = searchParams.get("next") || "/konto";

  const [form, setForm] = useState({
    name: "",
    email: "",
    phone: "",
    address: "",
    postalCode: "",
    city: "",
    password: "",
  });
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  function updateField(field: keyof typeof form, value: string) {
    setForm((f) => ({ ...f, [field]: value }));
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    const res = await fetch("/api/member/register", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(form),
    });
    const data = await res.json();
    setSubmitting(false);
    if (!res.ok) {
      setError(data.error ?? "Något gick fel.");
      return;
    }
    router.push(next);
    router.refresh();
  }

  return (
    <div className="max-w-md mx-auto px-4 py-20">
      <h1 className="font-display text-3xl font-bold text-paper mb-2">
        Skapa konto
      </h1>
      <p className="text-mute mb-8">
        Du får ett medlemsnummer som visas när du budar på auktioner, och
        slipper fylla i dina uppgifter på nytt varje gång.
      </p>
      <form onSubmit={handleSubmit} className="space-y-4">
        <Field label="Namn" value={form.name} onChange={(v) => updateField("name", v)} required />
        <Field
          label="E-post"
          type="email"
          value={form.email}
          onChange={(v) => updateField("email", v)}
          required
        />
        <Field label="Telefon" value={form.phone} onChange={(v) => updateField("phone", v)} />
        <Field label="Adress" value={form.address} onChange={(v) => updateField("address", v)} />
        <div className="grid grid-cols-2 gap-4">
          <Field
            label="Postnummer"
            value={form.postalCode}
            onChange={(v) => updateField("postalCode", v)}
          />
          <Field label="Ort" value={form.city} onChange={(v) => updateField("city", v)} />
        </div>
        <Field
          label="Lösenord (minst 8 tecken)"
          type="password"
          value={form.password}
          onChange={(v) => updateField("password", v)}
          required
        />
        {error && <p className="text-sm text-red-400">{error}</p>}
        <button
          type="submit"
          disabled={submitting}
          className="focus-ring w-full rounded-sm bg-gold text-ink font-semibold py-3 disabled:opacity-50"
        >
          {submitting ? "Skapar konto…" : "Skapa konto"}
        </button>
      </form>
      <p className="text-sm text-mute mt-6">
        Har du redan ett konto?{" "}
        <Link href="/konto/logga-in" className="text-gold hover:underline">
          Logga in
        </Link>
      </p>
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
        className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
      />
    </label>
  );
}
