import { redirect } from "next/navigation";
import { getCurrentMember } from "@/lib/currentMember";
import MessageInbox from "@/components/MessageInbox";

export const dynamic = "force-dynamic";

export default async function MeddelandenPage() {
  const member = await getCurrentMember();
  if (!member) {
    redirect("/konto/logga-in?next=/konto/meddelanden");
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-14">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Meddelanden
      </h1>
      <p className="text-mute mb-8">
        Meddelanden du skickat och fått, kopplade till dina matchningar.
      </p>

      <MessageInbox />
    </div>
  );
}
