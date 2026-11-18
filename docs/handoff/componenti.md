# I componenti

Una riga per ogni componente di [`app/lib/design_system/`](../../app/lib/design_system/), **ricavata dal codice**: classi pubbliche, parametri, classi di token usate (`grep` sul file) e test che lo importano. Il test [`app/test/documentazione_test.dart`](../../app/test/documentazione_test.dart) fa fallire la suite se un file che definisce un componente non compare qui: quando aggiungi un componente, aggiungi la riga (lo dice anche `CLAUDE.md`).

Torna all'[indice](README.md). Per sapere come si costruisce un componente nuovo vedi [architettura](architettura.md); per le schermate che li usano vedi [schermate](schermate.md).

**Come si legge.** «Token» sono le classi di [`tokens.dart`](../../app/lib/design_system/tokens.dart) che il file cita; i valori stanno lì. «Fonte di design» è la sezione di [`design/system/md/inventario-componenti.md`](../../design/system/md/inventario-componenti.md) (la copia di lettura dell'Inventario di Claude Design) e il prototipo in `design/handoff/`. In caso di divergenza fanno fede il codice e `tokens.dart`.

## La tabella

| Componente | File | A che cosa serve | Stati e varianti | Token | Test |
| --- | --- | --- | --- | --- | --- |
| `BaTouchable` | [`touchable.dart`](../../app/lib/design_system/touchable.dart) | Rende toccabile qualunque contenuto: premuto, focus, area minima di 44, tastiera (Invio e spazio), semantica da bottone | varianti `standard` (cede a scala 0,98 con un velo) e `suPresenza` (nessuna scala: il premuto lo disegna il contenuto); stati a riposo, premuto, a fuoco, inattivo (`onTap` nullo) | Color, Controllo, Movimento, Raggio | [`touchable_test.dart`](../../app/test/touchable_test.dart) |
| `BaRitratto` | [`ritratto.dart`](../../app/lib/design_system/ritratto.dart) | Ciò che sta dentro la sagoma di una presenza: immagine, iniziali o sagoma nuda | in carico (iniziali), caricata (immagine con velo), fallita (iniziali), assente; sotto 32 dp nessuna iniziale | Color, Presenza, Scala, Testo | [`ritratto_test.dart`](../../app/test/ritratto_test.dart) |
| `BaAnello` | [`anello.dart`](../../app/lib/design_system/anello.dart) | L'anello di chi parla, a doppio tratto, su due canali: `parla` (compare in 70 ms, scompare in 140) e `ampiezza` (il respiro, campionata ogni 500 ms) | a riposo, voce, ampiezza, linea instabile, fermo; ripiego statico con «riduci movimento» | Color, Movimento, Presenza | [`anello_test.dart`](../../app/test/anello_test.dart) |
| `BaPresenza` | [`presenza.dart`](../../app/lib/design_system/presenza.dart) | Una persona sul palco: sagoma, tinta, ritratto, anello, disco con glifo, tacca della parola, tocco | ferma, parla, persa, scheletro, mutata (anche mentre parla), bloccata, microfono spento (altri e «io»), ha la parola, premuta, a fuoco | Color, Movimento, Presenza, Raggio, Sagoma, Tinta | [`presenza_test.dart`](../../app/test/presenza_test.dart), [`presenza_glifi_test.dart`](../../app/test/presenza_glifi_test.dart) |
| `BaPalco` | [`palco.dart`](../../app/lib/design_system/palco.dart) | Il palco: riceve una **scatola**, ne ricava diametro e posizioni con `disponiPalco` e mette una `BaPresenza` per persona. L'unico punto dell'app dove un layout decide una misura | da 1 a 8 persone (nessuna è mai tolta); `vivo`, `scheletro(n)`, `congelato`; palco vuoto con invito; `dietro` (un foglio è aperto: presenze a 0,22 e sfocate) | Color, Presenza, Spazio, Testo | [`palco_test.dart`](../../app/test/palco_test.dart), [`palco_disposizione_test.dart`](../../app/test/palco_disposizione_test.dart) |
| `BaGlifo` | [`glifo.dart`](../../app/lib/design_system/glifo.dart) | Il segno dentro il disco di una presenza: microfono, altoparlante o cerchio, tutti barrati | tipi `microfono`, `altoparlante`, `bloccata`; spento (opacità 0,45) e acceso (1) in 140 ms; `ripiego` a 32 | Color, Glifo, Movimento, Presenza | [`glifo_test.dart`](../../app/test/glifo_test.dart), [`glifo_livello_test.dart`](../../app/test/glifo_livello_test.dart) |
| `BaPillola` | [`pillola.dart`](../../app/lib/design_system/pillola.dart) | Il controllo di BA, sopra `BaTouchable` | `informativa` (non fa niente), `attiva`, `chiara`, `spenta` (hairline); a riposo, premuta, a fuoco, inattiva | Color, Controllo, Raggio, Spazio, Testo | [`pillola_test.dart`](../../app/test/pillola_test.dart) |
| `BaAzioniInCoppia` | [`azioni_in_coppia.dart`](../../app/lib/design_system/azioni_in_coppia.dart) | Due pillole spente affiancate, o una sola centrata; aree toccabili che si toccano senza sovrapporsi | due o una; stati indipendenti fra le due; stessa altezza (la più alta) | Controllo | [`azioni_in_coppia_test.dart`](../../app/test/azioni_in_coppia_test.dart) |
| `BaBarraAzioni` | [`barra_azioni.dart`](../../app/lib/design_system/barra_azioni.dart) | La barra in fondo allo schermo: un posto primario e due secondari; dalla quarta azione compare «Altro» (48 × 48) | da 1 a 3 azioni senza «Altro»; da 4 con «Altro» (chiama `onAltro`); a testo grande le secondarie vanno in colonna se una parola non entra | BarraAzioni, Color, Controllo, Raggio | [`barra_azioni_test.dart`](../../app/test/barra_azioni_test.dart) |
| `BaPubblico` | [`pubblico.dart`](../../app/lib/design_system/pubblico.dart) | Il campione di chi ascolta e il contatore | nessuno (non si disegna), da 1 a 3 sagome, oltre 3 un campione fisso di tre; nessuna animazione | Color, Controllo, Presenza, Sagoma, Scala, Spazio, Testo, Tinta | [`pubblico_test.dart`](../../app/test/pubblico_test.dart) |
| `BaFoglio` | [`foglio.dart`](../../app/lib/design_system/foglio.dart) | Il contenitore di ciò che si apre sopra la stanza: sale dal basso su un velo; il corpo scorre, le azioni restano ancorate. Si apre con `showBaFoglio` | facce `richiesta`, `scheda`, `invito`; chiuso, in salita (240 ms, subito con «riduci movimento»), aperto, contenuto più alto dello schermo (scorre) | Accesso, Color, Controllo, Layout, Movimento, Raggio, Scala, Spazio, Testo | [`foglio_test.dart`](../../app/test/foglio_test.dart) |
| `BaSchedaPersona` | [`scheda_persona.dart`](../../app/lib/design_system/scheda_persona.dart) | Il contenuto del foglio «scheda presenza»: nome e stato, le tre righe fisse (muta, blocca, segnala) e il gruppo delle azioni nuove | «Muta questa voce» attiva solo se la persona parla (altrimenti inattiva con la spiegazione); azioni nuove da zero a molte | Color, Controllo, Scala, SchedaPersona, Spazio, Testo | [`scheda_persona_test.dart`](../../app/test/scheda_persona_test.dart) |
| `BaMessaggio` | [`messaggio.dart`](../../app/lib/design_system/messaggio.dart) | Una frase che la schermata dice: neutro o errore. L'errore non si riempie mai | `neutro`, `errore` (filetto, segno «!» e testo; annunciato come regione viva) | Accesso, Color, Raggio, Spazio, Testo | [`messaggio_test.dart`](../../app/test/messaggio_test.dart) |
| `BaPuntoAggancio` | [`punto_aggancio.dart`](../../app/lib/design_system/punto_aggancio.dart) | Una riga tratteggiata che tiene il posto di ciò che non è deciso (invitati, persone, il campo «Quando» spento): **solo un posto, mai un'azione** | forma riquadro; forma `quando` (filetto tratteggiato e interruttore spento 44 × 26 che non si tocca); non toccabile, non focalizzabile, non è un bottone | Color, Controllo, Creazione, Scala, Spazio, Testo | [`punto_aggancio_test.dart`](../../app/test/punto_aggancio_test.dart), [`tratteggio_test.dart`](../../app/test/tratteggio_test.dart) |

I test della galleria ([`galleria_test.dart`](../../app/test/galleria_test.dart)) provano anche l'uso insieme di `BaAzioniInCoppia`, `BaBarraAzioni`, `BaFoglio`, `BaGlifo`, `BaMessaggio`, `BaPalco`, `BaPillola`, `BaPresenza`, `BaPubblico` e `BaSchedaPersona`.

## Fonte di design e note per la produzione

| Componente | Fonte di design | Note per chi lo userà in produzione |
| --- | --- | --- |
| `BaTouchable` | Inventario C3 (e C7 bis); `token.md` T7 bis e T8. Nessun prototipo dedicato: il comportamento è descritto nei token | Chiede sempre `semanticsLabel`: il contenuto visivo è **escluso** dalla semantica. Un widget che sporge dai propri confini non riceve i tocchi: l'area estesa funziona solo se il genitore la contiene (limite dichiarato nel file) |
| `BaRitratto` | Inventario C1; [Stati critici 002](../../design/handoff/002/Stati%20critici%20002.dc.html) | `immagine` è un `ImageProvider`: il caricamento è di chi lo usa. Se fallisce restano le iniziali |
| `BaAnello` | Inventario C1; Stati critici 002 | Vuole due segnali separati: `parla` (il fatto, arriva presto) e `ampiezza` (0–1, decorazione). Il commento in `tokens.dart` li lega a `ActiveSpeakersChanged` e a un campionamento dell'SDK ogni 500 ms (LiveKit): **da verificare** con chi integra l'audio. `voci` è il numero di voci con anello (il limiter) |
| `BaPresenza` | Inventario C1; Stati critici 002 (le cinque presenze, il disco, la tacca) | Il diametro non è un parametro: lo eredita da un `BaDiametro` messo dal palco. Tinta e sagoma sono **indici** assegnati dalla stanza, non si calcolano dall'id. Un solo disco con precedenza bloccata > mutata > microfono spento; «persa» è un filtro sopra qualunque aspetto; lo scheletro batte tutto |
| `BaPalco` | Inventario C1 e C6; Stati critici 002; [Stanza 004](../../design/handoff/004/Schermate%20004.dc.html); [disposizioni](../../design/handoff/005/disposizioni.svg) (generato da un test) | Vuole la larghezza dello **schermo** (non della scatola: decide telefono o tablet). L'**ordine** della lista `persone` decide chi sta a quale centro e l'ordine di lettura; gli `id` sono unici (assert in debug). Nessuna persona viene tolta, nemmeno se la scatola è troppo piccola (`sfora`). Non conosce le traduzioni: etichetta e testi dell'invito arrivano dal chiamante. `dietro` lo accende chi apre un foglio. L'assestamento animato non c'è (è rimandato, lo dice il file) |
| `BaGlifo` | Inventario C3; Stati critici 002 (§7.17); consegna [012c](../../design/handoff/012c/changelog.md) | Sta fuori dalla semantica: il significato lo dà l'etichetta della presenza. L'altoparlante e il cerchio sono stati confermati dalla consegna 012c |
| `BaPillola` | Inventario C3; Stati critici 002, [Accesso 013](../../design/handoff/013/Accesso%20013.dc.html), [Creare DEN 014](../../design/handoff/014/Creare%20DEN%20014.dc.html) | La `chiara` solo dove l'app non prosegue senza quel gesto, una per schermata (regola 1). Altezza **minima**: il testo grande la alza, non la taglia. Testo ed etichetta dal chiamante |
| `BaAzioniInCoppia` | Inventario C3; Stati critici 002 | Estensione verso la vicina di mezzo gap; verso l'esterno solo se il genitore la contiene |
| `BaBarraAzioni` | Inventario C3 (la regola della barra); `decisioni-consolidate` §7.19; Stati critici 002 (sezione «La barra delle azioni e la scheda di una persona») | Le prime tre azioni della lista sono visibili, le altre vanno in «Altro»: **chi chiama le ordina** perché «Esci», «Scendi dal palco» e il microfono stiano fra le prime tre. In debug un assert se la primaria o una fissa finirebbe in «Altro», se la primaria non è una sola o se c'è più di una chiara. Non costruisce il foglio di «Altro»: chiama `onAltro` |
| `BaPubblico` | Inventario C1; Stati critici 002 | Tinte e sagome sono liste di indici dal chiamante; il testo del contatore («14 in ascolto») arriva già composto |
| `BaFoglio` | Inventario C3; Stati critici 002 (foglio e scheda), Accesso 013 (un solo foglio che cresce per passi) | `showBaFoglio` usa il `Navigator` del contesto: l'app deve averne uno. Il foglio non chiude da solo (velo, «indietro» o `Navigator.pop`); il focus torna dov'era. Niente trascinamento verso il basso. La curva di salita è `curvaScheda` limitata a 1 (il rimbalzo lascerebbe una striscia vuota). **Da fare:** scriverla in T8 |
| `BaSchedaPersona` | Inventario C3 e `decisioni-consolidate` §7.19; Stati critici 002 (schermata 6) | È solo contenuto: le azioni sono callback e non eseguono niente. «Muta questa voce» è inattiva se `parla` è falso |
| `BaMessaggio` | Inventario C3; Accesso 013 (l'errore del codice, il segno «!») | **Uno solo per schermata**: un assert da dentro il widget non è possibile, la regola è del chiamante. Un errore si annuncia, un neutro no |
| `BaPuntoAggancio` | Inventario C4; [Creare DEN 014](../../design/handoff/014/Creare%20DEN%20014.dc.html) (C2 «Quando», C4 invitati, G2 persone) e [Accesso 013](../../design/handoff/013/Accesso%20013.dc.html) (A1, il posto per «Continua con…») | Non è mai un'azione: quando la fonte sarà decisa (domanda 8 in [aperte](aperte.md)) entra qui senza ridisegnare il passo. Il testo, anche il sottotitolo, lo dà il chiamante; per lo screen reader è solo testo. Il colore del tratteggio è `ascoltoGruppoBordo` (manca un token dedicato) |

## Componenti di supporto (nello stesso file)

| Nome | File | Che cos'è |
| --- | --- | --- |
| `BaDiametro` | `presenza.dart` | Il diametro che il palco eredita alle presenze (regola 5) |
| `BaDiscoGlifo` | `presenza.dart` | Il disco in basso a destra della sagoma con il glifo |
| `BaTaccaParola` | `presenza.dart` | La tacca sotto la sagoma di chi ha la parola |
| `BaPersonaPalco`, `BaStatoPalco` | `palco.dart` | I dati di una persona sul palco e lo stato del palco: vedi [architettura](architettura.md) |
| `BaVarianteTocco`, `BaStatoTocco` | `touchable.dart` | Le due varianti del tocco e lo stato che il builder riceve |
| `BaTipoGlifo` | `glifo.dart` | I tre glifi |
| `BaVariantePillola` | `pillola.dart` | Le quattro varianti della pillola |
| `BaAzioneCoppia` | `azioni_in_coppia.dart` | Una delle due azioni della coppia |
| `BaRuoloAzione`, `BaAzioneBarra` | `barra_azioni.dart` | Il ruolo (primaria o secondaria) e un'azione della barra |
| `BaVarianteFoglio`, `BaAzioneFoglio`, `showBaFoglio` | `foglio.dart` | Le tre facce, un'azione ancorata e la funzione che apre il foglio |
| `BaRigaAzione`, `BaAzioneScheda` | `scheda_persona.dart` | Una riga di azione (usata anche dal foglio di «Altro» nella galleria) e un'azione nuova della scheda. `BaRigaAzione` non è nell'Inventario |
| `BaVarianteMessaggio` | `messaggio.dart` | Neutro o errore |
| `BaTratteggio` | `tratteggio.dart` | Il bordo tratteggiato (Flutter non ne ha uno): tratti da `BaSpazioTokens.xs` e vuoti da `xxs`, spezzando il contorno con `Path.computeMetrics()`. Lo condividono `BaPuntoAggancio` e `BaBandaPosto`; non è toccabile e non entra nella semantica |

## I file che non sono componenti

Questi tre file di `app/lib/design_system/` non definiscono widget e per questo non hanno una riga nella tabella; il test li elenca come esenti, ognuno con il motivo.

| File | Che cos'è |
| --- | --- |
| [`tokens.dart`](../../app/lib/design_system/tokens.dart) | I valori di design (e `BaOra`, `BaPayloadStanza`, `BaRegole`): non è un widget |
| [`forma.dart`](../../app/lib/design_system/forma.dart) | Una funzione di geometria (`ingrandisci`), usata da `anello.dart`, `presenza.dart` e `touchable.dart` |
| [`palco/disposizione.dart`](../../app/lib/design_system/palco/disposizione.dart) | La funzione pura `disponiPalco`: diametro e centri, senza widget |

## Non ancora costruiti

Nomi che l'Inventario elenca nelle tabelle C2, C4 e C5 e che **non hanno ancora una classe** in `app/lib/` (verificato con una ricerca di `class <nome>` nel codice). L'Inventario dice anche che esiste uno scaffold `BaSchermata` (C8) che porta il posto unico della richiesta: nel codice non c'è. **L'Inventario introduce «venti widget (C1–C4)», ma le sue tabelle ne nominano 28: da verificare con chi lo mantiene.**

| Sezione | Nomi | Per che cosa servono |
| --- | --- | --- |
| C2, struttura della stanza | `BaIntestazione`, `BaMarcatore`, `BaRigaStato`, `BaFasciaTesto`, `BaAlone` | Intestazione, marcatori, riga di stato, fascia di testo (non in v1) e alone dietro il palco |
| C4, elenco e impostazioni | `BaRigaDen`, `BaRigaImpostazione`, `BaRigaBloccata` | Le righe degli elenchi dei DEN, delle impostazioni e delle persone bloccate |
| C4, accesso e creazione | `BaCampoCodice`, `BaSceltaDen`, `BaChipScelta`, `BaPuntoAggancio` | Il codice a sei caselle, la scelta del tipo di DEN, i chip di tema e lingua, il punto di aggancio |
| C4, gestione, coda e attesa | `BaFoglioGestisci`, `BaInterruttoreRiga`, `BaRigaCoda`, `BaFasciaAttesa`, `BaBandaPosto` | Il foglio «Gestisci», l'interruttore di riga, «Le tue code», il sotto-DEN d'attesa e la banda del posto conservato |
| C5, superfici di sistema | `BaCardLive`, `BaIsola`, `BaNotificaAndroid` | Live Activity, Dynamic Island e notifica Android: **non sono widget Flutter** (l'Inventario le descrive come superfici che Flutter non disegna) |

Che cosa serve a ogni schermata, e che cosa manca in totale, è in [schermate](schermate.md). I componenti dei task 022–024 (vedi `docs/tasks/README.md`) non esistono ancora.
