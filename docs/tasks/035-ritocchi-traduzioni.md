# Task 035 — Ritocchi 2 e foglio di revisione delle traduzioni

25 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Il design system e il prototipo sono completi; restano **piccoli debiti tecnici** emersi nelle revisioni dei task 020–024 e **la revisione delle traduzioni** da parte di madrelingua (D-045: lingue di interfaccia dinamiche; italiano per l'alpha, poi inglese). Questo task li chiude senza cambiare nessun comportamento visibile. Fonti: `docs/handoff/componenti.md`, `regole.md`, `produzione.md` e `aperte.md`, `CLAUDE.md`, `app/README.md`, i file ARB in `app/lib/l10n/`, i componenti `BaFasciaAttesa` e `BaPubblico`, `BaFraseErrore`, `BaMovimentoTokens` in `tokens.dart`, e la galleria. Dove un documento tace, **proponi nel piano e segnala nel report**.

## Do

1. **Branch** `task/035-ritocchi-traduzioni`, da `main` aggiornato (024c già unito).
2. **Sagoma duplicata.** `BaFasciaAttesa` e `BaPubblico` disegnano la stessa sagoma: estraila in un solo punto condiviso **senza cambiare l'aspetto** (i test esistenti passano senza modifiche; aggiungi un test che prova che le due usano lo stesso disegno).
3. **Segno «!» duplicato.** Lo stesso segno compare in più componenti (frase d'errore, campo, messaggio): un solo disegno condiviso, stesso aspetto, test invariati.
4. **`dart:math`.** L'eccezione all'import è usata ma non è scritta in `CLAUDE.md`: documentala (dove, perché, quali funzioni) nella regola degli import.
5. **Chiavi ARB.** Documenta in `app/README.md` come sono fatte le chiavi dei testi (convenzione dei nomi, descrizioni, segnaposto) e come si aggiunge una lingua.
6. **`BaMovimentoTokens.statico`.** Verifica se è usato. Se non lo è, **non cancellarlo** (`tokens.dart` è del design): aggiungi un commento «riservato, nessun uso» **solo se** il design lo prevede, altrimenti segnalalo nel report per il consolidamento (task 032).
7. **Etichette della galleria.** Le etichette degli stati dell'intestazione si leggono come i nomi nel codice («suInvito», «inIngresso»): scrivile in italiano (solo `lib/galleria/`, esente da l10n).
8. **Foglio di revisione delle traduzioni.** Uno script in `tool/` (Dart, nessuna dipendenza nuova) che, **da tutti i file ARB**, produce **un file CSV per ogni lingua** (UTF-8 con BOM, apribile in Excel), con le colonne: chiave, contesto (la descrizione dell'ARB), italiano, la lingua, **correzione** (vuota), **nota** (vuota), lunghezza e se il testo contiene segnaposto. Salva i file in `docs/traduzioni/` con un `README.md` che spiega come si compila e come si riporta una correzione negli ARB; non cambiare nessun ARB. Aggiungi un test che lo script produce una riga per chiave e che i segnaposto coincidono fra le lingue.
9. **Documenti.** `docs/handoff/componenti.md` (i due componenti che cambiano internamente), `produzione.md` (le traduzioni: la revisione dei madrelingua, come si fa e cosa si riporta), `aperte.md`, `app/README.md`, `docs/tasks/README.md` (035 «In corso»; 031 e 034 restano «Brief da scrivere»), e nel report la riga «Impatto sull'handoff».

## Do NOT

- Non cambiare nessun comportamento o aspetto: i test esistenti dei componenti passano **senza modifiche**.
- Non modificare `tokens.dart` né gli ARB, non aggiungere dipendenze, Material o Cupertino, né numeri di design a mano.
- Non tradurre né correggere testi: il task prepara la revisione, non la fa.

## Acceptance check

- [ ] `BaFasciaAttesa` e `BaPubblico` condividono la sagoma; il «!» è disegnato in un solo punto; nessun test esistente è modificato.
- [ ] `CLAUDE.md` descrive l'eccezione `dart:math`; `app/README.md` descrive le chiavi ARB e come si aggiunge una lingua.
- [ ] Lo script produce un CSV per lingua con una riga per chiave; il test lo prova.
- [ ] `flutter analyze` e `flutter test` verdi (suite entro i 50 secondi); CI verde; il test sulla documentazione passa.

## Cosa restituire

Branch `task/035-ritocchi-traduzioni`, report in `docs/reports/035.md` (massimo 20 righe) con ciò che è cambiato, `BaMovimentoTokens.statico` (usato o no), i valori mancanti, e la riga «Impatto sull'handoff». Pull request con il template.
