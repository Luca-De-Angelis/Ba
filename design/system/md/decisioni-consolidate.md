<!-- Copia di lettura generata da "BA - decisioni-consolidate.html". Fa fede l'HTML esportato da Claude Design; i valori fanno fede in app/lib/design_system/tokens.dart. -->
BA · brief di design · sostituisce il §7
# Decisioni consolidate sulla rappresentazione, lo stato e il movimento
Questo documento porta le **decisioni e le motivazioni**. La fonte di verità per i valori è **tokens.dart**: i numeri citati qui sono copie di lettura e, se divergono, vince il file.
Direzione scelta: impacchettamento adattivo con sagome irregolari. Perimetro alpha, tema scuro. Ogni valore qui è destinato a tokens.dart: dove manca un valore è dichiarato mancante, non lasciato al codice.
## 7.1  Come si rappresenta una persona

La persona è rappresentata dall'**immagine che ha scelto**, usata come riempimento della sagoma assegnata dalla stanza. Le **iniziali su tinta assegnata** sono il ripiego. In alpha il ripiego è il caso dominante: è progettato come principale, e ogni stato deve leggersi identico nelle due varianti. Nessun nome visibile accanto alle presenze.

## 7.2  Colore e forma li assegna la stanza

Entrando in un DEN si riceve una tinta libera e una sagoma libera, valide finché si è dentro. Palette e repertorio di sagome sono **chiusi e disegnati**: nessun valore generato da hash dell'ID. Assegnare per stanza garantisce l'unicità dove serve e rende tinta e forma effimere come tutto il resto. Corollario: la forma non identifica una persona fra sessioni diverse, e non deve diventarlo.

## 7.3  Luminanza: il tetto vale anche per le immagini

Le presenze stanno nella metà bassa della scala di luminanza; la parte alta resta allo stato. Sui dischi il tetto è **luminanza relativa ≤ 0,18**, che garantisce iniziali bianche a 4,5:1 senza eccezioni. Con le sfumature il vincolo vale sullo *stop più chiaro*. Sulle immagini il tetto è un velo piatto rgba(8,7,6,.34) dentro la sagoma — un ColorFiltered, non un blur: qualunque foto smette di abbagliare al buio.

| Presenza   | stop chiaro | stop scuro | L (stop chiaro) |
|------------|-------------|------------|-----------------|
| indaco     | \#5257AC    | \#33367A   | 0,118           |
| terracotta | \#A83E2E    | \#6E251C   | 0,120           |
| verde      | \#23735A    | \#14473A   | 0,134           |
| ocra       | \#96621A    | \#5F3C0B   | 0,154           |
| blu        | \#2A6894    | \#1B4463   | 0,131           |
| magenta    | \#AC3765    | \#72203F   | 0,124           |
| oliva      | \#557426    | \#374A18   | 0,151           |
| prugna     | \#7A3080    | \#4E1F52   | 0,092           |

Otto tinte disegnate su dodici previste: le quattro mancanti vanno disegnate in Fase 2 nella stessa banda (L 0,09–0,16), non oltre. I valori di L sono calcolati, non stimati; vanno riverificati sul dispositivo con profilo colore reale.

## 7.4  Sagome irregolari

Raggi asimmetrici entro **±8% dal cerchio** (nessun raggio oltre 58% né sotto 42%): abbastanza per non leggersi come geometria, poco per non leggersi come illustrazione. Cinque sagome in repertorio, assegnate per posto. La sagoma è anche la maschera dell'immagine e il tracciato dell'anello. *Da verificare con volti reali*: se la sagoma più asimmetrica taglia mento o fronte, l'escursione scende a ±5% e la regola diventa "nessun raggio sotto il 46%".

## 7.5  Disposizione: la scala è del gruppo

Le presenze si impacchettano in posizioni irregolari, senza griglia e senza posti vuoti disegnati: **il palco non ha sedie, solo persone**. La dimensione dice quante sono, e appartiene al gruppo: dimensioni diverse fra persone sarebbero rango.

| Sul palco | Diametro  | Iniziali | Luce minima fra sagome          |
|-----------|-----------|----------|---------------------------------|
| 1         | 208 dp    | 61 dp    | —                               |
| 2         | 156 dp    | 46 dp    | 20 dp · *in diagonale a 360 dp* |
| 3–4       | 130 dp    | 38 dp    | 20 dp                           |
| 5–6       | 112 dp    | 33 dp    | 20 dp                           |
| 7–8       | **88 dp** | 26 dp    | 20 dp                           |

## 7.6  Distanza minima: è un token, non un layout

Distanza fra i centri ≥ diametro + banda anello (5) + crescita al picco (4) + respiro (8) = **20 pt di luce fra le sagome**. È il vincolo che tiene l'anello di chi parla fuori dal vicino anche al massimo dell'escursione. Se l'algoritmo di impacchettamento scende sotto questa soglia, il segnale si degrada: la soglia va imposta al packing, non corretta a valle.

**Ricontrollato sulla baseline vera, che è 360 dp e non 375 pt.** Con 320 dp di larghezza utile, una fila di tre a 92 chiedeva 328 dp — otto di troppo, e a pagarli sarebbe stato l'anello del bordo esterno. **Il fondo della scala scende quindi a 88** (tre in fila: 316 dp, quattro di margine). Conseguenza sull'impacchettamento: la coppia a 156 non sta affiancata a questa larghezza e va in diagonale — è un vincolo del packing, non una scala nuova. Il conto per riga, la tabella dei casi e la formula stanno in *BA · Token*, T6 bis.

## 7.7  "Sta parlando": anello a doppio tratto

Chi parla porta un anello che segue la propria sagoma, reattivo al livello audio, distinto per **luminanza e movimento, mai per tinta** — la tinta è occupata dall'identità, e la luminanza è il canale che sopravvive a schermo piccolo, luce scarsa e daltonismo. L'anello porta con sé il proprio sfondo: keyline scura adiacente alla sagoma e tratto chiaro sopra, così il segnale non dipende dall'immagine sotto né da quella del vicino. Non è un tracciato d'onda.

**L'anello sta su due canali, non uno**, e la divisione viene dall'SDK (LiveKit). **Canale veloce**: comparsa e scomparsa, guidate da ActiveSpeakersChanged — un fatto booleano, che arriva presto e regge da solo tutto il significato. **Canale lento**: il respiro, guidato dall'ampiezza campionata a 500 ms — decorazione informata, non informazione. La conseguenza è un vincolo, non una preferenza: **il rilascio del respiro non può essere più corto dell'intervallo di campionamento**, o l'anello si sgonfia fra un campione e l'altro e si rigonfia al successivo, disegnando un dente di sega alla frequenza di campionamento che non ha più niente a che vedere con la voce. Se un giorno il canale lento non arrivasse, resta il veloce: ed è esattamente il ripiego statico del 7.16, non un caso in più da progettare.

**Il proprio livello va degradato al ritmo degli altri.** Il microfono locale è leggibile a qualunque frequenza, e sarebbe gratis far respirare la propria bolla più fluida di tutte: non si fa. La stessa forma avrebbe due comportamenti, e chi lo nota per primo è chi guarda se stesso parlare. Il livello locale si ricampiona a 500 ms come quello di chiunque altro.

|                 |                                                                 |
|-----------------|-----------------------------------------------------------------|
| keyline interna | 3 pt · rgba(8,7,6,.92) · adiacente alla sagoma                  |
| tratto chiaro   | 2 pt · \#F5F1EC · esterno alla keyline                          |
| banda totale    | 5 pt · crescita al picco +4 pt                                  |
| inviluppo       | attacco 70 ms · rilascio 350 ms                                 |
| escursione      | scala 1,00 → 1,075 · opacità 0,28 → 0,95                        |
| implementazione | un ticker per schermata · CustomPainter con repaint: Listenable |

## 7.8  Più voci insieme: un limiter sulla grafica

Con più voci contemporanee l'escursione di ciascun anello si comprime, così l'energia visiva totale resta costante: a due voci il massimo per anello scende a 1,042 di scala e 0,66 di opacità. L'albero di Natale diventa impossibile per costruzione, non sconsigliato per buon gusto.

## 7.9  Abbassata da me — vale per la sessione

La presenza **perde saturazione ma tiene una traccia della propria tinta** (\#4A3F4A→#332B33 per la prugna; con immagine, velo al 66%), le iniziali restano all'80% e l'identità resta leggibile. Occupa comunque un posto sul palco. **Non ha anello, nemmeno ridotto**: l'anello significa "questa voce ti sta arrivando", e su una voce abbassata direbbe il falso. La sua attività passa su un canale separato — un altoparlante barrato che si accende quando quella persona parla, per sola opacità (0,45 → 1 in 140 ms lineari), senza seguire il livello audio. Il glifo usa la stessa logica a doppio tratto dell'anello: casing scuro sotto la barra chiara. Vive solo sul palco: nelle bolle da 22 pt del pubblico sarebbe sotto la soglia di leggibilità, e lì resta la sola desaturazione. Si legge come "abbassato", non come "punito".

## 7.10  Bloccata — permanente, ovunque, dichiarata

La presenza è **neutra piena** (\#3D3B39→#2A2927, iniziali al 70%: la tinta scompare, l'identità no), porta un glifo diverso — cerchio barrato — e **nessun segnale di attività**. Entrando in un DEN dove c'è una persona bloccata la vedo *marcata, non nascosta*: il posto resta occupato e il palco resta contato correttamente.

Il blocco è **l'unica cosa che l'app ricorda di una persona**, ed è un'eccezione dichiarata al principio dell'effimero: va scritta all'utente nel momento in cui blocca, non nascosta in un'informativa, e non protetta da un dialogo di conferma (un dialogo si chiude senza leggerlo). Ne segue un requisito: **l'elenco dei bloccati vive nelle impostazioni (§5.5), con sblocco**. Un'azione permanente senza un posto dove vederla e annullarla non è una preferenza, è una trappola.

## 7.10 bis  Rimosso da un DEN — la memoria è della stanza, non mia · da Fase 2, 5j

Chi ha aperto il DEN può rimuovermi. Nel momento in cui succede la stanza si chiude e resta una frase ferma — *“Non sei più in Fra due turni. Non puoi rientrare.”* — senza motivo inventato, senza dialogo di conferma, senza appello: **il motivo non lo abbiamo e non lo chiediamo**, e un appello in alpha sarebbe una promessa che nessuno può mantenere. L'uscita è hairline, non azione chiara: qui l'app potrebbe riportarmi in elenco da sola, quindi non le serve un colore per chiedermelo (regola 1).

In elenco la riga **resta, spenta e inerte**, con il marcatore rimosso: una porta chiusa si vede, altrimenti sembra un guasto e si ritenta. **Non è un blocco e non si somma al blocco:** il blocco è mio verso una persona e vale in ogni DEN, la rimozione è di una stanza verso di me e vale in quella stanza — chi mi ha rimosso non entra fra le persone che non sento, perché non l'ho deciso io. Le impostazioni tengono le due cose nella stessa schermata (§5.5), in due gruppi: *dati da te*, con **Sblocca**, e *ricevuti*, **senza nessuna azione**. È l'asimmetria a dire la differenza; un pulsante inattivo suggerirebbe che da qualche parte c'è un modo. Stesso tempo sfocato del blocco (“in aprile”, “stasera”).

## 7.11  Il pubblico

Il pubblico è **un numero**, più al massimo tre bolle da 22 pt come campione stabile — non "ultimi connessi", che sarebbe una classifica e produrrebbe rimescolio in periferia. L'arrivo di qualcuno è un evento transitorio, non uno slot permanente. Il pubblico esiste solo da nove persone in su: a quota zero deve costare zero. Nessun marcatore di stato a questa scala.

## 7.12  I nomi esistono, non si vedono

Nessun nome accanto alle presenze: il legame voce→persona lo fa l'anello, e si abbassa solo chi sta parlando, quindi il flusso si chiude senza etichette. Il nome per esteso vive nella scheda al tocco e nel **livello di accessibilità**, che non è una modalità separata né un TTS proprietario: ogni presenza è un elemento semantico con etichetta completa ("Lucia C., voce abbassata da te, sta parlando"), e i cambi di stato del palco sono annunci — sale, scende, entra, esce, abbassata, bloccata. L'anello è decorativo per lo screen reader; il suo significato vive nell'etichetta. È anche l'unico posto dove lo stato è testo, e quindi va tenuto aggiornato come codice di prodotto, non come metadato.

È anche la ragione per cui **i sottotitoli, quando esisteranno, non porteranno etichette**: l'attribuzione la fanno tinta e anello, non un nome davanti alla battuta. A differenza della televisione, qui un indicatore dal vivo di chi parla esiste già. Nella prima versione non esistono; quello che si tiene aperto è solo la fascia nell'ordine di cessione e l'unicità della tinta sul palco (Fase 2, 5i).

## 7.12 bis  La fascia testo ha due sorgenti, non una

Quando la fascia esisterà, il testo che ci compare avrà **due origini e un solo componente**: il riconoscimento della voce di chi parla, oppure il **testo digitato da un partecipante che non può o non vuole usare la propria voce**. Attribuzione, permanenza e regole sono identiche nei due casi — un blocco alla volta, tinta e anello di chi lo produce, permanenza ricavata dalla velocità di lettura, nessuna etichetta. Non si costruisce niente ora: serve solo che **l'ingresso testuale non diventi impossibile dopo**, come per la Loggia.

La distinzione che salva il §3, ed è precisa: il divieto riguarda **un canale testuale parallelo alla voce**, che competerebbe con essa — si scriverebbe mentre un altro parla, si leggerebbe invece di ascoltare, e resterebbe una cronologia. Il testo usato *al posto della propria voce*, da chi occupa un posto sul palco, non è un canale parallelo: **occupa lo stesso turno che occuperebbe parlando**, non scorre, non si risale, non lascia cronologia. Non aggiunge un canale, usa quello che c'è in un'altra forma.

Le condizioni perché resti vero sono tre, e sono le stesse che tengono in piedi i sottotitoli. **Il posto sul palco è la condizione d'accesso**: chi è nel pubblico non scrive, come non parla. **La fascia è unica e sequenziale**: scrivere non consente di sovrapporsi a chi sta parlando, perché due blocchi insieme non esistono. E **non esiste un campo di scrittura permanente a schermo**: si scrive quando è il proprio turno, non si tiene una tastiera aperta accanto alla conversazione — una casella sempre presente *sarebbe* il canale parallelo, come che la chiamiamo.

## 7.13  Il tocco su una presenza

Apre una **scheda breve, non una schermata profilo**: nome per esteso, stato, e tre azioni — *abbassa questa voce*, *blocca* (con la sua conseguenza scritta accanto), *segnala*. Nessun preferito, nessuna azione utente-utente, nessuna storia. La scheda esiste per dire chi è e per regolare cosa sento, poi si chiude. Fuori perimetro alpha: automoderazione, amministratore del DEN, follow, sottogruppi.

## 7.14  Intestazione della stanza

Nome del DEN e, nelle stanze pubbliche, il marcatore entra chiunque: è una previsione sociale — *chi può arrivare* — perché regola cosa dico, non un lucchetto. **Le stanze private non portano alcun marcatore**: l'assenza è l'informazione. La riga di stato del palco separa due livelli: il fatto della stanza ("5 sul palco") sopra, le mie preferenze ("per te: 1 abbassata, 1 bloccata") sotto e più deboli. Non si mescolano mai su una riga sola.

I marcatori restano due in elenco — entra chiunque e su invito — più rimosso sulla riga spenta. **Nessun marcatore nomina il trattamento della voce**: è una questione tecnica accettata alla registrazione e, come il trattamento dei dati, non si ridichiara a ogni conversazione. Una stanza non decide nessuna impostazione di chi entra.

## 7.15  Movimento: perché è così poco, e dove sta la specifica

**La specifica del movimento sta in un punto solo: *BA · Token*, T8.** Cosa si muove, per quanti millisecondi, con quale curva, cosa deve restare fermo, e cosa non può muoversi insieme a cos'altro. Le due tabelle che stavano qui e nel 7.15 bis sono state fuse là e questo paragrafo tiene solo le ragioni: due copie di una durata divergono al primo ritocco, e la copia sbagliata è sempre quella che qualcuno legge.

**Perché è poco.** Il rischio da evitare non è la batteria ma il throttling termico: quando il telefono scalda, la prima cosa che degrada è l'audio — l'unica non negoziabile. L'anello resta l'unico movimento continuo ammesso, perché è l'unico che porta un'informazione che cambia da sola.

**Perché l'arrivo di una persona non si celebra.** Nessun suono, nessun annuncio, nessuna animazione d'ingresso: le presenze compaiono e spariscono. Il solo effetto ammesso è il re-incastro, che è la conseguenza geometrica dell'arrivo, non la sua celebrazione.

**Perché la scala cambia per tutti insieme, chi parla compreso.** Una presenza più piccola delle altre, anche solo per qualche secondo, si legge come rango. Le soglie non si toccano: si governa la *frequenza* con cui si assesta, con l'attesa a conteggio fermo — il viavai produce un assestamento solo. Le alternative scartate (animare ogni ingresso, o cambiare scala a scatto) sono disegnate al §5g del documento di fase 2, con il motivo dello scarto.

Il ripiego senza movimento non è una versione ridotta di questo: è il 7.16, e comunica gli stessi stati.

## 7.16  Fallback statico di prima classe

Con movimento ridotto, screen reader attivo o degrado termico, gli stessi stati si comunicano senza alcun movimento: l'anello resta fermo sul valore alto (chi parla è l'unica presenza cerchiata), il glifo di chi è abbassato resta acceso mentre parla, il re-incastro diventa istantaneo. Nessuno stato dipende dall'animazione per esistere: l'animazione ne è la resa continua, non la definizione.

## Cosa resta aperto — e va deciso su un telefono vero

1.  **Il ritaglio delle sagome su volti reali.** Se taglia mento o fronte: asimmetria a ±5%, nessun raggio sotto 46%.
2.  **Il glifo di "abbassata che parla" a 375 pt e 20% di luminosità.** Se sparisce, si ingrandisce da 28 a 32 pt — non si colora: la tinta è occupata.
3.  **Il tetto di luminanza sulle immagini** provato su una foto molto chiara e una molto scura. Se una foto scura diventa illeggibile, il velo va calcolato sulla luminanza media dell'immagine: più codice, da sapere prima.
4.  **Otto persone su un 360 dp reale.** Tre a 88 in fila lasciano 4 dp di margine: se sul telefono l'anello del bordo esterno tocca comunque il vuoto laterale, il fondo scende a 86 — non si stringe la distanza fra i centri, che è ciò che protegge il segnale.
5.  **Il respiro dell'anello con campioni veri a 500 ms.** Un rilascio di 600 ms è calcolato, non visto: su rete instabile i campioni arrivano in ritardo e il respiro può risultare a scatti. Se accade, il rilascio sale (non scende), o il canale lento si spegne — il veloce resta e dice la stessa cosa.
6.  **Il DEN vuoto a 208 pt.** Una presenza sola molto grande può leggersi come generosa o come pomposa. È la schermata che vedrà quasi ogni tester.
7.  **Che lavoro resta al colore** (§8.5) quando le immagini diventano dominanti: sul palco la tinta perde il suo compito e sopravvive solo nel ripiego. Il candidato è la stanza, non la persona.
8.  **In v1 chi ha bisogno di leggere non ha niente.** Rinviare i sottotitoli è un costo, non un pareggio: va detto agli invitati dell'alpha, non scoperto dai loro silenzi. Da verificare che la fascia riservata (Fase 2, 5i) basti davvero ad accoglierli poi senza rifare la stanza.
9.  **L'effimero non ha più un segno visibile.** Rimossa la riga "non si registra", resta solo l'assenza di archivi: vera ma silenziosa. Da dire una volta, all'ingresso in stanza, non in permanenza.
