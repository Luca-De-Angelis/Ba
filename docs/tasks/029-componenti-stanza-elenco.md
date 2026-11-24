# Task 029 — Componenti della stanza, dell'elenco e dell'account chiuso

24 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Il design system ha presenze, palco, controlli, fogli e i controlli di accesso, creazione e coda, ma **non le pagine di partenza**: l'intestazione della stanza, le righe dell'elenco dei DEN, le impostazioni, le persone bloccate e la schermata che copre tutto (account chiuso). Sono i componenti dei task 001, 002 e 027 che l'handoff elenca fra i «non ancora costruiti» e che il prototipo navigabile (024) richiede. Questo task li costruisce, con la stessa regola dei task 020, 022 e 023: componenti piccoli, solo token, testi dal chiamante, galleria e test. **Nessuna navigazione, nessuna schermata intera.** Fonti: `design/system/md/inventario-componenti.md` (C2: struttura della stanza; C4: elenco e impostazioni; la riga `BaSchermataCopertura`), `token.md` (T6 ter, T7 bis, T11), `tokens.dart` (`BaTestoTokens.stanza`, `.marcatore`, `.riga`, `.minore`; `BaColorTokens.fondoAlone`; `BaSchermoBloccatoTokens`), i prototipi `design/handoff/001/Schermate 001.dc.html` (elenco, impostazioni, persone bloccate), `002/Stati critici 002.dc.html` (la stanza), `013/Accesso 013.dc.html` (elenco e impostazioni aggiornati), `027/Account e controlli 027.dc.html` (B1, B1 bis, B2) con i `changelog.md`, e `docs/handoff/componenti.md` e `schermate.md`. Dove un documento tace, **proponi nel piano e segnala nel report**.

## Do

1. **Branch** `task/029-componenti-stanza-elenco`, da `main` aggiornato (023b già unito).
2. **Struttura della stanza (C2).** **`BaIntestazione`**: il nome della stanza e il marcatore sotto; stati *pubblica*, *su invito*, *viva*, *in ingresso*, *disconnessa* (nome e marcatore spenti); testo dal chiamante. **`BaMarcatore`**: il marcatore a sé (stanza, conteggio, orario): **un solo stato, è un fatto fermo**, mai un conto alla rovescia. **`BaRigaStato`**: due righe indipendenti (i fatti della stanza sopra, le mie preferenze sotto) che possono essere vuote separatamente senza lasciare spazio. **`BaAlone`**: l'alone dietro il palco, acceso o spento (linea persa, ingresso), con `fondoAlone`.
3. **Elenco e impostazioni (C4).** **`BaRigaDen`**: nome, un campione di presenze (le sagome di `BaPubblico`: indici dal chiamante, nessuna iniziale) e la riga di marcatore («Entra chiunque · 5 sul palco»); stati *viva*, *spenta* (DEN vuoto, sagoma vuota), *su invito*; premuta e a fuoco da `BaTouchable`; area ≥ 44. **`BaRigaImpostazione`**: titolo, valore o interruttore (`BaInterruttoreRiga` o testo), l'**azione con la conseguenza scritta** («Torna ascoltatore»: la frase di conseguenza sotto) e lo stato **negato dal sistema** (il permesso del microfono rifiutato, con la sua via d'uscita). **`BaRigaBloccata`**: una persona bloccata da te (sagoma e nome) con «Sblocca»; stati *bloccata*, *sblocco in corso*, *sbloccata* (esce dall'elenco). Non costruire gli stati «ricevuto» e «rimosso» (beta).
4. **`BaSchermataCopertura`** (account chiuso, B1, B1 bis, B2): una schermata che **copre tutto**, con titolo, paragrafi, una riga opzionale (la durata del blocco: un fatto fermo) e **una sola azione chiara**, «Richiedi revisione»; dopo il tocco, «Richiesta inviata» inattiva. Con testo grande il contenuto scorre e l'azione resta ancorata in basso (T11). Non è un foglio e non è dentro un foglio.
5. **Galleria.** Una pagina nuova «Stanza ed elenco» con tutti i componenti nei loro stati e i controlli di sempre (testo 1,0 e 2,0, riduci movimento, 360 e 744), testi fissi in italiano dai prototipi (D-030). La stanza finta della galleria usa `BaIntestazione` e `BaMarcatore` al posto del testo provvisorio (è l'unica modifica a un file esistente, e solo della galleria).
6. **Documenti** (regola «Impatto sull'handoff»): `docs/handoff/componenti.md` (le righe nuove: il test le impone; tolte da «Non ancora costruiti»), `schermate.md` e `aperte.md` dove dicono «non costruito», `avvio.md`, `app/README.md`, `docs/tasks/README.md` (029 «In corso»; 024 resta «Brief da scrivere»).

## Do NOT

- Non costruire schermate intere, la navigazione né la logica (quale riga si apre, dove va «Torna ascoltatore»): è il task 024.
- Non costruire `BaFasciaTesto` (non in v1), `BaCardLive` e i controlli a schermo bloccato (superfici di sistema), né gli stati beta di `BaRigaDen` e `BaRigaBloccata`.
- Nessun conto alla rovescia, contatore che accumula, segno del pagante né annuncio dell'ingresso di altri nella stanza (D-034).
- Non toccare `tokens.dart` né i componenti esistenti. Se manca un valore, segnalalo nel report.
- Niente Material o Cupertino, nuove dipendenze, golden, numeri di design a mano; ogni import oltre `widgets.dart` va motivato nel file e in `CLAUDE.md`.

## Acceptance check

- [ ] I componenti usano solo token e ricevono i testi dal chiamante; ogni area toccabile è ≥ 44; a testo 2,0 nulla si taglia.
- [ ] `BaRigaStato` senza righe non lascia spazio; `BaMarcatore` non ha timer né ticker; `BaRigaDen` non ha numeri che accumulano.
- [ ] `BaRigaImpostazione` mostra la conseguenza scritta e lo stato negato con la sua via d'uscita; l'informazione non è mai il solo colore.
- [ ] `BaSchermataCopertura` ha una sola azione, chiara; a 2,0 il contenuto scorre e l'azione resta in basso; dopo il tocco è inattiva.
- [ ] `flutter analyze` e `flutter test` verdi; CI verde; il test sulla documentazione passa; nessun componente esistente modificato.
- [ ] Nella galleria, la verifica di Luca: le righe dell'elenco nei tre stati, le impostazioni con la conseguenza e lo stato negato, le persone bloccate, l'intestazione nei cinque stati e l'account chiuso a 2,0 e a 744.

## Cosa restituire

Branch `task/029-componenti-stanza-elenco`, report in `docs/reports/029.md` (massimo 30 righe) con le **proposte dove i documenti tacciono**, i valori mancanti nei token, ciò che non hai potuto verificare e la riga «Impatto sull'handoff». Pull request con il template.
