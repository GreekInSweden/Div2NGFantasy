import Link from "next/link";
import { notFound } from "next/navigation";
import { createServerSupabase } from "@/lib/supabase/server";
import { rarityLabel } from "@/lib/rarity";
import { variantLabel } from "@/lib/variant";

export const dynamic = "force-dynamic";

export default async function AdminMemberPortfolioPage({
  params,
}: {
  params: { id: string };
}) {
  const supabase = createServerSupabase();

  const { data: member } = await supabase
    .from("members")
    .select("id, member_number, username, name, email")
    .eq("id", params.id)
    .maybeSingle();

  if (!member) notFound();

  const { data: rows } = await supabase
    .from("member_cards")
    .select(
      "status, variant, sellable, tradeable, quantity, cards(number, name, rarity, sets(name, category_name))"
    )
    .eq("member_id", params.id);

  const entries = ((rows as any[]) ?? []).sort((a, b) => {
    const setA = a.cards?.sets?.name ?? "";
    const setB = b.cards?.sets?.name ?? "";
    if (setA !== setB) return setA.localeCompare(setB);
    return (a.cards?.number ?? 0) - (b.cards?.number ?? 0);
  });

  const haves = entries.filter((e) => e.status === "have");
  const wants = entries.filter((e) => e.status === "want");

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <Link href="/admin/medlemmar" className="focus-ring text-sm text-mute hover:text-paper">
        ← Alla medlemmar
      </Link>
      <h1 className="font-display text-2xl font-bold text-paper mt-2 mb-1">
        {member.name}
      </h1>
      <p className="text-mute text-sm mb-8">
        Medlem #{member.member_number}
        {member.username && ` · ${member.username}`} ·{" "}
        <a href={`mailto:${member.email}`} className="text-gold hover:underline">
          {member.email}
        </a>
      </p>

      {entries.length === 0 ? (
        <p className="text-mute">Portföljen är tom.</p>
      ) : (
        <div className="space-y-8">
          <section>
            <h2 className="font-display text-lg font-semibold text-paper mb-3">
              Har ({haves.length})
            </h2>
            {haves.length === 0 ? (
              <p className="text-mute text-sm">Inget markerat.</p>
            ) : (
              <div className="space-y-1.5">
                {haves.map((e, i) => (
                  <PortfolioRow key={i} entry={e} />
                ))}
              </div>
            )}
          </section>

          <section>
            <h2 className="font-display text-lg font-semibold text-paper mb-3">
              Vill ha ({wants.length})
            </h2>
            {wants.length === 0 ? (
              <p className="text-mute text-sm">Inget markerat.</p>
            ) : (
              <div className="space-y-1.5">
                {wants.map((e, i) => (
                  <PortfolioRow key={i} entry={e} />
                ))}
              </div>
            )}
          </section>
        </div>
      )}
    </div>
  );
}

function PortfolioRow({ entry }: { entry: any }) {
  const card = entry.cards;
  return (
    <div className="border border-line rounded-sm bg-panel px-3 py-2 flex items-center gap-3 text-sm">
      <span className="font-mono text-xs text-mute w-10 shrink-0">
        #{String(card?.number ?? 0).padStart(3, "0")}
      </span>
      <div className="min-w-0 flex-1">
        <span className="text-paper font-medium">{card?.name ?? "Okänt kort"}</span>{" "}
        <span className="text-mute text-xs">
          {card?.sets?.name ?? ""} · {rarityLabel[card?.rarity as keyof typeof rarityLabel] ?? card?.rarity}{" "}
          · {variantLabel[entry.variant as keyof typeof variantLabel] ?? entry.variant}
        </span>
      </div>
      {entry.status === "have" && (entry.sellable || entry.tradeable) && (
        <span className="text-xs shrink-0">
          {[entry.sellable ? "Säljer" : null, entry.tradeable ? "Byter" : null]
            .filter(Boolean)
            .join(" / ")}
        </span>
      )}
    </div>
  );
}
