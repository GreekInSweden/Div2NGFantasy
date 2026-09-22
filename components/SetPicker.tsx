"use client";

import { useEffect, useMemo, useState } from "react";

interface SetOption {
  id: string;
  slug: string;
  name: string;
  category_name: string;
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

function FolderIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="none" className="w-4 h-4 shrink-0 text-gold/70">
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

export default function SetPicker({
  sets,
  selectedSlug,
  baseHref,
}: {
  sets: SetOption[];
  selectedSlug: string | undefined;
  baseHref: string;
}) {
  const [query, setQuery] = useState("");

  const categoryOfSelected = sets.find((s) => s.slug === selectedSlug)?.category_name;
  const [openCategories, setOpenCategories] = useState<Set<string>>(
    () => new Set(categoryOfSelected ? [categoryOfSelected] : [])
  );

  const q = query.trim().toLowerCase();
  const isSearching = q.length > 0;

  const filtered = useMemo(() => {
    if (!isSearching) return sets;
    return sets.filter(
      (s) => s.name.toLowerCase().includes(q) || s.category_name.toLowerCase().includes(q)
    );
  }, [sets, q, isSearching]);

  const categories = useMemo(() => {
    const names = Array.from(new Set(filtered.map((s) => s.category_name)));
    return names.map((name) => ({
      name,
      sets: filtered.filter((s) => s.category_name === name),
    }));
  }, [filtered]);

  // Auto-expand every category that currently has a search match, so
  // typing doesn't require also clicking to open the right folder.
  useEffect(() => {
    if (isSearching) {
      setOpenCategories(new Set(categories.map((c) => c.name)));
    }
  }, [isSearching, categories]);

  function toggleCategory(name: string) {
    setOpenCategories((prev) => {
      const next = new Set(prev);
      if (next.has(name)) next.delete(name);
      else next.add(name);
      return next;
    });
  }

  return (
    <div className="mb-8">
      <input
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Sök set eller era…"
        className="focus-ring w-full max-w-md mb-4 rounded-sm border border-line bg-panel px-3 py-2 text-sm text-paper placeholder:text-mute"
      />

      {categories.length === 0 ? (
        <p className="text-mute text-sm">Inga set matchar sökningen.</p>
      ) : (
        <div className="border border-line rounded-md divide-y divide-line max-h-96 overflow-y-auto">
          {categories.map((cat) => {
            const open = openCategories.has(cat.name);
            const hasSelected = cat.sets.some((s) => s.slug === selectedSlug);
            return (
              <div key={cat.name}>
                <button
                  onClick={() => toggleCategory(cat.name)}
                  className={`focus-ring w-full flex items-center gap-2 px-3 py-2.5 text-left hover:bg-panelLight/60 ${
                    hasSelected ? "bg-gold/5" : ""
                  }`}
                >
                  <ChevronIcon open={open} />
                  <FolderIcon />
                  <span
                    className={`text-sm font-medium flex-1 ${
                      hasSelected ? "text-gold" : "text-paper"
                    }`}
                  >
                    {cat.name}
                  </span>
                  <span className="text-xs text-mute font-mono">{cat.sets.length}</span>
                </button>
                {open && (
                  <div className="flex flex-wrap gap-2 px-3 pb-3 pt-1 pl-9">
                    {cat.sets.map((s) => (
                      <a
                        key={s.id}
                        href={`${baseHref}?set=${s.slug}`}
                        className={`focus-ring text-xs rounded-sm border px-3 py-1.5 ${
                          s.slug === selectedSlug
                            ? "border-gold text-gold bg-gold/10"
                            : "border-line text-mute hover:border-mute hover:text-paper"
                        }`}
                      >
                        {s.name}
                      </a>
                    ))}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
