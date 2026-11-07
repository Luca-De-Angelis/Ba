# Task 005 — BaPalco: la disposizione come funzione pura

7 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Primo task con logica di prodotto. È il punto dell'app dove un layout decide una misura: dato quante persone sono sul palco e la scatola che avanza (dopo il testo), si calcolano il diametro e le posizioni delle presenze. Fonti, in ordine: `tokens.dart` (`BaPresenza.diametro`, `distanzaMinima`, `iniziali`), `design/system/md/token.md` (T6 e T6 bis), `design/system/md/inventario-componenti.md` (C6, C7, C7 bis).

Va scritta come funzione pura *(conteggio, scatola) → posizioni + diametro*, senza stato e senza widget, perché è l'unico modo di verificarla con test invece che a occhio. **Non serve emulatore né Mac: si verifica tutta con `flutter test`.**

Per l'alpha basta una disposizione fissa per conteggio. Fuori da questo task: l'irregolarità dell'impacchettamento, l'assestamento animato e qualunque widget.

## Do

1. **File e nomi.** `app/lib/design_system/palco/disposizione.dart`, con `disponiPalco({required int persone, required Size scatola})` che restituisce `BaDisposizionePalco`: `diametro` (double), `centri` (`List<Offset>`, relativi all'angolo in alto a sinistra della scatola) e `sfora` (bool). I nomi `BaPalco` e `BaPresenza` sono dei widget (D-021): non usarli per classi nuove.
2. **Persone.** Da 1 a 8. Con 0 restituisce nessun centro (lo stato vuoto si disegna altrove). Fuori da 0–8 lancia `ArgumentError`.
3. **Diametro di partenza** da `BaPresenza.diametro(persone)`: non copiare 208, 156, 130, 112, 88 (task 004 può cambiarli per il tablet). Se la scatola non basta, il diametro scende in modo **continuo** (non a gradini) fino a 32. Le iniziali non si calcolano qui: si chiede `BaPresenza.iniziali(diametro)`.
4. **Distanza minima.** Fra due centri qualsiasi, distanza ≥ `BaPresenza.distanzaMinima(diametro)`. **Non si stringe mai**: se una fila non ci sta, si cambia disposizione o si riduce il diametro.
5. **Margine esterno.** Ogni presenza sta dentro la scatola con 9 dp di margine per lato (anello 5 + crescita al picco 4: sono i 18 della formula di T6 bis). Il valore non è in `tokens.dart`: tienilo in una costante privata con nome e commento, e segnalalo nel report.
6. **Disposizione fissa.** Stesso input, stesso output: niente casualità. Righe da *k* presenze, dove una fila chiede `(k−1)·(d+17) + d + 18` dp di larghezza. Quando la larghezza lo permette, righe sfalsate di mezzo passo per risparmiare altezza. A 360 dp (scatola larga 320) la coppia a 156 non sta affiancata: va in diagonale.
7. **Ordine dei centri.** Dall'alto in basso e da sinistra a destra: è l'ordine di lettura per lo screen reader. Chi chiama decide quale persona va a quale posizione.
8. **Scatola troppo piccola.** Nessuna presenza sparisce e la distanza non si stringe. Se nemmeno a 32 dp la disposizione entra, restituisci la disposizione a 32 con `sfora: true`. È una proposta: se trovi un caso in cui non regge, dillo nel report.
9. **Test con `test`, non `testWidgets`.** Scatola 320 × 420 per i casi base, altezze ridotte per la cessione.

## Do NOT

- Non toccare `tokens.dart`: i valori mancanti si segnalano, li porta nel file un task di design.
- Non scrivere widget, animazioni, assestamento o irregolarità.
- Non aggiungere dipendenze né importare Material o Cupertino.
- Non scrivere a mano numeri che esistono nei token.

## Acceptance check

- [ ] 1 persona: `208`, riga da 226 dp, centrata.
- [ ] 2 persone a 320 dp: `156`, **non affiancate** (347 dp non ci stanno), centri in diagonale.
- [ ] 3 e 4: `130`, due per riga (295 dp). 5 e 6: `112`, due per riga (259 dp); tre per riga (388 dp) mai.
- [ ] 7 e 8: `88`, tre per riga (316 dp, margine di 4 dp su 320).
- [ ] Per ogni conteggio da 1 a 8 e per scatole di larghezza 300, 320, 360, 480, 744: tutte le distanze ≥ `d + 17`, tutte le presenze dentro la scatola con 9 dp di margine, risultato identico a ogni chiamata.
- [ ] Il diametro non cresce se la scatola si restringe, né se aumentano le persone.
- [ ] Otto persone in una scatola 150 × 150: `sfora` falso e diametro ≥ 32.
- [ ] Scatola più piccola del minimo: `sfora` vero, nessun centro in meno, nessuna distanza ridotta.
- [ ] `flutter analyze` e `flutter test` verdi; CI verde.

## Cosa restituire

Branch `task/005-bapalco-disposizione`, report in `docs/reports/005.md` (massimo 30 righe) e pull request con il template. Nel report: la costante del margine esterno da portare in `tokens.dart`, la regola con cui hai scelto righe e sfalsamento, ed eventuali casi in cui il punto 8 non regge. Se i task 001 o 004 sono già nel `main`, riallinea i nomi dei token prima di aprire la pull request.
