"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Member } from "@/lib/types";

// Statisk förklaringssida -- länkad från headern (synlig även för
// utloggade besökare, precis som "Mest eftertraktade"). "use client" +
// en /api/member/me-koll bara för att kunna dölja "Skapa konto"/"Logga
// in"-raden när man redan är inloggad -- annars var den uppmaningen kvar
// även för inloggade medlemmar, vilket inte gör någon nytta.
//
// OBS: nämner medvetet INTE att bläddra/köpa ur "Vårt lager" som ett
// steg -- den funktionen är tillfälligt pausad (se lib/siteConfig.ts,
// LAGER_ENABLED). Lägg till det steget igen den dagen lagret slås på.

const steps = [
  {
    number: 1,
    title: "Lägg till kort i din portfölj",
    text: "Logga in och markera vilka kort du har och vilka du letar efter -- per set, kort och variant/parallel. Du väljer själv om det du har är till salu, byte, eller bara för din egen samlingsöversikt.",
  },
  {
    number: 2,
    title: "Vi matchar dig automatiskt",
    text: "Så fort någon annan medlem har ett kort du vill ha (eller vill ha ett du säljer/byter), dyker det upp under \"Mina matchningar\" -- ingen manuell sökning behövs.",
  },
  {
    number: 3,
    title: "Ta kontakt",
    text: "Skicka ett meddelande direkt här på sidan (går alltid, oavsett om personen fyllt i externa kontaktuppgifter), eller hör av dig via WhatsApp/Messenger om medlemmen har lagt in det.",
  },
  {
    number: 4,
    title: "Byt eller sälj er emellan",
    text: "Kom överens om pris eller byte direkt med den andra medlemmen. Kortmarknad är mötesplatsen -- själva affären gör ni upp om sinsemellan.",
  },
  {
    number: 5,
    title: "Auktioner för de riktigt sällsynta korten",
    text: "De mest värdefulla korten går istället på auktion, där medlemmar kan buda mot varandra. Har du ett kort du tror är auktionsvärt? Hör av dig så kan vi ordna en exklusiv auktion.",
  },
];

export default function SaFungarDetPage() {
  const [member, setMember] = useState<Member | null | undefined>(undefined);

  useEffect(() => {
    fetch("/api/member/me")
      .then((res) => res.json())
      .then((data) => setMember(data.member ?? null))
      .catch(() => setMember(null));
  }, []);

  return (
    <div className="max-w-3xl mx-auto px-4 py-14">
      <h1 className="font-display text-4xl font-bold text-paper mb-3">
        Så funkar det
      </h1>
      <p className="text-mute mb-12 max-w-prose">
        Kortmarknad är en mötesplats för dig som samlar på Pokémon- och
        sportkort -- så här går det till, steg för steg.
      </p>

      <div className="space-y-6">
        {steps.map((s) => (
          <div
            key={s.number}
            className="flex gap-4 border border-line rounded-md p-5 bg-panel"
          >
            <div className="shrink-0 w-9 h-9 rounded-full bg-gold text-ink font-display font-bold flex items-center justify-center">
              {s.number}
            </div>
            <div>
              <div className="font-display text-lg font-semibold text-paper mb-1">
                {s.title}
              </div>
              <p className="text-mute text-sm leading-relaxed">{s.text}</p>
            </div>
          </div>
        ))}
      </div>

      {member === null && (
        <div className="mt-12 border-t border-line pt-8 flex flex-wrap items-center gap-4">
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
      )}
    </div>
  );
}
