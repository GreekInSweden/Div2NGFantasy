import { redirect } from "next/navigation";
import { getCurrentMember } from "@/lib/currentMember";
import MatchList from "@/components/MatchList";

export const dynamic = "force-dynamic";

export default async function MatchningarPage() {
  const member = await getCurrentMember();
  if (!member) {
    redirect("/konto/logga-in?next=/konto/matchningar");
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-14">
      <h1 className="font-display text-3xl font-bold text-paper mb-1">
        Mina matchningar
      </h1>
      <p className="text-mute mb-8 max-w-prose">
        Kort från din önskelista som minst en annan medlem äger. Ingen
        kontaktinfo visas förrän du klickar "Visa kontakt" på en specifik
        matchning.
      </p>
      <MatchList />
    </div>
  );
}
