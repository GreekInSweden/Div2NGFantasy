import { Rarity } from "@/lib/types";

const placeholderTint: Record<Rarity, string> = {
  common: "bg-rare-common/20",
  rare: "bg-rare-tier/20",
  double_rare: "bg-rare-double/20",
  illustration_rare: "bg-rare-illustration/20",
  ultra_rare: "bg-rare-ultra/20",
  special_illustration_rare: "bg-rare-special/20",
  mega_hyper_rare: "bg-rare-gold/20",
  promo: "bg-rare-promo/20",
  base: "bg-rare-common/20",
  insert: "bg-rare-illustration/20",
};

export default function CardImage({
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
  if (src) {
    // eslint-disable-next-line @next/next/no-img-element
    return (
      <img
        src={src}
        alt={alt}
        className={`object-cover ${className}`}
        loading="lazy"
      />
    );
  }

  return (
    <div
      className={`flex items-center justify-center ${placeholderTint[rarity]} ${className}`}
    >
      <span className="font-mono text-xs text-mute">
        #{String(number).padStart(3, "0")}
      </span>
    </div>
  );
}
