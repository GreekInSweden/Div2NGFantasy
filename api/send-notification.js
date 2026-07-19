// Vercel serverless function – skickar Web Push-notiser
// Kräver environment variables: VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY, VAPID_EMAIL, API_SECRET
const webpush = require('web-push');
const VAPID_PUBLIC_KEY = process.env.VAPID_PUBLIC_KEY;
const VAPID_PRIVATE_KEY = process.env.VAPID_PRIVATE_KEY;
const VAPID_EMAIL = process.env.VAPID_EMAIL || 'mailto:admin@div2ng.se';
webpush.setVapidDetails(VAPID_EMAIL, VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY);

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }
  const authHeader = req.headers['x-api-key'];
  if (authHeader !== process.env.API_SECRET) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  const { subscriptions, title, body, url } = req.body;
  if (!subscriptions || !title || !body) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const payload = JSON.stringify({
    title,
    body,
    icon: '/icon.svg',
    badge: '/icon.svg',
    url: url || '/',
    timestamp: Date.now()
  });

  const results = await Promise.allSettled(
    subscriptions.map(sub =>
      webpush.sendNotification({
        endpoint: sub.endpoint,
        keys: sub.keys
      }, payload)
    )
  );

  const sent = results.filter(r => r.status === 'fulfilled').length;
  const failed = results.filter(r => r.status === 'rejected').length;

  // Plocka ut de faktiska felmeddelandena så vi kan se dem direkt i appen,
  // istället för att behöva leta i Vercels loggar.
  const errors = results
    .filter(r => r.status === 'rejected')
    .map(r => ({
      statusCode: r.reason?.statusCode || null,
      message: r.reason?.body || r.reason?.message || String(r.reason)
    }));

  // Logga också i Vercel för säkerhets skull
  errors.forEach(e => console.error('Push-fel:', e.statusCode, e.message));

  return res.status(200).json({ sent, failed, errors });
}
