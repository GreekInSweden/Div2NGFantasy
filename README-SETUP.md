# Familjenotiser - installationsguide (Supabase-version)

En privat PWA där familjemedlemmar kan skicka snabba notiser till varandra
("Maten är klar!", "Jag handlar - säg till om du vill ha nåt") - även när
mottagarens telefon har appen stängd.

Bygger på **Supabase** (databas, som du redan har sen tidigare) + **native
Web Push** (webbstandard, inget SDK från Google/Firebase behövs) +
**Vercel** (gratis hosting + den lilla servern som skickar notiserna).

Kostnad: **0 kr**. Inget kort krävs.

---

## Steg 1: Databasen i Supabase

Du kan antingen skapa ett nytt Supabase-projekt för det här, eller
återanvända ditt befintliga (tabellen `push_subscriptions` stör inte något
annat du har där).

1. Gå till https://supabase.com/dashboard och öppna (eller skapa) ditt
   projekt
2. Gå till **SQL Editor -> New query**
3. Klistra in innehållet från `supabase-setup.sql` (finns i projektet) och
   klicka **Run**. Det skapar tabellen `push_subscriptions` samt enkla
   säkerhetsregler.

### Hämta dina Supabase-nycklar
1. **Project Settings -> API**
2. Kopiera:
   - **Project URL** -> in i `config.js` som `SUPABASE_URL`
   - **anon public**-nyckeln -> in i `config.js` som `SUPABASE_ANON_KEY`
   - **service_role**-nyckeln -> sparas åt sidan, ska bara in som
     miljövariabel på Vercel i steg 3 (den ger fulla rättigheter - lägg
     den ALDRIG i klientkoden eller på GitHub)

---

## Steg 2: Fyll i `config.js`

Öppna `config.js` i projektet och fyll i:
- `SUPABASE_URL` och `SUPABASE_ANON_KEY` (från steg 1)
- `VAPID_PUBLIC_KEY` - **redan ifyllt**, ett nyckelpar är fördigenererat åt
  dig. Vill du generera ett eget går det med
  `npx web-push generate-vapid-keys` (kräver Node.js installerat) - byt då
  ut både den publika (i `config.js`) och privata (Vercel, steg 3)
- `FAMILY_MEMBERS` - lista med allas namn, t.ex.
  `["Christos", "Maria", "Elias", "Nora"]`
- `QUICK_MESSAGES` - redigera/lägg till snabbknappar om du vill
- `APP_SECRET` - valfritt, se "Extra skydd" längst ner

---

## Steg 3: Lägg upp på Vercel (gratis hosting)

1. Gå till https://vercel.com och skapa ett konto (går bra med GitHub,
   GitLab eller e-post - inget kort behövs för gratisplanen)
2. Enklast: skapa ett nytt GitHub-repo, lägg in alla filer från det här
   projektet, och importera det repot på Vercel ("Add New... -> Project").
   - Alternativt: installera Vercel CLI (`npm i -g vercel`) och kör `vercel`
     i projektmappen, följ instruktionerna.
3. **Innan du deployar**, lägg till miljövariabler i Vercel (Projektet ->
   **Settings -> Environment Variables**):

   | Variabel | Värde |
   |---|---|
   | `SUPABASE_URL` | Samma som i `config.js` |
   | `SUPABASE_SERVICE_ROLE_KEY` | service_role-nyckeln från steg 1 |
   | `VAPID_PUBLIC_KEY` | `BFrcm5oKjKnIyLr58Cm38JEtmtJB5QuFBhOYvpYXYT1xpaWgwSixAtRIe6ZiQQ7gkBV-T1aUOE_kO_QssVWMECk` (samma som i `config.js`, eller din egen om du genererat ny) |
   | `VAPID_PRIVATE_KEY` | `U68Vlt7Uz1tgHRCoHKxvBQgl0zixc8m1mFymuf0XP9Y` (**håll hemlig** - ligger bara här, aldrig i klientkoden) |
   | `VAPID_SUBJECT` | (Valfritt) t.ex. `mailto:din@epost.se` |
   | `APP_SECRET` | (Valfritt) samma värde som i `config.js` |
   | `ALLOWED_SENDERS` | (Valfritt) kommaseparerad lista över vilka namn som får skicka meddelanden, t.ex. `Christos,Ingela` - måste matcha `ADMINS` i `config.js` |
   | `ADMIN_PINS` | (Valfritt) PIN-koder som JSON, t.ex. `{"Christos":"1234","Ingela":"5678"}` - måste matcha `ADMIN_PINS` i `config.js` |

4. Deploya (Vercel gör det automatiskt vid varje push, eller kör `vercel --prod`)
5. Du får en URL, typ `https://familjenotiser.vercel.app` - det är den
   familjen ska öppna och lägga till på hemskärmen

> **Om VAPID-nycklarna ovan:** de är riktiga, färdiggenererade och fungerar
> direkt - jag skapade dem lokalt åt dig så du slipper ett extra steg. Bara
> den publika halvan (`VAPID_PUBLIC_KEY`) är avsedd att synas i klientkoden;
> den privata halvan ska bara finnas som miljövariabel på Vercel. Du kan när
> som helst byta ut båda mot ett eget nyckelpar om du vill.

---

## Steg 4: Testa

1. Öppna länken på din mobil (helst i Chrome/Safari)
2. **Lägg till på hemskärmen** (Dela -> "Lägg till på hemskärmen") så det
   fungerar som en riktig app
3. Öppna appen, välj ditt namn, tryck **"Aktivera notiser"** och tillåt
4. Testa att skicka ett snabbmeddelande till en annan familjemedlems
   telefon (eller be någon annan aktivera också)

**Obs för iPhone:** push-notiser för webbappar (PWA) på iOS fungerar bara om
appen är tillagd på hemskärmen och öppnas därifrån (inte i vanliga Safari-
fliken), samt kräver iOS 16.4 eller senare.

---

## Extra skydd (valfritt)

Appen har ingen inloggning - vem som helst med länken kan använda den, vilket
är tänkt eftersom det är en enkel privat familjeapp. Om du vill ha ett enkelt
extra skydd:
1. Sätt ett valfritt lösenord i `config.js` -> `APP_SECRET`
2. Sätt **samma värde** som miljövariabel `APP_SECRET` i Vercel
3. Då krävs den "nyckeln" för att skicka notiser via `/api/send`

Detta skyddar inte tabellen `push_subscriptions` i Supabase (den är öppen
för att slippa bygga inloggning) - dela därför inte appens URL offentligt.

---

## Lägga till/ta bort familjemedlemmar senare

Bara ändra listan `FAMILY_MEMBERS` i `config.js` och deploya om (push till
GitHub, eller `vercel --prod`). Klart.

## Vem får skicka meddelanden?

Alla i `FAMILY_MEMBERS` kan välja sitt namn och ta emot notiser, men bara de
som står listade i `ADMINS` (i `config.js`) ser knapparna för att skicka
meddelanden. Vill du ändra vilka det är:

1. Ändra listan `ADMINS` i `config.js`
2. Ändra miljövariabeln `ALLOWED_SENDERS` på Vercel till samma namn
   (kommaseparerat, t.ex. `Christos,Ingela`)
3. Deploya om

Steg 2 är viktigt - det är den som faktiskt stoppar obehöriga från att
skicka (steg 1 döljer bara knapparna i appen).

## Filöversikt

| Fil | Vad den gör |
|---|---|
| `index.html` / `style.css` / `app.js` | Själva appen (gränssnitt + logik) |
| `config.js` | Alla inställningar du fyller i - **börja här** |
| `sw.js` | Service worker - tar emot notiser i bakgrunden + gör appen installerbar |
| `manifest.json` | PWA-manifest (namn, ikon, färger) |
| `api/send.js` | Servern som faktiskt skickar push-notiserna (via `web-push`) |
| `supabase-setup.sql` | Skapar databastabellen och säkerhetsreglerna |
| `icons/` | App-ikoner (byt gärna ut mot egna) |
