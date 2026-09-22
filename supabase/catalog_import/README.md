# Katalogimport – hela Pokémon TCG-historiken

Detta är en **engångsimport** av alla Pokémon-set från Base Set (1999) fram
till dagens Mega Evolution/Scarlet & Violet-era, för att portfölj-/
önskelista-funktionen ska kunna täcka vilket kort en medlem än har.

## Vad det är – och inte är

- 168 set, ~19 250 kort, källa: den öppna och välunderhållna databasen
  [PokemonTCG/pokemon-tcg-data](https://github.com/PokemonTCG/pokemon-tcg-data).
- Allt importeras med `stock = 0`, `price_sek = 0` och `is_visible = false`
  på seten. Det betyder: **inget av detta dyker upp i butiken** eller går
  att köpa – det är rena referensdata för portföljen. De set ni redan sålt
  (Mega Evolution, Ascended Heroes, Chaos Rising osv) är avsiktligt
  uteslutna ur importen eftersom de redan finns i databasen.
- Rariteterna är en bästa-möjliga-mappning från källans råa text (43 olika
  varianter, allt från "Rare Holo" till "Radiant Rare") till våra tio
  raritetsnivåer. För enstaka udda kort från äldre eller ovanliga set kan
  klassningen bli fel – går enkelt att rätta i admin efteråt om något ser
  konstigt ut, precis som med de andra seten.
- Kortnummer som inte är rena siffror i originalet (typ "TG01" i Trainer
  Gallery-set eller "SWSH001" i vissa kampanjset) har fått ett internt
  unikt nummer så de inte krockar med varandra – det är bara en teknisk
  detalj i databasen, syns inte för medlemmarna.
- **Holo-only rariteter**: kort med rariteten "Rare" i gamla set (t.ex.
  Base Sets Alakazam, Blastoise, Chansey) visas bara som "Holo" och
  "Reverse Holo" — aldrig "Normal". Det stämmer historiskt: de här korten
  gavs faktiskt aldrig ut i ett vanligt icke-holo-tryck, holo-versionen
  ÄR grundtrycket. Samma modell används för alla set, inte bara Base.
- **Reverse Holo fanns inte förrän Neo Destiny (2002)**. Set äldre än
  det (Base, Jungle, Fossil, Team Rocket, Base Set 2, Gym Heroes/
  Challenge, Neo Genesis/Discovery/Revelation, Wizards-promosen) erbjuder
  därför bara "Holo"/"Normal", inte "Reverse Holo" — det alternativet
  fanns helt enkelt inte att trycka på den tiden.

## Körordning

Kör **efter** de tre medlemsmigrationerna (`member_accounts.sql` →
`member_security.sql` → `member_portfolio.sql`), i valfri ordning sinsemellan
– filerna är oberoende av varandra. Kör en fil i taget i Supabase SQL
Editor:

```
base.sql
gym.sql
neo.sql
e-card.sql
ex.sql
diamond-pearl.sql
platinum.sql
heartgold-soulsilver.sql
black-white.sql
xy.sql
sun-moon.sql
sword-shield.sql
scarlet-violet.sql
mega-evolution.sql
pop.sql
np.sql
other.sql
```

Varje fil är fristående och säker att köra flera gånger (använder
`on conflict ... do nothing` överallt), så inget krånglar sig om något
skulle behöva köras om.

Störst fil är `sword-shield.sql` på ca 380 kB text – inga problem för SQL
Editorn, men ha tålamod, det är många rader.

**Har du redan kört en tidigare version** av `base.sql`, `gym.sql` eller
`neo.sql` (innan Reverse Holo-fixen ovan fanns)? Kör i så fall
`../catalog_import_reverse_holo_cleanup.sql` en gång för att städa bort
de felaktigt tillagda Reverse Holo-alternativen för de här seten. Har du
inte kört importen än, eller kör den för första gången nu, kan du
ignorera den filen helt — de nya set-filerna gör redan rätt från början.

## Efter importen

Sidan `/konto/portfolj` listar numera alla set (inte bara de synliga i
butiken) med ett sökfält, eftersom listan annars hade blivit väldigt lång.
