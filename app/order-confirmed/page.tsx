import Link from "next/link";

export default function OrderConfirmedPage({
  searchParams,
}: {
  searchParams: { order?: string; total?: string };
}) {
  const orderNumber = searchParams.order ?? "—";
  const total = searchParams.total ?? "0";
  const swishNumber = process.env.NEXT_PUBLIC_SWISH_NUMBER || "[fyll i ditt Swish-nummer]";

  return (
    <div className="max-w-xl mx-auto px-4 py-20">
      <h1 className="font-display text-3xl font-bold text-paper mb-2">
        Tack för din beställning!
      </h1>
      <p className="text-mute mb-8">
        Ordernummer <span className="font-mono text-paper">{orderNumber}</span>{" "}
        är registrerad. Sista steget är att betala via Swish.
      </p>

      <div className="border border-gold rounded-md p-6 bg-gold/5 mb-8">
        <div className="flex justify-center mb-6">
          <div className="bg-white p-3 rounded-md">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src="/swish-qr.png"
              alt="Swish QR-kod"
              width={220}
              height={220}
            />
          </div>
        </div>
        <div className="text-sm text-mute mb-1">Swisha</div>
        <div className="font-mono text-3xl font-bold text-gold mb-4">
          {total} kr
        </div>
        <div className="text-sm text-mute mb-1">Till</div>
        <div className="font-mono text-xl text-paper mb-4">{swishNumber}</div>
        <div className="text-sm text-mute mb-1">Meddelande (viktigt!)</div>
        <div className="font-mono text-xl text-paper">{orderNumber}</div>
      </div>

      <p className="text-sm text-mute mb-8">
        Scanna QR-koden ovan för att öppna Swish med vårt nummer ifyllt —
        skriv sedan in beloppet och ordernumret som meddelande själv (koden
        vet bara vårt nummer, inte belopp/meddelande). Vi packar och
        skickar så snart betalningen kommit in, och hör av oss via e-post
        med spårningsinfo.
      </p>

      <p className="text-xs text-mute mb-8 border-t border-line pt-4">
        Vi reserverar oss för eventuella prisfel och slutförsäljning. Om
        något kort i din order visar sig ha fått fel pris eller redan är
        sålt kontaktar vi dig innan något skickas, och betalningen
        återbetalas i sin helhet om vi inte kommer överens om något annat.
      </p>

      <Link
        href="/"
        className="focus-ring inline-block rounded-sm border border-line px-6 py-3 text-paper hover:border-gold"
      >
        Tillbaka till startsidan
      </Link>
    </div>
  );
}
