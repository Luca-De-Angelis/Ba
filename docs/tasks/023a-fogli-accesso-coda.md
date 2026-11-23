# Task 023a — Fogli di contenuto: diventa partecipante, coda e attesa

18 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Con i task 021 (il foglio, la scheda, il messaggio) e 022 (campi, scelte, interruttori, righe di coda) il design system ha i contenitori e i controlli; mancano i **contenuti** che i prototipi mettono dentro i fogli. Questo task costruisce quelli dell'**accesso a parlare** (013 e 014b) e della **coda e attesa** (015). I contenuti di «Crea un DEN», «Gestisci» e del sotto-DEN sono il task 023b. **Nessuna navigazione, nessuna logica di flusso**: il design system non sa quale passo viene dopo; i passi sono pezzi riusabili, e la macchina a stati è di chi li usa (il prototipo navigabile, task 024). Fonti: `design/handoff/013/Accesso 013.dc.html` (P1–P6), `014/Creare DEN 014.dc.html` (R1 e R2, le due varianti per chi crea un DEN), `015/Coda e attesa 015.dc.html` (K1, K2, W1, S1, S2) con i `changelog.md`, `design/system/md/inventario-componenti.md` (C4), `token.md` (T6 ter, T11), `tokens.dart` (`BaAccessoTokens.foglioAltezza*`), `docs/handoff/componenti.md` e `schermate.md`, e i componenti `BaFoglio`, `BaCampoTesto`, `BaCampoCodice`, `BaInterruttoreRiga`, `BaRigaCoda`, `BaMessaggio`, `BaPillola`. Dove un documento tace, **proponi nel piano e segnala nel report**.

## Do

1. **Branch** `task/023a-fogli-accesso-coda`, da `main` aggiornato (022 già unito).
2. **Il foglio a più passi.** Il 013 e il 014b disegnano **un foglio solo che cresce per passi**: ciò che sta sopra scorre, le azioni restano ancorate (T11), l'altezza massima è `foglioAltezzaTelefono` e `foglioAltezzaTablet`. Costruisci il pezzo che lo permette sopra `BaFoglio` (per esempio `BaFoglioPassi`): mostra il passo corrente con il suo titolo, il suo corpo e le sue azioni; il passo lo dà il chiamante. **Quando il passo cambia, il focus va al titolo del nuovo passo e lo screen reader lo legge** (proponi come: il foglio resta lo stesso, quindi un nuovo `namesRoute` non basta). «Non ora» c'è in ogni passo, senza colpa e senza conseguenze.
3. **I passi di «diventa partecipante»** (P1–P4, P6, R1, R2). Un passo per schermata del prototipo, tutti con i testi dal chiamante: **avviso** (titolo, paragrafi, «Continua» e «Non ora»), **numero** (`BaCampoTesto` con prefisso «+39», testo, «Ricevi il codice»), **codice SMS** (`BaCampoCodice`, la frase «Mandato al … 4821», «Mandalo di nuovo» inattivo durante l'attesa, «Conferma»), **consenso** («Vuoi parlare?», «Acconsento e salgo» oppure «Acconsento e continuo» per chi sta creando un DEN). Il caso P6 (numero già verificato) è avviso più consenso, senza numero né SMS. Il componente non valida il numero né il codice: mostra lo stato di errore che il chiamante gli dà.
4. **Coda e attesa.** Quattro contenuti: **«Mettiti in coda»** (K2: il testo, `BaInterruttoreRiga` «Fammi entrare automaticamente», e **solo per chi ha la capacità** la riga «Aspetta con altri»; per gli altri la riga **non esiste, senza etichetta né spazio vuoto**; «Salirai a microfono spento»; «Mettiti in coda» e «Non ora»); **«Aspetta con altri»** (W1: la spiegazione, «Entra nel gruppo» e «Non ora»); **«Le tue code»** (K1: un `BaRigaCoda` per coda, nessuna posizione, conteggio o massimo, «Chiudi»); e i due **stati** («La coda è piena adesso» con «Ho capito»; «Non puoi metterti in coda adesso» con «Le tue code» e «Chiudi»). Usa le varianti del `BaFoglio` (richiesta o invito): la primaria è **chiara solo dove l'app non prosegue senza il gesto** (BaRegole 1).
5. **Galleria.** Una pagina nuova «Fogli di contenuto» con un pulsante per ciascun contenuto, che lo apre in un foglio, con **testi fissi in italiano** presi dai prototipi (galleria esente da l10n, D-030) e i controlli di sempre (testo 1,0 e 2,0, riduci movimento, 360 e 744). Il foglio a più passi si percorre con «Continua» e «Indietro» di prova, solo nella galleria.
6. **Documenti** (con la regola «Impatto sull'handoff»): `docs/handoff/componenti.md` (le righe nuove), `schermate.md` e `aperte.md` dove dicono «non costruito», `avvio.md` (la pagina), `app/README.md`, `docs/tasks/README.md` (023a «In corso»; 023b «Brief da scrivere»; il 024 resta il prototipo navigabile), e nel report la riga «Impatto sull'handoff».

## Do NOT

- Non costruire i contenuti di «Crea un DEN», «Gestisci», del sotto-DEN né il foglio dei co-amministratori (023b), né le schermate dell'accesso (email, codice, onboarding: sono pagine, task 024).
- Non scrivere logica di flusso, validazione del numero o del codice, invio di SMS, timer o conti alla rovescia: l'attesa del nuovo invio è una **frase ferma**.
- Non scrivere codice di suono né di vibrazione; nessun segno del pagante: chi non ha «Aspetta con altri» non vede né etichetta né invito.
- Non toccare `tokens.dart` né i componenti esistenti. Se manca un valore, segnalalo nel report.
- Niente Material o Cupertino, nuove dipendenze, golden, numeri di design a mano; ogni import oltre `widgets.dart` va motivato nel file e in `CLAUDE.md`.

## Acceptance check

- [ ] Il foglio a più passi tiene il corpo che scorre e le azioni ancorate a testo 2,0; ogni passo ha «Non ora»; al cambio di passo il focus va al titolo e il passo si annuncia.
- [ ] I quattro passi dell'accesso e le due varianti della creazione (R1, R2) esistono con i testi dal chiamante; il caso P6 non mostra numero né SMS.
- [ ] «Aspetta con altri» non lascia traccia (nessuna riga, nessuno spazio) senza la capacità.
- [ ] Nessun conto alla rovescia; «Mandalo di nuovo» è inattivo durante l'attesa con una frase.
- [ ] Il colore non porta mai da solo un'informazione; la primaria è chiara solo dove il gesto è obbligato.
- [ ] `flutter analyze` e `flutter test` verdi; CI verde; il test sulla documentazione passa.
- [ ] Nella galleria, la verifica di Luca: il percorso a quattro passi con il foglio che cresce, le azioni sempre in fondo, il caso con numero già verificato, la coda con e senza «Aspetta con altri», e «Le tue code», a 2,0 e a 744.

## Cosa restituire

Branch `task/023a-fogli-accesso-coda`, report in `docs/reports/023a.md` (massimo 30 righe) con le **proposte dove i documenti tacciono** (come cambia il focus fra i passi, come si annuncia il passo, la struttura di `BaFoglioPassi`, l'API dei passi), i valori mancanti nei token, ciò che non hai potuto verificare e la riga «Impatto sull'handoff». Pull request con il template.
