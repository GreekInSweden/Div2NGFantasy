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
      <p className="text-mute mb-10">
        Medlemsnummer <span className="font-mono text-gold">#{member.memberNumber}</span>
      </p>

      <MemberProfileForm member={member} />
      <MemberHistory />
    </div>
  );
}
