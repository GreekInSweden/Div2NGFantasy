import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabaseAdmin";
import { getCurrentMember } from "@/lib/currentMember";
import { checkRateLimit, getClientIp } from "@/lib/rateLimit";

export const dynamic = "force-dynamic";

export async function POST(req: NextRequest) {
  try {
    const member = await getCurrentMember();
    if (!member) {
      return NextResponse.json({ error: "Inte inloggad." }, { status: 401 });
    }

    // A handful of reports per member per hour is plenty for genuine use
    // and stops someone from spamming the admin's inbox.
    const ip = getClientIp(req);
    const withinLimit = await checkRateLimit(`report:member:${member.id}`, 10, 60 * 60);
    const withinIpLimit = await checkRateLimit(`report:ip:${ip}`, 20, 60 * 60);
    if (!withinLimit || !withinIpLimit) {
      return NextResponse.json(
        { error: "För många anmälningar. Försök igen senare." },
        { status: 429 }
      );
    }

    const body = await req.json();
    const { reportedMemberId, reason } = body as {
      reportedMemberId: string;
      reason: string;
    };

    if (!reportedMemberId || !reason?.trim()) {
      return NextResponse.json(
        { error: "Fyll i en anledning." },
        { status: 400 }
      );
    }
    if (reportedMemberId === member.id) {
      return NextResponse.json(
        { error: "Du kan inte anmäla dig själv." },
        { status: 400 }
      );
    }

    const { error } = await supabaseAdmin.from("member_reports").insert({
      reporter_member_id: member.id,
      reported_member_id: reportedMemberId,
      reason: reason.trim().slice(0, 1000),
    });

    if (error) {
      return NextResponse.json({ error: "Kunde inte skicka anmälan." }, { status: 500 });
    }

    return NextResponse.json({ ok: true });
  } catch (err: any) {
    return NextResponse.json(
      { error: `Serverfel: ${err?.message ?? "okänt fel"}` },
      { status: 500 }
    );
  }
}
