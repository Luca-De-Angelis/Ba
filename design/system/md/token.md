<!-- Copia di lettura generata da "BA - Token.html". Fa fede l'HTML esportato da Claude Design; i valori fanno fede in app/lib/design_system/tokens.dart. -->
BA · brief di design · token
# I valori, estratti dalle schermate
La fonte di verità è **tokens.dart**. Questo documento dice **perché** quei valori sono quelli, e porta le regole d’uso che nessun valore può contenere.
Niente qui è stato inventato per completezza: ogni token ha almeno un impiego nella stanza (§7) o nelle altre superfici (fase 2), e la colonna *dove* lo dice. Un valore senza impiego non è un token, è un'ipotesi.
## T0  Gerarchia dei documenti — quale vince

Le stesse misure oggi compaiono in più file, e questo produce codice incoerente. Da qui in avanti:

|                            |                                  |                                                                                                                                   |
|----------------------------|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| tokens.dart                | **fonte di verità**              | ogni valore: colori, misure, durate, rapporti, più le regole che il codice può violare compilando. Se un numero esiste, esiste lì |
| BA · Token (questo)        | perché quei valori               | la motivazione di ogni token e le regole d’uso. I numeri qui sono **copie di lettura**                                            |
| BA · Inventario componenti | cosa costruire                   | widget, varianti, stati, e il comportamento con Dynamic Type                                                                      |
| BA · §7 consolidato        | decisioni sulla rappresentazione | perché una cosa è così, cosa è stato scartato                                                                                     |
| BA · Fase 2 schermate      | esplorazione                     | le schermate da cui i ruoli sono emersi. Niente qui è normativo                                                                   |

**In caso di divergenza vince tokens.dart**, senza discussione: i documenti si correggono. Chi scrive codice legge il file Dart e usa questi documenti per capire cosa non rompere. Chi cambia un valore lo cambia nel file per primo — se resta scritto solo in un documento, non è stato cambiato. **Il §4 del brief chiedeva questo**: non una tavola di colori, un file che si importa.

## T1  Come si legge

I nomi sono famiglia/ruolo, in italiano, e descrivono **il mestiere del valore, non il suo aspetto**: azione/chiara resta valido se domani è verde, sabbia no. Le tinte delle presenze fanno eccezione e sono numerate: non hanno un ruolo, sono dodici posti in un mazzo.

**Tema unico, scuro.** Non ci sono coppie chiaro/scuro: l'alpha ha un tema solo, quindi i token sono valori assoluti e non alias. Il giorno che serve un tema chiaro si aggiunge un livello sopra questo, non si riscrive.

## T2  Colore — fondali e superfici

| token               | valore                                                  | dove                                                 |
|---------------------|---------------------------------------------------------|------------------------------------------------------|
| fondo/app           | \#0A0A09                                                | elenco, impostazioni, accesso                        |
| fondo/stanza        | \#171413 → \#100F0E 52% → \#0B0A09                      | DEN, verticale: il palco sta nella parte più chiara  |
| fondo/alone         | radial closest-side 50% 42%, rgba(230,220,190,.055) → 0 | dietro il palco; unica sorgente di luce della stanza |
| superficie/foglio   | \#161412                                                | foglio del permesso negato, schede                   |
| superficie/sistema  | rgba(28,25,23,.86)                                      | card Live Activity, sopra lo sfondo del lock screen  |
| superficie/notifica | \#1A1917                                                | notifica Android (opaca per obbligo di sistema)      |
| superficie/isola    | \#000000                                                | Dynamic Island: nero vero, non il nostro fondo       |

## T3  Colore — testo, filetti, azione, errore

|                     |                                   |                                                                  |
|---------------------|-----------------------------------|------------------------------------------------------------------|
| testo/primo         | \#F2EEE9                          | nomi di stanza, frasi di BA, stato attivo                        |
| testo/secondo       | \#A09890                          | spiegazioni, azioni hairline, riga sotto il titolo               |
| testo/terzo         | \#8A837B                          | marcatori mono, contatori, orario                                |
| testo/spento        | \#6E6862                          | note di formato, "tocca per rientrare"                           |
| testo/inattivo      | \#5E5952                          | azione non disponibile (palco pieno, ingresso in corso)          |
| testo/su-tinta      | \#FFFFFF                          | iniziali sulle presenze; bianco pieno, non testo/primo           |
| testo/su-chiara     | \#100F0E                          | sopra azione/chiara                                              |
| filetto/appena      | rgba(242,238,233,.06)             | contorno di un'azione spenta                                     |
| filetto/base        | rgba(242,238,233,.10)             | azioni hairline, bordo dei telefoni, righe di elenco             |
| filetto/marcato     | rgba(242,238,233,.14)             | pillola dello stato del mio microfono                            |
| filetto/divisorio   | rgba(242,238,233,.12)             | separazioni fra blocchi, non fra controlli                       |
| azione/chiara       | \#D9CFA8 · pieno \#EDE7DC→#D2C9B6 | accesso, "Apri le impostazioni"; vedi T9                         |
| azione/attiva-bordo | rgba(217,207,168,.42)             | controllo acceso ma non urgente: avviso attivo, "Riprova adesso" |
| azione/attiva-fondo | \#302A25 → \#1F1A15               | riempimento della stessa pillola                                 |
| errore/testo        | \#E4705B                          | "La linea è caduta", "microfono negato"                          |
| errore/filetto      | rgba(228,112,91,.32)              | riquadro del messaggio; mai riempito                             |

**Due divieti che sono parte dei token.** errore esiste come testo e filetto e **non ha una variante riempita**: la palette contiene già due tinte rosse per le presenze, e una bolla rossa piena sarebbe una persona. Non esiste un token successo: quando una cosa riesce, la prova è che è successa.

## T4  Colore — la voce e gli stati della presenza

|                    |                             |                                                              |
|--------------------|-----------------------------|--------------------------------------------------------------|
| voce/keyline       | rgba(8,7,6,.92)             | tratto interno dell'anello: stacca dalla foto, non dal fondo |
| voce/tratto        | \#F5F1EC                    | tratto esterno, dentro l'app                                 |
| voce/tratto-fermo  | rgba(245,241,236,.34)       | linea instabile: c'è una voce, non ne conosco l'ampiezza     |
| voce/tratto-stanza | rgba(245,241,236,.55–.62)   | fuori dall'app l'anello sta sulla sagoma della stanza, fermo |
| presenza/abbassata | saturate(.25) · opacity .78 | microfono chiuso; il glifo si accende se parla lo stesso     |
| presenza/persa     | grayscale(1) · opacity .34  | linea caduta: "questa è l'ultima cosa che ho visto"          |
| presenza/dietro    | opacity .22 · blur 1,5      | stanza dietro un foglio aperto                               |

Le **dodici tinte delle presenze** (tinta/01…12, ognuna con il suo secondo stop più scuro) stanno nel §5p della fase 2 e non si ripetono qui: sono un mazzo, non una scala. Vale il corollario: **nessuna distinzione dell'app può dipendere dalla sola tinta**.

## T5  Tipografia

Due famiglie. **Instrument Sans** per tutto ciò che si legge come una frase; **IBM Plex Mono** solo per i marcatori — stato della stanza, conteggi, orari, etichette — sempre maiuscoletto con letter-spacing .06em. Il mono è il modo in cui l'app dice un fatto senza commentarlo.

| token           | valore                       | dove                                            |
|-----------------|------------------------------|-------------------------------------------------|
| testo/stanza    | 22 / 600 / -.012em           | nome del DEN in intestazione                    |
| testo/foglio    | 20 / 600 / -.015em / 1,25    | titolo di un foglio che chiede qualcosa         |
| testo/riga      | 18 / 600 / -.01em            | nome di stanza in elenco                        |
| testo/controllo | 16 / 500                     | pillola principale                              |
| testo/corpo     | 15 / 400 / 1,5               | le frasi di BA — l'unico posto dove l'app parla |
| testo/azione    | 14 / 400                     | azioni hairline in coppia                       |
| testo/minore    | 13 / 400 / 1,45              | seconda riga di una card, spiegazioni brevi     |
| mono/marcatore  | 11 / 400 / .06em / maiuscolo | "entra chiunque", "su invito", "8 sul palco"    |
| mono/nota       | 10 / 400 / .05em             | note di formato, unità, misure                  |

Sotto i 13 pt si scrive solo in mono e solo per fatti. **Le iniziali sulle presenze non sono in questa scala**: dipendono dal diametro della sagoma (T6), non dal ruolo del testo.

## T6  Presenza — diametri e iniziali

| token             | diametro     | iniziali     | dove                                                                                                   |
|-------------------|--------------|--------------|--------------------------------------------------------------------------------------------------------|
| presenza/sola     | 208          | 61           | una persona sul palco                                                                                  |
| presenza/xl       | 156          | 46           | due                                                                                                    |
| presenza/l        | 130          | 38           | tre e quattro                                                                                          |
| presenza/m        | 112          | 33           | cinque e sei                                                                                           |
| presenza/s        | 88           | 26           | sette e otto — **fondo della scala a testo normale**. Era 92: **88 è quanto entra in 360 dp** (T6 bis) |
| presenza/sistema  | 36 / 34 / 32 | 13 / 12 / 11 | lock screen, isola espansa, notifica Android                                                           |
| presenza/pubblico | 22           | —            | campione del pubblico: sagome mute, senza iniziali                                                     |

**La regola delle iniziali, con il suo dominio — le righe vanno lette insieme, la formula da sola è sbagliata:**

|                |                                            |                                                                                                                                                                             |
|----------------|--------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| app, d ≥ 32    | **iniziali = round(d × 0,295)**            | tutto il palco, **a qualunque scala**: da 208 fino al fondo della catena di cessione                                                                                        |
| sistema, 32–36 | **iniziali = round(d × 0,35)**             | superfici di sistema: a quella scala il testo deve reggere lo schermo bloccato e l'always-on, quindi cresce più della sagoma                                                |
| d \< 32        | **nessuna iniziale: resta la sola sagoma** | pubblico a 22 pt, marchio, sagome campione, e il fondo della scala a testo grande. Sotto i 32 pt due lettere non si leggono: disegnarle piccole è peggio che non disegnarle |

Il rapporto lo decide il **contesto, non il diametro**: a testo di sistema grande una presenza sul palco può stare a 34 pt, cioè esattamente alla misura del lock screen, e dedurre il rapporto dalla taglia farebbe *crescere* le iniziali mentre la sagoma si rimpicciolisce. Un solo rapporto per tutto il palco, quindi: le iniziali scendono con la bolla fino a sparire, e sono l'ultima cosa che cede prima delle sagome — che non cedono (Inventario, C6). Fuori dal dominio la funzione non restituisce una taglia minima: restituisce niente, e chi disegna non scrive. La distanza minima fra i centri resta quella del §7.6 (diametro + 17). L'anello aggiunge sempre 3 pt di keyline e 2 di tratto, a ogni scala: **non si assottiglia con la bolla**, o sparisce al fondo della scala.

## T6 bis  La baseline stretta è 360 dp

Il telefono più stretto che supportiamo è **Android a 360 dp**, non iPhone a 375 pt: la scala va verificata là, ed è dove è stata ricontrollata. Larghezza utile del palco 360 − 2×20 = 320. Una fila di *k* sagome chiede:

larghezza = (k − 1) × (d + 17) + d + 18  
i 18 sono anello (5) e crescita al picco (4) sui due bordi esterni

|                 |        |                                                                                                  |
|-----------------|--------|--------------------------------------------------------------------------------------------------|
| 7–8 · tre a 92  | 328 dp | **non sta**: mancano 8 dp, e l'anello del bordo esterno andrebbe tagliato                        |
| 7–8 · tre a 88  | 316 dp | **sta, con 4 dp di margine**. È il motivo per cui il fondo della scala è 88 e non 92             |
| 5–6 · due a 112 | 259 dp | sta larghissima; tre a 112 (388) non sta, e non serve                                            |
| 3–4 · due a 130 | 295 dp | sta                                                                                              |
| 2 · due a 156   | 347 dp | **non affiancate**: a 360 dp la coppia va in diagonale. Vincolo del packing, non una scala nuova |
| 1 · una a 208   | 226 dp | sta con 94 dp d'aria: la schermata che vedrà ogni tester non è quella a rischio                  |

**La formula è il vincolo, non la tabella.** L'impacchettamento deve rifiutare una fila che non ci sta invece di stringere la distanza fra i centri: sotto i 17 dp l'anello di chi parla entra nel vicino, ed è l'unico segnale che non può degradare. A otto persone e testo grande la catena di cessione fa il resto (Inventario, C6) — quella parte non cambia, perché a 32 dp otto sagome stanno in 150×150 su qualunque larghezza. **Da verificare su telefono**: otto a 88 su un 360 dp reale, che è il caso con soli 4 dp di margine.

## T7  Forma, spazio, controlli

|                    |                                   |                                                                      |
|--------------------|-----------------------------------|----------------------------------------------------------------------|
| sagoma/01…05       | 5 border-radius irregolari        | assegnate dalla stanza, non dalla persona (§7.3)                     |
| raggio/pillola     | 999                               | ogni controllo dell'app                                              |
| raggio/foglio      | 26                                | fogli che salgono dal basso                                          |
| raggio/card        | 22 · 24                           | Live Activity · notifica Android                                     |
| raggio/riquadro    | 14                                | messaggi di stato dentro la stanza                                   |
| passo              | 2 → 4 6 8 10 12 14 16 20 24 32 44 | scala a passo 2, non a passo 8: le card di sistema non ci starebbero |
| margine/schermo    | 20                                | lato di ogni schermata dell'app                                      |
| controllo/primario | h 56                              | stato del microfono, azione che chiede qualcosa                      |
| controllo/coppia   | h 48 · gap 10                     | le due azioni hairline in fondo                                      |
| controllo/sistema  | h 38 · h 34                       | azioni App Intent su lock screen · isola                             |

**Non esistono token di ombra né di elevazione.** Le superfici si distinguono per fondo e filetto: in una stanza al buio un'ombra è una macchia. L'unica profondità dell'app è l'alone dietro il palco.

## T7 bis  Tocco e focus

Questi non emergono da una schermata: emergono dal fatto che gli elementi sono toccabili. Valgono per **ogni** elemento interattivo, comprese le presenze — che sono il bersaglio più grande dell'app e anche il più facile da dimenticare, perché non somigliano a pulsanti.

|                        |                                             |                                                                                                                                                                                             |
|------------------------|---------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| tocco/area-minima      | 44 × 44                                     | sotto questa misura nessun bersaglio, mai. I controlli a 56 e 48 sono già oltre; il bersaglio di una presenza è la sua sagoma, quindi il fondo della scala (88) la copre con 44 dp d'avanzo |
| tocco/area-estesa      | +8 oltre il bordo visibile                  | le pillole in coppia: il dito arriva prima dell'occhio                                                                                                                                      |
| tocco/premuto          | fondo rgba(242,238,233,.06) · scala .98     | vale per pillole e righe di elenco. 90 ms all'andata, 140 al ritorno                                                                                                                        |
| tocco/premuto-presenza | keyline a rgba(8,7,6,1) · **nessuna scala** | sulle presenze la scala è occupata dall'assestamento e il contorno dall'anello: il premuto scurisce la keyline e basta                                                                      |
| focus/anello           | 2 pt azione/chiara · offset 3 pt · statico  | tastiera esterna e controllo interruttori                                                                                                                                                   |
| focus/anello-su-chiara | 2 pt \#100F0E · offset 3 pt                 | sopra un controllo già chiaro                                                                                                                                                               |

**Il focus non può somigliare alla voce.** L'anello di chi parla è bianco, doppio, aderente alla sagoma e in movimento; quello di focus è **color azione, singolo, staccato di 3 pt e immobile**. Sono le tre differenze che restano leggibili anche quando cadono sulla stessa bolla — e ci cadono, perché si può mettere a fuoco chi sta parlando.

**Il focus è sempre visibile quando esiste, anche al primo tocco di tastiera**: niente "solo se navighi da tastiera" deciso dal framework. Non anima mai, nemmeno con il movimento pieno: un anello che pulsa su un elemento a fuoco è rumore per chi lo sta usando proprio perché non vede bene.

## T8  Movimento — l'unica specifica

**Questo è il punto solo**: cosa si muove, per quanti millisecondi, con quale curva, cosa deve restare fermo, e cosa non può muoversi insieme a cos'altro. Le tabelle del §7.15 e del 7.15 bis sono state fuse qui e là restano le ragioni — un valore scritto in due posti divergerà, e la copia sbagliata è sempre quella che qualcuno legge. **L'anello sta su due canali, e i token seguono la divisione.** Il canale veloce è ActiveSpeakersChanged: l'anello compare (70 ms) e scompare (140 ms), ed è un fatto booleano che regge da solo tutto il significato — con il ripiego statico resta solo questo. Il canale lento è l'ampiezza campionata dall'SDK, **LiveKit, 500 ms di default**: è il respiro, cioè decorazione informata, non informazione. **Il rilascio del respiro non può essere più corto del campionamento** — con 350 ms su campioni a 500 l'anello si sgonfia fra un campione e l'altro e si rigonfia al successivo: un dente di sega alla frequenza di campionamento, visibile e scollegato dalla voce. Da qui i 600 ms, che lasciano margine al jitter. L'attacco a 70 ms resta, ma **vale solo per la comparsa**: sull'ampiezza non significa niente. Le curve sono due, più la lineare: curva/assestamento cubic-bezier(.22,.9,.25,1) per tutto ciò che si sposta o cambia scala, curva/scheda cubic-bezier(.34,1.2,.64,1) per ciò che appare sopra il resto. Se serve una terza curva, prima serve una ragione.

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td>voce/comparsa<br />
voce/scomparsa</td>
<td>70 ms · 140 ms</td>
<td><strong>canale veloce</strong>: l'anello c'è o non c'è, su <span>ActiveSpeakersChanged</span>. Regge da solo il significato</td>
</tr>
<tr class="even">
<td>voce/rilascio<br />
campionamento</td>
<td>600 ms · 500 ms</td>
<td><strong>canale lento</strong>: il respiro sull'ampiezza campionata dall'SDK. <strong>Il rilascio non può scendere sotto il campionamento</strong></td>
</tr>
<tr class="odd">
<td>stato/glifo</td>
<td>140 ms lineare</td>
<td>glifo dell'abbassata che si accende</td>
</tr>
<tr class="even">
<td>premuto</td>
<td>90 ms andata · 140 ritorno</td>
<td>ogni elemento toccabile (T7 bis): cede al 94,5% e torna, i vicini non si muovono</td>
</tr>
<tr class="odd">
<td>scheda</td>
<td>180 ms · curva/scheda</td>
<td>scheda breve di una presenza</td>
</tr>
<tr class="even">
<td>foglio</td>
<td>240 ms · curva/scheda</td>
<td>fogli che salgono dal basso: permesso negato, invito</td>
</tr>
<tr class="odd">
<td>assestamento</td>
<td>320 ms · curva/assestamento</td>
<td>tutte le presenze alla nuova scala, insieme — chi parla compreso; solo a ingresso/uscita, mai perpetuo</td>
</tr>
<tr class="even">
<td>ricompattamento</td>
<td>200 ms · curva/assestamento</td>
<td>il posto di chi esce si chiude subito, alla stessa scala</td>
</tr>
<tr class="odd">
<td>comparsa · sparizione</td>
<td>0 ms</td>
<td>le presenze non entrano e non escono: ci sono o non ci sono — e l'arrivato compare al suo posto <strong>alla scala corrente</strong>, mai più piccolo degli altri</td>
</tr>
<tr class="even">
<td>attesa/ingresso</td>
<td>4 s</td>
<td>conteggio fermo prima di assestare</td>
</tr>
<tr class="odd">
<td>attesa/uscita</td>
<td>6 s</td>
<td>ma il posto vuoto si chiude subito (200 ms). <strong>Eccezione: se resta una persona sola, 208 subito</strong> — non si aspetta a guardare un DEN vuoto</td>
</tr>
<tr class="even">
<td>attesa/skeleton</td>
<td>1,8 s · .30→.62 opacità</td>
<td>sagome vuote mentre entro</td>
</tr>
<tr class="odd">
<td>soglia/instabile</td>
<td>4 s</td>
<td>apertura che non si aggancia: si passa a "audio a scatti"</td>
</tr>
<tr class="even">
<td>soglia/persa</td>
<td>12 s</td>
<td>e poi a "la linea è caduta". Il caricamento non ha uno stato infinito</td>
</tr>
<tr class="odd">
<td>riprova/automatica</td>
<td>8 s</td>
<td>intervallo fra i tentativi di BA, dichiarato a schermo</td>
</tr>
<tr class="even">
<td>fascia/testo</td>
<td>0 ms · permanenza 17–20 car/s</td>
<td><strong>non in v1</strong> (§7.12 bis): il blocco compare e si sostituisce, non scivola; la permanenza minima si ricava dalla lettura, non dalla voce</td>
</tr>
<tr class="odd">
<td>tutto il resto</td>
<td>&lt; 200 ms, discreto</td>
<td>e senza effetti: nessun glow, nessuna ombra ampia, nessun blur, nessuno scorrimento animato</td>
</tr>
<tr class="even">
<td>ripiego/statico</td>
<td>0 ms, stesse regole</td>
<td>movimento ridotto, screen reader, degrado termico (§7.16)</td>
</tr>
</tbody>
</table>

Nessuna transizione di entrata o di uscita per le presenze: **compaiono e spariscono**. L'unico movimento che riguarda una persona è l'anello, e l'unico che riguarda la stanza è l'assestamento.

**Cosa deve restare fermo.** È metà della specifica, e quella che si perde per prima quando si aggiunge una schermata:

- **Il testo.** Non scorre, non si compone lettera per lettera, non si sposta mentre lo leggi, e nessun numero conta da solo. Vale anche per la fascia testo quando esisterà: il blocco c'è o non c'è.
- **I controlli.** Le azioni stanno ancorate in basso e non si spostano mai — né per fare posto a una fascia, né durante un assestamento.
- **Il palco mentre si parla.** Durante una conversazione l'unica cosa che si muove è l'anello: sagome, posizioni, tinte e scala restano dove sono.
- **Il fondo.** Sfondo, alone e filetti non animano, non pulsano, non respirano.
- **Il focus e il pubblico.** L'anello di focus non anima nemmeno a movimento pieno (T7); il campione di tre bolle non ruota.

**Mai due movimenti sopra i 140 ms nello stesso momento.** Se una scheda o un foglio è aperto, l'assestamento aspetta la chiusura: la stanza non si riorganizza sotto una cosa che sto leggendo. E **un solo assestamento in volo**: se ne parte un secondo, quello in corso non si accoda e non si somma — si interrompe e riparte dal punto dov'è, che è il caso che capita davvero con il viavai. Sono le due sole regole di concorrenza, e sostituiscono qualunque orchestrazione.

## T9  Regole d'uso che non sono valori

**1. Quando compare azione/chiara.** Solo dove **l'app non può proseguire senza un gesto dell'utente**, che nessun altro può fare al posto suo. Una per schermata: se ce ne fossero due, nessuna sarebbe la condizione. Tutto il resto è hairline.

**2. Nessuna informazione affidata al solo colore.** Chi parla è luminanza e movimento; abbassata e bloccata sono desaturazione più glifo; palco e pubblico sono dimensione e posizione.

**3. Nessun contatore che accumula** (§2): si mostrano fatti fermi — l'ora d'inizio, non i minuti trascorsi. Le memorie dichiarate sono tre e non aumentano: il blocco che dai, la rimozione che ricevi da un DEN — due gruppi, una schermata, lo stesso tempo sfocato — e il profilo derivato alla registrazione.

**4. Fuori dall'app l'anello cambia proprietario**: sta sulla stanza, fermo, e dice "qui si parla". Dentro l'app sta sulla persona e segue la voce.

**5. Il palco ha una dimensione sola per volta.** Nessuna presenza è più piccola di un'altra, in nessun momento della transizione: dimensioni diverse sono rango.

## T10  Note di implementazione

Non sono stime: sono i punti dove una scelta di design costa codice, e vanno visti prima di aprire l'editor. La colonna *costo* dice se si può rimandare.

| punto                         | costo                    | perché                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
|-------------------------------|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| livello audio per persona     | **vincolo di scelta**    | **risolto: LiveKit.** Dà ActiveSpeakersChanged (canale veloce) più l'ampiezza per partecipante a 500 ms (canale lento) — 2 Hz, non 10, e per questo il respiro ha un rilascio di 600 ms (T8). Un SDK che desse solo "chi parla" sì/no basterebbe comunque: sarebbe il solo canale veloce, che porta tutto il significato. **Quello che va verificato è il contrario**: che l'ampiezza sia per partecipante e non del mix, o il respiro non è attribuibile a nessuno |
| autorità su tinta e sagoma    | **basso ora, alto dopo** | se le assegna il client, due telefoni mostrano la stessa stanza con bolle diverse. Le assegna la stanza, cioè il server, e viaggiano con l'evento di ingresso                                                                                                                                                                                                                                                                                                       |
| niente da salvare             | **basso, ma vincola**    | l'unico dato durevole del client è l'elenco dei bloccati. Nessuna cache di presenze, nomi, stanze: l'effimero è un'architettura, non una schermata                                                                                                                                                                                                                                                                                                                  |
| impostazioni di accessibilità | **dovuto**               | movimento ridotto e screen reader si leggono dal sistema e spengono ogni animazione (T8). Il ripiego statico non è una modalità nostra: è quella del telefono                                                                                                                                                                                                                                                                                                       |
| focus e ordine di lettura     | **basso ora, alto dopo** | nodi di focus ed etichette vanno messi mentre si costruiscono i controlli. Aggiungerli a interfaccia finita costa più che scriverla                                                                                                                                                                                                                                                                                                                                 |
| Live Activity iOS             | **alto · rinviabile**    | estensione WidgetKit in Swift dentro Flutter, interfaccia duplicata, stato via App Group, azioni come App Intent. L'alpha vive anche senza                                                                                                                                                                                                                                                                                                                          |
| notifica Android              | **dovuto**               | un foreground service che tiene il microfono deve mostrarla, o il sistema lo chiude                                                                                                                                                                                                                                                                                                                                                                                 |
| degrado termico               | **medio · rinviabile**   | nessuna API affidabile: si osserva il frame rate e si scende al ripiego statico. Serve solo quando l'alpha durerà sessioni lunghe                                                                                                                                                                                                                                                                                                                                   |

## Cosa manca ancora

La **vibrazione** resta fuori, ed è l'unica assenza voluta: è la §8.4 del brief e merita un passaggio suo. In un'app dove la voce arriva a telefono in tasca, il tocco aptico è un canale di uscita vero — dire "è entrato qualcuno" senza accendere lo schermo — non la vibrazione di conferma di un pulsante. Deciderla insieme al resto la ridurrebbe a quello.

Da verificare su telefono vero, nell'ordine: il fondo della catena di cessione a scala 2,0 con otto persone (dove arriva la scala, e a che punto spariscono le iniziali), il glifo dell'abbassata a 28 pt, l'anello di focus accanto a quello della voce sulla stessa bolla, l'assestamento a 320 ms con debounce 4 s, e la leggibilità di errore/testo \#E4705B sopra fondo/stanza al buio.
