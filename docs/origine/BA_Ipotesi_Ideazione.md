# BA — Ipotesi per la prossima fase di ideazione

**Origine.** Call di presentazione al prototipatore, 12 ottobre 2026. Le proposte emerse sono state
valutate e approvate **come ipotesi**: materiale per la prossima fase di ideazione, non decisioni.
Non modificano il perimetro dell'alpha né le specifiche di sviluppo. Quando un'ipotesi viene
confermata, entra nel registro delle decisioni.

**Aggiornamento del 20 novembre.** Nel catalogo dei servizi attivabili del 10 novembre queste
proposte compaiono con lo stato «Ipotesi IP-n» (le «ipotesi di ottobre»). Da allora valgono due
decisioni che toccano IP-4 e IP-5: le lingue di lancio sono l'italiano, poi l'inglese, e anche la
beta è a uso interno (registro §1). Dove qui si legge «beta», quindi, si intende una fase con
decine di tester interni.

---

## Sintesi

<!-- widths: 8,30,44,18 -->
| # | Ipotesi | Forma approvata | Orizzonte |
|---|---|---|---|
| **IP-1** | Registrazione via email per chi ascolta | **Confermata il 22 ottobre** ed entrata nel registro (§3) | Alpha |
| **IP-2** | Pubblicità audio e abbonamento | Uscita, prima di entrare, durante l'ascolto con limiti. Esclusa all'apertura dell'app | Fase 2 |
| **IP-3** | Controlli a schermo bloccato e widget | Controllo della sessione e presenza a colpo d'occhio | Beta; la notifica Android già nell'alpha |
| **IP-4** | Lingua del DEN | Dichiarata alla creazione e rilevata dalla conversazione | Beta; la lingua dichiarata già nello schema |
| **IP-5** | Categoria "lingue" | Scambio linguistico gratuito. Escluso il tutor a pagamento | Beta |

---

## IP-1 · Registrazione via email per chi ascolta

**Confermata il 22 ottobre 2026** ed entrata nel registro delle decisioni (§3), già per l'alpha.
Rispetto alla forma qui sotto cambia una condizione: chi ascolta accetta solo termini e privacy.

**Proposta.** Chiedere la verifica del numero via SMS solo a chi vuole parlare. Chi ascolta soltanto
può registrarsi con l'email.

**Forma approvata.** Due livelli di account.

- **Ascoltatore**: registrazione con **codice via email**, non con link di attivazione. Il link si
  apre nell'app di posta o nel browser, a volte su un altro dispositivo; il codice riusa la stessa
  schermata dell'SMS.
- **Partecipante**: numero di telefono verificato. **"Può parlare" diventa una capacità** che si
  sblocca con la verifica, coerente con il principio che le capacità sono dati.

"Solo ascolto" significa **nessuna voce, da nessuna parte**: niente palco, sotto-DEN, alzata di mano
o creazione di DEN. Al primo tentativo parte la verifica del numero.

**Perché.** Il primo contatto con BA è l'ascolto, e il numero di telefono è la barriera d'ingresso
più alta. Chiederlo quando la persona vuole parlare arriva nel momento in cui il valore è evidente.

**Conseguenza accettata.** Chi è bloccato può aprire un account email e tornare ad ascoltare i DEN
pubblici di chi l'ha bloccato. È accettabile, perché un DEN pubblico è pubblico per definizione; i
DEN privati restano protetti.

**Condizioni.**

- **I segnali di moderazione pesano secondo il livello di verifica.** Senza questa regola, molti
  account email creati apposta potrebbero bloccare o mutare in massa una persona e affossarne la
  reputazione.
- **Per i creator contano solo gli ascolti di account verificati**, altrimenti i numeri si gonfiano
  a costo zero.
- **Play Integrity e App Attest** diventano necessari dal giorno in cui si apre la registrazione via
  email.
- *Superata il 22 ottobre:* i due consensi per tutti. Chi ascolta accetta solo termini e privacy.

**Punto critico per il design.** La richiesta "verifica il numero per parlare" diventa il punto di
conversione più importante dell'app, perché separa chi ascolta da chi partecipa ai sotto-DEN, dove
BA si distingue.

**Domande chiuse il 22 ottobre.** Accesso con Google o Apple per i soli ascoltatori: sì, dopo
l'alpha. Chi è bannato come partecipante: dipende dalla gravità, e nei casi lievi resta ascoltatore.

---

## IP-2 · Pubblicità audio e abbonamento

**Proposta.** Pubblicità audio per gli utenti free in più momenti; un abbonamento senza pubblicità
con alcuni ascolti di creator a pagamento inclusi.

**Forma approvata.**

<!-- widths: 24,22,54 -->
| Collocazione | Per chi | Condizioni |
|---|---|---|
| **All'uscita dal DEN** | Free | La meno invasiva: non interrompe nulla |
| **Prima di entrare** | Free | Limite di frequenza (uno spot ogni 10 minuti). **Mai dopo il tocco su una notifica**: la notifica serve a portarti dentro mentre qualcuno parla |
| **Durante l'ascolto** | Solo account email (IP-1) | **Mai nei DEN dei creator**. Mai con il microfono aperto, dentro un sotto-DEN o con la parola |
| All'apertura dell'app | — | **Esclusa**: spesso si apre l'app solo per vedere chi c'è, e un audio che parte da solo è ostile |

Ne risulta una scala coerente: **chi ascolta con l'email sente più pubblicità, chi verifica il
telefono meno, chi paga nessuna.**

**Abbonamento.** Nessuna pubblicità e un numero di ascolti di creator a pagamento inclusi. È coerente
con gli eventi a biglietto sui DEN programmati.

**Vincoli.**

- **La pubblicità non si profila sul contenuto delle conversazioni**, al massimo sul tema del DEN.
  Usare le trascrizioni per il marketing richiederebbe un consenso apposito e sarebbe il danno di
  fiducia peggiore possibile.
- La pubblicità deve essere riconoscibile come tale.
- **Durante l'ascolto la conversazione continua e quel pezzo si perde per sempre**, perché BA non
  offre il riascolto. Prima di estenderla va misurato l'effetto su chi ascolta con l'email.
- Sotto una certa scala lo spazio pubblicitario rende pochissimo: è un'ipotesi per quando ci saranno
  numeri importanti.

**Alternative da valutare.** **DEN sponsorizzati**, con una frase all'ingresso come alla radio.
**Annunci letti dal creator**, il formato che rende di più nei podcast perché fa parte del contenuto
invece di interromperlo.

**Domande aperte.** Cos'è un "ascolto di creator" incluso: un evento, un'ora? Cosa succede agli
ascolti non usati: scadono o si accumulano? Quale quota va ai creator: se BA paga i creator, si
applica quanto già segnalato nel documento legale (§7). Il prezzo dell'abbonamento resta 4,99 €/mese
anche con gli ascolti inclusi?

---

## IP-3 · Controlli a schermo bloccato e widget

**22 ottobre:** la notifica Android con i pulsanti è entrata nello sviluppo (spec 028). Il resto
resta un'ipotesi per la beta.

**Proposta.** Un widget nativo iOS e Android, in stile Spotify, visibile a schermo bloccato, con
azioni dirette.

**Forma approvata.** Due superfici con scopi diversi.

- **Controllo della sessione** mentre si è in un DEN. Su iOS una *Live Activity*, sullo schermo
  bloccato e nella Dynamic Island. Su Android la notifica fissa, già obbligatoria per tenere il
  microfono attivo in background, resa utile con delle azioni. Contenuto: nome del DEN, quante
  persone ci sono, stato del microfono, eventuale parola concessa. Azioni: spegni il microfono, esci.
- **Presenza a colpo d'occhio** quando non si è in un DEN: un widget con chi è in onda tra le persone
  seguite e i DEN programmati in partenza. È un buon motivo per tornare nell'app.

**Perché.** È il primo principio di design, "l'app è per lo più non guardata", applicato fino in
fondo: lo schermo bloccato è dove l'utente passa la maggior parte del tempo.

**Vincoli di sicurezza.**

- **Dallo schermo bloccato il microfono si può spegnere, mai accendere.** Un tocco in tasca non deve
  aprirlo.
- **Niente comandi multimediali standard.** Chi preme "pausa" mentre è sul palco crede di essersi
  fermato, ma il microfono continua a trasmettere.
- "Chi sta parlando" in tempo reale non si riporta sullo schermo bloccato: il sistema limita la
  frequenza degli aggiornamenti. Meglio stati stabili.

**Costo.** Serve codice nativo oltre a Flutter (Swift per iOS, Kotlin per Android). Materia per la
beta, tranne la notifica Android, già necessaria nell'alpha.

---

## IP-4 · Lingua del DEN

**22 ottobre:** la lingua dichiarata è entrata nello schema (spec 012). La rilevazione resta
un'ipotesi per la beta.

**Proposta.** La lingua come attributo del DEN: impostata alla creazione (facoltativa, informativa,
non vincolante) e rilevata dalla trascrizione, in base a chi ha parlato negli ultimi minuti.

**Forma approvata.**

- **Lingua dichiarata**, precompilata con la lingua dell'app di chi crea il DEN e modificabile.
- **Lingua rilevata**, calcolata sugli ultimi N minuti e pesata sul tempo di parola di ciascuno.
- Nell'elenco si mostrano **fino a due lingue**, perché un DEN può essere misto.

**Vincolo tecnico.** La trascrizione deve conoscere la lingua *prima* di trascrivere, e non tutti i
motori la riconoscono da soli: Whisper sì, i riconoscitori del sistema operativo in genere lavorano
su una lingua indicata in partenza. In pratica si parte dalla lingua dichiarata del DEN e dalle
lingue di chi parla, e la rilevazione corregge.

**Perché la lingua dichiarata conta più di quanto sembri.** In un DEN vuoto, lo stato più frequente,
è l'unica informazione disponibile per chi decide se restare in attesa.

**Privacy.** Per chi ha rifiutato la trascrizione vale solo la lingua dichiarata. Se anche la sola
rilevazione della lingua richieda il consenso è una domanda per il DPO.

**Tocca.** Il matchmaking, dove la lingua è il filtro principale; l'elenco dei DEN, con l'etichetta
di lingua.

---

## IP-5 · Categoria "lingue": scambio linguistico gratuito

**Proposta.** Una categoria per parlare con qualcuno in un'altra lingua, per imparare o migliorare,
eventualmente anche a pagamento.

**Forma approvata.** **Categoria gratuita**, pensata per generare flusso audio: lo scambio
linguistico (io ti aiuto con l'italiano, tu mi aiuti con l'inglese). Si innesta su "disponibile a
chiacchierare" con il filtro lingua di IP-4.

**Escluso.** Il tutor a pagamento come servizio a sé, con prenotazioni, rimborsi e pagamenti ai
tutor: le implicazioni economiche e di rimborso non valgono lo sforzo. L'unica strada ammessa è
quella di ogni creator: chi insegna usa gli strumenti normali (DEN programmati, eventi, ascolti
inclusi nell'abbonamento), senza un sistema separato.

**Vincoli.**

- **Niente gamification.** Le app per le lingue vivono di serie di giorni consecutivi e punteggi,
  esattamente ciò che il principio "il tempo dell'app è solo adesso" esclude.
- **Dipende dalla politica sui minori.** Conversazioni uno a uno con sconosciuti, in una categoria
  che attira molti ragazzi: è lo schema di interazione più delicato per la tutela dei minori, anche
  quando è gratuito. Va affrontato dopo le decisioni del documento legale (§2).

**Nota per il futuro.** Se si riaprisse il pagamento per lezioni individuali: le regole Apple
consentono di incassare fuori dall'acquisto in-app, quindi senza commissione Apple, solo i servizi
in tempo reale tra due persone. Con più partecipanti l'acquisto in-app è obbligatorio.

---

## Predisposizioni da riproporre al prossimo giro di orchestrazione

**Riproposte il 22 ottobre, come d'accordo, ed entrate tutte nello sviluppo.**

<!-- widths: 36,10,38,16 -->
| Predisposizione | Ipotesi | Perché conviene decidere presto | Spec |
|---|---|---|---|
| **Identità non legata al telefono**: identificativo proprio dell'utente, telefono ed email come identificativi verificabili separati, "può parlare" come capacità | IP-1 | **Superata il 22 ottobre:** con IP-1 confermata non è più una predisposizione ma un requisito della 011 | 011 · identità |
| **Lingua dichiarata del DEN** nello schema | IP-4 | **Fissata il 22 ottobre:** entra nella 012 | 012 · registro DEN |
| **Notifica Android con azioni** (spegni microfono, esci) | IP-3 | **Fissata il 22 ottobre:** entra nella 028 | 028 · ciclo di vita audio |

---

## Documenti da aggiornare se le ipotesi vengono confermate

<!-- widths: 34,66 -->
| Documento | Cosa cambia |
|---|---|
| Registro delle decisioni | Identità a due livelli (IP-1); lingua del DEN (IP-4) |
| Tipologie di account | Collocazioni della pubblicità e abbonamento con ascolti inclusi (IP-2) |
| Vincoli legali | Informativa per i due livelli di account; pubblicità; minori nello scambio linguistico |
| Brief di design e guida per il prototipatore | Accesso a due livelli; schermo bloccato e widget come superfici di design |

**Per IP-1 è fatto:** il 22 ottobre sono stati aggiornati registro, roadmap, audit, tipologie di
account, vincoli legali, brief di design e guida per il prototipatore.
