"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import ToggleSetVisibilityButton from "@/components/admin/ToggleSetVisibilityButton";

interface SetRow {
  id: string;
  slug: string;
  name: string;
  category_name: string;
  is_visible: boolean;
}

export default function AdminSetGroups({ sets }: { sets: SetRow[] }) {
  const [query, setQuery] = useState("");
  const [collapsed, setCollapsed] = useState<Record<string, boolean>>({});

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return sets;
    return sets.filter(
      (s) =>
        s.name.toLowerCase().includes(q) ||
        s.category_name.toLowerCase().includes(q)
    );
  }, [sets, query]);

  const groups = useMemo(() => {
    const map = new Map<string, SetRow[]>();
    for (const s of filtered) {
      const list = map.get(s.category_name) ?? [];
      list.push(s);
      map.set(s.category_name, list);
    }
    return Array.from(map.entries()).sort((a, b) => a[0].localeCompare(b[0]));
  }, [filtered]);

  function toggleGroup(category: string) {
    setCollapsed((c) => ({ ...c, [category]: !c[category] }));
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

      {groups.length === 0 ? (
        <p className="text-mute">Inga set matchar sökningen.</p>
      ) : (
        <div className="space-y-6">
          {groups.map(([category, categorySets]) => {
            const isCollapsed = collapsed[category] ?? false;
            return (
              <div key={category}>
                <button
                  onClick={() => toggleGroup(category)}
                  className="focus-ring flex items-center gap-2 mb-2 text-left w-full"
                >
                  <span className="text-mute text-xs">
                    {isCollapsed ? "▸" : "▾"}
                  </span>
                  <h2 className="font-display text-lg font-semibold text-paper">
                    {category}
                  </h2>
                  <span className="text-xs text-mute font-mono">
                    ({categorySets.length})
                  </span>
                </button>

                {!isCollapsed && (
                  <div className="space-y-2">
                    {categorySets.map((s) => (
                      <div
                        key={s.slug}
                        className="flex items-center gap-2 border border-line rounded-md p-4 bg-panel"
                      >
                        <Link
                          href={`/admin/${s.slug}`}
                          className="focus-ring flex-1 min-w-0 hover:opacity-80 transition-opacity"
                        >
                          <div className="font-display font-medium text-paper">
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
      )}
    </div>
  );
}
