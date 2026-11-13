# Task 015 — changelog

13 novembre 2026. Schermate in `design/handoff/015/Coda e attesa 015.dc.html`; screenshot in `screenshots/` (360 dp e 744 dp, nomi parlanti) e `screenshots/de-testo-2/` (tedesco, testo 2,0, stato iniziale e stato scrollato). Solo righe aggiunte in `tokens.dart`. `tokens.diff.md` non rigenerato. Decisioni rispettate: D-007, D-019, D-025, D-029, D-034.

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| tokens.dart | BaCodaTokens (nuova) | — | interruttore (da BaCreazioneTokens), riga sp14 e uscita sp11, gruppo 8 con presenze sp8 e gap sp1_5, banda (riquadro, border1), durate 30 s / 3 min / 60 min come eccezioni, `oraDelPosto` | punti 1–8; D-019 |
| BA · Token | T6 ter | — | 7 righe nuove con nome e «dove» (coda/interruttore, riga, gruppo, banda, posto-conservato, permanenza, persa) | punto 8 |
| BA · decisioni consolidate | 5.C (nuova) | — | code, sotto-DEN d'attesa, posto conservato, permanenza massima | punto 8 |
| BA · Inventario | dopo BaFoglioGestisci | — | BaInterruttoreRiga, BaRigaCoda, BaFasciaAttesa, BaBandaPosto | punti 1, 2, 3, 4 |
| BA · Fase 2 schermate | prima di 5a | — | rimando alle superfici di sistema del 015 | punto 8 |
| suono-e-vibrazione.md | tabella | — | due righe: posto libero con ingresso manuale (notifica di sistema, nessun segnale dell'app); posto passato al ritorno della linea (suono senza vibrazione, ipotesi) | punto 2: due eventi nuovi |
| handoff/015 | Coda e attesa 015 | — | K1–K5 (code, mettiti in coda ×3, notifiche, stanza), W1–W3 (gruppo d'attesa), P1–P3 e M1 (posto conservato, permanenza), S1–S3 (stati) | punti 1–7 |

## Ipotesi segnate (si tolgono con `segniIpotesi`)

- Il sotto-DEN d'attesa è a scelta, non predefinito (K2 ter, W1).
- Per il Pro il posto conservato è di 3 minuti, per il Free 30 secondi (P1 bis; «3 o 5 minuti»: si usa 3).
- B05 vale per chi sta fra il pubblico, ed è «in revisione» (M1).
- Il numero massimo di code insieme non è deciso (K1, S1): mai mostrato.
- Mia: al ritorno con il posto passato niente vibrazione di «spento» (suono-e-vibrazione.md).

## Dove il brief ostacola

- **Il glossario non ha «sotto-DEN d'attesa» né «gruppo d'attesa».** Il task vieta di cambiarlo. Nell'interfaccia dico «Aspetta con altri» e «gruppo» e uso «sotto-DEN d'attesa» solo nei documenti. Vanno aggiunti prima del codice.
- **«Chi non ha questa capacità non vede nulla» contro «Free 30 secondi, Pro 3 minuti».** La schermata del posto conservato è identica; cambia l'ora. Il segno «ipotesi · per il Pro…» è un'annotazione di progetto: va tolto prima del codice, perché nomina il piano.
- **Il Pro non si può nascondere del tutto.** «Aspetta con altri» ha una riga in più: chi la vede sa di averla, ma nessun altro lo vede. Nessuna etichetta e nessun invito per gli altri.
- **K4 è uno stato nuovo della stanza («Si è liberato un posto»).** Il task vieta di cambiare gli stati del 002. Non cambia nessuno stato esistente, ma il 002 non lo prevede: da confermare.
- **«Esci dalla coda» sta in «Le tue code», non nella barra.** Nella barra resta quella del 002 (Esci, azione, «Altro»).
- **Stato «persa» e tempo.** La banda dice solo un'ora; non mostra quando finisce il Pro rispetto al Free. 30 secondi si arrotondano al minuto successivo: «fino alle 21:41» può durare meno di un minuto.
- **Numero massimo di code e coda piena.** S1 e S2 sono frasi senza numero; il comportamento reale non è deciso.
