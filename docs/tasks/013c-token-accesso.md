# Task 013c — Applicare i token e i documenti del 013

12 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Claude Design ha consegnato 013 e 013b: l'accesso dell'ascoltatore con email, il percorso «diventa partecipante» (numero, SMS, consenso), «Torna ascoltatore». Lo zip è in `Import/BA_design_3.zip` (cartella già ignorata da git, non committarlo). Il `tokens.dart` nuovo compila (parser Dart, zero errori, solo `widgets.dart` importato) e rispetto a quello di `main` ha **solo righe aggiunte**: la classe `BaAccessoTokens`. Nessun colore nuovo. Come per il 006, il 008 e il 012d, questo task porta tutto nella repo; **nessun widget** (le schermate e `BaCampoCodice` sono task successivi).

## Do

1. **Branch** `task/013c-token-accesso`, da `main` aggiornato.
2. **Documenti.** Dallo zip copia `design/system/*.dc.html` (sostituiscono quelli attuali) e `design/handoff/013/` intera (il prototipo `Accesso 013.dc.html`, il `changelog.md`, gli screenshot compresi quelli in `de-testo-2/`, `support.js`). Non copiare `tokens.dart` in `design/`; le altre cartelle `handoff/` dello zip sono già nella repo.
3. **`tokens.dart`.** Sostituisci `app/lib/design_system/tokens.dart` con quello dello zip. Il `git diff` deve contenere solo righe aggiunte, solo `BaAccessoTokens`. Con lo script temporaneo (non committato) controlla che l'ARGB dei colori già esistenti coincida; riporta l'esito.
4. **Test nuovi** in `test/tokens_test.dart`, su `BaAccessoTokens`: `codiceCaselle` 6; `codiceAltezza` e `campoAltezza` uguali a `BaControlloTokens.primario`; `codiceGap` 8; `codiceRaggio` uguale a `BaRaggioTokens.riquadro`; `codiceBordo` 1 e `codiceBordoAttivo` 2; `campoLinea` 2; `segnoBordo` 1 e `segnoRaggio` uguale a `BaRaggioTokens.riquadro`; `erroreSegnoLato` 22 e `erroreSegnoTratto` 2; `nuovoInvioAttesa` 30 secondi; `foglioAltezzaTelefono` 0,8 e `foglioAltezzaTablet` 0,62. In più, un test che prova che **sei caselle stanno nella colonna a 360 dp** senza scendere sotto `areaMinima`: (larghezza colonna − 5 × `codiceGap`) / 6 ≥ `areaMinima`.
5. **Copie Markdown.** Le fornisce Luca (nessuna installazione): copiale da `Import/copie-di-lettura-md-013c/` in `design/system/md/`, in un commit separato.
6. **Documenti di progetto.** `docs/tasks/README.md`: 013 e 013b «Concluso», 013c «In corso». Niente altro: le ipotesi del 013 sono già nelle «Aperte» di `DECISIONS.md`.

## Do NOT

- Non scrivere widget, schermate né `BaCampoCodice`; non toccare i componenti esistenti.
- Non modificare i valori consegnati né aggiungere token.
- Niente Material o Cupertino, nuove dipendenze, golden.

## Acceptance check

- [ ] `git diff` di `tokens.dart`: solo righe aggiunte, solo `BaAccessoTokens`.
- [ ] I colori che esistevano in `main` hanno lo stesso ARGB: esito nel report.
- [ ] Nessun termine vietato nei file nuovi (eccetto Stanza DEN, storico, e il falso positivo in Inventario); nessun `tokens*.dart` in `design/`; nessuno zip tracciato.
- [ ] `flutter analyze` e `flutter test` verdi; CI verde.

## Cosa restituire

Branch `task/013c-token-accesso`, report in `docs/reports/013c.md` (massimo 15 righe): esito del confronto dei colori, differenze inattese in `tokens.dart`, tempo della suite. Pull request con il template.
