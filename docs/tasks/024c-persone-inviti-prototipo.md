# Task 024c — Persone e inviti nel prototipo, allineamento dei testi, test più leggeri

25 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Il prototipo navigabile (024a e 024b, unite) arriva fino alla coda, alla creazione e gestione dei DEN, alle simulazioni, all'account chiuso e allo schermo bloccato. Mancano **le persone**: i componenti ci sono dal 033 (`BaRicercaPersone`, `BaRigaPersona` estesa, `BaSelettorePersone`, `BaRigaConsenso`, `BaFoglioInvito`) e il design è il 030 (proposta: D-038, D-039, D-041, D-042, D-055), ma nel prototipo il posto degli invitati è ancora un selettore su persone finte (`ganci.dart`). Questo task collega **aggiungere persone, la rubrica, «Chi può trovarmi», gli inviti e il richiamo**, sempre in `app/lib/prototipo/`, con le stesse regole: stato in memoria, nessun `Timer`, nessun import oltre `widgets.dart`, nessun file di `design_system/`, `galleria/` né `tokens.dart` toccato. In più, **due lavori di manutenzione** emersi dalla prova di Luca: i testi del prototipo non coincidono sempre con il design, e la suite è salita a 55 secondi. Fonti: `docs/handoff/prototipo.md`, `schermate.md` (§4 ter: P1–P6, R1–R3, V1–V2, S1–S3, I1–I6, C1–C5), `aperte.md`, il prototipo `design/handoff/030/Persone e inviti 030.dc.html` con il `changelog.md`, `027/Account e controlli 027.dc.html`, `015/Coda e attesa 015.dc.html`, `001/Stati critici`, e il codice del prototipo. Dove un documento tace, **proponi nel piano e segnala nel report**.

## Do

1. **Branch** `task/024c-prototipo`, da `main` aggiornato (024b già unito). **Primo commit: allineamento dei testi** (punto 2); poi i flussi; **ultimo: l'alleggerimento dei test** (punto 8). Un solo piano, una sola pull request.
2. **Allinea i testi ai prototipi di design**, solo in `testi.dart`, con i test aggiornati. L'account chiuso è il caso noto: B1 dice «Questo account non può più usare BA», «Un contenuto non rispetta le regole di BA.» e «Se pensi che sia un errore, puoi chiedere una revisione.»; B1 bis ha la riga «Potrai rientrare il 21 novembre alle 21:40.» (ipotesi); B2 «Richiesta inviata» (da `design/handoff/027/Account e controlli 027.dc.html`). Controlla anche il banner del richiamo (K7, 015) e il foglio del microfono negato (Fase 2, `001/Stati critici`) e usa i testi dei prototipi. Elenca nel report ogni testo cambiato, con il file di design da cui viene.
3. **Aggiungere persone.** Una voce di ingresso (proponi dove sta: il tasto «+» di D-039; l'elenco ha già un'azione sola) apre la pagina «Aggiungi persone» con `BaRicercaPersone` che **filtra davvero** persone di prova (nickname, alias, email, numero, da due caratteri) e i suggeriti; le righe con «Aggiungi» che diventa «✓ Aggiunta»; i due «Sara» distinti dall'alias; nessun risultato con «Invita con un link»; l'errore di rete provocato dal pannello.
4. **La rubrica e «Chi può trovarmi».** Il foglio di richiesta del permesso con il rifiuto senza colpa e lo stato dopo il rifiuto, la lista «Dalla rubrica» («Su BA» e «Non ancora su BA» con «Invita»); la voce «Chi può trovarmi» nelle impostazioni con le tre scelte (Nessuno, Chi conosco, Tutti) e la conseguenza scritta; valore di partenza «Chi conosco» (ipotesi).
5. **Gli inviti nei flussi esistenti.** Il passo «Chi inviti?» di «Crea un DEN» e il posto del co-amministratore in «Gestisci» usano ora la ricerca e le persone aggiunte (lo stesso `BaSelettorePersone`); `ganci.dart` resta **il solo punto** che li fornisce.
6. **«Sei stato invitato».** Dal pannello: *arriva un invito (ho BA)* (banner, poi il foglio `BaFoglioInvito.valido` «Entra / Non ora»; entrando si sta come **ascoltatore** nel DEN privato, D-041), *arriva un invito (non ho BA)* (la mail e la pagina d'arrivo sono **fuori dall'app**: mostrale come pagine marcate «fuori dall'app · simulazione», poi l'accesso con email del 013 e l'ingresso diretto nel DEN), *l'invito è scaduto* e *annullato* (`.scaduto`, `.annullato`). Se si è **già in un DEN**, l'invito apre «Vuoi passare di qua?» (K6, D-042); una **coda in un DEN privato pieno** usa lo stesso «Mettiti in coda» (nessuna schermata nuova).
7. **Il richiamo.** Nelle impostazioni la riga «Richiamo» (parte **spenta**), poi «Chi puoi avvisare» (un `BaRigaConsenso` per persona aggiunta, con la conferma «Avvisare Marta?») e «Chi può avvisarti»; dal pannello *una persona che ho scelto entra in un DEN pubblico* (il banner K7 di 024b, ma solo per le persone con il consenso acceso e solo per DEN pubblici). **Nessuna schermata, in nessun punto, mostra o lascia dedurre che una persona è online o in un DEN senza il suo consenso**; un test cerca le parole «online» e «in un DEN» nel sorgente di `lib/prototipo/`.
8. **Test più leggeri.** La suite è passata da ~40 a **55 secondi** sulla macchina di Luca (tetto 60). **Misura i dieci test più lenti** e alleggeriscili (per esempio condividendo la costruzione della cornice, o evitando riavvii inutili), **senza togliere nessun controllo**; obiettivo: la suite sotto i 45 secondi con i test nuovi. Scrivi nel report prima e dopo.
9. **Documenti.** `docs/handoff/prototipo.md` (i percorsi da provare 20 e seguenti, le simulazioni nuove), `schermate.md` (P1–P6, R1–R3, V1–V2, S1–S3, I1–I6, C1–C5 «collegate nel prototipo»), `aperte.md` (le proposte nuove), `app/README.md`, `docs/tasks/README.md` (024b concluso, 024c in corso), e nel report la riga «Impatto sull'handoff».

## Do NOT

- Non costruire la scoperta né il pacchetto creator, e non modificare `design_system/`, `galleria/` né `tokens.dart` (se un componente non basta, segnalalo nel report).
- Nessun `Timer`, `Future.delayed`, Material, Cupertino né import oltre `widgets.dart`; nessun conto alla rovescia, contatore di follower o di amici, classifica, segno del pagante, stato «online» o «visto da».
- Non decidere le questioni aperte (alias unico, nome «Aggiungi», richiamo solo fra persone aggiunte): sono proposte di Luca, segnate come tali in `aperte.md`.

## Acceptance check

- [ ] I testi dell'account chiuso, del richiamo e del microfono negato coincidono con i prototipi di design; il report elenca ogni testo cambiato.
- [ ] La ricerca filtra davvero; le due Sara si distinguono per l'alias; l'aggiunta è privata e non produce nessun avviso.
- [ ] Il richiamo parte spento, vale solo per DEN pubblici e solo per chi ha il consenso acceso; nessuna parola «online» né «in un DEN» nel sorgente del prototipo (test).
- [ ] L'invito arriva a chi ha BA e a chi non ce l'ha, fino all'ingresso nel DEN come ascoltatore; l'invito scaduto e annullato hanno il loro stato; già in un DEN apre «Vuoi passare di qua?».
- [ ] `flutter analyze` e `flutter test` verdi, **suite sotto i 45 secondi** (misura prima e dopo); CI verde; il test sulla documentazione passa; `git diff main -- app/lib/design_system app/lib/galleria` vuoto.

## Cosa restituire

Branch `task/024c-prototipo`, report in `docs/reports/024c.md` (massimo 30 righe) con le **proposte dove i documenti tacciono**, i testi cambiati, i secondi della suite prima e dopo, ciò che non hai potuto verificare e la riga «Impatto sull'handoff». Pull request con il template. In `prototipo.md`, **i percorsi che Luca può provare** in Chrome.
