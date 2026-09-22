import Link from "next/link";
import { redirect } from "next/navigation";
import { getCurrentMember } from "@/lib/currentMember";
import MemberProfileForm from "@/components/MemberProfileForm";
import MemberHistory from "@/components/MemberHistory";

export const dynamic = "force-dynamic";

export default async function KontoPage() {
  const member = await getCurrentMember();
  if (!member) {
    redirect("/konto/logga-in?next=/konto");
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-14">
      <h1 className="font-display text-3xl font-bold text-paper mb-1">
        Mitt konto
      </h1>
      <p className="text-mute mb-6">
        Medlemsnummer <span className="font-mono text-gold">#{member.memberNumber}</span>
        {member.username && (
          <>
            {" "}
            · Användarnamn <span className="text-gold">{member.username}</span>
          </>
        )}
      </p>

      <div className="flex flex-wrap gap-2 mb-10">
        <Link
          href="/konto/portfolj"
          className="focus-ring text-sm rounded-sm border border-line px-4 py-2 text-paper hover:border-gold"
        >
          Min portfölj
        </Link>
        <Link
          href="/konto/matchningar"
          className="focus-ring text-sm rounded-sm border border-line px-4 py-2 text-paper hover:border-gold"
        >
          Mina matchningar
        </Link>
        <Link
          href="/mest-eftertraktade"
          className="focus-ring text-sm rounded-sm border border-line px-4 py-2 text-paper hover:border-gold"
        >
          Mest eftertraktade
        </Link>
      </div>

      <MemberProfileForm member={member} />
      <MemberHistory />
    </div>
  );
}
