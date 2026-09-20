import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { checkRateLimit, getClientIp } from "@/lib/rateLimit";

export const dynamic = "force-dynamic";

// This project has no outbound email set up yet, so a reset request
// doesn't hand out a link by itself — that would let anyone "reset" any
// account just by knowing its email address. Instead this flags the
// account in the admin panel (Medlemmar), where the admin generates a
// one-time link and sends it to the member directly, the same manual way
// Swish payments are already confirmed in this project.
export async function POST(req: NextRequest) {
  const ip = getClientIp(req);
  const withinIpLimit = await checkRateLimit(`pwreset:ip:${ip}`, 8, 60 * 60);
  if (!withinIpLimit) {
    return NextResponse.json(
      { error: "För många förfrågningar. Försök igen senare." },
      { status: 429 }
    );
  }

  const body = await req.json();
  const { email } = body as { email: string };
  if (!email?.trim()) {
    return NextResponse.json({ error: "Ange en e-postadress." }, { status: 400 });
  }

  const { data: member } = await supabaseAdmin
    .from("members")
    .select("id")
    .eq("email", email.trim().toLowerCase())
    .maybeSingle();

  // Deliberately the same response whether or not the account exists —
  // otherwise this endpoint could be used to check which e-mails are
  // registered.
  if (member) {
    await supabaseAdmin
      .from("members")
      .update({ password_reset_requested_at: new Date().toISOString() })
      .eq("id", member.id);
  }

  return NextResponse.json({ ok: true });
}
