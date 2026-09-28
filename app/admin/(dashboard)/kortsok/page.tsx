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
  parallel_tier_id: string | null;
  parallel_tiers: { name: string } | null;
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

// Räknar UNIKA kort (card_id + variant + parallel), inte antal rader --
// tre medlemmar som alla har samma Charizard ska bara räknas en gång.
// PostgREST har en gräns på 1000 rader per svar, så sidan igenom med
// .range() tills en sida kommer tillbaka kortare än sidstorleken.
async function countUniqueCards(
  supabase: ReturnType<typeof createServerSupabase>,
  status: "have" | "want"
): Promise<number> {
  const pageSize = 1000;
  let from = 0;
  const keys = new Set<string>();
  for (;;) {
    const { data, error } = await supabase
      .from("member_cards")
      .select("card_id, variant, parallel_tier_id")
      .eq("status", status)
      .range(from, from + pageSize - 1);
    if (error || !data) break;
    for (const r of data as { card_id: string; variant: string; parallel_tier_id: string | null }[]) {
      keys.add(`${r.card_id}:${r.variant}:${r.parallel_tier_id ?? ""}`);
    }
    if (data.length < pageSize) break;
    from += pageSize;
  }
  return keys.size;
}

export default async function AdminCardSearchPage({
  searchParams,
}: {
  searchParams: { q?: string };
}) {
  const q = (searchParams.q ?? "").trim();
  const supabase = createServerSupabase();

  const [uniqueHaveCount, uniqueWantCount] = await Promise.all([
    countUniqueCards(supabase, "have"),
    countUniqueCards(supabase, "want"),
  ]);

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

    // Sökningen matchar även parallel-namn (t.ex. "1:4", "Gold Rainbow
    // Foil") -- inte bara kortnamn. Hitta matchande parallel_tiers
    // först, sen vilka kort som faktiskt har en member_cards-rad med
    // någon av de tiersen, och slå ihop med namnträffarna ovan.
    const { data: matchingTiers } = await supabase
      .from("parallel_tiers")
      .select("id")
      .ilike("name", `%${q}%`)
      .limit(200);
    const tierIds = (matchingTiers ?? []).map((t: any) => t.id);

    let cardsFromParallel: any[] = [];
    if (tierIds.length > 0) {
      const { data: parallelMemberRows } = await supabase
        .from("member_cards")
        .select("card_id")
        .in("parallel_tier_id", tierIds);
      const cardIdsFromParallel = Array.from(
        new Set((parallelMemberRows ?? []).map((r: any) => r.card_id))
      );
      if (cardIdsFromParallel.length > 0) {
        const { data: extraCards } = await supabase
          .from("cards")
          .select("id, number, name, rarity, sets(name)")
          .in("id", cardIdsFromParallel);
        cardsFromParallel = extraCards ?? [];
      }
    }

    const cardMap = new Map<string, any>();
    for (const c of matchingCards ?? []) cardMap.set(c.id, c);
    for (const c of cardsFromParallel) if (!cardMap.has(c.id)) cardMap.set(c.id, c);
    const cards = Array.from(cardMap.values());

    if (cards.length > 0) {
      const { data: entryRows } = await supabase
        .from("member_cards")
        .select(
          "card_id, status, variant, sellable, tradeable, member_id, parallel_tier_id, parallel_tiers(name), members(member_number, username, name, email)"
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
        Sök på ett kortnamn eller ett parallel-namn (t.ex. "1:4" eller
        "Gold") för att se vilka medlemmar säljer, byter eller söker det —
        utan att behöva klicka in på varje medlem för sig.
      </p>

      <div className="flex flex-wrap gap-3 mb-8">
        <div className="border border-line rounded-md p-4 bg-panel flex-1 min-w-[180px]">
          <div className="text-xs text-mute uppercase tracking-wide mb-1">
            Unika kort som finns
          </div>
          <div className="font-mono text-2xl text-gold">{uniqueHaveCount}</div>
          <div className="text-[11px] text-mute mt-0.5">
            Alla "har"-markeringar, oavsett om de är öppna för sälj/byte
          </div>
        </div>
        <div className="border border-line rounded-md p-4 bg-panel flex-1 min-w-[180px]">
          <div className="text-xs text-mute uppercase tracking-wide mb-1">
            Unika kort som efterfrågas
          </div>
          <div className="font-mono text-2xl text-paper">{uniqueWantCount}</div>
          <div className="text-[11px] text-mute mt-0.5">
            Antal olika kort någon har på sin önskelista
          </div>
        </div>
      </div>

      <form method="GET" className="mb-8">
        <input
          type="text"
          name="q"
          defaultValue={q}
          placeholder="Sök kortnamn eller parallel, t.ex. Charizard eller 1:4…"
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
          {entry.parallel_tiers?.name ?? variantLabel[entry.variant as keyof typeof variantLabel] ?? entry.variant}
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
