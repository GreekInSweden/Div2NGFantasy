import { NextRequest, NextResponse } from "next/server";
import bcrypt from "bcryptjs";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import {
  signMemberSession,
  MEMBER_SESSION_COOKIE,
  memberSessionCookieOptions,
} from "@/lib/memberSession";

export const dynamic = "force-dynamic";

export async function POST(req: NextRequest) {
  const body = await req.json();
  const { email, password } = body as { email: string; password: string };

  if (!email?.trim() || !password) {
    return NextResponse.json({ error: "Fyll i e-post och lösenord." }, { status: 400 });
  }

  const { data: member } = await supabaseAdmin
    .from("members")
    .select("id, member_number, name, email, password_hash")
    .eq("email", email.trim().toLowerCase())
    .maybeSingle();

  if (!member || !(await bcrypt.compare(password, member.password_hash))) {
    return NextResponse.json({ error: "Fel e-post eller lösenord." }, { status: 401 });
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
