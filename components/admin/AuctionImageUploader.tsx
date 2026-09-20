"use client";

import { useState } from "react";
import { createBrowserSupabase } from "@/lib/supabase/browser";

export default function AuctionImageUploader({
  auctionId,
  field,
  label,
  initialUrl,
}: {
  auctionId: string;
  field: "front_image_url" | "back_image_url";
  label: string;
  initialUrl: string | null;
}) {
  const [url, setUrl] = useState<string | null>(initialUrl);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleUpload(file: File) {
    setError(null);
    setUploading(true);
    const supabase = createBrowserSupabase();

    const ext = file.name.split(".").pop() || "jpg";
    const side = field === "front_image_url" ? "front" : "back";
    const path = `auction-${side}-${auctionId}.${ext}`;

    const { error: uploadErr } = await supabase.storage
      .from("card-images")
      .upload(path, file, { upsert: true, cacheControl: "3600" });

    if (uploadErr) {
      setError(`Kunde inte ladda upp: ${uploadErr.message}`);
      setUploading(false);
      return;
    }

    const { data: publicUrlData } = supabase.storage
      .from("card-images")
      .getPublicUrl(path);
    const freshUrl = `${publicUrlData.publicUrl}?t=${Date.now()}`;

    const { error: updateErr } = await supabase
      .from("auctions")
      .update({ [field]: freshUrl })
      .eq("id", auctionId);

    setUploading(false);
    if (updateErr) {
      setError(`Bilden laddades upp men kunde inte sparas: ${updateErr.message}`);
      return;
    }
    setUrl(freshUrl);
  }

  return (
    <div className="flex items-center gap-2">
      <label className="cursor-pointer group relative shrink-0">
        {url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={url}
            alt={label}
            className="w-10 h-14 rounded-sm object-cover border border-line"
          />
        ) : (
          <div className="w-10 h-14 rounded-sm border border-dashed border-amber-400/60 flex items-center justify-center">
            <span className="text-[9px] text-amber-400/90 text-center leading-tight px-0.5">
              Saknas
            </span>
          </div>
        )}
        <div className="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity rounded-sm">
          <span className="text-[9px] text-paper text-center leading-tight px-0.5">
            {uploading ? "Laddar…" : url ? "Byt" : "Ladda upp"}
          </span>
        </div>
        <input
          type="file"
          accept="image/*"
          className="hidden"
          disabled={uploading}
          onChange={(e) => {
            const file = e.target.files?.[0];
            if (file) handleUpload(file);
            e.target.value = "";
          }}
        />
      </label>
      <span className="text-xs text-mute">{label}</span>
      {error && <span className="text-xs text-red-400">{error}</span>}
    </div>
  );
}
