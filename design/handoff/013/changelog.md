# Task 013 — changelog

12 novembre 2026. Schermate in `design/handoff/013/Accesso 013.dc.html`; screenshot in `screenshots/` (360 dp e 744 dp, nomi parlanti) e `screenshots/de-testo-2/` (tedesco, testo 2,0, stato iniziale e stato scrollato in fondo). Nessun valore esistente di `tokens.dart` cambiato: solo righe aggiunte. `tokens.diff.md` non rigenerato. Decisioni rispettate: D-003, D-013, D-019, D-024, D-031.

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| tokens.dart | BaAccessoTokens (nuova) | — | codice a 6 caselle (sp14, sp2, rounded2xl, border1/border2), campo (sp14, border2), segno «ipotesi» (border1, rounded2xl), segno «!» (22, border2), `nuovoInvioAttesa` 30 s, altezze del foglio 0,80 e 0,62 | punti 1, 3, 6; D-019 |
| BA · Token | T6 ter | — | 7 righe nuove con nome e «dove» (accesso/codice, campo, segno-ipotesi, errore-segno, errore-bordo, nuovo-invio-attesa, foglio) | punto 6 |
| BA · Fase 2 schermate | 5a | «Accesso — dal numero all'elenco»; «Nessuna email» | titolo «superato dal task 013» e avviso con le sostituzioni; le schermate restano come riferimento | punto 6 |
| BA · decisioni consolidate | 5.A (nuova) | — | accesso dell'ascoltatore, diventare partecipante, le tre ipotesi | punto 6 |
| BA · Inventario | BaCampoCodice (C1, C6) | «accesso · invito»; stati in verifica e scaduto non distinti | «accesso (email) · verifica del numero»; sbagliato, scaduto e nuovo invio con attesa come stati | punti 1, 6 |
| handoff/013 | Accesso 013 | — | A1–A6 (email, codice, sbagliato, scaduto, nuovo invio, onboarding, termini, nome, elenco); P1–P6 (avviso, numero, SMS, consenso, sale, con numero); T1–T2 («Torna ascoltatore» prima e dopo) | punti 1–5 |

## Ipotesi segnate (si tolgono con la proprietà `segniIpotesi`)

- Nessun DEN privato su invito per l'ascoltatore (elenco A6).
- Dopo «Torna ascoltatore» il numero resta verificato (P6, T1, T2).
- Il passo del nome resta aperto (A5).

## Decisioni di design

- **Aggancio per A02.** Sotto l'azione dell'email c'è un posto tratteggiato con la larghezza dell'azione secondaria. «Continua con…» entra lì senza spostare altro.
- **Passo SMS rimovibile.** P3 è tratteggiato. Con la verifica tramite operatore P2 porta a P4 con «Continua»; nessun testo degli altri passi nomina l'SMS.
- **Un solo foglio.** Il foglio «Vuoi salire sul palco?» è lo stesso del task 002 e cresce passo per passo. L'avviso del primo passo comprende il numero (par. 1); chi ha già il numero vede la versione del 002 (P6).
- **Testo grande.** Ciò che sta sopra le azioni scorre, le azioni restano in basso; il prototipo non scorre e mostra lo stato in fondo con la proprietà `scorri`.

## Dove il brief ostacola

- **«Decisioni consolidate (§5.A)».** Il documento contiene solo il §7 («sostituisce il §7»): non esiste un §5.A da aggiornare. Ho aggiunto una sezione 5.A prima del 7.1. Se il §5.A vive in un altro documento, va riportato lì.
- **Testi nuovi miei.** Il brief non dà il testo di tre punti: la frase del passo del numero («Ti mandiamo un codice per SMS. Il numero serve solo per parlare.»), quella del consenso («Acconsenti che, mentre parli, la tua voce si registri…») e l'attesa del nuovo invio («Ne puoi chiedere un altro fra poco.»). Sono in italiano e in tedesco nelle schermate; vanno approvate come testo di interfaccia.
- **Passo 5 del percorso.** «Sale a microfono spento» è lo stato 1 bis del task 002 e non l'ho ridisegnato (Do NOT: non cambiare gli stati del 002); l'ho mostrato con lo sfondo della stanza e l'azione inattiva «Sto salendo…».
- **«Torna ascoltatore» (5d).** Le schermate del 001 e di Fase 2 mostrano solo la riga cambiata; qui il «dopo» è una schermata sola con la riga «Sei ascoltatore».
