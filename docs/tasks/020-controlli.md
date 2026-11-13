# Task 020 — Controlli e barra delle azioni: BaPillola, BaAzioniInCoppia, BaBarraAzioni, BaPubblico

12 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Quarto passo dei componenti, dopo `BaTouchable` (009), presenze (010) e palco (011, 012): i **controlli** e la **barra delle azioni**, per far diventare vera la stanza finta della galleria. Fonti: `design/system/md/inventario-componenti.md` (C3: `BaPillola`, `BaAzioniInCoppia`, `BaPubblico`; la regola della barra del task 002; «le altezze dei controlli sono minimi, non misure»), `token.md` (T7, T7 bis, T8), `tokens.dart` (`BaControlloTokens`, `BaBarraAzioniTokens`, `BaPresenzaTokens.pubblico`/`campionePubblico`, `BaRaggioTokens`, `BaTestoTokens`), il prototipo `Stati critici 002.dc.html` (la barra a tre posti, «Altro», il pubblico) e `BaRegole` (regola 1: la pillola «chiara»). Dove un documento tace, **proponi nel piano e segnala nel report**.

Restano fuori, per il 021: `BaFoglio` (e quindi cosa apre «Altro»), la scheda della persona, `BaMessaggio`, la fascia «chi mi sente» del sotto-DEN.

## Do

1. **Branch** `task/020-controlli`, da `main` aggiornato.
2. **`BaPillola`** (`lib/design_system/pillola.dart`), sopra `BaTouchable`. Varianti: **informativa** (non fa niente, dice), **attiva**, **chiara** (solo dove l'app non prosegue senza un gesto, `BaRegole` 1: scrivilo nel commento) e **spenta**. Stati: a riposo, premuta, a fuoco, inattiva. Altezza **minima** `BaControlloTokens.primario`: il contenuto può alzarla, mai abbassarla, e il testo non si taglia a testo 2,0. Raggio, filetti e colori dai token. L'etichetta di semantica arriva dal chiamante.
3. **`BaAzioniInCoppia`.** Due pillole secondarie affiancate (`coppia`, `gapCoppia`), oppure una sola centrata. Gli stati sono indipendenti fra le due. Le aree toccabili si estendono di mezzo gap verso la vicina e di `areaEstesa` sugli altri lati, come nella galleria del 009: un tocco a 3 dp dal bordo del gap va a sinistra, a 7 dp a destra.
4. **`BaBarraAzioni`.** Compone, secondo `BaBarraAzioniTokens`: **un posto primario e due secondari**; dalla quarta azione compare **«Altro»** (`altroLato`, 48 × 48) con le azioni rimanenti (`inAltro`). Riceve una lista di azioni con ruolo (primaria o secondaria), etichetta di semantica e `onTap`; chi chiama le ordina in modo che «Esci», «Scendi dal palco» e il controllo del microfono siano fra le prime tre. In debug, un assert se l'azione primaria o una delle fisse finisse in «Altro». «Altro» chiama un `onAltro`: **non costruire il foglio**. Le azioni restano ancorate in basso: a testo grande scorre quello che sta sopra, mai la barra (T11). Proponi nel piano dove sta «Altro» rispetto alle altre due, leggendo il prototipo.
5. **`BaPubblico`.** Il campione e il contatore: nessuno (non si disegna), da 1 a 3 sagome, oltre 3 un campione fisso (`campionePubblico`), sagome di `pubblico` senza iniziali, e il testo del contatore in `BaTestoTokens.marcatore`. Tinte e sagome arrivano come indici dal chiamante; il testo («{n} in ascolto») arriva già composto. Nessuna animazione: le sagome compaiono e spariscono. Semantica: una sola etichetta con il conteggio.
6. **Galleria.** Una pagina nuova «Controlli»: le quattro varianti di pillola nei loro stati, la coppia (due e una), la barra con da 1 a 6 azioni, il pubblico con 0, 1, 2, 3 e 14, e i controlli di sempre (testo 1,0 e 2,0, riduci movimento, larghezza 360 e 744). **Nella stanza finta della pagina «BaPalco»** sostituisci la riga di testo in fondo con `BaPubblico` e `BaBarraAzioni`: a testo 2,0 si vede il palco cedere sotto una barra vera.
7. **Documenti.** `docs/tasks/README.md`: 020 «In corso» con il titolo, 021 «BaFoglio, scheda della persona e BaMessaggio» (brief da scrivere). `app/README.md`: i componenti nuovi.

## Test (di widget, senza golden)

- **Pillola:** altezza ≥ `primario` a 1,0 e a 2,0 senza tagliare il testo; le quattro varianti; premuta, a fuoco e inattiva; semantica (etichetta, `button`, `enabled`).
- **Coppia:** gap 10; le due aree si toccano e non si sovrappongono (3 dp a sinistra, 7 dp a destra); la singola è centrata.
- **Barra:** con 1, 2 e 3 azioni nessun «Altro»; con 4 e 5 compare, 48 × 48, e `inAltro` vale 1 e 2; l'ordine è quello passato; l'assert sull'azione primaria; a testo 2,0 la barra non perde nessuna azione e il palco della stanza finta cede.
- **Pubblico:** 0 non disegna niente; 1, 2 e 3 sagome; 14 mostra tre sagome e il contatore; una sola etichetta di semantica; nessuna animazione in corso.

## Do NOT

- Non costruire `BaFoglio`, la scheda della persona, `BaMessaggio` né la fascia del sotto-DEN.
- Non scrivere codice di suono né di vibrazione, né file audio.
- Non toccare `tokens.dart` (se manca un valore, segnalalo), né le presenze e il palco, a parte la stanza finta della galleria.
- Niente Material o Cupertino, nuove dipendenze, golden, numeri di design scritti a mano; ogni import oltre `widgets.dart` va motivato nel file e in `CLAUDE.md`.

## Acceptance check

- [ ] I test passano; `flutter analyze` e `flutter test` verdi; CI verde.
- [ ] Nessun numero di design a mano; nessuna eccezione di import non motivata.
- [ ] Nella galleria, la verifica di Luca: le pillole non si abbassano né si tagliano a testo 2,0; la coppia ha le aree che si toccano; «Altro» compare dalla quarta azione; nella stanza finta la barra resta ancorata in basso e il palco cede; il pubblico mostra al massimo tre sagome con il contatore.

## Cosa restituire

Branch `task/020-controlli`, report in `docs/reports/020.md` (massimo 30 righe) con le **proposte dove i documenti tacciono** (posizione di «Altro», cosa fa la pillola «informativa», come si scelgono tinte e sagome del pubblico) e ciò che non hai potuto verificare. Pull request con il template.
