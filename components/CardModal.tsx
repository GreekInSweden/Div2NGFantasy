"use client";

import { useState, useEffect } from "react";
import { CardRow, Variant } from "@/lib/types";
import { rarityLabel } from "@/lib/rarity";
import { variantLabel } from "@/lib/variant";
import { useCart } from "@/lib/CartContext";
import CardImage from "@/components/CardImage";

export default function CardModal({
  card,
  setSlug,
  setName,
  onClose,
}: {
  card: CardRow;
  setSlug: string;
  setName: string;
  onClose: () => void;
}) {
  const { addItem } = useCart();
  const available = card.variants.filter((v) => v.stock > 0);
  const [selectedVariant, setSelectedVariant] = useState<Variant | null>(
    available[0]?.variant ?? null
  );
  const [quantity, setQuantity] = useState(1);
  const [justAdded, setJustAdded] = useState(false);

  useEffect(() => {
    function onKey(e: KeyboardEvent) {
      if (e.key === "Escape") onClose();
    }
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  const currentVariant = available.find((v) => v.variant === selectedVariant);
  const maxQty = currentVariant?.stock ?? 1;

  function handleAdd() {
    if (!currentVariant) return;
    addItem({
      variantId: currentVariant.id,
      cardId: card.id,
      cardNumber: card.number,
      cardName: card.name,
      variant: currentVariant.variant,
      unitPriceSek: currentVariant.price_sek,
      quantity,
      setSlug,
      setName,
    });
    setJustAdded(true);
    setTimeout(() => {
      setJustAdded(false);
      onClose();
    }, 700);
  }

  return (
    <div
      className="fixed inset-0 z-40 bg-black/70 flex items-center justify-center p-4"
      onClick={onClose}
    >
      <div
        className="bg-panel border border-line rounded-md max-w-sm w-full overflow-hidden"
        onClick={(e) => e.stopPropagation()}
      >
        <CardImage
          src={card.image_url}
          alt={card.name}
          number={card.number}
          rarity={card.rarity}
          className="w-full aspect-[3/4]"
        />
        <div className="p-6">
        <div className="font-mono text-xs text-mute mb-1">
          #{String(card.number).padStart(3, "0")} · {rarityLabel[card.rarity]}
        </div>
        <h2 className="font-display text-2xl font-bold text-paper mb-4">
          {card.name}
        </h2>

        {available.length === 0 ? (
          <p className="text-mute">Slut i lager just nu.</p>
        ) : (
          <>
            <div className="mb-4">
              <div className="text-sm text-mute mb-2">Variant</div>
              <div className="flex gap-2">
                {available.map((v) => (
                  <button
                    key={v.variant}
                    onClick={() => {
                      setSelectedVariant(v.variant);
                      setQuantity(1);
                    }}
                    className={`focus-ring flex-1 rounded-sm border px-3 py-2 text-sm font-medium transition-colors ${
                      selectedVariant === v.variant
                        ? "border-gold bg-gold/10 text-gold"
                        : "border-line text-paper hover:border-mute"
                    }`}
                  >
                    {variantLabel[v.variant]}
                    <span className="block text-xs font-mono text-mute mt-0.5">
                      {v.price_sek} kr · {v.stock} st
                    </span>
                  </button>
                ))}
              </div>
            </div>

            <div className="mb-6">
              <div className="text-sm text-mute mb-2">Antal</div>
              <div className="flex items-center gap-3">
                <button
                  onClick={() => setQuantity((q) => Math.max(1, q - 1))}
                  className="focus-ring w-9 h-9 rounded-sm border border-line text-paper hover:border-gold"
                  aria-label="Minska antal"
                >
                  −
                </button>
                <span className="font-mono text-lg w-8 text-center text-paper">
                  {quantity}
                </span>
                <button
                  onClick={() => setQuantity((q) => Math.min(maxQty, q + 1))}
                  className="focus-ring w-9 h-9 rounded-sm border border-line text-paper hover:border-gold"
                  aria-label="Öka antal"
                >
                  +
                </button>
                <span className="text-xs text-mute font-mono ml-1">
                  max {maxQty} st
                </span>
              </div>
            </div>

            <button
              onClick={handleAdd}
              className="focus-ring w-full rounded-sm bg-gold text-ink font-semibold py-3 hover:bg-gold/90 transition-colors"
            >
              {justAdded
                ? "Tillagd i varukorgen ✓"
                : `Lägg till — ${(currentVariant?.price_sek ?? 0) * quantity} kr`}
            </button>
          </>
        )}

        <button
          onClick={onClose}
          className="focus-ring w-full text-center text-sm text-mute hover:text-paper mt-3"
        >
          Stäng
        </button>
        </div>
      </div>
    </div>
  );
}
