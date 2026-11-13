# Task 015c — Applicare i token e i documenti del 015, e le voci di glossario

13 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Claude Design ha consegnato 015 e 015b: coda e attesa (mettiti in coda con l'ingresso automatico, «Le tue code», la notifica del posto libero, il sotto-DEN d'attesa, il posto conservato dopo la linea persa, la permanenza massima, gli stati). Lo zip è in `Import/BA_Design_2.zip` (cartella già ignorata da git, non committarlo). Il `tokens.dart` nuovo compila (parser Dart, zero errori, solo `widgets.dart` importato) e rispetto a quello di `main` ha **solo righe aggiunte** (50): la classe `BaCodaTokens`, e in `BaBarraAzioniTokens` i tre token di «Altro» (`altroPuntoLato`, `altroPuntoGap`, `altroBordo`). Nessun colore nuovo a parte `altroBordo`, che è una combinazione di primitive esistenti. Come per 006, 013c e 014c, questo task porta tutto nella repo; **nessun widget** (le schermate sono task successivi). In più, porta in `docs/` due voci di glossario e le ipotesi aperte.

## Do

1. **Branch** `task/015c-token-coda`, da `main` aggiornato.
2. **Documenti.** Dallo zip copia con il confronto per hash i `design/system/*.dc.html` che cambiano (Token, Inventario, Fase 2, decisioni consolidate; Stanza DEN non cambia), `design/handoff/015/` intera (il prototipo `Coda e attesa 015.dc.html`, `changelog.md`, `changelog-015b.md`, `suono-e-vibrazione.md`, `support.js`, gli screenshot compresi quelli in `de-testo-2/`). Non copiare `tokens.dart` in `design/`; i file di altre cartelle `handoff/` che nello zip sono più vecchi di quelli della repo (come `handoff/001/changelog.md`) e i tre `sotto-den-pubblico-abbassato-*` di `handoff/002` non si copiano. Dimmi nel piano cosa copi e cosa no.
3. **`suono-e-vibrazione.md`.** La consegna aggiunge due eventi (posto libero con ingresso manuale: notifica di sistema senza segnale dell'app; posto passato al ritorno: un suono senza vibrazione, **ipotesi**). Non c'è una copia in `docs/`: lasciala solo nel `handoff/015/`, e scrivilo nel report.
4. **`tokens.dart`.** Sostituisci `app/lib/design_system/tokens.dart` con quello dello zip. Il `git diff` deve contenere solo righe aggiunte. Con lo script temporaneo (non committato) controlla che l'ARGB dei colori già esistenti coincida; riporta l'esito.
5. **Test nuovi** in `test/tokens_test.dart`. `BaCodaTokens`: `interruttoreLarghezza` e `interruttoreAltezza` uguali a quelli del «quando» (`BaCreazioneTokens`); `interruttoreBordo` 1 e `interruttoreBordoAcceso` 2; `rigaAltezza` e `uscitaAltezza` almeno `BaControlloTokens.areaMinima`; `gruppoMax` 8; `postoConservatoFree` 30 s, `postoConservatoPro` 3 min, `permanenzaMassima` 60 min, `sogliaMomento` 2 min. **`oraDelPosto`**: sotto la soglia restituisce `null` (30 secondi, 1 minuto 59); da due minuti in su restituisce l'ora di fine **troncata al minuto**, mai oltre la fine reale (persa 21:40:50 + 3 min → 21:43; persa 21:40:00 + 2 min → 21:42; persa 21:40:50 + 5 min → 21:45) e **mai maggiore** di `persa + durata`. `BaBarraAzioniTokens`: `altroPuntoLato` 4, `altroPuntoGap` 3, e `altroBordo` con la trasparenza di `a32`.
6. **Copie Markdown.** Le fornisce Luca (nessuna installazione): copiale da `Import/copie-di-lettura-md-015c/` in `design/system/md/`, in un commit separato.
7. **Glossario.** In `docs/GLOSSARY.md` aggiungi: **Sotto-DEN d'attesa** (nell'interfaccia: «Aspetta con altri») «un gruppo di chi aspetta nella stessa coda, fino a 8: sente il gruppo e parla al gruppo, il palco non lo sente; si lascia quando si libera un posto (C05)»; **Gruppo d'attesa** «il gruppo di chi, nella stessa coda, ha scelto di aspettare insieme».
8. **Voci aperte.** In `docs/DECISIONS.md`, nella sezione «Aperte», aggiungi: «Task 015 (coda e attesa): in attesa dei soci le ipotesi: il sotto-DEN d'attesa è a scelta e non predefinito; il Pro ha un posto conservato di 3 minuti (3 o 5); la permanenza massima (B05) vale per chi sta fra il pubblico; il numero massimo di code contemporanee; il suono senza vibrazione quando al ritorno il posto è passato. Nuovo stato della stanza: «Si è liberato un posto» (ingresso manuale), da confermare».
9. **Elenco dei task.** `docs/tasks/README.md`: 015 e 015b «Concluso», 015c «In corso»; controlla che 020, 020b e 021 siano coerenti con lo stato reale e segnala nel report se non lo sono.

## Do NOT

- Non scrivere widget né schermate; non toccare i componenti esistenti.
- Non modificare i valori consegnati né aggiungere token.
- Niente Material o Cupertino, nuove dipendenze, golden.

## Acceptance check

- [ ] `git diff` di `tokens.dart`: solo righe aggiunte (`BaCodaTokens` e i tre token di «Altro»).
- [ ] I colori che esistevano in `main` hanno lo stesso ARGB: esito nel report.
- [ ] `oraDelPosto` non promette mai più del reale: il test lo prova.
- [ ] Il glossario ha le due voci nuove e le «Aperte» la voce del 015.
- [ ] Nessun termine vietato nei file nuovi (eccetto Stanza DEN, storico, e il falso positivo in Inventario); nessun `tokens*.dart` in `design/`; nessuno zip tracciato.
- [ ] `flutter analyze` e `flutter test` verdi; CI verde.

## Cosa restituire

Branch `task/015c-token-coda`, report in `docs/reports/015c.md` (massimo 15 righe): esito del confronto dei colori, differenze inattese in `tokens.dart`, cosa copiato e cosa no, tempo della suite. Pull request con il template.
