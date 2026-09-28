"use client";

import { useEffect, useMemo, useState } from "react";

type ProductLine = "pokemon" | "sportkort";

interface SetOption {
  id: string;
  slug: string;
  name: string;
  category_name: string;
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

// Same split as /lager: Pokémon and Sportkort (Topps m.fl.) never mix in
// one flat list — each product line gets its own labeled group, in its
// own accent color, above the usual era/kategori-mappar.
const LINE_META: Record<
  ProductLine,
  { label: string; textAccent: string; folderAccent: string; activeBg: string }
> = {
  pokemon: {
    label: "Pokémon",
    textAccent: "text-gold",
    folderAccent: "text-gold/70",
    activeBg: "bg-gold/5",
  },
  sportkort: {
    label: "Sportkort",
    textAccent: "text-sport-pitch",
    folderAccent: "text-sport-pitch/70",
    activeBg: "bg-sport-pitch/5",
  },
};

export default function SetPicker({
  sets,
  selectedSlug,
  baseHref,
  completeSetIds,
}: {
  sets: SetOption[];
  selectedSlug: string | undefined;
  baseHref: string;
  // Optional — only the Master Set-sidan skickar in det här. När den
  // finns markeras varje helt klart set grönt, och en hel era/kategori
  // (mappen) guld när ALLA set i den är klara.
  completeSetIds?: string[];
}) {
  const [query, setQuery] = useState("");
  const completeSet = useMemo(() => new Set(completeSetIds ?? []), [completeSetIds]);

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

  const lineGroups = useMemo(() => {
    const lines: ProductLine[] = ["pokemon", "sportkort"];
    return lines
      .map((line) => {
        const setsForLine = filtered.filter(
          (s) => (s.product_line ?? "pokemon") === line
        );
        const names = Array.from(new Set(setsForLine.map((s) => s.category_name)));
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

  // Only one line present (e.g. every card is Pokémon) → skip the extra
  // heading, no point labeling a group when there's nothing to tell it
  // apart from.
  const showLineHeadings = lineGroups.length > 1;

  const allCategoryNames = useMemo(
    () => lineGroups.flatMap((g) => g.categories.map((c) => c.name)),
    [lineGroups]
  );

  // Auto-expand every category that currently has a search match, so
  // typing doesn't require also clicking to open the right folder.
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
    <div className="mb-8">
      <input
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Sök set eller era…"
        className="focus-ring w-full max-w-md mb-4 rounded-sm border border-line bg-panel px-3 py-2 text-sm text-paper placeholder:text-mute"
      />

      {lineGroups.length === 0 ? (
        <p className="text-mute text-sm">Inga set matchar sökningen.</p>
      ) : (
        <div className="space-y-5">
          {lineGroups.map(({ line, categories }) => {
            const meta = LINE_META[line];
            return (
              <div key={line}>
                {showLineHeadings && (
                  <h3 className={`text-xs font-semibold uppercase tracking-wide mb-2 ${meta.textAccent}`}>
                    {meta.label}
                  </h3>
                )}
                <div className="border border-line rounded-md divide-y divide-line max-h-96 overflow-y-auto">
                  {categories.map((cat) => {
                    const open = openCategories.has(cat.name);
                    const hasSelected = cat.sets.some((s) => s.slug === selectedSlug);
                    // Guld = HELA eran/kategorin klar, t.ex. Mega Evolution
                    // bara när både Pitch Black, Perfect Order osv. är
                    // klara var för sig. completeSetIds saknas helt på
                    // sidor som inte bryr sig (portföljen), så där blir
                    // categoryComplete alltid false.
                    const categoryComplete =
                      !!completeSetIds &&
                      cat.sets.length > 0 &&
                      cat.sets.every((s) => completeSet.has(s.id));
                    return (
                      <div key={cat.name}>
                        <button
                          onClick={() => toggleCategory(cat.name)}
                          className={`focus-ring w-full flex items-center gap-2 px-3 py-2.5 text-left hover:bg-panelLight/60 ${
                            categoryComplete
                              ? "bg-gold/10 ring-1 ring-inset ring-gold/40"
                              : hasSelected
                              ? meta.activeBg
                              : ""
                          }`}
                        >
                          <ChevronIcon open={open} />
                          <FolderIcon accentClass={categoryComplete ? "text-gold" : meta.folderAccent} />
                          <span
                            className={`text-sm font-medium flex-1 ${
                              categoryComplete ? "text-gold" : hasSelected ? meta.textAccent : "text-paper"
                            }`}
                          >
                            {cat.name}
                          </span>
                          {categoryComplete && (
                            <span className="text-xs text-gold shrink-0" title="Hela eran klar">
                              🏆
                            </span>
                          )}
                          <span className="text-xs text-mute font-mono">{cat.sets.length}</span>
                        </button>
                        {open && (
                          <div className="flex flex-wrap gap-2 px-3 pb-3 pt-1 pl-9">
                            {cat.sets.map((s) => {
                              const isComplete = completeSet.has(s.id);
                              const selected = s.slug === selectedSlug;
                              // "Klart" (grönt) och "det här är setet du tittar
                              // på just nu" (rosa ring) är två helt olika
                              // saker och får ALDRIG dela färg — annars ser
                              // ett bara-valt-men-inte-klart set (t.ex.
                              // Retro Threads på 0%) grönt ut precis som ett
                              // faktiskt klart set, vilket är exakt bugen
                              // som rapporterades.
                              const colorClasses = isComplete
                                ? "border-sport-pitch text-sport-pitch bg-sport-pitch/10"
                                : "border-line text-mute hover:border-mute hover:text-paper";
                              const selectedRing = selected
                                ? "ring-2 ring-inset ring-rose-400"
                                : "";
                              return (
                                <a
                                  key={s.id}
                                  href={`${baseHref}?set=${s.slug}`}
                                  className={`focus-ring text-xs rounded-sm border px-3 py-1.5 inline-flex items-center gap-1 ${colorClasses} ${selectedRing}`}
                                >
                                  {isComplete && <span aria-hidden>✓</span>}
                                  {s.name}
                                </a>
                              );
                            })}
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
