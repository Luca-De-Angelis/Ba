# Task 030 — changelog (proposta)

24 novembre 2026. Schermate in `design/handoff/030/Persone e inviti 030.dc.html`; screenshot in `screenshots/` (360 dp e 744 dp, nomi parlanti) e `screenshots/de-testo-2/` (tedesco, testo 2,0, stato iniziale e scrollato in fondo). Solo righe aggiunte in `tokens.dart`. `tokens.diff.md` non rigenerato. Decisioni: D-038, D-039, D-041, D-042, D-052.

**Principio verificato su ogni schermata:** nessuna riga mostra o lascia dedurre che una persona è online o in un DEN. Nessun contatore, nessun «online», nessun «visto da». Il richiamo parte spento.

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| handoff/030 | P1–P6 | — | aggiungere persone: suggeriti, ricerca con due Sara (alias), nessun suggerito, nessun risultato, aggiunta, errore di rete | punto 1 |
| handoff/030 | R1–R3 | — | rubrica: permesso (due azioni alla pari), dopo il rifiuto (senza colpa), «Dalla rubrica» | punto 2 |
| handoff/030 | V1–V2 | — | «Chi può trovarmi»: riga e scelta (Nessuno, Chi conosco, Tutti) con la conseguenza scritta; partenza «Chi conosco» (ipotesi) | punto 3 |
| handoff/030 | S1–S3 | riga tratteggiata in C4 e G2 | stesso selettore per invitati (nessuno scelto, due scelti) e co-amministratore | punto 4 |
| handoff/030 | I1–I6 | — | invito a chi ha BA (notifica, foglio) e a chi non ce l'ha (mail, pagina d'arrivo, ingresso come ascoltatore); scaduto e annullato | punto 5 |
| handoff/030 | C1–C5 | solo la notifica (015 K7) e la riga spenta (K8) | richiamo: spento, acceso senza persone, chi puoi avvisare, conferma, chi può avvisarti | punto 6 |
| tokens.dart | BaPersoneTokens (nuova) | — | riga sp14, gap sp3, sagoma sp8, azione sp11 / rounded2xl / border1, ricerca sp14, 2 caratteri, interruttore dal 015, scadenza invito 7 giorni (eccezione) | punto 8; D-019 |
| BA · Token | T6 ter | — | 4 righe: persone/riga, ricerca, consenso, invito | punto 8 |
| BA · decisioni consolidate | 5.E (nuova) | — | persone, inviti, richiamo | punto 8 |
| BA · Inventario | dopo BaSchermataCopertura | — | BaRigaPersona, BaRicercaPersone, BaSelettorePersone, BaFoglioInvito, BaRigaConsenso | punto 8 |
| BA · Fase 2 schermate | prima di 5a | — | rimando alle schermate del 030 | punto 8 |

## Ipotesi segnate (si tolgono con `segniIpotesi`)

- L'azione si chiama «Aggiungi» e l'aggiunta è privata: l'altra persona non riceve un avviso.
- I nickname uguali si distinguono con un alias unico (`@marta.v`).
- Dalla rubrica compare solo chi ha scelto di essere trovato per numero.
- Valore di partenza di «Chi può trovarmi»: «Chi conosco».
- Un DEN privato si può creare senza invitati e invitare dopo.
- L'invito scade dopo 7 giorni; la pagina d'arrivo è una pagina web fuori dall'app.
- Richiamo: spento di partenza, un consenso per persona, solo DEN pubblici; chi riceve sceglie se ricevere.

## Dove il brief ostacola

- **Glossario.** Mancano «Aggiungi», «alias», «Chi può trovarmi», «invito» e «Persone». Il task non dà il permesso di cambiarlo: vanno aggiunti prima del codice.
- **«Chi ho frequentato di più» e il principio.** I suggeriti dicono chi ho frequentato io, non chi è online. Resta da confermare con lo sviluppo che la lista non esponga mai, nemmeno nell'ordine, chi ha fatto cosa quando.
- **La pagina web d'arrivo.** D-030 dice che il web non è una piattaforma di prodotto. L'ho disegnata come pagina fuori dall'app, segnata come ipotesi.
- **«Sei stato invitato» e il DEN privato pieno.** D-041 parla della coda per chi partecipa: non l'ho disegnata, perché non è nel task.
- **Un solo DEN attivo (D-042) e l'invito.** Se si è già in un DEN, l'invito dovrebbe seguire «Vuoi passare di qua?» del 015 (K6). Non l'ho disegnato.
- **Il richiamo da una persona che non ho aggiunto.** Il consenso è mio, ma chi riceve deve avermi aggiunto o essere un mio contatto? È aperto: nelle schermate ogni persona della lista è una persona già aggiunta.
- **Tre punti del task non toccano nulla di esistente** (stanza, palco, stati 002/011/012): ho rispettato il Do NOT.
