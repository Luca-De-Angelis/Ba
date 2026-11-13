# Task 015b — changelog

13 novembre 2026. Il resto del 015 non è toccato. `tokens.diff.md` non rigenerato. Screenshot rifatti: tutte le schermate della stanza e «Mettiti in coda» (360 e 744 dp), più `screenshots/de-testo-2/barra-*` (tedesco, testo 2,0, barra con le secondarie una sotto l'altra).

| Punto | Prima | Dopo | Motivo |
| --- | --- | --- | --- |
| 1 · Barra | tre pillole in colonna, «Esci» e «Altro» da 48 sulla riga sotto, due righe nel gruppo | la primaria sopra a tutta larghezza; sotto, le due secondarie (o «Esci» sola, quando il palco non c'è) con «Altro» a destra; nelle schermate con il palco c'è «Scendi dal palco» | è la barra del 002 e del codice |
| 2 · «Mettiti in coda» | chiara nella schermata di uscita, attiva (filetto) nelle altre, e chiara in K2 | con filetto ovunque, anche nei passi K2 e nell'uscita dalla coda | BaRegole 1: qui si può restare fra il pubblico |
| 3 · Tempo del posto conservato | «fino alle 21:41», arrotondato al minuto successivo; `oraDelPosto` restituiva un'ora anche per 30 secondi | sotto i due minuti: «Il posto resta tuo ancora per un momento» (DE: «Dein Platz bleibt noch einen Moment deiner»); da due minuti: «fino alle 21:43», arrotondata per difetto. `oraDelPosto` ora restituisce `DateTime?` (nulla sotto `sogliaMomento`, 2 min) e tronca al minuto | il tempo non promette mai più del reale; la stessa banda regge i due casi |
| 4a · T11 | nessuna regola della barra | paragrafo «Barra delle azioni con testo grande»: se la parola più lunga non entra, le secondarie vanno una sotto l'altra a tutta larghezza e «Altro» sta a destra sulla riga dell'ultima; pillole della stessa riga alla stessa altezza; nessuna parola si spezza | regola mancante dalla consegna |
| 4b · «Altro» | punti e filetto senza token | `BaBarraAzioniTokens.altroPuntoLato` (sp1), `altroPuntoGap` (3, eccezione), `altroBordo` (a32 su pietra100); T6 ter: `barra/altro-punti` e `coda/momento` | il filetto era 0,30 nel 002: ora a32, la primitiva che c'è già |

## Dove il brief ostacola

- **Il filetto di «Altro» da 0,30 a 0,32.** Due punti di opacità non si vedono, ma è un valore che cambia rispetto al 002. Se serve 0,30 va aggiunta una primitiva: oggi non esiste e `filettoMarcato` è a 0,14.
- **«Non cambiare nient'altro» e il codice del palco.** La regola dell'impilamento è disegnata con una misura approssimata (larghezza media del carattere × 0,52): il codice deve misurare il testo.
- **Le 8 schermate della stanza ora hanno «Scendi dal palco»** solo dove si è sul palco; nelle altre c'è «Esci» e «Altro».
