// Enkel på/av-flagga för att tillfälligt pausa lagret (bläddra/köp lösa
// kort ur egen samling) utan att röra någon data. Sätt tillbaka till
// true och deploya för att slå på lagret igen -- inget i Supabase
// behöver ändras, ingenting raderas.
//
// Påverkar INTE auktioner, portfölj/matchningar eller meddelanden --
// bara själva "bläddra och köp ur vårt lager"-delen av sidan.
export const LAGER_ENABLED = false;
