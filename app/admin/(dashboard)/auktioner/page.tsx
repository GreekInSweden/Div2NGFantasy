import Link from "next/link";
import { createServerSupabase } from "@/lib/supabase/server";
import { variantLabel } from "@/lib/variant";
import CloseAuctionButton from "@/components/admin/CloseAuctionButton";
import AuctionImageUploader from "@/components/admin/AuctionImageUploader";
import DeleteAuctionButton from "@/components/admin/DeleteAuctionButton";
import AuctionWinActions from "@/components/admin/AuctionWinActions";
import ArchivedAuctions from "@/components/admin/ArchivedAuctions";

export const dynamic = "force-dynamic";

const ARCHIVE_AFTER_DAYS = 30;

const winStatusLabel: Record<string, string> = {
  pending: "Väntar på att vinnaren loggar in och ser betalsidan",
  claimed: "Har sett betalsidan — väntar på Swish",
  paid: "Betald",
  expired: "Utgången — ingen hämtade ut vinsten",
};

export default async function AdminAuktionerPage() {
  const supabase = createServerSupabase();

  const { data: auctions } = await supabase
    .from("auctions")
    .select(
      "id, starting_price_sek, min_increment_sek, reserve_price_sek, ends_at, status, front_image_url, back_image_url, card_variants(variant, cards(number, name)), auction_wins(id, status, amount_sek, claim_deadline, members(member_number, name, email, phone))"
    )
    .order("created_at", { ascending: false });

  const withBids = await Promise.all(
    (auctions ?? []).map(async (a: any) => {
      const { data: bids } = await supabase
        .from("bids")
        .select("amount_sek, created_at, members(member_number, name)")
        .eq("auction_id", a.id)
        .order("amount_sek", { ascending: false });
      const win = Array.isArray(a.auction_wins) ? a.auction_wins[0] ?? null : a.auction_wins;
      return { ...a, bids: bids ?? [], win };
    })
  );

  const archiveCutoff = Date.now() - ARCHIVE_AFTER_DAYS * 24 * 60 * 60 * 1000;
  const recentAuctions = withBids.filter(
    (a) => new Date(a.ends_at).getTime() >= archiveCutoff
  );
  const archivedAuctions = withBids.filter(
    (a) => new Date(a.ends_at).getTime() < archiveCutoff
  );

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="font-display text-2xl font-bold text-paper mb-1">
            Auktioner
          </h1>
          <p className="text-mute text-sm">
            Bud visas bara med belopp — köparens uppgifter dyker upp här
            först när de faktiskt vunnit och fyllt i sin betalsida.
          </p>
        </div>
        <Link
          href="/admin/auktioner/ny"
          className="focus-ring rounded-sm bg-gold text-ink font-semibold px-4 py-2 text-sm shrink-0"
        >
          + Ny auktion
        </Link>
      </div>

      {withBids.length === 0 ? (
        <p className="text-mute">Inga auktioner ännu.</p>
      ) : (
        <div className="space-y-4">
          {recentAuctions.map((a: any) => {
            const card = a.card_variants?.cards;
            const topBid = a.bids[0];
            const ended = new Date(a.ends_at) < new Date();
            return (
              <div
                key={a.id}
                className="border border-line rounded-md p-4 bg-panel"
              >
                <div className="flex items-start justify-between mb-2">
                  <div>
                    <div className="font-mono text-xs text-mute">
                      #{String(card?.number ?? 0).padStart(3, "0")} ·{" "}
                      {a.card_variants?.variant
                        ? variantLabel[a.card_variants.variant as keyof typeof variantLabel]
                        : "Vanligt"}
                    </div>
                    <div className="font-display font-semibold text-paper">
                      {card?.name ?? "Okänt kort"}
                    </div>
                  </div>
                  <span
                    className={`text-xs font-mono px-2 py-1 rounded-sm ${
                      a.status === "open" && !ended
                        ? "bg-gold/10 text-gold"
                        : "bg-line text-mute"
                    }`}
                  >
                    {a.status === "open" && !ended ? "Pågår" : "Avslutad"}
                  </span>
                </div>

                {a.status === "open" && !a.front_image_url && (
                  <p className="text-xs text-amber-400/90 mb-2">
                    ⚠ Ingen bild av kortet uppladdad än — auktionen visas
                    utan bild för köpare tills du laddar upp en.
                  </p>
                )}

                <p className="text-xs text-mute mb-3">
                  Utrop: {a.starting_price_sek} kr
                  {a.reserve_price_sek !== null && (
                    <>
                      {" "}
                      · Reservationspris:{" "}
                      <span className="text-paper">{a.reserve_price_sek} kr</span>
                    </>
                  )}
                  {" "}· Slutar: {new Date(a.ends_at).toLocaleString("sv-SE")}
                </p>

                {a.reserve_price_sek !== null && a.bids.length > 0 && (
                  <p
                    className={`text-xs mb-2 ${
                      Number(a.bids[0].amount_sek) >= Number(a.reserve_price_sek)
                        ? "text-gold"
                        : "text-amber-400/90"
                    }`}
                  >
                    {Number(a.bids[0].amount_sek) >= Number(a.reserve_price_sek)
                      ? "✓ Reservationspris uppnått — okej att sälja"
                      : "⚠ Reservationspris ej uppnått ännu"}
                  </p>
                )}

                {a.bids.length === 0 ? (
                  <p className="text-sm text-mute">Inga bud ännu.</p>
                ) : (
                  <div className="space-y-1">
                    {a.bids.map((b: any, i: number) => (
                      <div
                        key={i}
                        className={`text-sm flex items-center justify-between px-2 py-1 rounded-sm ${
                          i === 0 ? "bg-gold/10" : ""
                        }`}
                      >
                        <span className={i === 0 ? "text-gold font-medium" : "text-paper"}>
                          {i === 0 && "🏆 "}
                          {b.members
                            ? `Medlem #${b.members.member_number} (${b.members.name})`
                            : "Okänd medlem"}
                        </span>
                        <span className="font-mono">{b.amount_sek} kr</span>
                      </div>
                    ))}
                  </div>
                )}

                {a.win && (
                  <div className="mt-3 border border-line rounded-md p-3 bg-ink/40">
                    <p className="text-sm text-paper font-medium mb-1">
                      {winStatusLabel[a.win.status] ?? a.win.status}
                    </p>
                    {a.win.members && (
                      <p className="text-sm text-mute">
                        Medlem #{a.win.members.member_number} — {a.win.members.name} —{" "}
                        {a.win.members.email} · {a.win.members.phone ?? "inget telefonnr"}
                      </p>
                    )}
                    {a.win.status === "claimed" && (
                      <div className="mt-2">
                        <AuctionWinActions winId={a.win.id} />
                      </div>
                    )}
                  </div>
                )}

                {a.status === "open" && (
                  <div className="mt-3 flex items-center justify-between gap-3 flex-wrap">
                    <div className="flex items-center gap-4">
                      <AuctionImageUploader
                        auctionId={a.id}
                        field="front_image_url"
                        label="Framsida"
                        initialUrl={a.front_image_url ?? null}
                      />
                      <AuctionImageUploader
                        auctionId={a.id}
                        field="back_image_url"
                        label="Baksida"
                        initialUrl={a.back_image_url ?? null}
                      />
                    </div>
                    <CloseAuctionButton auctionId={a.id} />
                  </div>
                )}

                {a.status === "closed" && (
                  <div className="mt-3">
                    <DeleteAuctionButton auctionId={a.id} />
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}

      <ArchivedAuctions auctions={archivedAuctions} />
    </div>
  );
}
