import { NextRequest, NextResponse } from "next/server";
import QRCode from "qrcode";

// Builds a Swish "prefilled payment" link and renders it as a QR code,
// entirely on our own server. No Swish merchant agreement or external QR
// API needed — this is the same link scheme Swish's own app generates
// when you create a payment QR code in the Swish app (confirmed by
// decoding a real one), just with the amount and message filled in
// per-order instead of left blank.
export const dynamic = "force-dynamic";

export async function GET(req: NextRequest) {
  const amount = req.nextUrl.searchParams.get("amount");
  const message = req.nextUrl.searchParams.get("message") ?? "";

  if (!amount) {
    return NextResponse.json({ error: "Missing amount" }, { status: 400 });
  }

  const rawNumber = (process.env.NEXT_PUBLIC_SWISH_NUMBER ?? "").replace(/\D/g, "");
  if (!rawNumber) {
    return NextResponse.json({ error: "Swish number not configured" }, { status: 500 });
  }

  const swishUrl = `https://app.swish.nu/1/p/sw/?sw=${rawNumber}&amt=${encodeURIComponent(
    amount
  )}&cur=SEK&msg=${encodeURIComponent(message)}&src=qr`;

  const pngBuffer = await QRCode.toBuffer(swishUrl, {
    type: "png",
    width: 300,
    margin: 1,
    color: { dark: "#14151A", light: "#FFFFFF" },
  });

  return new NextResponse(new Uint8Array(pngBuffer), {
    headers: {
      "Content-Type": "image/png",
      "Cache-Control": "no-store",
    },
  });
}
