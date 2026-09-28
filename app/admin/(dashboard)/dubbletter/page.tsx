import { createServerSupabase } from "@/lib/supabase/server";
import { Rarity, Variant } from "@/lib/types";
import DuplicateList from "@/components/admin/DuplicateList";

export const dynamic = "force-dynamic";

export interface DuplicateRow {
  id: string;
  variant: Variant;
  sellable: boolean;
  tradeable: boolean;
  cardId: string;
  number: number;
  name: string;
  rarity: Rarity;
  imageUrl: string | null;
  setName: string;
  setSlug: string;
}

export default async function DubbletterPage() {
  const supabase = createServerSupabase();

  const { data: sellerSetting } = await supabase
    .from("admin_settings")
    .select("value")
    .eq("key", "duplicate_seller_username")
    .maybeSingle();
  const sellerUsername = (sellerSetting?.value as string | null) ?? null;

  let sellerMemberId: string | null = null;
  if (sellerUsername) {
    const { data: sellerMember } = await supabase
      .from("members")
      .select("id")
      .ilike("username", sellerUsername)
      .maybeSingle();
    sellerMemberId = (sellerMember?.id as string | undefined) ?? null;
  }

  let rows: DuplicateRow[] = [];
  if (sellerMemberId) {
    const { data } = await supabase
      .from("member_cards")
      .select(
        "id, variant, sellable, tradeable, parallel_tier_id, cards(id, number, name, rarity, image_url, sets(name, slug))"
      )
      .eq("member_id", sellerMemberId)
      .eq("status", "have")
      .is("parallel_tier_id", null)
      .or("sellable.eq.true,tradeable.eq.true");

    rows = (
      (data as unknown as {
        id: string;
        variant: Variant;
        sellable: boolean;
        tradeable: boolean;
        cards: {
          id: string;
          number: number;
          name: string;
          rarity: Rarity;
          image_url: string | null;
          sets: { name: string; slug: string } | null;
        } | null;
      }[]) ?? []
    )
      .filter((r) => r.cards)
      .map((r) => ({
        id: r.id,
        variant: r.variant,
        sellable: r.sellable,
        tradeable: r.tradeable,
        cardId: r.cards!.id,
        number: r.cards!.number,
        name: r.cards!.name,
        rarity: r.cards!.rarity,
        imageUrl: r.cards!.image_url,
        setName: r.cards!.sets?.name ?? "Okänt set",
        setSlug: r.cards!.sets?.slug ?? "",
      }))
      .sort((a, b) => a.setName.localeCompare(b.setName) || a.number - b.number);
  }

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Dubbletter till salu
      </h1>
      <p className="text-mute mb-8">
        Alla kort som just nu är uppmarkerade som till salu/bytbara via
        Master Set eller en bulk-import -- klicka "Markera som klar" när en
        affär är gjord (sålt eller bytat) så försvinner kortet direkt från
        andra medlemmars matchningar. Inget här spåras automatiskt; det är
        du som säger till när det är klart.
      </p>

      {!sellerMemberId ? (
        <p className="text-mute">
          Inget säljkonto konfigurerat än -- ställ in det på{" "}
          <a href="/admin/masterset" className="text-gold hover:underline">
            Master Set-sidan
          </a>{" "}
          först.
        </p>
      ) : rows.length === 0 ? (
        <p className="text-mute">Inga aktiva dubbletter just nu.</p>
      ) : (
        <DuplicateList rows={rows} />
      )}
    </div>
  );
}
