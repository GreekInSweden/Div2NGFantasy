"use client";

import { useMemo, useRef, useState } from "react";
import { createBrowserSupabase } from "@/lib/supabase/browser";

interface CardOption {
  id: string;
  number: number;
  name: string;
  image_url: string | null;
}

interface PendingImage {
  key: string;
  file: File;
  previewUrl: string;
  cardId: string | null;
  autoMatched: boolean;
}

export default function BulkImageUploader({ cards }: { cards: CardOption[] }) {
  const [pending, setPending] = useState<PendingImage[]>([]);
  const [activeKey, setActiveKey] = useState<string | null>(null);
  const [assignQuery, setAssignQuery] = useState("");
  const [uploading, setUploading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState({ done: 0, total: 0 });
  const [uploadError, setUploadError] = useState<string | null>(null);
  const [isDragging, setIsDragging] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const maxCardNumber = useMemo(
    () => cards.reduce((max, c) => Math.max(max, c.number), 0),
    [cards]
  );

  function guessCardNumberFromFilename(filename: string): number | null {
    const base = filename.replace(/\.[^/.]+$/, "");
    const matches = base.match(/\d+/g);
    if (!matches || matches.length === 0) return null;
    // Prefer the last digit group — usually the meaningful counter in
    // filenames like "kort_004" or "IMG_20260904_017".
    for (let i = matches.length - 1; i >= 0; i--) {
      const n = parseInt(matches[i], 10);
      if (n >= 1 && n <= maxCardNumber) return n;
    }
    return null;
  }

  function addFiles(files: FileList | File[]) {
    const cardByNumber = new Map(cards.map((c) => [c.number, c]));
    const usedCardIds = new Set(
      pending.filter((p) => p.cardId).map((p) => p.cardId)
    );

    const newItems: PendingImage[] = Array.from(files)
      .filter((f) => f.type.startsWith("image/"))
      .map((file) => {
        const guessedNumber = guessCardNumberFromFilename(file.name);
        const matchedCard = guessedNumber ? cardByNumber.get(guessedNumber) : undefined;
        const cardId =
          matchedCard && !usedCardIds.has(matchedCard.id) ? matchedCard.id : null;
        if (cardId) usedCardIds.add(cardId);

        return {
          key: `${file.name}-${file.size}-${Math.random().toString(36).slice(2)}`,
          file,
          previewUrl: URL.createObjectURL(file),
          cardId,
          autoMatched: !!cardId,
        };
      });

    setPending((prev) => [...prev, ...newItems]);
  }

  function handleFileInputChange(e: React.ChangeEvent<HTMLInputElement>) {
    if (e.target.files) addFiles(e.target.files);
    e.target.value = "";
  }

  function handleDrop(e: React.DragEvent) {
    e.preventDefault();
    setIsDragging(false);
    if (e.dataTransfer.files) addFiles(e.dataTransfer.files);
  }

  function removeImage(key: string) {
    setPending((prev) => prev.filter((p) => p.key !== key));
    if (activeKey === key) setActiveKey(null);
  }

  function assignActiveTo(cardId: string) {
    if (!activeKey) return;
    setPending((prev) =>
      prev.map((p) =>
        p.key === activeKey ? { ...p, cardId, autoMatched: false } : p
      )
    );
    // Auto-advance to the next unassigned image so pairing goes fast.
    const currentIndex = pending.findIndex((p) => p.key === activeKey);
    const next = pending
      .slice(currentIndex + 1)
      .find((p) => !p.cardId);
    setActiveKey(next ? next.key : null);
    setAssignQuery("");
  }

  const assignedCount = pending.filter((p) => p.cardId).length;
  const cardNameById = useMemo(
    () => new Map(cards.map((c) => [c.id, c])),
    [cards]
  );

  const filteredCardsForAssign = useMemo(() => {
    const q = assignQuery.trim().toLowerCase();
    const base = q
      ? cards.filter(
          (c) =>
            c.name.toLowerCase().includes(q) ||
            String(c.number).padStart(3, "0").includes(q)
        )
      : cards;
    return base.slice(0, 40);
  }, [cards, assignQuery]);

  async function handleUploadAll() {
    const toUpload = pending.filter((p) => p.cardId);
    if (toUpload.length === 0) return;
    setUploading(true);
    setUploadError(null);
    setUploadProgress({ done: 0, total: toUpload.length });

    const supabase = createBrowserSupabase();
    let done = 0;
    let firstError: string | null = null;

    for (const item of toUpload) {
      const ext = item.file.name.split(".").pop() || "jpg";
      const path = `${item.cardId}.${ext}`;

      const { error: uploadErr } = await supabase.storage
        .from("card-images")
        .upload(path, item.file, { upsert: true, cacheControl: "3600" });

      if (uploadErr) {
        firstError = uploadErr.message;
        break;
      }

      const { data: publicUrlData } = supabase.storage
        .from("card-images")
        .getPublicUrl(path);
      const freshUrl = `${publicUrlData.publicUrl}?t=${Date.now()}`;

      const { error: updateErr } = await supabase
        .from("cards")
        .update({ image_url: freshUrl })
        .eq("id", item.cardId!);

      if (updateErr) {
        firstError = updateErr.message;
        break;
      }

      done += 1;
      setUploadProgress({ done, total: toUpload.length });
    }

    setUploading(false);
    if (firstError) {
      setUploadError(
        `Fel efter ${done} av ${toUpload.length} bilder: ${firstError}`
      );
      return;
    }
    // Remove successfully uploaded images from the pending list.
    setPending((prev) => prev.filter((p) => !p.cardId));
  }

  return (
    <div>
      <div
        onDragOver={(e) => {
          e.preventDefault();
          setIsDragging(true);
        }}
        onDragLeave={() => setIsDragging(false)}
        onDrop={handleDrop}
        onClick={() => fileInputRef.current?.click()}
        className={`cursor-pointer border-2 border-dashed rounded-md p-10 text-center mb-6 transition-colors ${
          isDragging ? "border-gold bg-gold/5" : "border-line hover:border-mute"
        }`}
      >
        <p className="text-paper font-medium mb-1">
          Släpp bilder här, eller klicka för att välja filer
        </p>
        <p className="text-sm text-mute">Ingen gräns på antal — ta alla på en gång.</p>
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          multiple
          className="hidden"
          onChange={handleFileInputChange}
        />
      </div>

      {pending.length > 0 && (
        <>
          <div className="sticky top-0 z-10 bg-ink py-3 -mx-4 px-4 mb-4 border-b border-line flex items-center justify-between gap-3">
            <span className="text-sm text-mute">
              {assignedCount} av {pending.length} bilder tilldelade ett kort
            </span>
            <button
              onClick={handleUploadAll}
              disabled={assignedCount === 0 || uploading}
              className="focus-ring rounded-sm bg-gold text-ink font-semibold px-4 py-2 text-sm disabled:opacity-40"
            >
              {uploading
                ? `Laddar upp ${uploadProgress.done}/${uploadProgress.total}…`
                : `Ladda upp ${assignedCount} bilder`}
            </button>
          </div>

          {uploadError && (
            <p className="text-sm text-red-400 mb-4">{uploadError}</p>
          )}

          {activeKey && (
            <div className="border border-gold rounded-md p-4 mb-6 bg-gold/5">
              <p className="text-sm text-paper mb-2">
                Vilket kort hör den markerade bilden till?
              </p>
              <input
                type="text"
                autoFocus
                placeholder="Sök kortnamn eller nummer…"
                value={assignQuery}
                onChange={(e) => setAssignQuery(e.target.value)}
                className="focus-ring w-full bg-ink border border-line rounded-sm px-3 py-2 text-paper text-sm mb-3"
              />
              <div className="flex flex-wrap gap-2 max-h-40 overflow-y-auto">
                {filteredCardsForAssign.map((c) => (
                  <button
                    key={c.id}
                    onClick={() => assignActiveTo(c.id)}
                    className="focus-ring text-left border border-line rounded-sm px-3 py-1.5 text-sm text-paper hover:border-gold hover:bg-panelLight"
                  >
                    <span className="font-mono text-mute mr-1">
                      #{String(c.number).padStart(3, "0")}
                    </span>
                    {c.name}
                  </button>
                ))}
              </div>
              <button
                onClick={() => setActiveKey(null)}
                className="focus-ring text-xs text-mute hover:text-paper mt-3"
              >
                Avbryt
              </button>
            </div>
          )}

          <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-3">
            {pending.map((item) => {
              const matchedCard = item.cardId
                ? cardNameById.get(item.cardId)
                : null;
              return (
                <div
                  key={item.key}
                  onClick={() => {
                    setActiveKey(item.key);
                    setAssignQuery("");
                  }}
                  className={`relative cursor-pointer rounded-sm overflow-hidden border-2 ${
                    activeKey === item.key
                      ? "border-gold"
                      : matchedCard
                      ? item.autoMatched
                        ? "border-green-500/60"
                        : "border-blue-400/60"
                      : "border-red-500/60 border-dashed"
                  }`}
                >
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img
                    src={item.previewUrl}
                    alt={item.file.name}
                    className="w-full aspect-[3/4] object-cover"
                  />
                  <div className="absolute inset-x-0 bottom-0 bg-black/80 px-1.5 py-1">
                    <p className="text-[10px] text-paper truncate">
                      {matchedCard
                        ? `#${String(matchedCard.number).padStart(3, "0")} ${matchedCard.name}`
                        : "Ej tilldelad"}
                    </p>
                  </div>
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      removeImage(item.key);
                    }}
                    className="focus-ring absolute top-1 right-1 w-5 h-5 rounded-full bg-black/70 text-paper text-xs flex items-center justify-center hover:bg-black"
                    aria-label="Ta bort bild"
                  >
                    ✕
                  </button>
                </div>
              );
            })}
          </div>
        </>
      )}
    </div>
  );
}
