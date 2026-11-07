# Task 000 — Setup della repo e del progetto Flutter

7 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

La repo contiene documenti e `tokens.dart`, ma nessun commit e nessun progetto Flutter. Questo task la porta a uno stato da cui partono tutti gli altri: storia git, progetto che compila, CI verde. Nessuna interfaccia: le schermate arrivano dopo i task di design 001 e 004.

## Do

1. **Commit dello scheletro su `main`.** È l'unica eccezione alla regola dei branch (CLAUDE.md). Messaggio: "Scheletro della repo: documenti, design, tokens.dart". Poi fermati: io creo la repo privata su GitHub, faccio il push e proteggo `main`.
2. **Branch `task/000-setup`.** Da qui in avanti, tutto su branch.
3. **Progetto Flutter in `app/`** per iOS e Android, con identificativo provvisorio `com.example.ba` (va sostituito prima della pubblicazione: segnalalo nel report). `lib/design_system/tokens.dart` non va toccato.
4. **Struttura di `lib/`** come in `app/README.md`: `design_system/`, `features/`, `core/`, `l10n/`, con un `main.dart` minimo che mostra uno schermo vuoto con `BaColor.fondoApp` come sfondo. Niente `MaterialApp`: usa `WidgetsApp` o equivalente.
5. **Traduzioni.** `l10n.yaml` in `app/`, file ARB in `lib/l10n/` per IT, EN, FR, ES, DE, con una sola chiave di prova. `generate: true` nel `pubspec.yaml`.
6. **Font.** Instrument Sans e IBM Plex Mono (licenza OFL) in `app/assets/fonts/`, dichiarati nel `pubspec.yaml` con i nomi di famiglia usati in `tokens.dart`. Aggiungi accanto le licenze.
7. **Orientamento.** Solo verticale per ora (D-020), sia nella configurazione nativa sia in `main.dart`. Su iPad, segnala nel report cosa comporta (`UIRequiresFullScreen`): la scelta finale la facciamo con lo sviluppo.
8. **Test di partenza.** Un test che verifica che l'app si avvii, e un test su `tokens.dart` che legge almeno `BaPresenza.diametro()` per 1…8 persone e controlla la scala 208, 156, 130, 112, 88.
9. **CI verde** con il workflow già presente in `.github/workflows/ci.yml`.

## Do NOT

- Non modificare `tokens.dart`, nemmeno per i nomi segnalati (abbassata, collisione di `BaPresenza`): li correggono i task 001 e 004.
- Non scrivere widget del design system né schermate.
- Non aggiungere dipendenze oltre a quelle per traduzioni e test. LiveKit arriva con il task che lo usa.
- Non committare chiavi o file `.env`.

## Acceptance check

- [ ] `main` ha un solo commit, quello dello scheletro.
- [ ] Su `task/000-setup`, `flutter analyze` e `flutter test` passano.
- [ ] L'app si avvia su un simulatore iOS e su un emulatore Android con lo schermo vuoto del colore giusto.
- [ ] Le traduzioni si generano e la chiave di prova esiste in cinque lingue.
- [ ] I due font sono caricati e hanno la licenza accanto.
- [ ] Nessun import di Material o Cupertino in `lib/design_system/`.
- [ ] La CI è verde sulla pull request.

## Cosa restituire

Report in `docs/reports/000.md` e pull request con il template. Nel report: l'identificativo provvisorio da sostituire, la nota sull'orientamento su iPad, e qualsiasi incoerenza trovata in `tokens.dart` senza correggerla.
