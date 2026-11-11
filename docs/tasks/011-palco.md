# Task 011 — BaPalco (widget) e la stanza vuota con una persona

11 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Terzo passo dell'ordine di costruzione: `BaTouchable` (009) → `BaPresenza` con `BaRitratto` e `BaAnello` (010, 010b) → **`BaPalco`**. Il palco è il punto dove la geometria decide una misura: riceve una **scatola**, non una dimensione, e ne ricava diametro e posizioni con `disponiPalco` (005, 005c, 007). Fonti: `design/system/md/inventario-componenti.md` (C1, C6, C7), `token.md` (T6, T6 bis, T8, T11), `tokens.dart` (`BaMovimentoTokens`, `BaPresenzaTokens`, `BaLayoutTokens`), `lib/design_system/palco/disposizione.dart`. Dove un documento tace, **proponi nel piano e segnala nel report**.

Per questo passo, **niente movimento del palco**: le presenze compaiono e spariscono, e la disposizione si ricalcola all'istante. L'assestamento animato (320 ms, 200 ms al ricompattamento, 4 s e 6 s di attesa) è rimandato (tabella dei rinvii dell'Inventario).

## Do

1. **Branch** `task/011-palco`, da `main` con 010 e 010b già uniti.
2. **`BaPalco`** (`lib/design_system/palco.dart`). Solo `widgets.dart`. Riceve:
   - `persone`: lista di un modello `BaPersonaPalco` (`id`, `indiceTinta`, `indiceSagoma`, `iniziali`, `immagine`, `parla`, `ampiezza`, `persa`, `semanticsLabel`, `semanticsLabelParla`, `onTap`); da 0 a 8, oltre è un errore;
   - `larghezzaSchermo`, per decidere telefono o tablet (D-027);
   - `stato`: `vivo`, `scheletro(conteggio)` o `congelato` (linea persa).
3. **Layout.** `LayoutBuilder` → scatola → `disponiPalco`. Ogni presenza sta in un `BaDiametro` con il diametro calcolato, centrata sul suo centro, e occupa `d + 10` (la banda a riposo). Il palco non scorre mai. Se `sfora` è vero, le presenze restano tutte a schermo e nessuna viene tolta, e si registra un avviso solo in debug.
4. **Le voci insieme.** Il palco conta quante persone hanno `parla` e passa a tutte lo stesso `voci` (il limiter): la scala cambia per tutti insieme, chi parla compreso, perché una presenza più piccola delle altre si leggerebbe come rango.
5. **Stati.**
   - **Vuoto** (nessuna persona): nessuna presenza, e un invito che non mette pressione: «Il palco è libero.» e «Puoi salire quando vuoi.» (come nel task 002);
   - **Pieno** (8): non è uno stato a sé, ma il caso `7–8` di `disponiPalco`;
   - **Scheletro**: `conteggio` presenze in stato scheletro, con la stessa disposizione;
   - **Congelato**: tutte le presenze in stato persa; la disposizione non cambia. La durata del posto conservato (30 s Free, 3–5 min Pro, catalogo C06) è logica di un task successivo: qui solo la resa.
6. **Accessibilità.** Ordine di lettura = ordine dei centri (dall'alto in basso, da sinistra a destra). Nessun annuncio per chi entra o esce (ingresso morbido). Il palco ha un'etichetta («Palco, 3 persone») composta con una chiave di traduzione.
7. **Traduzioni.** Aggiungi le chiavi ARB nelle cinque lingue (IT, EN, FR, ES, DE): etichetta della persona, etichetta di chi parla («{nome}, sta parlando»), «Il palco è libero.», «Puoi salire quando vuoi.», «Palco, {n} persone». Il tedesco prendilo da `design/handoff/002` (`Stati critici 002.dc.html`) dove esiste. Le altre sono bozze: segnalale nel report come **da far rivedere a madrelingua**.
8. **Galleria.** Una pagina nuova, `galleria_palco.dart`, nel menu. È una stanza finta: intestazione, palco in `Expanded`, riga sotto. Controlli (come `BaTouchable`): persone da 0 a 8, quante parlano (0–3), persa, scheletro, congelato, larghezza schermo 360 o 744, **testo di sistema 1,0 oppure 2,0** (cambia `MediaQuery.textScaler`: intestazione e riga crescono e il palco cede), riduci movimento, e un indicatore del diametro e di `sfora`. Con 1 persona e testo normale deve vedersi la stanza vuota con una persona a 208 dp.
9. **Documenti.** `docs/tasks/README.md`: 010 e 010b «Concluso», 011 «In corso». `CLAUDE.md`: una riga che dice che le chiavi ARB nuove richiedono la revisione dei madrelingua.

## Test (di widget, senza golden)

- 1 persona, schermo 360, scatola 320 × 420: diametro 208, una presenza centrata; 8 persone: 88, righe 3+2+3;
- 0 persone: nessuna presenza e l'invito; 8 non sparisce nessuna presenza al restringersi della scatola;
- schermo 744: i diametri sono quelli del tablet (312 per una persona);
- due persone che parlano: tutte e due le presenze ricevono `voci` 2 (anello più piccolo che con una voce);
- congelato: tutte persa, stessa disposizione; scheletro: `conteggio` presenze senza iniziali;
- testo di sistema 2,0: il diametro scende rispetto a 1,0, nessuna presenza sparisce, le iniziali non crescono;
- ordine di lettura uguale all'ordine dei centri; nessun annuncio all'ingresso di una persona;
- cambio del numero di persone: la disposizione nuova c'è al primo fotogramma, senza animazioni in corso.

## Do NOT

- Non costruire l'assestamento animato, `BaGlifo`, il disco del microfono spento, la tacca, `BaPubblico`, né la barra delle azioni.
- Non toccare `tokens.dart` né `disposizione.dart` (se serve un cambio, proponilo).
- Niente Material o Cupertino, niente nuove dipendenze, niente golden, nessun numero di design a mano.

## Acceptance check

- [ ] I test passano; `flutter analyze` e `flutter test` verdi; CI verde.
- [ ] Nessun numero di design a mano; `rendering.dart` resta solo in `touchable.dart`.
- [ ] Nella galleria, la verifica di Luca: 1 persona a 208; 8 persone a 88 con 3+2+3; il testo grande restringe le presenze senza toglierne nessuna; due voci con anello più piccolo; il palco vuoto invita senza pressione; a 744 le presenze sono più grandi.

## Cosa restituire

Branch `task/011-palco`, report in `docs/reports/011.md` (massimo 30 righe) con le proposte fatte dove i documenti tacciono e la lista delle traduzioni da rivedere. Pull request con il template.
