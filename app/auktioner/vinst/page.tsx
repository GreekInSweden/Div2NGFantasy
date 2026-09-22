"use client";

import { Suspense, useEffect, useState } from "react";
import { useSearchParams } from "next/navigation";
import Link from "next/link";
import { AuctionWin } from "@/lib/types";
import { rarityLabel } from "@/lib/rarity";
import { variantLabel } from "@/lib/variant";
import CardZoomImage from "@/components/CardZoomImage";

export default function AuctionWinPage() {
  return (
    <Suspense fallback={<div className="max-w-xl mx-auto px-4 py-20 text-mute">Laddar…</div>}>
      <AuctionWinContent />
    </Suspense>
  );
}

function AuctionWinContent() {
  const searchParams = useSearchParams();
  const winId = searchParams.get("win");

  const [win, setWin] = useState<AuctionWin | null>(null);
  const [loading, setLoading] = useState(true);
  const [needsLogin, setNeedsLogin] = useState(false);

  useEffect(() => {
    if (!winId) {
      setLoading(false);
      return;
    }
    fetch(`/api/auction-win?id=${encodeURIComponent(winId)}`)
      .then(async (res) => {
        if (res.status === 401) {
          setNeedsLogin(true);
          return;
        }
        const data = await res.json();
        setWin(data.win ?? null);
      })
      .finally(() => setLoading(false));
  }, [winId]);

  if (loading) {
    return <div className="max-w-xl mx-auto px-4 py-20 text-mute">Laddar…</div>;
  }

  if (needsLogin) {
    return (
      <div className="max-w-xl mx-auto px-4 py-20 text-center">
        <h1 className="font-display text-2xl font-bold text-paper mb-3">
          Logga in för att se din vinst
        </h1>
        <p className="text-mute mb-6">
          Du behöver vara inloggad på samma konto som vann auktionen.
        </p>
        <Link
          href={`/konto/logga-in?next=${encodeURIComponent(`/auktioner/vinst?win=${winId}`)}`}
          className="focus-ring inline-block rounded-sm bg-gold text-ink font-semibold px-6 py-3"
        >
          Logga in
        </Link>
      </div>
    );
  }

  if (!win) {
    return (
      <div className="max-w-xl mx-auto px-4 py-20 text-center">
        <h1 className="font-display text-2xl font-bold text-paper mb-3">
          Hittade ingen vinst
        </h1>
        <p className="text-mute mb-6">
          Länken saknas eller är felaktig. Om du precis vann en auktion,
          gå tillbaka till auktionssidan — en ruta för din vinst dyker upp
          där automatiskt.
        </p>
        <Link
          href="/auktioner"
          className="focus-ring inline-block rounded-sm border border-line px-6 py-3 text-paper hover:border-gold"
        >
          Till auktionerna
        </Link>
      </div>
    );
  }

  if (win.status === "expired") {
    return (
      <div className="max-w-xl mx-auto px-4 py-20 text-center">
        <h1 className="font-display text-2xl font-bold text-paper mb-3">
          Tiden gick ut
        </h1>
        <p className="text-mute mb-6">
          Vinsten för {win.cardName} hämtades inte ut inom en vecka och
          kortet läggs ut igen.
        </p>
        <Link
          href="/auktioner"
          className="focus-ring inline-block rounded-sm border border-line px-6 py-3 text-paper hover:border-gold"
        >
          Till auktionerna
        </Link>
      </div>
    );
  }

  const reference = `AUK-${win.winId.slice(0, 8).toUpperCase()}`;
  const swishNumber = process.env.NEXT_PUBLIC_SWISH_NUMBER || "[fyll i ditt Swish-nummer]";

  return (
    <div className="max-w-xl mx-auto px-4 py-14">
      <h1 className="font-display text-3xl font-bold text-paper mb-2">
        🎉 Grattis, du vann!
      </h1>
      <p className="text-mute mb-8">
        Sista steget är att betala via Swish — vi har redan dina uppgifter
        från ditt konto.
      </p>

      <div className="border border-line rounded-md p-4 bg-panel mb-8 flex gap-4">
        {win.imageUrl && (
          <CardZoomImage
            src={win.imageUrl}
            alt={win.cardName}
            number={win.cardNumber}
            rarity={win.rarity}
            className="w-20 aspect-[3/4] rounded-sm shrink-0"
          />
        )}
        <div>
          <div className="font-mono text-xs text-mute mb-1">
            #{String(win.cardNumber).padStart(3, "0")} · {rarityLabel[win.rarity]}
          </div>
          <div className="font-display font-semibold text-paper mb-1">
            {win.cardName}{" "}
            <span className="text-mute text-sm font-body">
              ({variantLabel[win.variant]})
            </span>
          </div>
          <div className="font-mono text-gold font-semibold">{win.amountSek} kr</div>
        </div>
      </div>

      <div className="border border-gold rounded-md p-6 bg-gold/5">
        <div className="flex justify-center mb-6">
          <div className="bg-white p-3 rounded-md">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={`/api/swish-qr?amount=${win.amountSek}&message=${encodeURIComponent(reference)}`}
              alt="Swish QR-kod"
              width={220}
              height={220}
            />
          </div>
        </div>
        <div className="text-sm text-mute mb-1">Swisha</div>
        <div className="font-mono text-3xl font-bold text-gold mb-4">
          {win.amountSek} kr
        </div>
        <div className="text-sm text-mute mb-1">Till</div>
        <div className="font-mono text-xl text-paper mb-4">{swishNumber}</div>
        <div className="text-sm text-mute mb-1">Meddelande (viktigt!)</div>
        <div className="font-mono text-xl text-paper mb-4">{reference}</div>
        <p className="text-xs text-mute">
          Scanna QR-koden för att öppna Swish med belopp och meddelande
          ifyllt. Vi skickar kortet till adressen på ditt konto så snart
          betalningen kommit in — dubbelkolla den gärna under{" "}
          <Link href="/konto" className="underline hover:text-gold">
            Mitt konto
          </Link>{" "}
          om det var ett tag sen du fyllde i den.
        </p>
      </div>
    </div>
  );
}
