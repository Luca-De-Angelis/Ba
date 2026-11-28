# Glossario

Questi termini valgono nell'interfaccia, nei documenti e nei nomi del codice (D-008). Se manca un termine, si aggiunge qui prima di usarlo.

| Termine | Significato |
| --- | --- |
| DEN | Stanza vocale: un palco di massimo 8 persone e un pubblico che ascolta |
| Palco | Le persone che possono parlare nel DEN, al massimo 8 |
| Pubblico | Chi è nel DEN e ascolta. Si entra sempre qui (D-006) |
| Sotto-DEN | Gruppo di massimo 8 persone dentro un DEN: sente il DEN principale e parla al proprio gruppo |
| Parola | Permesso di farsi sentire da tutto il DEN restando nel proprio sotto-DEN. È additiva: non è un cambio di stanza |
| Microfono acceso / spento | Stato del proprio microfono. È per stanza, non globale |
| Muta una voce / voce mutata | Preferenza personale: non sentire più una persona. Non è un atto pubblico |
| Blocca / persona bloccata | La persona resta visibile ma mutata d'ufficio |
| Ascoltatore | Account di base, con email, senza numero: ascolta, non parla e non viene mai trascritto |
| Partecipante | Account con numero verificato e consenso a parlare. Il consenso a parlare **cambia il tipo di account** (D-040): non è un'azione al volo e può richiedere di rifare l'accesso |
| Torna ascoltatore | Ritiro del consenso a parlare (D-003). È un **cambio di tipo di account**, non un tap: si fa dalle impostazioni, con una doppia conferma, e chi lo fa durante una conversazione esce dalla stanza (D-040) |
| Coda | Lista d'attesa per il palco, anche su più DEN insieme |
| Ingresso automatico | "Fammi entrare automaticamente" quando si libera un posto |
| Sotto-DEN d'attesa | Nell'interfaccia «Aspetta con altri». Un gruppo di chi aspetta nella stessa coda, fino a 8: sente il gruppo e parla al gruppo, il palco non lo sente; si lascia quando si libera un posto (C05) |
| Gruppo d'attesa | Il gruppo di chi, nella stessa coda, ha scelto di aspettare insieme |
| DEN programmato | DEN con data e ora, creato da qualunque utente (D-016) |
| DEN privato | Si entra solo su invito; ha un amministratore, chi lo ha creato |
| DEN pubblico | Entra chiunque; si trova nell'elenco. **Creato dal sistema**: nessun amministratore, solo automoderazione. **Creato da un utente**: l'amministratore è chi lo crea, come nei privati (D-043; D-011 vale per quelli del sistema) |
| Co-amministratore | Persona a cui l'amministratore di un DEN privato affida la gestione (uno nel Free, tre nel Pro) |
| Gestisci | Il foglio con cui chi ha creato un DEN lo amministra: vale per i DEN privati e per i pubblici creati da un utente (D-043) |
| Connessione | Legame fra due persone; fra le connessioni si scelgono gli invitati (D-014) |
| Ascolto condiviso | Contenuto riprodotto nel DEN che tutti sentono insieme; si abbassa da solo quando qualcuno parla (D-017) |
| Modalità radio | Quando il DEN finisce o si svuota, si passa da soli a uno simile per tema e lingua (B10, solo annotata, D-032) |
| Richiamo | La notifica che dice che una persona è entrata in un DEN pubblico, con l'invito a passare («In Famiglia c'è Ciccio · vuoi passare?», D-042). Arriva solo a chi ha scelto di riceverla, e solo da una persona che ha scelto di avvisare: **parte spento, con un consenso per persona** (proposta del 030, ancora aperta, D-055) |
| Aggiungi | L'azione per aggiungere una persona alla propria lista. **L'aggiunta è privata: l'altra persona non riceve un avviso.** Nome proposto dal design (D-039: «segui/aggiungi» da decidere), ancora aperto |
| Alias | Il nome unico che distingue due persone con lo stesso nickname (`@sara.rossi`): i nickname possono ripetersi (D-052). Proposta del design, ancora aperta |
| Chi può trovarmi | La visibilità di una persona nella ricerca: nessuno, chi conosco, tutti (D-038). Valore di partenza proposto: «Chi conosco» (aperto) |
| Invito | Un DEN privato si apre solo a chi è invitato (D-041). Chi ha BA riceve una notifica e un foglio «Invito di Marta»: «Entra» porta fra il pubblico. L'invito scade dopo 7 giorni (ipotesi: l'interfaccia non mostra il numero) o si annulla |
| Persone | Le persone che si sono aggiunte: da qui si scelgono gli invitati e il co-amministratore (D-039). Nessuna è mai mostrata online o in un DEN senza il suo consenso |
| Account bannato | Account chiuso dalla moderazione, in modo definitivo nei fatti (D-049). All'apertura o al login compare una schermata che copre tutto, con un messaggio e «Richiedi revisione» come unica azione |
| Nickname | Nome che si sceglie alla registrazione: obbligatorio, anche ripetibile (l'unicità si deciderà con il following, D-052) |
| Tipo di account | Ascoltatore o partecipante. Cambia con il consenso a parlare e con «Torna ascoltatore»; essere ascoltatore in un DEN è invece un ruolo, non un tipo di account (D-040) |
| DEN creato dal sistema | DEN pubblico nato da un trend o da altri motivi: nessun amministratore, solo automoderazione; si elimina da solo dopo un tempo di inattività (D-043) |
| Prossimo DEN | Etichetta provvisoria del controllo «next» a schermo bloccato, che passa a un altro DEN (zapping). Da dove viene il DEN successivo è da definire (D-050) |

**Da non usare:** "Loggia" (si dice sotto-DEN), "abbassa / abbassata" (si dice muta / mutata), "Mutami" o "Muta" per il proprio microfono (si dice spegni il microfono).

## Genere grammaticale (task 032)

L'interfaccia italiana **non usa participi o aggettivi che dipendano dal genere di una persona nominata né di chi usa l'app**. Le forme valide:

| Non così | Così |
| --- | --- |
| «Marta ti ha invitato» · «Sei stato invitato» | «Invito di Marta» · «Hai un invito» |
| «Marta è entrato nel DEN Famiglia» | «In Famiglia c'è Marta · vuoi passare?» |
| «✓ Aggiunta» accanto a «Davide» | «✓ In lista» |
| «Dario V.: bloccata» | «Persona bloccata: Dario V.» |
| «Sei entrato su invito di Marta» · «Sei salito sul palco» · «Sei uscito dalla coda» | «Sei dentro, su invito di Marta» · «Sei sul palco» · «Hai lasciato la coda» |
| «Ne sei sicuro?» | «Confermi?» |
| «Non siamo riusciti ad aprirlo» | «Non è stato possibile aprirlo» |

Gli accordi con un sostantivo (posto passato, persona aggiunta, DEN creato) sono ammessi: dipendono dal sostantivo, non dalla persona; non si scrivono accanto al nome di una persona. I verbi con *avere* (hai aggiunto, hai lasciato) non si accordano con chi li compie. I **nomi di ruolo** (ascoltatore, partecipante, co-amministratore) sono termini del glossario: sono al maschile e restano finché non si decide una forma neutra (domanda aperta). Il tedesco usa già le forme inclusive (Teilnehmer:in, Zuhörer:in) e i suoi participi non si accordano.

**Nomi del codice già in uso:** `BaPresenza`, `BaPalco`, `BaTouchable`, `BaRegole`, `BaOra`. Vedi `design/system/md/inventario-componenti.md`.

## Nomi di ruolo (task 036)

«**Partecipante**» è già neutro (epiceno): resta. «**Ascoltatore**» e «**co-amministratore**» hanno un genere. **Eccezione dichiarata:** restano come **termini di tipo di account e di funzione** (D-040, catalogo D04), nei documenti e nel codice, perché sono i nomi con cui il prodotto li chiama. Non compaiono nell'interfaccia come predicato di una persona né accanto al suo nome.

| Non così | Così |
| --- | --- |
| «sei ascoltatore» (marcatore fermo) | «in ascolto» |
| «Torna ascoltatore» (azione) | «Torna all’ascolto» |
| «Con il consenso il tuo account passa da ascoltatore a partecipante» | invariata: «da ascoltatore» e «a partecipante» sono nomi di tipo dopo una preposizione e non si accordano con chi legge |
| «Aggiungi un co-amministratore» | invariata finché il nome della funzione non cambia; forma neutra proposta: «Aggiungi chi amministra con te» (ipotesi, da decidere) |

Il tedesco usa già le forme inclusive («Zuhörer:in», «Co-Administrator:in»).

## Scoperta (task 031, 034)

| Termine | Che cos'è |
| --- | --- |
| Disponibile a chiacchierare | Uno stato **dichiarato** da chi lo accende, mai rilevato: il profilo diventa **trovabile e invitabile** (compari fra le persone che si possono invitare, solo per chi può trovarti secondo «Chi può trovarmi»: la visibilità non si allarga da sola). Si spegne in un tocco e **da solo quando si entra in un DEN** (ipotesi, D-055; nessun timer). Si mostra sempre come «● Disponibile»: un punto pieno **e** la parola, mai il solo colore, mai uno stato di presenza |
| Zona abituale | La zona in cui di solito si ascolta, usata al posto del GPS quando la posizione non è autorizzata: una zona, mai un indirizzo (G15, ipotesi). È una memoria in più da dichiarare nell'informativa |
| Proposti per te | I DEN che la home suggerisce, ognuno con il **motivo** in una frase («Perché: tema Cucina», «Perché: in italiano») e un marcatore («vicino a te», «zona abituale»). Vengono da tema e lingua scelti; il loro numero non è deciso. Nessuna classifica, nessun segno del pagante, nessun contatore |
| Avvisi sui DEN | Un avviso quando si apre un **DEN** su un tema o una lingua che scegli (G09). **Mai per le persone**: quello è il richiamo, che ha il suo consenso per persona |
