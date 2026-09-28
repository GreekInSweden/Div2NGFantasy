"use client";

import { useMemo, useState } from "react";
import { createBrowserSupabase } from "@/lib/supabase/browser";
import { rarityLabel } from "@/lib/rarity";
import { variantShortLabel } from "@/lib/variant";
import CardZoomImage from "@/components/CardZoomImage";
import type { DuplicateRow } from "@/app/admin/(dashboard)/dubbletter/page";

export default function DuplicateList({ rows: initialRows }: { rows: DuplicateRow[] }) {
  const [rows, setRows] = useState(initialRows);
  const [pending, setPending] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [query, setQuery] = useState("");

  const grouped = useMemo(() => {
    const q = query.trim().toLowerCase();
    const filtered = q
      ? rows.filter(
          (r) =>
            r.name.toLowerCase().includes(q) ||
            r.setName.toLowerCase().includes(q) ||
            String(r.number).padStart(3, "0").includes(q)
        )
      : rows;
    const map = new Map<string, DuplicateRow[]>();
    for (const r of filtered) {
      const list = map.get(r.setName) ?? [];
      list.push(r);
      map.set(r.setName, list);
    }
    return Array.from(map.entries());
  }, [rows, query]);

  async function markDone(id: string) {
    setPending(id);
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: delErr } = await supabase.from("member_cards").delete().eq("id", id);
    setPending(null);
    if (delErr) {
      setError(delErr.message);
      return;
    }
    setRows((r) => r.filter((row) => row.id !== id));
  }

  return (
    <div>
      <input
        type="text"
        placeholder="Sök kort, set eller nummer…"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        className="focus-ring w-full bg-panel border border-line rounded-sm px-3 py-2 text-paper text-sm mb-6"
      />

      {error && <p className="text-sm text-red-400 mb-4">{error}</p>}

      <div className="space-y-8">
        {grouped.map(([setName, list]) => (
          <div key={setName}>
            <h2 className="font-display text-sm font-semibold text-mute uppercase tracking-wide mb-3">
              {setName} ({list.length})
            </h2>
            <div className="space-y-2">
              {list.map((r) => (
                <div
                  key={r.id}
                  className="border border-line rounded-md p-3 bg-panel flex items-center gap-4"
                >
                  <CardZoomImage
                    src={r.imageUrl}
                    alt={r.name}
                    number={r.number}
                    rarity={r.rarity}
                    className="w-12 h-16 rounded-sm shrink-0"
                  />
                  <div className="w-16 shrink-0 font-mono text-xs text-mute">
                    #{String(r.number).padStart(3, "0")}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="font-display text-sm font-medium text-paper truncate">
                      {r.name}
                    </div>
                    <div className="text-xs text-mute">
                      {rarityLabel[r.rarity]} · {variantShortLabel[r.variant]}
                    </div>
                  </div>
                  <div className="flex items-center gap-1 shrink-0">
                    {r.sellable && (
                      <span className="text-[10px] bg-gold/20 text-gold border border-gold/40 rounded-full px-2 py-0.5">
                        Säljer
                      </span>
                    )}
                    {r.tradeable && (
                      <span className="text-[10px] bg-sport-pitch/10 text-sport-pitch border border-sport-pitch/40 rounded-full px-2 py-0.5">
                        Byter
                      </span>
                    )}
                  </div>
                  <button
                    type="button"
                    onClick={() => markDone(r.id)}
                    disabled={pending === r.id}
                    className="focus-ring text-xs rounded-sm border border-line hover:border-gold hover:text-gold px-3 py-1.5 disabled:opacity-50 shrink-0"
                  >
                    {pending === r.id ? "…" : "Markera som klar"}
                  </button>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
