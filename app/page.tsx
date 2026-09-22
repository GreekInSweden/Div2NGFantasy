import Link from "next/link";
import { redirect } from "next/navigation";
import { getCurrentMember } from "@/lib/currentMember";

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
        <h1 className="font-display text-4xl sm:text-5xl font-bold text-paper leading-tight mb-5">
          Din portfölj, dina byten,
          <br />
          dina fynd.
        </h1>
        <p className="text-mute text-lg mb-8 max-w-prose">
          Kortlagret är stället för lösa Pokémon- och sportkort — köp
          styckvis ur vårt lager, buda på de sällsynta korten, och bygg
          din egen portfölj för att hitta andra medlemmar som säljer
          eller byter precis det du letar efter.
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
          <Link
            href="/lager"
            className="focus-ring text-sm text-mute hover:text-paper px-3 py-3"
          >
            Bara bläddra i lagret →
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
    {
      href: "/lager",
      accent: "text-gold",
      title: "Vårt lager",
      text: "Bläddra bland lösa Pokémon- och sportkort ur egen samling, sorterade set för set. Välj vilka du vill ha — vi packar och skickar.",
    },
    {
      href: "/auktioner",
      accent: "text-gold",
      title: "Auktioner",
      text: "De mest värdefulla korten går på auktion. Buda mot andra medlemmar — vinner du dyker en betalsida upp automatiskt.",
    },
    {
      href: "/konto/portfolj",
      accent: "text-sport-pitch",
      title: "Portfölj & byten",
      text: "Logga vad du har och vad du letar efter. Andra medlemmar som säljer eller byter precis dina önskekort går att hitta direkt.",
    },
  ];

  return (
    <div className="max-w-6xl mx-auto px-4 pb-20">
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        {items.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            className="focus-ring group border border-line rounded-md p-6 bg-panel hover:border-gold/60 transition-colors"
          >
            <div className={`font-display text-lg font-semibold mb-2 ${item.accent}`}>
              {item.title}
            </div>
            <p className="text-mute text-sm leading-relaxed">{item.text}</p>
          </Link>
        ))}
      </div>
    </div>
  );
}

// Enkel, egen illustration — tre överlappande kort i sajtens egna
// färger, ingen extern bildfil att hålla reda på eller som kan sluta
// fungera.
function CardFanIllustration() {
  return (
    <svg
      viewBox="0 0 340 300"
      className="w-full max-w-sm"
      fill="none"
      aria-hidden="true"
    >
      <g transform="translate(170 160)">
        <g transform="rotate(-16)">
          <rect
            x="-85"
            y="-115"
            width="150"
            height="210"
            rx="14"
            fill="#1E2028"
            stroke="#33363F"
          />
          <rect x="-70" y="-98" width="120" height="80" rx="8" fill="#272A35" />
          <rect x="-70" y="8" width="80" height="10" rx="5" fill="#33363F" />
          <rect x="-70" y="28" width="100" height="8" rx="4" fill="#33363F" />
        </g>
        <g transform="rotate(4)">
          <rect
            x="-75"
            y="-120"
            width="150"
            height="210"
            rx="14"
            fill="#1E2028"
            stroke="#4FC1E9"
            strokeOpacity="0.5"
          />
          <rect x="-60" y="-103" width="120" height="80" rx="8" fill="#272A35" />
          <rect x="-60" y="3" width="80" height="10" rx="5" fill="#33363F" />
          <rect x="-60" y="23" width="100" height="8" rx="4" fill="#33363F" />
        </g>
        <g transform="rotate(20)">
          <rect
            x="-65"
            y="-110"
            width="150"
            height="210"
            rx="14"
            fill="#1E2028"
            stroke="#E8B33D"
          />
          <rect x="-50" y="-93" width="120" height="80" rx="8" fill="#272A35" />
          <rect x="-50" y="13" width="80" height="10" rx="5" fill="#E8B33D" fillOpacity="0.6" />
          <rect x="-50" y="33" width="100" height="8" rx="4" fill="#33363F" />
          <circle cx="55" cy="-70" r="13" fill="#E8B33D" fillOpacity="0.85" />
        </g>
      </g>
    </svg>
  );
}
