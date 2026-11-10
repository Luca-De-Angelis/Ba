# Task 009 — BaTouchable e la galleria per vederlo

9 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Primo widget del design system. L'Inventario lo vuole per primo: porta premuto, focus e area minima a tutto il resto, e "non si taglia niente in BaTouchable". Fonti: `design/system/md/token.md` (T7 bis, T8), `design/system/md/inventario-componenti.md` (C7 bis e accessibilità), `tokens.dart` (`BaControlloTokens`: `areaMinima`, `areaEstesa`, `focusSpessore`, `focusStacco`, `premutoScala`; `BaMovimentoTokens`: `premutoAndata`, `premutoRitorno`; `BaColorTokens`: `premutoVelo`, `premutoKeyline`, `focusAnello`).

Oggi nessuno può vedere l'app girare (niente Android Studio, niente Mac). Per questo il task aggiunge una **galleria**: una pagina di sviluppo da aprire in Chrome. Il web serve solo a questo e non è una piattaforma di prodotto.

## Do

1. **Branch** `task/009-batouchable`.
2. **Web per la galleria.** Da `app/`: `flutter create --platforms=web .` senza sovrascrivere i file esistenti. Controlla con `flutter doctor` che Chrome compaia; se non c'è, fermati e dimmelo. Non cambiare le dipendenze e non toccare le cartelle `ios/` e `android/`.
3. **`BaTouchable`**, in `app/lib/design_system/touchable.dart`. Solo `package:flutter/widgets.dart`: niente Material, niente `InkWell`.
   - Parametri: `semanticsLabel` (obbligatorio), `onTap` (nullo = inattivo), `variante` (`standard` o `suPresenza`), `suChiara` (falso di default), `estensione` (`EdgeInsets`, zero di default; la costante `BaTouchable.estesa = EdgeInsets.all(BaControlloTokens.areaEstesa)` dà gli 8 dp su ogni lato), e **uno solo** fra `child` e `builder`. Il `builder` riceve un `BaStatoTocco` (`premuto`, `aFuoco`, `inattivo`) così `BaPresenza` potrà disegnare la propria keyline.
   - **Area minima.** L'area toccabile non scende mai sotto 44 × 44 (`areaMinima`), anche se il contenuto è più piccolo. Con `estensione` l'area sporge oltre il bordo visibile, lato per lato (`BaTouchable.estesa`: 8 dp, `areaEstesa`, su ogni lato). L'estensione è un `EdgeInsets` e non un booleano perché in una coppia (gap 10) due estensioni di 8 si sovrappongono di 6 dp e la pillola dipinta dopo si prenderebbe l'area dell'altra: la coppia usa mezzo gap verso la vicina e `areaEstesa` sugli altri lati.
   - **Premuto, variante standard.** Fondo `premutoVelo` e scala `premutoScala` (0,98), 90 ms all'andata e 140 al ritorno (`premutoAndata`, `premutoRitorno`). La scala è una trasformazione: i vicini non si spostano. Con "riduci movimento" (`MediaQuery.disableAnimations`) si omette la scala e resta il fondo: non si taglia lo stato, solo la resa.
   - **Premuto, variante `suPresenza`.** Nessuna scala. Il `builder` riceve `premuto: true`, e la keyline diventa `premutoKeyline`.
   - **Focus.** Anello singolo, `focusSpessore` (2), staccato di `focusStacco` (3), immobile, colore `focusAnello`; con `suChiara` colore `testoSuChiara`. **Sempre visibile quando c'è il focus**, per qualunque via (Tab, `requestFocus` programmatico, anche con la modalità touch come ultima interazione), senza dipendere da `FocusHighlightMode`. **Il tocco non richiede il focus**: l'anello serve per tastiera esterna e controllo interruttori (T7 bis), quindi dopo un tocco su telefono non deve restare. Non si anima mai.
   - **Inattivo.** Senza `onTap`: nessun feedback, non focalizzabile, semantica `enabled: false`. Lo stile lo decide il contenuto tramite il `builder`.
   - **Semantica.** Nodo con l'etichetta, `button: true` e l'azione di tocco; il contenuto visivo è escluso dalla semantica. Enter e spazio attivano `onTap`.
4. **Test di widget**, senza golden:
   - area: con un contenuto di 20 × 20, un tocco a 20 dp dal centro lo colpisce e uno a 23 dp no; con `estensione: EdgeInsets.all(8)` la soglia sale di 8; in una coppia con gap 10 ed estensione di mezzo gap (5) verso la vicina, un tocco a 3 dp dal bordo del gap va alla pillola di sinistra e uno a 7 dp a quella di destra;
   - premuto standard: dopo 90 ms la scala è 0,98, dopo il rilascio e 140 ms torna 1; il fondo è `premutoVelo`; un secondo `BaTouchable` accanto non cambia posizione;
   - riduci movimento: scala sempre 1, fondo presente;
   - `suPresenza`: nessuna `Transform` di scala, il `builder` vede `premuto` vero;
   - focus: dopo `requestFocus` programmatico l'anello è disegnato, anche con la modalità touch come ultima interazione; un tocco non dà il focus e non disegna l'anello; sparisce quando il focus si perde; non ha animazioni;
   - inattivo: il tocco non fa niente, non prende focus, `enabled` falso;
   - semantica: etichetta, flag `button`, azione di tocco; Enter attiva.
5. **Galleria.** `app/lib/galleria/main_galleria.dart` e `galleria_touchable.dart`. Sfondo `fondoApp`, solo token. Mostra `BaTouchable` come pillola grande (56), come coppia di pillole (48, gap 10, con `estensione` di mezzo gap verso la vicina e `areaEstesa` sugli altri lati; la galleria legge l'estensione dal widget, non dal token), come riga larga quanto lo schermo, inattivo e `suPresenza` su un cerchio con keyline. Controlli di sviluppo: "mostra le aree toccabili" (contorno semitrasparente), "riduci movimento" e la larghezza (360 oppure 744). Si lancia da `app/` con `flutter run -d chrome -t lib/galleria/main_galleria.dart`. La galleria è uno strumento di sviluppo: i testi sono fissi e non vanno in `l10n/`.
6. **Documenti.** `CLAUDE.md`: una riga sulla galleria, che il web è solo per questo e che è esente da `l10n/`. `app/README.md`: come lanciarla. `docs/DECISIONS.md`: D-030 (testo qui sotto). `docs/tasks/README.md`: 008 "Concluso", 009 "In corso", 010 "BaRitratto, BaAnello, BaPresenza: brief da scrivere", 011 "BaPalco (widget) e la stanza vuota con una persona: brief da scrivere".

| ID | Data | Decisione | Fonte | Stato |
| --- | --- | --- | --- | --- |
| D-030 | 9/11/2026 | Il web serve solo come galleria di sviluppo per vedere i componenti in Chrome: non è una piattaforma di prodotto. I target restano iOS e Android | Task 009 | Valida |

## Do NOT

- Non scrivere `BaRitratto`, `BaAnello`, `BaPresenza` né il palco: sono i task 010 e 011.
- Non importare Material o Cupertino; non aggiungere dipendenze; non toccare `tokens.dart`.
- Non cambiare `main.dart` dell'app né la build di iOS e Android.
- Non scrivere test golden.

## Acceptance check

- [ ] I test del punto 4 passano; `flutter analyze` e `flutter test` verdi; CI verde.
- [ ] Nessun numero scritto a mano in `touchable.dart`: solo token.
- [ ] La galleria si apre in Chrome con il comando del punto 5. **La verifica visiva la fa Luca**: il premuto cede e torna senza spostare i vicini; l'anello di focus si vede con il tasto Tab (e non resta dopo un clic); le aree toccabili mostrate sono almeno 44 × 44; a 744 il comportamento è lo stesso.

## Cosa restituire

Branch `task/009-batouchable`, report in `docs/reports/009.md` (massimo 30 righe) con il comando esatto per aprire la galleria e ciò che non hai potuto verificare. Pull request con il template.
