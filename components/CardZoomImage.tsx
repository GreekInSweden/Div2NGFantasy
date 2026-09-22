"use client";

import { useEffect, useState } from "react";
import { Rarity } from "@/lib/types";
import { rarityLabel } from "@/lib/rarity";
import CardImage from "@/components/CardImage";

// Drop-in replacement for CardImage in read-only listing contexts
// (portfölj, master set, mest eftertraktade, auktionsvinst) — same
// small thumbnail, but a click opens it enlarged in the middle of the
// screen so numbers/detaljer syns bättre. Not used where the image
// click already does something else (StockEditor's photo upload,
// CardGrid's/BidModal's buy/bud-flöde already shows a bigger image).
export default function CardZoomImage({
  src,
  alt,
  number,
  rarity,
  className = "",
}: {
  src: string | null;
  alt: string;
  number: number;
  rarity: Rarity;
  className?: string;
}) {
  const [open, setOpen] = useState(false);

  useEffect(() => {
    if (!open) return;
    function onKey(e: KeyboardEvent) {
      if (e.key === "Escape") setOpen(false);
    }
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open]);

  return (
    <>
      <button
        type="button"
        onClick={(e) => {
          e.stopPropagation();
          setOpen(true);
        }}
        className="focus-ring shrink-0 cursor-zoom-in"
        aria-label={`Förstora ${alt}`}
      >
        <CardImage
          src={src}
          alt={alt}
          number={number}
          rarity={rarity}
          className={className}
        />
      </button>

      {open && (
        <div
          className="fixed inset-0 z-50 bg-black/80 flex items-center justify-center p-4"
          onClick={() => setOpen(false)}
        >
          <div className="max-w-sm w-full" onClick={(e) => e.stopPropagation()}>
            <CardImage
              src={src}
              alt={alt}
              number={number}
              rarity={rarity}
              className="w-full aspect-[3/4] rounded-md border border-line"
            />
            <div className="mt-3 text-center">
              <div className="font-mono text-xs text-mute mb-1">
                #{String(number).padStart(3, "0")} · {rarityLabel[rarity]}
              </div>
              <div className="font-display text-lg font-semibold text-paper">
                {alt}
              </div>
            </div>
            <button
              onClick={() => setOpen(false)}
              className="focus-ring w-full text-center text-sm text-mute hover:text-paper mt-4"
            >
              Stäng
            </button>
          </div>
        </div>
      )}
    </>
  );
}
