"use client";

import { useEffect, useState } from "react";
import { Variant } from "@/lib/types";
import { variantLabel } from "@/lib/variant";

interface Match {
  cardId: string;
  cardNumber: number;
  cardName: string;
  setName: string;
  variant: Variant;
  matchCount: number;
  sellCount: number;
  tradeCount: number;
}

interface Contact {
  memberId: string;
  memberNumber: number;
  name: string;
  sellable: boolean;
  tradeable: boolean;
  contactMessenger: string | null;
  contactWhatsapp: string | null;
  contactOther: string | null;
}

export default function MatchList() {
  const [matches, setMatches] = useState<Match[] | null>(null);
  const [revealed, setRevealed] = useState<Record<string, Contact[] | "loading" | "none">>({});
  const [reportingMemberId, setReportingMemberId] = useState<string | null>(null);
  const [reportReason, setReportReason] = useState("");
  const [reportSubmitting, setReportSubmitting] = useState(false);
  const [reportedIds, setReportedIds] = useState<Set<string>>(new Set());

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
    const k = `${m.cardId}:${m.variant}`;
    setRevealed((r) => ({ ...r, [k]: "loading" }));
    try {
      const res = await fetch("/api/member/matchningar/reveal", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ cardId: m.cardId, variant: m.variant }),
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
        const k = `${m.cardId}:${m.variant}`;
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
                    ({variantLabel[m.variant]})
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
                De som har kortet har inte fyllt i någon kontaktväg än.
              </p>
            )}
            {Array.isArray(state) && (
              <div className="mt-3 space-y-2 border-t border-line pt-3">
                {state.map((c, i) => (
                  <div key={i} className="text-sm">
                    <span className="text-gold font-medium">
                      Medlem #{c.memberNumber} ({c.name})
                    </span>{" "}
                    <span className="text-xs text-mute">
                      {[c.sellable ? "säljer" : null, c.tradeable ? "byter" : null]
                        .filter(Boolean)
                        .join(" / ")}
                    </span>
                    <div className="text-mute text-xs mt-0.5 space-y-0.5">
                      {c.contactMessenger && <div>Messenger: {c.contactMessenger}</div>}
                      {c.contactWhatsapp && <div>WhatsApp: {c.contactWhatsapp}</div>}
                      {c.contactOther && <div>{c.contactOther}</div>}
                    </div>

                    {reportedIds.has(c.memberId) ? (
                      <p className="text-xs text-mute mt-1">Anmäld — tack, vi kollar på det.</p>
                    ) : reportingMemberId === c.memberId ? (
                      <div className="mt-2 flex flex-col gap-1.5 max-w-sm">
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
                        className="focus-ring text-xs text-mute hover:text-red-400 mt-1"
                      >
                        Anmäl medlem
                      </button>
                    )}
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
