<!-- Copia di lettura generata da "BA - Fase 2 schermate.dc.html". Fa fede l'HTML esportato da Claude Design; i valori fanno fede in app/lib/design_system/tokens.dart. -->

<div class="section">
BA · fase 2 · le altre superfici
Accesso, elenco, attesa, impostazioni, e la superficie più guardata
Documento di esplorazione: nessun valore qui è normativo. La fonte di verità per misure, colori e durate è **tokens.dart**.
Prima le schermate, poi i token: i ruoli semantici devono emergere da qui invece di essere previsti. Stessa direzione della stanza — impacchettamento, sagome a bolla, sfumature a una tinta. La Live Activity è progettata dentro i formati di sistema, non come superficie libera.
5p
Palette chiusa — 12 tinte
le quattro nuove chiudono il caso palco pieno
\#5257AC  
L 0,118
\#A83E2E  
L 0,120
\#23735A  
L 0,134
\#96621A  
L 0,154
\#2A6894  
L 0,131
\#AC3765  
L 0,124
\#557426  
L 0,151
\#7A3080  
L 0,092
\#1C6E75  
L 0,129 · nuova
\#9B4A6E  
L 0,130 · nuova
\#8A4A2A  
L 0,106 · nuova
\#3F7A34  
L 0,153 · nuova
**Regola di assegnazione, per esteso.** Il DEN assegna a ciascuno una tinta libera fra le 12 al momento dell'ingresso, e la tinta vale finché resti. **L'unicità è garantita sul palco** — al massimo 8 presenze su 12 tinte, quindi nessuna collisione è possibile fra le voci che si sentono. **Il pubblico può ripetere**: da nove persone in su le tinte si riusano, perché nel pubblico la tinta non identifica nessuno (non c'è voce da attribuire) e serve solo a dire "sono persone diverse". Chi sale sul palco riceve, se necessario, una tinta libera al momento della salita: la promozione può cambiare tinta, e non è un problema — la tinta è effimera per costruzione.
**Corollario, e vale come divieto.** Dodici tinte tenute dentro L 0,09–0,16 sono poco distinguibili fra loro a 22 pt e al buio: vanno bene per accompagnare le iniziali, non per portare informazione. **Nessuna distinzione dell'app può dipendere dal solo colore** — chi parla è luminanza e movimento, voce mutata e bloccata sono desaturazione più glifo, il palco si distingue dal pubblico per dimensione e posizione. Se una futura funzione ha bisogno di essere letta a colpo d'occhio, il canale non è la tinta.
5a
Accesso — dal numero all'elenco
Un'azione chiara per schermata. I due consensi sono due schermate e due controlli. Nessun codice di invito e nessuna email.
5a.1 · NUMERO
21:40
Il tuo numero
Numero di telefono
+39347 120 4821
Ricevi il codice
Con verifica tramite operatore cambia solo l'etichetta dell'azione: "Continua".
5a.2 · CODICE SMS · RIMOVIBILE
21:40
Il codice
Mandato al +39 ••• ••• 4821.
4
8
1
Mandalo di nuovo
Conferma
Se l'operatore verifica il numero, questa schermata non c'è: 5a.1 porta a 5a.3 con "Continua". Nessun'altra schermata dipende da questa.
5a.3 · ONBOARDING · PRIMO ACCESSO
21:41
Prima di entrare
Nessuna conversazione si può riascoltare.
Quando qualcuno parla, la sua voce si salva per poco tempo, solo per trascriverla. Poi si cancella.
Il testo trascritto resta per un periodo.
Ho capito
SEGNAPOSTO Il testo definitivo lo approva il legale. Compare una volta sola, al primissimo accesso; lo stesso contenuto torna in 5a.5 e in fondo a 5d.
5a.4 · CONSENSO 1 · NECESSARIO
21:41
Termini e privacy
Per usare BA servono i termini d'uso e l'informativa sulla privacy.
Leggi i termini›
Leggi l'informativa›
Accetto
Solo i termini e la privacy. La voce ha il suo consenso, nella schermata dopo.
5a.5 · CONSENSO 2 · RIFIUTABILE
21:42
Vuoi anche parlare?
Per parlare serve un secondo consenso. Mentre parli, la tua voce si registra per poco tempo e si trascrive; il testo serve alla moderazione e a costruire il tuo profilo.
Nessuna conversazione si può riascoltare. La voce si cancella dopo la trascrizione, il testo resta per un periodo.
Acconsento
Entra come ascoltatore
Ascolti ogni DEN come chiunque altro, senza parlare.
Due strade, nessuna è un errore: chi sceglie di ascoltare arriva all'elenco come gli altri (5a.7b).
5a.6 · NOME · DECISIONE APERTA
21:42
Come ti chiamano?
nome, nickname o entrambi  
da decidere
Continua
Lo spazio resta, il contenuto no. Vale sia per chi parla sia per chi ascolta.
5a.7a · ELENCO · PARTECIPANTE
21:43
DEN
Cucina di notte
entra chiunque · 5 sul palco
Fra due turni
entra chiunque · 2 sul palco
Lettori lenti
su invito · 3 sul palco
5a.7b · ELENCO · ASCOLTATORE
21:43
DEN
sei ascoltatore
Cucina di notte
entra chiunque · 5 sul palco
Fra due turni
entra chiunque · 2 sul palco
Lettori lenti
su invito · 3 sul palco
Stesso elenco, stessi DEN. Un marcatore fermo dice il fatto, senza commento e senza un invito a cambiare.
5b
Elenco DEN
vivi e vuoti, nella stessa lista
21:42
DEN
2 vivi
Cucina di notte
entra chiunque
MB
SL
AH
5 sul palco, 14 in ascolto  
Marta sta parlando
Corridoio lungo
su invito
GT
NV
2 sul palco  
Giulia sta parlando
Radio insonni
Vuoto. Puoi restare e ti avviso.
Tavolo lungo
Vuoto. Puoi restare e ti avviso.
Serra
Vuoto. Puoi restare e ti avviso.
Apri un DEN
**I vuoti non sono in fondo e non sono in grigio-errore.** Stanno nella stessa lista, con la stessa struttura, e la loro riga dice cosa puoi fare — "puoi restare e ti avviso" — non cosa manca. In alpha saranno la maggioranza: se la lista li trattasse come scarti, l'app sembrerebbe vuota anche quando funziona.
**Chi parla si legge già da qui**, con l'anello sulla bolla e il nome in chiaro. È l'unico posto dell'app dove un nome accompagna una presenza fuori dalla scheda: nella lista non ho ancora il contesto per riconoscere le iniziali.
**La sagoma vuota** alla destra dei DEN spenti è la stessa forma delle presenze, disegnata come contorno: dice "qui ci sta qualcuno" con il vocabolario dell'app, senza icone nuove.
Il marcatore su invito sui privati dice come ci sono entrato, non che sono protetti: nella stanza spariscono entrambi i marcatori tranne "entra chiunque" (§7.14).
**Niente personalizzazione dell'elenco in alpha — rinviata.** Con pochi DEN non ordina nulla: preferiti, ordine manuale e nascondi-stanza avrebbero un effetto misurabile solo su una lista che non abbiamo ancora. E cambierebbero cos'è questa schermata — da *dove si parla adesso* a *la mia collezione di stanze* — che è una decisione di prodotto, non un'aggiunta. L'ordine resta uno e non si tocca: prima i vivi, poi i vuoti.
5c
Attesa, e il passaggio a vivo
lo stato più frequente dell'alpha
21:44
Radio insonni
entra chiunque
SL
solo tu · sei in attesa
Resto qui con te. Quando arriva qualcuno te lo dico, anche a schermo spento.
Ti avviso quando si anima
Invita qualcuno
Esci
sono in attesa
21:52
Radio insonni
entra chiunque
SL
TR
2 sul palco
Non sei più solo.
Il tuo microfono è aperto
Scendi dal palco
Esci
da vuoto a vivo
**L'attesa non è una schermata a parte:** è la stanza vuota con l'avviso acceso. Cambiare schermata farebbe sembrare l'attesa un luogo diverso dallo stare dentro — e invece sto già dentro. L'unico segno è il pulsante che passa a stato attivo (bordo rgba(217,207,168,.42) e un punto acceso) più la riga "sei in attesa".
**Da vuoto a vivo, l'ingresso morbido in atto:** la scala scende da 208 a 156, l'arrivato appare al suo posto e nient'altro si muove. Nessun suono, nessun "X è entrato", nessuna animazione di ingresso — la sola riga "Non sei più solo", che scompare al secondo evento. Chi guardava lo schermo lo nota; chi era in tasca lo scopre dalla voce.
**Da provare:** il salto di scala 208→156 è il movimento più grande dell'app (52 pt su due presenze). Se sul telefono risulta brusco, si smorza tenendo 208 fino a tre persone e scalando solo dopo — cioè accettando due dimensioni fuori tabella.
5d
Impostazioni e persone bloccate
il blocco con la sua uscita, e il ritorno ad ascoltatore
21:46
Impostazioni
Lingua
Italiano
Microfono
Consentito
Notifiche
Negate — senza queste non posso avvisarti
Apri
Persone bloccate
3 persone
→
Torna ascoltatore
Non potrai più parlare. Se stai parlando, esci dalla stanza.
Esci da BA
Nessuna conversazione si può riascoltare. Quando qualcuno parla, la sua voce si salva per poco tempo, solo per trascriverla, poi si cancella. Il testo trascritto resta per un periodo.
impostazioni · minime
21:47
← Impostazioni
Persone bloccate
Non le senti in nessun DEN, e le vedi marcate se le incontri. Restano finché non le sblocchi.
bloccate da te · 3
DV
Dario V.
bloccato in aprile
Sblocca
PM
P. Morandi
bloccato in giugno
Sblocca
KY
K. Yilmaz
bloccato la settimana scorsa
Sblocca
Sbloccare è immediato e non avvisa nessuno.
elenco bloccati · con sblocco
**Una data approssimativa, non un timestamp.** "In aprile", "la settimana scorsa": basta a ricordare il perché, non costruisce una cronologia. È l'unico posto dell'app dove esiste un tempo passato, e resta volutamente sfocato.
Le presenze bloccate sono già neutre in elenco, con il glifo a 20 pt: lo stesso componente della stanza, ridotto — non un'icona diversa per la stessa cosa.
**Permessi negati senza colpa:** la riga Notifiche dice la conseguenza ("senza queste non posso avvisarti") e offre l'uscita, invece di rimproverare. Stesso schema per il microfono.
**Torna ascoltatore, non un interruttore.** Il consenso a parlare si ritira con una riga sola, con la conseguenza scritta. Non esiste un interruttore della trascrizione: chi parla viene trascritto, chi non vuole torna ad ascoltare. La riga finale dice cosa succede a voce e testo, come l'onboarding.
**Un gruppo solo in alpha.** In beta, con i DEN privati, il gruppo "ricevuti" di [5j](#5j) si aggiunge sotto questo, con la stessa intestazione e senza azioni; la riga in Impostazioni diventerà *Blocchi*. La schermata non si rifà.
5e
Sesta superficie — lock screen, Dynamic Island, notifica Android
dentro i formati di sistema, non come superficie libera
domenica 26 luglio
21:48
Cucina di notte
BA
MB
SL
AH
RK
5 sul palco  
viva dalle 21:02
Tocca per rientrare
altezza card 138 pt · limite di troncamento 160 pt · cadenza aggiornamenti ≥ 5 min
ios · lock screen · informativa
dynamic island · compact (36 pt)
5sul palco
minimal (≤ 45×36,67 pt)
espansa (≤ 144 pt) · con azioni (app intents)
Cucina di notte
5 sul palco
MB
SL
AH
RK
viva dalle 21:02
Spegni il microfono
Esci
android · notifica persistente (foreground service)
BA · in corso
MB
SL
AH
Cucina di notte  
5 sul palco · viva dalle 21:02
Spegni il microfono
Esci
ios 26 · con azioni · app intents
Cucina di notte
BA
MB
SL
AH
RK
5 sul palco  
viva dalle 21:02
Spegni il microfono
Esci
stessa card, subito dopo il tocco
Cucina di notte
BA
MB
SL
AH
RK
5 sul palco  
viva dalle 21:02
Microfono spento
Esci
**Perché le azioni sono l'eccezione che si aggiorna subito.** Un App Intent gira nel processo dell'app e riscrive l'attività da lì: il ritorno del tocco non passa da APNs e non consuma il budget di aggiornamenti. Quindi **l'unico stato che il lock screen può mostrare in tempo reale è il mio** — microfono spento, uscito — mai quello degli altri. Le due azioni sono le stesse della stanza, e nessuna è distruttiva senza ritorno: "Esci" chiude l'attività, il DEN resta.
**Il limite vero è la frequenza, non la sandbox.** Gli aggiornamenti push a un'attività hanno un budget: se arrivano troppo ravvicinati il sistema li scarta o li ritarda, e chiedere la cadenza alta è un'eccezione da motivare (e comunque non è al secondo). Un'app dove chi parla cambia ogni pochi secondi non può inseguire quel dato fuori dall'app. **Quindi il lock screen non dice chi parla adesso: dice che la stanza è viva** — quante persone, da quanto. È un fatto che cambia di rado, sopravvive a un aggiornamento mancato e non mente mai per più di qualche minuto. "Marta sta parlando" letto quaranta secondi dopo sarebbe falso; "5 sul palco, viva dalle 21:02" no. **Ora d'inizio, non durata:** "da 38 minuti" sarebbe un contatore che accumula — il primo dell'app, e sulla superficie più guardata — e il §2 li esclude. L'ora d'inizio dà lo stesso vantaggio tecnico (si renderizza da sola, senza un solo push) ma è un fatto fermo: la differenza la fa chi legge, se gli interessa.
**Conseguenza sull'anello.** Fuori dall'app l'anello non sta più su una persona: **sta sulla sagoma della stanza**, fermo, e significa "qui dentro si parla". Le presenze restano nude. Così il segno non promette un tempo reale che il canale non può mantenere, e dentro l'app torna a fare il suo mestiere (§7.7, §7.16 da aggiornare).
**Vincoli di formato.** Card 138 pt su 160 di troncamento; espansa esattamente 144; minimal entro 45×36,67; payload ~300 byte. Quattro sagome anche a palco pieno, con il contatore che porta il resto.
ios · costo alto · rinviabile
La Live Activity è un'estensione WidgetKit scritta in Swift dentro un progetto Flutter: target separato, interfaccia riscritta in SwiftUI, stato condiviso via App Group, un canale verso il codice Dart, e ogni azione duplicata come App Intent. È l'unica parte dell'app dove il codice esiste due volte. **Si può spedire l'alpha senza**: senza di lei il DEN vive lo stesso, si perde la vetrina.
android · costo dovuto · obbligatoria
La notifica Android non è una scelta: un foreground service che tiene il microfono deve mostrarne una, o il sistema chiude il servizio. Il costo è quello della notifica in sé — layout compatto, silhouette monocromatica, due azioni — e va speso comunque. **Non anima e non si aggiorna spesso**, il che ora è coerente: dice anche lei che la stanza è viva.
**Durata:** 8 ore attive più 4 di coda sul lock screen. Un DEN che vive più di 8 ore perde la Live Activity: è fine sessione, non errore.
5e bis
Superfici di sistema — il lessico del proprio microfono
Sul proprio microfono l'azione è "Spegni il microfono"; "muta" resta per la voce di un altro. Lo stato spento è solo informativo: da qui il microfono non si riaccende. Le altezze dei controlli sono minimi: in tedesco il testo va a capo, non si tronca.
MICROFONO ACCESO · LOCK SCREEN E NOTIFICA ANDROID
Cucina di notte
5 sul palco · dalle 21:12
Spegni il microfono
Esci
BA · Cucina di notte
Sei sul palco
Spegni il microfono
Esci
Azione sul proprio microfono: "Spegni il microfono". Nessun "Muta".
MICROFONO SPENTO · LOCK SCREEN E NOTIFICA ANDROID
Cucina di notte
5 sul palco · dalle 21:12
Microfono spento
Esci
BA · Cucina di notte
Sei sul palco · microfono spento
Esci
Stato solo informativo: dal telefono bloccato il microfono si spegne e non si riaccende. Nessun contorno, nessuna azione; resta Esci.
5f
Palco pieno, linea instabile, linea persa, permessi negati, ingresso
due di questi fanno nascere il rosso
\#E4705B  
errore
**Il ruolo errore nasce qui, e nasce piccolo.** Vive in due schermate su sei: linea persa e permesso negato. Vale come **testo e filetto, mai come riempimento** — una bolla rossa piena sarebbe indistinguibile da una presenza, visto che nella palette ci sono già due tinte rosse. Sempre accompagnato da una parola, mai da un'icona sola, **una sola occorrenza per schermata**. Se la stessa cosa può essere detta in neutro (linea instabile, palco pieno), si dice in neutro.
22:07
Cucina di notte
entra chiunque
SL
MB
RK
AH
GP
NV
EC
TR
14 ad ascoltare
8 sul palco · pieno
Non c'è posto sul palco
Avvisami se si libera
Esci
palco pieno · nessun errore
22:09
Cucina di notte
entra chiunque
MB
SL
AH
RK
L'audio va a scatti
Sto tenendo la linea. Se cade te lo dico.
Il tuo microfono è aperto
Scendi dal palco
Esci
linea instabile · neutro
22:10
Cucina di notte
entra chiunque
MB
SL
AH
RK
La linea è caduta
Non ti sentono e non li senti. Riprovo io fra 8 secondi.
Riprova adesso
Esci dalla stanza
linea persa · errore
22:12
Cucina di notte
entra chiunque
microfono negato
Senza microfono non posso farti parlare
Il permesso è chiuso nelle impostazioni del telefono, non qui. Puoi restare ad ascoltare quanto vuoi: per gli altri non cambia niente.
Apri le impostazioni
Resto ad ascoltare
permesso negato · errore
22:14
Corridoio lungo
su invito
Sto entrando
Invita qualcuno
Annulla
0–600 ms · apertura
22:14
Corridoio lungo
su invito
MB
SL
AH
Il tuo microfono è aperto
Invita qualcuno
Esci
≈600 ms · dentro
**Palco pieno è un fatto della stanza, non un errore.** Otto presenze a 88 pt sono il fondo della scala a testo normale: è quanto entra in 360 dp. Il pulsante non sparisce — resta al suo posto spento, "Non c'è posto sul palco", perché un'azione che scompare fa cercare cosa è cambiato. L'unica cosa nuova è "Avvisami se si libera", che è una preferenza mia e sta nella riga di sotto.
**Instabile e persa sono due cose diverse e si vedono diverse.** Instabile: le presenze restano vive, **l'anello smette di modulare e resta fermo al minimo** — non posso più fidarmi dell'ampiezza, quindi non la disegno. Persa: la stanza va in grigio al 34%, che è lo stesso trattamento della voce mutata portato all'estremo, e vuol dire "questa è l'ultima cosa che ho visto". **Non ti sbatto fuori dallo schermo**: la stanza resta lì mentre riprovo.
**Il permesso negato usa il colore d'azione chiaro** perché soddisfa la condizione del §5a: senza quel gesto — fatto fuori dall'app, dove BA non arriva — la cosa non va avanti in nessun modo. La linea persa invece no: lì BA riprova da sola, "Riprova adesso" è solo un'accelerazione, e resta hairline attivo. La colpa non è dell'utente e la frase non la assegna: dice dov'è il permesso e cosa si può fare comunque. "Resto ad ascoltare" è un'uscita vera, non un rifiuto.
**L'ingresso non ha una rotella.** Il numero di presenze lo conosco già dall'elenco, quindi disegno subito le sagome giuste al posto giusto, vuote e in respiro lento (0,30→0,62 opacità, 1,8 s): quando l'audio si aggancia si riempiono **senza che il layout si muova**. Nome della stanza e marcatore ci sono dal primo frame. Oltre 4 s l'apertura diventa la schermata "instabile", oltre 12 s "persa": il caricamento non ha uno stato infinito.
**Regola che ne esce, e vale per tutti gli stati futuri:** BA parla in prima persona quando si prende la responsabilità ("riprovo io", "sto tenendo la linea") e in seconda quando serve una tua decisione. Mai un codice, mai "qualcosa è andato storto".
5g
Quando qualcuno entra, si ridimensionano tutti
tre comportamenti, uno da scegliere · va in §7.15
La soglia resta dov'è: 208 da solo, 156 in due, e giù secondo tabella. Quello che si decide qui è **come si passa da una scala all'altra**. Il ridimensionamento è collettivo per costruzione — tocca anche me, anche mentre sto parlando: nessuna presenza è esente, altrimenti l'impacchettamento si rompe.
opzione A · animato
Tutti insieme, subito, in 320 ms
→
L'arrivo e la nuova scala partono nello stesso frame, curva morbida. La stanza "respira" a ogni ingresso: il movimento è la notizia.
Con viavai frequente la stanza pompa in continuazione, e mentre parlo lo schermo si muove sotto la voce.
opzione B · a scatto
Nessuna transizione, un frame
\|
La scala cambia insieme alla comparsa, senza interpolazione. Zero costo, zero distrazione periferica, coerente con il fallback statico.
A 208→156 il salto si legge come un difetto di rendering, non come un arrivo.
opzione C · con ritardo
proposta
Prima arriva, poi la stanza si assesta
arriva · scala corrente
4 s
si assestano insieme
Chi arriva compare **subito**, in un posto libero e **alla scala che hanno tutti in quel momento**: mai più piccolo, nemmeno per un istante. Il ridimensionamento collettivo parte dopo **4 s di conteggio fermo**, animato in 320 ms. Tre ingressi ravvicinati producono un assestamento solo.
Separa le due notizie: "è arrivato qualcuno" è immediata, "la stanza è diventata più grande" è lenta e succede una volta. Il palco resta **a una sola dimensione per volta** — una presenza più piccola delle altre sarebbe rango, e qui non esiste gerarchia.
**Perché C.** Il salto 208→156 è brusco per quello che dice, non per quanto dura: annuncia una persona con un movimento che coinvolge tutto lo schermo. C smorza la frequenza invece della grandezza, e il viavai — che nell'alpha è la norma, non l'eccezione — smette di far pulsare la stanza.
**Numeri, ora consolidati in BA · Token T8.** Debounce 4 s sugli ingressi, 6 s sulle uscite. Assestamento 320 ms, cubic-bezier(.22,.9,.25,1), uno solo in volo: se ne parte un altro, quello in corso si interrompe e riparte dal punto dov'è. Chi c'era resta dov'era: cambia la scala, non l'ordine.
**L'uscita non lascia il buco.** Sei secondi di vuoto in mezzo a sagome incastrate si leggono come un difetto, non come un'assenza. Quindi **le posizioni si ricompattano subito** (spostamento di 200 ms, stessa scala: la stanza si stringe), e solo la crescita di scala aspetta i 6 s. Il ritardo serve a non ingrandire tutti per una disconnessione di tre secondi, non a tenere un posto vuoto in vista. Unica eccezione: se resta una persona sola si passa subito a 208, perché un buco accanto a una bolla sola non è una stanza, è un errore.
**Nessuna esenzione per chi parla.** Rimandare l'assestamento per non muovere la mia bolla mentre parlo produrrebbe due layout diversi nella stessa stanza. Se disturba, si tocca il debounce, non l'insieme.
**Movimento ridotto:** C con durata 0 — stesso ritardo, cambio in un frame. Cioè B, ma solo dopo che la stanza si è calmata: è il caso in cui B va bene.
5i
Sottotitoli — rinviati, non resi impossibili
in v1 non esistono: si tengono la fascia e la tinta
22:14
Cucina di notte
entra chiunque
SL
MB
AH
fascia riservata · quota zero · non disegnata
Chiudi microfono
Esci
v1 · nessun controllo, nessun marcatore
22:14
Cucina di notte
entra chiunque
SL
MB
AH
Provo domani e ti dico. Se sbaglio ancora, cambio mestiere.
Chiudi microfono
Esci
poi · un blocco alla volta
parlano insieme
Qui il testo si ferma.
accavallamento · si dichiara, non si indovina
Sottotitoli
Mostra le voci come testo, sul tuo telefono
l'unico controllo ammesso · non in v1
**Fuori dall'interfaccia, adesso.** Via il marcatore di stanza. Non esiste un interruttore della trascrizione: il consenso a parlare si dà all'accesso e si ritira con *Torna ascoltatore* (5d). Se e quando esisteranno, i *Sottotitoli* saranno una preferenza di visualizzazione, distinta dalla scelta fra ascoltatore e partecipante: dicono cosa vedo io, non cosa accade alla mia voce.
**Si tiene la fascia.** Fra il palco e le azioni esiste già una posizione nell'ordine di cessione, tenuta a quota zero: quando comparirà, il palco cede un passo di scala e le azioni non si muovono di un pixel. È l'unica cosa che va decisa ora — inserire due righe più tardi in un impacchettamento che non le prevede vuol dire rifare la stanza.
**Si tiene l'attribuzione per colore.** Tinta unica garantita sul palco (al massimo 8 presenze su 12 tinte) è la precondizione perché una battuta possa dire di chi è senza portare un nome. Qualunque funzione futura che rompa quell'unicità uccide i sottotitoli con sé: da verificare prima di toccarla.
**Mai due blocchi insieme.** Se una voce prevale, la didascalia è sequenziale: i blocchi si succedono, ognuno con la sua tinta e il suo anello. Un solo blocco alla volta è anche il motivo per cui la fascia può restare bassa e non diventa un pannello.
**Se si accavallano davvero, si dichiara l'accavallamento.** È la pratica standard del sottotitolaggio ed è anche l'unica onesta: il parlato sovrapposto è esattamente dove il riconoscimento fallisce, e una frase sbagliata attribuita a una tinta è peggio di nessuna frase.
**L'attribuzione la portano colore e anello, non un'etichetta.** A differenza della televisione, qui un indicatore dal vivo di chi parla esiste già: l'anello sul palco e lo stesso anello, ridotto, sul blocco. Nessun nome davanti alla battuta — §7.12 resta intatto.
**La permanenza si ricava dalla lettura, non dalla voce.** Circa 17–20 caratteri al secondo: una riga da 42 caratteri sta almeno ~2,2 s e non viene sostituita prima, anche se chi parla è già andato avanti. Il testo resta indietro rispetto al parlato, ed è accettato: non è un verbale, è un appoggio.
**La fascia avrà due sorgenti, non una.** Il riconoscimento della voce, oppure il testo digitato da chi non può o non vuole usare la propria voce: stesso componente, stesse regole, stessa attribuzione. Non è un canale parallelo — occupa il turno che occuperebbe parlando, e per questo non tocca il §3 (§7.12 bis). Nessuna delle due sorgenti si costruisce ora.
**Resta aperto:** il costo del rinvio lo paga chi ha bisogno di leggere, e in v1 non ha niente. Va detto agli invitati dell'alpha invece di essere scoperto dai loro silenzi.
5j
Sono stato rimosso da un DEN
quello che ho dato e quello che ho ricevuto non sono la stessa cosa
beta · da non precludere
Fuori dall'alpha: nei DEN pubblici non ci sono amministratori. Esisterà con i DEN privati. In alpha vale "Persone bloccate" con un gruppo solo (5d); il gruppo "Ricevuti" e la riga "rimosso" di queste schermate arrivano in beta, senza rifare la schermata.
22:31
Non sei più in Fra due turni.
Chi ha aperto il DEN ti ha rimosso. Non puoi rientrare, e non ti diciamo un motivo che non abbiamo.
Gli altri DEN non cambiano. Niente di quella stanza resta sul tuo telefono: non c'era niente da tenere.
Torna all'elenco
Il microfono è già spento.
il momento · nessun colore d'azione
22:33
← Impostazioni
Blocchi
Chi non senti, e dove non entri. Restano finché non li togli.
date da te · 3
DV
Dario V.
bloccato in aprile
Sblocca
PM
P. Morandi
bloccato in giugno
Sblocca
ricevuti · 1
Fra due turni
rimosso stasera · non puoi rientrare
Sui ricevuti non c'è niente da premere: non l'hai deciso tu, e non è tuo da disfare.
blocchi · due gruppi, un'azione sola
Fra due turni
Non puoi rientrare.
rimosso
BaRigaDen · rimosso (inerte)
**La riga resta in elenco, spenta.** Farla sparire sembrerebbe un guasto e mi lascerebbe a ritentare: una porta chiusa si vede, altrimenti non è una porta. Non è toccabile e non ha un'uscita, perché non ce n'è una.
**Nessun motivo inventato, nessuna richiesta di revisione.** Non abbiamo il motivo e non lo chiediamo a chi rimuove: scriverne uno sarebbe finzione, e un appello in alpha sarebbe una promessa che nessuno può mantenere. La frase dice il fatto e si ferma.
**La rimozione non è un blocco, e non si somma.** Il blocco è mio verso una persona e vale in ogni DEN; la rimozione è di una stanza verso di me e vale in quella stanza. Chi mi ha rimosso non finisce fra le persone che non sento: *non ho deciso io di non sentirlo*.
**Due gruppi e un'azione sola.** "Date da te" ha *Sblocca*, "Ricevuti" non ha niente — ed è l'asimmetria a spiegare la differenza meglio di qualsiasi etichetta. Un pulsante inattivo sulla riga ricevuta suggerirebbe che da qualche parte c'è un modo.
**In beta la memoria cresce di una riga, non di una categoria.** Al blocco si aggiunge la rimozione, e vanno dette insieme nella stessa schermata, con lo stesso tempo sfocato ("in aprile", "stasera"). Se restassero separate, l'app avrebbe due memorie e ne dichiarerebbe una.
In beta la riga in Impostazioni diventa **Blocchi**, con "3 persone · 1 DEN" al posto del solo numero: il titolo non nomina più una sola delle due cose che contiene.
5h
"Pass" cade — e non lo sostituisce un'altra parola
| candidato     | come legge                                                                                       | esito    |
|---------------|--------------------------------------------------------------------------------------------------|----------|
| pass          | de: *Pass* = passaporto, documento personale e permanente                                        | scartato |
| chiave        | nessun falso amico, ma promette una porta che resta apribile                                     | scartato |
| ospite        | giusto sul tempo, ma qualifica la persona e suggerisce due classi di presenza                    | scartato |
| varco, soglia | intraducibili corti; en *threshold*, de *Schwelle* non stanno in un marcatore                    | scartato |
| su invito     | it *su invito* · en *by invite* · de *auf Einladung* · es *por invitación* · fr *sur invitation* | adottato |
La ricerca di un sinonimo era il problema. **Il DEN privato non ha bisogno di un oggetto con un nome**: ha bisogno di dire come ci si entra. Quindi il marcatore diventa una **proprietà della stanza**, in coppia con quello che esisteva già:
entra chiunque
su invito
Due stati della stessa cosa, stessa forma grammaticale, nessun sostantivo nuovo da tradurre. Il pulsante perde il complemento e diventa **"Invita qualcuno"**; il codice che si spedisce resta "codice di invito" e vale solo per i DEN privati. All'accesso non serve nessun codice.
