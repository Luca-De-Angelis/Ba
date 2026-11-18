# Task 021b — Ritocchi al design system

16 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Dopo i task 010–021 sono rimasti quattro ritocchi, tutti piccoli e indipendenti dalle risposte degli stakeholder. Nessuno cambia un valore di design: sistemano punti in cui il codice usa un sostituto, un difetto di resa o un testo. Fonti: i report dei task 012, 015c, 020 e 021, `tokens.dart` (`BaBarraAzioniTokens.altro*`, `BaPresenzaTokens.dietroOpacita` e `dietroSfocatura`), `design/system/md/token.md` (T8), i prototipi `Stati critici 002.dc.html` e `Coda e attesa 015.dc.html`. Dove un documento tace, **proponi nel piano e segnala nel report**.

## Do

1. **Branch** `task/021b-ritocchi`, da `main` aggiornato (021 già unito).
2. **«Altro» con i token giusti.** `BaBarraAzioni` usa ancora i sostituti `xxs` (punti e spazio da 4) e `filettoMarcato` (0,14). Da 015c esistono `altroPuntoLato` (4), `altroPuntoGap` (3) e `altroBordo` (`a32`): usali. Aggiorna i test della barra, e non cambiare altro.
3. **Tratti dei glifi senza macchie.** Nei glifi, dove la barra incrocia l'anello (il cerchio barrato) e dove tocca il microfono, i due tratti semitrasparenti si sommano e lasciano punti più chiari. Disegna i tratti chiari **opachi dentro un livello** e applica la trasparenza (`glifoTratto`) al livello intero, così l'incrocio ha lo stesso colore del resto. Il casing scuro sotto la barra resta com'è. Vale per `BaGlifo` e per il disco (`BaDiscoGlifo`). Proponi nel piano come provarlo senza immagini di riferimento (per esempio verificando che il painter apre un solo livello con la trasparenza e che i tratti sono disegnati opachi).
4. **Etichette senza genere.** «bloccata» (IT), «bloquée» (FR) e «bloqueada» (ES) sono femminili e non valgono per ogni persona. Riformulale con un sostantivo («persona bloccata», «personne bloquée», «persona bloqueada») nella chiave `presenzaBloccata`; EN e DE sono già neutre. Aggiorna le chiavi e i test sulle traduzioni, e segnala nel report che restano **da rivedere a madrelingua**, come le altre.
5. **Le presenze dietro il foglio.** Quando un foglio è aperto, le presenze della stanza dietro devono ridursi a `dietroOpacita` (0,22) con `dietroSfocatura` (1,5): i token esistono, il velo da solo non basta. Leggi T8 e i prototipi per il comportamento (dissolvenza con il foglio o subito) e **proponilo nel piano**; con «riduci movimento» è immediato. `BaPalco` riceve un parametro (per esempio `dietro`) e lo applica **a tutte le presenze insieme**, senza cambiare disposizione, anello o stati; il palco non scorre mai. Nella stanza finta della galleria si accende mentre un foglio è aperto.
6. **Test del foglio più rapidi** (facoltativo, solo se non costa nulla). I test del foglio campionano ogni 10 ms e portano la suite a 65 s. Se si può avere lo stesso controllo con meno campioni, falla; altrimenti lascia com'è e scrivilo nel report.
7. **Documenti.** `docs/tasks/README.md`: 021 «Concluso», 021b «In corso». `app/README.md`: solo se cambia qualcosa che descrive.

## Do NOT

- Non modificare i valori di `tokens.dart` né aggiungere token; se manca un valore, segnalalo.
- Non toccare l'anello, la disposizione del palco né gli stati delle presenze oltre a quanto scritto al punto 5.
- Non costruire altri componenti; niente trascinamento del foglio.
- Niente Material o Cupertino, nuove dipendenze, golden, numeri di design scritti a mano; ogni import oltre `widgets.dart` va motivato nel file e in `CLAUDE.md`.

## Acceptance check

- [ ] `BaBarraAzioni` non contiene più `xxs` né il filetto `filettoMarcato` per «Altro»; i test passano.
- [ ] Il glifo non ha più punti più chiari all'incrocio; il test lo dimostra.
- [ ] Le tre etichette di «bloccata» non sono più femminili; le chiavi esistono in cinque lingue.
- [ ] Con un foglio aperto le presenze sono a 0,22 e sfocate di 1,5, tutte insieme; il palco non cambia disposizione; con «riduci movimento» è immediato.
- [ ] `flutter analyze` e `flutter test` verdi; CI verde.
- [ ] Nella galleria, la verifica di Luca: il cerchio barrato senza macchie, la barra con «Altro», la scheda aperta con le presenze dietro attenuate e sfocate, e le etichette nelle cinque lingue.

## Cosa restituire

Branch `task/021b-ritocchi`, report in `docs/reports/021b.md` (massimo 15 righe) con le **proposte dove i documenti tacciono** (come si prova il livello dei glifi, il comportamento delle presenze dietro il foglio) e ciò che non hai potuto verificare. Pull request con il template.
