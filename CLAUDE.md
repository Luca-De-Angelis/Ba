# BA — istruzioni per Claude Code

BA è un social vocale basato sulla presenza. Le persone stanno nei DEN: un palco di massimo 8 voci e un pubblico che ascolta. App Flutter per iOS e Android, una sola base di codice. Leggi questo file all'inizio di ogni sessione: sostituisce i riassunti.

## Fonti di verità, in ordine

1. `docs/DECISIONS.md` — le decisioni prese. Non si cambiano senza chiedere.
2. `docs/brief/` — brief v2.1 e aggiornamento v2.2. Dove divergono, vale la v2.2.
3. `app/lib/design_system/tokens.dart` — ogni valore visivo: colori, misure, durate. Se un numero esiste, esiste lì.
4. `design/system/md/` — perché i valori sono quelli e cosa costruire (Token, Inventario componenti, decisioni consolidate). Sono copie di lettura: in caso di divergenza vince `tokens.dart`.
5. `docs/tasks/NNN-*.md` — il task in corso, con il suo acceptance check.
6. `design/handoff/NNN/` — la consegna di Claude Design per quel task, se c'è interfaccia nuova.

`design/system/md/fase-2-schermate.md` e `stanza-den.md` sono esplorazione e storia: non sono normativi.

## Regole

- **Design system.** Niente Material o Cupertino come linguaggio visivo. In `lib/design_system/` si importa solo `package:flutter/widgets.dart` (eccezioni: `touchable.dart` importa anche `package:flutter/rendering.dart`, per l'area estesa, task 009; `palco.dart` importa anche `package:flutter/semantics.dart`, solo per `OrdinalSortKey`, che fissa l'ordine di lettura, task 011). Nessun numero scritto a mano nei widget: solo token. Se un valore manca, aggiungilo a `tokens.dart` con un nome e segnalalo nel report.
- **Galleria (D-030).** `app/lib/galleria/` è la pagina di sviluppo per vedere i componenti in Chrome: da `app/`, `flutter run -d chrome -t lib/galleria/main_galleria.dart`. Il web serve solo a questo: i target restano iOS e Android. La galleria è esente da `l10n/` (testi fissi).
- **Token a due livelli (D-019).** Le scale primitive seguono il modello di Tailwind: spaziature su base 4 (`n × 4`), tipografia, raggi e colori con nomi alla Tailwind. I token semantici di BA (`fondoApp`, `testoPrimo`…) fanno riferimento alle primitive. Un valore fuori scala è ammesso solo se è un'eccezione documentata in `tokens.dart`.
- **Mobile first e tablet (D-020).** Si progetta e si scrive prima per il telefono più stretto (360 dp). Il tablet arriva con i breakpoint di `tokens.dart`, decisi in base alla larghezza, mai all'orientamento. Il tablet si decide sulla larghezza dello schermo, da 600 dp (D-027), mai su quella di una scatola né sull'orientamento. Per ora solo verticale: nessun layout deve dare per scontato che resti così.
- **Nomi.** Classi, variabili e testi usano i termini di `docs/GLOSSARY.md`. Mai "Loggia", "abbassa/abbassata", "Mutami". I nomi `Ba<Componente>` sono dei widget; le classi di token hanno il suffisso `Tokens` (D-021). `BaOra`, `BaPayloadStanza` e `BaRegole` restano senza suffisso (D-028).
- **Testi.** Nessuna stringa fissa nell'interfaccia: tutto in `app/lib/l10n/` (file ARB, configurati da `app/l10n.yaml`), cinque lingue (IT, EN, FR, ES, DE). Il tedesco allunga le etichette fino al 30%.
- **Traduzioni nuove.** Le chiavi ARB nuove richiedono la revisione dei madrelingua prima del rilascio: il report del task elenca quelle da rivedere.
- **Accessibilità.** Ogni presenza ha un'etichetta per lo screen reader; lo screen reader annuncia i cambi di stato di chi usa l'app (il proprio microfono, la salita sul palco, la parola ricevuta o revocata, la linea persa e ripresa), mai l'ingresso o l'uscita di altre persone né il loro stato: si leggono sul palco (ingresso morbido, D-034); aree toccabili di almeno 44 pt; contrasto AA; rispetto della riduzione delle animazioni.
- **Stati critici.** Microfono acceso o spento, chi ti sente, parola ricevuta: mai affidati solo alla vista o solo al colore.
- **Dati personali.** Nessun audio con voci vere nella repo: i test usano file sintetici. Chiavi e credenziali solo in `.env`, mai committate.
- **Decisioni.** Se il task chiede di cambiare qualcosa che è in `docs/DECISIONS.md`, fermati e chiedi.

## Come si lavora

1. Un branch per task: `task/NNN-nome`. Mai commit diretti su `main`, con una sola eccezione: il primo commit dello scheletro della repo.
2. Prima di scrivere codice, in Plan mode: leggi il brief del task e solo i documenti che servono, poi proponi il piano e aspetta l'approvazione.
3. Leggi con ricerche mirate e a intervalli, non file interi: i documenti di design sono lunghi.
4. Commit piccoli, ognuno con un messaggio che dice cosa e perché.
5. Prima della pull request lancia `/verify NNN`: scrive `docs/reports/NNN.md` (massimo 30 righe).
6. Apri la pull request con il template. La review la fa Claude AI sul diff e sul report.

## Quando fermarsi e chiedere

- Una scelta di prodotto non è chiara dal brief o dalle decisioni.
- Il cambiamento tocca un'invariante: stati critici, regole in `BaRegole`, valori in `tokens.dart`, consenso e dati personali.
- Lo stesso bug ricompare dopo due tentativi.

## Comandi (da `app/`)

```bash
flutter pub get
flutter analyze
flutter test
flutter test --update-goldens   # solo se il task lo chiede esplicitamente
```

## Cosa non è in questa repo (per ora)

Server (Servizio), LiveKit, coturn e la pipeline di trascrizione non sono ancora collocati: potrebbero vivere in un'altra repo. Vedi `README.md`.
