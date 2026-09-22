"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { MemberProfile } from "@/lib/currentMember";

export default function MemberProfileForm({ member }: { member: MemberProfile }) {
  const router = useRouter();
  const [form, setForm] = useState({
    name: member.name,
    phone: member.phone ?? "",
    address: member.address ?? "",
    postalCode: member.postalCode ?? "",
    city: member.city ?? "",
    contactMessenger: member.contactMessenger ?? "",
    contactWhatsapp: member.contactWhatsapp ?? "",
    contactOther: member.contactOther ?? "",
  });
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [saved, setSaved] = useState(false);
  const [loggingOut, setLoggingOut] = useState(false);

  function updateField(field: keyof typeof form, value: string) {
    setForm((f) => ({ ...f, [field]: value }));
    setSaved(false);
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      const res = await fetch("/api/member/profile", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form),
      });
      const data = await res.json().catch(() => ({}));
      setSubmitting(false);
      if (!res.ok) {
        setError(data.error ?? `Något gick fel (${res.status}).`);
        return;
      }
      setSaved(true);
    } catch {
      setSubmitting(false);
      setError("Kunde inte nå servern. Kontrollera internetuppkopplingen och försök igen.");
    }
  }

  async function handleLogout() {
    setLoggingOut(true);
    await fetch("/api/member/logout", { method: "POST" });
    router.push("/");
    router.refresh();
  }

  return (
    <div className="border border-line rounded-md p-6 bg-panel mb-10">
      <h2 className="font-display text-lg font-semibold text-paper mb-4">
        Kontaktuppgifter & leveransadress
      </h2>
      <form onSubmit={handleSubmit} className="space-y-4">
        <Field label="Namn" value={form.name} onChange={(v) => updateField("name", v)} required />
        <div>
          <span className="text-sm text-mute mb-1 block">E-post</span>
          <p className="text-paper">{member.email}</p>
        </div>
        {member.username && (
          <div>
            <span className="text-sm text-mute mb-1 block">Användarnamn</span>
            <p className="text-paper">{member.username}</p>
            <p className="text-xs text-mute mt-0.5">
              Valdes vid registreringen och går inte att ändra själv än —
              hör av dig till oss om du vill byta.
            </p>
          </div>
        )}
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

        <div className="border-t border-line pt-4 mt-2">
          <h3 className="text-sm font-medium text-paper mb-1">
            Kontaktvägar för byten/köp mellan medlemmar
          </h3>
          <p className="text-xs text-mute mb-3">
            Helt frivilligt, och dolt som standard. Fylls ett fält i visas
            det bara för den andra medlemmen när ni faktiskt matchar på ett
            kort — aldrig publikt på din profil.
          </p>
          <Field
            label="Messenger"
            value={form.contactMessenger}
            onChange={(v) => updateField("contactMessenger", v)}
          />
          <div className="h-3" />
          <Field
            label="WhatsApp"
            value={form.contactWhatsapp}
            onChange={(v) => updateField("contactWhatsapp", v)}
          />
          <div className="h-3" />
          <Field
            label="Annat (t.ex. Snapchat, Discord, telefon)"
            value={form.contactOther}
            onChange={(v) => updateField("contactOther", v)}
          />
        </div>

        {error && <p className="text-sm text-red-400">{error}</p>}
        {saved && <p className="text-sm text-gold">Sparat ✓</p>}
        <button
          type="submit"
          disabled={submitting}
          className="focus-ring rounded-sm bg-gold text-ink font-semibold px-4 py-2 text-sm disabled:opacity-50"
        >
          {submitting ? "Sparar…" : "Spara"}
        </button>
      </form>
      <button
        onClick={handleLogout}
        disabled={loggingOut}
        className="focus-ring text-sm text-mute hover:text-paper mt-6 disabled:opacity-50"
      >
        {loggingOut ? "Loggar ut…" : "Logga ut"}
      </button>
    </div>
  );
}

function Field({
  label,
  value,
  onChange,
  required,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
  required?: boolean;
}) {
  return (
    <label className="block">
      <span className="text-sm text-mute mb-1 block">{label}</span>
      <input
        required={required}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="focus-ring w-full bg-ink border border-line rounded-sm px-3 py-2 text-paper"
      />
    </label>
  );
}
