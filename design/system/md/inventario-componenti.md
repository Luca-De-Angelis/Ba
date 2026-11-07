<!-- Copia di lettura generata da "BA - Inventario componenti.html". Fa fede l'HTML esportato da Claude Design; i valori fanno fede in app/lib/design_system/tokens.dart. -->
BA · brief di design · inventario
# I componenti da costruire, con i loro stati
La fonte di verità per i valori è **tokens.dart**. Qui non compaiono numeri se non come conseguenza: ogni cella cita il token per nome.
## C0  Come si legge

Venti widget Flutter (C1–C4), lo scaffold BaSchermata che porta il posto unico della richiesta (C8), più tre superfici che Flutter non disegna (C5). La regola per aggiungerne uno: **deve comparire in due schermate diverse con lo stesso comportamento**, altrimenti è una composizione locale e resta dov'è. La colonna *stati* è vincolante: uno stato che non è in tabella non esiste, e uno che c'è va disegnato prima di dire che il componente è finito.

Tre stati valgono **per ogni componente toccabile** e non si ripetono riga per riga: premuto, a fuoco, inattivo. Li porta BaTouchable, che è il primo widget da scrivere.

## C1  La presenza e il palco

| widget     | varianti                                            | stati                                                                                              | token                                                                |
|------------|-----------------------------------------------------|----------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|
| BaPresenza | palco (sola…s) · sistema · pubblico (muta)          | ferma · parla · abbassata · abbassata che parla · bloccata · persa · scheletro · premuta · a fuoco | BaPresenza.\* · BaSagoma · BaTinta · BaColor.voce\*                  |
| BaRitratto | immagine · iniziali · sagoma nuda                   | in carico · caricata · fallita (→ iniziali) · assente (→ iniziali)                                 | BaPresenza.iniziali · BaTesto.iniziali                               |
| BaAnello   | voce (doppio tratto) · fermo · sulla stanza · focus | a riposo · inviluppo · fermo per linea instabile · statico da ripiego                              | anelloKeyline · anelloTratto · voceAttacco/Rilascio                  |
| BaPalco    | 1 · 2 · 3–4 · 5–6 · 7–8 · pieno                     | vuoto (attesa) · scheletro · vivo · in assestamento · in ricompattamento · congelato (linea persa) | diametro() · distanzaMinima() · assestamento · attesaIngresso/Uscita |
| BaPubblico | campione + contatore                                | nessuno (non si disegna) · 1–3 · oltre 3 (campione fisso)                                          | BaPresenza.pubblico · BaTesto.marcatore                              |

**BaPalco riceve una scatola, non una dimensione.** Calcola la scala dal numero di presenze *e* dallo spazio che avanza (C6): è l'unico punto dell'app dove un layout decide una misura, e per questo è l'unico che va testato con il testo di sistema al massimo. **Esiste in un'implementazione sola, in Dart**, perché nessun'altra superficie impacchetta: le card di sistema allineano le sagome in fila (C5), quindi non c'è geometria da ricalcolare in Swift né da serializzare nel payload.

## C2  Struttura della stanza

|                |                                                                           |                                                                                                                                                  |                                         |
|----------------|---------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|
| BaIntestazione | pubblica · su invito                                                      | viva · in ingresso · disconnessa (nome e marcatore spenti)                                                                                       | BaTesto.stanza · marcatore · testoTerzo |
| BaMarcatore    | stanza · conteggio · orario                                               | unico stato: è un fatto                                                                                                                          | BaTesto.marcatore · testoTerzo          |
| BaRigaStato    | fatti della stanza (sopra) · preferenze mie (sotto)                       | le due righe sono indipendenti e possono essere vuote separatamente                                                                              | BaSpazio.sm · marcatore                 |
| BaFasciaTesto  | unica · due sorgenti (voce riconosciuta · testo digitato) · **non in v1** | assente (in v1 la fascia esiste solo nell'ordine di cessione, a quota zero) · futuri: un blocco · accavallamento dichiarato. **Mai due blocchi** | BaPresenza (pubblico) · BaTesto.riga    |
| BaAlone        | unico                                                                     | acceso · spento (linea persa, ingresso)                                                                                                          | BaColor.fondoAlone                      |

## C3  Controlli e messaggi

|                  |                                                   |                                                                                                 |                                                            |
|------------------|---------------------------------------------------|-------------------------------------------------------------------------------------------------|------------------------------------------------------------|
| BaTouchable      | standard · su presenza                            | a riposo · premuto · a fuoco · inattivo. Su presenza il premuto scurisce la keyline e non scala | premutoVelo · premutoKeyline · focus\* · areaMinima/Estesa |
| BaPillola        | informativa · attiva · chiara · spenta            | \+ i tre comuni. "Chiara" solo dove l'app non prosegue senza un gesto (BaRegole 1)              | BaControllo.primario · azione\* · filettoMarcato           |
| BaAzioniInCoppia | due hairline · una sola (centrata)                | \+ i tre comuni, indipendenti fra le due                                                        | BaControllo.coppia · gapCoppia · filettoBase               |
| BaMessaggio      | neutro · errore                                   | assente · presente. Uno solo per schermata; l'errore non si riempie mai                         | BaRaggio.riquadro · errore\* · filettoBase                 |
| BaFoglio         | richiesta (permesso) · scheda presenza · invito   | chiuso · in salita · aperto · con contenuto più alto dello schermo (scorre)                     | BaRaggio.foglio · superficieFoglio · movimento.foglio      |
| BaGlifo          | microfono barrato (abbassata) · bloccata · negato | spento · acceso (parla da abbassata) · in errore                                                | movimento.glifo · erroreTesto                              |

Le altezze dei controlli in tokens.dart sono **minimi, non misure**: il contenuto può alzarli, mai abbassarli. È la condizione perché il testo grande non tronchi (C6).

## C4  Elenco e impostazioni

|                    |                                                                |                                                                                                                                                           |                                        |
|--------------------|----------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|
| BaRigaDen          | viva · spenta · su invito · rimosso                            | con campione di presenze · con sagoma vuota (spenta) · con anello su chi parla · premuta · a fuoco · **inerte** (rimosso: né premuta né a fuoco)          | BaTesto.riga · marcatore · filettoBase |
| BaRigaImpostazione | interruttore · valore · azione · conseguenza (permesso negato) | acceso · spento · negato dal sistema (con via d'uscita) · + i tre comuni. **Nessuno stato "deciso dalla stanza"**: un DEN non impone nessuna impostazione | BaTesto.minore · filettoDivisorio      |
| BaRigaBloccata     | **dato da te** · **ricevuto** (un DEN, non una persona)        | bloccata · sblocco in corso · sbloccata (esce dall'elenco) · ricevuto: **nessuna azione**, sagoma vuota al posto della presenza                           | BaPresenza (neutra) · BaGlifo          |
| BaCampoCodice      | accesso · invito                                               | vuoto · in scrittura · in verifica · rifiutato (errore) · scaduto                                                                                         | azioneChiara · erroreTesto             |

## C5  Superfici di sistema

|                   |                                          |                                                              |                                                    |
|-------------------|------------------------------------------|--------------------------------------------------------------|----------------------------------------------------|
| BaCardLive        | informativa · con azioni · dopo il tocco | stanza viva · io con microfono chiuso · stanza finita (coda) | superficieSistema · voceTrattoStanza · sistemaLock |
| BaIsola           | compatta · minimal · espansa             | viva · con azioni (App Intent)                               | superficieIsola · voceTrattoStanzaTenue            |
| BaNotificaAndroid | unica (obbligatoria)                     | viva · microfono chiuso. Non anima, per costruzione          | superficieNotifica                                 |

Questi tre **non sono widget Flutter**: sono SwiftUI e RemoteViews. Vivono nell'inventario perché gli stati vanno decisi qui, ma il codice sta altrove e va scritto due volte.

**Fuori dall'app non si impacchetta: si allinea.** Le sagome stanno in fila, al massimo quattro, con il contatore che porta il resto — dentro 144 pt di altezza l'impacchettamento non avrebbe spazio per esistere. Ne segue che BaPalco non serve mai fuori da Flutter e **non c'è geometria da serializzare**: BaPayloadStanza porta nome, conteggio, ora d'inizio, tinte e iniziali, e nient'altro. **La sagoma della stanza è statica** — sempre BaSagoma.mazzo\[0\], con l'anello fermo — quindi nemmeno lei è una geometria da calcolare in due posti.

## C6  Dynamic Type — cosa scala e cosa cede

La domanda giusta non è se il layout regge il testo grande, ma **chi cede quando i due si contendono lo schermo**. La risposta è: cede il palco. E può cedere senza rompersi perché non è geometria fissa — è una scala calcolata su una scatola, e la scatola è ciò che avanza dopo il testo.

| cosa                    | scala?       | perché                                                                                                                                                                                                  |
|-------------------------|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| frasi, titoli, azioni   | sì · ≤ 2,0   | è testo da leggere: se non scala, il resto non ha senso                                                                                                                                                 |
| marcatori mono          | sì · ≤ 1,6   | stanno accanto a numeri e a sagome: oltre 1,6 diventano titoli                                                                                                                                          |
| altezza dei controlli   | sì           | 56 e 48 sono minimi: il contenuto li alza, il testo non si tronca mai                                                                                                                                   |
| iniziali sulle presenze | no · cedono  | derivano dal diametro: sono un ritratto, non una parola. Ingrandirle le farebbe uscire dalla sagoma. Sono l'**ultima cosa che cede**: si rimpiccioliscono con la bolla e sotto i 32 pt non si disegnano |
| anello, focus, filetti  | no           | sono segni, non testo; a spessore doppio l'anello diventa un bordo                                                                                                                                      |
| spazi e margini         | no           | scalarli raddoppierebbe il consumo di schermo senza aggiungere leggibilità                                                                                                                              |
| diametro delle presenze | al contrario | si **riduce** quando il testo cresce: è il palco che paga                                                                                                                                               |

**Ordine di cessione, quando lo spazio non basta.** Primo: l'alone e i margini verticali del palco. Secondo: la scala delle presenze, da 208 giù fino a 92. Terzo: **le iniziali** — sotto i 92 continuano a rimpicciolirsi con la bolla, e a 32 pt escono dal dominio e non si disegnano più. Resta la forma colorata, che porta comunque presenza, tinta e anello.

**Le sagome non cedono mai.** Nessuna presenza passa al contatore per fare spazio, nessuno scambia posto, nessuna priorità da calcolare, nessuna contesa: **chi è sul palco è a schermo**. Il fondo della scala — 88 dp da quando è stato ricontrollato a 360 dp — era un fondo solo perché era il minimo leggibile *con le iniziali dentro* — toltele, la scala prosegue, e non serve un secondo meccanismo. È la regola che l'app ha già: non si cede una sagoma, si cede quello che ci sta sopra.

**Perché la catena basta.** Otto sagome a 32 dp, con i 17 dp di respiro fra i centri, stanno in circa 150×150 dp: meno di quanto avanzi sotto il testo a scala 2,0 sul telefono più stretto che supportiamo, che è **360 dp di Android** e non 375 pt di iPhone (T6 bis). Il caso che rompeva non si raggiunge — e un caso che non si raggiunge non ha bisogno di essere governato. Il problema era lo spazio di disegno, non chi meritasse di stare a schermo.

**Il rapporto delle iniziali lo decide il contesto, non la taglia.** A scala 2,0 una presenza sul palco può trovarsi a 34 pt, cioè alla misura del lock screen: se il rapporto si deducesse dal diametro, le iniziali *crescerebbero* mentre la bolla si rimpicciolisce. Sul palco vale 0,295 a ogni scala; lo 0,35 è delle superfici di sistema e solo loro lo chiedono (T6).

**Quello che non succede mai:** il testo non si comprime, le frasi di BA non si troncano, **nessuna sagoma sparisce**, e il numero di persone sul palco resta scritto in ogni caso. **Il dato non sparisce mai con la sua figura** — e qui la figura non sparisce affatto.

**Sulle superfici di sistema non decidiamo noi.** L'altezza è fissa (144 e 160) e il testo scala lo stesso: lì cadono prima le sagome — quattro diventano due, poi zero — e resta la riga di testo, perché una card di sistema *è* testo. **Da verificare su telefono**: otto persone su un 360 dp reale — prima a testo normale, dove il margine è di soli 4 dp, poi a scala 2,0 per leggere il fondo della catena e vedere se le iniziali spariscono prima o dopo di quanto dice il conto.

## C7  Note di implementazione, per componente

Le note generali stanno in *BA · Token*, T10; le durate e tutto il movimento in T8, che è l'unica specifica. Qui solo quello che appartiene a un widget preciso — come si costruisce (C7) e cosa si può spedire non fatto (C7 bis).

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr class="odd">
<td>BaPalco</td>
<td>l'impacchettamento va scritto come funzione pura <em>(conteggio, scatola) → posizioni + diametro</em>, senza stato: è l'unico modo per verificarlo con dei test invece che a occhio. Non esiste una seconda implementazione da tenere allineata (C5)</td>
</tr>
<tr class="even">
<td>BaAnello</td>
<td><strong>due sorgenti, due controller</strong>: <span>ActiveSpeakersChanged</span> accende e spegne (canale veloce), l'ampiezza campionata dall'SDK a 500 ms fa respirare (canale lento). Un solo controller per presenza per canale, mai ricostruito a ogni evento — e il rilascio del respiro ≥ 500 ms, o si vede il dente di sega. Il livello locale si ricampiona a 500 ms come gli altri: la stessa forma non può avere due comportamenti</td>
</tr>
<tr class="odd">
<td>BaPresenza</td>
<td>tinta e sagoma arrivano dall'evento di ingresso, non si calcolano dall'id: due telefoni devono vedere la stessa stanza</td>
</tr>
<tr class="even">
<td>BaTouchable</td>
<td>nodi di focus e ordine di lettura si mettono qui una volta sola. L'ordine è: intestazione → presenze in ordine di impacchettamento → stato → controlli</td>
</tr>
<tr class="odd">
<td>BaPresenza<br />
<span>accessibilità</span></td>
<td>l'etichetta per lo screen reader è "<em>nome</em>, sta parlando / microfono chiuso": le iniziali non sono la rappresentazione accessibile, sono un ripiego visivo</td>
</tr>
<tr class="even">
<td>BaFoglio</td>
<td>a testo grande diventa più alto dello schermo: deve scorrere fin dal primo giorno, non quando qualcuno se ne accorge</td>
</tr>
<tr class="odd">
<td>BaFasciaTesto</td>
<td><strong>non si costruisce in v1</strong>: della fascia esiste solo la posizione nell'ordine di cessione, a quota zero, perché inserirla dopo in un impacchettamento che non la prevede vuol dire rifare la stanza. Quando si farà, il riconoscimento sta <strong>sul telefono</strong>, per flusso separato di ogni partecipante — attribuire un blocco alla sagoma giusta richiede lo stesso audio per persona che serve all'anello (T10) — e un blocco alla volta, mai due</td>
</tr>
<tr class="even">
<td>BaCardLive</td>
<td>gli stati qui sono tre, ma il codice è SwiftUI: ogni stato aggiunto costa il doppio. È il motivo per cui sono tre</td>
</tr>
</tbody>
</table>

## C7 bis  Essenziale e rifinitura, per componente

La colonna di destra non è un elenco di cose brutte: è quello che si può **spedire non fatto** senza che la prima versione dica una cosa falsa. Serve perché il modo tipico in cui una v1 si blocca non è un componente difficile, è una rifinitura trattata come requisito. **Se il tempo finisce, si taglia da destra**, in qualunque ordine, senza chiedere.

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>widget</th>
<th>essenziale — senza questo non si spedisce</th>
<th>rifinitura sacrificabile</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>BaPresenza</td>
<td>sagoma con ritratto o iniziali, tetto di luminanza, e lo stato leggibile in entrambe le varianti</td>
<td>le cinque sagome del repertorio — in alpha ne basta una — e il ritaglio ottimizzato sui volti</td>
</tr>
<tr class="even">
<td>BaRitratto</td>
<td>iniziali su tinta al rapporto 0,295: in alpha è il caso dominante</td>
<td>l'immagine scelta e il velo calcolato sulla luminanza media (basta il velo piatto)</td>
</tr>
<tr class="odd">
<td>BaAnello</td>
<td>c'è o non c'è: chi parla è l'unica presenza cerchiata, a doppio tratto</td>
<td>il canale lento, cioè il respiro sull'ampiezza. Il canale veloce (compare/scompare) porta tutto il significato: un anello fermo dice già chi parla — è esattamente il ripiego statico</td>
</tr>
<tr class="even">
<td>BaPalco</td>
<td>la funzione pura <em>(conteggio, scatola) → posizioni + diametro</em> con i suoi test, e tutte le presenze a schermo</td>
<td>l'irregolarità dell'impacchettamento: una disposizione fissa per conteggio regge l'alpha. E l'assestamento animato</td>
</tr>
<tr class="odd">
<td>BaPubblico</td>
<td>il numero</td>
<td>il campione di tre bolle</td>
</tr>
<tr class="even">
<td>BaIntestazione</td>
<td>il nome del DEN</td>
<td>il marcatore in intestazione e l'ora d'inizio: sono già in elenco</td>
</tr>
<tr class="odd">
<td>BaMarcatore</td>
<td><span>entra chiunque</span> e <span>su invito</span> in elenco</td>
<td>la variante conteggio e la variante orario</td>
</tr>
<tr class="even">
<td>BaRigaStato</td>
<td>il fatto della stanza ("3 sul palco")</td>
<td>la seconda riga con le mie preferenze: la stessa cosa si legge nella scheda al tocco</td>
</tr>
<tr class="odd">
<td>BaFasciaTesto</td>
<td><strong>niente</strong>: in v1 esiste solo la sua posizione nell'ordine di cessione</td>
<td>tutto — sorgenti, permanenza, accavallamento (§7.12 bis). È il componente interamente rinviato</td>
</tr>
<tr class="even">
<td>BaAlone</td>
<td>acceso e spento, perché porta la linea persa</td>
<td>la sfumatura: un fondo piatto dice la stessa cosa</td>
</tr>
<tr class="odd">
<td>BaTouchable</td>
<td>area minima 44, nodo di focus, ordine di lettura. <strong>Va per primo</strong>: tutto il resto lo eredita</td>
<td>il premuto a 94,5% con la sua curva</td>
</tr>
<tr class="even">
<td>BaPillola</td>
<td>informativa e chiara, con la regola dell'una sola per schermata</td>
<td>gli stati attiva e spenta come varianti disegnate: l'opacità basta</td>
</tr>
<tr class="odd">
<td>BaAzioniInCoppia</td>
<td>due hairline affiancate, con l'area estesa</td>
<td>la variante a una sola azione centrata</td>
</tr>
<tr class="even">
<td>BaMessaggio</td>
<td>neutro ed errore, uno per schermata</td>
<td>la distinzione tipografica fra i due: il testo d'errore in colore basta</td>
</tr>
<tr class="odd">
<td>BaFoglio</td>
<td>si apre e <strong>scorre a testo grande</strong>, dal primo giorno</td>
<td>la curva d'apertura: 240 ms o 0 ms cambiano poco</td>
</tr>
<tr class="even">
<td>BaGlifo</td>
<td>microfono barrato e bloccata, a due tratti come l'anello</td>
<td>lo stato in errore e l'accensione a 140 ms</td>
</tr>
<tr class="odd">
<td>BaRigaDen</td>
<td>viva, spenta, e <strong>rimosso inerte</strong> — una porta chiusa non si preme</td>
<td>il campione di presenze nella riga, e l'anello su chi parla dentro l'elenco</td>
</tr>
<tr class="even">
<td>BaRigaImpostazione</td>
<td>interruttore, valore, e azione con la conseguenza scritta per i permessi negati</td>
<td>l'animazione dell'interruttore</td>
</tr>
<tr class="odd">
<td>BaRigaBloccata</td>
<td>i due gruppi asimmetrici — dati da te con <em>Sblocca</em>, ricevuti senza azioni</td>
<td>la data sfocata ("in aprile"): utile, non necessaria al primo giro</td>
</tr>
<tr class="even">
<td>BaCampoCodice</td>
<td>vuoto, in scrittura, rifiutato</td>
<td>gli stati in verifica e scaduto come stati a sé: in alpha un errore solo basta</td>
</tr>
<tr class="odd">
<td>BaCardLive · BaIsola<br />
BaNotificaAndroid</td>
<td>solo <span>BaNotificaAndroid</span>, perché il sistema la impone a un'app che tiene il microfono aperto</td>
<td>tutto il resto delle superfici di sistema: si costruiscono per ultime e solo se l'alpha regge senza (vedi <em>Ordine in cui costruirli</em>)</td>
</tr>
</tbody>
</table>

Due avvertenze sul taglio. **Non si taglia mai uno stato, solo la sua resa**: un anello fermo va bene, un anello assente no — e questo vale già come ripiego statico (T8), quindi non è codice in più. E **non si taglia niente in BaTouchable**: area minima, focus e ordine di lettura non sono rifinitura, e recuperarli dopo costa più che farli.

## C8  Regole che diventano irrappresentabili

Una regola documentata si viola per distrazione; una regola senza strumento per violarla, no. Sette delle otto BaRegole si possono togliere dal terreno delle buone intenzioni — cinque nel file dei token, due nella forma dei widget. La colonna *come* è la specifica: chi costruisce il widget deve renderla vera.

| regola                                                 | come si rende impossibile                                                                                                                                                                                                                                                                   |
|--------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1 · una sola azione chiara, e solo dove serve un gesto | BaSchermata ha **un solo posto** per la richiesta, e lo accetta soltanto con il motivo che la giustifica. Due richieste non stanno in un posto solo, e una richiesta senza motivo non si costruisce                                                                                         |
| 2 · niente informazione dalla sola tinta               | **Resta convenzione.** Si può obbligare BaPresenza a disegnare il glifo per abbassata e bloccata — quello sì — ma nessun tipo impedisce a una funzione futura di appoggiarsi al colore. Va guardata in revisione                                                                            |
| 3 · nessun contatore che accumula                      | BaOra.hhmm è l'unico formattatore di tempo dell'app. Non esiste una funzione che trasformi una durata in testo, e il modello della stanza porta l'ora d'inizio, non i minuti                                                                                                                |
| 4 · l'anello sulla stanza fuori dall'app               | BaPayloadStanza **non ha un campo "chi parla"**. La superficie di sistema non può disegnare un anello su una persona perché non sa chi sia                                                                                                                                                  |
| 5 · una dimensione sola per volta                      | BaPresenza **non prende un diametro**: lo eredita dal palco che la contiene. Due misure diverse nello stesso palco non sono esprimibili; una presenza fuori dal palco non si costruisce                                                                                                     |
| 6 · errore senza riempimento, nessun successo          | i token che servirebbero non esistono: nessun erroreFondo, nessun colore "successo". Il riempimento rosso va inventato a mano, e in revisione si vede                                                                                                                                       |
| 7 · nessuna ombra, nessuna elevazione                  | l'app **non importa material.dart**. Senza Material non ci sono Card, elevation, InkWell: l'ombra non è vietata, è assente                                                                                                                                                                  |
| 8 · le sagome non cedono mai                           | il palco **non ha un parametro “quante disegnarne”**: prende le persone sul palco e le disegna tutte. Le iniziali le dà il dominio di BaPresenza.iniziali — fuori da quello la funzione restituisce null e non esiste uno stile di ripiego, quindi nessuno può forzarle a una taglia minima |

Il costo di tutto questo è qualche costruttore più rigido del necessario, ed è il punto: **le regole che restano scritte solo in un documento sono quelle che si rompono al terzo mese**, quando chi le ha scritte non è più nella stanza.

## Ordine in cui costruirli

**BaTouchable** (porta premuto, focus, area minima a tutto il resto) → **BaPresenza** con **BaRitratto** e **BaAnello** → **BaPalco** come funzione pura, con i suoi test → i controlli → l'elenco → le impostazioni → le superfici di sistema, per ultime e solo se l'alpha regge senza.

Il primo schermo che dimostra che il sistema funziona non è la stanza piena: è **la stanza vuota con una persona sola**. Se 208 pt, un anello e una frase di BA reggono su un telefono vero, il resto è aritmetica.
