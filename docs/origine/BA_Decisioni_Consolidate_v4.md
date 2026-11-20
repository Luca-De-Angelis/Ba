# BA — Registro delle decisioni · v4

31 luglio 2026 · **Documento autoritativo e autosufficiente.** In caso di conflitto con altri file,
**vince questo**.

**ADR:** le decisioni di progettazione (numeri 001–023) sono consolidate qui; solo ADR-017 ha un
file proprio. Le decisioni della fase di sviluppo diventano file in `docs/adr/` a partire da
ADR-024 — convenzione e risoluzione dei numeri citati in `docs/adr/README.md`.
Novità v4: coda con ingresso automatico opt-in, funzioni di coda per livello, following e DEN
programmati, vincolo licenze rimandato al documento legale.
**21 ottobre 2026:** assioma sull'audio salvato per la trascrizione (§1, §6).
**22 ottobre 2026:** due tipi di account, già nell'alpha (§3); chiuse quasi tutte le questioni del
§9; fissate le predisposizioni di lingua del DEN e notifica Android (§8); backup nell'alpha in
ADR-024 (§2, §6).
**28 ottobre 2026:** rilevamento della voce prima della trascrizione (§6).
**10 novembre 2026:** trascrizione differita sul server (ADR-027, §2, §6); formato degli interventi
e fino alla produzione nessuna cancellazione (§6); modello locale per moderare e profilare (§6);
lingue di lancio e beta a uso interno (§1).
**20 novembre 2026:** registrate le decisioni del catalogo dei servizi del 10 novembre: posizione
attuale e posizione abituale (§1), livello Pro e abbonamento unico (§10.1).
Documenti collegati: `BA_Tipologie_Account.md` (funzionalità per livello) · `BA_Vincoli_Legali.md`
(punti da istruire con il legale) · catalogo dei servizi attivabili (10 novembre: servizi, leve e
stato di ciascuno; ipotesi per costruire i pacchetti, non decisioni, salvo dove indicato).

---

## 0. Vocabolario — usare questi termini, sempre

| Termine | Cosa indica |
|---|---|
| **App** | Client Flutter, iOS e Android |
| **Servizio** | Backend applicativo in Go che scriviamo noi. Emette i token, tiene regole, dati e permessi. Nel repository sta in `/backend`. |
| **Console** | Pannello amministrativo interno (statistiche, riavvio servizi). **Fuori dall'alpha.** |
| **Server** | La macchina Linux che ospita tutto |

Il **Servizio** non è opzionale: LiveKit accetta solo token JWT firmati con il segreto dell'API,
che non può stare nell'App. Da lì in poi, tutto ciò che un client modificato non deve poter
aggirare vive nel Servizio.

---

## 1. Cos'è BA

Social **vocale** basato sulla presenza. Le persone entrano in **DEN**: stanze vocali con un
**palco di massimo 8 che parlano** e un pubblico che ascolta. Claim: *"La Live sei tu"*.
**L'audio si salva solo per trascriverlo** (assioma, §6). In produzione si cancella a elaborazione
conclusa; in alpha e beta si conserva, per misurare i miglioramenti di trascrizione, moderazione e
profilazione.
**Marchio** (22 ottobre): "BA" nell'icona dell'app, "live.ba" dove c'è spazio.

**Fasi** (28 ottobre). Anche la **beta è a uso interno**: decine di utenti, 2–3 DEN
contemporanei. L'apertura a utenti esterni coincide con il lancio pubblico, ed è lì che scattano
gli obblighi "prima dell'apertura" (§3, documento legale).
**Lingue di lancio** (28 ottobre): italiano, poi inglese; le altre a seguire. La lingua si rileva
comunque su ogni intervento. Sostituisce le cinque lingue della sintesi §7.2.
**Posizione** (10 novembre, catalogo G15): due posizioni separate. Il GPS dice dove sei ora; il
profilo dice dove sei di solito e fa da riserva se il GPS non è autorizzato. Non è nell'alpha.

---

## 2. Stack — decisioni ferme

App **Flutter** (Riverpod) · Servizio **Go** (chi, pgx+sqlc, golang-migrate) · Media **LiveKit OSS
self-host** + coturn · **PostgreSQL 18** + Valkey · **Contabo** Cloud VPS 4, Germania, Ubuntu 24.04
LTS · **Codemagic** per iOS · **GitHub Issues** · Trascrizione **sul server, in differita**
(ADR-027) · Push **FCM** · Errori **Sentry** · Segreti **SOPS + age** · Dominio **live.ba**
(acquisito, con posta).

**Trascrizione** (ADR-027, 10 novembre): sul server, in differita, sull'audio salvato da un
**registratore**, un partecipante di servizio nascosto in ogni DEN e sotto-DEN. Il registratore lo
costruisce la chat di sviluppo (spec 019), il trascrittore il socio della traccia. La trascrizione
sul telefono esce dall'alpha (027): la prova in Flutter citata nella sintesi non era mai stata
fatta.

**Realtime fuori dalla stanza:** polling leggero (5 s) per l'elenco DEN; dentro la stanza fanno
fede gli eventi LiveKit. **Senza connessione** l'app mostra l'ultimo elenco DEN noto, segnato come
non aggiornato; tutto il resto richiede la rete.

**API:** versione nel percorso fin da subito (`/v1/...`).

**Backup** (ADR-024): nell'alpha il backup automatico di Contabo; la copia esterna del database
presso un altro fornitore arriva prima della beta e del trasloco sotto la società.

**Ambienti:** nell'alpha una macchina per LiveKit, Servizio e dati — **staging è quella macchina, la
produzione non esiste ancora** — più una seconda per registratore e trascrittore (ADR-027), che il
socio sceglie dopo il banco di prova. La separazione media/app su due nodi resta per la produzione
(ADR-017).

**Infrastruttura in alpha: niente Terraform né Ansible.** Ogni macchina ha tutto in docker-compose: la
configurazione si riduce a Docker, firewall e TLS, coperta da **uno script di bootstrap
idempotente e versionato**. Invariante: *niente comandi digitati a mano che non stiano nello
script*. Al secondo nodo in produzione lo script diventerà un ruolo Ansible.

**Segreti: SOPS + age** (sostituisce Ansible Vault, rimasto orfano quando Ansible è uscito
dall'alpha). File `.env` cifrato **versionato nel repository**, decifrato solo al deploy. Ogni
persona ha la **propria chiave age**: aggiungere qualcuno significa aggiungere la sua chiave
pubblica e ri-cifrare; toglierlo, l'inverso. È la ragione per cui supera una passphrase condivisa
quando si lavora in due. GitHub Secrets per la CI; **gitleaks in CI dal primo commit**. Il pepe
dell'HMAC del numero di telefono vive qui.

---

## 3. Identità e anti-abuso

**Identità a due livelli** (22 ottobre 2026). Chi parla ha il **numero di telefono verificato**: le
SIM italiane richiedono documento, ed è l'unico ancoraggio reale contro l'elusione dei ban. Chi
ascolta soltanto ha un'**email verificata con un codice**. Identificativo interno **stabile e
pseudonimo**; telefono ed email sono **identificativi verificabili separati** dall'utente.

### Due tipi di account

Decisione del 22 ottobre 2026, approvata da tutti i soci. Conferma l'ipotesi IP-1.

| | **Ascoltatore** | **Partecipante** |
|---|---|---|
| Registrazione | Email, verificata con un codice; dopo l'alpha anche Google o Apple. Nessun OTP via SMS | Numero di telefono verificato con OTP via SMS |
| Consensi | Solo termini e privacy | Termini e privacy, più registrazione dell'audio, trascrizione, profilazione e moderazione (§6) |
| Cosa fa | Ascolta i DEN pubblici, creator compresi, e i contenuti free. Muta una voce, blocca. Attende in un DEN vuoto, con notifica quando arriva qualcuno | Tutto ciò che prevede il suo livello: free, pagante o creator (§10) |
| Voce | **Nessuna, da nessuna parte:** niente palco, coda, alzata di mano, sotto-DEN, creazione di DEN. I DEN privati, fatti solo di palco, gli restano chiusi | Sì |
| Trascrizione, profilazione e moderazione di ciò che dice | No: non parla | Sì |
| Pubblicità | Riceve le sponsorizzate, quando ci saranno (fase 2) | Secondo il livello (§10) |

- **Il passaggio.** Chi ascolta e prova a parlare (salire, mettersi in coda, alzare la mano, entrare
  in un sotto-DEN, creare un DEN) viene invitato a verificare il numero e a dare il consenso. **Chi
  non accetta resta ascoltatore.** È il punto di conversione più importante dell'app.
- **"Può parlare" è una capacità** (§8, vincolo 6): si ottiene con numero verificato e consenso. Il
  Servizio la applica lato server: **il token di un ascoltatore non permette di pubblicare audio**.
  Il passaggio a partecipante avviene a stanza aperta, senza riconnessione (§8, vincolo 3).
- **Alla registrazione**, per tutti: **nickname obbligatorio**, anche ripetibile (l'unicità si
  deciderà con il following), e la dichiarazione **"ho almeno 18 anni"**.
- **Età minima:** si parte sicuramente da 18 anni; l'obiettivo è 16, da decidere con il legale.
  Scendere a 16 richiederà di rivedere la registrazione e di riconoscere i minori: per loro niente
  profilazione pubblicitaria e cautele sulle decisioni automatiche.
- **Ban, secondo la gravità:** nei casi lievi il partecipante perde la voce e resta ascoltatore; in
  quelli gravi il ban è totale.
- **Abbonamento anche per l'ascoltatore**, senza verificare il numero: niente pubblicità e contenuti
  dei creator. Per parlare serve comunque il numero (§10).
- **Condizioni confermate il 22 ottobre**, per quando arriveranno le funzioni interessate: mute,
  blocchi e segnalazioni pesano di più se vengono da account con numero verificato; nelle
  statistiche dei creator contano solo gli ascolti di account verificati; Play Integrity e App
  Attest servono dal giorno in cui la registrazione via email si apre a utenti esterni.
- **Conseguenza accettata:** chi è bloccato può aprire un account da ascoltatore e tornare ad
  ascoltare i DEN pubblici di chi l'ha bloccato. I DEN privati restano protetti.

**Nell'alpha** (scelta delegata, 22 ottobre): **i due tipi di account entrano già nell'alpha.** Lo
schema va fatto giusto dalla spec 011 in ogni caso; il passaggio da ascoltatore a partecipante è il
punto di conversione da giudicare con i tester; con i mittenti dietro interfaccia il costo resta
quasi nullo.
- **Dentro:** registrazione con email e con numero, consensi per tipo di account, passaggio a
  partecipante, capacità "può parlare" applicata nel token.
- **Fuori:** pubblicità, Play Integrity e App Attest, pesi dei segnali di moderazione, conteggio
  degli ascolti per i creator, accesso con Google o Apple.

**Verifica del numero:** preferita la **Silent Network Authentication** (verifica del possesso
della SIM via crittografia del carrier, senza codice; disponibile in Italia, resistente a SIM swap,
elimina l'8–22% di abbandono tipico dell'OTP; richiede rete dati mobile). Ripiego: **OTP via SMS**
(Esendex 0,058 €/msg; esistono rotte europee intorno a 0,03 €). **Non ottimizzare in alpha.**

**Obbligatori prima dell'apertura a utenti esterni**, cioè prima del lancio pubblico *(alpha e beta
hanno solo tester interni e noti, §1: lì resta obbligatorio solo il limite di frequenza, che non ha
costi esterni)*:
- **Rifiuto dei numeri VoIP e virtuali** (API di lookup). Senza, il ban si aggira in trenta secondi.
  Lo step esiste già in alpha ma **dietro interfaccia**: validatore permissivo in alpha (nessuna
  chiamata esterna, costo zero), reale in produzione. Il Servizio **rifiuta di avviarsi** in
  produzione con il validatore permissivo attivo — stesso vincolo del mittente SMS finto.
- **Limiti di frequenza per IP e dispositivo** + paesi ammessi (contro l'inflazione artificiale del
  traffico, 5–15% della spesa OTP).
- **Play Integrity (Android) e App Attest (iOS)**: gratuiti, migliore difesa contro la creazione
  massiva di account falsi.

**Accesso con Google o Apple: escluso per chi parla.** Nessuna garanzia d'identità né resistenza
ai ban — account gratuiti e illimitati, e *Hide My Email* è progettato per impedire la
correlazione. **Per i soli ascoltatori sì, dopo l'alpha** (22 ottobre): la loro identità è comunque
debole, e conta poco perché non parlano.

**Riciclo dei numeri:** gli operatori riassegnano dopo 12–24 mesi → **i ban devono scadere**.

---

## 4. Modello di ruoli e permessi

**Un solo primitivo: una stanza vocale con al massimo 8 che parlano.** Il resto sono attributi.

| Tipo | Admin | Pubblico | Ingresso | Genitore |
|---|---|---|---|---|
| DEN pubblico (sistema o utente) | **nessuno** | sì | libero; palco pieno → coda | no |
| DEN privato | creatore, **1→n admin** pari poteri | no (solo palco) | solo su invito | no |
| Sotto-DEN | secondo visibilità | no | **pubblico = qualunque partecipante fino a 8**; privato = su invito | sì |
| **DEN creator** *(tipo distinto, non in alpha)* | **il creator** | sì, con gruppi | secondo configurazione | no |

⚠ Il **DEN creator è un tipo a sé**, non un DEN pubblico con poteri: è l'unico DEN pubblico dotato
di admin. Senza questa distinzione il modello si contraddice.

**DEN pubblici:** nessuna autorizzazione per entrare e ascoltare; per salire bisogna essere
partecipanti (§3). Palco pieno → coda. Chiunque può mutare e bloccare.
Moderazione **calcolata** sulla community.

**Coda verso il palco — vincolo di sicurezza.** Quando si libera un posto, l'utente in coda viene
avvisato ed **entra sempre con microfono spento**, con richiesta esplicita di salire e una finestra
oltre la quale il posto passa al successivo. **Mai attivare il microfono automaticamente**:
pubblicherebbe l'audio di chi è al supermercato o in auto con altri.

È prevista una spunta facoltativa **"fammi entrare automaticamente"**: fa occupare il posto senza
conferma, ma **il microfono resta comunque spento** — la scelta riguarda l'occupare il posto, non
il trasmettere. La spunta vale **per singolo DEN e per la sessione**, non come impostazione globale
permanente.

**Funzioni di coda per livello** (nessuna scavalca nessuno): free = code multiple su più DEN +
notifica push mentre si aspetta; pagante = sotto-DEN d'attesa + conservazione del posto in caso di
uscita breve. **La precedenza a pagamento è esclusa**: contraddirebbe il principio palco/pubblico
funzionale e non di status.

**Funzioni creator (non in alpha):** DEN con gruppi di ascoltatori; autorizzazione a parlare per
persone o interi sotto-DEN, **che si sommano agli 8** (fino a 8+8); revoca della parola; richiesta
per alzata di mano; **ban discrezionale** sul singolo DEN o su tutti i propri (richiede liste di
ban con ambito creator).

**Principio chiave:** chi riceve la parola **non sale sul palco** — *"come se dal palco passassero
un microfono tra il pubblico"*. Resta nel proprio sotto-DEN con il solo permesso di pubblicare.

---

## 5. Blocco tra utenti

Persistente, con lista consultabile e sbloccabile.

- A blocca B → B **non entra** nei DEN creati da A, **non può esservi invitato**, **non li vede**.
- In un DEN di terzi: B entra, A lo vede, ma B è **automaticamente mutato per A**.
- A può togliere il muto a B **solo per sé e solo in quel DEN**; **la scelta resta memorizzata**.
- B può aprire un account da ascoltatore e ascoltare i DEN pubblici di A: conseguenza accettata
  (§3). I DEN privati di A restano protetti.

Ingresso, inviti e visibilità sono applicati **dal Servizio**; il muto resta de-sottoscrizione
lato client. Effetto noto e accettato: B può dedurre di essere stato bloccato.

---

## 6. Trascrizione, profilazione e conservazione — vincolo permanente

**Va prevista sempre e da subito**, anche se facoltativa nel funzionamento.

**Assioma sull'audio, fisso e insindacabile** (21 ottobre 2026, testo di Andy):

> L'audio viene salvato solo nel momento in cui si veda necessario per poterlo trascrivere
> evitando di doverlo fare in real-time (non ci serve subito, basta che arrivi la trascrizione
> prima o poi). Una volta trascritto ed elaborato il testo al fine di profilare e moderare, il file
> audio e le trascrizioni potranno essere eliminate.
> Questo punto è fisso e insindacabile: se la parte tecnica necessita di una registrazione salvata
> su disco (anche se temporanea) la direzione sarà quella. Profilazione e moderazione non sono
> discutibili e direttamente dipendenti dalla trascrizione.

- **Non è più vero:** "nessun audio persistito, mai". L'audio si può salvare, anche su disco, per
  trascriverlo; per quanto tempo resta, lo dice la conservazione qui sotto.
- **Non è più vero:** "le uniche persistenze sono metadati anonimizzati". I dati sono **personali**.

**Pipeline:** audio → **rilevamento della voce**, che tiene solo i tratti in cui qualcuno parla →
salvataggio, se serve a trascrivere senza farlo in tempo reale → trascrizione → coda per DEN e
sotto-DEN → elaborazione a blocchi di N minuti via modello AI → estrazione di
profilazione, sentiment, reputazione → a elaborazione conclusa, **cancellazione dell'audio e della
porzione elaborata**, dalla produzione. **Casi segnalati dalla moderazione** (22 ottobre): l'audio
dei pochi secondi segnalati resta fino alla revisione umana, che fa parte dell'elaborazione "al fine
di moderare".
**Fino alla produzione non si cancella nulla** (10 novembre): audio e testi restano, per ripassare
trascrizione, moderazione e profilazione sugli stessi contenuti e misurarne i miglioramenti.
Formulare nel consenso dei tester come *"per la durata della fase di test, comunque non oltre N
mesi"*. **Dalla produzione** l'audio si cancella a elaborazione conclusa, e comunque entro **72
ore** anche se la trascrizione si ferma. Termine del testo in produzione: da decidere.
**Modello per moderare e profilare** (10 novembre): **in locale**, su una macchina dedicata ancora
da ordinare e configurare; se ne occupa l'altro socio. Nessun servizio esterno riceve i testi.
**Costo:** ~0,015 $ per DEN-ora, stimato per l'elaborazione del testo con il modello AI. Non
condiziona le scelte. La trascrizione è una voce a parte.

**Rilevamento della voce** (28 ottobre): il silenzio non si salva e non arriva al motore. Un
rilevatore di voce tiene solo i tratti in cui qualcuno parla, con un margine prima e dopo ogni
tratto. Due motivi. Con una traccia per persona l'audio è in gran parte silenzio, quindi il calcolo
si riduce di più volte. E sul silenzio i motori di trascrizione inventano frasi, anche violente, che
finirebbero nei profili e nella moderazione di chi non le ha dette. **Vincolo: nessun parlato
perso.** Nel dubbio il rilevatore tiene. Sul banco di prova, applicato alle registrazioni intere,
non deve far perdere parole rispetto alla trascrizione dell'audio intero. Valori di partenza nella
proposta di pipeline della chat sulla trascrizione: un tratto si chiude dopo 0,8 s di silenzio, con
250 ms di margine.

**Salvataggio e formato** (ADR-027). Un file per intervento, salvato solo mentre la persona parla.
Inizio e fine sono orari reali dell'orologio del server, in UTC al millisecondo: l'ordine della
conversazione si ricostruisce da lì, e nessun passaggio successivo accorcia o modifica un file
salvato. FLAC, mono, 16 kHz, con i metadati dentro il file e una riga nel database con gli stessi
dati e lo stesso identificativo (25 ottobre). Chiavi: `BA_ID`, `BA_DEN_ID`, `BA_ROOM_ID`,
`BA_USER_ID`, `BA_SESSION_ID`, `BA_STARTED_AT`, `BA_ENDED_AT`, `BA_DECLARED_LANGUAGE`, `BA_SCHEMA`.

**Consenso — due accettazioni distinte**, legate al tipo di account (§3):
1. **Termini e privacy** — per tutti, alla registrazione. È l'unica accettazione dell'ascoltatore.
2. **Registrazione dell'audio, trascrizione, profilazione e moderazione** — richiesta per parlare,
   dopo la verifica del numero. **Rifiutabile: chi rifiuta resta ascoltatore**, non parla e quindi
   non viene trascritto. Da verificare con il legale che legare la parola a questo consenso sia
   compatibile con un consenso libero (art. 7 GDPR; documento legale §3). **La revoca è un
   passaggio ad ascoltatore:** si fa dalle impostazioni, con una doppia conferma, e chi la fa
   durante una conversazione viene fatto uscire.

Si salvano **chi, quando, quale versione del testo**. Deve esistere dalla prima fetta con
registrazione.

**Cancellazione e ban:** dopo la cancellazione sopravvive **solo un HMAC con chiave segreta lato
server** del numero (pepe nel vault) — non un hash semplice, invertibile per forza bruta in secondi
sui numeri italiani. Solo impronta, data, motivo.

**Sicurezza:** il database e l'audio salvato in attesa di trascrizione conterranno contenuto
conversazionale → **cifratura a riposo** e **accesso ristretto e tracciato**, anche per il team.
**Backup:** il backup automatico di Contabo copia tutto il disco e tiene le copie dieci giorni
(ADR-024). Fino alla produzione non si cancella nulla, quindi le copie non trattengono file già
cancellati. Resta da scegliere se la macchina del registratore ha il backup, e dove sta la chiave del
volume cifrato (§9). Dalla produzione l'audio resta fuori dalle copie.

**Al DPO:** se la reputazione **limita accessi**, si entra nella decisione automatizzata, che
richiede revisione umana.

---

## 7. Loggia e sotto-DEN

**Trasporto: doppia connessione lato client** (DEN in sola sottoscrizione, sotto-DEN in
pubblicazione e ascolto). Rende banale il ritorno ad ascoltatore, requisito esplicito.

**Il contenuto riprodotto è un partecipante come gli altri e NON conta negli 8:** il limite conta i
*pubblicatori umani*. Da scrivere così, o verrà implementato come "massimo 8 tracce".

### Semantica della parola concessa — additiva, non un cambio di stanza

Chi riceve la parola **resta nel proprio sotto-DEN**: la sua voce viene *aggiunta* al DEN
principale. Lo sentono sia i membri del suo gruppo sia tutti gli altri, esattamente come chiunque
sia sul palco.

**Regola tecnica obbligatoria — doppia ricezione.** Tutti i membri di un sotto-DEN sono connessi a
due stanze. Se A pubblica anche sul DEN principale, B riceverebbe la voce di A **da entrambe** con
qualche decina di ms di sfasamento: non un'eco pulita, ma un effetto metallico da filtro a pettine,
immediatamente percepibile. Quindi: **quando un membro pubblica sul DEN principale, gli altri
membri del suo sotto-DEN si de-sottoscrivono dalla sua traccia nel sotto-DEN** e lo sentono solo
dal principale. Usa il meccanismo di de-sottoscrizione già previsto per "muta una voce": nessuna
architettura nuova.

Perché si tiene la copia pubblica e non quella privata: così il gruppo sente A **come lo sente il
resto del DEN**, il che rinforza percettivamente il fatto che A ora è pubblico, invece di lasciar
credere che stia ancora parlando in privato.

**Sotto-DEN intero con la parola:** tutti pubblicano sul principale e si de-sottoscrivono a vicenda
nel sotto-DEN, il cui canale audio resta di fatto inutilizzato per la durata del turno. Il gruppo è
temporaneamente fuso nell'audio del DEN principale pur restando distinto a livello logico.

**Conseguenza da gestire: chi ha la parola perde il canale privato.** Il microfono è uno solo:
tutto ciò che dice diventa pubblico. Rischio concreto — un gruppo che riceve la parola e continua a
consultarsi tra sé davanti a tutti senza rendersene conto; con il sotto-DEN intero il problema si
moltiplica per otto.

**Soluzione ratificata: il microfono è per stanza, non globale.**
Lo stato del microfono appartiene alla **connessione**, non all'utente. Con due contesti audio
servono due interruttori: uno per il DEN principale, uno per il sotto-DEN. Chi ha la parola può
quindi **abbassare il microfono pubblico e tornare a parlare solo al gruppo senza perdere il
turno** — l'equivalente di appoggiare il microfono senza restituirlo, senza che il creator debba
intervenire.

Non è una funzione nuova: è il muto già esistente, reso per stanza anziché globale. Il client è
già connesso a due stanze e pubblica su ciascuna in modo indipendente: sono due flag invece di uno
derivato.

Nota sulla leggibilità: **gli stati udibili restano due** — o mi sente il gruppo, o mi sentono
tutti. Il terzo non è un pubblico diverso, è solo la possibilità di passare dall'uno all'altro.
La domanda *"chi mi sente adesso"* resta binaria.

**In alpha:** la connessione è una sola, quindi in pratica non cambia nulla; cambia solo la forma
del modello — vedi vincolo 8 del §8.

**Sonda esperienziale: prova il podcast, non il DEN dal vivo** — provare il DEN dal vivo richiede
cinque o sei persone contemporaneamente, impossibile in alpha con due persone alternate.

---

## 8. Vincoli di predisposizione — obbligatori in alpha

Quasi gratuiti ora, costosi dopo. Da rispettare anche se la funzione non esiste ancora.

1. **Il diritto di parlare è separato dal posto sul palco.** Due attributi distinti, mai un solo
   booleano. Prerequisito di 8+8, microfono al pubblico, sotto-DEN che riceve la parola.
2. **La capienza del palco è una proprietà della stanza**, non la costante 8.
3. **I permessi devono poter cambiare a stanza aperta**, aggiornati lato server. Se cristallizzati
   nel token all'ingresso, ogni promozione richiede una riconnessione — un buco udibile.
4. **Gli eventi di mute e blocco vengono riportati al Servizio** (la moderazione calcolata ne ha
   bisogno). Aggiungerlo dopo richiede un aggiornamento dell'App su ogni dispositivo.
5. **Lo schema prevede da subito:** visibilità, proprietario, admin (1→n), genitore, tipo di DEN
   (incluso `creator`), lingua dichiarata del DEN, identificativo utente stabile, **identificativi verificabili separati**
   (telefono, email), tipo di account, consenso versionato, impronta HMAC.
6. **Le capacità dell'utente sono dati, non rami di codice** (§10.4).
7. **Il profilo di qualità audio è un attributo di chi pubblica**, derivato dalle capacità (§10.4).
8. **Lo stato del microfono appartiene alla connessione, non all'utente.** Mai un unico flag
   globale "sto parlando": va modellato per stanza. In alpha la connessione è una sola e non
   cambia nulla in pratica, ma la forma dev'essere questa fin da subito — con i sotto-DEN servono
   due interruttori indipendenti (§7).

**Fissate il 22 ottobre**, dalle ipotesi IP-4 e IP-3: la **lingua dichiarata del DEN** come campo
dello schema (spec 012); la **notifica fissa di Android** con i pulsanti "spegni il microfono" ed
"esci" (spec 028). Dallo schermo bloccato il microfono si spegne, mai si accende.

**Non serve predisporre:** coda, alzata di mano, inviti, funzioni creator, algoritmo di
moderazione, pagamenti. Poggiano su questi punti senza modificarli.

---

## 9. Questioni aperte — nessuna blocca l'inizio

Campi esatti di profilazione · termine del testo in produzione · N mesi di conservazione di audio e
testi nella fase di test (§6) · età minima definitiva, 18 o 16 (§3) · fin dove usare la
profilazione per partner e sponsorizzate, da approfondire a parte · fornitore della copia esterna
dei backup, che sceglie la chat di sviluppo (ADR-024) · macchina di registratore e trascrittore, che
sceglie il socio dopo il banco di prova (ADR-027) · motore di trascrizione: modello aperto o servizio
esterno, quest'ultimo solo dopo la verifica del legale (banco di prova) · backup della macchina del
registratore e chiave del volume cifrato: chat di sviluppo con il socio (§6) · nome visibile del
sotto-DEN, che propone il prototipatore.

**Risolte il 10 novembre:**
- dove si trascrive → sul server, in differita (ADR-027);
- tempo massimo dell'audio su disco → 72 ore, dalla produzione; fino ad allora non si cancella nulla
  (§6);
- modello che legge i testi per moderare e profilare → in locale, su una macchina dedicata (§6);
- revisione umana dei casi segnalati → fa parte dell'elaborazione: era già deciso il 22 ottobre (§6);
- vendita di analisi ricavate dalle conversazioni → resta tra le cose da non fare (§10.3).

**Risolte il 22 ottobre:**
- chi rifiuta il consenso → resta ascoltatore (§3, §6);
- nickname → obbligatorio, anche ripetibile (§3);
- versionamento API → `/v1` nel percorso da subito (§2);
- comportamento offline → l'ultimo elenco DEN noto, segnato come non aggiornato (§2);
- chi crea i DEN in alpha → solo noi: DEN pre-creati;
- lingua dell'alpha → solo italiano, con i testi predisposti per le altre lingue;
- destinazione dei backup → nell'alpha Contabo, la copia esterna prima della beta (ADR-024);
- push iOS senza account Apple → superata: l'account Apple c'è;
- accesso con Google o Apple per i soli ascoltatori → sì, dopo l'alpha (§3);
- chi è bannato come partecipante → secondo la gravità (§3);
- abbonamento dell'ascoltatore → sì, senza verificare il numero (§3, §10).

---

## 10. Monetizzazione — sintesi (dettaglio in `BA_Tipologie_Account.md`)

**Nulla di questo è in alpha.** Serve conoscerlo ora solo per i vincoli di predisposizione (§10.3).

### 10.1 · Livelli e prezzi

**I livelli riguardano i partecipanti** (§3). L'ascoltatore è gratuito, ma può abbonarsi senza
verificare il numero: niente pubblicità e contenuti dei creator. Per parlare serve comunque il
numero.

**FREE** (livello dell'alpha) · **PAGANTE** 4,99 €/mese o 39,99 €/anno · **CREATOR** gratuito in
avvio, prezzo da definire quando ci saranno numeri.
**10 novembre (catalogo dei servizi):** il PAGANTE si chiama **Pro** ed è **un solo abbonamento**:
chi lo compra da ascoltatore toglie la pubblicità, e verificando il numero parla anche. Scala
ipotizzata: ascoltatore con pubblicità, Free che parla con pubblicità, Pro senza, Creator. Come BA
guadagna dai creator resta da decidere; il B2B è rinviato alla v2.
Vendita via **acquisto in-app con Small Business Program** (commissione 15% sotto il milione di
dollari annui). Nessun pagamento esterno finché non ci sono volumi: in UE il quadro DMA è a più
livelli e cambia di trimestre in trimestre.

Motivazione dei prezzi: tra 2,99 e 4,99 la conversione cambia poco — l'attrito è la decisione di
pagare, non l'importo — e l'annuale riduce l'abbandono. Il creator gratuito in avvio perché nei
mercati a due lati si sussidia il lato scarso, e all'inizio i creator **sono** il lato scarso.

### 10.2 · Confermato

- **Coda:** code multiple e notifica push **free**; sotto-DEN d'attesa e conservazione del posto
  **a pagamento**. Nessuna precedenza acquistabile.
- **Qualità:** si vende la **trasmissione** in alta qualità (ai creator), mai l'ascolto. In una
  stanza condivisa la qualità è una proprietà di chi pubblica: se un free parla a 24 kbps, tutti lo
  sentono a 24 kbps.
- **Following e DEN programmati:** gli utenti seguono un creator e vengono avvisati quando va in
  onda; un DEN può essere creato con orario di inizio, per pre-allertare e mettere in attesa. Riusa
  il meccanismo "attesa + notifica" già in costruzione: cambia solo il fatto scatenante.
- **Pubblicità e limite di permanenza:** rinviati, vedi §10.3.

### 10.3 · Vincoli e criticità aperte

**Contenuti multimediali dei creator — bloccante per quella funzione.** Ritrasmettere musica dai
nostri server è verosimilmente comunicazione al pubblico e richiede licenze; la manleva sul creator
è necessaria ma **non protegge verso i titolari dei diritti**. Ammesso solo per contenuti di cui il
creator è titolare, tramite fornitori licenziati, o con riproduzione client-side. → documento
legale §1.

**Espulsione a 60 minuti — in revisione.** Nessuna difficoltà tecnica (i tempi arrivano dai webhook,
l'espulsione è una chiamata API), ma cinque comportamenti da decidere: espulsione attiva lato
server perché la scadenza del token non chiude la sessione; preavviso e tolleranza per chi sta
parlando; rientro in fondo alla coda o no; l'attesa in DEN vuoto consuma il tempo o no; raffiche di
riconnessioni simultanee. **Criterio di attivazione: densità, non calendario** — solo quando le
stanze sono affidabilmente piene.

**Pubblicità — rinviata a fase 2.** Una conversazione dal vivo non si mette in pausa: o entri in
ritardo o perdi contenuto. Contraddice l'ingresso morbido. L'inventario per poche migliaia di
utenti vale quasi zero.

**Accesso ai DEN creator — aperta.** Accesso libero in qualità normale con alta qualità a pagamento
(raccomandata), oppure DEN interamente a pagamento. Da decidere insieme al modello di ricavo e alla
quota per i creator. Terza via emersa: **eventi a biglietto** sui DEN programmati.

**Da non fare:** precedenza in coda a pagamento; alzare il limite di 8 sul palco; vendere analisi
ricavate dalle conversazioni. Sull'ultimo punto (confermato il 10 novembre): resta vietato e se ne
parlerà a parte; è un'informazione, senza effetti su sviluppo e pubblicazione.

### 10.4 · Cosa predisporre in alpha (costa quasi nulla)

- **Capacità come dati, non come rami di codice.** Livello sul record utente + tabella di capacità
  (**può parlare**, durata massima, pubblicità sì/no, profilo di qualità, può creare DEN creator,
  funzioni di coda).
- **Contabilità di sessione per utente e per DEN** — già disponibile dai webhook di presenza.
- **Profilo di qualità audio derivato dalle capacità**, applicato in pubblicazione.
- **Tipo di DEN esteso a `creator`**, e **stato "programmato" con orario di inizio** nella macchina
  a stati: un DEN deve poter esistere prima di essere vivo.
- **Relazione di following** prevista nello schema (persone, non contenuti: compatibile con
  l'effimero).
- **La pubblicità non richiede lavoro sul media:** è riproduzione client-side di un file prima del
  join, non un'iniezione nella stanza.
- **Entitlement con origine e scadenza** (apple / google / promo), validazione ricevute lato
  Servizio. Mai un booleano "pagante".
- **Astrazione "sorgente di contenuto"** con attributo di provenienza e licenza: compatibile con
  tutte le strade di §10.3 senza vincolarci a una.
