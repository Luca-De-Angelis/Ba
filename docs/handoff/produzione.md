# Dal prototipo alla produzione

Che cosa è finto nel prototipo e dove si sostituisce, dove il codice si innesta con il server e con l'audio, che cosa non esiste ancora, e le cose che vanno tenute d'occhio: suono e vibrazione, accessibilità, traduzioni, CI.

Torna all'[indice](README.md). Per le regole che il codice deve rispettare vedi [regole](regole.md); per le ipotesi ancora aperte [aperte](aperte.md).

**Che cosa è il prototipo.** Un design system in Flutter (token e 28 componenti, ciascuno con i suoi test) e una **galleria** per vederli in Chrome. Non c'è un'app: `main.dart` è uno schermo vuoto, non ci sono schermate, navigazione, rete, audio né server. Il team di sviluppo ha il suo server e il suo audio in tempo reale, e **non sono in questa repo** (lo dice `CLAUDE.md`, «Cosa non è in questa repo»; l'`README.md` della radice lascia aperta la scelta di dove vivranno server, LiveKit e trascrizione).

## Che cosa è finto, e dove si sostituisce

| Che cosa | Dove | Con che cosa si sostituisce |
| --- | --- | --- |
| **Persone, nomi, iniziali, tinte e sagome** della stanza finta | `lib/galleria/galleria_palco.dart` (`_nomi`, `indiceTinta`, `indiceSagoma`) | Le persone vere della stanza, come `BaPersonaPalco`: `id` stabile, tinta e sagoma **assegnate dalla stanza** |
| **Chi parla, l'ampiezza, la linea persa**: sono interruttori («Parlano», «Ampiezza», «Persa», «Simula voce») | `lib/galleria/galleria_presenza.dart`, `galleria_palco.dart` | I segnali dell'audio (vedi sotto) |
| **Il pubblico**: «12 in ascolto», tre sagome fisse | `galleria_palco.dart` (`_ascoltano`), `BaPubblico` con tinte e sagome `[0, 1, 2]` | Il conteggio vero; tinte e sagome scelte dal chiamante, stabili |
| **`onTap` vuoti o che chiudono il foglio**: le azioni della barra, le righe della scheda, «Altro» | `galleria_palco.dart`, `galleria_fogli.dart`, `galleria_controlli.dart` | Le azioni vere: ogni componente espone solo callback e non esegue niente da solo |
| **Testi fissi in italiano** (titoli, etichette, «Azione 4», «Azione nuova 1»…) | tutta la galleria, esente da `l10n/` (D-030) | Le chiavi di traduzione, scritte dal chiamante e passate ai componenti |
| **Il Navigator interno** della stanza finta | `lib/galleria/galleria_navigator.dart` | Il Navigator dell'app: `showBaFoglio` usa quello del contesto |
| **`dietro` di `BaPalco`** acceso a mano mentre un foglio è aperto | `galleria_palco.dart` | Chi apre un foglio lo accende (il palco non sa dei fogli) |
| **La lista dei temi** dei DEN è «di prova» (C3) | il prototipo 014 e [`design/handoff/014/changelog.md`](../../design/handoff/014/changelog.md); nel codice non c'è nessuna lista | La lista ufficiale (domanda 13 della mail, vedi [aperte](aperte.md)) |
| **Valori provvisori** dei tempi della coda (posto conservato Pro 3 minuti, permanenza massima 60) | `BaCodaTokens` in `tokens.dart` | I valori decisi (domanda 11) |
| **Il web**: la galleria gira in Chrome, l'app no | D-030 | L'app vera, su iOS e Android |

La galleria **non si porta in produzione**: è uno strumento di sviluppo.

## Dove il codice si innesta con il server e con l'audio

Quello che i componenti si aspettano **in ingresso**. Sono i punti d'innesto; la logica che li produce non esiste.

| Che cosa | Dove entra | Che cosa si aspetta il codice | Note |
| --- | --- | --- | --- |
| **Le persone sul palco** | `BaPalco.persone` (lista di `BaPersonaPalco`) | Da 0 a 8 persone, **in ordine**: l'ordine decide chi sta a quale centro e l'ordine di lettura. Ogni `id` è unico e stabile (assert in debug) | Oltre 8 è un errore (`ArgumentError`) |
| **Chi parla** | `BaPersonaPalco.parla` → anello | Un fatto booleano, che arriva presto. Il commento in `tokens.dart` lo lega a `ActiveSpeakersChanged` | Con il solo `parla` l'anello regge già il significato |
| **L'ampiezza** | `BaPersonaPalco.ampiezza`, da 0 a 1 | Campionata dall'SDK; il commento in `tokens.dart` dice «LiveKit, 500 ms di default» (`BaMovimentoTokens.campionamentoAmpiezza`). Il respiro dell'anello sale in 500 ms e scende in 600 | **Da verificare** con chi integra l'audio: il dato vero e il suo intervallo |
| **Quante voci insieme** (il limiter) | lo calcola `BaPalco` | Conta chi parla **con un anello**: `parla`, non persa, non mutata, non bloccata. Lo passa a ogni presenza | Non è un parametro del chiamante |
| **Linea instabile, linea persa** | `BaPresenza.lineaInstabile`, `BaPersonaPalco.persa`, `BaStatoPalco.congelato` | Il codice mostra lo stato; **chi lo decide non c'è**. I tempi sono token: instabile dopo 4 s, persa dopo 12 s, riprova ogni 8 s (`BaMovimentoTokens`) | La decisione del posto conservato (30 s Free, 3 minuti Pro: ipotesi) è logica di un task successivo, lo dice `palco.dart` |
| **Entrare, uscire** | `BaStatoPalco.scheletro(n)` mentre si entra; la lista cambia quando altri entrano o escono | Attese prima di riassettare il palco: 4 s all'ingresso, 6 s all'uscita (`attesaIngresso`, `attesaUscita`) | L'assestamento **animato** non c'è: il palco ricalcola subito (rimandato) |
| **Stati con glifo** | `mutata`, `bloccata`, `microfonoSpento`, `io`, `haLaParola` | Booleani dalla stanza e dalle preferenze personali (la voce mutata e il blocco sono scelte di chi usa l'app, non atti pubblici) | Precedenza del disco: bloccata > mutata > microfono spento |
| **Le immagini** | `BaPersonaPalco.immagine` (`ImageProvider`) | Il caricamento è di chi lo usa; se fallisce restano le iniziali | |
| **Ciò che va alle superfici di sistema** | `BaPayloadStanza` | `stanza`, `sulPalco`, `inizio`, `tinte` (al massimo 4), `iniziali`. **Niente «chi parla»**: lì il dato non si aggiorna abbastanza spesso | Le superfici (Live Activity, notifica) **non esistono** |
| **Il tempo del posto conservato** | `BaCodaTokens.oraDelPosto(persa, durata)` | L'istante in cui è caduta la linea e la durata; restituisce l'ora fino a cui il posto è tuo (troncata al minuto) o `null` sotto i due minuti | Si mostra come ora, mai come conto alla rovescia |
| **Il tempo dell'invio del codice** | `BaAccessoTokens.nuovoInvioAttesa` (30 s) | Solo il valore: il conto non esiste | |
| **Il codice di accesso** | `BaCampoCodice` (`onCompleto`, `stato`, `frase`) | Il codice scritto (sei cifre) esce da `onCompleto`; **chi lo verifica e decide** se è `sbagliato`, `scaduto` o se c'è un'`attesa` per un nuovo invio **non c'è**: lo decide il server, il componente mostra lo stato e la frase. L'SMS si legge con `AutofillHints.oneTimeCode` | **Da verificare** su un telefono vero: l'autocompilazione dell'SMS |
| **La coda e l'attesa** | `BaRigaCoda` (`onEsci`), `BaInterruttoreRiga` (`onCambia`), `BaFasciaAttesa` (`onLascia`, presente solo per chi ha la capacità), `BaBandaPosto` (testo già composto) | I componenti ricevono testi e callback: **nessuna logica di coda** (posizione, posto libero, ingresso automatico, permanenza) esiste. La banda del posto la compone il chiamante con `BaCodaTokens.oraDelPosto` | La banda non calcola mai un tempo |

## Che cosa non esiste

Per non promettere: nel codice **non c'è** niente di tutto questo, solo i valori di design in `tokens.dart`.

- **Il server (Servizio)**, l'audio (LiveKit, coturn), la trascrizione, la rete e la persistenza.
- **L'accesso, la registrazione, il consenso, «Torna ascoltatore»**: ci sono i token (`BaAccessoTokens`), il prototipo 013 (aggiornato dal 027) e, dai task 022 e 023a, i controlli (`BaCampoTesto`, `BaCampoCodice`) e il foglio a più passi (`BaFoglioPassi`); la logica e le schermate no.
- **La navigazione e le schermate**. `app/lib/core/` e `app/lib/features/` sono vuote.
- **Le notifiche**, la Live Activity su iPhone, la Dynamic Island, la notifica Android: l'Inventario le descrive (C5), il codice no. Il meccanismo per spegnere il microfono a schermo bloccato è un'ipotesi in attesa dello sviluppo (domanda 18 della mail).
- **Gli annunci dello screen reader dei propri cambi di stato** (D-034): nel codice ci sono la regione viva di `BaMessaggio` e di `BaFraseErrore` per un errore e, dal task 023a, il titolo di `BaFoglioPassi` dal secondo passo (da provare con TalkBack e VoiceOver, vedi sotto).
- **Menù di selezione e maniglie nei campi di testo.** `BaCampoTesto` e `BaCampoCodice` si costruiscono con `EditableText` e **non hanno** il menù di selezione né le maniglie — incolla da pressione lunga, taglia, copia, seleziona tutto — né il posizionamento del cursore col dito: richiederebbero la barra degli strumenti di Material o di Cupertino, che qui non si importano. Si scrive, si incolla dalla tastiera del telefono (e dal suggerimento dell'SMS) e da una tastiera fisica, e si cancella. **In produzione vanno aggiunti.** Non è verificabile da qui come si comportano la tastiera vera, l'incolla e l'autocompilazione su un telefono: **da verificare**.
- **Suono e vibrazione**, vedi sotto.
- **La sintesi tecnica sull'audio** e gli ADR esistenti lato sviluppo non sono nella repo: `docs/research/README.md` e `docs/adr/README.md` dicono che vanno portati, e `DECISIONS.md` ha una nota «Da unire» sul registro delle decisioni dello sviluppo (`BA_Decisioni_Consolidate.md`). Nessun ADR è presente oggi.

## Suono e vibrazione

**Nessun codice di suono né di vibrazione esiste ancora**, e non ci sono file audio (la repo ignora `*.wav`, `*.mp3`, ecc. per non committare voci vere). Esiste la **specifica**:

- i **token**, in `tokens.dart`: `BaApticaTokens` (otto pattern di vibrazione, durate e ampiezze nel formato di Android `createWaveform` e iOS Core Haptics), `BaSuonoTokens` (tre suoni: `ba_mic_spento`, `ba_conn_persa`, `ba_conn_ripresa`, con durata e volume relativo 0,5) e `BaSuonoTokens.consentito`, che dice che un suono non parte con il microfono aperto;
- la **tabella degli eventi**: [`design/handoff/015/suono-e-vibrazione.md`](../../design/handoff/015/suono-e-vibrazione.md) (la versione completa; identica a quella in [`design/handoff/002/`](../../design/handoff/002/suono-e-vibrazione.md)). Aggiunge due eventi del task 015: il posto libero con l'ingresso manuale (notifica di sistema, nessun segnale dell'app) e il posto passato al ritorno della linea (un suono senza vibrazione: **ipotesi**).

Le tre regole che reggono la tabella: un suono a microfono aperto finisce nella stanza; la forza di una vibrazione non si legge in tasca, quindi i pattern si distinguono per numero e durata; **niente per le azioni degli altri né per chi entra o esce**. I tre suoni **vanno ancora prodotti**, e chi li realizza non è deciso (voce in «Aperte» di `DECISIONS.md`); i pattern vanno provati su un iPhone e su un Android veri.

## Accessibilità

Che cosa il codice fa già e che cosa va costruito:

- **Etichetta per lo screen reader** su ogni presenza e su ogni controllo: la dà sempre il chiamante (`semanticsLabel`), in lingua. Il contenuto visivo di un `BaTouchable` è escluso dalla semantica: l'etichetta è l'unica rappresentazione accessibile. Anello, disco e glifo sono decorativi: il significato sta nell'etichetta.
- **Ordine di lettura del palco:** `BaPalco` lo fissa con `OrdinalSortKey`, uguale all'ordine dei centri (l'ordine geometrico di Flutter con le righe sfalsate può leggere le presenze nell'ordine sbagliato). Per questo `palco.dart` importa `package:flutter/semantics.dart` ([architettura](architettura.md)).
- **Annunci:** vedi la regola D-034 in [regole](regole.md). Oggi esiste solo la regione viva dell'errore (`BaMessaggio`). I fogli si annunciano come finestre (`namesRoute` e `scopesRoute`) con il titolo come nome, e **non annunciano l'arrivo di nessuno**.
- **Fogli:** il focus entra nel foglio, Tab non ne esce, alla chiusura il focus torna dov'era; ciò che sta dietro è escluso dalla semantica finché il foglio è aperto.
- **Il codice è un campo solo:** `BaCampoCodice` ha sei caselle disegnate ma **un solo elemento focalizzabile**, con l'etichetta del chiamante e il valore letto cifra per cifra; l'errore di un campo o del codice (`BaFraseErrore`) è una regione viva e si annuncia; gli interruttori sono `toggled`, le scelte esclusive sono `inMutuallyExclusiveGroup`, i chip `selected`. Provato sull'albero semantico, **non con uno screen reader vero**.
- **Il cambio di passo del foglio a più passi, con TalkBack e VoiceOver.** `BaFoglioPassi` porta il focus sul titolo del nuovo passo (un `Focus` dentro un `Semantics` di intestazione) e dal secondo passo ne fa una **regione viva**, perché il foglio resta lo stesso e un nuovo `namesRoute` non basta. **Non è stato provato con uno screen reader vero:** con TalkBack e VoiceOver il titolo potrebbe essere **letto due volte** (una per il focus, una per la regione viva). Va provato su un iPhone e su un Android veri; se succede, si toglie una delle due. Il campo del passo nuovo non prende il focus da solo, per non coprire il titolo con la tastiera.
- **Aree toccabili** di almeno 44, **contrasto AA** (nessun test lo misura: **da verificare** in revisione), **testo di sistema fino a 2,0** senza tagli (ogni componente ha un test a 2,0), **«riduci movimento»**.
- **Stati critici** mai affidati al solo colore.

## Traduzioni

- **Cinque lingue:** italiano (il file di riferimento), inglese, francese, spagnolo, tedesco, in `app/lib/l10n/*.arb`. Oggi ci sono **nove chiavi**, quasi tutte per il palco: `appNome`, `palcoLibero`, `palcoInvito`, `palcoEtichetta` (con il plurale), `presenzaParla`, `presenzaMutata`, `presenzaBloccata`, `presenzaMicSpento`, `presenzaHaLaParola`. Le usano solo la pagina del palco della galleria e `main.dart`.
- **I componenti non importano le traduzioni:** i testi arrivano dal chiamante. Le traduzioni si usano nelle schermate, che non esistono ancora.
- **Come si aggiunge una chiave.** (1) La chiave va in `app_it.arb` con la sua descrizione (`@chiave`) e i segnaposto; (2) lo stesso testo tradotto in tutti e quattro gli altri file; (3) `flutter gen-l10n` (o `flutter pub get`, `flutter test`: li lanciano da sole) rigenera `app_localizations*.dart`, che **non si committano**; (4) un test come [`l10n_palco_test.dart`](../../app/test/l10n_palco_test.dart) che prova la chiave nelle cinque lingue; (5) il report del task elenca le chiavi nuove da rivedere. Il tedesco allunga le etichette fino al 30%: vale per ogni layout.
- **Da far rivedere a madrelingua.** Le chiavi nuove richiedono la revisione dei madrelingua **prima del rilascio** (`CLAUDE.md`). Oggi sono bozze: inglese, francese e spagnolo per intero; il tedesco in parte (le frasi «Mikrofon aus» e «hat das Wort» vengono dal handoff del 002, le altre no). Le tre etichette di «bloccata» sono state riformulate senza genere («persona bloccata», «personne bloquée», «persona bloqueada») e sono bozze anch'esse. Lo dicono i report dei task [012](../reports/012.md) e [021b](../reports/021b.md) e la voce «Traduzioni» di «Aperte» in `DECISIONS.md`.
- **Fra le cose da tradurre** ci sono anche i testi delle schermate dei prototipi: i prototipi sono in italiano e tedesco (selettore `it`/`de`); le altre tre lingue non sono scritte.

## La CI e il lavoro sul codice

- **CI** ([`.github/workflows/ci.yml`](../../.github/workflows/ci.yml)): parte a ogni pull request e a ogni push su `main`; gira su `ubuntu-24.04` nella cartella `app/`. Passi: controllo che `app/pubspec.yaml` ci sia (altrimenti salta i controlli Flutter), Flutter **3.47.9** stable con cache, `flutter pub get`, `flutter analyze`, `flutter test`, e un controllo che nel design system non si importi `package:flutter/material.dart` né `cupertino.dart` (un `grep`). Non fa altro: nessuna build, nessun deploy, nessuna copertura.
- **La versione di Flutter** è fissata di proposito: si aggiorna in un task a parte, e insieme in locale e in `ci.yml`. La voce «Aggiornamento di Flutter» in «Aperte» elenca che cosa controllare (i delegati Material e Cupertino del file di traduzioni, i test sensibili ai tempi).
- **Il ciclo di un task** è nel `README.md` della radice: brief, piano, branch `task/NNN-nome`, `/verify NNN` ([`.claude/commands/verify.md`](../../.claude/commands/verify.md)), report in `docs/reports/NNN.md`, pull request con il [template](../../.github/pull_request_template.md), review, merge. Un test in più: [`documentazione_test.dart`](../../app/test/documentazione_test.dart) tiene allineata questa documentazione.
- **Protezione di `main`** (niente push diretti, pull request obbligatoria con CI verde): l'`README.md` della radice la elenca fra i «Primi passi»; che sia attiva su GitHub è **da verificare** (non si legge dal codice).
- **Dati personali:** nessun audio con voci vere nella repo; chiavi e credenziali solo in `.env`, mai committate (`.gitignore` ignora `.env`, `*.wav`, `*.mp3` e simili). Le tre memorie dichiarate in alpha sono nella regola 3 di [regole](regole.md).
