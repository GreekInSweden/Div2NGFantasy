import Link from "next/link";
import { createServerSupabase } from "@/lib/supabase/server";
import { rarityLabel } from "@/lib/rarity";
import { variantLabel } from "@/lib/variant";

export const dynamic = "force-dynamic";

// Shown after filtering down to cards someone actually has/wants — a
// popular name like "Charizard" or "Pikachu" matches 100+ printings
// across the whole catalog, but almost none of them will have any
// member activity, so this caps the useful, already-relevant list
// rather than the raw name search (see below for why that matters).
const MAX_RESULTS = 40;

interface EntryRow {
  status: "have" | "want";
  variant: string;
  sellable: boolean;
  tradeable: boolean;
  member_id: string;
  members: { member_number: number; username: string | null; name: string; email: string } | null;
}

interface CardGroup {
  cardId: string;
  cardName: string;
  cardNumber: number;
  rarity: string;
  setName: string;
  entries: EntryRow[];
}

export default async function AdminCardSearchPage({
  searchParams,
}: {
  searchParams: { q?: string };
}) {
  const q = (searchParams.q ?? "").trim();
  const supabase = createServerSupabase();

  let groups: CardGroup[] = [];
  let truncated = false;

  if (q) {
    // A popular name (Charizard, Pikachu…) matches 100+ printings across
    // the whole imported catalog, but almost none of those individual
    // prints will have any member activity — so capping the *name*
    // search itself would risk cutting off the one printing someone
    // actually has, just because it happened to sort after 30 other
    // irrelevant printings. Fetch every matching card (cheap — it's just
    // id/name/number), filter down to the ones with real member_cards
    // activity, and only cap that already-relevant result.
    const { data: matchingCards } = await supabase
      .from("cards")
      .select("id, number, name, rarity, sets(name)")
      .ilike("name", `%${q}%`)
      .limit(500);

    const cards = matchingCards ?? [];

    if (cards.length > 0) {
      const { data: entryRows } = await supabase
        .from("member_cards")
        .select(
          "card_id, status, variant, sellable, tradeable, member_id, members(member_number, username, name, email)"
        )
        .in(
          "card_id",
          cards.map((c: any) => c.id)
        );

      const withActivity = cards
        .map((c: any) => ({
          cardId: c.id,
          cardName: c.name,
          cardNumber: c.number,
          rarity: c.rarity,
          setName: c.sets?.name ?? "",
          entries: ((entryRows as any[]) ?? []).filter((e) => e.card_id === c.id),
        }))
        // Cards nobody has marked at all are just noise in a search
        // meant to answer "who has/wants this" — skip them.
        .filter((g) => g.entries.length > 0)
        // Most-active printing first — the one people actually asked
        // about, not whatever order the DB happened to return.
        .sort((a, b) => b.entries.length - a.entries.length);

      truncated = withActivity.length > MAX_RESULTS;
      groups = withActivity.slice(0, MAX_RESULTS);
    }
  }

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Kortsök
      </h1>
      <p className="text-mute text-sm mb-6">
        Sök på ett kortnamn för att se vilka medlemmar säljer, byter eller
        söker det — utan att behöva klicka in på varje medlem för sig.
      </p>

      <form method="GET" className="mb-8">
        <input
          type="text"
          name="q"
          defaultValue={q}
          placeholder="Sök kortnamn, t.ex. Charizard…"
          autoFocus
          className="focus-ring w-full max-w-md rounded-sm border border-line bg-panel px-3 py-2 text-sm text-paper placeholder:text-mute"
        />
      </form>

      {!q ? (
        <p className="text-mute text-sm">Skriv ett kortnamn ovan och tryck Enter.</p>
      ) : groups.length === 0 ? (
        <p className="text-mute text-sm">
          Ingen medlem har markerat något kort som matchar "{q}".
        </p>
      ) : (
        <div className="space-y-6">
          {truncated && (
            <p className="text-xs text-amber-400/90">
              Fler än {MAX_RESULTS} kort med aktivitet matchar — visar de{" "}
              {MAX_RESULTS} mest aktiva. Skriv en mer specifik del av
              namnet (t.ex. "Charizard VMAX" istället för bara
              "Charizard") för att smalna av.
            </p>
          )}
          {groups.map((g) => {
            const haves = g.entries.filter((e) => e.status === "have");
            const wants = g.entries.filter((e) => e.status === "want");
            return (
              <div key={g.cardId} className="border border-line rounded-md p-4 bg-panel">
                <div className="font-mono text-xs text-mute">
                  #{String(g.cardNumber).padStart(3, "0")} · {g.setName} ·{" "}
                  {rarityLabel[g.rarity as keyof typeof rarityLabel] ?? g.rarity}
                </div>
                <div className="font-display font-semibold text-paper mb-3">{g.cardName}</div>

                {haves.length > 0 && (
                  <div className="mb-2">
                    <div className="text-xs text-gold uppercase tracking-wide mb-1">
                      Har ({haves.length})
                    </div>
                    <div className="space-y-1">
                      {haves.map((e, i) => (
                        <MemberEntryRow key={i} entry={e} />
                      ))}
                    </div>
                  </div>
                )}

                {wants.length > 0 && (
                  <div>
                    <div className="text-xs text-mute uppercase tracking-wide mb-1">
                      Vill ha ({wants.length})
                    </div>
                    <div className="space-y-1">
                      {wants.map((e, i) => (
                        <MemberEntryRow key={i} entry={e} />
                      ))}
                    </div>
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

function MemberEntryRow({ entry }: { entry: EntryRow }) {
  const m = entry.members;
  return (
    <div className="flex items-center justify-between gap-3 text-sm">
      <Link
        href={`/admin/medlemmar/${entry.member_id}`}
        className="focus-ring text-paper hover:text-gold truncate"
      >
        #{m?.member_number ?? "?"} {m?.username ? `(${m.username})` : `— ${m?.name ?? ""}`}
      </Link>
      <span className="flex items-center gap-2 shrink-0">
        <span className="text-xs text-mute font-mono">
          {variantLabel[entry.variant as keyof typeof variantLabel] ?? entry.variant}
          {entry.status === "have" &&
            (entry.sellable || entry.tradeable) &&
            ` · ${[entry.sellable ? "Säljer" : null, entry.tradeable ? "Byter" : null]
              .filter(Boolean)
              .join(" / ")}`}
        </span>
        {m?.email && (
          <a
            href={`mailto:${m.email}`}
            className="focus-ring text-xs rounded-sm border border-line px-2 py-0.5 text-mute hover:border-gold hover:text-gold"
            title={`Mejla ${m.email}`}
          >
            Kontakta
          </a>
        )}
      </span>
    </div>
  );
}
