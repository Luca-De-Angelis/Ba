# Task 025 — Documentazione di handoff per il team di sviluppo

16 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Il progetto consegna due risultati: un prototipo navigabile in locale e **questa repository**, pensata per il passaggio al team di sviluppo (handoff). Il preventivo include una voce «documentazione di handoff nella repository». Oggi la repo ha molta documentazione (decisioni, glossario, registro delle funzionalità, brief, specifiche dei task, report), ma è scritta per chi lavora al progetto giorno per giorno: **chi arriva da fuori non sa da dove cominciare**. Questo task scrive la porta d'ingresso. Il team di sviluppo ha il suo server e il suo audio in tempo reale: la documentazione deve dire chiaramente che cosa il prototipo è, che cosa non è e dove si innesta il resto.

Regola d'oro: **ogni affermazione si verifica nel codice o nei documenti**. Non inventare, non decidere, non abbellire. Quello che non si può verificare si scrive come «da verificare». Fonti: `docs/` (DECISIONS, GLOSSARY, FEATURES, brief, tasks, reports), `design/system/md/`, `design/handoff/`, `app/lib/` e `app/test/`, `.github/`, `CLAUDE.md`.

## Do

1. **Branch** `task/025-handoff`, da `main` aggiornato. Solo documentazione, più il test del punto 8: **nessun codice di prodotto cambia**.
2. **`docs/handoff/README.md`: la porta d'ingresso.** Che cos'è BA in dieci righe (da `CLAUDE.md` e dal brief); che cosa contiene la repo; che cosa è il prototipo e che cosa **non** è (server, audio, servizi esterni, dati veri); come si legge il resto, con un indice ordinato di tutti i file di `docs/handoff/` e un «da dove cominciare» per tre lettori (sviluppo Flutter, sviluppo del server, chi gestisce il prodotto).
3. **`avvio.md`: farlo girare.** Versione di Flutter fissata e dove (`ci.yml`), come si installano le dipendenze, come si lancia la **galleria** in Chrome (`flutter run -d chrome -t lib/galleria/main_galleria.dart`, da `app/`), come si lanciano analisi e test, come si leggono le pagine della galleria e i loro controlli (testo, larghezza, «riduci movimento», lingua). Ogni comando provato.
4. **`architettura.md`: come è fatto.** La struttura di `app/lib/` (design system, palco, galleria, l10n), i principi (token a due livelli, solo `widgets.dart` e le eccezioni scritte in `CLAUDE.md`, niente Material, i nomi `Ba…` per i widget e `…Tokens` per le classi di token: D-021 e D-028), il modello della stanza (`BaPayloadStanza`, `BaRegole`, `BaOra`), e come si aggiunge un componente o un token.
5. **`componenti.md`: la tabella dei componenti.** Una riga per ogni componente di `app/lib/design_system/`: nome, file, a che cosa serve, stati, token che usa, test, **fonte di design** (la sezione dell'Inventario e il prototipo in `design/handoff/`), e note per chi lo userà in produzione. La ricavi dal codice, non dall'Inventario a memoria.
6. **`schermate.md`: dalle schermate ai componenti.** Per ogni prototipo di `design/handoff/` (stanza e stati critici, accesso, creare DEN, coda e attesa): le schermate, i componenti che servono, **quali esistono già nel codice e quali no**. Qui si vede che cosa resta da costruire.
7. **`regole.md` e `aperte.md`.** `regole.md`: le regole di prodotto che toccano il codice, in forma operativa (la pillola chiara solo dove il gesto è obbligato, mai il solo colore, il tempo come fatto fermo e mai conto alla rovescia, ingresso morbido, nessun annuncio dell'arrivo di altri: D-034, microfono che si spegne soltanto da fuori: D-025, lo stato del microfono appartiene alla connessione: D-029), ciascuna con il rimando alla decisione. `aperte.md`: **tutte le ipotesi segnate** nelle schermate e nei token (ricercale nel codice e nei documenti), con il numero della domanda agli stakeholder che le riguarda (le 19 domande della mail), dove si trovano e che cosa cambia se la risposta è diversa. Se un'ipotesi non corrisponde a una domanda, scrivilo.
8. **`produzione.md`: dal prototipo alla produzione.** Che cosa è finto nel prototipo (dati di prova, testi fissi della galleria, `onTap` vuoti) e dove si sostituisce; i punti di innesto con il server e l'audio (che cosa il codice si aspetta in ingresso: payload, stati, `ampiezza`, `parla`, `voci`); il suono e la vibrazione (rimanda a `suono-e-vibrazione.md`: nessun codice esiste ancora); l'accessibilità (semantica, ordine di lettura, annunci); le traduzioni (le cinque lingue, le **bozze da far rivedere a madrelingua**, come si aggiunge una chiave); la CI.
9. **Un test che tiene allineata la documentazione.** `test/documentazione_test.dart`: ogni file di `lib/design_system/` che definisce un componente compare in `docs/handoff/componenti.md`, e ogni link relativo dei file di `docs/handoff/` punta a un file che esiste. Se un file non è un componente (token, forma, disposizione), elencalo come esente nel test, con il motivo.
10. **Elenco dei task.** In `docs/tasks/README.md`: 021b «Concluso»; 022 «Componenti dei task 013–015», 023 «Contenuti dei fogli», 024 «Prototipo navigabile in locale», 025 «Documentazione di handoff» «In corso» (i primi tre «brief da scrivere»). In `CLAUDE.md`: una riga che dice che `docs/handoff/` va aggiornata quando si aggiunge un componente.

## Do NOT

- Non modificare codice di prodotto, token, design né decisioni; non registrare decisioni nuove.
- Non duplicare ciò che esiste già: rimanda ai file con un link e un riassunto di una riga.
- Non scrivere in inglese: la lingua del progetto è l'italiano. Se serve l'inglese per il team, lo si chiede dopo.
- Niente promesse su ciò che non esiste (suono, vibrazione, server, notifiche).

## Acceptance check

- [ ] `docs/handoff/` ha i sette file (README, avvio, architettura, componenti, schermate, regole, aperte, produzione) e ogni link relativo funziona.
- [ ] Ogni comando di `avvio.md` è stato provato; quelli che non si possono provare sono segnati «da verificare».
- [ ] `componenti.md` ha una riga per ogni componente della repo e il test lo prova.
- [ ] `aperte.md` elenca **tutte** le ipotesi segnate, ciascuna con la sua domanda; quelle senza domanda sono dichiarate.
- [ ] Nessuna affermazione inventata: dove non si può verificare c'è scritto «da verificare».
- [ ] `flutter analyze` e `flutter test` verdi; CI verde.

## Cosa restituire

Branch `task/025-handoff`, report in `docs/reports/025.md` (massimo 20 righe) con le affermazioni segnate «da verificare», le ipotesi senza domanda, e ciò che manca perché i componenti 022–024 non esistono ancora. Pull request con il template.
