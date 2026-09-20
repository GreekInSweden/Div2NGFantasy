import { SignJWT, jwtVerify } from "jose";

// Member accounts are deliberately NOT Supabase Auth. Every RLS policy in
// this project so far uses `auth.role() = 'authenticated'` to mean "the
// logged-in admin" (see middleware.ts / lib/supabase/server.ts) — if
// members signed in through Supabase Auth too, any registered member
// would satisfy that same check and could read/write orders, stock,
// cards etc. directly through the browser Supabase client, completely
// bypassing the admin login. So members get their own password table and
// their own signed session cookie, checked only by this project's own API
// routes (which use the service-role key, never RLS) — never by Supabase
// itself. See supabase/member_accounts.sql for the full explanation.

export const MEMBER_SESSION_COOKIE = "kortlagret_member_session";
const SESSION_DURATION_SECONDS = 60 * 60 * 24 * 30; // 30 days

function getSecret() {
  const secret = process.env.MEMBER_SESSION_SECRET;
  if (!secret) {
    throw new Error(
      "MEMBER_SESSION_SECRET saknas — sätt en lång slumpad hemlighet som miljövariabel."
    );
  }
  return new TextEncoder().encode(secret);
}

export async function signMemberSession(memberId: string): Promise<string> {
  return new SignJWT({ memberId })
    .setProtectedHeader({ alg: "HS256" })
    .setIssuedAt()
    .setExpirationTime(`${SESSION_DURATION_SECONDS}s`)
    .sign(getSecret());
}

export async function verifyMemberSession(token: string): Promise<string | null> {
  try {
    const { payload } = await jwtVerify(token, getSecret());
    return typeof payload.memberId === "string" ? payload.memberId : null;
  } catch {
    return null;
  }
}

export const memberSessionCookieOptions = {
  httpOnly: true,
  secure: process.env.NODE_ENV === "production",
  sameSite: "lax" as const,
  path: "/",
  maxAge: SESSION_DURATION_SECONDS,
};
