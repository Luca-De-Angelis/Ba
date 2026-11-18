# Task 021 — BaFoglio, scheda della persona e BaMessaggio

13 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Quinto passo dei componenti, dopo i controlli (020): il **foglio**, che è il contenitore di tutto ciò che si apre sopra la stanza. Lo usano già i design consegnati: il consenso e il percorso «diventa partecipante» (013), «Crea un DEN», il sotto-DEN e «Gestisci» (014), e la **scheda di una persona** (002: «Muta questa voce», «Blocca», «Segnala» più un posto per le azioni nuove). L'«Altro» della barra delle azioni (020) chiama un `onAltro` che oggi non apre niente: con questo task apre un foglio. Fonti: `design/system/md/inventario-componenti.md` (C3: `BaFoglio`, `BaMessaggio`; la regola della barra e della scheda del task 002), `token.md` (T8 `foglio`, T11), `tokens.dart` (`BaRaggioTokens.foglio`, `BaColorTokens.superficieFoglio` e `veloSipario`, `BaMovimentoTokens.foglio` 240 ms, `BaSchedaPersonaTokens`, `BaAccessoTokens.foglioAltezza*` e `erroreSegno*`), i prototipi `Stati critici 002.dc.html` (scheda e «Altro»), `Accesso 013.dc.html` e `Creare DEN 014.dc.html` (i fogli a più passi). Dove un documento tace, **proponi nel piano e segnala nel report**.

Restano fuori, per i prossimi task: `BaFoglioGestisci` e gli altri contenuti dei fogli (si compongono con questi pezzi), i campi di testo, la fascia «chi mi sente».

## Do

1. **Branch** `task/021-fogli`, da `main` aggiornato (020 e 020b già uniti).
2. **`BaFoglio`** (`lib/design_system/foglio.dart`). Un foglio dal basso su un velo (`veloSipario`), con `BaRaggioTokens.foglio` in alto e `superficieFoglio`. Tre varianti: **richiesta** (un permesso: titolo, testo, azioni), **scheda presenza**, **invito**. Stati: chiuso, in salita (240 ms, immediato con «riduci movimento»), aperto, **con il contenuto più alto dello schermo**: ciò che sta sopra le azioni **scorre**, le azioni **restano ancorate in basso** (T11). Altezza massima: la frazione che i token dicono per il foglio a più passi (`foglioAltezzaTelefono` 0,80 e `foglioAltezzaTablet` 0,62); per gli altri fogli proponi la regola. Su tablet il foglio resta nella colonna centrale. Si apre con un'API di navigazione (per esempio `showBaFoglio`) costruita con `widgets.dart` (`PageRouteBuilder`): niente Material. Si chiude toccando il velo, con il gesto «indietro» del sistema e con un'azione; proponi se aggiungere il trascinamento verso il basso. L'etichetta per lo screen reader e i testi arrivano dal chiamante.
3. **Accessibilità del foglio.** Quando si apre il focus va dentro e al tasto Tab resta dentro; quando si chiude torna dov'era; il foglio si annuncia come finestra (`namesRoute` e `scopesRoute`), con il titolo come nome. Non annuncia l'arrivo di nessuno (D-034). Tutto ciò che sta dietro è escluso dalla semantica finché il foglio è aperto.
4. **`BaSchedaPersona`** (`lib/design_system/scheda_persona.dart`), contenuto di un foglio «scheda presenza». In alto il nome e lo stato in una riga; poi **le tre righe fisse** (`BaSchedaPersonaTokens.fisse`, `rigaFissa`): «Muta questa voce» (disattivata quando la persona non sta parlando, con la riga di spiegazione «Si può mutare solo mentre parla»), «Blocca», «Segnala»; sotto, **una riga per ogni azione nuova** passata dal chiamante, con `rigaMinima`. Ogni riga ha un titolo e al più una riga di spiegazione, e un'area toccabile di almeno 44. Le azioni sono callback: la scheda non esegue niente da sola.
5. **`BaMessaggio`** (`lib/design_system/messaggio.dart`). Due varianti, **neutro** e **errore**; stati assente e presente. Uno solo per schermata (lo scrivi nel commento; in debug un assert non è possibile da dentro il widget, quindi lo documenti). L'errore **non si riempie mai**: riquadro con filetto `erroreFiletto`, segno «!» di `erroreSegnoLato` con tratto `erroreSegnoTratto`, e testo; mai il solo colore. Un messaggio di errore si annuncia allo screen reader; uno neutro no. Il testo va a capo a testo grande, senza tagli.
6. **«Altro» apre il foglio.** Nella stanza finta della galleria, `onAltro` apre un `BaFoglio` con le azioni oltre la terza, come righe; toccare una presenza apre la scheda. Mostra così il punto di aggancio per le azioni nuove della scheda.
7. **Galleria.** Una pagina nuova «Fogli e messaggi»: un pulsante per ciascuna variante di foglio, con contenuto corto e contenuto lungo (che scorre con le azioni ancorate); la scheda con e senza azioni nuove, e con la persona che non parla; i due messaggi. Controlli di sempre: testo 1,0 e 2,0, riduci movimento, 360 e 744. Testi fissi (galleria esente da l10n).
8. **Documenti.** `docs/tasks/README.md`: 020 e 020b «Concluso», 021 «In corso», 022 «Contenuti dei fogli: Gestisci, Crea un DEN, percorso diventa partecipante» (brief da scrivere). `app/README.md`: i componenti nuovi.

## Test (di widget, senza golden)

- **Foglio:** in salita in 240 ms e immediato con «riduci movimento»; il velo chiude; il gesto «indietro» chiude; a testo 2,0 con contenuto lungo il contenuto scorre e le azioni restano in basso; altezza massima 0,80 (telefono) e 0,62 (tablet); il focus entra e torna; la semantica ha il nome del foglio e lo sfondo è escluso.
- **Scheda:** le tre righe fisse nell'ordine; «Muta questa voce» disattivata se non parla, con la spiegazione; le azioni nuove vengono dopo le fisse; ogni riga ha area ≥ `areaMinima`; a 2,0 nessun overflow.
- **Messaggio:** l'errore ha filetto, segno e testo e **nessun fondo pieno**; il neutro non ha segno; l'errore è annunciato e il neutro no; a 2,0 il testo va a capo.
- **Galleria:** «Altro» apre il foglio con le azioni dalla quarta; toccare una presenza apre la scheda.

## Do NOT

- Non costruire `BaFoglioGestisci`, i campi di testo, né i contenuti dei task 013 e 014: sono il 022.
- Non scrivere codice di suono né di vibrazione.
- Non toccare `tokens.dart` (se manca un valore, segnalalo), né i componenti esistenti, a parte `onAltro` nella stanza finta.
- Niente Material o Cupertino, nuove dipendenze, golden, numeri di design scritti a mano; ogni import oltre `widgets.dart` va motivato nel file e in `CLAUDE.md`.

## Acceptance check

- [ ] I test passano; `flutter analyze` e `flutter test` verdi; CI verde.
- [ ] Nessun numero di design a mano; nessuna eccezione di import non motivata.
- [ ] Nella galleria, la verifica di Luca: il foglio sale e scende; con contenuto lungo scorre e le azioni restano in basso; la scheda ha le tre righe e il posto per le nuove; l'errore non è mai pieno; «Altro» e la presenza aprono davvero qualcosa; a testo 2,0 nulla si taglia.

## Cosa restituire

Branch `task/021-fogli`, report in `docs/reports/021.md` (massimo 30 righe) con le **proposte dove i documenti tacciono** (altezza dei fogli diversi dal percorso a più passi, il trascinamento, la gestione del focus, l'annuncio dell'errore) e ciò che non hai potuto verificare. Pull request con il template.
