# Task 022 — Componenti dei task 013–015: accesso, creazione dei DEN, coda e attesa

18 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

I task di design 013 (accesso), 014 (creare e gestire i DEN) e 015 (coda e attesa) hanno consegnato schermate e token, ma **nessun componente è ancora nel codice**: i token (`BaAccessoTokens`, `BaCreazioneTokens`, `BaCodaTokens`) esistono, i widget no. Questo task costruisce i controlli che quelle schermate usano, con la stessa regola dei task 020 e 021: componenti piccoli, token soli, testi dal chiamante, galleria e test. **Nessuna schermata, nessuna navigazione**: le schermate sono i task 023 e 024. Fonti: `design/system/md/inventario-componenti.md` (C4 e le righe di ciascun componente), `token.md` (T6 ter, T7 bis, T8, T11), `tokens.dart`, i prototipi `design/handoff/013/Accesso 013.dc.html`, `014/Creare DEN 014.dc.html` e `015/Coda e attesa 015.dc.html` con i rispettivi `changelog.md`, e `docs/handoff/componenti.md` e `schermate.md` (dicono cosa manca). Dove un documento tace, **proponi nel piano e segnala nel report**.

## Do

1. **Branch** `task/022-componenti-013-015`, da `main` aggiornato (025 già unito).
2. **`BaCampoTesto`** (nome proposto: l'Inventario non lo nomina, i token sì: `BaAccessoTokens.campoAltezza` e `campoLinea`). Il campo email, numero, nome e descrizione: una riga con la **linea sotto, non una scatola**, etichetta in marcatore sopra, testo di aiuto sotto. Stati: vuoto, a fuoco, compilato, errore. La descrizione è a più righe (`BaCreazioneTokens.descrizioneAltezza`). Si costruisce con `EditableText` di `widgets.dart` (controller e focus dal chiamante); tipo di tastiera, suggerimenti di autocompilazione e `onChanged` dal chiamante.
3. **`BaCampoCodice`.** Il codice a sei caselle (`codiceCaselle`, altezza `codiceAltezza`, gap `codiceGap`) per l'email e per l'SMS. Stati: vuoto, in scrittura, sbagliato, scaduto, nuovo invio con attesa. **Per lo screen reader è un campo solo** («codice di sei cifre», valore letto cifra per cifra), non sei caselle focalizzabili; incolla e cancella funzionano; il completamento chiama `onCompleto`. L'errore ha il segno «!» (`erroreSegno*`) e una frase, mai il solo colore, ed è annunciato; l'attesa del nuovo invio è **una frase ferma**, senza conto alla rovescia (`nuovoInvioAttesa` è solo il valore). Proponi se l'errore sta dentro il componente o si dà a `BaMessaggio`.
4. **`BaSceltaDen`.** La scelta del tipo di DEN (privato o pubblico), a righe: scelta ha **bordo spesso e cerchio pieno**, non solo il colore (`BaCreazioneTokens.scelta*`); una frase sotto che cambia con la scelta (dal chiamante). Semantica di scelta esclusiva (`inMutuallyExclusiveGroup`, selezionato).
5. **`BaChipScelta`.** I chip di tema e lingua (`BaCreazioneTokens.chip*`): scelto con **segno di spunta**, non scelto; vanno a capo e a testo grande la riga cresce.
6. **`BaInterruttoreRiga`.** «Fammi entrare automaticamente» e «Aspetta con altri»: acceso con bordo spesso **e la parola «Acceso»**, spento con «Spento» (le parole dal chiamante); con testo grande il testo va a capo e l'interruttore resta a destra (`BaCodaTokens.interruttore*`). Tutta la riga è toccabile (area ≥ 44); semantica di interruttore.
7. **`BaPuntoAggancio`.** La riga tratteggiata che tiene il posto di ciò che non è deciso (invitati, persone fra cui scegliere, campo «Quando» spento; `BaCreazioneTokens.aggancio*` e `quando*`): **solo un posto, mai un'azione** (non toccabile, non focalizzabile). Il tratteggio non ha un widget di Flutter: proponi come disegnarlo (un `CustomPaint` con un painter privato condiviso con `BaBandaPosto`) e se serve un import oltre `widgets.dart`.
8. **`BaRigaCoda`.** Una riga per coda in «Le tue code»: DEN, stato («In coda · entri a microfono spento»), «Esci dalla coda»; **nessuna posizione, nessun conteggio, nessun numero massimo**. Con testo grande l'uscita va a capo sotto il nome (`BaCodaTokens.riga*`, `uscita*`).
9. **`BaFasciaAttesa`.** Il sotto-DEN d'attesa: presenze piccole (**senza numeri né segni**: `gruppoPresenza*`), una frase, e «Lascia il gruppo» **solo per chi ha la capacità**: se la callback non c'è la riga non esiste, senza etichetta né spazio vuoto.
10. **`BaBandaPosto`.** Il posto conservato e la permanenza massima: **un'ora ferma, mai un conto alla rovescia**; a filo per il posto conservato, tratteggiata per B05 (in revisione) (`BaCodaTokens.banda*`). **Regge 30 secondi e 5 minuti senza cambiare schermata**: il componente riceve il testo già composto dal chiamante (con `oraDelPosto` o con la frase «ancora per un momento») e non calcola mai un tempo.
11. **Galleria.** Una pagina nuova «Accesso, creazione e coda» con tutti i componenti nei loro stati e i controlli di sempre (testo 1,0 e 2,0, riduci movimento, 360 e 744). Testi fissi (galleria esente da l10n, D-030).
12. **Documenti** (la regola nuova della riga «Impatto sull'handoff»): `docs/handoff/componenti.md` (le righe dei nove componenti: **il test sulla documentazione lo impone**, e vanno tolte da «Non ancora costruiti»), `schermate.md` e `aperte.md` (dove dicono «non costruito»), `app/README.md`, `docs/tasks/README.md` (022 «In corso»; 023 «Contenuti dei fogli», 024 «Prototipo navigabile» «Brief da scrivere»), e nel report la riga «Impatto sull'handoff».

## Do NOT

- Non costruire schermate, navigazione né `BaFoglioGestisci`; non costruire `BaRigaDen`, `BaRigaImpostazione` né `BaRigaBloccata` (sono del task 001).
- Non fare un componente per il segno «ipotesi»: è un'annotazione di design che si toglie prima del codice; le ipotesi stanno in `docs/handoff/aperte.md`.
- Non scrivere codice di suono né di vibrazione; niente conto alla rovescia, contatori che accumulano né segni del pagante.
- Non toccare `tokens.dart` né i componenti esistenti. Se manca un valore, segnalalo nel report.
- Niente Material o Cupertino, nuove dipendenze, golden, numeri di design scritti a mano; ogni import oltre `widgets.dart` va motivato nel file e in `CLAUDE.md`.

## Acceptance check

- [ ] I nove componenti esistono, usano solo token e ricevono i testi dal chiamante.
- [ ] Il codice è **un campo solo** per lo screen reader; l'errore è annunciato e non è il solo colore.
- [ ] Acceso e scelto non sono mai il solo colore (parola, bordo, spunta).
- [ ] `BaPuntoAggancio` non è mai toccabile; la riga «Lascia il gruppo» sparisce senza lasciare traccia; `BaBandaPosto` non contiene nessun conto alla rovescia.
- [ ] A testo 2,0 nulla si taglia e ogni area toccabile è ≥ 44.
- [ ] `docs/handoff/componenti.md` ha le nove righe e il test di documentazione passa; `flutter analyze` e `flutter test` verdi; CI verde.
- [ ] Nella galleria, la verifica di Luca: il codice che si scrive e che sbaglia, il campo con la linea, le scelte, i chip che vanno a capo, l'interruttore, la riga di coda, la fascia d'attesa e la banda a testo 2,0.

## Cosa restituire

Branch `task/022-componenti-013-015`, report in `docs/reports/022.md` (massimo 30 righe) con le **proposte dove i documenti tacciono** (il nome `BaCampoTesto`, come si costruisce il campo con `EditableText`, come si disegna il tratteggio, dove sta l'errore del codice), i **valori mancanti nei token** e ciò che non hai potuto verificare (la tastiera vera, l'incolla, l'autocompilazione), più la riga «Impatto sull'handoff». Pull request con il template.
