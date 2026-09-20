import { NextResponse } from "next/server";
import { MEMBER_SESSION_COOKIE } from "@/lib/memberSession";

export const dynamic = "force-dynamic";

export async function POST() {
  const res = NextResponse.json({ ok: true });
  res.cookies.set(MEMBER_SESSION_COOKIE, "", { path: "/", maxAge: 0 });
  return res;
}
