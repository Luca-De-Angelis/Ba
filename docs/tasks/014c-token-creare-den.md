# Task 014c — Applicare i token e i documenti del 014, e le voci di glossario

13 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Claude Design ha consegnato 014 e 014b: creare e gestire i DEN (tipo, nome, descrizione, tema e lingua, invitati, riepilogo, sotto-DEN, «Gestisci», stati) e il percorso da ascoltatore («Per creare un DEN bisogna diventare partecipante…», «Acconsento e continuo»). Lo zip è in `Import/BA_design_5.zip` (cartella già ignorata da git, non committarlo). Il `tokens.dart` nuovo compila (parser Dart, zero errori, solo `widgets.dart` importato) e rispetto a quello di `main` ha **solo righe aggiunte**: la classe `BaCreazioneTokens`. Nessun colore nuovo. Come per 006, 008, 012d e 013c, questo task porta tutto nella repo; **nessun widget**. In più, porta in `docs/` quattro voci di glossario che il design usa e che mancano.

## Do

1. **Branch** `task/014c-token-creare-den`, da `main` aggiornato.
2. **Documenti.** Dallo zip copia `design/system/*.dc.html` che cambiano (Token, Inventario, Fase 2, decisioni consolidate; Stanza DEN non cambia), `design/handoff/014/` intera (il prototipo `Creare DEN 014.dc.html`, `changelog.md`, `support.js`, gli screenshot compresi quelli in `de-testo-2/`) e `design/handoff/014b/changelog.md` se c'è. Non copiare `tokens.dart` in `design/`; le altre cartelle `handoff/` dello zip sono già nella repo (confronta per hash, come nel 013c), e non copiare i vecchi `handoff/001/changelog.md` e `tokens.diff.md` né i tre `sotto-den-pubblico-abbassato-*` di `handoff/002`.
3. **`tokens.dart`.** Sostituisci `app/lib/design_system/tokens.dart` con quello dello zip. Il `git diff` deve contenere solo righe aggiunte, solo `BaCreazioneTokens`. Con lo script temporaneo (non committato) controlla che l'ARGB dei colori già esistenti coincida; riporta l'esito.
4. **Test nuovi** in `test/tokens_test.dart`, su `BaCreazioneTokens`: `sceltaAltezza` uguale a `BaControlloTokens.primario`; `sceltaRaggio` e `aggancioRaggio` uguali a `BaRaggioTokens.riquadro`; `sceltaBordo` 1, `sceltaBordoScelta` 2, `aggancioBordo` 1; `sceltaSegnoLato` uguale a `BaAccessoTokens.erroreSegnoLato` (22); `chipAltezza` 48 e `chipGap` 8; `chipRaggio` uguale a `BaRaggioTokens.pillola`; `descrizioneAltezza` 96; `aggancioAltezza` 48; `quandoInterruttoreLarghezza` 44, `quandoInterruttoreAltezza` 26, `quandoPallino` 16; `coAmministratoriFree` 1 e `coAmministratoriPro` 3. In più: l'area toccabile della scelta e del chip non scende sotto `BaControlloTokens.areaMinima`.
5. **Copie Markdown.** Le fornisce Luca (nessuna installazione): copiale da `Import/copie-di-lettura-md-014c/` in `design/system/md/`, in un commit separato.
6. **Glossario.** In `docs/GLOSSARY.md` aggiungi: **DEN privato** «si entra solo su invito; ha un amministratore, chi lo ha creato»; **DEN pubblico** «entra chiunque; non ha amministratore, lo modera l'app (D-011)»; **Co-amministratore** «persona a cui l'amministratore di un DEN privato affida la gestione (uno nel Free, tre nel Pro)»; **Gestisci** «il foglio con cui chi ha creato un DEN privato lo amministra».
7. **Voci aperte.** In `docs/DECISIONS.md`, nella sezione «Aperte», aggiungi: «Task 014 (creare e gestire i DEN): in attesa dei soci le ipotesi: chi crea entra sul palco a microfono spento; la fonte degli invitati; la lista dei temi (di prova); il numero di DEN attivi insieme; chi può terminare o modificare un DEN pubblico (senza amministratore, D-011)».
8. **Elenco dei task.** `docs/tasks/README.md`: 014 e 014b «Concluso», 014c «In corso».

## Do NOT

- Non scrivere widget né schermate; non toccare i componenti esistenti.
- Non modificare i valori consegnati né aggiungere token.
- Niente Material o Cupertino, nuove dipendenze, golden.

## Acceptance check

- [ ] `git diff` di `tokens.dart`: solo righe aggiunte, solo `BaCreazioneTokens`.
- [ ] I colori che esistevano in `main` hanno lo stesso ARGB: esito nel report.
- [ ] Il glossario ha le quattro voci nuove e le «Aperte» la voce del 014.
- [ ] Nessun termine vietato nei file nuovi (eccetto Stanza DEN, storico, e il falso positivo in Inventario); nessun `tokens*.dart` in `design/`; nessuno zip tracciato.
- [ ] `flutter analyze` e `flutter test` verdi; CI verde.

## Cosa restituire

Branch `task/014c-token-creare-den`, report in `docs/reports/014c.md` (massimo 15 righe): esito del confronto dei colori, differenze inattese in `tokens.dart`, tempo della suite. Pull request con il template.
