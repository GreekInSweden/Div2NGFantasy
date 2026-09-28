"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import ToggleSetVisibilityButton from "@/components/admin/ToggleSetVisibilityButton";

type ProductLine = "pokemon" | "sportkort";

interface SetRow {
  id: string;
  slug: string;
  name: string;
  category_name: string;
  is_visible: boolean;
  product_line?: ProductLine;
}

function ChevronIcon({ open }: { open: boolean }) {
  return (
    <svg
      viewBox="0 0 20 20"
      fill="none"
      className={`w-4 h-4 shrink-0 text-mute transition-transform duration-150 ${
        open ? "rotate-90" : ""
      }`}
    >
      <path
        d="M7.5 5L12.5 10L7.5 15"
        stroke="currentColor"
        strokeWidth="1.75"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

function FolderIcon({ accentClass }: { accentClass: string }) {
  return (
    <svg viewBox="0 0 20 20" fill="none" className={`w-4 h-4 shrink-0 ${accentClass}`}>
      <path
        d="M2.5 5.5C2.5 4.67 3.17 4 4 4h3.4c.35 0 .68.14.93.38l1.1 1.12H16c.83 0 1.5.67 1.5 1.5v7.5c0 .83-.67 1.5-1.5 1.5H4c-.83 0-1.5-.67-1.5-1.5v-9Z"
        fill="currentColor"
        fillOpacity="0.15"
        stroke="currentColor"
        strokeWidth="1.2"
      />
    </svg>
  );
}

// Samma uppdelning som butikens Vårt lager och portfölj/master set: en
// flat lista med 170+ set (och växande) är för mycket att scrolla igenom
// — Pokémon och Sportkort delas upp i varsin grupp, och kategorierna
// under respektive är ihopfällda som standard istället för att alla
// ligga uppfällda samtidigt.
const LINE_META: Record<ProductLine, { label: string; textAccent: string; folderAccent: string }> = {
  pokemon: { label: "Pokémon", textAccent: "text-gold", folderAccent: "text-gold/70" },
  sportkort: { label: "Sportkort", textAccent: "text-sport-pitch", folderAccent: "text-sport-pitch/70" },
};

export default function AdminSetGroups({ sets }: { sets: SetRow[] }) {
  const [query, setQuery] = useState("");
  const [openCategories, setOpenCategories] = useState<Set<string>>(new Set());

  const q = query.trim().toLowerCase();
  const isSearching = q.length > 0;

  const filtered = useMemo(() => {
    if (!isSearching) return sets;
    return sets.filter(
      (s) =>
        s.name.toLowerCase().includes(q) || s.category_name.toLowerCase().includes(q)
    );
  }, [sets, q, isSearching]);

  const lineGroups = useMemo(() => {
    const lines: ProductLine[] = ["pokemon", "sportkort"];
    return lines
      .map((line) => {
        const setsForLine = filtered.filter((s) => (s.product_line ?? "pokemon") === line);
        const names = Array.from(new Set(setsForLine.map((s) => s.category_name))).sort((a, b) =>
          a.localeCompare(b)
        );
        return {
          line,
          categories: names.map((name) => ({
            name,
            sets: setsForLine.filter((s) => s.category_name === name),
          })),
        };
      })
      .filter((g) => g.categories.length > 0);
  }, [filtered]);

  const showLineHeadings = lineGroups.length > 1;

  const allCategoryNames = useMemo(
    () => lineGroups.flatMap((g) => g.categories.map((c) => c.name)),
    [lineGroups]
  );

  // Sökning fäller automatiskt upp de kategorier som matchar, så man
  // slipper klicka i mappen manuellt bara för att hitta ett set.
  useEffect(() => {
    if (isSearching) {
      setOpenCategories(new Set(allCategoryNames));
    }
  }, [isSearching, allCategoryNames]);

  function toggleCategory(name: string) {
    setOpenCategories((prev) => {
      const next = new Set(prev);
      if (next.has(name)) next.delete(name);
      else next.add(name);
      return next;
    });
  }

  return (
    <div>
      <input
        type="text"
        placeholder="Sök set eller kategori…"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper text-sm mb-6"
      />

      {lineGroups.length === 0 ? (
        <p className="text-mute">Inga set matchar sökningen.</p>
      ) : (
        <div className="space-y-6">
          {lineGroups.map(({ line, categories }) => {
            const meta = LINE_META[line];
            return (
              <div key={line}>
                {showLineHeadings && (
                  <h2 className={`text-xs font-semibold uppercase tracking-wide mb-2 ${meta.textAccent}`}>
                    {meta.label}
                  </h2>
                )}
                <div className="space-y-2">
                  {categories.map((cat) => {
                    const open = openCategories.has(cat.name);
                    return (
                      <div key={cat.name} className="border border-line rounded-md bg-panel">
                        <button
                          onClick={() => toggleCategory(cat.name)}
                          className="focus-ring w-full flex items-center gap-2 px-4 py-3 text-left hover:bg-panelLight/60"
                        >
                          <ChevronIcon open={open} />
                          <FolderIcon accentClass={meta.folderAccent} />
                          <span className="font-display text-sm font-medium text-paper flex-1">
                            {cat.name}
                          </span>
                          <span className="text-xs text-mute font-mono">
                            {cat.sets.length}
                          </span>
                        </button>

                        {open && (
                          <div className="space-y-2 px-4 pb-4 pt-1">
                            {cat.sets.map((s) => (
                              <div
                                key={s.slug}
                                className="flex items-center gap-2 border border-line rounded-md p-3 bg-ink"
                              >
                                <Link
                                  href={`/admin/${s.slug}`}
                                  className="focus-ring flex-1 min-w-0 hover:opacity-80 transition-opacity"
                                >
                                  <div className="font-display font-medium text-paper text-sm">
                                    {s.name}
                                  </div>
                                </Link>
                                <ToggleSetVisibilityButton
                                  setId={s.id}
                                  isVisible={s.is_visible}
                                />
                              </div>
                            ))}
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
