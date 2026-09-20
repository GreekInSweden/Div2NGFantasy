import type { Metadata } from "next";
import { Space_Grotesk, IBM_Plex_Sans, IBM_Plex_Mono } from "next/font/google";
import Link from "next/link";
import "./globals.css";
import { CartProvider } from "@/lib/CartContext";
import SiteHeader from "@/components/SiteHeader";

const display = Space_Grotesk({
  subsets: ["latin"],
  weight: ["500", "700"],
  variable: "--font-display",
});
const body = IBM_Plex_Sans({
  subsets: ["latin"],
  weight: ["400", "500", "600"],
  variable: "--font-body",
});
const mono = IBM_Plex_Mono({
  subsets: ["latin"],
  weight: ["400", "500"],
  variable: "--font-mono",
});

export const metadata: Metadata = {
  title: "Kortlagret",
  description: "Köp lösa Pokémonkort — välj kort, betala med Swish, vi skickar.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="sv" className={`${display.variable} ${body.variable} ${mono.variable}`}>
      <body className="font-body min-h-screen flex flex-col">
        <CartProvider>
          <SiteHeader />
          <main className="flex-1">{children}</main>
          <footer className="border-t border-line py-8 mt-16">
            <div className="max-w-6xl mx-auto px-4 flex items-center justify-between text-sm text-mute">
              <span>Kortlagret — köp lösa samlarkort. Frakt tillkommer, betalning via Swish.</span>
              <Link href="/admin" className="focus-ring hover:text-paper shrink-0 ml-4">
                Admin
              </Link>
            </div>
          </footer>
        </CartProvider>
      </body>
    </html>
  );
}
