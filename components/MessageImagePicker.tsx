"use client";

import { useState } from "react";

// Låter en medlem bifoga framsida + baksida av det fysiska kortet till
// ett meddelande, så mottagaren ser exakt vilket exemplar det gäller
// innan ett köp/byte. Laddar upp direkt vid filval (inte vid skicka) så
// man ser en förhandsvisning och ett ev. fel innan man skriver klart
// meddelandet.
export default function MessageImagePicker({
  onChange,
}: {
  onChange: (urls: { front: string | null; back: string | null }) => void;
}) {
  const [frontUrl, setFrontUrl] = useState<string | null>(null);
  const [backUrl, setBackUrl] = useState<string | null>(null);
  const [uploading, setUploading] = useState<"front" | "back" | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function upload(side: "front" | "back", file: File) {
    setUploading(side);
    setError(null);
    try {
      const formData = new FormData();
      formData.append("file", file);
      const res = await fetch("/api/member/messages/upload-image", {
        method: "POST",
        body: formData,
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        setError(data.error ?? "Kunde inte ladda upp bilden.");
        return;
      }
      if (side === "front") {
        setFrontUrl(data.url);
        onChange({ front: data.url, back: backUrl });
      } else {
        setBackUrl(data.url);
        onChange({ front: frontUrl, back: data.url });
      }
    } catch {
      setError("Kunde inte ladda upp bilden.");
    } finally {
      setUploading(null);
    }
  }

  function remove(side: "front" | "back") {
    if (side === "front") {
      setFrontUrl(null);
      onChange({ front: null, back: backUrl });
    } else {
      setBackUrl(null);
      onChange({ front: frontUrl, back: null });
    }
  }

  function Slot({ side, label, url }: { side: "front" | "back"; label: string; url: string | null }) {
    return (
      <label className="shrink-0 cursor-pointer group relative">
        {url ? (
          <img src={url} alt={label} className="w-14 h-20 object-cover rounded-sm border border-line" />
        ) : (
          <div className="w-14 h-20 rounded-sm border border-dashed border-line flex items-center justify-center text-mute text-[10px] text-center px-1">
            {uploading === side ? "…" : `+ ${label}`}
          </div>
        )}
        {url && (
          <button
            type="button"
            onClick={(e) => {
              e.preventDefault();
              remove(side);
            }}
            className="absolute -top-1.5 -right-1.5 w-4 h-4 rounded-full bg-ink border border-line text-[10px] text-mute hover:text-red-400 flex items-center justify-center"
            title="Ta bort"
          >
            ×
          </button>
        )}
        <input
          type="file"
          accept="image/*"
          className="hidden"
          disabled={uploading !== null}
          onChange={(e) => {
            const file = e.target.files?.[0];
            if (file) upload(side, file);
            e.target.value = "";
          }}
        />
      </label>
    );
  }

  return (
    <div>
      <div className="flex items-center gap-2">
        <Slot side="front" label="Framsida" url={frontUrl} />
        <Slot side="back" label="Baksida" url={backUrl} />
      </div>
      {error && <p className="text-xs text-red-400 mt-1">{error}</p>}
    </div>
  );
}
