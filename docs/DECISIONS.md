# Registro delle decisioni

Un solo registro per tutte le decisioni di prodotto e di design. Le decisioni tecniche più ampie stanno in `adr/`. Una decisione non si cambia: se ne aggiunge una nuova che la supera, e si segna qui quale.

> **Da unire.** La sintesi tecnica sull'audio cita un registro già esistente lato sviluppo (`BA_Decisioni_Consolidate.md`, con sezioni §2, §3, §6…) e alcuni ADR (ADR-017, ADR-024). Quando sono disponibili vanno portati qui e in `adr/`, risolvendo eventuali doppioni. Due registri separati finiscono per contraddirsi.

| ID | Data | Decisione | Fonte | Stato |
| --- | --- | --- | --- | --- |
| D-001 | 17/10/2026 | Se il design diverge da una decisione di prodotto, vince il brief; le scelte estetiche restano del design | Luca | Valida |
| D-002 | 17/10/2026 | Accesso con numero di telefono e codice SMS, poi due consensi separati: termini e privacy (necessario) e consenso a parlare (rifiutabile). Chi rifiuta resta ascoltatore. Il flusso regge la sparizione del passaggio SMS | Brief §5; Guida §3, §5; sintesi tecnica §2 | Superata da D-031 |
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
| D-018 | Novembre 2026 | Le emittenti radio possono programmare DEN per interagire con i loro ascoltatori | Call con gli stakeholder | Superata da D-032 |
| D-019 | 6/11/2026 | Il framework resta Flutter. Token e scale seguono il modello di Tailwind: due livelli, scale primitive con nomi e passi alla Tailwind e token semantici di BA che vi fanno riferimento | Luca | Valida |
| D-020 | 6/11/2026 | Approccio mobile first. Il tablet è supportato dalla beta 1, per ora solo in verticale. Il layout dipende dalla larghezza dello schermo, non dall'orientamento, così l'orizzontale si potrà aggiungere | Luca | Valida; orizzontale da rivalutare |
| D-021 | 7/11/2026 | I nomi `Ba<Componente>` (per esempio `BaPresenza`, `BaPalco`) sono riservati ai widget. Le classi di token prendono il suffisso `Tokens` (`BaPresenza` → `BaPresenzaTokens`, `BaColor` → `BaColorTokens`…). Il cambio si fa nel task 004 | Chat di orchestrazione, su segnalazione di Claude Code | Valida |
| D-022 | 7/11/2026 | Il telefono più stretto di riferimento è 360 dp (Android), non i 375 pt dell'iPhone citati nel brief v2.1: progettare per 360 copre entrambi | Decisioni consolidate §7; brief v2.1 §4 | Valida |
| D-023 | 7/11/2026 | Su iPad l'app richiede lo schermo intero (UIRequiresFullScreen) finché è solo verticale: rinuncia a Split View e Slide Over. Si toglie quando arriva l'orizzontale | Task 000; D-020 | Valida |
| D-024 | 7/11/2026 | Chi è ascoltatore diventa partecipante dalla stanza: tocca "Sali sul palco", rivede l'avviso su voce e testo, dà il consenso e sale a microfono spento. Nelle impostazioni non c'è una riga apposita | Review del 001; task 002 | Valida |
| D-025 | 7/11/2026 | Da lock screen e notifica Android il microfono si può solo spegnere, mai riaccendere. Lo stato spento è informativo; resta "Esci" | Sintesi tecnica sull'audio §1; 001b | Valida |
| D-026 | 8/11/2026 | Tipografia: corpo 16, secondario 14, marcatore e nota 12 (erano 15, 13, 11, 10). Raggi: foglio 24, riquadro 16 (erano 26 e 14) | Task 004; confermata da Luca | Valida |
| D-027 | 8/11/2026 | Il tablet si decide sulla larghezza dello schermo, da 600 dp. Sul tablet la scala del palco cresce di 1,5 (312, 234, 195, 168, 132). Il tetto assoluto di presenze per riga è 3 sul telefono e 4 sul tablet; il tetto per conteggio resta nel codice del palco | Task 004, 004b; confermata da Luca | Valida |
| D-028 | 8/11/2026 | D-021 vale per le classi di token. `BaOra`, `BaPayloadStanza` e `BaRegole` non sono né token né widget e restano senza suffisso | Task 004 | Valida |
| D-029 | 9/11/2026 | Quando cade la connessione il microfono si spegne, e alla ripresa resta spento: lo stato del microfono appartiene alla connessione. Per questo suono e vibrazione di connessione persa sono sicuri | Sintesi tecnica sull'audio §1; task 002b | Valida |
| D-030 | 9/11/2026 | Il web serve solo come galleria di sviluppo per vedere i componenti in Chrome: non è una piattaforma di prodotto. I target restano iOS e Android | Task 009 | Valida |
| D-031 | 10/11/2026 | L'account di base è da ascoltatore: si entra con un codice via email (A01), si vedono solo i DEN pubblici e non si ha voce. Il numero di telefono verificato e il consenso a parlare servono solo per parlare, e si chiedono in «Sali sul palco» (A03, D-024). Google e Apple arrivano dopo l'alpha (A02). Sostituisce D-002 | Catalogo dei servizi (A01, A02, A03); risposta dei soci | Valida |
| D-032 | 10/11/2026 | Le emittenti radio non programmano DEN. La «radio» è la modalità radio (B10): quando il DEN finisce o si svuota, si passa da soli a uno simile per tema e lingua. Sostituisce D-018 | Catalogo dei servizi (B10); risposta dei soci | Valida |
| D-033 | 10/11/2026 | Perimetro di lavoro: si prende nota di tutti i servizi del catalogo, ma si lavora (design, codice, domande ai soci) solo su quelli segnati Confermato, Ipotesi o Previsto, più i verdi con un punto aperto: 48 servizi. Gli altri 67 sono solo annotati in `FEATURES.md` e si predispone il sistema ad accoglierli senza precluderli. Le sezioni N e X valgono come principi | Indicazione di Luca | Valida |
| D-034 | 12/11/2026 | Lo screen reader annuncia i cambi di stato di chi usa l'app (il proprio microfono, la salita sul palco, la parola ricevuta o revocata, la linea persa e ripresa), mai l'ingresso o l'uscita di altre persone né il loro stato (microfono, parola): si leggono sul palco (ingresso morbido). Sostituisce la formulazione «ogni cambio di stato del palco viene annunciato» | Report del task 011; task 002 | Valida |

## Aperte

- Dove si trascrive e con chi: team e legale, con le scadenze della sintesi tecnica.
- In quale rilascio arrivano home, connessioni, ascolto condiviso e radio.
- Come ci si connette con una persona.
- Licenze per podcast e musica.
- Revisione umana dei passaggi segnalati dalla moderazione.
- Tablet Android: con target 36 il blocco in verticale viene ignorato dai 600 dp in su; esiste una deroga temporanea, che sparisce con target 37. Da decidere con lo sviluppo se attivarla.
- Regola del limiter oltre le due voci (escursione × 1,12/n): provvisoria fino alla prova con tre o più voci vere.
- Traduzioni: quelle tedesche, e quelle delle altre lingue, da far rivedere a madrelingua.
- Vibrazione: i pattern vanno provati su un iPhone e su un Android veri, in particolare le coppie "spento" e "solo gruppo", "acceso" e "revocata", "ricevuta" e "salita".
- Suoni: `ba_mic_spento`, `ba_conn_persa` e `ba_conn_ripresa` esistono solo come specifica; vanno prodotti, e chi li realizza non è deciso.
- Catalogo LIVE.BA (10/11/2026): in attesa dei soci le voci D07, E06 e G10; vedi docs/FEATURES.md.
- Task 013 (accesso con email): tre ipotesi in attesa dei soci: nessun DEN privato su invito per l'ascoltatore; dopo «Torna ascoltatore» il numero resta verificato; il passo del nome resta aperto.
- Ritocchi da raccogliere in un giro di rifinitura: sovrapposizione dei tratti semitrasparenti nei glifi (punti più chiari dove la barra incrocia l'anello); genere delle etichette «bloccata», «bloquée», «bloqueada»; traduzioni EN, FR, ES e le bozze tedesche da far rivedere a madrelingua; barra dei glifi a .62 invece di .85 del prototipo (accettata).
- Aggiornamento di Flutter: il file di traduzioni generato include i delegati di Material e Cupertino, deprecati nelle versioni nuove; oggi il file generato è escluso dall'analisi (`analysis_options.yaml`). Da risolvere alla radice quando si aggiorna Flutter, insieme al controllo dei test sensibili ai tempi (`AnimationController` finisce solo al primo fotogramma oltre la durata).
- Task 014 (creare e gestire i DEN): in attesa dei soci le ipotesi: chi crea entra sul palco a microfono spento; la fonte degli invitati; la lista dei temi (di prova); il numero di DEN attivi insieme; chi può terminare o modificare un DEN pubblico (senza amministratore, D-011).
- Task 015 (coda e attesa): in attesa dei soci le ipotesi: il sotto-DEN d'attesa è a scelta e non predefinito; il Pro ha un posto conservato di 3 minuti (3 o 5); la permanenza massima (B05) vale per chi sta fra il pubblico; il numero massimo di code contemporanee; il suono senza vibrazione quando al ritorno il posto è passato. Nuovo stato della stanza: «Si è liberato un posto» (ingresso manuale), da confermare.
