# App Flutter

Il progetto Flutter c'è (iOS, Android e, solo per la galleria, web). Lo stato oggi:

- **Token**: `lib/design_system/tokens.dart`, la copia unica dei valori di design, a due livelli (D-019).
- **Componenti** in `lib/design_system/`: `BaTouchable` (task 009), `BaRitratto`, `BaAnello` e `BaPresenza` con `BaDiametro` (task 010 e 010b, stati di base), `BaPalco` (task 011, widget sopra `disponiPalco` in `palco/disposizione.dart`). `BaGlifo` (task 012) e gli stati di `BaPresenza` con glifo: mutata, bloccata, microfono spento e la tacca della parola; i tre glifi stanno nel disco in basso a destra della sagoma, mai al centro. I testi di `BaPalco` gli arrivano dal chiamante: non importa le traduzioni. I controlli (task 020): `BaPillola` (informativa, attiva, chiara, spenta; altezza minima `primario`, raggio a stadio), `BaAzioniInCoppia` (due pillole spente o una centrata), `BaBarraAzioni` (un posto primario e due secondari; «Altro» dalla quarta azione, che chiama `onAltro`: il foglio arriva con il 021) e `BaPubblico` (campione di tre sagome e contatore, senza animazione). Nessuno importa le traduzioni: i testi arrivano dal chiamante. I fogli (task 021): `BaFoglio` (il contenitore: corpo che scorre e azioni ancorate in basso, altezza massima 0,80 sul telefono e 0,62 dal tablet; tre facce, richiesta, scheda e invito) con `showBaFoglio` che lo apre sopra un velo; `BaSchedaPersona` (le tre righe fisse e il gruppo delle azioni nuove) con `BaRigaAzione`; `BaMessaggio` (neutro ed errore, l'errore mai pieno). Nessuno importa le traduzioni. I controlli dei task 013–015 (task 022): `BaCampoTesto` (la linea sotto, costruito con `EditableText`) con `BaFraseErrore`, `BaCampoCodice` (sei caselle, un campo solo per lo screen reader), `BaSceltaDen`, `BaChipScelta` (la spunta è disegnata), `BaPuntoAggancio` (solo un posto, mai un'azione) e `BaTratteggio`, `BaInterruttoreRiga`, `BaRigaCoda`, `BaFasciaAttesa`, `BaBandaPosto`. Nessuno importa le traduzioni; i campi di testo non hanno menù di selezione né maniglie (richiederebbero Material o Cupertino).
- **Traduzioni**: file ARB in `lib/l10n/`, `l10n.yaml`, `generate: true`. Cinque lingue (IT, EN, FR, ES, DE); oggi nove chiavi, quasi tutte per il palco (vedi «Traduzioni» sotto).
- **Font**: Instrument Sans e IBM Plex Mono (OFL) in `assets/fonts/`, dichiarati nel `pubspec.yaml`.
- **Galleria di sviluppo**: vedi sotto.
- `lib/features/` e `lib/core/` (audio, servizio) sono ancora vuote. `main.dart` è uno schermo vuoto del colore di fondo, senza Material.

Struttura di `lib/`:

```
lib/
├── design_system/   # tokens.dart, BaTouchable, BaPresenza, BaPillola, barra delle azioni, BaFoglio, palco/…
├── galleria/        # pagine di sviluppo (D-030), esenti da l10n
├── features/        # access, home, room, settings (vuota)
├── l10n/            # file ARB
├── core/            # audio (LiveKit), servizio (vuota)
└── main.dart
```

L'ordine di costruzione è in `design/system/md/inventario-componenti.md`: `BaTouchable` → `BaPresenza` con `BaRitratto` e `BaAnello` → `BaPalco` → i componenti con glifo.

Comandi, sempre da questa cartella: `flutter pub get`, `flutter analyze`, `flutter test`.

## Traduzioni (file ARB)

I testi dell'interfaccia sono in `lib/l10n/app_<lingua>.arb`, configurati da `l10n.yaml`: **`app_it.arb` è il riferimento** (`template-arb-file`) e le altre quattro lingue (`en`, `fr`, `es`, `de`) lo seguono. `flutter gen-l10n` (o `flutter pub get` e `flutter test`, che lo lanciano da soli) genera `app_localizations*.dart`, che **non si committano**. I componenti di `design_system/` non importano le traduzioni: il testo arriva dal chiamante.

**Come è fatta una chiave** (in `app_it.arb`):
- **Nome** in camelCase, per area e poi per cosa dice: `palcoLibero`, `palcoInvito`, `presenzaParla`, `presenzaBloccata`. Il nome non porta la lingua né il testo.
- **Descrizione**: subito dopo, `"@chiave": { "description": "…" }`, che dice **dove compare, a chi serve e qualunque vincolo** («Etichetta di una persona bloccata, per lo screen reader.»). La leggono i madrelingua nel foglio di revisione (colonna `contesto`): scrivila per chi non ha visto la schermata.
- **Segnaposto**: fra graffe nel testo (`{nome}`, `{n}`) e dichiarati in `@chiave` con il loro tipo (`"placeholders": { "nome": { "type": "String" } }`, `int` per i conteggi). Non si traducono e **restano uguali in tutte le lingue**.
- **Plurali**: sintassi ICU con i casi `=0` e `=1` **espliciti** (in francese 0 e 1 sono entrambi «uno»): `{n, plural, =0{…} =1{…} other{…}}`.
- **Senza genere**: l'italiano non usa participi o aggettivi che dipendano dal genere di una persona (`docs/GLOSSARY.md`, «Genere grammaticale»): `Persona bloccata: {nome}`, non «{nome}, bloccata».
- Gli altri quattro file hanno **solo i testi**: descrizioni e segnaposto stanno nell'italiano.

**Come si aggiunge una chiave**: nell'italiano con descrizione e segnaposto; lo stesso testo tradotto in tutti gli altri file; un test come `test/l10n_palco_test.dart` che la prova nelle cinque lingue; il report del task elenca le chiavi nuove da far rivedere.

**Come si aggiunge una lingua**: (1) `lib/l10n/app_<codice>.arb` (codice a due lettere) con `"@@locale": "<codice>"` e **tutte le stesse chiavi** dell'italiano, con gli stessi segnaposto, **senza** i `@chiave`; (2) `flutter gen-l10n`: la lingua entra da sola in `AppLocalizations.supportedLocales` (non c'è una lista da aggiornare a mano); (3) aggiungere il codice a `_lingue` nei test di `test/l10n_palco_test.dart`; (4) `dart run tool/revisione_traduzioni.dart` prepara il suo foglio di revisione in `docs/traduzioni/` (vedi il suo `README.md`); (5) i madrelingua rivedono **prima del rilascio** (`CLAUDE.md`). Il tedesco allunga le etichette fino al 30%: vale per ogni layout.

## Tablet e orientamento (D-020)

L'app gira su telefono e tablet dalla beta 1, per ora solo in verticale. Due punti tecnici da decidere con lo sviluppo:

- Su iPad, un'app che limita l'orientamento deve rinunciare a Split View e Slide Over (`UIRequiresFullScreen` in `Info.plist`). Se in futuro si aggiunge l'orizzontale, si può tornare indietro.
- Il blocco in verticale si imposta sia nella configurazione nativa sia con `SystemChrome.setPreferredOrientations`, ma il layout non deve dipenderne: i breakpoint usano la larghezza.

## Galleria di sviluppo (D-030)

Una pagina per vedere i componenti del design system in Chrome, senza emulatore né Mac. Il web serve solo a questo: i target restano iOS e Android.

Da questa cartella (`app/`):

```bash
flutter run -d chrome -t lib/galleria/main_galleria.dart
```

La galleria sta in `lib/galleria/`, usa solo i token e i suoi testi sono fissi (fuori da `l10n/`). Un menu in cima sceglie la pagina:

- **BaTouchable**: mostra le aree toccabili, riduci movimento, larghezza 360 o 744.
- **BaPresenza**: le presenze ai cinque diametri, le 12 tinte e le 5 sagome, con i controlli per parla, ampiezza (0, 0,5, 1), voci insieme (1, 2, 3), linea instabile, persa, scheletro, immagine caricata e fallita, riduci movimento e «Simula voce» (una ampiezza nuova ogni 500 ms). Dal task 012: mutata (con Parla, mutata che parla), bloccata, microfono spento (altri e io), ha la parola e una riga con i tre glifi a 28 e 32, spenti e accesi. Per vedere insieme la voce al massimo e il focus sulla stessa presenza: Parla, Ampiezza 1, poi Tab.
- **BaPalco**: una stanza finta (intestazione, palco, pubblico e barra delle azioni veri in basso, dal task 020) con persone da 0 a 8, quante parlano (0–3), persa, scheletro, congelato, larghezza 360 o 744, testo di sistema 1,0 o 2,0, riduci movimento e lingua (IT, EN, FR, ES, DE); un indicatore mostra diametro, scatola e «sfora». «Prima persona» le dà uno stato con glifo; «Altezza» fa cedere il palco senza ridimensionare la finestra. Con 1 persona e testo normale: la stanza vuota con una persona a 208 dp. Mentre un foglio è aperto le presenze vanno dietro (`dietro` di `BaPalco`: opacità 0,22 e sfocatura 1,5, subito, tutte insieme).
- **Controlli** (task 020): le quattro varianti di `BaPillola` a riposo e inattive, la coppia (due e una), la barra con da 1 a 6 azioni («Altro» dalla quarta), il pubblico con 0, 1, 2, 3 e 14, e i controlli di sempre (testo 1,0 e 2,0, riduci movimento, larghezza 360 e 744). Il premuto si prova toccando, il focus con Tab.
- **Fogli e messaggi** (task 021): una schermata finta con un Navigator suo, e un pulsante per ogni foglio (richiesta e invito, corti e lunghi; la scheda senza azioni nuove, con azioni nuove, con molte e con la persona che non parla), il messaggio (nessuno, neutro, errore) e i controlli di sempre (testo 1,0 e 2,0, riduci movimento, larghezza 360 e 744). Nella stanza del palco, «Altro» apre le azioni dalla quarta e il tocco su una presenza apre la scheda.
- **Accesso, creazione e coda** (task 022): i nove componenti dei task 013–015 nei loro stati, con i controlli di sempre (testo 1,0 e 2,0, riduci movimento, larghezza 360 e 744). Il campo del codice si scrive davvero (prova a incollare «481902» o «48a1-9») e il pulsante «Codice» ne cambia lo stato: scrittura, sbagliato, scaduto, nuovo invio con attesa. La banda del posto è la stessa a 30 secondi e a 5 minuti.
- **Fogli di contenuto** (task 023a): un pulsante per ogni contenuto, che lo apre in un foglio sulla schermata finta. «Sali sul palco» e «Crea un DEN» aprono il foglio a più passi (avviso, numero, codice, consenso; R1 e R2 per la creazione) con «Continua» e «Indietro (di prova)», che esistono solo nella galleria: il numero e il codice si scrivono davvero e il pulsante «Codice» ne cambia lo stato (scrittura, sbagliato, scaduto, attesa). Poi i fogli della coda: «Mettiti in coda» (senza e con «Aspetta con altri»), «Aspetta con altri», «Le tue code», «Coda piena» e «Vuoi passare di qua?». Testi fissi in italiano, e i controlli di sempre (testo 1,0 e 2,0, riduci movimento, larghezza 360 e 744).
- **Fogli di creazione e gestione** (task 023b): un pulsante per ogni contenuto. «Crea un DEN» si percorre con «Continua» e «Indietro (di prova)», che esistono solo nella galleria: tipo, nome (con il «Quando» spento), descrizione con tema e lingua, invitati (solo il privato), riepilogo; i campi si scrivono davvero, e i controlli «Creazione» (riesce o non riesce) e «Nome» (libero o già usato) provano l'errore e «Riprova». Poi «Nuovo sotto-DEN» e «Gestisci» (con un posto libero o al limite) con tutte le sue viste: menu, descrizione, co-amministratori, persone, conferme di rimozione e di termine. Testi fissi in italiano, e i controlli di sempre (testo 1,0 e 2,0, riduci movimento, larghezza 360 e 744).
- **Stanza ed elenco** (task 029): tutti i componenti delle pagine di partenza nei loro stati, sulla schermata finta: l'intestazione della stanza (pubblica, su invito, viva, in ingresso, disconnessa), la riga di stato, l'alone acceso e spento, le righe dell'elenco dei DEN (viva, spenta, su invito), le impostazioni (valore, interruttore, azione con la conseguenza, permesso negato con «Apri»), le persone bloccate («Sblocca» passa a «Sblocco…» e poi la riga sparisce) e, con il controllo «Account chiuso», la schermata che copre tutto (B1, B1 bis, B2). Testi fissi in italiano, e i controlli di sempre (testo 1,0 e 2,0, riduci movimento, larghezza 360 e 744). La stanza finta della pagina del palco usa ora `BaIntestazione`.
- **Persone e inviti** (task 033): la ricerca (vuota, «sar» con due nickname uguali distinti dall'alias, nessun risultato, errore di rete), le righe di persona nei loro stati (da aggiungere, aggiunta, nell'invito, scegli), il selettore (nessuno scelto, scelti, limite), il richiamo per persona (parte spento; accendere passa da una conferma composta qui) e «Sei stato invitato» (foglio, scaduto, annullato). Due pulsanti aprono i passi «Invita» e «Co-amministratori» con il posto riempito dal selettore. Testi fissi in italiano, e i controlli di sempre (testo 1,0 e 2,0, riduci movimento, larghezza 360 e 744).
- **Scoperta** (task 034): le righe e i fogli del 031 sulla schermata finta: un DEN con il motivo («Perché: tema Cucina») e con «zona abituale», le persone disponibili con «● Disponibile» (sempre con la parola), i tre punti di aggancio della home, «Disponibile a chiacchierare» (la conferma e la riga di stato con «Spegni») e `BaRichiestaPermesso` per gli avvisi e per la posizione, con lo stato dopo il rifiuto. Il tasto del testo gira 1,0, 1,4 e 2,0; il menu delle pagine è una riga che scorre. Nessuna pagina intera.

## Prototipo navigabile (task 024)

Da `app/`: `flutter run -d chrome -t lib/prototipo/main_prototipo.dart`. Parte dal login e si naviga come un'app, con dati finti (codice di prova `123456`), dentro una cornice da telefono; fuori dalla cornice c'è il pannello dello strumento, con le **simulazioni** degli eventi (qualcuno parla, si libera un posto, perdo la linea, l'account viene chiuso, il microfono negato, lo schermo bloccato, un invito, un richiamo…), ognuna un tasto a un colpo, senza timer. Dal 024c ci sono anche le persone: aggiungerle, la rubrica, «Chi può trovarmi», il richiamo e gli inviti (anche per chi non ha BA). Il codice è in `lib/prototipo/`; non tocca il design system né la galleria. Vedi [`docs/handoff/prototipo.md`](../docs/handoff/prototipo.md).
