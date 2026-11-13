# Task 014 — changelog

13 novembre 2026. Schermate in `design/handoff/014/Creare DEN 014.dc.html`; screenshot in `screenshots/` (360 dp e 744 dp, nomi parlanti) e `screenshots/de-testo-2/` (tedesco, testo 2,0, stato iniziale e stato scrollato in fondo). Solo righe aggiunte in `tokens.dart`: nessun valore esistente cambiato. `tokens.diff.md` non rigenerato. Decisioni rispettate: D-005, D-007, D-011, D-019, D-024, D-031.

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| tokens.dart | BaCreazioneTokens (nuova) | — | scelta (sp14, rounded2xl, border1/border2), chip (sp12, sp2, roundedFull), descrizione 96, aggancio (sp12, rounded2xl, border1), interruttore del «quando» (sp11 × 26, pallino sp4), co-amministratori 1 e 3 | punti 1, 4, 7, 9; D-019 |
| BA · Token | T6 ter | — | 7 righe nuove con nome e «dove» (creazione/scelta, chip, descrizione, aggancio, quando, co-amministratori, foglio) | punto 9 |
| BA · decisioni consolidate | 5.B (nuova) | — | creare, gestire, sotto-DEN, stati, ipotesi | punto 9 |
| BA · Inventario | C4 | BaCampoCodice con stati «in verifica · rifiutato» | stati «sbagliato · scaduto · nuovo invio con attesa» (correzione: il 013 lo dichiarava ma la cella non era cambiata) | coerenza con il 013 |
| BA · Inventario | C4 | — | BaSceltaDen, BaChipScelta, BaPuntoAggancio, BaFoglioGestisci | punti 1, 3, 4, 7 |
| BA · Fase 2 schermate | prima di 5a | — | rimando alle schermate del 014 | punto 9 |
| handoff/014 | Creare DEN 014 | — | E1; C1–C6 (tipo privato e pubblico, nome con «quando» spento, nome vuoto, nome già usato, dettagli, invita, riepilogo, creato); S1–S2 (limite, non riuscita); G1–G5 (gestisci, co-amministratori con posto e al limite, persone, rimozione, termine, descrizione); D1 (sotto-DEN) | punti 1–8 |

## Ipotesi segnate (si tolgono con `segniIpotesi`)

- Chi crea entra sul palco a microfono spento (C5, C6).
- La fonte degli invitati non è decisa (C4, G2): una riga tratteggiata tiene il posto.
- La lista dei temi è di prova (C3).
- Il numero di DEN attivi insieme non è deciso (S1): la frase non lo dice.
- Dedotte da me: chi crea il DEN crea i sotto-DEN, nome e membri del sotto-DEN scelti dopo (D1); cosa succede dopo la rimozione (G3 bis).

## Dove il brief ostacola

- **Termini mancanti nel glossario.** «Co-amministratore», «Gestisci» e «DEN privato / pubblico» non sono nel glossario e il task vieta di cambiarlo. Li ho usati come nel task. Vanno aggiunti prima del codice.
- **Il DEN pubblico non ha un amministratore (D-011), ma il task chiede «terminare il DEN».** Ho dato il foglio «Gestisci» solo ai DEN privati. Per chi crea un DEN pubblico non c'è gestione: è un'ipotesi da confermare con i soci (chi può terminare o cambiare la descrizione di un DEN pubblico?).
- **Ultimo passo del 013.** Nel percorso «Crea un DEN» il consenso del 013 (P4) dice «Acconsento e salgo» e «Salirai a microfono spento»: qui il testo giusto sarebbe «Acconsento e continuo». Non ridisegno P4; serve una variante del testo.
- **Nessun «Esci» e nessun testo per la barra nelle schermate di gestione.** La barra con «Altro» è disegnata solo come sfondo del foglio, come nel 013.
- **Tetto di DEN, nome unico e limiti di lunghezza.** Non decisi: nessun numero a schermo, nessun contatore di caratteri.
