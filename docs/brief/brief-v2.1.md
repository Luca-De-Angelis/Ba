**BA — Brief di design (UI/UX)**

Versione 2.1

Documento riservato · ottobre 2026

**Come leggerlo.** Il §5 distingue **ciò che va progettato ora** (alpha) da **ciò che va solo non precluso** (beta). Il modello completo è qui perché una stanza disegnata senza sapere che esistono i sotto-DEN va rifatta da capo; ma progettare in alta fedeltà funzioni della beta è lavoro sprecato. Modello completo dichiarato, alpha in dettaglio, resto a livello di concetto.

**1. Cos'è BA**

Un social **vocale** basato sulla presenza. Le persone entrano in **DEN**: spazi vocali dove un **palco di massimo 8 persone parla** e un pubblico ascolta. Chi ascolta può mettersi in coda per salire. Claim: **"La Live sei tu"** — la live non è il contenuto, è chi lo fruisce insieme.

Tutto è **effimero per scelta**: nessuna conversazione viene registrata o riascoltata. Non esistono archivi né cronologie.

Dentro un DEN possono esistere **sotto-DEN**: gruppi fino a 8 persone che ascoltano il DEN principale e nel frattempo parlano tra loro. Un creator può **dare la parola** a una persona o a un intero sotto-DEN.

**La parola è additiva, non è un cambio di stanza.** Chi la riceve resta nel proprio gruppo, ma la sua voce viene *aggiunta* al DEN principale: da quel momento lo sentono sia il suo gruppo sia tutti gli altri, esattamente come chiunque sia sul palco. **Conseguenza cruciale per il design: chi ha la parola non ha più un canale privato.** Il microfono è uno solo, e tutto ciò che dice è pubblico.

**2. La tesi di design**

**L'app è per lo più non guardata.** Si usa a schermo spento, in tasca, camminando, al buio a letto, mentre si fa altro. Ogni scelta deve reggere l'ipotesi *"l'utente non sta guardando"*. Il compito dell'interfaccia non è intrattenere: è rendere leggibile la presenza in mezzo secondo d'occhiata, e poi sparire. **Corollario nuovo:** gli stati critici — microfono aperto o chiuso, chi ti sente — non possono affidarsi solo alla vista. Suono e feedback aptico sono parte del design.

**Il pubblico è il contenuto.** "La Live sei tu" significa che non c'è una star al centro. La distinzione palco/pubblico è **funzionale** (chi ha il microfono acceso), non di status. Il design non deve creare un podio né far sentire chi ascolta una comparsa. **Vale anche per i livelli a pagamento:** un abbonato non deve apparire superiore, solo attrezzato meglio.

**Il tempo dell'app è solo adesso.** Niente cronologie, archivi, badge accumulativi, contatori di follower in evidenza, "streak". Unica eccezione: i **DEN programmati** di un creator, che guardano avanti (un appuntamento), non indietro (un archivio).

**L'ingresso è morbido.** Si entra in un DEN senza essere annunciati: nessun suono, nessuna animazione trionfale, nessun "X è entrato". Requisito di prodotto, non preferenza estetica.

**3. Cosa BA non deve sembrare**

- **Clubhouse** — simile in superficie (stanze, palco, mani alzate) ma costruita sullo status e su chi è famoso. È il riferimento da cui prendere le distanze più consapevolmente.

- **Broadcast / Twitch** — un emittente e un pubblico passivo. In BA il pubblico è metà del punto. Vale anche per le funzioni creator: restano conversazione, non spettacolo.

- **Discord** — il testo è primario. BA è l'inverso: **non esiste chat testuale** nelle stanze, e nulla deve farne le veci.

- **Spotify e simili** — il contenuto è protagonista. In BA è un pretesto per stare insieme.

**4. Vincoli tecnici**

- **Flutter** (iOS + Android, una sola base di codice). Non serve aderire a Material o Cupertino: serve un'identità propria, implementabile con widget standard.

- **I valori diventano token.** L'output confluisce in un unico tokens.dart: serve una scala definita, non valori arbitrari schermata per schermata.

- **Prima il tema scuro.** Uso serale e notturno prevalente.

- **Schermi piccoli inclusi**: il device più stretto è un iPhone di 4+ anni.

- **Uso a una mano**: azioni primarie nella metà bassa dello schermo.

- **Cinque lingue** (IT, EN, FR, ES, DE): il tedesco allunga le etichette anche del 30%.

- **Accessibilità**: contrasto almeno AA, aree toccabili ≥ 44 pt, screen reader. Un'app audio-first attira anche utenti non vedenti: non è un requisito teorico.

- **Parsimonia nelle animazioni**: mentre gira l'audio in tempo reale il movimento continuo compete con CPU e batteria. Otto indicatori che pulsano sempre sono otto animazioni permanenti.

**5. Le schermate**

**A · Da progettare ora (alpha)**

| **\#** | **Schermata**    | **Cosa contiene**                                                                                                                                                      |
|--------|------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1      | **Accesso**      | Verifica del **numero di telefono** (codice via SMS). Poi **due accettazioni separate**: termini e privacy (necessaria) e trascrizione/profilazione (**rifiutabile**). |
| 2      | **Elenco DEN**   | I DEN disponibili con stato: vivo (quante persone, chi parla) o vuoto.                                                                                                 |
| 3      | **Stanza DEN**   | Il cuore: palco fino a 8, pubblico, chi parla, sali/scendi, muta una voce, blocca, esci.                                                                               |
| 4      | **Attesa**       | DEN vuoto in cui si resta per essere avvisati quando arriva qualcuno.                                                                                                  |
| 5      | **Impostazioni** | Lingua, permessi, interruttore trascrizione, **lista utenti bloccati**, esci.                                                                                          |

La **stanza DEN** è la schermata su cui concentrare l'esplorazione: se funziona quella, il resto segue.

**B · Da non precludere (beta e oltre)**

Non progettarle in dettaglio. Servono perché le scelte di layout della stanza devono poterle accogliere senza essere rifatte.

| **\#** | **Schermata**                      | **Cosa deve poter accogliere**                                                                                                                                         |
|--------|------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 6      | **Coda verso il palco**            | Lista d'attesa quando il palco è pieno, anche su più DEN insieme; si sale **con il microfono spento**. Fuori dall'alpha: con pochi tester il palco non si riempie mai. |
| 7      | **Sotto-DEN**                      | Un gruppo ≤8 dentro un DEN: senti il DEN principale **e** parli col tuo gruppo. La stanza deve avere un posto dove questo secondo contesto possa comparire.            |
| 8      | **Alzata di mano**                 | Chiedere la parola; stato "richiesta in attesa"; accolta o no.                                                                                                         |
| 9      | **Dare la parola** (vista creator) | Chi sta chiedendo; concedere a una persona o a un **intero sotto-DEN**; revocare.                                                                                      |
| 10     | **Profilo creator**                | Seguire, essere avvisati quando va in onda, **DEN programmati** con orario.                                                                                            |
| 11     | **Livelli account**                | Differenze tra free, pagante e creator, senza creare gerarchia percepita tra persone.                                                                                  |

**6. Gli stati che contano più delle schermate**

**Stati critici — un errore qui è un incidente, non un fastidio:**

- **"Chi mi sente adesso?"** — con i sotto-DEN una persona è in due contesti audio insieme, e se riceve la parola diventa udibile da tutti. Deve essere leggibile in un istante se sta parlando a 8 o a 80. **È la domanda più importante dell'intero design.**

- **Sul palco, microfono spento.** Chi entra dalla coda occupa il posto ma **non trasmette** finché non lo attiva esplicitamente. Lo stato deve essere impossibile da fraintendere, anche per chi ha il telefono in tasca: serve una controparte sonora o aptica.

- **Hai ricevuto la parola.** Da questo momento **tutti** ti sentono, non più solo il tuo gruppo, e **non hai più modo di dire qualcosa in privato**. Va segnalato con la stessa forza del microfono aperto. Rischio concreto da prevenire: un gruppo che riceve la parola e continua a consultarsi tra sé ("vai tu", "no, dillo tu") davanti a ottanta persone senza accorgersene. Con il **sotto-DEN intero** il segnale deve arrivare a tutti e otto i membri contemporaneamente.

- **Microfono pubblico abbassato pur avendo la parola** — **confermato**: il microfono è per stanza, non globale. Chi ha la parola può abbassare quello pubblico e tornare a parlare solo al suo gruppo senza perdere il turno, come appoggiare il microfono senza restituirlo. Serve una resa immediatamente distinguibile da "ho la parola e sto trasmettendo" — e va notato che i due stati hanno **pubblici udibili diversi** pur condividendo lo stesso permesso: è esattamente il punto in cui l'utente può sbagliarsi.

- **La parola ti è stata revocata.** Chiaro, e non umiliante.

**Stati ordinari:**

- Qualcuno sta parlando — il segnale centrale dell'app.

- Più persone parlano insieme — deve restare leggibile, non diventare un albero di Natale.

- Silenzio — stato normale, va reso sereno e non imbarazzante.

- **DEN vuoto** — nell'alpha sarà **lo stato più frequente**: deve risultare invitante, non deprimente. È la prima impressione di quasi ogni tester.

- Da vuoto a vivo — qualcuno entra mentre aspetti: va notato senza spaventare.

- **In coda** — a che punto sei; si può stare in coda in **più DEN insieme**, con notifica anche a app chiusa.

- **Ingresso automatico attivo** — hai spuntato "fammi entrare automaticamente" per questo DEN.

- Voce mutata da me — preferenza personale, non atto ostile o pubblico.

- **Persona bloccata presente** — la vedi, è mutata d'ufficio, e con un tap puoi sentirla **solo qui**; la scelta resta memorizzata per quel DEN.

- Palco pieno — non posso salire, posso mettermi in coda.

- Connessione instabile o persa — l'audio è in tempo reale: va detto subito e con calma.

- Permessi negati (microfono, notifiche) — recupero chiaro, senza colpevolizzare.

- **Consenso alla profilazione rifiutato** — cosa cambia per quella persona, senza farla sentire penalizzata.

**7. Le domande di design a cui rispondere**

1.  **Come si vede chi parla in mezzo secondo?** Senza guardare fisso. È la domanda numero uno.

2.  **Come si risponde a "chi mi sente adesso"** quando si è dentro un sotto-DEN, e come cambia nel momento in cui si riceve la parola? Il passaggio da *"mi sentono in 8"* a *"mi sentono tutti"* deve essere percepibile senza guardare, e deve restare percepibile per tutta la sua durata — non basta una notifica al momento del cambio. Se una persona può dimenticarsene dopo trenta secondi, il design non ha funzionato.

3.  **Come si segnala il microfono spento a chi non sta guardando lo schermo?** Vale sia all'ingresso dalla coda sia con l'ingresso automatico attivo.

4.  **Come si distingue il palco dal pubblico** senza costruire una gerarchia di status?

5.  **Come si rappresenta una persona?** I profili sono leggeri e potrebbero non avere foto: iniziali, forme generate, colore assegnato? La scelta ha conseguenze su tutta l'app.

6.  **Come si passa tra DEN principale e sotto-DEN** senza perdere l'orientamento?

7.  **Come si mostra un vantaggio a pagamento senza creare status?** Un abbonato non deve apparire superiore, solo attrezzato meglio. Vale anche per chi è in coda con funzioni diverse.

8.  **Come rendere un DEN vuoto un invito** invece di una delusione?

9.  **Come si esprime l'ingresso morbido** — arrivare senza essere annunciati, ma capendo di essere arrivati?

10. **Come si comunica l'effimero** quando l'app **trascrive** le conversazioni? L'audio non resta davvero, il testo sì per un periodo: entrambe le cose devono risultare oneste dall'interfaccia, non solo dall'informativa.

11. **Come si dà un'identità sonora e visiva insieme?** Quali eventi meritano un suono o una vibrazione e quali no — in un'app dove il suono è tutto e gli stati critici non possono contare solo sulla vista.

12. **Che ruolo ha il colore** quando l'elemento principale è un elenco di persone senza foto?

**8. Cosa mi serve in output**

Il codice lo scrivono agenti a partire dai token: serve **precisione nei valori** più che mockup rifiniti al pixel.

**Fase 1 — direzione (prima consegna)** Due o tre direzioni visive alternative, ciascuna applicata **alla stessa schermata: la stanza DEN**, in tema scuro. Per ognuna: una frase che ne spiega la tesi e cosa la rende diversa.

**Fase 2 — sistema (dopo la scelta)**

1.  **Token con valori concreti**, in tabella: colori (hex) per tema scuro e chiaro con ruoli semantici (sfondo, superficie, testo primario/secondario, accento, **sta parlando**, **mutato**, **microfono spento sul palco**, **hai la parola**, errore); scala tipografica; spaziature; raggi; durate e curve delle animazioni.

2.  **Le 5 schermate dell'alpha** nella direzione scelta.

3.  **Il componente "partecipante"** in tutte le varianti: sul palco / tra il pubblico, parla / tace, **sul palco col microfono spento**, mutato da me, **bloccato e mutato d'ufficio**, sono io, sta salendo, **ha la parola pur non essendo sul palco**, **ha la parola ma col microfono pubblico abbassato**.

4.  **Gli stati del §6**, almeno a livello di schizzo con descrizione. Priorità agli stati critici.

5.  **Specifica del movimento**: cosa si muove, per quanti millisecondi, con quale curva, e cosa deve restare fermo.

6.  **Specifica sonora e aptica**: quali eventi hanno un suono o una vibrazione, e quale.

7.  **Concetti (non mockup) per le schermate della beta** del §5.B: quanto basta a verificare che il layout della stanza le possa accogliere.

8.  **Note di implementazione**: cosa è essenziale e cosa è rifinitura sacrificabile, così la prima versione non si blocca sui dettagli.

**9. Come lavoriamo**

- Per iterazioni: prima le direzioni, poi il sistema, poi le rifiniture.

- Se un vincolo di questo brief ostacola una buona soluzione, **dimmelo** invece di aggirarlo: i vincoli di prodotto (ingresso morbido, effimero, niente chat testuale, nessuna gerarchia di status) sono fermi; quelli estetici no.

- Ogni proposta motivata in una riga: perché questa e non l'ovvia.

- Il giudizio finale si dà **su un telefono vero**, non sul canvas: privilegia soluzioni che reggono su schermo piccolo e con luce scarsa.

**10. Messaggio d'apertura suggerito**

\> Ti allego la versione aggiornata del brief di design di BA. Rispetto a prima il modello di

\> prodotto si è ampliato: sotto-DEN, code verso il palco, alzata di mano, parola concessa, blocchi,

\> livelli di account.

\>

\> Prima di disegnare, dimmi come hai interpretato la tesi del §2 e come affronteresti la domanda

\> §7.2 — *"chi mi sente adesso"* quando una persona è dentro un sotto-DEN e riceve la parola. È il

\> problema che considero più importante e voglio verificare che ci siamo capiti.

\>

\> Poi procediamo con la Fase 1: due o tre direzioni per la **stanza DEN** in tema scuro.
