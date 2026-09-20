import { NextResponse } from "next/server";
import { getCurrentMember } from "@/lib/currentMember";

export const dynamic = "force-dynamic";

export async function GET() {
  const member = await getCurrentMember();
  return NextResponse.json({ member });
}
