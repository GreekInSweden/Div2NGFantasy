import Link from "next/link";
import { createServerSupabase } from "@/lib/supabase/server";
import MemberAdminActions from "@/components/admin/MemberAdminActions";

export const dynamic = "force-dynamic";

export default async function AdminMedlemmarPage() {
  const supabase = createServerSupabase();

  const { data: members } = await supabase
    .from("members")
    .select(
      "id, member_number, username, name, email, phone, created_at, failed_login_attempts, locked_until, password_reset_requested_at"
    )
    .order("member_number", { ascending: true });

  // One query for everyone's portfolio counts, aggregated here rather
  // than per member — a member_cards row set for a hobby shop is small
  // enough that this is simpler and cheaper than N+1 grouped queries.
  const { data: cardRows } = await supabase
    .from("member_cards")
    .select("member_id, status, sellable, tradeable");

  const portfolioCounts = new Map<
    string,
    { have: number; want: number; sellable: number; tradeable: number }
  >();
  for (const r of (cardRows as any[]) ?? []) {
    const c = portfolioCounts.get(r.member_id) ?? {
      have: 0,
      want: 0,
      sellable: 0,
      tradeable: 0,
    };
    if (r.status === "have") c.have += 1;
    if (r.status === "want") c.want += 1;
    if (r.sellable) c.sellable += 1;
    if (r.tradeable) c.tradeable += 1;
    portfolioCounts.set(r.member_id, c);
  }

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Medlemmar
      </h1>
      <p className="text-mute text-sm mb-8">
        Alla registrerade medlemskonton. Ett konto låses automatiskt i 15
        minuter efter 5 felaktiga inloggningsförsök i rad.
      </p>

      {!members || members.length === 0 ? (
        <p className="text-mute">Inga medlemmar ännu.</p>
      ) : (
        <div className="space-y-3">
          {members.map((m: any) => {
            const isLocked = m.locked_until && new Date(m.locked_until) > new Date();
            const hasPendingRequest = !!m.password_reset_requested_at;
            const counts = portfolioCounts.get(m.id);
            return (
              <div key={m.id} className="border border-line rounded-md p-4 bg-panel">
                <div className="flex items-start justify-between gap-3 mb-1">
                  <div>
                    <div className="font-mono text-xs text-gold">
                      Medlem #{m.member_number}
                      {m.username && ` · ${m.username}`}
                    </div>
                    <div className="font-display font-semibold text-paper">
                      {m.name}
                    </div>
                    <div className="text-sm text-mute">
                      <a href={`mailto:${m.email}`} className="hover:text-gold hover:underline">
                        {m.email}
                      </a>{" "}
                      · {m.phone ?? "inget telefonnr"}
                    </div>
                  </div>
                  <div className="flex flex-col items-end gap-1 shrink-0">
                    {isLocked && (
                      <span className="text-xs font-mono px-2 py-1 rounded-sm bg-red-400/10 text-red-400">
                        Låst
                      </span>
                    )}
                    {hasPendingRequest && (
                      <span className="text-xs font-mono px-2 py-1 rounded-sm bg-amber-400/10 text-amber-400">
                        Begärt återställning
                      </span>
                    )}
                  </div>
                </div>

                <div className="flex items-center gap-3 flex-wrap mt-2 mb-1">
                  {counts && (counts.have > 0 || counts.want > 0) ? (
                    <span className="text-xs text-mute font-mono">
                      {counts.have} har
                      {(counts.sellable > 0 || counts.tradeable > 0) &&
                        ` (${[
                          counts.sellable > 0 ? `${counts.sellable} säljer` : null,
                          counts.tradeable > 0 ? `${counts.tradeable} byter` : null,
                        ]
                          .filter(Boolean)
                          .join(", ")})`}
                      {" · "}
                      {counts.want} vill ha
                    </span>
                  ) : (
                    <span className="text-xs text-mute">Tom portfölj</span>
                  )}
                  <Link
                    href={`/admin/medlemmar/${m.id}`}
                    className="focus-ring text-xs rounded-sm border border-line px-3 py-1.5 text-paper hover:border-gold"
                  >
                    Visa portfölj
                  </Link>
                </div>

                <MemberAdminActions memberId={m.id} isLocked={!!isLocked} />
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
