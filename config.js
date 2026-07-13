// ============================================================
// FYLL I DINA EGNA VÄRDEN HÄR. Se README-SETUP.md steg för steg.
// ============================================================

// Hittar du i Supabase -> Project Settings -> API
self.SUPABASE_URL = "https://vsxqcdsmkozxefyrialf.supabase.co"; // t.ex. https://xxxxx.supabase.co
self.SUPABASE_ANON_KEY = "sb_publishable_C0XsAemLiySpB8dxuQRKaQ_WgBpnIY9"; // publishable key (motsvarar tidigare "anon" key)

// Den publika VAPID-nyckeln (säker att ha i klientkoden - motsatsen till
// den privata nyckeln som bara ska ligga som miljövariabel på Vercel).
// Den här är redan färdiggenererad åt dig, men du kan byta ut den mot en
// egen (se README-SETUP.md) om du vill.
self.VAPID_PUBLIC_KEY = "BFrcm5oKjKnIyLr58Cm38JEtmtJB5QuFBhOYvpYXYT1xpaWgwSixAtRIe6ZiQQ7gkBV-T1aUOE_kO_QssVWMECk";

// Lista alla i familjen som ska kunna välja sitt namn och ta emot notiser.
// Lägg till/ta bort namn här - fritt att ändra.
self.FAMILY_MEMBERS = [
  "Christos",
  "Ingela",
  "Zakis",
  "Xanthos",
  "Thalea",
  "Aqleia"
];

// Vilka av namnen ovan som får SKICKA meddelanden. Alla i FAMILY_MEMBERS kan
// fortfarande välja sitt namn och ta emot notiser - men bara de som står här
// nedan ser knapparna för att skicka. Detta kollas även på servern (se
// README-SETUP.md om miljövariabeln ALLOWED_SENDERS) så det går inte att
// kringgå genom att t.ex. öppna webbläsarens utvecklarverktyg.
self.ADMINS = ["Christos", "Ingela"];

// PIN-kod som krävs för att välja Christos respektive Ingelas namn, så att
// inte vem som helst kan trycka på ett adminnamn och skicka meddelanden i
// någon annans namn. Bara siffror, valfri längd. Sätt egna koder här.
// Samma koder måste sättas som miljövariabeln ADMIN_PINS på Vercel
// (se README-SETUP.md) - annars kollas PIN:en bara i appen, inte på servern.
self.ADMIN_PINS = {
  "Christos": "3030",
  "Ingela": "3030"
};

// Snabbknappar som visas i appen. Lägg till/ändra/ta bort valfritt.
self.QUICK_MESSAGES = [
  { label: "🍽️ Maten är klar!", text: "Maten är klar - kom ner!" },
  { label: "🛒 Jag handlar", text: "Jag handlar nu - säg till om du vill ha nåt!" },
  { label: "⏰ 5 minuter kvar", text: "5 minuter kvar tills det är dags!" },
  { label: "🏠 Är hemma", text: "Är hemma nu." }
];

// Valfritt enkelt "lösenord" så inte vem som helst som hittar länken kan skicka notiser.
// Sätt samma värde här som du sätter som miljövariabel APP_SECRET på Vercel.
// Lämna tomt ("") om du inte vill ha detta extra skydd.
self.APP_SECRET = "";
