<!-- Copia di lettura generata da "BA - Stanza DEN.dc.html". Fa fede l'HTML esportato da Claude Design; i valori fanno fede in app/lib/design_system/tokens.dart. -->
Documento storico · Fase 1
Le schermate qui sotto sono la Fase 1 e non vengono aggiornate: valori, lessico ed etichette sono superati. Fa fede tokens.dart; le decisioni stanno in BA · §7 consolidato e i componenti in BA · Inventario componenti.
<div class="section">
BA · abbassare e bloccare
Due azioni, due stati, nessun anello
L'anello resta riservato alle voci che sto sentendo. Chi è abbassato mostra un altoparlante barrato che si accende quando parla — transizione discreta, non legata al livello. Chi è bloccato non ha alcun segnale di attività. In entrambi i casi l'identità resta leggibile e il posto resta occupato. Intestazione senza "non si registra"; le stanze private non portano marcatore.
4a
Viva — 2 voci, 1 abbassata che parla, 1 bloccata
21:40
Cucina di notte
entra chiunque
SL
MB
AH
DV
LC
5 sul palco
per te: 1 abbassata, 1 bloccata
14 in ascolto
Il tuo microfono è aperto
Scendi dal palco
Esci
4b
Scheda — abbassa, blocca, segnala
21:40
Cucina di notte
entra chiunque
SL
MB
DV
RK
AH
5 sul palco
per te: 1 bloccata
14 in ascolto
Il tuo microfono è aperto
Scendi dal palco
Esci
MB
Marta Bellini
sul palco · sta parlando
Abbassa questa voce
Blocca
Vale in ogni DEN e resta anche dopo. Resta finché non lo togli, dalle impostazioni.
Segnala
Chiudi
i quattro stati, a confronto
MB
in ascolto
MB
sta parlando
MB
abbassata, tace
MB
abbassata, parla
DV
bloccata
perché due canali diversi
Il glifo usa la stessa logica a doppio tratto dell'anello — casing scuro 5 px sotto la barra chiara 2 px — perché è l'unico canale che porta "abbassata sta parlando" e non deve fondersi col cono. Il marcatore vive solo sul palco: nelle bolle da 22 px del pubblico sarebbe sotto la soglia di leggibilità, quindi lì resta la sola desaturazione. L'anello dice "questa voce ti sta arrivando". Se l'avesse anche chi è abbassato, direbbe il falso — quindi l'attività di chi è abbassato passa su un canale separato: il glifo, che si accende e si spegne (opacità 0,45 → 1, 140 ms lineari) senza seguire l'ampiezza. Sono due informazioni diverse e ora hanno due forme diverse, non due intensità della stessa.
desaturazione, non annerimento
Abbassata: la tinta perde saturazione ma tiene la sua traccia (viola → \#4A3F4A→#332B33). Bloccata: neutro pieno (\#3D3B39→#2A2927) — a distanza di colpo d'occhio si distinguono per il glifo, da vicino anche per la tinta residua. Iniziali all'80% e al 70%: 5,2:1 e oltre, l'identità resta leggibile in entrambi.
un buco dichiarato
Via "non si registra", l'effimero (§8.3) non ha più un segno visibile: resta solo l'assenza di archivi, che è vera ma silenziosa. Da riempire altrove — una volta, all'ingresso in stanza, non in permanenza.
accessibilità, senza modalità
Nessuna vista alternativa e nessun TTS proprietario: ogni presenza è un elemento semantico con etichetta ("Lucia C., voce abbassata da te, sta parlando"), e i cambi di stato del palco sono annunci di cortesia — sale, scende, entra, esce, abbassata, bloccata. L'anello è decorativo per lo screen reader; il suo significato vive nell'etichetta.
<div class="section">
BA · rappresentazione della persona
Immagine, ripiego, e il segnale che non dipende dal vicino
Nessun nome visibile: il binding voce→persona lo fa l'anello. Le iniziali sono il ripiego, ed è il caso dominante dell'alpha — quindi [3a](#3a) è la schermata principale e [3b](#3b) la variante con immagine. [3c](#3c) è la scheda al tocco.
3a
Ripiego iniziali — principale
21:40non si registra
Cucina di notte
entra chiunque
SL
MB
AH
RK
LC
5 sul palco1 abbassata
14 in ascolto
Il tuo microfono è aperto
Scendi dal palco
Esci
3b
Con immagine — misto
21:40non si registra
Cucina di notte
entra chiunque
AH
RK
5 sul palco1 abbassata
14 in ascolto
Il tuo microfono è aperto
Scendi dal palco
Esci
trascina tre volti reali nelle tre sagome per verificare il ritaglio ↑
3c
Al tocco — scheda breve
21:40non si registra
Cucina di notte
entra chiunque
SL
MB
AH
RK
LC
Il tuo microfono è aperto
Scendi dal palco
Esci
MB
Marta Bellini
sul palco · sta parlando
Abbassa questa voce
Chiudi
Nome per esteso e una sola azione. Nessun preferito, nessuna azione utente-utente, nessuna storia: la scheda esiste per dire chi è e per abbassarlo, e si chiude.
anello a doppio tratto
Keyline scura 3 px adiacente alla sagoma (rgba(8,7,6,.92)), tratto chiaro 2 px sopra (\#F5F1EC): banda totale 5 px, entrambi i tratti sulla stessa sagoma scalata e sullo stesso inviluppo. Il segnale non dipende più da cosa c'è sotto o accanto.
distanza minima, ora è un token
Distanza fra i centri ≥ diametro + banda anello (5) + crescita al picco (4) + 8 di respiro = 20 px di luce fra le sagome. È il vincolo che tiene l'anello fuori dal vicino anche al picco d'escursione, quindi va nei token accanto alla scala, non nel layout.
tetto di luminanza sulle immagini
Velo piatto rgba(8,7,6,.34) dentro la sagoma: qualunque foto scende sotto luminanza ~0,34 e non abbaglia al buio. È un \`ColorFiltered\`, non un blur. Le persone restano nella metà bassa della scala anche con le immagini, come i dischi (§7). "Abbassata" con foto è lo stesso velo al 66%: il volto resta riconoscibile, l'energia cala.
ritaglio: da verificare con volti veri
Non lo verifico su un volto immaginato: in [3b](#3b) le tre sagome sono caselle in cui trascinare tre foto reali. Da guardare in particolare la sagoma con il raggio più asimmetrico (58%/42%): è quella che può tagliare mento o fronte. Se accade, l'asimmetria scende da ±8% a ±5% e la regola diventa "nessun raggio sotto il 46%".
i nomi esistono, non si vedono
Ogni presenza porta un'etichetta di accessibilità completa — "Marta Bellini, sul palco, sta parlando" / "Lucia C., voce abbassata da te" — che è anche l'unico posto dove lo stato è testo. Lo screen reader annuncia i cambi di stato del palco, non ogni campione d'ampiezza: l'anello è decorativo per VoiceOver, lo stato no.
<div class="section">
BA · direzione scelta · consolidamento
Impacchettamento adattivo, incastrato
Stessa schermata di [1c](#1c), tre correzioni strutturali: sfumature a una sola tinta su superfici e presenze, posizioni fuori griglia con le presenze che si sfiorano, e sagome a bolla — una diversa per posto. La scala resta del gruppo, non della persona.
2a
Stanza DEN — viva e vuota
21:40non si registra
Cucina di notte
entra chiunque
SL
MB
AH
RK
LC
5 sul palco1 abbassata
14 in ascolto
Il tuo microfono è aperto
Scendi dal palco
Esci
viva · 5 sul palco · 2 parlano · 14 in ascolto
21:40non si registra
Cucina di notte
entra chiunque
SL
solo tu
Il microfono è tuo. Se arriva qualcuno, arriva senza annunciarsi.
Resta e ti avviso
Invita qualcuno
Esci
vuota · solo io
sfumature, con il vincolo §7
Due stop della stessa tinta, 155°. Lo stop più chiaro sta comunque sotto luminanza 0,18 — indigo 0,118 · terracotta 0,120 · verde 0,134 · ocra 0,154 — quindi le iniziali bianche restano AA su tutta la palette. Superfici e pulsanti hanno una sfumatura verticale a bassa escursione, l'alone sotto il gruppo è un \`RadialGradient\`: nessuna ombra, nessun blur.
forma: bolla, non cerchio
Ogni presenza ha una sagoma appena diversa (raggi asimmetrici entro ±8% dal cerchio: abbastanza per non sembrare geometria, poco per non sembrare un'illustrazione). **La forma la assegna la stanza, come il colore** — cinque sagome in rotazione sui posti, non legate alla persona: altrimenti diventerebbe un tratto permanente, cioè identità accumulata. L'anello di chi parla è la stessa sagoma scalata, non un cerchio: segue il contorno.
al tocco
Premi una presenza nell'anteprima: cede di 5,5% e torna, 180 ms, curva con un filo di rimbalzo — la sagoma irregolare fa il resto, si legge come cedimento di una bolla. I vicini si scostano di ≤ 4 px e rientrano nello stesso tempo. È movimento *a richiesta*, quindi fuori dal budget continuo della §4: nessun assestamento perpetuo, che competerebbe con l'unico segnale che conta. Le dimensioni restano uguali fra le persone — diverse fra loro sarebbero rango (§2).
da approvare
Sono caduti i nomi sotto i dischi: erano ciò che impediva l'incastro. Le iniziali a 30 px restano l'identificatore (§7), e "abbassata" si legge dal disco composto verso lo sfondo più una riga di stato sotto il gruppo. Se i nomi devono tornare, i dischi tornano distanziati.
<div class="section">
BA · fase 1 · direzione
Tre disposizioni per la stanza DEN
Tema scuro. Palette, tipografia, spaziature, copy e quantità di interfaccia sono *identici* nelle tre: cambia solo dove stanno le persone sul palco. Ogni direzione in due stati — viva (5 sul palco, 2 che parlano insieme, 14 in ascolto) e vuota (solo io).
superfici
sfondo \#100F0E  
superficie \#191715  
hairline \#F2EEE9 @ 9%
testo
primario \#F2EEE9  
secondario \#A09890  
terziario \#8A837B
tipo
Instrument Sans 22/16/13/12  
IBM Plex Mono 11 (etichette)  
nessun peso oltre 600
spazio · raggi
4 · 8 · 12 · 20 · 32  
raggi 0 · 6 · 999 (mai 12–16)  
nessuna ombra, nessun blur
stato parla
anello, solo luminanza  
attacco 70 ms · rilascio 350 ms  
escursione compressa a più voci
1a
Griglia regolare
La posizione non porta significato, così l'unica cosa che cambia sullo schermo è chi parla: l'occhio impara otto caselle una volta e poi non deve più cercare.
21:40non si registra
Cucina di notte
entra chiunque
SL
Io
MB
Marta
RK
Ren
LC
abbassata
AH
Ahmed
14 in ascolto
Il tuo microfono è aperto
Scendi dal palco
Esci
viva · 5 sul palco · 2 parlano
21:40non si registra
Cucina di notte
entra chiunque
SL
Io
Il microfono è tuo. Se arriva qualcuno, arriva senza annunciarsi.
Resta e ti avviso
Invita qualcuno
Esci
vuota · solo io
Costo: a una sola persona la griglia mostra sette caselle non occupate, e il vuoto diventa misurabile. Le ho tenute (l'alternativa era nasconderle e perdere la prevedibilità) ma portate a opacità 5%: si leggono come limite del palco, non come assenze.
1b
Anello
Un cerchio non ha una prima posizione, quindi non può produrre un podio nemmeno per sbaglio; e libera il centro, il solo punto dove uno stato di stanza si legge senza essere cercato.
21:40non si registra
Cucina di notte
entra chiunque
2 parlano
5 sul palco
SL
Io
MB
Marta
RK
Ren
LC
abbassata
AH
Ahmed
14 in ascolto
Il tuo microfono è aperto
Scendi dal palco
Esci
viva · 5 sul palco · 2 parlano
21:40non si registra
Cucina di notte
entra chiunque
solo tu
SL
Io
Il microfono è tuo. Se arriva qualcuno, arriva senza annunciarsi.
Resta e ti avviso
Invita qualcuno
Esci
vuota · solo io
Nello stato vivo i posti liberi diventano punti da 6 px invece di cerchi: sono la geometria del palco, non sedie vuote. Nello stato vuoto tornano cerchi, perché con una persona sola servono a dire "c'è posto".
1c
Impacchettamento adattivo
Il palco non ha posti, solo persone: la scala dice quante sono prima che si contino, e a una sola persona non resta nessun buco da leggere.
21:40non si registra
Cucina di notte
entra chiunque
SL
Io
MB
Marta
RK
Ren
LC
abbassata
AH
Ahmed
14 in ascolto
Il tuo microfono è aperto
Scendi dal palco
Esci
viva · 5 sul palco · 2 parlano
21:40non si registra
Cucina di notte
entra chiunque
SL
Io
Il microfono è tuo. Se arriva qualcuno, arriva senza annunciarsi.
Resta e ti avviso
Invita qualcuno
Esci
vuota · solo io
Scala per numero di persone sul palco: 1 → 196, 2 → 148, 3–4 → 112, 5–6 → 88, 7–8 → 68 px. La scala è del gruppo, non dell'individuo: chi parla non diventa più grande, altrimenti la dimensione tornerebbe a essere rango.
il test dei 375 pt
Accendi *Prova occhiata* nei tweaks: porta le tre schermate a luminosità 20%. Restano visibili solo gli anelli e la conta — è la lettura che deve funzionare.
fallback statico
*Riduci il movimento* ferma gli anelli sul valore alto: chi parla resta l'unico avatar cerchiato. Nessuno stato dipende dall'animazione.
cosa non c'è
Nessun tempo trascorso, nessun conteggio cumulativo, nessuna mano alzata permanente, nessun badge. L'unica riga che nomina la registrazione la nega, e sta dove sta l'ora.
