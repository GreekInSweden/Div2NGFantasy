import Link from "next/link";
import LogoutButton from "@/components/admin/LogoutButton";
import { LAGER_ENABLED } from "@/lib/siteConfig";

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div>
      <div className="border-b border-line">
        <div className="max-w-5xl mx-auto px-4 h-14 flex items-center justify-between">
          <Link
            href={LAGER_ENABLED ? "/admin" : "/admin/masterset"}
            className="font-display font-semibold text-paper"
          >
            Kortmarknad — Admin
          </Link>
          <nav className="flex items-center gap-4">
            {/* Lager och Beställningar hör ihop med det pausade "Vårt
                lager" (se lib/siteConfig.ts) -- döljs tills det slås på
                igen, precis som länken i den publika headern. */}
            {LAGER_ENABLED && (
              <Link href="/admin" className="focus-ring text-sm text-paper hover:text-gold">
                Lager
              </Link>
            )}
            {LAGER_ENABLED && (
              <Link href="/admin/bestallningar" className="focus-ring text-sm text-paper hover:text-gold">
                Beställningar
              </Link>
            )}
            <Link href="/admin/paket" className="focus-ring text-sm text-paper hover:text-gold">
              Paket
            </Link>
            <Link href="/admin/masterset" className="focus-ring text-sm text-paper hover:text-gold">
              Master Set
            </Link>
            <Link href="/admin/dubbletter" className="focus-ring text-sm text-paper hover:text-gold">
              Dubbletter
            </Link>
            <Link href="/admin/auktioner" className="focus-ring text-sm text-paper hover:text-gold">
              Auktioner
            </Link>
            <Link href="/admin/medlemmar" className="focus-ring text-sm text-paper hover:text-gold">
              Medlemmar
            </Link>
            <Link href="/admin/kortsok" className="focus-ring text-sm text-paper hover:text-gold">
              Kortsök
            </Link>
            <Link href="/admin/anmalningar" className="focus-ring text-sm text-paper hover:text-gold">
              Anmälningar
            </Link>
            <LogoutButton />
          </nav>
        </div>
      </div>
      {children}
    </div>
  );
}
