"use client";

import { useEffect, useState } from "react";
import { Variant } from "@/lib/types";
import { variantLabel } from "@/lib/variant";
import MessageImagePicker from "@/components/MessageImagePicker";

interface Message {
  id: string;
  fromMemberId: string;
  toMemberId: string;
  outgoing: boolean;
  otherMemberLabel: string;
  cardId: string | null;
  cardNumber: number | null;
  cardName: string | null;
  cardImageUrl: string | null;
  variant: Variant | null;
  parallelTierName: string | null;
  body: string;
  frontImageUrl: string | null;
  backImageUrl: string | null;
  createdAt: string;
  wasUnread: boolean;
}

function formatWhen(iso: string): string {
  const d = new Date(iso);
  return d.toLocaleString("sv-SE", {
    day: "numeric",
    month: "short",
    hour: "2-digit",
    minute: "2-digit",
  });
}

export default function MessageInbox() {
  const [messages, setMessages] = useState<Message[] | null>(null);
  const [replyOpenId, setReplyOpenId] = useState<string | null>(null);
  const [replyText, setReplyText] = useState("");
  const [replyImages, setReplyImages] = useState<{ front: string | null; back: string | null }>({
    front: null,
    back: null,
  });
  const [replySubmitting, setReplySubmitting] = useState(false);
  const [replyError, setReplyError] = useState<string | null>(null);
  const [sentReplyFor, setSentReplyFor] = useState<Set<string>>(new Set());
  const [deletingId, setDeletingId] = useState<string | null>(null);
  const [deleteError, setDeleteError] = useState<string | null>(null);

  function load() {
    fetch("/api/member/messages")
      .then((res) => res.json())
      .then((data) => setMessages(data.messages ?? []))
      .catch(() => setMessages([]));
  }

  useEffect(() => {
    load();
  }, []);

  async function submitReply(m: Message) {
    if (!replyText.trim() || !m.cardId || !m.variant) return;
    setReplySubmitting(true);
    setReplyError(null);
    try {
      const res = await fetch("/api/member/messages", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          toMemberId: m.outgoing ? m.toMemberId : m.fromMemberId,
          cardId: m.cardId,
          variant: m.variant,
          parallelTierId: null,
          body: replyText,
          frontImageUrl: replyImages.front,
          backImageUrl: replyImages.back,
        }),
      });
      const data = await res.json().catch(() => ({}));
      if (res.ok) {
        setSentReplyFor((s) => new Set(s).add(m.id));
        setReplyOpenId(null);
        setReplyText("");
        setReplyImages({ front: null, back: null });
        load();
      } else {
        setReplyError(data.error ?? "Kunde inte skicka svaret.");
      }
    } catch {
      setReplyError("Kunde inte skicka svaret.");
    } finally {
      setReplySubmitting(false);
    }
  }

  // Optimistisk radering -- meddelandet försvinner ur listan direkt när
  // man klickar, istället för att vänta på svar från servern (det
  // väntandet är precis det som gjorde att det kändes som knappen inte
  // reagerade och man klickade flera gånger). Misslyckas anropet mot
  // förmodan läggs meddelandet tillbaka på samma plats igen.
  async function deleteMessage(id: string) {
    setDeleteError(null);
    let removedAt = -1;
    let removedMessage: Message | null = null;
    setMessages((prev) => {
      const list = prev ?? [];
      removedAt = list.findIndex((m) => m.id === id);
      removedMessage = removedAt >= 0 ? list[removedAt] : null;
      return list.filter((m) => m.id !== id);
    });

    setDeletingId(id);
    try {
      const res = await fetch("/api/member/messages", {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ id }),
      });
      if (!res.ok && removedMessage) {
        const restore = removedMessage;
        const atIndex = removedAt;
        setMessages((prev) => {
          const list = [...(prev ?? [])];
          list.splice(Math.min(atIndex, list.length), 0, restore);
          return list;
        });
        setDeleteError("Kunde inte radera meddelandet. Försök igen.");
      }
    } catch {
      if (removedMessage) {
        const restore = removedMessage;
        const atIndex = removedAt;
        setMessages((prev) => {
          const list = [...(prev ?? [])];
          list.splice(Math.min(atIndex, list.length), 0, restore);
          return list;
        });
      }
      setDeleteError("Kunde inte radera meddelandet. Försök igen.");
    } finally {
      setDeletingId(null);
    }
  }

  if (messages === null) {
    return <p className="text-mute text-sm">Laddar…</p>;
  }

  if (messages.length === 0) {
    return (
      <p className="text-mute text-sm">
        Inga meddelanden än. De dyker upp här när du eller någon du matchat
        med skickar ett meddelande om ett kort — se{" "}
        <a href="/konto/matchningar" className="text-gold hover:underline">
          Mina matchningar
        </a>
        .
      </p>
    );
  }

  return (
    <div className="space-y-3">
      <p className="text-xs text-mute">
        Det här är inte en chatt i realtid — meddelanden dyker upp nästa
        gång du eller den andra laddar om sidan, inte direkt.
      </p>
      {deleteError && <p className="text-xs text-red-400">{deleteError}</p>}
      {messages.map((m) => (
        <div
          key={m.id}
          className={`border rounded-md p-3 bg-panel ${
            m.wasUnread ? "border-gold" : "border-line"
          }`}
        >
          <div className="flex items-center justify-between gap-3 flex-wrap mb-1.5">
            <div className="text-xs text-mute">
              {m.outgoing ? "Till" : "Från"}{" "}
              <span className="text-paper">{m.otherMemberLabel}</span>
              {m.cardName && (
                <>
                  {" "}
                  ·{" "}
                  <span className="text-gold">
                    {m.cardName}
                    {m.variant && (
                      <> ({m.parallelTierName ?? variantLabel[m.variant]})</>
                    )}
                  </span>
                </>
              )}
            </div>
            <div className="flex items-center gap-2 shrink-0">
              <span className="text-[10px] text-mute font-mono">
                {formatWhen(m.createdAt)}
              </span>
              <button
                onClick={() => deleteMessage(m.id)}
                title="Radera meddelandet (bara ur din egen brevlåda)"
                className="focus-ring text-[11px] text-mute hover:text-red-400"
              >
                Radera
              </button>
            </div>
          </div>
          <p className="text-sm text-paper whitespace-pre-wrap">{m.body}</p>
          {(m.frontImageUrl || m.backImageUrl) && (
            <div className="flex gap-2 mt-2">
              {m.frontImageUrl && (
                <a href={m.frontImageUrl} target="_blank" rel="noopener noreferrer">
                  <img
                    src={m.frontImageUrl}
                    alt="Framsida"
                    className="w-14 h-20 object-cover rounded-sm border border-line"
                  />
                </a>
              )}
              {m.backImageUrl && (
                <a href={m.backImageUrl} target="_blank" rel="noopener noreferrer">
                  <img
                    src={m.backImageUrl}
                    alt="Baksida"
                    className="w-14 h-20 object-cover rounded-sm border border-line"
                  />
                </a>
              )}
            </div>
          )}

          {m.cardId && m.variant && (
            <div className="mt-2">
              {sentReplyFor.has(m.id) ? (
                <p className="text-xs text-gold">Svar skickat ✓</p>
              ) : replyOpenId === m.id ? (
                <div className="flex flex-col gap-1.5 max-w-sm">
                  <textarea
                    value={replyText}
                    onChange={(e) => setReplyText(e.target.value)}
                    placeholder="Skriv ett svar…"
                    rows={2}
                    className="focus-ring text-xs bg-ink border border-line rounded-sm px-2 py-1.5 text-paper placeholder:text-mute"
                  />
                  <MessageImagePicker onChange={setReplyImages} />
                  {replyError && <p className="text-xs text-red-400">{replyError}</p>}
                  <div className="flex gap-2">
                    <button
                      onClick={() => submitReply(m)}
                      disabled={replySubmitting || !replyText.trim()}
                      className="focus-ring text-xs rounded-sm bg-gold text-ink font-semibold px-2 py-1 disabled:opacity-50"
                    >
                      {replySubmitting ? "Skickar…" : "Skicka svar"}
                    </button>
                    <button
                      onClick={() => {
                        setReplyOpenId(null);
                        setReplyText("");
                        setReplyImages({ front: null, back: null });
                        setReplyError(null);
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
                    setReplyOpenId(m.id);
                    setReplyText("");
                    setReplyImages({ front: null, back: null });
                    setReplyError(null);
                  }}
                  className="focus-ring text-xs text-mute hover:text-gold"
                >
                  Svara
                </button>
              )}
            </div>
          )}
        </div>
      ))}
    </div>
  );
}
