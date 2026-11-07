# Registro delle decisioni

Un solo registro per tutte le decisioni di prodotto e di design. Le decisioni tecniche più ampie stanno in `adr/`. Una decisione non si cambia: se ne aggiunge una nuova che la supera, e si segna qui quale.

> **Da unire.** La sintesi tecnica sull'audio cita un registro già esistente lato sviluppo (`BA_Decisioni_Consolidate.md`, con sezioni §2, §3, §6…) e alcuni ADR (ADR-017, ADR-024). Quando sono disponibili vanno portati qui e in `adr/`, risolvendo eventuali doppioni. Due registri separati finiscono per contraddirsi.

| ID | Data | Decisione | Fonte | Stato |
| --- | --- | --- | --- | --- |
| D-001 | 17/10/2026 | Se il design diverge da una decisione di prodotto, vince il brief; le scelte estetiche restano del design | Luca | Valida |
| D-002 | 17/10/2026 | Accesso con numero di telefono e codice SMS, poi due consensi separati: termini e privacy (necessario) e consenso a parlare (rifiutabile). Chi rifiuta resta ascoltatore. Il flusso regge la sparizione del passaggio SMS | Brief §5; Guida §3, §5; sintesi tecnica §2 | Valida, aggiornata il 6/11 |
| D-003 | 17/10/2026 | Il consenso a parlare si ritira dalle impostazioni con "Torna ascoltatore": non si parla più e, se si sta parlando, si esce dalla stanza. Non esiste un interruttore della trascrizione separato | Brief §5; sintesi tecnica §2 | Valida, aggiornata il 6/11 |
| D-004 | 17/10/2026 | Nessuna conversazione si può riascoltare. La voce di chi parla si salva per poco tempo per trascriverla, poi si cancella; il testo resta per un periodo. L'interfaccia lo dice nell'onboarding, quando si diventa partecipante e nelle impostazioni | Sintesi tecnica §1, §2; D-013 | Valida, aggiornata il 6/11 |
| D-005 | 17/10/2026 | La rimozione di una persona da un DEN è fuori dall'alpha; esisterà nei DEN privati, quindi non va preclusa | Brief §5.A; Guida §4 | Valida |
| D-006 | 17/10/2026 | Si entra in un DEN nel pubblico e si sale sul palco se c'è posto | Guida §5 | Valida |
| D-007 | 17/10/2026 | Si sale sul palco sempre a microfono spento, anche dalla coda e con l'ingresso automatico | Guida §5; Brief §6 | Valida |
| D-008 | 17/10/2026 | Il lessico è quello di `GLOSSARY.md`, che coincide con i nomi del codice | Guida §2 | Valida |
| D-009 | 17/10/2026 | `tokens.dart` vince sui documenti: luce fra le sagome 17, rilascio del respiro 600 ms, fondo della scala 88 | Token T0 | Valida |
| D-010 | 17/10/2026 | Ogni valore citato in un documento esiste in `tokens.dart`, con nome e impiego | Token T0 | Valida |
| D-011 | Novembre 2026 | Moderazione interamente AI, anche nei DEN pubblici, a blocchi di 8 tramite i sotto-DEN, in differita. Nessun presidio umano | Call con gli stakeholder | Valida; rischio accettato |
| D-012 | Novembre 2026 | La sostenibilità fino a 50.000 utenti attivi al mese non va verificata | Call con gli stakeholder | Valida; rischio accettato |
| D-013 | Novembre 2026 | Voce e testo si dichiarano nei termini e condizioni e nell'onboarding al primissimo accesso | Call con gli stakeholder | Valida |
| D-014 | Novembre 2026 | Dimensione sociale: ci si connette con altre persone e fra le connessioni si scelgono gli invitati ai propri DEN programmati | Call con gli stakeholder | Valida nel principio; modo di connettersi aperto |
| D-015 | Novembre 2026 | Home ricca, in stile Spotify: DEN dal vivo e programmati a sezioni, contenuti di terzi, suggerimenti su misura | Call con gli stakeholder | Valida nel principio; rilascio aperto |
| D-016 | Novembre 2026 | Ogni utente può programmare un DEN e invitare le sue connessioni | Call con gli stakeholder | Valida |
| D-017 | Novembre 2026 | Podcast e musica si ascoltano insieme dentro un DEN (ascolto condiviso) | Call con gli stakeholder | Valida nel principio; nessuna licenza |
| D-018 | Novembre 2026 | Le emittenti radio possono programmare DEN per interagire con i loro ascoltatori | Call con gli stakeholder | Valida nel principio; rilascio aperto |
| D-019 | 6/11/2026 | Il framework resta Flutter. Token e scale seguono il modello di Tailwind: due livelli, scale primitive con nomi e passi alla Tailwind e token semantici di BA che vi fanno riferimento | Luca | Valida |
| D-020 | 6/11/2026 | Approccio mobile first. Il tablet è supportato dalla beta 1, per ora solo in verticale. Il layout dipende dalla larghezza dello schermo, non dall'orientamento, così l'orizzontale si potrà aggiungere | Luca | Valida; orizzontale da rivalutare |
| D-021 | 7/11/2026 | I nomi `Ba<Componente>` (per esempio `BaPresenza`, `BaPalco`) sono riservati ai widget. Le classi di token prendono il suffisso `Tokens` (`BaPresenza` → `BaPresenzaTokens`, `BaColor` → `BaColorTokens`…). Il cambio si fa nel task 004 | Chat di orchestrazione, su segnalazione di Claude Code | Valida |
| D-022 | 7/11/2026 | Il telefono più stretto di riferimento è 360 dp (Android), non i 375 pt dell'iPhone citati nel brief v2.1: progettare per 360 copre entrambi | Decisioni consolidate §7; brief v2.1 §4 | Valida |
| D-023 | 7/11/2026 | Su iPad l'app richiede lo schermo intero (UIRequiresFullScreen) finché è solo verticale: rinuncia a Split View e Slide Over. Si toglie quando arriva l'orizzontale | Task 000; D-020 | Valida |

## Aperte

- Dove si trascrive e con chi: team e legale, con le scadenze della sintesi tecnica.
- In quale rilascio arrivano home, connessioni, ascolto condiviso e radio.
- Come ci si connette con una persona.
- Licenze per podcast e musica.
- Revisione umana dei passaggi segnalati dalla moderazione.
- Tablet Android: con target 36 il blocco in verticale viene ignorato dai 600 dp in su; esiste una deroga temporanea, che sparisce con target 37. Da decidere con lo sviluppo se attivarla.
