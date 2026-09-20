import { createHash } from "crypto";
import { NextRequest, NextResponse } from "next/server";
import bcrypt from "bcryptjs";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import {
  signMemberSession,
  MEMBER_SESSION_COOKIE,
  memberSessionCookieOptions,
} from "@/lib/memberSession";
import { checkRateLimit, getClientIp } from "@/lib/rateLimit";

export const dynamic = "force-dynamic";

export async function POST(req: NextRequest) {
  const ip = getClientIp(req);
  // The token itself is 256 bits of randomness (infeasible to guess), but
  // this still caps how fast someone could hammer the endpoint.
  const withinIpLimit = await checkRateLimit(`pwresetconfirm:ip:${ip}`, 15, 60 * 60);
  if (!withinIpLimit) {
    return NextResponse.json(
      { error: "För många försök. Försök igen senare." },
      { status: 429 }
    );
  }

  const body = await req.json();
  const { token, newPassword } = body as { token: string; newPassword: string };

  if (!token || !newPassword || newPassword.length < 8) {
    return NextResponse.json(
      { error: "Ange ett lösenord på minst 8 tecken." },
      { status: 400 }
    );
  }

  const tokenHash = createHash("sha256").update(token).digest("hex");

  const { data: member } = await supabaseAdmin
    .from("members")
    .select("id, password_reset_expires_at")
    .eq("password_reset_token_hash", tokenHash)
    .maybeSingle();

  if (!member || !member.password_reset_expires_at || new Date(member.password_reset_expires_at) < new Date()) {
    return NextResponse.json(
      { error: "Länken är ogiltig eller har gått ut. Begär en ny återställning." },
      { status: 400 }
    );
  }

  const passwordHash = await bcrypt.hash(newPassword, 10);

  await supabaseAdmin
    .from("members")
    .update({
      password_hash: passwordHash,
      password_reset_token_hash: null,
      password_reset_expires_at: null,
      password_reset_requested_at: null,
      failed_login_attempts: 0,
      locked_until: null,
    })
    .eq("id", member.id);

  // Log them straight in — they just proved ownership of the link.
  const sessionToken = await signMemberSession(member.id);
  const res = NextResponse.json({ ok: true });
  res.cookies.set(MEMBER_SESSION_COOKIE, sessionToken, memberSessionCookieOptions);
  return res;
}
