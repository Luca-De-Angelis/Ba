# BA — Tipologie di account e funzionalità

31 luglio 2026, aggiornato il 22 ottobre con il tipo di account ascoltatore, il 10 novembre
(vendita di analisi, §6) e il 20 novembre (Pro e abbonamento unico, §1) · Documento di lavoro. **Ricavi e prezzi definitivi sono in sospeso**; qui si fissano
struttura e funzionalità.

**Regola che governa tutto il documento:** si monetizza la **comodità** e la **capacità**, mai la
**posizione rispetto a un'altra persona**. Ciò che cambia il rapporto tra te e il sistema è
legittimo; ciò che ti mette davanti a qualcun altro no. È la traduzione economica del principio di
design *"la distinzione palco/pubblico è funzionale, non di status"*.

---

## 1. Tipo di account e livelli

| | **ASCOLTATORE** | **FREE** | **PAGANTE** | **CREATOR** |
|---|---|---|---|---|
| Costo | 0 | 0 | 4,99 €/mese · 39,99 €/anno | gratuito in avvio, poi da definire |
| Quando | **alpha** | **alpha** | beta | beta / produzione |
| Verifica | email con codice; dopo l'alpha anche Google o Apple | numero di telefono | come free | come free |
| Consensi | termini e privacy | termini e privacy, più registrazione dell'audio, trascrizione, profilazione e moderazione | come free | come free |
| Voce | **nessuna** | sì | sì | sì |

**L'ascoltatore non è un livello ma un tipo di account** (registro §3, decisione del 22 ottobre):
solo ascolto, senza voce. FREE, PAGANTE e CREATOR sono i livelli dei **partecipanti**. Chi ascolta e
vuole parlare verifica il numero e dà il consenso; chi non accetta resta ascoltatore. Un ascoltatore
può anche abbonarsi senza verificare il numero (22 ottobre): niente pubblicità e contenuti dei
creator; per parlare serve comunque il numero.

**Aggiornamento del 10 novembre** (catalogo dei servizi attivabili). Il PAGANTE si chiama **Pro**
ed è **un solo abbonamento**: chi lo compra da ascoltatore toglie la pubblicità, e verificando il
numero parla anche. Scala ipotizzata: ascoltatore con pubblicità, Free che parla con pubblicità, Pro
senza, Creator. Come BA guadagna dai creator resta da decidere; il B2B è rinviato alla v2. Nel
catalogo le funzioni di questo documento ancora da confermare hanno lo stato «Proposta di luglio»
(§2) o «Analisi ricavi» (§7).

Prezzi via acquisto in-app con Small Business Program (commissione 15% sotto il milione di dollari
annui). Nessun pagamento esterno finché non ci sono volumi.

---

## 2. Funzionalità per livello

### ASCOLTATORE — solo ascolto, già nell'alpha

| Funzione | Stato |
|---|---|
| Ascoltare i DEN pubblici, creator compresi, e i contenuti free | **confermata** |
| Mutare una voce, bloccare | **confermata** |
| Ricevere le sponsorizzate | **confermata**, quando arriverà la pubblicità (fase 2) |
| Attendere in un DEN vuoto, con notifica quando arriva qualcuno | **confermata** |
| Abbonarsi senza verificare il numero: niente pubblicità, contenuti dei creator | **confermata**, dalla beta |
| Voce: palco, coda, alzata di mano, sotto-DEN, creazione di DEN, DEN privati | **esclusa**: al primo tentativo parte la verifica del numero |

### FREE — il livello dei partecipanti nell'alpha

| Funzione | Stato |
|---|---|
| Creare DEN privati (solo su invito, solo palco, admin 1→n) | **confermata** |
| Creare DEN pubblici (visibili a tutti, palco 8 + coda) | **confermata** |
| Entrare, ascoltare, parlare, mutare una voce, bloccare | **confermata** |
| Coda verso il palco su più DEN contemporaneamente | **confermata** — free per scelta: genera traffico e contenuto |
| Notifica push quando si libera il posto (si può uscire dall'app) | **confermata** — free per scelta |
| Spunta "fammi entrare automaticamente" | **confermata**, con vincoli §4 |
| Sotto-DEN: crearli e parteciparvi | **confermata** |

**Restrizioni previste solo dalla beta o oltre** (nessuna in alpha):

| Restrizione | Stato |
|---|---|
| Permanenza massima 60 minuti per DEN, con rientro | **in revisione** — vedi §5 |
| Messaggio pubblicitario all'ingresso, valido 10 minuti | **rinviata a fase 2**, con app consolidata e numeri importanti |
| Trasmissione in qualità normale | **confermata** |

### PAGANTE — tutto il FREE, più:

| Funzione | Stato |
|---|---|
| Nessun limite di permanenza | confermata (dipende da §5) |
| Nessuna pubblicità | confermata (dipende dall'introduzione della pubblicità) |
| **Sotto-DEN mentre si è in coda** — chiacchierare con altri in attesa | **confermata** — il vero valore aggiunto, aggiunge invece di sottrarre |
| **Conservazione del posto** in caso di uscita breve (chiamata, cambio rete) | **confermata** |
| Accesso a eventuali contenuti a pagamento | da definire con il modello di ricavo |
| Ascolto in alta qualità dei DEN creator | **aperta** — vedi §3 |

### CREATOR — tutto il PAGANTE, più:

| Funzione | Stato |
|---|---|
| DEN creator (tipo distinto: **unico DEN pubblico con admin**) | **confermata** |
| Gruppi di ascoltatori e sotto-DEN organizzati | confermata |
| Dare e togliere la parola a persone o interi sotto-DEN (**8+8**) | confermata |
| Alzata di mano per richiedere la parola | confermata |
| Ban discrezionale sui propri DEN (uno o tutti) | confermata |
| **Trasmissione** in alta qualità | **confermata** — si vende la trasmissione, mai l'ascolto |
| Contenuti multimediali nella conversazione | **vincolata** — solo con i limiti di licenza (§6) |
| **Following**: gli utenti lo seguono e vengono avvisati quando è in onda | **confermata** |
| **DEN programmati** con orario di inizio e attesa anticipata | **confermata** |
| Analisi dei propri DEN (presenze, permanenza) | proposta — usa metadati già raccolti |
| Registrazione opt-in del proprio palco | prevista in v2 |

---

## 3. Questione aperta: qualità e accesso ai DEN creator

Due formulazioni sul tavolo, **da decidere insieme al modello di ricavo**.

**(a) Accesso libero in qualità normale, alta qualità a pagamento** — *raccomandata.*
Il creator mantiene tutto il suo pubblico e continua a costruirsi seguito; chi vuole la resa piena
paga. Tecnicamente: il client del creator pubblica **due tracce**, normale e alta qualità, e la
sottoscrizione dipende dalle capacità dell'utente. L'audio costa poca banda, quindi il doppio invio
è sostenibile e non richiede transcodifica sul server.

**(b) DEN creator accessibile solo ai paganti.**
Genera ricavo diretto da cui ricavare la quota del creator, ma **mura il pubblico** proprio mentre
si cerca di attrarre creator con la gratuità: i due meccanismi lavorano l'uno contro l'altro. È un
prodotto diverso — contenuto a pagamento anziché social — con difficoltà di avvio molto più alta.

**Terza via, emersa dall'analisi dei ricavi:** eventi a biglietto sui **DEN programmati**. Il
creator resta libero e gratuito per il quotidiano, e vende i singoli appuntamenti. Non mura il
pubblico e riusa una funzione già confermata.

---

## 4. Coda verso il palco — regole confermate

- La coda è dei partecipanti: l'ascoltatore non si mette in coda (§1).
- Free: **code multiple** su più DEN e **notifica push** mentre si aspetta.
- Pagante: **sotto-DEN d'attesa** e **conservazione del posto** in caso di uscita breve.
- **Nessuno scavalca nessuno.** La precedenza a pagamento è esclusa: contraddirebbe il principio di
  design e trasformerebbe BA in un posto dove si compra il diritto di parlare.

**Vincolo di sicurezza — vale anche con la spunta di ingresso automatico attiva:**
si entra **sempre con microfono spento**. La spunta riguarda l'*occupare il posto*, non il
*trasmettere*: l'utente l'ha attivata venti minuti prima e nel frattempo può essere al supermercato
o in auto con altri. Stato ben visibile ("sei sul palco, tocca per parlare"); se non attiva il
microfono entro N minuti, il posto passa al successivo. **La spunta vale per singolo DEN e per la
sessione**, non come impostazione globale permanente.

---

## 5. Limite di permanenza — in revisione

Nessuna difficoltà tecnica: i tempi arrivano dai webhook di presenza e l'espulsione è una chiamata
all'API del media server. Le complicazioni sono di comportamento, e vanno decise prima di
implementare:

- il token scade ma **non chiude la sessione in corso**: serve un'espulsione attiva lato server;
- chi viene espulso **mentre parla** subisce un taglio a metà frase → preavviso e tolleranza;
- chi rientra torna in fondo alla coda? Sarebbe punitivo;
- l'attesa in un DEN vuoto **consuma** il tempo? Presumibilmente no;
- espulsioni simultanee generano raffiche di riconnessioni.

**Criterio di attivazione:** solo quando le stanze sono affidabilmente piene e c'è coda. La densità
di presenza è la metrica di sopravvivenza del prodotto, e questo meccanismo rimuove persone dalle
stanze. Prima della densità costa retention senza portare ricavi.

---

## 6. Funzionalità dubbie — da decidere consapevolmente

Elencate perché **esistono e vanno valutate**, non perché siano raccomandate.

| Funzione | Perché è dubbia | Posizione |
|---|---|---|
| **Precedenza in coda a pagamento** | Contraddice il principio palco/pubblico funzionale e non di status | **esclusa** — sostituita dalle opzioni §4 |
| **Donazioni durante la diretta** | È il modello che genera più ricavi nell'audio live al mondo. Ma crea **gerarchia comprabile**: chi dona ottiene visibilità e attenzione dal palco. Riscriverebbe la cultura del prodotto | **da decidere** — praticabile solo in forma sobria: donazione privata, senza classifiche né effetti visibili |
| **Pubblicità audio** | In una conversazione dal vivo non si può mettere in pausa: o entri in ritardo o perdi contenuto. Contraddice l'ingresso morbido | **rinviata a fase 2** |
| **Contenuti multimediali dei creator** | Ritrasmettere musica dai nostri server richiede licenze. La manleva sul creator non protegge verso i titolari dei diritti | **vincolata** — vedi documento legale §1 |
| **DEN creator solo a pagamento** | Mura il pubblico del creator mentre si cerca di attrarne | **aperta** — vedi §3 |
| **Reputazione che limita l'accesso** | Ricade nella decisione automatizzata: richiede informativa specifica e intervento umano | **da istruire** — documento legale §3 |
| **Vendita di analisi aggregate** ricavate dalle conversazioni | Anche anonimizzata, è ricavata da conversazioni private: il danno di fiducia quando emerge è sproporzionato rispetto al ricavo | **vietata** (registro §10.3, confermato il 10 novembre): se ne parlerà a parte, senza effetti su sviluppo e pubblicazione |
| **Alzare il limite di 8 sul palco** per i creator | È una costante di qualità della conversazione, non un vincolo tecnico | **sconsigliata** |

---

## 7. Direzioni di ricavo — analisi, decisione sospesa

A 10.000 utenti attivi nessun modello consumer produce cifre significative (abbonamento: 850–4.200
€/mese secondo la conversione). **La metrica che conta non è il numero di iscritti ma quante persone
sono contemporaneamente presenti e per quanto tempo.**

| Direzione | Ordine di grandezza a 50k utenti | Nota |
|---|---|---|
| Abbonamento consumer | ~8.500 €/mese (conv. 4%) | Pulito, non degrada nulla |
| **Eventi a biglietto** | ~24.000 €/mese (300 eventi) | Non mura il pubblico del creator; riusa i DEN programmati |
| **B2B / organizzazioni** | ~10.000 €/mese (50 clienti) | Ricavo più alto per unità, nessuna commissione store, non tocca l'esperienza consumer |
| **Matchmaking premium** | — | Il ciclo "disponibile a chiacchierare" è strutturalmente quello delle app di incontri, che convertono il 5–15% contro il 2–5% delle app di contenuto |
| Pubblicità | in tabella ~36.000 €/mese, **nella realtà iniziale un terzo o meno** | Il fattore limitante è il riempimento dell'inventario, non il CPM: i circuiti hanno soglie minime |
| Donazioni | molto variabile | Vedi §6 |

**Da decidere insieme:** modello di ricavo principale, quota ai creator, e di conseguenza la
questione §3.
