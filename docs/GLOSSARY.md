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
| Richiamo | La notifica che dice che una persona è entrata in un DEN pubblico, con l'invito a passare («Ciccio è entrato nel DEN Famiglia: vuoi passare?», D-042). Arriva solo a chi ha scelto di riceverla, e solo da una persona che ha scelto di avvisare: **parte spento, con un consenso per persona** (proposta del 030, ancora aperta, D-055) |
| Aggiungi | L'azione per aggiungere una persona alla propria lista. **L'aggiunta è privata: l'altra persona non riceve un avviso.** Nome proposto dal design (D-039: «segui/aggiungi» da decidere), ancora aperto |
| Alias | Il nome unico che distingue due persone con lo stesso nickname (`@sara.rossi`): i nickname possono ripetersi (D-052). Proposta del design, ancora aperta |
| Chi può trovarmi | La visibilità di una persona nella ricerca: nessuno, chi conosco, tutti (D-038). Valore di partenza proposto: «Chi conosco» (aperto) |
| Invito | Un DEN privato si apre solo a chi è invitato (D-041). Chi ha BA riceve una notifica e un foglio «Sei stato invitato»: «Entra» porta fra il pubblico. L'invito scade dopo 7 giorni (ipotesi: l'interfaccia non mostra il numero) o si annulla |
| Persone | Le persone che si sono aggiunte: da qui si scelgono gli invitati e il co-amministratore (D-039). Nessuna è mai mostrata online o in un DEN senza il suo consenso |
| Account bannato | Account chiuso dalla moderazione, in modo definitivo nei fatti (D-049). All'apertura o al login compare una schermata che copre tutto, con un messaggio e «Richiedi revisione» come unica azione |
| Nickname | Nome che si sceglie alla registrazione: obbligatorio, anche ripetibile (l'unicità si deciderà con il following, D-052) |
| Tipo di account | Ascoltatore o partecipante. Cambia con il consenso a parlare e con «Torna ascoltatore»; essere ascoltatore in un DEN è invece un ruolo, non un tipo di account (D-040) |
| DEN creato dal sistema | DEN pubblico nato da un trend o da altri motivi: nessun amministratore, solo automoderazione; si elimina da solo dopo un tempo di inattività (D-043) |
| Prossimo DEN | Etichetta provvisoria del controllo «next» a schermo bloccato, che passa a un altro DEN (zapping). Da dove viene il DEN successivo è da definire (D-050) |

**Da non usare:** "Loggia" (si dice sotto-DEN), "abbassa / abbassata" (si dice muta / mutata), "Mutami" o "Muta" per il proprio microfono (si dice spegni il microfono).

**Nomi del codice già in uso:** `BaPresenza`, `BaPalco`, `BaTouchable`, `BaRegole`, `BaOra`. Vedi `design/system/md/inventario-componenti.md`.
