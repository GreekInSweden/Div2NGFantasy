import Link from "next/link";
import { createServerSupabase } from "@/lib/supabase/server";
import ReportActions from "@/components/admin/ReportActions";

export const dynamic = "force-dynamic";

export default async function AdminReportsPage() {
  const supabase = createServerSupabase();

  const { data: reports } = await supabase
    .from("member_reports")
    .select(
      "id, reason, status, created_at, reporter:reporter_member_id(id, member_number, username, name), reported:reported_member_id(id, member_number, username, name, email)"
    )
    .order("created_at", { ascending: false });

  const open = ((reports as any[]) ?? []).filter((r) => r.status === "open");
  const resolved = ((reports as any[]) ?? []).filter((r) => r.status === "resolved");

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Anmälningar
      </h1>
      <p className="text-mute text-sm mb-8">
        När en medlem anmäler någon (t.ex. vid en matchning som verkar
        skum) hamnar det här. Blockera + radera stänger av kontot och
        hindrar samma e-postadress från att registrera sig igen.
      </p>

      {open.length === 0 ? (
        <p className="text-mute text-sm mb-8">Inga öppna anmälningar.</p>
      ) : (
        <div className="space-y-3 mb-10">
          {open.map((r: any) => (
            <ReportCard key={r.id} report={r} />
          ))}
        </div>
      )}

      {resolved.length > 0 && (
        <details className="mb-8">
          <summary className="text-sm text-mute cursor-pointer hover:text-paper">
            Avklarade ({resolved.length})
          </summary>
          <div className="space-y-3 mt-3">
            {resolved.map((r: any) => (
              <ReportCard key={r.id} report={r} />
            ))}
          </div>
        </details>
      )}
    </div>
  );
}

function ReportCard({ report }: { report: any }) {
  const reporter = report.reporter;
  const reported = report.reported;
  return (
    <div className="border border-line rounded-md p-4 bg-panel">
      <div className="text-xs text-mute mb-1">
        {new Date(report.created_at).toLocaleString("sv-SE")}
        {report.status === "resolved" && " · Avklarad"}
      </div>
      <div className="text-sm text-paper mb-2">
        <Link href={`/admin/medlemmar/${reported?.id}`} className="text-gold hover:underline">
          {reported ? `#${reported.member_number} ${reported.username ?? reported.name}` : "Okänd medlem"}
        </Link>{" "}
        anmäld av{" "}
        {reporter ? (
          <Link href={`/admin/medlemmar/${reporter.id}`} className="text-gold hover:underline">
            #{reporter.member_number} {reporter.username ?? reporter.name}
          </Link>
        ) : (
          "en medlem som sen tagits bort"
        )}
      </div>
      <p className="text-sm text-mute mb-3 whitespace-pre-wrap">{report.reason}</p>
      {report.status === "open" && reported && (
        <ReportActions
          reportId={report.id}
          reportedMemberId={reported.id}
          reportedEmail={reported.email}
        />
      )}
    </div>
  );
}
