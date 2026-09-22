// How a member is shown to other people (auction bid history/leaderboard,
// header) — their own chosen username if they set one, otherwise falls
// back to "Medlem #<nummer>" like before. Never the real name.
export function memberLabel(
  memberNumber: number | null,
  username?: string | null
): string {
  if (username) return username;
  if (memberNumber !== null) return `Medlem #${memberNumber}`;
  return "Okänd medlem";
}
