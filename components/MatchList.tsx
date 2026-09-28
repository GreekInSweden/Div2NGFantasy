"use client";

import { useEffect, useState } from "react";
import { Variant } from "@/lib/types";
import { variantLabel } from "@/lib/variant";
import MessageImagePicker from "@/components/MessageImagePicker";

interface Match {
  cardId: string;
  cardNumber: number;
  cardName: string;
  setName: string;
  variant: Variant;
  parallelTierId: string | null;
  parallelTierName: string | null;
  matchCount: number;
  sellCount: number;
  tradeCount: number;
}

interface Contact {
  memberId: string;
  label: string;
  sellable: boolean;
  tradeable: boolean;
  contactMessenger: string | null;
  contactWhatsapp: string | null;
  contactOther: string | null;
}

// wa.me vill ha ett rent internationellt nummer utan mellanslag/plus/
// bindestreck -- annars öppnas WhatsApp men chatten hittas inte.
function waMeHref(rawNumber: string, prefill: string): string {
  const digits = rawNumber.replace(/[^0-9]/g, "");
  return `https://wa.me/${digits}?text=${encodeURIComponent(prefill)}`;
}

export default function MatchList() {
  const [matches, setMatches] = useState<Match[] | null>(null);
  const [revealed, setRevealed] = useState<Record<string, Contact[] | "loading" | "none">>({});
  const [reportingMemberId, setReportingMemberId] = useState<string | null>(null);
  const [reportReason, setReportReason] = useState("");
  const [reportSubmitting, setReportSubmitting] = useState(false);
  const [reportedIds, setReportedIds] = useState<Set<string>>(new Set());
  const [messagingMemberId, setMessagingMemberId] = useState<string | null>(null);
  const [messageText, setMessageText] = useState("");
  const [messageImages, setMessageImages] = useState<{ front: string | null; back: string | null }>({
    front: null,
    back: null,
  });
  const [messageSubmitting, setMessageSubmitting] = useState(false);
  const [sentIds, setSentIds] = useState<Set<string>>(new Set());
  const [messageError, setMessageError] = useState<string | null>(null);

  async function submitMessage(m: Match, memberId: string) {
    if (!messageText.trim()) return;
    setMessageSubmitting(true);
    setMessageError(null);
    try {
      const res = await fetch("/api/member/messages", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          toMemberId: memberId,
          cardId: m.cardId,
          variant: m.variant,
          parallelTierId: m.parallelTierId,
          body: messageText,
          frontImageUrl: messageImages.front,
          backImageUrl: messageImages.back,
        }),
      });
      const data = await res.json().catch(() => ({}));
      if (res.ok) {
        setSentIds((s) => new Set(s).add(memberId));
        setMessagingMemberId(null);
        setMessageText("");
        setMessageImages({ front: null, back: null });
      } else {
        setMessageError(data.error ?? "Kunde inte skicka meddelandet.");
      }
    } catch {
      setMessageError("Kunde inte skicka meddelandet.");
    } finally {
      setMessageSubmitting(false);
    }
  }

  async function submitReport(memberId: string) {
    if (!reportReason.trim()) return;
    setReportSubmitting(true);
    try {
      const res = await fetch("/api/member/report", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ reportedMemberId: memberId, reason: reportReason }),
      });
      if (res.ok) {
        setReportedIds((s) => new Set(s).add(memberId));
        setReportingMemberId(null);
        setReportReason("");
      }
    } catch {
      // stays open so the person can retry
    } finally {
      setReportSubmitting(false);
    }
  }

  useEffect(() => {
    fetch("/api/member/matchningar")
      .then((res) => res.json())
      .then((data) => setMatches(data.matches ?? []))
      .catch(() => setMatches([]));
  }, []);

  async function handleReveal(m: Match) {
    const k = `${m.cardId}:${m.variant}:${m.parallelTierId ?? ""}`;
    setRevealed((r) => ({ ...r, [k]: "loading" }));
    try {
      const res = await fetch("/api/member/matchningar/reveal", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          cardId: m.cardId,
          variant: m.variant,
          parallelTierId: m.parallelTierId,
        }),
      });
      const data = await res.json().catch(() => ({}));
      setRevealed((r) => ({
        ...r,
        [k]: data.contacts && data.contacts.length > 0 ? data.contacts : "none",
      }));
    } catch {
      setRevealed((r) => ({ ...r, [k]: "none" }));
    }
  }

  if (matches === null) {
    return <p className="text-mute text-sm">Laddar…</p>;
  }

  if (matches.length === 0) {
    return (
      <p className="text-mute text-sm">
        Inga matchningar just nu. Lägg till kort i din önskelista på{" "}
        <a href="/konto/portfolj" className="text-gold hover:underline">
          Min portfölj
        </a>
        .
      </p>
    );
  }

  return (
    <div className="space-y-3">
      {matches.map((m) => {
        const k = `${m.cardId}:${m.variant}:${m.parallelTierId ?? ""}`;
        const state = revealed[k];
        return (
          <div key={k} className="border border-line rounded-md p-4 bg-panel">
            <div className="flex items-center justify-between gap-3 flex-wrap">
              <div>
                <div className="font-mono text-xs text-mute">
                  #{String(m.cardNumber).padStart(3, "0")} · {m.setName}
                </div>
                <div className="font-display font-semibold text-paper">
                  {m.cardName}{" "}
                  <span className="text-mute text-sm font-body">
                    ({m.parallelTierName ?? variantLabel[m.variant]})
                  </span>
                </div>
                <div className="text-xs text-gold mt-1">
                  {m.matchCount} {m.matchCount === 1 ? "medlem har" : "medlemmar har"} det
                  här kortet tillgängligt
                  {" "}
                  ({[
                    m.sellCount > 0 ? `${m.sellCount} säljer` : null,
                    m.tradeCount > 0 ? `${m.tradeCount} byter` : null,
                  ]
                    .filter(Boolean)
                    .join(", ")})
                </div>
              </div>
              {!state && (
                <button
                  onClick={() => handleReveal(m)}
                  className="focus-ring text-xs rounded-sm bg-gold text-ink font-semibold px-3 py-1.5 shrink-0"
                >
                  Visa kontakt
                </button>
              )}
            </div>

            {state === "loading" && (
              <p className="text-xs text-mute mt-3">Hämtar…</p>
            )}
            {state === "none" && (
              <p className="text-xs text-mute mt-3">
                Ingen matchning kvar just nu — kortet verkar inte längre
                finnas tillgängligt.
              </p>
            )}
            {Array.isArray(state) && (
              <div className="mt-3 space-y-2 border-t border-line pt-3">
                {state.map((c, i) => (
                  <div key={i} className="text-sm">
                    <span className="text-gold font-medium">{c.label}</span>{" "}
                    <span className="text-xs text-mute">
                      {[c.sellable ? "säljer" : null, c.tradeable ? "byter" : null]
                        .filter(Boolean)
                        .join(" / ")}
                    </span>
                    <div className="text-mute text-xs mt-0.5 space-y-0.5">
                      {c.contactWhatsapp && (
                        <div>
                          <a
                            href={waMeHref(
                              c.contactWhatsapp,
                              `Hej! Jag såg att du har ${m.cardName} (${
                                m.parallelTierName ?? variantLabel[m.variant]
                              }) i Kortmarknad.`
                            )}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="focus-ring text-gold hover:underline"
                          >
                            Öppna WhatsApp →
                          </a>
                        </div>
                      )}
                      {c.contactMessenger && <div>Messenger: {c.contactMessenger}</div>}
                      {c.contactOther && <div>{c.contactOther}</div>}
                      {!c.contactWhatsapp && !c.contactMessenger && !c.contactOther && (
                        <div>
                          Har inte fyllt i någon extern kontaktväg — skicka ett
                          meddelande här på sidan istället:
                        </div>
                      )}
                    </div>

                    <div className="mt-2 flex items-start justify-between gap-3 flex-wrap">
                      {sentIds.has(c.memberId) ? (
                        <p className="text-xs text-gold">Meddelande skickat ✓</p>
                      ) : messagingMemberId === c.memberId ? (
                        <div className="flex flex-col gap-1.5 max-w-sm w-full">
                          <textarea
                            value={messageText}
                            onChange={(e) => setMessageText(e.target.value)}
                            placeholder="Skriv ett meddelande (t.ex. 'Hej, är det här kortet fortfarande kvar?')…"
                            rows={2}
                            className="focus-ring text-xs bg-ink border border-line rounded-sm px-2 py-1.5 text-paper placeholder:text-mute"
                          />
                          <MessageImagePicker onChange={setMessageImages} />
                          {messageError && <p className="text-xs text-red-400">{messageError}</p>}
                          <div className="flex gap-2">
                            <button
                              onClick={() => submitMessage(m, c.memberId)}
                              disabled={messageSubmitting || !messageText.trim()}
                              className="focus-ring text-xs rounded-sm bg-gold text-ink font-semibold px-2 py-1 disabled:opacity-50"
                            >
                              {messageSubmitting ? "Skickar…" : "Skicka"}
                            </button>
                            <button
                              onClick={() => {
                                setMessagingMemberId(null);
                                setMessageText("");
                                setMessageImages({ front: null, back: null });
                                setMessageError(null);
                              }}
                              className="focus-ring text-xs rounded-sm border border-line px-2 py-1 text-mute hover:text-paper"
                            >
                              Avbryt
                            </button>
                          </div>
                        </div>
                      ) : (
                        <button
                          onClick={() => {
                            setMessagingMemberId(c.memberId);
                            setMessageText("");
                            setMessageImages({ front: null, back: null });
                            setMessageError(null);
                          }}
                          className="focus-ring text-xs rounded-sm bg-gold text-ink font-semibold px-3 py-1.5"
                        >
                          Skicka meddelande i Kortmarknad
                        </button>
                      )}

                      {reportedIds.has(c.memberId) ? (
                        <p className="text-xs text-mute">Anmäld — tack, vi kollar på det.</p>
                      ) : reportingMemberId === c.memberId ? (
                        <div className="flex flex-col gap-1.5 max-w-sm w-full ml-auto">
                          <textarea
                            value={reportReason}
                            onChange={(e) => setReportReason(e.target.value)}
                            placeholder="Vad hände? (t.ex. svarar inte, verkar vara bluff, oschysst byte…)"
                            rows={2}
                            className="focus-ring text-xs bg-ink border border-line rounded-sm px-2 py-1.5 text-paper placeholder:text-mute"
                          />
                          <div className="flex gap-2">
                            <button
                              onClick={() => submitReport(c.memberId)}
                              disabled={reportSubmitting || !reportReason.trim()}
                              className="focus-ring text-xs rounded-sm bg-red-400 text-ink font-semibold px-2 py-1 disabled:opacity-50"
                            >
                              {reportSubmitting ? "Skickar…" : "Skicka anmälan"}
                            </button>
                            <button
                              onClick={() => {
                                setReportingMemberId(null);
                                setReportReason("");
                              }}
                              className="focus-ring text-xs rounded-sm border border-line px-2 py-1 text-mute hover:text-paper"
                            >
                              Avbryt
                            </button>
                          </div>
                        </div>
                      ) : (
                        <button
                          onClick={() => {
                            setReportingMemberId(c.memberId);
                            setReportReason("");
                          }}
                          className="focus-ring text-[11px] text-mute hover:text-red-400 ml-auto shrink-0"
                        >
                          Anmäl medlem
                        </button>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}
