// Vercel Routing Middleware – byter "Div2NG Play" mot "Bonnboll Play"
// i sidans HTML (titel + Open Graph-taggar) när sidan besöks via bonnboll.se.
// Detta behövs eftersom Facebooks förhandsvisningsrobot inte kör JavaScript,
// så bytet måste ske i själva HTML-koden innan den skickas iväg.

export const config = {
  matcher: '/',
};

export default async function middleware(request) {
  const host = request.headers.get('host') || '';

  // Skydd mot oändlig loop: om anropet redan passerat vår ombyggnad en gång,
  // släpp igenom det obehandlat den här gången.
  if (request.headers.get('x-mw-pass') === '1') {
    return;
  }

  // Bara bonnboll.se ska byta namn – allt annat lämnas orört.
  if (!host.includes('bonnboll')) {
    return;
  }

  const originUrl = new URL(request.url);
  const passHeaders = new Headers(request.headers);
  passHeaders.set('x-mw-pass', '1');

  const originRes = await fetch(originUrl, { headers: passHeaders });
  let html = await originRes.text();
  html = html.split('Div2NG Play').join('Bonnboll Play');

  const headers = new Headers(originRes.headers);
  headers.set('content-type', 'text/html; charset=utf-8');

  return new Response(html, {
    status: originRes.status,
    headers,
  });
}
