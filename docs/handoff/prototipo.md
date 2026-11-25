# Il prototipo navigabile

Torna all'[indice](README.md). Come farlo girare in generale è in [avvio](avvio.md); le schermate dei prototipi di design e che cosa esiste per ognuna sono in [schermate](schermate.md); i componenti in [componenti](componenti.md).

Il prototipo è una **pagina web in Chrome**, in locale, che parte dal login e si naviga il più possibile come un'app, con **dati finti**, collegando le pagine e i fogli già costruiti. **D-030: il web è uno strumento di sviluppo e di dimostrazione, non una piattaforma di prodotto; il prototipo non è un'app.** Il codice vive in `app/lib/prototipo/` e non tocca `lib/design_system/` né `lib/galleria/`.

## Come si lancia

```
cd app
flutter run -d chrome -t lib/prototipo/main_prototipo.dart
```

Servono Flutter e Chrome ([avvio](avvio.md)). Niente backend, audio, autenticazione vera, persistenza, notifiche di sistema, timer: lo stato è in memoria e **ricaricare la pagina riparte dal login**.

## Come si naviga

- **La cornice** al centro è un telefono da **360 dp** (il dispositivo di riferimento) e alto 896 (sul palco, a testo 2,0, la barra a tre posti e «Altro» non entra in meno; a testo 2,0 diventa **1200**, perché una nota lunga come il posto offerto non entra: un telefono vero scorrerebbe); dal pannello si passa a **744** (il tablet). **Quello che sta nella cornice è il prodotto.**
- **Il pannello dello strumento**, fuori dalla cornice, **non è il prodotto**: testo 1,0 e 2,0, riduci movimento, larghezza 360 e 744, **«Torna all'inizio»** (riparte dal login), una riga con i **codici di prova**, le **simulazioni** (sotto) e, in piccolo, lo stato finto (account e pagina). Accanto alla cornice il pannello scorre da solo.
- **Codici di prova:** `123456` è giusto, `000000` è scaduto, ogni altro è sbagliato. Il numero di telefono dei passi di «diventa partecipante» è `320 000 0000` (qualunque numero non vuoto va bene); la email, una qualunque che sembri una email.
- **Con la tastiera:** Tab porta il focus da un elemento al successivo, Invio e spazio toccano; al cambio di pagina il titolo della pagina nuova prende il focus. **Ogni vicolo ha un'uscita:** «Indietro» nelle pagine, «Non ora» o «Chiudi» nei fogli.

## I percorsi che puoi provare in Chrome (024a)

1. **Dal login all'elenco.** Email (`sara.m@example.it`) → «Ricevi il codice» → il codice `123456` → «Conferma» → «Prima di entrare» → «Ho capito» → «Termini e privacy» → «Accetto» → nickname → «Continua»: si arriva all'**elenco** da **ascoltatore** («sei ascoltatore»).
2. **Gli errori del codice.** Un codice qualunque → «Il codice non è giusto»; `000000` → «Il codice è scaduto» e l'azione diventa «Manda un nuovo codice»; «Mandalo di nuovo» o «Manda un nuovo codice» → «Ne puoi chiedere un altro fra poco» (inattivo, nessun conto alla rovescia); scrivere di nuovo finisce l'attesa. Un'email senza `@` e un nickname vuoto danno la loro frase.
3. **Dall'elenco alla stanza.** Tocca «Cucina di notte» (cinque sul palco, Marta B. parla), «Fra due turni» (due) o «Radio insonni» (vuoto: «Il palco è libero»). Si entra **come pubblico** (D-006). **«Esci»** torna all'elenco.
4. **Sali sul palco da ascoltatore → partecipante.** Nella stanza, «Sali sul palco» → il foglio «diventa partecipante» (avviso → numero → codice → consenso: «Acconsento e salgo»; «Indietro» in ogni passo dopo il primo): l'account passa a **partecipante** e **si sale a microfono spento** (D-007). «Accendi il microfono» / «Spegni il microfono» / «Scendi dal palco».
5. **Da partecipante si sale subito.** Torna all'elenco (ora «sei partecipante» e compare «Corridoio lungo», su invito, D-041), entra in un'altra stanza e «Sali sul palco»: nessun foglio, sempre a microfono spento.
6. **La scheda di una persona.** Tocca una presenza: la scheda con «Muta questa voce» (attiva solo se parla), «Blocca» e «Segnala». **«Blocca»** chiude la scheda e la persona sul palco compare **con il glifo «bloccata»**; sta anche nelle persone bloccate (impostazioni) e **«Sblocca» la ripristina**.
7. **«Altro».** Come nei prototipi 015 e 027, **l'ascoltatore ha «Sali sul palco», «Esci» e «Altro»**, e dentro «Altro» ci sono **«Impostazioni» e «Persone bloccate»** (e «Altro» porta alle impostazioni; «Indietro» riporta alla stanza). Sul palco la barra ha «Microfono», «Scendi dal palco», «Esci» e «Altro» con le stesse due voci dentro. «Impostazioni» non è un'azione visibile per nessun ruolo. Lo permette `inAltro` di `BaAzioneBarra` (task 034).8. **Le impostazioni** (dall'elenco, riga «Impostazioni ›»): lingua e microfono (di sola lettura), **«Persone bloccate»** (con «Sblocca») e, da partecipante, **«Torna ascoltatore» con le due conferme** («Tornare ascoltatore?» → «Ne sei sicuro?»); dopo, la riga diventa un fatto («Sei ascoltatore»). **«Esci da BA»** riporta al login.
9. **«Crea un DEN» da ascoltatore.** «Per creare un DEN bisogna diventare partecipante» → i quattro passi («Acconsento e continuo») → l'account è partecipante e **si continua con i passi della creazione** (percorso 14).

## I percorsi che puoi provare in Chrome (024b)

Le **simulazioni** sono tasti del pannello: ognuno cambia lo stato **a un colpo** (si può premere di nuovo) e **non c'è nessun timer**; ciò che nei documenti scade da solo ha un secondo tasto («il posto scade»). Un tasto senza niente da simulare è inattivo e la ragione è scritta sotto.

10. **Mettiti in coda.** Da partecipante entra in **«Tavolo lungo»** (palco pieno: la primaria è «Mettiti in coda»): il foglio K2 con «Fammi entrare automaticamente»; «Mettiti in coda» → «Esci dalla coda» (a filetto) e, in «Altro», **«Le tue code»** (K1, con «Esci dalla coda»). **«Serra»** ha la coda piena: S1 «La coda è piena adesso» («Ho capito»). Da ascoltatore «Mettiti in coda» passa prima da «diventa partecipante».
11. **«Aspetta con altri».** Accendi nel pannello **«capacità di aspettare con altri»**: K2 mostra la riga «Aspetta con altri» (senza la capacità la riga non esiste, né etichetta né traccia); acceso, «Mettiti in coda» porta a W1 e «Entra nel gruppo» dà la fascia d'attesa con «Lascia il gruppo» (solo per chi ha la capacità).
12. **Il posto offerto.** In coda, **«si libera un posto»**: nella stanza la frase K4 («Hai pochi secondi per salire. Salirai a microfono spento.», nessun conto alla rovescia), «Sali sul palco» chiara e il **banner** K3; con «Fammi entrare automaticamente» acceso si sale subito a microfono spento (K5). **«il posto scade»** → K4 bis («Il posto è passato alla persona dopo di te. Resti in coda.», «In coda» inattiva). Se sei in un altro DEN, il banner porta a **«Vuoi passare di qua?»** (K6: «Passa» / «Resta qui»).
13. **Un richiamo.** **«arriva un richiamo»**: il banner «Ciccio è entrato nel DEN Famiglia · vuoi passare?» (K7); dall'elenco entra in «Famiglia» (pubblico), da una stanza apre K6. La riga sotto il tasto dice che il richiamo arriva solo da chi ti ha scelto e solo per DEN pubblici (proposta 030).
14. **Creare un DEN.** «Crea un DEN» (da partecipante subito; da ascoltatore dopo «diventa partecipante») → tipo → nome («Scrivi un nome per il DEN.») → descrizione, tema e lingua → **invitati** (solo il privato, con `BaSelettorePersone` su persone finte) → riepilogo → «Crea il DEN»: **si entra come amministratore, sul palco, a microfono spento**, e il DEN è nell'elenco. **«la creazione non riesce»** arma il prossimo «Crea il DEN»: S2 «Il DEN non è stato creato», «Riprova» (quello che hai scritto resta) e stavolta riesce.
15. **«Gestisci» e il sotto-DEN.** Nel DEN che hai creato (privato o pubblico), «Altro» ha **«Gestisci»** (descrizione, co-amministratori con il limite «0 di 1», persone con «Rimuovi» e la conferma, «Termina il DEN» con la conferma) e **«Nuovo sotto-DEN»**. Nei DEN di prova non ci sono.
16. **Linea persa.** Sul palco, **«perdo la linea»**: intestazione disconnessa, palco congelato, alone spento, microfono spento, «Il posto resta tuo ancora per un momento.» e «Sto riprovando…» inattiva (P1). **«torno in linea»**: il posto c'era (P2); se prima premi **«il posto scade»**, il posto è stato preso e sei fra il pubblico con «Mettiti in coda» (P3). **«qualcuno parla»**: l'anello passa alla persona dopo.
17. **Il permesso del microfono.** **«microfono negato»**: nelle impostazioni la riga «Microfono» è «Negato — senza il microfono non puoi parlare» con **«Apri»** (simula il ritorno dalle impostazioni del telefono con il permesso dato); sul palco, «Accendi il microfono» apre il foglio «Senza microfono non posso farti parlare» («Apri le impostazioni» / «Resto ad ascoltare»).
18. **L'account chiuso.** **«l'account viene chiuso»** (B1) e **«blocco temporaneo»** (B1 bis, con la durata): una copertura sopra tutto con «Richiedi revisione» → B2 «Revisione richiesta» e «Richiesta inviata» inattiva. **«riapri l'account»** (dello strumento) per riprovare.
19. **Lo schermo bloccato.** In una stanza, **«schermo bloccato»** (simulazione): sul palco con il microfono acceso L1 («Spegni il microfono»), spento L2 (solo il testo: **dal telefono bloccato il microfono si spegne e non si accende**, D-025); nel pubblico L3 («Pausa») e L4 («Riprendi dal vivo»); «Esci» esce dalla stanza, «Prossimo DEN» è inattivo, «Sblocca» chiude la simulazione.

## Che cosa è finto

Tutto: i DEN, le persone, i numeri, il codice, la «verifica» del telefono. **Non c'è** nessun server, nessuna voce, nessuna autenticazione, nessuna persistenza, nessuna notifica di sistema, nessun timer. Gli eventi si provocano con un tocco, mai col tempo: così sono ripetibili. I testi sono in italiano, fissi, in **un solo file** (`lib/prototipo/testi.dart`), presi dai prototipi.

## Che cosa non c'è

**Persone e inviti** (ricerca, rubrica, «Sei stato invitato», richiamo con il consenso) e la scoperta (024c e dopo: i design 030 e 031 hanno i componenti, non ancora le pagine). Non c'è «sto salendo» (002: dura fino a 8 secondi, e senza timer non si può): si sale subito. «Sblocca» toglie la persona subito (lo stato «sblocco in corso» chiede tempo).

## Le schermate collegate

| Schermata | Collegata | Note |
| --- | --- | --- |
| A1 email · A2 codice (e i suoi errori) · A3 prima di entrare · A4 termini · A5 nickname (013) | **024a** | codice di prova `123456` |
| A6 elenco · E1 «Crea un DEN» (013, 014) | **024a** | «Crea un DEN» da ascoltatore apre il percorso di «diventa partecipante»; da partecipante apre i passi della creazione (024b) |
| Stanza: pubblico, sul palco con microfono acceso e spento, palco vuoto, scheda persona, «Altro» (002) | **024a** | senza «sto salendo»; il palco pieno e la coda: 024b |
| P1–P4 «diventa partecipante» · R1, R2 (013, 014) | **024a** | |
| T1–T4 «Torna ascoltatore» · persone bloccate · impostazioni (013, 001) | **024a** | «Esci da BA» → login |
| Coda e attesa (015: K1, K2, K2 ter, K4, K4 bis, K5, K6, K7, W1, W2, S1) · linea persa e ritorno (015 P1–P3) | **024b** | senza W3 (lasciare il gruppo per salire: il posto si offre e basta); P1 senza l'ora fissa (P1 bis) |
| «Crea un DEN» C1–C5 · S2 · «Gestisci» G1–G5 · sotto-DEN D1 (014) | **024b** | il posto degli invitati e del co-amministratore con `BaSelettorePersone` su persone finte (`ganci.dart`: un solo punto da sostituire nel 024c); da ascoltatore «diventa partecipante» e la creazione sono due fogli di seguito |
| Account chiuso B1, B1 bis, B2 · schermo bloccato L1–L4 (027) · permesso del microfono negato (001, Fase 2) | **024b** | simulazioni dichiarate, dal pannello |
| Persone e inviti, richiamo, scoperta (030, 031) | non collegate | 024c e dopo |

## Le proposte del task 024 dove i documenti tacciono

«Esci» dalla stanza → l'elenco; «Esci da BA» → il login; le impostazioni si aprono da una riga «Impostazioni ›» in fondo all'elenco (non da un'azione: l'elenco ne ha una sola, 014b) e dall'«Altro» della stanza; il tocco di una riga dell'elenco entra come pubblico; l'intestazione dell'elenco di un partecipante è «sei partecipante» (il 013 ha solo «sei ascoltatore»); dopo «Torna ascoltatore» non c'è un nuovo accesso (ipotesi 17 in [aperte](aperte.md)); il codice di prova e l'attesa del nuovo invio che dura finché si scrive; «Lingua» e «Microfono» sono righe di sola lettura; «Blocca» dalla scheda aggiunge una persona alle bloccate.

## Limiti dichiarati

- **La 024b.** Senza timer: il posto offerto non scade da solo (un tasto), il nuovo invio del codice resta in attesa finché si scrive, il banner non scompare da solo. Il sotto-DEN non ha la «fascia chi mi sente» (non esiste come componente): la stanza ne prende nota in una riga. Lo schermo bloccato è una simulazione sopra la cornice: non è il telefono. «Prossimo DEN» è inattivo. Il DEN creato parte con due persone di prova sul palco, per poter provare «Rimuovi». Le persone degli inviti e del co-amministratore sono finte (024c).
- **Il doppio annuncio.** Al cambio di pagina il titolo della pagina nuova prende il focus ed è un'intestazione, e la pagina ha un nome per lo screen reader (come `BaFoglioPassi` al cambio di passo). **Senza TalkBack e VoiceOver veri non so se il nome della pagina e il titolo a fuoco, insieme, facciano leggere il titolo una volta o due**: va provato su dispositivo.
- **Chrome.** I test provano i widget, non il browser: la resa in Chrome, la tastiera vera (anche l'incolla nei campi: senza Material non ci sono il menu di selezione né le maniglie, vedi [produzione](produzione.md)) e lo scorrimento con il mouse non sono verificati da qui.
- Il prototipo non è un'app: non va confuso con il lavoro di produzione ([produzione](produzione.md)).

## Come si aggiunge una pagina

Una voce nell'enum `Pagina` (`lib/prototipo/stato.dart`), una pagina in `lib/prototipo/` che usa `PaginaProto` (nome, titolo, corpo, azioni) e una riga in `pagine.dart`. I testi vanno in `testi.dart`; i valori di design, nei token.
