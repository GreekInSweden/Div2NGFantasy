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
  const withinIpLimit = await checkRateLimit(`register:ip:${ip}`, 5, 60 * 60);
  if (!withinIpLimit) {
    return NextResponse.json(
      { error: "För många registreringar från samma nätverk. Försök igen senare." },
      { status: 429 }
    );
  }

  const body = await req.json();
  const { name, email, phone, address, postalCode, city, password } = body as {
    name: string;
    email: string;
    phone?: string;
    address?: string;
    postalCode?: string;
    city?: string;
    password: string;
  };

  if (!name?.trim() || !email?.trim() || !password || password.length < 8) {
    return NextResponse.json(
      { error: "Fyll i namn, e-post och ett lösenord på minst 8 tecken." },
      { status: 400 }
    );
  }

  const normalizedEmail = email.trim().toLowerCase();

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
      password_hash: passwordHash,
    })
    .select("id, member_number, name, email")
    .single();

  if (error || !member) {
    return NextResponse.json({ error: "Kunde inte skapa kontot." }, { status: 500 });
  }

  const token = await signMemberSession(member.id);
  const res = NextResponse.json({
    member: {
      memberNumber: member.member_number,
      name: member.name,
      email: member.email,
    },
  });
  res.cookies.set(MEMBER_SESSION_COOKIE, token, memberSessionCookieOptions);
  return res;
}
