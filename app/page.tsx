import { redirect } from "next/navigation";
import { getCurrentMember } from "@/lib/currentMember";

export const dynamic = "force-dynamic";

// The storefront (kategori-listan) lives at /lager now — it's reachable
// from the nav as "Vårt lager". Root just decides where to send people:
// a logged-in medlem lands in sin egna portfölj (the page they'll use
// most, especially right after opening new packs), everyone else lands
// in the shop.
export default async function RootPage() {
  const member = await getCurrentMember();
  redirect(member ? "/konto/portfolj" : "/lager");
}
