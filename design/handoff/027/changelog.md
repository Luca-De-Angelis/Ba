# Task 027 — changelog

20 novembre 2026. Schermate nuove in `design/handoff/027/Account e controlli 027.dc.html`. I prototipi 013, 014 e 015 sono aggiornati sul posto. Screenshot in `screenshots/` (360 dp e 744 dp, nomi parlanti) e `screenshots/de-testo-2/` (tedesco, testo 2,0, stato iniziale e scrollato in fondo, solo per le schermate del 013). Solo righe aggiunte in `tokens.dart`; nessun valore esistente cambiato. `tokens.diff.md` non rigenerato. Decisioni: D-025, D-040…D-044, D-049, D-050, D-052.

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| 013 | A4 Termini | solo termini e privacy | frase «Toccando «Accetto» dichiari di avere almeno 18 anni…» sopra l'azione; ipotesi: età minima 18, obiettivo 16 | punto 1, D-052 |
| 013 | A5 Nome | «Come ti chiamano?», decisione aperta | A5 «Scegli un nickname» (obbligatorio, può ripetersi) e A5 bis (vuoto, azione inattiva) | punto 1, D-052 |
| 013 | A6 Elenco | segno «nessun DEN privato su invito» | segno tolto; la nota dice che un privato si apre solo su invito, da un percorso a parte | punto 3, D-041 |
| 013 | P4 Consenso | solo avviso e consenso | frase «il tuo account passa da ascoltatore a partecipante»; ipotesi: può servire un nuovo accesso | punto 2, D-040 |
| 013 | P6 | numero già verificato: avviso e consenso | tolta (con il segno «il numero resta verificato») | punto 2, D-040 |
| 013 | T1–T4 Torna ascoltatore | un tap, riga «il numero resta verificato» | cambio di tipo di account: T1 riga, T2 prima conferma, T3 seconda conferma (ipotesi: nuovo accesso), T4 risultato | punto 2, D-040 |
| 014 | C1, C1 bis Tipo | «Un DEN pubblico non ha un amministratore: lo modera l'app» | «Entra chiunque. Si trova nell'elenco.» e «Lo gestisci tu, con i co-amministratori che scegli.» per entrambi | punto 4, D-043 |
| 014 | G, intestazione | «Gestisci» solo per i privati | per privati e pubblici | punto 4, D-043 |
| 014 | R2 Consenso | senza il cambio di account | stessa frase del 013 P4 | coerenza con D-040 |
| 015 | K3, K4 posto offerto | «Si è liberato un posto» | «…Hai pochi secondi per salire.» (30 s, frase ferma, nessun conto alla rovescia) | punto 5, D-042 |
| 015 | K4 bis | — | posto scaduto: «Il posto è passato alla persona dopo di te. Resti in coda.» (ipotesi) | punto 5 |
| 015 | K6 | — | già in un DEN: «Si è liberato un posto in X. Vuoi passare di qua?», «Passa» e «Resta qui» | punto 5 |
| 015 | K7, K8 richiamo | — | notifica a schermo bloccato (non un annuncio in stanza); riga «Richiamo» spenta nelle impostazioni (ipotesi) | punto 6, D-034, D-042 |
| 015 | S1 «non puoi metterti in coda» | presente (S1) | tolta; K1 e il segno del numero massimo di code tolti; S2→S1, S3→S2 | punto 7, D-042 |
| 015 | M1, M1 bis | «vale per chi sta fra il pubblico», in revisione | vale per ascoltatori e parlatori, tempi da definire; M1 bis sul palco | punto 7, D-044 |
| handoff/027 | B1, B1 bis, B2 | — | account chiuso, blocco temporaneo (ipotesi), richiesta inviata; «Richiedi revisione» è l'unica azione | punto 8, D-049 |
| handoff/027 | L1–L4 | — | controlli a schermo bloccato: palco con microfono acceso e spento, pubblico in diretta e in pausa | punto 9, D-050 |
| tokens.dart | BaCodaTokens, BaSchermoBloccatoTokens | — | `postoOffertoFinestra` 30 s (eccezione, valore variabile); controlli sp11, sp2, roundedFull, border1 | punti 5, 9 |
| BA · Token | T6 ter | — | `coda/posto-offerto`, `blocco/controlli`; righe del segno ipotesi e della permanenza aggiornate | punti 5, 7, 9 |
| BA · decisioni consolidate | 5.D (nuova), 5.A, 5.B | nome aperto, numero che resta verificato, «Gestisci» solo privati | 5.D con ciò che vale ora; 5.A e 5.B corrette nelle frasi superate | tutti |
| BA · Inventario | BaControlliBloccato, BaSchermataCopertura | — | due righe nuove | punti 8, 9 |
| suono-e-vibrazione.md | tabella | — | posto offerto, richiamo, account chiuso: nessun segnale dell'app | punti 5, 6, 8 |

## Dove il brief ostacola

- **Glossario superato.** «DEN pubblico: non ha amministratore», «Partecipante: numero verificato e consenso», «Torna ascoltatore: ritiro del consenso» e «Gestisci: foglio dei DEN privati» non sono più veri (D-040, D-043). Il task vieta di cambiarlo; va aggiornato prima del codice.
- **14 · S1 «Limite di DEN attivi» resta.** D-042 dice nessun limite in alpha e beta, ma il task toglie solo lo stato della coda. L'ho lasciato con il suo segno «non è deciso»: da togliere o da tenere come stato futuro (Pro).
- **Tedesco e testo 2,0 solo per il 013.** Le schermate lunghe del 013 hanno la prova con stato iniziale e scrollato. Per le nuove (account chiuso, controlli, K6) non ho fatto la prova in tedesco: il tedesco c'è nelle schermate ma non gli screenshot.
- **«18 anni» come frase e non come passo.** È un solo gesto: una frase sopra «Accetto». Se il legale vuole una casella da spuntare, serve un passo a sé.
- **«Prossimo DEN».** Il nome dell'etichetta è mio; la fonte del DEN successivo è da definire.
- **Nuovo accesso al cambio di tipo.** Segnato come ipotesi: se serve, il flusso dopo T3 e dopo P4 si interrompe e va ridisegnato.
- **Elenco senza DEN privati e invito.** «Sei stato invitato» non è disegnato (non nel task): il percorso resta fuori.
