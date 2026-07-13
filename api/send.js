const webpush = require("web-push");
const { createClient } = require("@supabase/supabase-js");

webpush.setVapidDetails(
  process.env.VAPID_SUBJECT || "mailto:example@example.com",
  process.env.VAPID_PUBLIC_KEY,
  process.env.VAPID_PRIVATE_KEY
);

// Service role-nyckeln har fulla rättigheter och används bara här på servern,
// aldrig i klientkoden.
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

module.exports = async (req, res) => {
  if (req.method !== "POST") {
    res.status(405).json({ error: "Endast POST är tillåtet" });
    return;
  }

  // Valfritt enkelt skydd - sätt APP_SECRET som miljövariabel på Vercel
  // och samma värde i config.js (self.APP_SECRET) om du vill använda detta.
  const expectedSecret = process.env.APP_SECRET;
  if (expectedSecret) {
    const provided = req.headers["x-app-secret"];
    if (provided !== expectedSecret) {
      res.status(401).json({ error: "Fel eller saknad nyckel" });
      return;
    }
  }

  try {
    const { from, to, body } = req.body || {};

    if (!from || !Array.isArray(to) || to.length === 0 || !body) {
      res.status(400).json({ error: "Saknar from, to eller body" });
      return;
    }

    // Bara tillåtna avsändare får skicka. Sätts via miljövariabeln
    // ALLOWED_SENDERS på Vercel, t.ex. "Christos,Ingela". Om variabeln inte
    // är satt tillåts alla (bakåtkompatibelt).
    const allowedSenders = (process.env.ALLOWED_SENDERS || "")
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean);
    if (allowedSenders.length > 0 && !allowedSenders.includes(from)) {
      res.status(403).json({ error: "Du har inte behörighet att skicka meddelanden" });
      return;
    }

    // Kontrollera PIN-kod för adminnamn, om ADMIN_PINS är satt på servern.
    // Format på miljövariabeln: {"Christos":"1234","Ingela":"5678"}
    if (process.env.ADMIN_PINS) {
      try {
        const pins = JSON.parse(process.env.ADMIN_PINS);
        const expectedPin = pins[from];
        const providedPin = req.headers["x-admin-pin"];
        if (expectedPin && providedPin !== expectedPin) {
          res.status(401).json({ error: "Fel PIN-kod" });
          return;
        }
      } catch (e) {
        console.error("Kunde inte tolka ADMIN_PINS", e);
      }
    }

    const { data: subs, error } = await supabase
      .from("push_subscriptions")
      .select("id, endpoint, p256dh, auth")
      .in("member_name", to);

    if (error) throw error;

    if (!subs || subs.length === 0) {
      res.status(200).json({
        warning: "Ingen av mottagarna har aktiverat notiser ännu.",
        sent: 0
      });
      return;
    }

    const payload = JSON.stringify({
      title: `${from} skriver`,
      body,
      data: { from, body }
    });

    // Spara meddelandet i historiken så det syns i appen, oavsett om
    // push-notisen lyckas nå fram eller inte.
    await supabase.from("messages").insert({
      from_name: from,
      to_names: to,
      body
    });

    const results = await Promise.allSettled(
      subs.map((s) =>
        webpush.sendNotification(
          {
            endpoint: s.endpoint,
            keys: { p256dh: s.p256dh, auth: s.auth }
          },
          payload
        )
      )
    );

    // Städa bort prenumerationer som inte längre är giltiga (t.ex. avinstallerad app)
    const deadIds = [];
    results.forEach((r, i) => {
      if (r.status === "rejected") {
        const statusCode = r.reason?.statusCode;
        if (statusCode === 404 || statusCode === 410) {
          deadIds.push(subs[i].id);
        }
      }
    });
    if (deadIds.length > 0) {
      await supabase.from("push_subscriptions").delete().in("id", deadIds);
    }

    const sent = results.filter((r) => r.status === "fulfilled").length;
    const failed = results.length - sent;

    res.status(200).json({ sent, failed });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message || "Serverfel" });
  }
};
