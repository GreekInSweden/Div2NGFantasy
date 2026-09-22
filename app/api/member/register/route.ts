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
  try {
    return await handleRegister(req);
  } catch (err: any) {
    // Any uncaught exception here (e.g. a pending migration the code
    // already assumes is applied) would otherwise bubble up as a bare
    // 500 with a non-JSON body — the frontend's res.json() then throws,
    // which used to leave the submit button stuck on "Skapar konto…"
    // forever with no visible error. Always answer with real JSON.
    return NextResponse.json(
      { error: `Serverfel: ${err?.message ?? "okänt fel"}` },
      { status: 500 }
    );
  }
}

async function handleRegister(req: NextRequest) {
  const ip = getClientIp(req);
  const withinIpLimit = await checkRateLimit(`register:ip:${ip}`, 5, 60 * 60);
  if (!withinIpLimit) {
    return NextResponse.json(
      { error: "För många registreringar från samma nätverk. Försök igen senare." },
      { status: 429 }
    );
  }

  const body = await req.json();
  const { name, email, phone, address, postalCode, city, username, password } = body as {
    name: string;
    email: string;
    phone?: string;
    address?: string;
    postalCode?: string;
    city?: string;
    username: string;
    password: string;
  };

  if (!name?.trim() || !email?.trim() || !password || password.length < 8) {
    return NextResponse.json(
      { error: "Fyll i namn, e-post och ett lösenord på minst 8 tecken." },
      { status: 400 }
    );
  }

  const trimmedUsername = username?.trim() ?? "";
  if (!/^[A-Za-z0-9_-]{3,20}$/.test(trimmedUsername)) {
    return NextResponse.json(
      {
        error:
          "Användarnamnet ska vara 3–20 tecken (bokstäver, siffror, _ eller -).",
      },
      { status: 400 }
    );
  }

  const normalizedEmail = email.trim().toLowerCase();

  const { data: blocked } = await supabaseAdmin
    .from("blocked_emails")
    .select("email")
    .eq("email", normalizedEmail)
    .maybeSingle();

  if (blocked) {
    return NextResponse.json(
      { error: "Den här e-postadressen kan inte användas för registrering." },
      { status: 403 }
    );
  }

  const { data: existing } = await supabaseAdmin
    .from("members")
    .select("id")
    .eq("email", normalizedEmail)
    .maybeSingle();

  if (existing) {
    return NextResponse.json(
      { error: "Det finns redan ett konto med den e-postadressen." },
      { status: 409 }
    );
  }

  const { data: usernameTaken } = await supabaseAdmin
    .from("members")
    .select("id")
    .ilike("username", trimmedUsername)
    .maybeSingle();

  if (usernameTaken) {
    return NextResponse.json(
      { error: "Det användarnamnet är redan taget." },
      { status: 409 }
    );
  }

  const passwordHash = await bcrypt.hash(password, 10);

  const { data: member, error } = await supabaseAdmin
    .from("members")
    .insert({
      name: name.trim(),
      email: normalizedEmail,
      phone: phone?.trim() || null,
      address: address?.trim() || null,
      postal_code: postalCode?.trim() || null,
      city: city?.trim() || null,
      username: trimmedUsername,
      password_hash: passwordHash,
    })
    .select("id, member_number, name, email, username")
    .single();

  if (error || !member) {
    if (error?.code === "23505") {
      return NextResponse.json(
        { error: "Det användarnamnet är redan taget." },
        { status: 409 }
      );
    }
    return NextResponse.json({ error: "Kunde inte skapa kontot." }, { status: 500 });
  }

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
