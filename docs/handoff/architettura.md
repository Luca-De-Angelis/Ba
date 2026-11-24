# Architettura: come è fatto

La struttura del codice, i principi che lo reggono, il modello della stanza e come si aggiunge un componente o un token. Per i singoli componenti vedi [componenti](componenti.md); per far girare tutto vedi [avvio](avvio.md).

Torna all'[indice](README.md).

## Che cosa c'è in `app/lib/`

```
app/lib/
├── design_system/   tokens.dart + i componenti (un file per componente) + palco/disposizione.dart
├── galleria/        pagine di sviluppo per vedere i componenti in Chrome (D-030)
├── l10n/            i file di traduzione (.arb) e, generati e non committati, app_localizations*.dart
├── core/            vuota (solo .gitkeep)
├── features/        vuota (solo .gitkeep)
└── main.dart        uno schermo vuoto del colore di fondo
```

- **`design_system/`** è tutto ciò che esiste oggi di prodotto: i token e 28 file di componenti. L'elenco completo, riga per riga, è in [componenti](componenti.md).
- **`design_system/palco/disposizione.dart`** non è un widget: è la **funzione pura** `disponiPalco(persone, scatola, larghezzaSchermo)` che restituisce diametro e centri delle presenze (`BaDisposizionePalco`: `diametro`, `centri`, `sfora`). `BaPalco` la usa; i test la provano da sola (`palco_disposizione_test.dart`).
- **`galleria/`** è uno strumento di sviluppo, fuori dall'app e fuori dalle traduzioni (D-030). Non si porta in produzione: vedi [produzione](produzione.md).
- **`l10n/`**: cinque lingue (IT, EN, FR, ES, DE), l'italiano è il file di riferimento (`template-arb-file: app_it.arb` in `app/l10n.yaml`). I componenti del design system **non importano le traduzioni**: i testi arrivano dal chiamante.
- **`core/` e `features/`** sono vuote. L'`app/README.md` le descrive come il posto dell'audio e del servizio (`core/`) e di accesso, home, stanza e impostazioni (`features/`); sono indicazioni di struttura, non codice esistente. Chi le riempie decide la forma: **da verificare** con il team.
- **`main.dart`** avvia `BaApp`, un `WidgetsApp` con uno schermo vuoto, i delegati di traduzione e il blocco in verticale (D-020). Nient'altro.

I test stanno in `app/test/`: un file per componente (più i test dei token, delle traduzioni, della galleria e della disposizione del palco). Sono test di widget, **senza golden**; niente immagini di riferimento nella repo. Due cose da sapere:

- Alcuni test dipendono dal tempo (animazioni con durate esatte): la regola è «durata + 1 ms», perché un `AnimationController` finisce solo al primo fotogramma oltre la durata (lo dice anche la voce «Aggiornamento di Flutter» in [`DECISIONS.md`](../DECISIONS.md)).
- `anteprima_disposizioni_test.dart` **scrive** il file `design/handoff/005/disposizioni.svg` quando gira: se l'output cambia, dopo `flutter test` quel file risulta modificato in `git status`.

## I principi

1. **I token sono la fonte di verità** ([`tokens.dart`](../../app/lib/design_system/tokens.dart)). Se un numero esiste, esiste lì; i documenti di design (`design/system/md/`) ne spiegano il perché, ma in caso di divergenza vince il file (D-009, D-010). Nei widget non si scrive nessun numero di design: se un valore manca, si aggiunge a `tokens.dart` con un nome e si segnala nel report del task.
2. **Token a due livelli (D-019).** Le **primitive** seguono il modello di Tailwind: `BaPaletteTokens` (colori, `pietra50`…), `BaPrimitiveTokens` (spazio `sp1`…, tipografia, raggi). I **token semantici** di BA (`BaColorTokens.fondoApp`, `testoPrimo`…) ci fanno riferimento e sono gli unici che i widget leggono. Un valore fuori scala è ammesso solo come **eccezione documentata** (un numero nel nome, come `text22`, o un commento con il motivo accanto).
3. **Solo `widgets.dart`.** In `design_system/` si importa solo `package:flutter/widgets.dart`. Niente Material né Cupertino come linguaggio visivo: la CI lo controlla con un grep ([produzione](produzione.md)). Le **eccezioni**, scritte in [`CLAUDE.md`](../../CLAUDE.md), sono tre, tutte motivate nel file stesso:
   - `touchable.dart` importa anche `package:flutter/rendering.dart`, per estendere l'area toccabile nel hit test (task 009);
   - `palco.dart` importa anche `package:flutter/semantics.dart`, solo per `OrdinalSortKey`, che fissa l'ordine di lettura (task 011), e `dart:ui`, solo per `ImageFilter`, che sfoca le presenze dietro un foglio (task 021b).
   - `dart:math` compare in `anello.dart`, `glifo.dart` e `disposizione.dart` per le funzioni matematiche: non è elencato in `CLAUDE.md` (è una libreria di base di Dart, non di Flutter). **Da verificare** con chi mantiene la regola se va dichiarato.
4. **Nomi (D-021, D-028).** `Ba<Componente>` è riservato ai widget (`BaPresenza`, `BaPalco`); le classi di token finiscono in `Tokens` (`BaPresenzaTokens`, `BaColorTokens`). Tre classi non sono né l'uno né l'altro e restano senza suffisso: `BaOra`, `BaPayloadStanza`, `BaRegole`. I termini sono quelli di [`GLOSSARY.md`](../GLOSSARY.md): mai «Loggia», «abbassa/abbassata», «Mutami» (D-008).
5. **Mobile first, e il tablet si decide sulla larghezza (D-020, D-027).** Si progetta per 360 dp (D-022); dal tablet (da 600 dp) `BaLayoutTokens` cambia margini e colonna e `BaPresenzaTokens` la scala del palco (1,5). Mai una regola sull'orientamento.
6. **I testi non stanno nei componenti.** Nessuna stringa fissa nell'interfaccia: arrivano dal chiamante, che le legge da `l10n/`. Fa eccezione la galleria.
7. **Accessibilità e stati critici** sono requisiti dei componenti, non rifiniture: etichetta per lo screen reader su ogni presenza, aree toccabili di almeno 44, contrasto AA, rispetto di «riduci movimento»; microfono, «chi ti sente» e parola ricevuta mai affidati al solo colore. Le regole operative sono in [regole](regole.md).

## Il modello della stanza

Tre cose, tutte in `tokens.dart` (fine del file, sezioni «tempo, payload» e «regole»), più i tipi del palco in `palco.dart`:

- **`BaPersonaPalco`** (in `palco.dart`): una persona sul palco, come arriva dall'evento di ingresso e dalla stanza. Campi: `id` (stabile e unico: tiene vivo lo stato dell'anello quando altri entrano o escono), `indiceTinta` e `indiceSagoma` (assegnati dalla stanza), `iniziali`, `immagine`, `parla`, `ampiezza`, `persa`, `mutata`, `bloccata`, `microfonoSpento`, `haLaParola`, `io`, `onTap`, `semanticsLabel`. Il palco riceve una lista di queste.
- **`BaStatoPalco`**: `vivo`, `scheletro(n)` (si sta entrando: n sagome vuote) o `congelato` (linea persa: tutto fermo).
- **`BaPayloadStanza`**: ciò che viaggia verso le superfici di sistema (Live Activity, notifica): `stanza`, `sulPalco`, `inizio`, `tinte` (al massimo 4), `iniziali`. **Non ha un campo «chi parla»**, e non è una dimenticanza: fuori dall'app quel dato non si aggiorna abbastanza spesso per essere vero (regola 4).
- **`BaOra`**: l'unico formattatore di tempo, `BaOra.hhmm`. Non esiste un formattatore di durate: il tempo si mostra come un'ora, mai come un conto (regola 3).
- **`BaRegole`**: una classe astratta senza codice, solo i commenti con le otto regole che «nessun valore può portare da solo». Di quelle otto, cinque (3, 4, 6, 7, 8) non si possono violare perché manca lo strumento per violarle, due (1 e 5) diventano irrappresentabili nel livello dei widget, e resta convenzione la 2 (nessuna informazione affidata alla sola tinta), da guardare in revisione. Il testo operativo, con le decisioni collegate, è in [regole](regole.md).
- **`BaCodaTokens.oraDelPosto`**: una delle poche funzioni di logica che stanno nei token (come `BaOra.hhmm` o `BaBarraAzioniTokens.visibili`); dato l'istante in cui è caduta la linea e una durata, dà l'ora fino a cui il posto è conservato (troncata al minuto, mai oltre il reale) oppure `null` sotto i due minuti.

## Come si aggiunge un componente

1. **Branch e piano.** Un branch per task (`task/NNN-nome`), mai commit diretti su `main`; prima del codice un piano, poi la pull request con il template (`.github/pull_request_template.md`): è il ciclo che descrive il `README.md` della radice.
2. **Il file.** `app/lib/design_system/<nome>.dart`, con una classe `Ba<Nome>` che estende un widget. Importa solo `widgets.dart` (più `tokens.dart` e gli altri componenti). Un commento di testa dice che cosa è, da quale sezione dell'Inventario e da quale consegna di design nasce, e quali sono i suoi stati.
3. **Solo token.** Colori, misure, durate e proporzioni da `tokens.dart`. Se manca un valore: lo si aggiunge lì (vedi sotto) e si segnala nel report. Nessun numero di design scritto a mano.
4. **Nessuna stringa fissa.** Il componente riceve i testi e le etichette per lo screen reader dal chiamante.
5. **Accessibilità.** Etichetta di semantica, area di almeno `BaControlloTokens.areaMinima` (44), «riduci movimento» rispettato, e lo stato critico mai affidato al solo colore. Dentro un `BaTouchable` se si tocca.
6. **Un test** in `app/test/<nome>_test.dart`: widget test senza golden, con i casi degli stati e un caso a testo 2,0.
7. **La galleria.** Una voce nella pagina giusta di `app/lib/galleria/` (o una pagina nuova, registrata in `main_galleria.dart`), con i controlli di sempre.
8. **La documentazione.** Una riga in [componenti](componenti.md) (il test `app/test/documentazione_test.dart` fallisce se manca) e, se serve, `app/README.md`.
9. **Prima della pull request:** `flutter analyze`, `flutter test`, e il report in `docs/reports/NNN.md` (lo fa il comando `/verify NNN` descritto in `.claude/commands/verify.md`).

## Come si aggiunge un token

1. **Dove.** In `tokens.dart`, nella sezione che gli compete (colore, forma, presenza, tipografia, spazio e controlli, movimento…). Le classi di token finiscono in `Tokens`.
2. **Due livelli.** Se esiste una primitiva (`BaPaletteTokens`, `BaPrimitiveTokens`), il token semantico la richiama (`_P.pietra100`, `_S.sp4`); non si scrive un valore nuovo. Se non esiste, è un'**eccezione**: un numero nel nome o un commento con il motivo. I colori non hanno un colore nuovo se si può comporre con le primitive (alfa compresa).
3. **Il test.** Un caso in `tokens_test.dart` che fissa il valore e, dove serve, le relazioni (per esempio «la riga non scende sotto `areaMinima`»).
4. **Il design.** `design/system/md/token.md` e il `.dc.html` corrispondente sono la motivazione e vengono da Claude Design: sono **copie di lettura**, e se divergono vince `tokens.dart`. Un cambiamento di valore si registra nel report e nella pull request («Decisioni e token»), non si fa in silenzio.
5. **Le decisioni.** Se il cambiamento tocca una decisione di [`DECISIONS.md`](../DECISIONS.md), ci si ferma e si chiede: una decisione non si cambia, se ne aggiunge una nuova che la supera.
