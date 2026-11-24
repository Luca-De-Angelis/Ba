# Task 024 — Prototipo navigabile in locale

24 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Il progetto consegna un **prototipo navigabile in locale** e questa repository. Con i task 020–029 il design system ha tutti i componenti per le pagine e i fogli dei prototipi 013, 014, 015 e 027 (stanza, elenco, impostazioni, persone bloccate, account chiuso, fogli di accesso a parlare, coda, creazione e gestione dei DEN). Mancano **il collegamento** e **le pagine intere**. Questo task li costruisce: una pagina web in Chrome, lanciata in locale, che parte dal login e si naviga **il più possibile come un'app**, con dati finti. D-030 resta vero: il web è uno strumento di sviluppo e di dimostrazione, non una piattaforma di prodotto; il prototipo non è un'app. Fonti: `docs/handoff/schermate.md` e `componenti.md` (che cosa esiste per ogni schermata), i prototipi `design/handoff/013/Accesso 013.dc.html`, `014/Creare DEN 014.dc.html`, `015/Coda e attesa 015.dc.html`, `027/Account e controlli 027.dc.html`, `002/Stati critici 002.dc.html` e `001/Schermate 001.dc.html` con i `changelog.md`, `docs/handoff/regole.md` e `aperte.md`, e la galleria (`lib/galleria/`: la stanza finta e i fogli già composti). Dove un documento tace, **proponi nel piano e segnala nel report**.

## Do

1. **Branch** `task/024-prototipo`, da `main` aggiornato (029 già unito). **Due pull request in sequenza**, dallo stesso piano: **024a** (struttura, accesso, elenco, stanza, «diventa partecipante», impostazioni) e **024b** (coda, creazione e «Gestisci», simulazioni, account chiuso, schermo bloccato simulato).
2. **Punto di ingresso a parte**: `lib/prototipo/main_prototipo.dart`, lanciato con `flutter run -d chrome -t lib/prototipo/main_prototipo.dart` da `app/`; non tocca `lib/galleria/` né `lib/design_system/`. Una **cornice da telefono** centrata (larghezza proposta nel piano), e **fuori dalla cornice un pannello dello strumento**: testo 1,0 e 2,0, riduci movimento, tornare all'inizio, e le simulazioni del punto 6. Quello che sta nella cornice è il prodotto; il pannello no.
3. **Stato finto in memoria**, senza dipendenze (`ValueNotifier` e simili di `widgets.dart`): tipo di account (ascoltatore, partecipante, chiuso), nickname, i DEN e le persone di prova, la stanza in cui si è e il proprio ruolo (pubblico, sul palco, in coda), microfono acceso o spento. Niente persistenza: ricaricare riparte dal login. Testi italiani fissi in **un solo file**, presi dai prototipi; numeri di telefono evidentemente finti (320 000 0000).
4. **Le pagine** (solo componenti del design system, nessun valore a mano): **accesso** (email → codice con i suoi errori e la scadenza → onboarding → termini con «almeno 18 anni» → nickname), **elenco dei DEN** (righe viva, spenta, su invito; «Sei ascoltatore» o partecipante; «Crea un DEN»), **stanza** (intestazione, alone, palco, pubblico, barra delle azioni; la scheda della persona al tocco di una presenza; «Altro»), **impostazioni** (lingua, microfono, persone bloccate con le sue righe, «Torna ascoltatore» con le **due conferme**, «Esci»), **account chiuso**.
5. **I fogli**, composti come nella galleria e collegati ai gesti: «Sali sul palco» da ascoltatore apre «diventa partecipante» (avviso, numero, codice, consenso) e alla fine l'account passa a partecipante e si sale **a microfono spento**; «Mettiti in coda» con le sue due varianti e «Le tue code»; «Crea un DEN» (da ascoltatore passa prima dal percorso di accesso a parlare), con riepilogo, successo (si entra come amministratore) e l'errore; «Gestisci» (anche per i DEN pubblici creati da un utente), il sotto-DEN.
6. **Le simulazioni, dal pannello e non da timer.** Nessun `Timer` né conto alla rovescia: gli eventi si provocano con un tasto, e così sono ripetibili. Almeno: *qualcuno parla*, *si libera un posto* (il foglio «pochi secondi» e «Vuoi passare di qua?»), *perdo la linea* e *torno in linea* (con il posto conservato), *arriva un richiamo*, *l'account viene chiuso*, *la creazione del DEN non riesce*. Le notifiche si mostrano come un banner in cima alla cornice, che al tocco porta dove deve.
7. **Lo schermo bloccato simulato** (D-050): una pagina che mostra i quattro stati (palco con microfono acceso e spento, pubblico in diretta e in pausa), raggiungibile dal pannello; è una simulazione e lo dice. Dal telefono bloccato il microfono si spegne e **non si accende** (D-025).
8. **Ganci per le fasi dopo** (persone e inviti, scoperta): nessuna schermata, ma i punti dove si innestano (il «Qui: la fonte degli invitati» del passo degli invitati, l'elenco) restano un posto che si può sostituire.
9. **Documenti.** `docs/handoff/` (la regola «Impatto sull'handoff»): un nuovo `prototipo.md` (come si lancia, come si naviga, che cosa è finto, che cosa non c'è, quali schermate sono collegate) **elencato nell'indice del `README.md`** (il test sulla documentazione lo impone); `avvio.md`, `schermate.md` (ogni schermata con «collegata nel prototipo»), `aperte.md`, `app/README.md`, `docs/tasks/README.md` (024a e 024b).

## Do NOT

- Non modificare `tokens.dart`, i componenti del design system né la galleria; se un componente non basta, segnalalo nel report invece di cambiarlo. Il codice nuovo vive in `lib/prototipo/`.
- Niente backend, audio, autenticazione vera, persistenza, notifiche di sistema, timer o conti alla rovescia; nessun contatore che accumula, nessun segno del pagante, nessun annuncio dell'ingresso di altri.
- Non costruire persone e inviti, la scoperta né il pacchetto creator: i design 030 e 031 non sono ancora costruiti.
- Niente Material o Cupertino, nuove dipendenze, golden, numeri di design a mano; ogni import oltre `widgets.dart` va motivato nel file e in `CLAUDE.md`.

## Acceptance check

- [ ] `flutter run -d chrome -t lib/prototipo/main_prototipo.dart` parte dal login e arriva alla stanza con tocchi e tastiera, senza uscire dal prodotto.
- [ ] Dall'ascoltatore: sali sul palco → i quattro passi → partecipante, a microfono spento; crea un DEN → i passi → si entra come amministratore; «Torna ascoltatore» chiede due conferme.
- [ ] Ogni elemento toccabile fa qualcosa di plausibile o è chiaramente inattivo; nessun vicolo cieco senza «Indietro», «Non ora» o «Chiudi».
- [ ] Le simulazioni funzionano e non c'è nessun `Timer`; a testo 2,0 e a 744 nulla si taglia nelle pagine e le azioni restano ancorate.
- [ ] `flutter analyze` e `flutter test` verdi, i secondi della suite sotto i 60; CI verde; il test sulla documentazione passa; nessun file di `design_system/` né `galleria/` cambia.

## Cosa restituire

Due pull request (`024a`, `024b`) e per ciascuna un report (`docs/reports/024a.md` e `024b.md`, massimo 30 righe) con le **proposte dove i documenti tacciono**, ciò che non è collegato, i valori mancanti nei token e la riga «Impatto sull'handoff». Alla fine, l'elenco dei **percorsi che Luca può provare** da Chrome, in `docs/handoff/prototipo.md`.
