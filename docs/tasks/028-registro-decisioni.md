# Task 028 — Registro delle decisioni degli stakeholder nella documentazione

20 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Andrea ha risposto alle 19 domande agli stakeholder e ha allegato i documenti di origine. Le risposte sono state riscritte come **D-035…D-054** in `Import/decisioni-da-aggiungere-2.md` (cartella ignorata da git; la mette Luca). Questo task le porta nei documenti della repo. **Solo documentazione**: nessun codice, token o design cambia. Fonti: il file di Import, `docs/DECISIONS.md`, `docs/FEATURES.md`, `docs/GLOSSARY.md`, `docs/handoff/aperte.md` e `docs/handoff/schermate.md`, `docs/tasks/README.md`.

## Do

1. **Branch** `task/028-registro-decisioni`, da `main` aggiornato.
2. **`DECISIONS.md`.** Aggiungi D-035…D-054 con lo stile esistente (data, contesto, decisione). Lo stato di ciascuna è nel file: **DECISO**, **DA DEFINIRE** (con il punto aperto) o **DA RIALLINEARE** (D-045, la palette chiaro/scuro). Dove una decisione modifica una vecchia, dillo come già fatto altre volte («sostituisce», «modifica in parte»): D-040 chiarisce D-031; D-043 modifica D-011 per i DEN pubblici creati da un utente. Registra anche che **due decisioni contraddicono il registro v4 di Andrea (§3 e §4)**: l'ascoltatore entra nei DEN privati se invitato (D-041) e un DEN pubblico creato da un utente ha un amministratore (D-043); Andrea ha confermato la sua risposta, e il registro va aggiornato da lui. Non toccare le «Aperte» già risolte senza dirlo nel report.
3. **`FEATURES.md`.** Dove una risposta lo dice **chiaramente**, aggiorna lo stato (per esempio H03, lo spot durante l'ascolto: escluso; E13, registrazione del palco: post-produzione per i creator; F02, Spotify e Apple Music: idea, non nei task; F01, ascolto condiviso: solo creator, non da subito; B05, permanenza massima: ascoltatori e parlatori). Nel dubbio non cambiare e scrivilo nel report.
4. **`docs/handoff/aperte.md`.** Aggiorna: le ipotesi chiuse dalle risposte diventano decisioni (con il numero D-0NN); aggiungi le ipotesi nuove segnate in D-040 (nuovo accesso dopo il cambio di tipo di account), D-042 (richiamo, scadenza del posto) e D-050 (la fonte del «next»); la tabella delle domande riporta per ogni numero la risposta in una riga (usa `Import/domande-stakeholder.md`, già nel 025). **Non dare per risolte** le ipotesi dei design 013–015 che il task di design 027 non ha ancora aggiornato: scrivi «da aggiornare nel design (task 027)».
5. **`GLOSSARY.md`.** Solo i termini nuovi che le decisioni introducono e il design già usa: **richiamo** (la notifica che dice che una persona è entrata in un DEN, con l'invito a passare) e **account bannato**. Se altri termini mancano, elencali nel report senza aggiungerli.
6. **Fonti.** Se Luca ha messo i documenti di Andrea in `Import/documenti-andrea/`, copia in `docs/origine/` **i cinque file** con il loro nome corretto (`BA_Decisioni_Consolidate_v4.md`, `BA_Tipologie_Account.md`, `BA_Ipotesi_Ideazione.md`, `BA_Brief_Design_v2.4.docx`, `BA_Guida_Prototipatore.docx`) e un `README.md` che spiega che nello zip originale tre file avevano il nome sbagliato (il «Benchmark competitivo» conteneva la Guida per il prototipatore; «Criticità riscontrate» e «Sintesi v-selfhosted» ripetevano le Tipologie di account e le Ipotesi di ideazione) e che i veri documenti di criticità, sintesi e benchmark non ci sono. Se la cartella non c'è, salta il punto e scrivilo nel report.
7. **Elenco dei task.** `docs/tasks/README.md`: 023b e 026, più 027 «Aggiornamento dei design 013–015» (Claude Design, brief scritto) e 028 «In corso».

## Do NOT

- Non modificare codice, token, test né design; non inventare decisioni: si registra solo ciò che c'è nel file di Import.
- Non cancellare decisioni vecchie: si marcano come sostituite.
- Non riscrivere i documenti di Andrea, nemmeno quelli copiati.

## Acceptance check

- [ ] D-035…D-054 sono in `DECISIONS.md` con lo stato di ciascuna; le sostituzioni e i conflitti con il registro v4 sono scritti.
- [ ] `FEATURES.md` cambia solo dove la risposta è chiara; il test sulla documentazione e `flutter analyze` e `flutter test` sono verdi; CI verde.
- [ ] `aperte.md` non dà per risolta nessuna ipotesi che il design non ha ancora aggiornato.
- [ ] Nessun file di `app/lib/` cambia.

## Cosa restituire

Branch `task/028-registro-decisioni`, report in `docs/reports/028.md` (massimo 20 righe): cosa è cambiato in ogni file, le righe di `FEATURES.md` lasciate invariate per dubbio, i termini del glossario che mancano e la riga «Impatto sull'handoff». Pull request con il template.
