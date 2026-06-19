# Fantasy Div2 Norra Götaland — webbapp

En fristående webbsida för din fantasy-liga, kopplad till din Supabase-databas.
Ingen byggprocess krävs — det är en enda `index.html`-fil.

## Publicera på Vercel (rekommenderat, gratis)

### Alternativ A — via GitHub (rekommenderas)
1. Gå till **github.com** → "New repository" → ge det ett namn, t.ex. `fantasy-div2ng` → skapa (välj "Public" eller "Private", spelar ingen roll)
2. Klicka **"uploading an existing file"** på repots sida
3. Dra in filen `index.html` från den här mappen → "Commit changes"
4. Gå till **vercel.com** → "Add New..." → "Project"
5. Välj ditt nyss skapade GitHub-repo → "Import"
6. Lämna alla inställningar som standard → klicka **"Deploy"**
7. Efter ca 30 sekunder får du en länk typ `https://fantasy-div2ng.vercel.app` — klar!

### Alternativ B — via Vercel CLI (om du är van vid terminalen)
```
npm install -g vercel
cd fantasy-div2ng-web
vercel
```
Följ instruktionerna i terminalen.

## Lägg till eget domännamn (valfritt)
I Vercel-projektet → "Settings" → "Domains" → lägg till din egen domän om du har en.

## Säkerhet att känna till
- Admin-lösenordet (`div2ng25`) ligger synligt i koden eftersom det är en enkel klientsidesapp. Byt det gärna till något eget genom att redigera raden `const ADMIN_PWD = "..."` i `index.html` innan du laddar upp. Det skyddar mot vanliga användare men inte mot någon som aktivt letar i sidans källkod — fullgott för en vänskaplig liga, men inte en riktig autentisering.
- Supabase "anon key" är designad för att vara synlig i frontend-kod — det är standard och säkert så länge dina policyer (Row Level Security) är rimliga.

## Ändra saker senare
All spelar-, lag- och resultatdata sparas i Supabase. Du kan när som helst:
- Redigera `index.html` och ladda upp en ny version till GitHub (Vercel uppdaterar automatiskt)
- Gå in direkt i Supabase ("Table Editor") för att se eller ändra data manuellt
