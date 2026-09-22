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

const LOCK_AFTER_ATTEMPTS = 5;
const LOCK_DURATION_MS = 15 * 60 * 1000;

export async function POST(req: NextRequest) {
  try {
    return await handleLogin(req);
  } catch (err: any) {
    // See the matching comment in register/route.ts — never let an
    // uncaught exception fall through as a non-JSON 500, or the login
    // button hangs on "Loggar in…" forever with no visible error.
    return NextResponse.json(
      { error: `Serverfel: ${err?.message ?? "okänt fel"}` },
      { status: 500 }
    );
  }
}

async function handleLogin(req: NextRequest) {
  const ip = getClientIp(req);
  // Caps how many login attempts total can come from one IP address —
  // catches a script trying many different accounts, on top of the
  // per-account lockout below which catches guessing one account's
  // password over and over.
  const withinIpLimit = await checkRateLimit(`login:ip:${ip}`, 20, 10 * 60);
  if (!withinIpLimit) {
    return NextResponse.json(
      { error: "För många inloggningsförsök. Vänta någon minut och försök igen." },
      { status: 429 }
    );
  }

  const body = await req.json();
  const { email, password } = body as { email: string; password: string };

  if (!email?.trim() || !password) {
    return NextResponse.json({ error: "Fyll i e-post och lösenord." }, { status: 400 });
  }

  const normalizedEmail = email.trim().toLowerCase();

  const { data: member, error: fetchError } = await supabaseAdmin
    .from("members")
    .select(
      "id, member_number, name, email, username, password_hash, failed_login_attempts, locked_until"
    )
    .eq("email", normalizedEmail)
    .maybeSingle();

  // A real query failure (e.g. a column the code expects isn't in the
  // database yet because a migration hasn't been run) must not be
  // reported as "wrong password" — that's indistinguishable from a
  // real login failure and just leaves someone stuck retyping a
  // correct password forever. Surface it plainly instead.
  if (fetchError) {
    return NextResponse.json(
      { error: `Serverfel vid inloggning: ${fetchError.message}` },
      { status: 500 }
    );
  }

  if (member?.locked_until && new Date(member.locked_until) > new Date()) {
    const minutesLeft = Math.ceil(
      (new Date(member.locked_until).getTime() - Date.now()) / 60000
    );
    return NextResponse.json(
      {
        error: `Kontot är tillfälligt låst efter för många felaktiga försök. Försök igen om ${minutesLeft} min, eller återställ lösenordet.`,
      },
      { status: 423 }
    );
  }

  const passwordOk = member ? await bcrypt.compare(password, member.password_hash) : false;

  if (!member || !passwordOk) {
    if (member) {
      const attempts = (member.failed_login_attempts ?? 0) + 1;
      const lockingNow = attempts >= LOCK_AFTER_ATTEMPTS;
      await supabaseAdmin
        .from("members")
        .update({
          failed_login_attempts: lockingNow ? 0 : attempts,
          locked_until: lockingNow ? new Date(Date.now() + LOCK_DURATION_MS).toISOString() : null,
        })
        .eq("id", member.id);
    }
    return NextResponse.json({ error: "Fel e-post eller lösenord." }, { status: 401 });
  }

  await supabaseAdmin
    .from("members")
    .update({ failed_login_attempts: 0, locked_until: null })
    .eq("id", member.id);

  const token = await signMemberSession(member.id);
  const res = NextResponse.json({
    member: {
      memberNumber: member.member_number,
      name: member.name,
      email: member.email,
      username: member.username,
    },
  });
  res.cookies.set(MEMBER_SESSION_COOKIE, token, memberSessionCookieOptions);
  return res;
}
