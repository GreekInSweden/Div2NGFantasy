"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";

interface CategoryOption {
  slug: string;
  name: string;
}

function slugify(text: string): string {
  return text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "") // strip accents (å/ä/ö etc.)
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
}

export default function NewSetForm({
  existingCategories,
}: {
  existingCategories: CategoryOption[];
}) {
  const router = useRouter();
  const [categoryChoice, setCategoryChoice] = useState<string>(
    existingCategories[0]?.slug ?? "__new__"
  );
  const [newCategoryName, setNewCategoryName] = useState("");
  const [setName, setSetName] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  const isNewCategory = categoryChoice === "__new__";

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);

    const categoryName = isNewCategory
      ? newCategoryName.trim()
      : existingCategories.find((c) => c.slug === categoryChoice)?.name ?? "";
    const categorySlug = isNewCategory ? slugify(newCategoryName) : categoryChoice;

    if (!categoryName || !setName.trim()) {
      setError("Fyll i alla fält.");
      return;
    }

    setSubmitting(true);
    const supabase = createBrowserSupabase();
    const { error: insertError } = await supabase.from("sets").insert({
      category_slug: categorySlug,
      category_name: categoryName,
      slug: slugify(setName),
      name: setName.trim(),
      is_visible: false,
    });
    setSubmitting(false);

    if (insertError) {
      setError(
        insertError.message.includes("duplicate")
          ? "Ett set med det namnet finns redan."
          : `Kunde inte skapa setet: ${insertError.message}`
      );
      return;
    }
    setSuccess(true);
    setTimeout(() => router.push("/admin"), 900);
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <label className="block">
        <span className="text-sm text-mute mb-1 block">Kategori</span>
        <select
          value={categoryChoice}
          onChange={(e) => setCategoryChoice(e.target.value)}
          className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
        >
          {existingCategories.map((c) => (
            <option key={c.slug} value={c.slug}>
              {c.name}
            </option>
          ))}
          <option value="__new__">+ Ny kategori…</option>
        </select>
      </label>

      {isNewCategory && (
        <label className="block">
          <span className="text-sm text-mute mb-1 block">Nytt kategorinamn</span>
          <input
            value={newCategoryName}
            onChange={(e) => setNewCategoryName(e.target.value)}
            placeholder="t.ex. Bonuskort & Promos"
            required
            className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
          />
        </label>
      )}

      <label className="block">
        <span className="text-sm text-mute mb-1 block">Setnamn</span>
        <input
          value={setName}
          onChange={(e) => setSetName(e.target.value)}
          placeholder="t.ex. Black Star Promos"
          required
          className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper"
        />
        {setName && (
          <span className="text-xs text-mute mt-1 block">
            Webbadress blir: /{isNewCategory ? slugify(newCategoryName) || "…" : categoryChoice}/{slugify(setName)}
          </span>
        )}
      </label>

      {error && <p className="text-sm text-red-400">{error}</p>}
      {success && (
        <p className="text-sm text-gold">
          Set skapat ✓ (dolt tills vidare — visa det från startsidan i admin
          när ni har kort att sälja)
        </p>
      )}

      <button
        type="submit"
        disabled={submitting}
        className="focus-ring w-full rounded-sm bg-gold text-ink font-semibold py-3 disabled:opacity-50"
      >
        {submitting ? "Skapar…" : "Skapa set"}
      </button>
    </form>
  );
}
