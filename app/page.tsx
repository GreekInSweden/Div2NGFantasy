import Link from "next/link";
import { redirect } from "next/navigation";
import { getCurrentMember } from "@/lib/currentMember";
import { LAGER_ENABLED } from "@/lib/siteConfig";

export const dynamic = "force-dynamic";

// A logged-in medlem hamnar direkt i sin egen portfölj — det är den de
// faktiskt kommer jobba med mest, särskilt precis efter att ha öppnat
// nya packs. En besökare som inte är inloggad ännu ser istället en
// riktig landningssida här (nedan) som förklarar vad man kan göra på
// sidan, istället för att kastas rakt in i lagret utan förklaring.
export default async function RootPage() {
  const member = await getCurrentMember();
  if (member) {
    redirect("/konto/portfolj");
  }

  return (
    <div>
      <Hero />
      <Features />
    </div>
  );
}

function Hero() {
  return (
    <div className="max-w-6xl mx-auto px-4 pt-16 pb-20 grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
      <div>
        <div className="font-display text-lg font-semibold text-gold mb-2">
          Kortmarknad
        </div>
        <h1 className="font-display text-base sm:text-2xl md:text-3xl lg:text-xl xl:text-2xl font-bold text-paper leading-tight mb-5 whitespace-nowrap">
          Din portfölj, dina byten, dina fynd.
        </h1>
        <p className="text-mute text-lg mb-8 max-w-prose">
          {LAGER_ENABLED
            ? "Kortmarknad är stället för lösa Pokémon- och sportkort — köp styckvis ur vårt lager, buda på de sällsynta korten, och bygg din egen portfölj för att hitta andra medlemmar som säljer eller byter precis det du letar efter."
            : "Kortmarknad är stället för Pokémon- och sportkort — buda på de sällsynta korten, och bygg din egen portfölj för att hitta andra medlemmar som säljer eller byter precis det du letar efter."}
        </p>
        <div className="flex flex-wrap items-center gap-3">
          <Link
            href="/konto/registrera"
            className="focus-ring rounded-md bg-gold text-ink font-semibold px-6 py-3 hover:bg-gold/90 transition-colors"
          >
            Skapa konto
          </Link>
          <Link
            href="/konto/logga-in"
            className="focus-ring rounded-md border border-line px-6 py-3 text-paper hover:border-gold transition-colors"
          >
            Logga in
          </Link>
        </div>
      </div>
      <div className="flex justify-center lg:justify-end">
        <CardFanIllustration />
      </div>
    </div>
  );
}

function Features() {
  const items = [
    ...(LAGER_ENABLED
      ? [
          {
            accent: "text-gold",
            title: "Vårt lager",
            text: "Bläddra bland lösa Pokémon- och sportkort ur egen samling, sorterade set för set. Välj vilka du vill ha — vi packar och skickar.",
          },
        ]
      : []),
    {
      accent: "text-gold",
      title: "Auktioner",
      text: "De mest värdefulla korten går på auktion. Buda mot andra medlemmar. Har du ett kort du vill sälja dyrt? Vi kan hjälpa till att ordna en exklusiv auktion bara för dig.",
    },
    {
      accent: "text-sport-pitch",
      title: "Portfölj & byten",
      text: "Logga vad du har och vad du letar efter. Andra medlemmar som säljer eller byter precis dina önskekort går att hitta direkt.",
    },
  ];

  return (
    <div className="max-w-6xl mx-auto px-4 pb-20">
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        {items.map((item) => (
          <div
            key={item.title}
            className="border border-line rounded-md p-6 bg-panel"
          >
            <div className={`font-display text-lg font-semibold mb-2 ${item.accent}`}>
              {item.title}
            </div>
            <p className="text-mute text-sm leading-relaxed">{item.text}</p>
          </div>
        ))}
      </div>
      <p className="text-center text-sm text-mute mt-6">
        Allt det här kräver ett konto —{" "}
        <Link href="/konto/registrera" className="text-gold hover:underline">
          skapa ett på under en minut
        </Link>
        .
      </p>
    </div>
  );
}

// Egen illustration i två stilar — ett Pokémon-inspirerat kort (energi-
// märke, rundad varelse-silhuett) och ett sportkorts-inspirerat kort
// (spelarsilhuett, ryggnummer, lagfärgsrand) — så det syns direkt att
// det är två olika sorters kort, utan att kopiera någon riktig
// karaktär, spelare eller logotyp.
function CardFanIllustration() {
  return (
    <svg
      viewBox="0 0 360 300"
      className="w-full max-w-sm"
      fill="none"
      aria-hidden="true"
    >
      {/* Sportkort, bakre */}
      <g transform="translate(150 155) rotate(-13)">
        <rect x="-80" y="-115" width="150" height="210" rx="14" fill="#1E2028" stroke="#33363F" />
        <rect x="-80" y="-115" width="150" height="46" rx="14" fill="#22C55E" fillOpacity="0.18" />
        <rect x="-80" y="-92" width="150" height="23" fill="#22C55E" fillOpacity="0.18" />
        <circle cx="-5" cy="-40" r="34" fill="#272A35" />
        <path
          d="M-5 -62 C 10 -62 20 -50 20 -38 C 20 -20 8 -5 -5 5 C -18 -5 -30 -20 -30 -38 C -30 -50 -20 -62 -5 -62 Z"
          fill="#98A2B3"
          fillOpacity="0.9"
        />
        <circle cx="-5" cy="-52" r="9" fill="#1E2028" />
        <rect x="-45" y="20" width="80" height="9" rx="4.5" fill="#33363F" />
        <rect x="-45" y="36" width="55" height="7" rx="3.5" fill="#33363F" />
        <text x="45" y="-70" textAnchor="middle" fontSize="26" fontWeight="700" fill="#22C55E" fillOpacity="0.85" fontFamily="sans-serif">
          9
        </text>
      </g>

      {/* Pokémon-inspirerat kort, främre */}
      <g transform="translate(205 150) rotate(11)">
        <rect x="-75" y="-115" width="150" height="210" rx="14" fill="#1E2028" stroke="#E8B33D" />
        <rect x="-80" y="-116" width="150" height="212" rx="14" fill="url(#holoShine)" opacity="0.5" />
        <rect x="-60" y="-98" width="110" height="78" rx="8" fill="#272A35" />
        <circle cx="-5" cy="-59" r="30" fill="#4FC1E9" fillOpacity="0.22" />
        <path
          d="M-5 -80 C 14 -80 26 -66 24 -50 C 22 -36 8 -30 -5 -30 C -18 -30 -32 -36 -34 -50 C -36 -66 -24 -80 -5 -80 Z"
          fill="#4FC1E9"
          fillOpacity="0.9"
        />
        <circle cx="-14" cy="-58" r="4" fill="#14151A" />
        <circle cx="4" cy="-58" r="4" fill="#14151A" />
        <circle cx="47" cy="-92" r="12" fill="#E8B33D" />
        <path d="M43 -97 L51 -97 L45 -89 L52 -89 L41 -76 L44 -88 L38 -88 Z" fill="#14151A" />
        <rect x="-45" y="30" width="90" height="9" rx="4.5" fill="#33363F" />
        <rect x="-45" y="46" width="60" height="7" rx="3.5" fill="#33363F" />
      </g>

      <defs>
        <linearGradient id="holoShine" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" stopColor="#E8B33D" stopOpacity="0" />
          <stop offset="45%" stopColor="#E8B33D" stopOpacity="0.12" />
          <stop offset="55%" stopColor="#F2C94C" stopOpacity="0.12" />
          <stop offset="100%" stopColor="#F2C94C" stopOpacity="0" />
        </linearGradient>
      </defs>
    </svg>
  );
}
