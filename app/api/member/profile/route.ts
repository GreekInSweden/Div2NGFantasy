import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";

export const dynamic = "force-dynamic";

export async function POST(req: NextRequest) {
  const member = await getCurrentMember();
  if (!member) {
    return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
  }

  const body = await req.json();
  const { name, phone, address, postalCode, city } = body as {
    name: string;
    phone?: string;
    address?: string;
    postalCode?: string;
    city?: string;
  };

  if (!name?.trim()) {
    return NextResponse.json({ error: "Ange ett namn." }, { status: 400 });
  }

  const { error } = await supabaseAdmin
    .from("members")
    .update({
      name: name.trim(),
      phone: phone?.trim() || null,
      address: address?.trim() || null,
      postal_code: postalCode?.trim() || null,
      city: city?.trim() || null,
    })
    .eq("id", member.id);

  if (error) {
    return NextResponse.json({ error: "Kunde inte spara uppgifterna." }, { status: 500 });
  }

  return NextResponse.json({ ok: true });
}
