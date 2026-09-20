import { createServerSupabase } from "@/lib/supabase/server";
import MemberAdminActions from "@/components/admin/MemberAdminActions";

export const dynamic = "force-dynamic";

export default async function AdminMedlemmarPage() {
  const supabase = createServerSupabase();

  const { data: members } = await supabase
    .from("members")
    .select(
      "id, member_number, name, email, phone, created_at, failed_login_attempts, locked_until, password_reset_requested_at"
    )
    .order("member_number", { ascending: true });

  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="font-display text-2xl font-bold text-paper mb-1">
        Medlemmar
      </h1>
      <p className="text-mute text-sm mb-8">
        Alla registrerade medlemskonton. Ett konto låses automatiskt i 15
        minuter efter 5 felaktiga inloggningsförsök i rad.
      </p>

      {!members || members.length === 0 ? (
        <p className="text-mute">Inga medlemmar ännu.</p>
      ) : (
        <div className="space-y-3">
          {members.map((m: any) => {
            const isLocked = m.locked_until && new Date(m.locked_until) > new Date();
            const hasPendingRequest = !!m.password_reset_requested_at;
            return (
              <div key={m.id} className="border border-line rounded-md p-4 bg-panel">
                <div className="flex items-start justify-between gap-3 mb-1">
                  <div>
                    <div className="font-mono text-xs text-gold">
                      Medlem #{m.member_number}
                    </div>
                    <div className="font-display font-semibold text-paper">
                      {m.name}
                    </div>
                    <div className="text-sm text-mute">
                      {m.email} · {m.phone ?? "inget telefonnr"}
                    </div>
                  </div>
                  <div className="flex flex-col items-end gap-1 shrink-0">
                    {isLocked && (
                      <span className="text-xs font-mono px-2 py-1 rounded-sm bg-red-400/10 text-red-400">
                        Låst
                      </span>
                    )}
                    {hasPendingRequest && (
                      <span className="text-xs font-mono px-2 py-1 rounded-sm bg-amber-400/10 text-amber-400">
                        Begärt återställning
                      </span>
                    )}
                  </div>
                </div>

                <MemberAdminActions memberId={m.id} isLocked={!!isLocked} />
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
