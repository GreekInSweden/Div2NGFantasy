"use client";

import { useEffect, useState } from "react";

function formatTimeLeft(diffMs: number): string {
  if (diffMs <= 0) return "Avslutad";
  const totalSeconds = Math.floor(diffMs / 1000);
  const days = Math.floor(totalSeconds / 86400);
  const hours = Math.floor((totalSeconds % 86400) / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = totalSeconds % 60;

  if (days > 0) return `${days}d ${hours}h kvar`;
  if (hours > 0) return `${hours}h ${minutes}m kvar`;
  if (minutes > 0) return `${minutes}m ${seconds}s kvar`;
  return `${seconds}s kvar`;
}

// A real, second-by-second ticking countdown (not just re-rendered on
// poll), so bidders can actually see time running out — and it turns red
// and starts pulsing in the last 3 minutes, the same window a bid would
// auto-extend the auction in.
export default function CountdownTimer({
  endsAt,
  size = "sm",
}: {
  endsAt: string;
  size?: "sm" | "lg";
}) {
  const [now, setNow] = useState<number | null>(null);

  useEffect(() => {
    setNow(Date.now());
    const interval = setInterval(() => setNow(Date.now()), 1000);
    return () => clearInterval(interval);
  }, []);

  // Avoid a server/client mismatch on first paint — render nothing until
  // mounted, then tick.
  if (now === null) {
    return (
      <span
        className={size === "lg" ? "font-mono text-lg text-mute" : "font-mono text-xs text-mute"}
      >
        …
      </span>
    );
  }

  const diffMs = new Date(endsAt).getTime() - now;
  const label = formatTimeLeft(diffMs);
  const isUrgent = diffMs > 0 && diffMs <= 3 * 60 * 1000;
  const isOver = diffMs <= 0;

  const base = size === "lg" ? "font-mono text-lg font-semibold" : "font-mono text-xs";
  const color = isOver
    ? "text-mute"
    : isUrgent
    ? "text-red-400 animate-pulse"
    : size === "lg"
    ? "text-gold"
    : "text-mute";

  return <span className={`${base} ${color}`}>{label}</span>;
}
