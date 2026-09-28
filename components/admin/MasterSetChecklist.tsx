"use client";

import { useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabase } from "@/lib/supabase/browser";
import { rarityLabel, reverseHoloEligibleRarities } from "@/lib/rarity";
import { variantShortLabel } from "@/lib/variant";
import { Rarity, Variant, ParallelTier } from "@/lib/types";
import CardZoomImage from "@/components/CardZoomImage";

interface ChecklistCard {
  id: string;
  number: number;
  name: string;
  rarity: Rarity;
  imageUrl: string | null;
  masterVariants: Variant[];
  ownedVariants: Variant[];
  ownedParallelTierIds: string[];
  wantedVariants: Variant[];
  wantedParallelTierIds: string[];
  duplicateVariants: Variant[];
}

interface Progress {
  owned: number;
  total: number;
}

function ProgressBar({ label, progress }: { label: string; progress: Progress }) {
  const pct = progress.total === 0 ? 0 : Math.round((progress.owned / progress.total) * 100);
  const complete = progress.total > 0 && progress.owned === progress.total;
  return (
    <div className="border border-line rounded-md p-4 bg-panel flex-1 min-w-[200px]">
      <div className="flex items-center justify-between mb-2">
        <span className={`text-sm font-medium ${complete ? "text-gold" : "text-paper"}`}>
          {label}
          {complete && " ✓"}
        </span>
        <span className="text-xs font-mono text-mute">
          {progress.owned}/{progress.total} ({pct}%)
        </span>
      </div>
      <div className="h-2 bg-line rounded-full overflow-hidden">
        <div
          className={`h-full ${complete ? "bg-gold" : "bg-mute"}`}
          style={{ width: `${pct}%` }}
        />
      </div>
    </div>
  );
}

function ParallelGuideRow({
  tier,
  imageUrl,
  uploading,
  onUpload,
}: {
  tier: ParallelTier;
  imageUrl: string | null;
  uploading: boolean;
  onUpload: (file: File) => void;
}) {
  return (
    <div className="flex items-center justify-between gap-2 text-xs text-paper py-1 border-b border-line/50">
      <div className="flex items-center gap-2 min-w-0">
        <label className="shrink-0 cursor-pointer group relative">
          {imageUrl ? (
            <img
              src={imageUrl}
              alt={tier.name}
              className="w-8 h-11 object-cover rounded-sm border border-line"
            />
          ) : (
            <div className="w-8 h-11 rounded-sm border border-dashed border-line flex items-center justify-center text-mute text-sm">
              +
            </div>
          )}
          <div className="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity rounded-sm">
            <span className="text-[8px] text-paper text-center leading-tight px-0.5">
              {uploading ? "…" : imageUrl ? "Byt" : "Lägg till"}
            </span>
          </div>
          <input
            type="file"
            accept="image/*"
            className="hidden"
            disabled={uploading}
            onChange={(e) => {
              const file = e.target.files?.[0];
              if (file) onUpload(file);
              e.target.value = "";
            }}
          />
        </label>
        <span className="truncate">{tier.name}</span>
      </div>
      <span className="font-mono text-mute shrink-0">
        {tier.print_run ? `/${tier.print_run}` : "onumrerad"}
      </span>
    </div>
  );
}

export default function MasterSetChecklist({
  setName,
  cards,
  masterProgress,
  parallelTiers = [],
  duplicateSellerUsername = null,
  duplicateSellerMemberId = null,
}: {
  setName: string;
  cards: ChecklistCard[];
  masterProgress: Progress;
  parallelTiers?: ParallelTier[];
  duplicateSellerUsername?: string | null;
  duplicateSellerMemberId?: string | null;
}) {
  const router = useRouter();
  const [owned, setOwned] = useState<Record<string, Variant[]>>(() => {
    const map: Record<string, Variant[]> = {};
    for (const c of cards) map[c.id] = c.ownedVariants;
    return map;
  });
  const [pending, setPending] = useState<string | null>(null);
  const [query, setQuery] = useState("");
  const [hideComplete, setHideComplete] = useState(false);
  const [showWantedOnly, setShowWantedOnly] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Egen önskelista -- "jag letar aktivt efter det här kortet/den här
  // varianten" -- helt separat från owned ovan och lagras i sin egen
  // tabell (master_set_wants) så den aldrig krockar med ägande-statusen.
  const [wanted, setWanted] = useState<Record<string, Variant[]>>(() => {
    const map: Record<string, Variant[]> = {};
    for (const c of cards) map[c.id] = c.wantedVariants;
    return map;
  });
  const [wantPending, setWantPending] = useState<string | null>(null);

  // Dubbletter till salu -- skrivs till member_cards (samma tabell som
  // medlemmarnas egen portfölj) kopplat till det säljkonto admin har
  // valt nedan, så de dyker upp för medlemmar via det vanliga
  // matchningssystemet utan något eget UI för det.
  const [duplicates, setDuplicates] = useState<Record<string, Variant[]>>(() => {
    const map: Record<string, Variant[]> = {};
    for (const c of cards) map[c.id] = c.duplicateVariants;
    return map;
  });
  const [duplicatePending, setDuplicatePending] = useState<string | null>(null);
  const [usernameInput, setUsernameInput] = useState(duplicateSellerUsername ?? "");
  const [savingUsername, setSavingUsername] = useState(false);
  const [usernameError, setUsernameError] = useState<string | null>(null);
  const [usernameSaved, setUsernameSaved] = useState(false);

  async function saveSellerUsername() {
    const trimmed = usernameInput.trim();
    setUsernameError(null);
    setUsernameSaved(false);
    if (!trimmed) {
      setUsernameError("Ange ett användarnamn.");
      return;
    }
    setSavingUsername(true);
    const supabase = createBrowserSupabase();
    const { data: memberRow, error: lookupErr } = await supabase
      .from("members")
      .select("id")
      .ilike("username", trimmed)
      .maybeSingle();
    if (lookupErr || !memberRow) {
      setSavingUsername(false);
      setUsernameError(
        "Hittar ingen medlem med det användarnamnet. Kontot måste redan finnas (registrera det som vanligt via Skapa konto först, med det användarnamnet)."
      );
      return;
    }
    const { error: upsertErr } = await supabase
      .from("admin_settings")
      .upsert({ key: "duplicate_seller_username", value: trimmed }, { onConflict: "key" });
    setSavingUsername(false);
    if (upsertErr) {
      setUsernameError(upsertErr.message);
      return;
    }
    setUsernameSaved(true);
    router.refresh();
  }

  async function toggleDuplicate(cardId: string, variant: Variant, isDuplicate: boolean) {
    if (!duplicateSellerMemberId) return;
    const key = `${cardId}-${variant}`;
    setDuplicatePending(key);
    setError(null);
    const supabase = createBrowserSupabase();

    if (isDuplicate) {
      const { error: delErr } = await supabase
        .from("member_cards")
        .delete()
        .eq("member_id", duplicateSellerMemberId)
        .eq("card_id", cardId)
        .eq("variant", variant)
        .eq("status", "have")
        .is("parallel_tier_id", null);
      setDuplicatePending(null);
      if (delErr) {
        setError(delErr.message);
        return;
      }
      setDuplicates((d) => ({
        ...d,
        [cardId]: (d[cardId] ?? []).filter((v) => v !== variant),
      }));
    } else {
      // NULL parallel_tier_id räknas inte som samma värde av sig själv i
      // en unique-constraint, så en ren upsert kan skapa dubbletter av
      // dubbletten -- kolla om raden redan finns (t.ex. om medlemmen
      // själv råkat lägga in samma "har"-rad) och uppdatera den istället.
      const { data: existing } = await supabase
        .from("member_cards")
        .select("id")
        .eq("member_id", duplicateSellerMemberId)
        .eq("card_id", cardId)
        .eq("variant", variant)
        .eq("status", "have")
        .is("parallel_tier_id", null)
        .maybeSingle();

      const { error: writeErr } = existing
        ? await supabase
            .from("member_cards")
            .update({ sellable: true })
            .eq("id", existing.id)
        : await supabase.from("member_cards").insert({
            member_id: duplicateSellerMemberId,
            card_id: cardId,
            variant,
            status: "have",
            quantity: 1,
            sellable: true,
            tradeable: false,
          });
      setDuplicatePending(null);
      if (writeErr) {
        setError(writeErr.message);
        return;
      }
      setDuplicates((d) => ({
        ...d,
        [cardId]: [...(d[cardId] ?? []), variant],
      }));
    }
  }

  // Parallels är ett fristående bonuslager -- vilka Topps-färger/tryck du
  // råkar äga av ett kort -- som INTE räknas in i masterVariants/liveMaster
  // ovan. Nyckel: card_id, värde: lista av ägda parallel_tier_id.
  const [ownedParallels, setOwnedParallels] = useState<Record<string, string[]>>(() => {
    const map: Record<string, string[]> = {};
    for (const c of cards) map[c.id] = c.ownedParallelTierIds;
    return map;
  });
  const [selectedParallel, setSelectedParallel] = useState<Record<string, string>>({});
  const [parallelPending, setParallelPending] = useState<string | null>(null);
  const [showParallelGuide, setShowParallelGuide] = useState(false);

  // Samma sak fast för önskelistan -- vilka parallel-färger man aktivt
  // letar efter, skrivna till master_set_wants med parallel_tier_id
  // satt istället för null. Håller sig undan cardOwnedParallels ovan så
  // en redan ägd färg inte samtidigt kan stå som önskad.
  const [wantedParallels, setWantedParallels] = useState<Record<string, string[]>>(() => {
    const map: Record<string, string[]> = {};
    for (const c of cards) map[c.id] = c.wantedParallelTierIds;
    return map;
  });
  const [selectedWantedParallel, setSelectedWantedParallel] = useState<Record<string, string>>({});
  const [wantedParallelPending, setWantedParallelPending] = useState<string | null>(null);

  // Ett exempelfoto per parallel (inte per kort — samma foliefärg ser
  // likadan ut oavsett spelare), så man faktiskt kan se nyansen istället
  // för att bara läsa namnet. Nyckel: parallel_tier_id.
  const [tierImages, setTierImages] = useState<Record<string, string | null>>(() => {
    const map: Record<string, string | null> = {};
    for (const t of parallelTiers) map[t.id] = t.image_url;
    return map;
  });
  const [uploadingTierId, setUploadingTierId] = useState<string | null>(null);

  async function handleTierImageUpload(tierId: string, file: File) {
    setError(null);
    setUploadingTierId(tierId);
    const supabase = createBrowserSupabase();

    const ext = file.name.split(".").pop() || "jpg";
    const path = `parallel-${tierId}.${ext}`;

    const { error: uploadErr } = await supabase.storage
      .from("card-images")
      .upload(path, file, { upsert: true, cacheControl: "3600" });

    if (uploadErr) {
      setUploadingTierId(null);
      setError(`Kunde inte ladda upp bilden: ${uploadErr.message}`);
      return;
    }

    const { data: publicUrlData } = supabase.storage
      .from("card-images")
      .getPublicUrl(path);
    const freshUrl = `${publicUrlData.publicUrl}?t=${Date.now()}`;

    const { error: updateErr } = await supabase
      .from("parallel_tiers")
      .update({ image_url: freshUrl })
      .eq("id", tierId);

    setUploadingTierId(null);
    if (updateErr) {
      setError(`Bilden laddades upp men kunde inte sparas: ${updateErr.message}`);
      return;
    }
    setTierImages((prev) => ({ ...prev, [tierId]: freshUrl }));
  }

  // Cards were seeded before reverse holo tracking existed, or an admin
  // simply never checked "reverse holo" when uploading — so many cards
  // have no reverse_holo row in card_variants yet, and masterVariants
  // (computed server-side from what actually exists) won't include it.
  // Rather than sending people off to the stock editor to add a missing
  // variant one card at a time, this set tracks which cards we've just
  // created a reverse_holo row for right here, and folds that into the
  // effective master-set list below until the page next reloads.
  const [addedReverseHolo, setAddedReverseHolo] = useState<Set<string>>(new Set());
  const [addingReverseHolo, setAddingReverseHolo] = useState<string | null>(null);

  function effectiveMasterVariants(c: ChecklistCard): Variant[] {
    if (
      addedReverseHolo.has(c.id) &&
      reverseHoloEligibleRarities.includes(c.rarity) &&
      !c.masterVariants.includes("reverse_holo")
    ) {
      return [...c.masterVariants, "reverse_holo"];
    }
    return c.masterVariants;
  }

  // Local, live-recomputed progress so the bars move instantly as you
  // check things off, instead of waiting for a page refresh.
  const liveMaster = useMemo(() => {
    let ownedN = 0;
    let totalN = 0;
    for (const c of cards) {
      const need = effectiveMasterVariants(c);
      totalN += need.length;
      ownedN += need.filter((v) => owned[c.id]?.includes(v)).length;
    }
    return { owned: ownedN, total: totalN };
  }, [cards, owned, addedReverseHolo]);

  const totalWanted = useMemo(
    () =>
      Object.values(wanted).reduce((n, vs) => n + vs.length, 0) +
      Object.values(wantedParallels).reduce((n, vs) => n + vs.length, 0),
    [wanted, wantedParallels]
  );

  const filteredCards = useMemo(() => {
    const q = query.trim().toLowerCase();
    let list = cards;
    if (q) {
      list = list.filter(
        (c) =>
          c.name.toLowerCase().includes(q) ||
          String(c.number).padStart(3, "0").includes(q)
      );
    }
    if (hideComplete) {
      list = list.filter((c) => {
        const need = effectiveMasterVariants(c);
        return !need.every((v) => owned[c.id]?.includes(v));
      });
    }
    if (showWantedOnly) {
      list = list.filter(
        (c) => (wanted[c.id]?.length ?? 0) > 0 || (wantedParallels[c.id]?.length ?? 0) > 0
      );
    }
    return list;
  }, [cards, query, hideComplete, showWantedOnly, owned, wanted, wantedParallels, addedReverseHolo]);

  async function toggleWant(cardId: string, variant: Variant, isWanted: boolean) {
    const key = `${cardId}-${variant}`;
    setWantPending(key);
    setError(null);
    const supabase = createBrowserSupabase();

    if (isWanted) {
      const { error: delErr } = await supabase
        .from("master_set_wants")
        .delete()
        .eq("card_id", cardId)
        .eq("variant", variant);
      setWantPending(null);
      if (delErr) {
        setError(delErr.message);
        return;
      }
      setWanted((w) => ({
        ...w,
        [cardId]: (w[cardId] ?? []).filter((v) => v !== variant),
      }));
    } else {
      const { error: insErr } = await supabase
        .from("master_set_wants")
        .insert({ card_id: cardId, variant });
      setWantPending(null);
      if (insErr) {
        if (!insErr.message?.toLowerCase().includes("duplicate")) {
          setError(insErr.message);
          return;
        }
      }
      setWanted((w) => ({
        ...w,
        [cardId]: [...(w[cardId] ?? []), variant],
      }));
    }
  }

  async function addReverseHolo(cardId: string) {
    setAddingReverseHolo(cardId);
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: insErr } = await supabase
      .from("card_variants")
      .insert({ card_id: cardId, variant: "reverse_holo", price_sek: 4, stock: 0 });
    setAddingReverseHolo(null);
    if (insErr) {
      // Redan tillagd (t.ex. i en annan flik) räknas inte som ett fel.
      if (!insErr.message?.toLowerCase().includes("duplicate")) {
        setError(insErr.message);
        return;
      }
    }
    setAddedReverseHolo((prev) => new Set(prev).add(cardId));
  }

  async function toggle(cardId: string, variant: Variant, isOwned: boolean) {
    const key = `${cardId}-${variant}`;
    setPending(key);
    setError(null);
    const supabase = createBrowserSupabase();

    if (isOwned) {
      const { error: delErr } = await supabase
        .from("master_set_progress")
        .delete()
        .eq("card_id", cardId)
        .eq("variant", variant);
      setPending(null);
      if (delErr) {
        setError(delErr.message);
        return;
      }
      setOwned((o) => ({
        ...o,
        [cardId]: (o[cardId] ?? []).filter((v) => v !== variant),
      }));
      // Inte längre ägt -- ingen dubblett kvar att sälja.
      if ((duplicates[cardId] ?? []).includes(variant)) {
        toggleDuplicate(cardId, variant, true);
      }
    } else {
      const { error: insErr } = await supabase
        .from("master_set_progress")
        .insert({ card_id: cardId, variant });
      setPending(null);
      if (insErr) {
        setError(insErr.message);
        return;
      }
      setOwned((o) => ({
        ...o,
        [cardId]: [...(o[cardId] ?? []), variant],
      }));
      // Nu ägt -- ingen anledning att fortfarande stå på önskelistan.
      if ((wanted[cardId] ?? []).includes(variant)) {
        toggleWant(cardId, variant, true);
      }
    }
  }

  // Parallellerna skrivs till SAMMA tabell (master_set_progress) som det
  // kravsatta master-setet, men med parallel_tier_id satt istället för
  // null -- de kravsatta raderna ovan (toggle()) rör aldrig den kolumnen,
  // så de två listorna kan aldrig krocka eller påverka varandras räkning.
  // Variant sätts till setets bas-variant (masterVariants[0]) rent
  // bokföringsmässigt -- parallels är en färg/tryck-variant av kortet,
  // inte en egen "normal/holo/reverse_holo"-status.
  async function addParallel(card: ChecklistCard) {
    const tierId = selectedParallel[card.id];
    if (!tierId) return;
    const baseVariant: Variant = card.masterVariants[0] ?? "normal";
    setParallelPending(`${card.id}-add`);
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: insErr } = await supabase.from("master_set_progress").insert({
      card_id: card.id,
      variant: baseVariant,
      parallel_tier_id: tierId,
    });
    setParallelPending(null);
    if (insErr) {
      if (!insErr.message?.toLowerCase().includes("duplicate")) {
        setError(insErr.message);
        return;
      }
    }
    setOwnedParallels((o) => ({
      ...o,
      [card.id]: [...(o[card.id] ?? []), tierId],
    }));
    setSelectedParallel((s) => ({ ...s, [card.id]: "" }));
    // Nu ägd -- ingen anledning att fortfarande stå på önskelistan.
    if ((wantedParallels[card.id] ?? []).includes(tierId)) {
      removeWantedParallel(card.id, tierId);
    }
  }

  async function removeParallel(cardId: string, tierId: string) {
    const key = `${cardId}-${tierId}`;
    setParallelPending(key);
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: delErr } = await supabase
      .from("master_set_progress")
      .delete()
      .eq("card_id", cardId)
      .eq("parallel_tier_id", tierId);
    setParallelPending(null);
    if (delErr) {
      setError(delErr.message);
      return;
    }
    setOwnedParallels((o) => ({
      ...o,
      [cardId]: (o[cardId] ?? []).filter((id) => id !== tierId),
    }));
  }

  // Samma modell som addParallel/removeParallel ovan, fast mot
  // master_set_wants (parallel_tier_id satt) istället för
  // master_set_progress -- "jag letar efter den här färgen", inte "jag
  // äger den".
  async function addWantedParallel(card: ChecklistCard) {
    const tierId = selectedWantedParallel[card.id];
    if (!tierId) return;
    const baseVariant: Variant = card.masterVariants[0] ?? "normal";
    setWantedParallelPending(`${card.id}-add`);
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: insErr } = await supabase.from("master_set_wants").insert({
      card_id: card.id,
      variant: baseVariant,
      parallel_tier_id: tierId,
    });
    setWantedParallelPending(null);
    if (insErr) {
      if (!insErr.message?.toLowerCase().includes("duplicate")) {
        setError(insErr.message);
        return;
      }
    }
    setWantedParallels((w) => ({
      ...w,
      [card.id]: [...(w[card.id] ?? []), tierId],
    }));
    setSelectedWantedParallel((s) => ({ ...s, [card.id]: "" }));
  }

  async function removeWantedParallel(cardId: string, tierId: string) {
    const key = `${cardId}-${tierId}`;
    setWantedParallelPending(key);
    setError(null);
    const supabase = createBrowserSupabase();
    const { error: delErr } = await supabase
      .from("master_set_wants")
      .delete()
      .eq("card_id", cardId)
      .eq("parallel_tier_id", tierId);
    setWantedParallelPending(null);
    if (delErr) {
      setError(delErr.message);
      return;
    }
    setWantedParallels((w) => ({
      ...w,
      [cardId]: (w[cardId] ?? []).filter((id) => id !== tierId),
    }));
  }

  return (
    <div>
      <h2 className="font-display text-lg font-semibold text-paper mb-4">
        {setName}
      </h2>

      <div className="flex flex-wrap gap-3 mb-6">
        <ProgressBar label="Master Set" progress={liveMaster} />
        <div className="border border-line rounded-md p-4 bg-panel flex-1 min-w-[200px] flex items-center justify-between">
          <span className="text-sm font-medium text-paper">Önskelista</span>
          <span className="text-xs font-mono text-mute">{totalWanted} kort</span>
        </div>
      </div>

      <div className="mb-6 border border-line rounded-md p-4 bg-panel">
        <div className="text-sm font-medium text-paper mb-1">Dubbletter till salu</div>
        <p className="text-xs text-mute mb-3 max-w-prose">
          Kort du markerar som dubblett här läggs upp som "har, till salu"
          på det medlemskonto du väljer nedan -- så dyker de upp för andra
          medlemmar via Mina matchningar, precis som om kontot självt hade
          kryssat i det i sin portfölj. Kontot måste redan finnas (skapa
          det som vanligt via Skapa konto, med det användarnamn du anger
          här).
        </p>
        <div className="flex flex-wrap items-center gap-2">
          <input
            type="text"
            value={usernameInput}
            onChange={(e) => {
              setUsernameInput(e.target.value);
              setUsernameSaved(false);
            }}
            placeholder="Användarnamn, t.ex. Kortmarknad"
            className="focus-ring bg-panelLight border border-line rounded-sm px-3 py-1.5 text-sm text-paper"
          />
          <button
            type="button"
            onClick={saveSellerUsername}
            disabled={savingUsername}
            className="focus-ring text-xs rounded-sm bg-gold text-ink font-semibold px-3 py-1.5 disabled:opacity-50"
          >
            {savingUsername ? "Sparar…" : "Spara"}
          </button>
          {duplicateSellerMemberId && (
            <span className="text-xs text-gold">
              ✓ Aktivt konto: {duplicateSellerUsername}
            </span>
          )}
          {duplicateSellerUsername && !duplicateSellerMemberId && (
            <span className="text-xs text-red-400">
              Hittar inget konto med användarnamnet "{duplicateSellerUsername}" längre.
            </span>
          )}
          {usernameSaved && <span className="text-xs text-gold">Sparat ✓</span>}
        </div>
        {usernameError && <p className="text-xs text-red-400 mt-2">{usernameError}</p>}
      </div>

      {parallelTiers.length > 0 && (
        <div className="mb-6">
          <button
            type="button"
            onClick={() => setShowParallelGuide((v) => !v)}
            className="focus-ring text-xs text-mute hover:text-gold border border-line hover:border-gold rounded-sm px-3 py-1.5"
          >
            {showParallelGuide ? "Dölj" : "ⓘ Vad är parallels?"} ({parallelTiers.length} st)
          </button>
          {showParallelGuide && (
            <div className="mt-3 border border-line rounded-md p-4 bg-panel">
              <p className="text-xs text-mute mb-3 max-w-prose">
                Varje spelare finns i flera färgade/numrerade tryck utöver
                grundkortet. Namnet beskriver oftast färgen (t.ex. "Gold
                Rainbow Foil"), och siffran efter "/" är hur många exemplar
                som finns totalt av just den färgen — lägre siffra betyder
                mer sällsynt. Onumrerade rader nedan finns i en okänd,
                större upplaga. "Hobby" och "Retail" är bara vilken sorts
                paket kortet kommer från. Klicka på en ruta för att ladda
                upp ett foto av ett riktigt kort i den färgen — det räcker
                med ett kort per färg, oavsett spelare, så listan fylls på
                allt eftersom ni stöter på dem.
              </p>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-6 gap-y-1">
                {/* Grupperat dynamiskt på vad som faktiskt finns i
                    channel-kolumnen, istället för en hårdkodad
                    hobby/retail-lista -- olika säsonger/set har olika
                    kanaler (t.ex. PL 2025/26 har en tredje "display-box"-
                    kanal utöver hobby/retail), och en hårdkodad lista
                    tappade tyst bort allt som inte var exakt "hobby"
                    eller "retail". "Övrigt" är reserverat för null. */}
                {Array.from(
                  new Set(parallelTiers.filter((t) => t.channel).map((t) => t.channel as string))
                ).map((ch) => {
                  const tiers = parallelTiers.filter((t) => t.channel === ch);
                  const chLabel =
                    ch === "hobby" ? "Hobby" : ch === "retail" ? "Retail" : ch === "display-box" ? "Display Box" : ch;
                  return (
                    <div key={ch} className="mb-2">
                      <div className="text-[10px] uppercase tracking-wide text-mute mb-1">
                        {chLabel}
                      </div>
                      {tiers.map((t) => (
                        <ParallelGuideRow
                          key={t.id}
                          tier={t}
                          imageUrl={tierImages[t.id] ?? null}
                          uploading={uploadingTierId === t.id}
                          onUpload={(file) => handleTierImageUpload(t.id, file)}
                        />
                      ))}
                    </div>
                  );
                })}
                {parallelTiers.some((t) => !t.channel) && (
                  <div className="mb-2">
                    <div className="text-[10px] uppercase tracking-wide text-mute mb-1">
                      Övrigt
                    </div>
                    {parallelTiers
                      .filter((t) => !t.channel)
                      .map((t) => (
                        <ParallelGuideRow
                          key={t.id}
                          tier={t}
                          imageUrl={tierImages[t.id] ?? null}
                          uploading={uploadingTierId === t.id}
                          onUpload={(file) => handleTierImageUpload(t.id, file)}
                        />
                      ))}
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      )}

      <div className="sticky top-0 z-10 bg-ink py-3 -mx-4 px-4 mb-4 border-b border-line flex items-center gap-3">
        <input
          type="text"
          placeholder="Sök kort efter namn eller nummer…"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          className="focus-ring flex-1 bg-panel border border-line rounded-sm px-3 py-2 text-paper text-sm"
        />
        <label className="flex items-center gap-2 text-xs text-mute shrink-0">
          <input
            type="checkbox"
            checked={hideComplete}
            onChange={(e) => setHideComplete(e.target.checked)}
            className="focus-ring accent-gold w-4 h-4"
          />
          Dölj klara
        </label>
        <label className="flex items-center gap-2 text-xs text-mute shrink-0">
          <input
            type="checkbox"
            checked={showWantedOnly}
            onChange={(e) => setShowWantedOnly(e.target.checked)}
            className="focus-ring accent-gold w-4 h-4"
          />
          Endast önskelista
        </label>
      </div>

      {error && <p className="text-sm text-red-400 mb-4">{error}</p>}

      <div className="space-y-2">
        {filteredCards.map((c) => {
          const cardOwned = owned[c.id] ?? [];
          const needVariants = effectiveMasterVariants(c);
          const canAddReverseHolo =
            reverseHoloEligibleRarities.includes(c.rarity) &&
            !needVariants.includes("reverse_holo");
          const cardOwnedParallels = ownedParallels[c.id] ?? [];
          const availableParallels = parallelTiers.filter(
            (t) => !cardOwnedParallels.includes(t.id)
          );
          const cardWantedParallels = wantedParallels[c.id] ?? [];
          const availableWantedParallels = parallelTiers.filter(
            (t) => !cardOwnedParallels.includes(t.id) && !cardWantedParallels.includes(t.id)
          );
          const cardWanted = wanted[c.id] ?? [];
          const cardDuplicates = duplicates[c.id] ?? [];
          return (
            <div
              key={c.id}
              className="border border-line rounded-md p-3 bg-panel flex flex-col gap-3"
            >
              <div className="flex items-center gap-4">
                <CardZoomImage
                  src={c.imageUrl}
                  alt={c.name}
                  number={c.number}
                  rarity={c.rarity}
                  className="w-12 h-16 rounded-sm shrink-0"
                />
                <div className="w-16 shrink-0 font-mono text-xs text-mute">
                  #{String(c.number).padStart(3, "0")}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="font-display text-sm font-medium text-paper truncate">
                    {c.name}
                  </div>
                  <div className="text-xs text-mute">{rarityLabel[c.rarity]}</div>
                </div>
                <div className="flex items-center gap-3 shrink-0">
                  {needVariants.map((v) => {
                    const isOwned = cardOwned.includes(v);
                    const isWanted = cardWanted.includes(v);
                    const isDuplicate = cardDuplicates.includes(v);
                    const key = `${c.id}-${v}`;
                    const isPending = pending === key;
                    const isWantPending = wantPending === key;
                    const isDuplicatePending = duplicatePending === key;
                    return (
                      <div key={v} className="flex flex-col items-center gap-1">
                        <label className="flex flex-col items-center gap-1 text-[10px] text-mute cursor-pointer">
                          <input
                            type="checkbox"
                            checked={isOwned}
                            disabled={isPending}
                            onChange={() => toggle(c.id, v, isOwned)}
                            className="focus-ring accent-gold w-4 h-4"
                          />
                          {variantShortLabel[v]}
                        </label>
                        {!isOwned && (
                          <button
                            type="button"
                            onClick={() => toggleWant(c.id, v, isWanted)}
                            disabled={isWantPending}
                            title={isWanted ? "Ta bort från önskelistan" : "Lägg till på önskelistan"}
                            className={`focus-ring text-[9px] rounded-sm border px-1 py-0.5 whitespace-nowrap disabled:opacity-50 ${
                              isWanted
                                ? "bg-gold/20 text-gold border-gold/60"
                                : "text-mute border-line hover:border-gold hover:text-gold"
                            }`}
                          >
                            {isWanted ? "★ Vill ha" : "☆ Vill ha"}
                          </button>
                        )}
                        {isOwned && duplicateSellerMemberId && (
                          <button
                            type="button"
                            onClick={() => toggleDuplicate(c.id, v, isDuplicate)}
                            disabled={isDuplicatePending}
                            title={
                              isDuplicate
                                ? "Ta bort från salu"
                                : "Markera som dubblett -- till salu för medlemmar"
                            }
                            className={`focus-ring text-[9px] rounded-sm border px-1 py-0.5 whitespace-nowrap disabled:opacity-50 ${
                              isDuplicate
                                ? "bg-sport-pitch/20 text-sport-pitch border-sport-pitch/60"
                                : "text-mute border-line hover:border-sport-pitch hover:text-sport-pitch"
                            }`}
                          >
                            {isDuplicate ? "✓ Till salu" : "Dubblett?"}
                          </button>
                        )}
                      </div>
                    );
                  })}
                  {canAddReverseHolo && (
                    <button
                      type="button"
                      onClick={() => addReverseHolo(c.id)}
                      disabled={addingReverseHolo === c.id}
                      className="focus-ring text-[10px] text-mute hover:text-gold border border-line hover:border-gold rounded-sm px-2 py-1 disabled:opacity-50 whitespace-nowrap"
                      title="Lägg till reverse holo-variant för det här kortet"
                    >
                      {addingReverseHolo === c.id ? "Lägger till…" : "+ Rev. Holo"}
                    </button>
                  )}
                </div>
              </div>

              {parallelTiers.length > 0 && (
                <div className="flex flex-wrap items-center gap-2 pl-[6.5rem] border-t border-line pt-2">
                  <span className="text-[10px] uppercase tracking-wide text-mute shrink-0">
                    Parallels:
                  </span>
                  {cardOwnedParallels.length === 0 && (
                    <span className="text-[10px] text-mute">Inga registrerade</span>
                  )}
                  {cardOwnedParallels.map((tierId) => {
                    const tier = parallelTiers.find((t) => t.id === tierId);
                    if (!tier) return null;
                    const key = `${c.id}-${tierId}`;
                    return (
                      <span
                        key={tierId}
                        className="inline-flex items-center gap-1 text-[10px] bg-sport-pitch/10 text-sport-pitch border border-sport-pitch/40 rounded-full px-2 py-0.5"
                      >
                        {tier.name}
                        {tier.print_run ? ` /${tier.print_run}` : ""}
                        <button
                          type="button"
                          onClick={() => removeParallel(c.id, tierId)}
                          disabled={parallelPending === key}
                          className="focus-ring text-sport-pitch/70 hover:text-red-400 disabled:opacity-50"
                          title="Ta bort"
                        >
                          ×
                        </button>
                      </span>
                    );
                  })}
                  {availableParallels.length > 0 && (
                    <span className="flex items-center gap-1 ml-auto">
                      <select
                        value={selectedParallel[c.id] ?? ""}
                        onChange={(e) =>
                          setSelectedParallel((s) => ({ ...s, [c.id]: e.target.value }))
                        }
                        className="focus-ring bg-panelLight border border-line rounded-sm px-2 py-1 text-[10px] text-paper"
                      >
                        <option value="">Välj parallel…</option>
                        {availableParallels.map((t) => (
                          <option key={t.id} value={t.id}>
                            {t.name}
                            {t.print_run ? ` /${t.print_run}` : ""}
                          </option>
                        ))}
                      </select>
                      <button
                        type="button"
                        onClick={() => addParallel(c)}
                        disabled={
                          !selectedParallel[c.id] || parallelPending === `${c.id}-add`
                        }
                        className="focus-ring text-[10px] text-mute hover:text-gold border border-line hover:border-gold rounded-sm px-2 py-1 disabled:opacity-50 whitespace-nowrap"
                      >
                        + Lägg till
                      </button>
                    </span>
                  )}
                </div>
              )}

              {parallelTiers.length > 0 && (
                <div className="flex flex-wrap items-center gap-2 pl-[6.5rem]">
                  <span className="text-[10px] uppercase tracking-wide text-mute shrink-0">
                    Vill ha parallels:
                  </span>
                  {cardWantedParallels.length === 0 && (
                    <span className="text-[10px] text-mute">Inga önskade</span>
                  )}
                  {cardWantedParallels.map((tierId) => {
                    const tier = parallelTiers.find((t) => t.id === tierId);
                    if (!tier) return null;
                    const key = `${c.id}-${tierId}`;
                    return (
                      <span
                        key={tierId}
                        className="inline-flex items-center gap-1 text-[10px] bg-gold/20 text-gold border border-gold/40 rounded-full px-2 py-0.5"
                      >
                        {tier.name}
                        {tier.print_run ? ` /${tier.print_run}` : ""}
                        <button
                          type="button"
                          onClick={() => removeWantedParallel(c.id, tierId)}
                          disabled={wantedParallelPending === key}
                          className="focus-ring text-gold/70 hover:text-red-400 disabled:opacity-50"
                          title="Ta bort från önskelistan"
                        >
                          ×
                        </button>
                      </span>
                    );
                  })}
                  {availableWantedParallels.length > 0 && (
                    <span className="flex items-center gap-1 ml-auto">
                      <select
                        value={selectedWantedParallel[c.id] ?? ""}
                        onChange={(e) =>
                          setSelectedWantedParallel((s) => ({ ...s, [c.id]: e.target.value }))
                        }
                        className="focus-ring bg-panelLight border border-line rounded-sm px-2 py-1 text-[10px] text-paper"
                      >
                        <option value="">Välj parallel…</option>
                        {availableWantedParallels.map((t) => (
                          <option key={t.id} value={t.id}>
                            {t.name}
                            {t.print_run ? ` /${t.print_run}` : ""}
                          </option>
                        ))}
                      </select>
                      <button
                        type="button"
                        onClick={() => addWantedParallel(c)}
                        disabled={
                          !selectedWantedParallel[c.id] ||
                          wantedParallelPending === `${c.id}-add`
                        }
                        className="focus-ring text-[10px] text-mute hover:text-gold border border-line hover:border-gold rounded-sm px-2 py-1 disabled:opacity-50 whitespace-nowrap"
                      >
                        + Vill ha
                      </button>
                    </span>
                  )}
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}
