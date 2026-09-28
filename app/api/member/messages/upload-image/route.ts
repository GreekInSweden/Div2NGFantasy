import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";
import { checkRateLimit, getClientIp } from "@/lib/rateLimit";

export const dynamic = "force-dynamic";

const MAX_BYTES = 8 * 1024 * 1024; // 8MB — gott om marginal för ett kortfoto från mobilen

// Medlemmar är inte Supabase Auth-användare, så de kan inte skriva direkt
// mot Storage under RLS (samma som varje annan medlemsskrivning i
// projektet) -- den här routen tar emot filen och laddar upp den åt dem
// med service-role-nyckeln.
export async function POST(req: NextRequest) {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const ip = getClientIp(req);
  const withinLimit = await checkRateLimit(`message-image:member:${member.id}`, 40, 60 * 60);
  const withinIpLimit = await checkRateLimit(`message-image:ip:${ip}`, 80, 60 * 60);
  if (!withinLimit || !withinIpLimit) {
    return NextResponse.json({ error: "För många uppladdningar. Försök igen senare." }, { status: 429 });
  }

  const formData = await req.formData();
  const file = formData.get("file");
  if (!(file instanceof File)) {
    return NextResponse.json({ error: "Ingen fil hittades." }, { status: 400 });
  }
  if (!file.type.startsWith("image/")) {
    return NextResponse.json({ error: "Bara bildfiler stöds." }, { status: 400 });
  }
  if (file.size > MAX_BYTES) {
    return NextResponse.json({ error: "Bilden är för stor (max 8MB)." }, { status: 400 });
  }

  const ext = file.name.split(".").pop() || "jpg";
  const path = `${member.id}/${crypto.randomUUID()}.${ext}`;

  const { error: uploadErr } = await supabaseAdmin.storage
    .from("member-message-images")
    .upload(path, file, { contentType: file.type, upsert: false });

  if (uploadErr) {
    return NextResponse.json(
      { error: `Kunde inte ladda upp bilden: ${uploadErr.message}` },
      { status: 500 }
    );
  }

  const { data: publicUrlData } = supabaseAdmin.storage
    .from("member-message-images")
    .getPublicUrl(path);

  return NextResponse.json({ url: publicUrlData.publicUrl });
}
