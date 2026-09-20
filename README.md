# Kortlagret

En enkel butik för att sälja lösa Pokémonkort styckvis. Kunder väljer
kategori (t.ex. "Mega Evolution") → set (t.ex. "Pitch Black") → klickar på
enskilda kort → väljer variant (vanligt/holo) och antal → går till kassan →
betalar manuellt via Swish.

Byggt med **Next.js** (Vercel), **Supabase** (databas) och vanlig **Swish**
(inget företagsavtal krävs för att börja — kunden swishar manuellt och du
bekräftar).

## 1. Sätt upp Supabase

1. Skapa ett nytt projekt på [supabase.com](https://supabase.com).
2. Gå till **SQL Editor** → **New query**, klistra in innehållet i
   `supabase/schema.sql` och kör det. Det skapar alla tabeller.
3. Kör därefter `supabase/seed_pitch_black.sql` i en ny query — det lägger in
   Pitch Black-setet och alla 120 kort (både vanlig och holo-variant), med
   **stock = 0** på allihop.
4. Gå till **Project Settings → API** och notera:
   - `Project URL` → blir `NEXT_PUBLIC_SUPABASE_URL`
   - `anon public` key → blir `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `service_role` key → blir `SUPABASE_SERVICE_ROLE_KEY` (håll hemlig!)

## 2. Sätt upp admin-inloggningen

Adminpanelen (`/admin`) är den snabbaste vägen att fylla i lager och lägga
upp bilder — sökbar lista med +/− knappar och ett fält per kort/variant,
mycket smidigare än att klicka runt i Supabase när ni just öppnat en hög
paket.

1. Kör `supabase/admin_policies.sql` i Supabase SQL Editor (efter
   `schema.sql` och `seed_pitch_black.sql`). Det ger inloggade användare
   rätt att uppdatera lagersaldo — utan den här filen går det inte att
   spara ändringar i adminpanelen.
2. Kör därefter `supabase/image_support.sql` — den lägger till bildstöd
   (kolumnen `image_url` samt en publik lagringsplats för foton).
3. Gå till **Authentication → Users** i Supabase, klicka **Add user**,
   fyll i din e-post och ett lösenord. Bocka gärna i "Auto Confirm User"
   så slipper du bekräfta via mejl. Det här kontot är ditt admin-login —
   det finns inget separat registreringsformulär i appen, med flit.
4. Gå till `dinsida.vercel.app/admin`, logga in med kontot du skapade.

## 3. Lägg in lager och bilder

**Snabbast — adminpanelen:** Logga in på `/admin`, välj ett set, sök fram
kortet, klicka +/− eller skriv siffran direkt i rutan för Vanligt/Holo,
klicka **Spara ändringar**. Perfekt när du suttit och sorterat en hög
nyöppnade paket och ska mata in allt på en gång.

**Bilder:** Klicka på den lilla bildrutan längst till vänster på ett kort i
adminlistan för att ladda upp ett foto av det faktiska kortet — det ersätter
platshållaren (kortnumret på en färgad ruta) både i adminlistan och ute i
butiken. En bild per kort räcker (inte en per exemplar), eftersom flera
likadana kort ser identiska ut.

**Massuppladdning (för många kort på en gång):** Klicka **"Massuppladdning
av bilder"** uppe i lagerredigeraren för ett set. Där kan du släppa in eller
välja hur många bilder som helst samtidigt:
- Bilder vars filnamn innehåller ett kortnummer (t.ex. `004.jpg` eller
  `IMG_20260906_017.jpg`) paras automatiskt ihop med rätt kort (grön kant).
- Resten (röd, streckad kant) klickar du på en i taget, söker fram rätt
  kort i listan som dyker upp, och klickar — sidan hoppar automatiskt
  vidare till nästa otilldelade bild så det går snabbt.
- Manuellt hopparade bilder får blå kant, så du ser skillnad på vad
  sidan gissade och vad du bestämt själv.
- Klicka **"Ladda upp X bilder"** när alla (eller så många du orkat para
  ihop just nu) är klara — resten kan du spara till nästa gång.

Ni behöver **inte** fotografera alla 120 kort på en gång — lägg bara upp
bilder efter hand, i den takt ni ändå går igenom korten för att fylla i
lager. Kort utan bild visar en enkel färgad platshållare istället, helt
fungerande men mindre snyggt.

**Alternativet — direkt i Supabase:** Table Editor → `card_variants` för
lager, eller `cards` för att klistra in en bild-URL direkt i kolumnen
`image_url` om ni redan har bilder liggande någon annanstans.

Oavsett metod: kort med `stock = 0` visas gråa och går inte att klicka på i
butiken — så fort saldot är över 0 dyker kortet upp som köpbart, automatiskt.

## 4. Kör lokalt

```bash
npm install
cp .env.local.example .env.local
# fyll i dina Supabase-nycklar och ditt Swish-nummer i .env.local
npm run dev
```

Öppna http://localhost:3000

## 5. Lägg upp på GitHub

```bash
git init
git add .
git commit -m "Första versionen av Kortlagret"
git branch -M main
git remote add origin https://github.com/DITT-ANVÄNDARNAMN/kortlagret.git
git push -u origin main
```

## 6. Deploya på Vercel

1. Gå till [vercel.com/new](https://vercel.com/new), importera GitHub-repot.
2. Under **Environment Variables**, lägg in samma fyra variabler som i
   `.env.local` (URL, anon key, service role key, Swish-nummer).
3. Klicka **Deploy**. Klart — sidan är live.

## 7. Sätt upp auktioner (för de mest värdefulla korten)

Utöver fastprisbutiken kan riktigt värdefulla enskilda kort (t.ex. en
Special Illustration Rare) säljas via bud istället.

1. Kör `supabase/auctions.sql` i Supabase SQL Editor (efter alla tidigare
   migrationer), och därefter `supabase/reserve_price.sql`.
2. Gå till `/admin/auktioner` → **+ Ny auktion**. Välj set, kort och
   variant (Vanligt/Holo), sätt ett utropspris (det budgivningen börjar
   från, syns publikt), ett valfritt **reservationspris** (ditt dolda
   verkliga minimipris — syns aldrig för kunder), minsta höjning per bud,
   och när auktionen ska sluta.
3. Kunder ser och budar på öppna auktioner på `/auktioner` — ingen inloggning
   krävs för att buda, bara namn, e-post, telefon och belopp.
4. Sidan uppdaterar högsta bud automatiskt var 20:e sekund, så det känns
   nästan live utan att vara en fullständig realtidslösning.
5. När auktionen är slut, gå till `/admin/auktioner` för att se alla bud
   med namn, e-post och telefon — högst upp markerat med 🏆, samt om ditt
   reservationspris är uppnått eller inte. Om det inte är uppnått är du
   inte skyldig att sälja — hör av dig till budgivaren och fråga om de vill
   höja, eller låt auktionen bara avslutas utan affär. Kontakta vinnaren
   för Swish-betalning precis som med vanliga beställningar när du bestämt
   dig, och klicka **"Markera som avslutad"** när det är klart.

Budgivares kontaktuppgifter syns bara för dig som inloggad admin, aldrig
för andra besökare på auktionssidan — bara det aktuella högsta beloppet
och antal bud visas publikt.

1. Kund lägger kort i varukorgen och fyller i sina uppgifter i kassan.
2. En order skapas i Supabase (`orders`-tabellen) med status
   `pending_payment`, och lagersaldot för de köpta korten minskas direkt.
3. Kunden ser din **Swish QR-kod** (från er uppladdade bild
   `public/swish-qr.png`) samt Swish-nummer och ordernummer i text.
   Kunden scannar koden för att öppna Swish med numret ifyllt, och skriver
   själv in belopp och ordernummer som meddelande.
4. Du kollar Swish-appen, matchar betalningen mot ordernumret, och ändrar
   ordern till `status = 'paid'` i Supabase Table Editor (tabell `orders`).
5. Du packar och skickar.

Vill ni byta QR-bild senare (nytt Swish-nummer, ny design) — ersätt bara
filen `public/swish-qr.png` med en ny och ladda upp den till GitHub, ingen
kodändring behövs.

Vill ni längre fram automatisera steg 3 (så belopp och meddelande fylls i
automatiskt när kunden scannar) eller steg 4 (markera som betald)
automatiskt, krävs ett Swish-handelsavtal via en betalväxel (t.ex.
Swedbank Pay eller Trustly) — hör av er så bygger vi på med det när ni är
redo för det steget.

## 8. Lägga till bonus- och promokort (utan officiell numrering)

ETB:er, blisters och tenn-boxar innehåller ofta ett extra promo-kort som
inte hör till setets vanliga 1-120-numrering (t.ex. ett Zarude- eller
Binacle-kort som såg annorlunda ut). Så lägger ni in dem:

1. Kör `supabase/promo_rarity.sql` i Supabase SQL Editor (lägger till
   "Promo" som en giltig korttyp).
2. Gå till `/admin/nytt-set`, skapa en kategori (t.ex. "Bonuskort & Promos")
   och ett set (t.ex. "Black Star Promos") en gång — dit går sedan alla
   framtida lösa promokort, oavsett vilken produkt de kom från.
3. Gå till det nya setet i `/admin`, klicka **"+ Nytt kort"**, fyll i namn,
   typ (välj "Promo"), pris och antal i lager. Bocka i "holo-variant" bara
   om kortet faktiskt finns i två utföranden.

Samma **"+ Nytt kort"**-knapp funkar för att lägga till fler kort i vilket
set som helst, inte bara promo-setet — praktiskt om ni t.ex. vill komplettera
Pitch Black med ett kort som saknades i ursprungslistan.

## 9. Dölja/visa set (förbered i bakgrunden)

Nya set du lägger till via `/admin/nytt-set` startar automatiskt **dolda**
— de syns i `/admin` som vanligt så du kan fylla i lager och bilder, men
dyker inte upp i butiken förrän du är redo.

1. Kör `supabase/set_visibility.sql` i Supabase SQL Editor.
2. På `/admin`-startsidan har varje set nu en knapp — **"Synlig — dölj"**
   eller **"Dold — visa"** — klicka för att växla när du vill.

## 10. Färdiga seed-filer för fler Mega Evolution-set

Utöver Pitch Black finns nu färdiga seed-filer för:

- **Chaos Rising (ME04)** — `supabase/seed_chaos_rising.sql`, 122 kort
- **Phantasmal Flames (ME02)** — `supabase/seed_phantasmal_flames.sql`, 130 kort
- **Mega Evolution (ME01, grundsetet)** — `supabase/seed_mega_evolution_base.sql`, 188 kort
- **Ascended Heroes (ME2.5)** — `supabase/seed_ascended_heroes.sql`, 295 kort (historiens största Pokémon-set!)
- **Perfect Order (ME03)** — `supabase/seed_perfect_order.sql`, 124 kort

Kör valfri fil i Supabase SQL Editor (efter `set_visibility.sql`) för att
lägga till hela setet med korrekt namn, nummer och sällsynthet på en gång —
precis som med Pitch Black. Alla fem läggs in **dolda** automatiskt (se
punkt 9 ovan), så de stör inte butiken förrän ni faktiskt har kort i lager.

Hela Mega Evolution-serien är nu representerad, från ME01 till ME05
(Pitch Black). Nästa set i serien, **Delta Reign (ME06)**, väntas
6 november 2026 — hör av er när det är dags.

## 11. Sammanfattning — sätt att lägga till ett nytt set

- **Ett fåtal kort (t.ex. en promo-samling):** använd `/admin/nytt-set` +
  `/admin/[setSlug]/nytt-kort` som beskrivs ovan — helt utan att röra
  Supabase direkt.
- **Ett helt nytt huvudset med massor av kort:** snabbast är en seed-fil
  likt `seed_pitch_black.sql`, `seed_chaos_rising.sql` eller
  `seed_phantasmal_flames.sql`. Hör av er så genererar vi en för nästa set.

Sidan plockar upp nya kategorier/set automatiskt oavsett metod — ingen
kodändring behövs.

## 12. Se totalt lagervärde

Gå till `/admin/lagervarde` (länk i admin-menyn) för att se vad ni skulle
få in om allt som just nu finns i lager såldes till satta priser — totalt,
och uppdelat per set. Kort med 0 i lager räknas inte med. Klicka på ett
set i listan för att hoppa direkt till dess lagerredigerare.

Ingen ny SQL-fil behövs för det här — det är bara en ny sida som räknar
ihop siffror ni redan har i databasen (`stock × pris` för varje kort).

## 13. Hantera obetalda beställningar (undvik att lagret "försvinner")

Lagersaldot dras av **direkt när en order skapas**, innan betalning är
bekräftad — annars skulle två kunder kunna "köpa" samma sista exemplar
samtidigt. Det betyder att en påbörjad men aldrig betald beställning binder
upp korten tills du gör något åt det.

1. Kör `supabase/order_admin_policies.sql` i Supabase SQL Editor.
2. Gå till `/admin/bestallningar` (länk i admin-menyn) för att se alla
   beställningar — obetalda högst upp, med tidsstämpel så du ser hur
   gamla de är.
3. För varje obetald order: klicka **"Markera betald"** när Swish-pengarna
   kommit in, eller **"Avbryt & lägg tillbaka i lager"** om kunden aldrig
   betalade — det återställer automatiskt lagersaldot för alla kort i den
   ordern.

**Ingen automatisk "loop"-risk finns** — varje klick på "Beställ" i kassan
skapar exakt en order, och varukorgen töms direkt efteråt. Risken är
istället att flera *olika* övergivna försök över tid binder upp lager utan
att synas någonstans — därför är den nya sidan tänkt att kollas igenom med
jämna mellanrum (t.ex. någon gång per dag), inte bara vid problem.

## 14. MEP Black Star Promos (löpande promoserie)

Till skillnad från huvudseten är det här **inte** en stängd, färdig lista —
Pokémon Company lägger till fler promokort varje gång en ny Mega Evolution-
produkt släpps, så den växer kontinuerligt.

1. Kör `supabase/delete_old_promo_set.sql` först (tar bort det gamla
   manuellt ihopsatta setet "MEP Black Star Promos Singles" — kort och
   lager för Zarude/Binacle försvinner, fylls i på nytt i steg 3).
2. Kör därefter `supabase/seed_mep_promos.sql` — lägger in 88 kort
   (MEP 001–088, alla hittills existerande promos t.o.m. Zarude från
   Pitch Black-ETB:n). Setet läggs in dolt som vanligt.
3. Fyll i lager/pris för de kort ni faktiskt har, precis som med övriga
   set. Ett kort saknas medvetet — en onumrerad "Pikachu at the Museum"-
   promo som inte passar det vanliga sifferschemat. Lägg till den för
   hand via **"+ Nytt kort"** om ni råkar få tag i den.
4. Nästa gång ett nytt promo-kort dyker upp (t.ex. med Delta Reign i
   november) — lägg bara till det enskilt via **"+ Nytt kort"** i det här
   setet, precis som ni redan gjorde med Zarude och Binacle. Ingen ny
   seed-fil behövs för enstaka tillskott.

## 15. Topps Premier League 2026/27 (fotbollskort, ny kategori)

Samma system som Pokémon-korten fungerar utmärkt för fotbollskort också.
Eftersom Topps inte har samma sällsynthetsnivåer som Pokémon (ingen
"Illustration Rare" osv.) finns två generella nivåer istället: **Grundkort**
och **Insert** (för temaserier som Beast Mode).

1. Kör `supabase/topps_rarity.sql` i Supabase SQL Editor (lägger till
   "Grundkort" och "Insert" som giltiga korttyper).
2. Kör därefter valfri/alla av dessa fyra seed-filer, i valfri ordning:
   - `supabase/seed_topps_pl_base.sql` — Grundset (Base + Future Stars), 300 kort
   - `supabase/seed_topps_pl_beastmode.sql` — Beast Mode-insert, 25 kort
   - `supabase/seed_topps_pl_8bitballers.sql` — 8-Bit Ballers-insert, 20 kort
   - `supabase/seed_topps_pl_chromeclassics.sql` — Chrome Classics-insert, 25 kort
   - `supabase/seed_topps_pl_nitroboost.sql` — Nitro Boost-insert, 25 kort
   - Plus 18 ytterligare insert-serier (samtliga filer med prefixet
     `seed_topps_pl_`) — se listan i mappen `supabase/` för alla namn
     (All Kings, Billboard Material, Black Edge, Carpe Diem, Diamond
     Rookies, Flying The Flag, Gold Lion, Golden Boot, Home Pitch, Mayhem,
     On Fire, Perfect 10, Perfect Storm, Quasar, Remember the Name, Retro
     Threads, Stars of the Premier League, The Rise, Ultra Beast Mode,
     Vibes)

   **Två serier är medvetet uteslutna:** "True Gold Lion" (varje kort är
   ett unikt 24-karats guldkort, inlöses individuellt — passar inte ett
   vanligt lagersystem med antal) och "Marks of Excellence" (finns bara
   som signerade autografkort, ingen vanlig "bas"-version att sälja).
   Hör av er om ni ändå får tag i något av dessa så löser vi det som
   ett enskilt kort via "+ Nytt kort".
   - `supabase/seed_topps_pl_nitroboost.sql` — Nitro Boost-insert, 25 kort
3. Alla fyra läggs in **dolda** under en ny kategori "Topps Premier League
   2026/27" (samma dölj/visa-system som Pokémon-seten). Fyll i lager,
   pris och bilder i `/admin` precis som vanligt — samma
   massuppladdningsverktyg för bilder fungerar identiskt.

**Skillnad mot Pokémon-korten:** bara en **normal**-variant skapas per
kort, ingen holo — Topps fotbollskort har inte det begreppet. Vill ni sälja
en specifik parallellversion eller autografkort separat, lägg till det som
ett eget kort via **"+ Nytt kort"** (t.ex. "Alexander Isak — Gold Parallel
/50") snarare än som en variant av grundkortet.

**Kommer senare om ni vill:** fler insert-serier (All Kings, Black Edge,
Diamond Rookies m.fl.) och parallellversioner — hör av er så genererar vi
fler seed-filer på samma sätt.

## 16. Destined Rivals (Scarlet & Violet, ny kategori)

Destined Rivals hör till Scarlet & Violet-eran (inte Mega Evolution), så
det blir en helt ny kategori i butiken: "Scarlet & Violet".

1. Kör `supabase/seed_destined_rivals.sql` i Supabase SQL Editor (efter de
   vanliga grundmigrationerna — schema.sql, set_visibility.sql osv.).
2. Setet läggs in **dolt** som vanligt, 244 kort totalt (182 grundkort +
   62 secret rares, inklusive alla 11 Special Illustration Rares och de
   4 Hyper Rares — bland dem Team Rocket's Mewtwo ex, samma kort ni redan
   sett i chatten).

**Notis om etiketten "Hyper Rare":** den hette tidigare "Mega Hyper Rare"
i systemet (döpt efter Mega Evolution-seten), men eftersom Destined Rivals
inte har några Mega-kort bytte vi till den mer generella termen "Hyper
Rare" — gäller nu automatiskt för alla set, inklusive de gamla.

## Struktur

```
app/
  page.tsx                    Startsida — kategorier
  [category]/page.tsx         Set-lista inom en kategori
  [category]/[setSlug]/page.tsx   Kortgrid (5 per rad) för ett set
  kassa/page.tsx               Varukorg + kundformulär
  order-confirmed/page.tsx     Swish-instruktioner
  auktioner/page.tsx            Publik auktionssida med budformulär
  api/swish-qr/route.ts          Genererar Swish-QR (belopp+meddelande) per order
  api/checkout/route.ts        Skapar order + drar av lager (server-side)
  api/auctions/route.ts         Listar öppna auktioner (utan budgivar-info)
  api/bid/route.ts               Tar emot och validerar bud (server-side)
  admin/login/page.tsx          Adminlogin
  admin/(dashboard)/page.tsx    Adminstartsida — välj set
  admin/(dashboard)/[setSlug]/page.tsx   Lagerredigering för ett set
  admin/(dashboard)/[setSlug]/bilder/page.tsx  Massuppladdning av bilder
  admin/(dashboard)/auktioner/page.tsx   Alla auktioner + budgivarkontakt
  admin/(dashboard)/auktioner/ny/page.tsx  Skapa ny auktion
  admin/(dashboard)/nytt-set/page.tsx       Skapa ny kategori/set
  admin/(dashboard)/[setSlug]/nytt-kort/page.tsx  Lägg till enskilt kort/promo
  admin/(dashboard)/lagervarde/page.tsx      Totalt lagervärde, per set
  admin/(dashboard)/bestallningar/page.tsx    Alla ordrar, markera betald/avbryt
components/
  CardGrid.tsx / CardModal.tsx  Interaktivt kortval + sök/filter
  CardImage.tsx                  Bild med platshållare
  SiteHeader.tsx                Header med varukorg + auktionslänk
  admin/StockEditor.tsx          Sökbar lagerredigerare med snabbknappar
  admin/BulkImageUploader.tsx    Massuppladdning, auto-matchning av filnamn
  admin/NewAuctionForm.tsx        Formulär för att skapa en auktion
  admin/CloseAuctionButton.tsx    Markera auktion som avslutad
  admin/NewSetForm.tsx             Formulär för att skapa nytt set/kategori
  admin/NewCardForm.tsx            Formulär för att lägga till ett kort
  admin/ToggleSetVisibilityButton.tsx  Visa/dölj-knapp för ett set
  admin/OrderActions.tsx           Markera betald / avbryt & återställ lager
  admin/LogoutButton.tsx         Loggar ut ur adminpanelen
lib/
  CartContext.tsx               Varukorg (localStorage)
  supabaseClient.ts              Publik klient (läsning, butik)
  supabaseAdmin.ts                Service-role-klient (endast i API-routes)
  supabase/server.ts              Inloggad admin-klient (Server Components)
  supabase/browser.ts             Inloggad admin-klient (webbläsaren)
middleware.ts                    Skyddar /admin — kräver inloggning
supabase/
  schema.sql                     Databastabeller + policys
  seed_pitch_black.sql           Pitch Black, alla 120 kort
  admin_policies.sql              Ger inloggad admin rätt att spara lager
  image_support.sql               Bildkolumn + lagringsplats för kortfoton
  auctions.sql                    Auktioner + bud, med skyddad budgivarinfo
  reserve_price.sql                Dolt reservationspris (minimipris)
  promo_rarity.sql                  Lägger till "Promo" som korttyp
  order_admin_policies.sql           Ger admin läs/skrivrätt på beställningar
  delete_old_promo_set.sql            Tar bort gamla manuella promo-setet
  seed_mep_promos.sql                 MEP Black Star Promos, 88 kort (MEP 001-088)
  set_visibility.sql                 Dölj/visa-funktion för set
  seed_chaos_rising.sql              Chaos Rising, alla 122 kort
  seed_phantasmal_flames.sql         Phantasmal Flames, alla 130 kort
  seed_mega_evolution_base.sql       Mega Evolution (ME01), alla 188 kort
  seed_ascended_heroes.sql           Ascended Heroes (ME2.5), alla 295 kort
  seed_perfect_order.sql             Perfect Order (ME03), alla 124 kort
  topps_rarity.sql                    Lägger till "Grundkort"/"Insert" som korttyper
  seed_topps_pl_base.sql              Topps PL Grundset, 300 kort
  seed_topps_pl_beastmode.sql         Topps PL Beast Mode-insert, 25 kort
  seed_topps_pl_8bitballers.sql       Topps PL 8-Bit Ballers-insert, 20 kort
  seed_topps_pl_chromeclassics.sql    Topps PL Chrome Classics-insert, 25 kort
  seed_topps_pl_nitroboost.sql        Topps PL Nitro Boost-insert, 25 kort
  seed_topps_pl_*.sql                  18 fler insert-serier (se ovan)
  seed_destined_rivals.sql            Destined Rivals (Scarlet & Violet), 244 kort
```
