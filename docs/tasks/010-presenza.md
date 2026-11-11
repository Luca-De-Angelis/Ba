# Task 010 — BaRitratto, BaAnello e BaPresenza (stati di base)

10 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Secondo passo dell'ordine di costruzione: `BaTouchable` (009, concluso) → **`BaPresenza` con `BaRitratto` e `BaAnello`** → `BaPalco` (011). Fonti: `design/system/md/inventario-componenti.md` (C1), `token.md` (T4, T6, T6 ter, T7 bis, T8), `tokens.dart` (`BaPresenzaTokens`, `BaSagomaTokens`, `BaTintaTokens`, `BaTestoTokens`, `BaColorTokens.voce*`, `BaMovimentoTokens.voce*` e `skeleton`). Se un documento non dice una cosa, **proponila nel piano e segnalala nel report**: non decidere in silenzio.

Passo piccolo per scelta. In questo task entrano gli stati **ferma, parla, persa, scheletro, premuta, a fuoco**. Restano fuori, per il task 012, tutti gli stati che hanno bisogno di un glifo: mutata, bloccata, microfono spento (disco) e tacca della parola.

## Do

1. **Branch** `task/010-presenza`.
2. **`BaRitratto`** (`lib/design_system/ritratto.dart`). Dentro la sagoma: immagine, iniziali o sagoma nuda. Stati: in carico, caricata, fallita (→ iniziali), assente (→ iniziali). Le iniziali hanno `BaPresenzaTokens.iniziali(d)` come taglia e lo stile di `BaTestoTokens`; sotto 32 dp non c'è nessuna iniziale. L'immagine arriva da un `ImageProvider?` e riceve il velo `veloImmagine`. Nessuna dipendenza di rete: nei test e nella galleria si usano immagini in memoria.
3. **`BaAnello`** (`lib/design_system/anello.dart`). Doppio tratto aderente alla sagoma (keyline interna, tratto esterno), fisso a ogni scala (`anelloKeyline`, `anelloTratto`). Due canali:
   - **veloce** (`parla`, booleano): compare in `voceAttacco` (70 ms) e scompare in `voceScomparsa` (140 ms);
   - **lento** (`ampiezza` da 0 a 1, campionata ogni `campionamentoAmpiezza`): il respiro fra scala e opacità di riposo e di picco (`anelloScala*`, `anelloOpacita*`), con rilascio `voceRilascio`, mai sotto il campionamento. Con più voci insieme (`voci`) l'escursione si comprime di `BaPresenzaTokens.quotaEscursione(voci)`;
   - **linea instabile**: anello fermo a `voceTrattoFermo` ("c'è una voce, non ne conosco l'ampiezza");
   - **ripiego statico** con "riduci movimento": solo il canale veloce, anello fermo, senza dissolvenza né respiro. Non si taglia lo stato, solo la resa.
4. **`BaPresenza`** (`lib/design_system/presenza.dart`), variante palco. Compone sagoma (`BaSagomaTokens.bordo`), gradiente della tinta, ritratto, anello e `BaTouchable` in variante `suPresenza`. Il diametro **si eredita dal palco** (regola 5): un `InheritedWidget` `BaDiametro` che per ora la galleria fornisce a mano; senza di esso, errore in debug. Stati:
   - ferma e parla (anello);
   - **persa**: scala di grigi e opacità `presenza/persa`, nessun anello;
   - **scheletro**: nessuna iniziale, opacità che respira fra i due valori dello scheletro in `skeleton`; con "riduci movimento" fermo (proponi il valore nel piano);
   - **premuta**: la keyline diventa `premutoKeyline` e basta, senza scala;
   - **a fuoco**: anello di focus di `BaTouchable`.
   Semantica: "nome, sta parlando" quando parla; le iniziali non sono la rappresentazione accessibile. Tinta e sagoma arrivano come indici dall'evento di ingresso: non si calcolano dall'id.
5. **Estensione di `BaTouchable`.** Oggi l'anello di focus segue un solo `raggio`; le sagome hanno angoli ellittici diversi. Aggiungi a `BaTouchable` un parametro opzionale `bordo` (`BorderRadius?`) che, se presente, ha la precedenza su `raggio` per velo e anello. Un test nuovo; i test del 009 restano verdi.
6. **Galleria.** Una pagina nuova, `galleria_presenza.dart`, raggiungibile da un menu in `main_galleria.dart` (i comandi sono `BaTouchable`). Mostra le presenze ai cinque diametri, le 12 tinte e le 5 sagome, con controlli per: parla, ampiezza (0, 0,5, 1), voci insieme (1, 2, 3), linea instabile, persa, scheletro, immagine caricata e fallita, riduci movimento. Un controllo "simula voce" che manda un'ampiezza nuova ogni 500 ms, per vedere il respiro. Sistema anche i due ritocchi del 009: la presenza MB in `galleria_touchable.dart` va allineata a sinistra (oggi la sua area è larga quanto la riga), e il contatore "TOCCHI" non deve spostare la pillola vicina (riga di altezza fissa).
7. **Documenti.** `app/README.md`: togli l'introduzione "progetto non creato" e descrivi lo stato attuale. `docs/tasks/README.md`: 009 "Concluso", 010 "In corso", 011 "BaPalco (widget) e la stanza vuota con una persona: brief da scrivere", 012 "BaGlifo e stati con glifo (mutata, bloccata, microfono spento, tacca): brief da scrivere".

## Test (di widget, senza golden)

- **Ritratto:** la taglia delle iniziali vale `iniziali(d)` per i cinque diametri e per 32; sotto 32 nessuna; immagine caricata con il velo; immagine fallita e assente mostrano le iniziali.
- **Anello:** assente senza `parla`; a pieno dopo 70 ms dall'accensione e sparito dopo 140 ms dallo spegnimento; ampiezza 1 → scala 1,075 e opacità 0,95; ampiezza 0 → 1,00 e 0,28; con due voci → 1,042 e 0,66 (±0,01); dopo un calo di ampiezza, il rilascio non è più corto di 500 ms; linea instabile → opacità 0,34 ferma; "riduci movimento" → nessuna animazione in corso.
- **Presenza:** dimensione presa da `BaDiametro`; sagoma e tinta secondo gli indici; etichetta "nome, sta parlando"; persa con opacità 0,34; scheletro senza iniziali e con opacità fra 0,30 e 0,62; premuta senza trasformazioni di scala e con la keyline `premutoKeyline`; focus; area toccabile di almeno 44 anche a 88.
- **`BaTouchable` con `bordo`:** l'anello segue gli angoli ellittici.

## Do NOT

- Non costruire mutata, bloccata, microfono spento, tacca, né `BaGlifo`: sono il task 012.
- Non costruire `BaPalco`, la variante sistema, né `BaPubblico`.
- Non toccare `tokens.dart`; se manca un valore, segnalalo nel report.
- Niente Material o Cupertino, niente nuove dipendenze, niente golden, nessun numero di design scritto a mano.

## Acceptance check

- [ ] I test passano; `flutter analyze` e `flutter test` verdi; CI verde.
- [ ] Nessun numero di design a mano nei file nuovi; `rendering.dart` resta solo in `touchable.dart`.
- [ ] Nella galleria, la verifica di Luca: l'anello compare e scompare senza sbavature; il respiro segue l'ampiezza e con due voci è più piccolo; con "riduci movimento" l'anello è fermo; la persa è grigia; lo scheletro respira; il focus con Tab segue la sagoma.

## Cosa restituire

Branch `task/010-presenza`, report in `docs/reports/010.md` (massimo 30 righe) con le **proposte fatte dove i documenti tacciono** (attacco del respiro, valore fermo dello scheletro, stato "in carico" del ritratto) e ciò che non hai potuto verificare. Pull request con il template.
