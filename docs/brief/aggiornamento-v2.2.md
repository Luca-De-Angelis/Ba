# Aggiornamento del brief dopo la call (v2.2)

6 novembre 2026

La call con gli stakeholder ha cambiato tre cose di fondo: BA avrà una dimensione sociale, una home ricca di DEN e contenuti, e l'ascolto condiviso di podcast e musica. Questo documento aggiorna il brief v2.1 senza riscriverlo: dice cosa cambia, sezione per sezione, e cosa resta aperto. **Dove i due testi divergono, vale questo.** Le decisioni sono in `docs/DECISIONS.md` (D-011…D-018 vengono dalla call).

## Cosa cambia nel brief, sezione per sezione

| § | Oggi il brief dice | Con la v2.2 |
| --- | --- | --- |
| 1 · Cos'è BA | "Tutto è effimero: nessuna conversazione viene registrata o riascoltata" | Nessuna conversazione si può riascoltare. La voce di chi parla si salva per poco tempo, solo per trascriverla, poi si cancella; il testo resta per un periodo. Per chi usa l'app non esiste alcun archivio. La trascrizione non avviene più sul telefono |
| 2 · Il tempo è solo adesso | Unica eccezione: i DEN programmati di un creator | Le eccezioni sono i DEN programmati da ogni utente (D-016) e dalle radio (D-018). Guardano sempre avanti, mai indietro |
| 3 · Spotify | Il contenuto è protagonista; in BA è un pretesto per stare insieme | Resta vero anche con podcast e musica (D-017): si ascoltano insieme, in un DEN. La home somiglia a Spotify nella ricchezza e nell'organizzazione, non nel catalogo da ascoltare da soli |
| 4 · Vincoli | Il device più stretto è un iPhone di 4+ anni | La baseline è 360 dp (Android), più stretta dei 375 pt di un iPhone: progettare per 360 copre entrambi (D-022). Il tablet in verticale è supportato dalla beta 1 (D-020) |
| 5.A · Accesso | Codice SMS, poi termini e privacy (necessari) e trascrizione e profilazione (rifiutabile) | Si aggiunge l'onboarding al primissimo accesso, con l'avviso su voce e testo (D-013). Rifiutare il secondo consenso significa restare ascoltatore: si ascolta, non si parla |
| 5.A · Elenco DEN | I DEN disponibili, vivi o vuoti | Diventa la home (D-015): sezioni con DEN dal vivo, DEN programmati e suggerimenti su misura. Nell'alpha resta l'elenco |
| 5.A · Impostazioni | Interruttore della trascrizione | Al suo posto, "Torna ascoltatore": chi revoca il consenso non parla più e, se sta parlando, esce dalla stanza |
| 5.B · Profilo creator | Seguire un creator, avvisi, DEN programmati | Le connessioni (D-014) e i DEN programmati (D-016) diventano di tutti. Il profilo creator resta dopo la versione 1 |
| 5.B · Nuove voci | — | Home (D-015), connessioni (D-014), ascolto condiviso (D-017), DEN delle radio (D-018): da non precludere finché non sono fissati i rilasci |
| 6 · Stati critici | Elenco del brief v2.1 | Si aggiunge "ascoltatore che vuole salire": per parlare deve diventare partecipante, e l'avviso su voce e testo va ripetuto in quel momento |
| 6 · Stati ordinari | Elenco del brief v2.1 | Si aggiunge "contenuto in riproduzione": si abbassa da solo quando qualcuno parla |

## Principi: cosa resta e cosa cambia

I quattro principi del brief restano. Due si allargano, e per ciascuno c'è un confine da non superare.

- **L'app è per lo più non guardata.** Invariato. La home più ricca non deve far diventare BA un'app da scorrere: una volta dentro un DEN, l'interfaccia torna a sparire.
- **Il pubblico è il contenuto.** Invariato. Le connessioni non diventano status: nessun numero di connessioni visibile, nessun segno di chi ne ha di più. Anche le radio sono partecipanti di una conversazione, non emittenti davanti a un pubblico passivo.
- **Il tempo è solo adesso.** Si allarga: oltre al DEN in corso esistono i DEN programmati da chiunque. Il confine: si guarda avanti, mai indietro. Nessun archivio, nessuna cronologia, niente da riascoltare da soli.
- **L'ingresso è morbido.** Invariato. Entrare in un DEN dove ci sono le proprie connessioni non va annunciato.
- **L'identità.** È il punto che cambia di più. Il design assegna colore e forma per stanza, e colore e forma non identificano una persona fra una sessione e l'altra. Le connessioni richiedono invece una persona riconoscibile fuori dalla stanza: nome, eventuale foto, profilo. Proposta: la stanza resta com'è, e l'identità stabile vive nel profilo e nelle connessioni. Da decidere se nella stanza si riconosce chi è già una tua connessione.

## Domande aperte

| Domanda | Perché serve | Proposta |
| --- | --- | --- |
| In quale rilascio arrivano home, connessioni e ascolto condiviso? | Beta 1 è fra poche settimane; senza una data non si possono pianificare i task di design | Beta 2 o dopo; la beta 1 resta sulla stanza |
| Le radio sono nella versione 1, anche se i creator no? | Una radio che programma DEN è di fatto un creator organizzato | Chiarirlo prima di disegnare i DEN delle radio |
| Come si entra in connessione con una persona? | Cambia profilo, notifiche e privacy | Richiesta e accettazione reciproca, senza contatori; la rubrica del telefono solo se l'utente la condivide |
| Chi segue le licenze di podcast e musica? | Senza accordi BA non può riprodurre nella stanza contenuti di altri | Partire da contenuti portati da chi ne ha i diritti: podcaster con le loro puntate, radio con i loro programmi. Verifica del legale |
| La moderazione in differita può avere una corsia veloce? | Senza presidio umano, chi disturba dal palco resta in onda per minuti od ore | Una segnalazione fa analizzare subito all'AI gli ultimi minuti di quella stanza. Da verificare con Andrea |
| Resta la revisione umana dei secondi segnalati? | La sintesi tecnica la prevede; "tutta AI" la toglierebbe | Verifica del legale sulle decisioni prese solo da un sistema automatico |

### Rischi accettati

- **Moderazione in differita, senza presidio umano (D-011).** In una stanza pubblica, la sola difesa immediata è mutare chi disturba per sé.
- **Sostenibilità non verificata (D-012).** Il numero di 50.000 utenti attivi al mese resta un'ipotesi degli stakeholder.

### Note tecniche

- Il registratore della sintesi tecnica salva le tracce di chi parla: la traccia del contenuto condiviso va esclusa da registrazione e trascrizione.
- Suggerimenti su misura: chi parla viene profilato dalla trascrizione, l'ascoltatore no. Per lui servono altri segnali, come i DEN frequentati e le connessioni. L'uso della profilazione per i suggerimenti va dichiarato nei termini e nell'onboarding.
