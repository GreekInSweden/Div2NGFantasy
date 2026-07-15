// Vercel serverless function – hämtar matchresultat från Fotbollskollen
export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const authHeader = req.headers['x-api-key'];
  if (authHeader !== process.env.API_SECRET) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  const { url } = req.body;
  if (!url || !url.includes('fotbollskollen')) {
    return res.status(400).json({ error: 'Ogiltig URL – måste vara från fotbollskollen.se' });
  }

  try {
    const response = await fetch(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'text/html,application/xhtml+xml',
        'Accept-Language': 'sv-SE,sv;q=0.9',
      }
    });

    if (!response.ok) {
      return res.status(502).json({ error: `Kunde inte hämta sidan (${response.status})` });
    }

    const html = await response.text();
    const matches = parseMatches(html);

    return res.status(200).json({ matches, count: matches.length });
  } catch (error) {
    return res.status(500).json({ error: 'Fel: ' + error.message });
  }
}

function parseMatches(html) {
  const matches = [];

  // Letar efter matchresultat i Fotbollskollen HTML
  // Format: lagnamn, resultat (t.ex. 2-1), lagnamn
  const patterns = [
    // Typisk tabell-rad med resultat
    /<tr[^>]*>[\s\S]*?<td[^>]*>([^<]{3,40}?)<\/td>[\s\S]*?<td[^>]*>(\d+)\s*[-–]\s*(\d+)<\/td>[\s\S]*?<td[^>]*>([^<]{3,40}?)<\/td>[\s\S]*?<\/tr>/gi,
    // Alt format med resultat som text
    /([A-ZÅÄÖ][a-zåäöA-ZÅÄÖ\s]{2,30}?)\s+(\d+)[-–](\d+)\s+([A-ZÅÄÖ][a-zåäöA-ZÅÄÖ\s]{2,30})/g,
  ];

  // Försök 1: Hitta JSON-data i sidan (modernare sajter)
  const jsonMatch = html.match(/window\.__INITIAL_STATE__\s*=\s*({[\s\S]*?});/);
  if (jsonMatch) {
    try {
      const data = JSON.parse(jsonMatch[1]);
      // Extrahera matcher från JSON om möjligt
      const events = data?.matches || data?.events || data?.games || [];
      if (events.length > 0) {
        events.forEach(e => {
          if (e.homeTeam && e.awayTeam && (e.homeScore !== undefined)) {
            matches.push({
              homeTeam: e.homeTeam.name || e.homeTeam,
              awayTeam: e.awayTeam.name || e.awayTeam,
              homeScore: parseInt(e.homeScore) || 0,
              awayScore: parseInt(e.awayScore) || 0,
            });
          }
        });
        if (matches.length > 0) return matches;
      }
    } catch(e) {}
  }

  // Försök 2: Regex på HTML-tabeller
  // Leta efter resultat-mönster: "2 - 1" eller "2-1"
  const resultPattern = /(\d+)\s*[-–]\s*(\d+)/g;
  const teamPattern = />([A-ZÅÄÖ][a-zåäöA-ZÅÄÖ\s\-\.]{2,35}?)</g;

  // Extrahera alla team-namn och resultat från sidan
  const allTeams = [];
  let teamMatch;
  while ((teamMatch = teamPattern.exec(html)) !== null) {
    const name = teamMatch[1].trim();
    if (name.length > 2 && name.length < 40 && !name.includes('  ')) {
      allTeams.push(name);
    }
  }

  const allResults = [];
  let resMatch;
  while ((resMatch = resultPattern.exec(html)) !== null) {
    const h = parseInt(resMatch[1]);
    const a = parseInt(resMatch[2]);
    if (h <= 20 && a <= 20) { // Rimliga fotbollsresultat
      allResults.push({ h, a });
    }
  }

  // Matcha lag mot resultat (enkel heuristik – tar varannan team-rad)
  for (let i = 0; i < Math.min(allResults.length, 7); i++) {
    const homeTeam = allTeams[i * 2] || `Hemmalag ${i + 1}`;
    const awayTeam = allTeams[i * 2 + 1] || `Bortalag ${i + 1}`;
    matches.push({
      homeTeam,
      awayTeam,
      homeScore: allResults[i].h,
      awayScore: allResults[i].a,
    });
  }

  return matches;
}
