# Dalle schermate ai componenti

Per ogni prototipo di Claude Design in [`design/handoff/`](../../design/handoff/README.md): le schermate, i componenti che servono e **quali esistono già nel codice e quali no**. Serve a vedere che cosa resta da costruire.

Torna all'[indice](README.md). I componenti esistenti sono descritti in [componenti](componenti.md) (con la sezione «Non ancora costruiti»); le ipotesi segnate nelle schermate sono in [aperte](aperte.md).

**Come è fatta questa mappa.** Le schermate sono elencate dai prototipi (`.dc.html`: identificativi e titoli) e dai `changelog.md`; i componenti sono ricavati dai titoli e dalle note delle schermate e dalle tabelle C2 e C4 dell'Inventario, e confrontati con le classi che esistono in `app/lib/design_system/` (ricerca di `class <nome>`). Non è una lettura riga per riga dell'HTML: **chi costruisce una schermata guarda il prototipo**. Dove un componente è un'inferenza e non un nome dell'Inventario, c'è scritto.

**Che cosa è «esiste».** Vuol dire che nel codice c'è una classe con quel nome, con i suoi test e una pagina nella galleria. Non vuol dire che la schermata esista: **nessuna schermata è ancora costruita**. `main.dart` è uno schermo vuoto ([avvio](avvio.md)). Le schermate che oggi si vedono sono composizioni di prova nella galleria (la stanza finta e i fogli).

Le sigle dei prototipi (A1, P3, K1, C4…) sono quelle dei prototipi stessi.

**I prototipi 013, 014 e 015 sono aggiornati al task 027 (20 novembre 2026)** con le decisioni degli stakeholder (D-040…D-054 in [`DECISIONS.md`](../DECISIONS.md)); le schermate nuove (account chiuso, controlli a schermo bloccato) sono nel [prototipo 027](../../design/handoff/027/Account%20e%20controlli%20027.dc.html), vedi la sezione 4 bis. Gli screenshot nuovi dei tre prototipi stanno in `design/handoff/027/screenshots/` (prefisso `013-`, `014-`, `015-`): quelli vecchi nelle cartelle 013, 014 e 015 non sono stati rifatti e **alcuni non rispecchiano più il prototipo** (vedi il report del task 027c). Dove [aperte](aperte.md) dice ancora «da aggiornare nel design» (la fonte degli invitati, la lista dei temi) il prototipo non è stato toccato.

## 1. Stanza e stati critici: [Stati critici 002](../../design/handoff/002/Stati%20critici%20002.dc.html)

La stanza di un DEN dal punto di vista dell'ascoltatore e di chi sta sul palco: salire, la coda, il microfono spento, il consenso, la scheda di una persona, il sotto-DEN. Il resto della consegna è in [`changelog.md`](../../design/handoff/002/changelog.md) e [`suono-e-vibrazione.md`](../../design/handoff/002/suono-e-vibrazione.md).

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| 1 · pubblico-sali | Dal pubblico: «Sali sul palco» | `BaPalco`, `BaPresenza`, `BaPubblico`, `BaBarraAzioni`, `BaPillola` (la chiara), `BaIntestazione`, `BaMarcatore`, `BaRigaStato`, `BaAlone` (task 029) | — |
| 1 bis · sta-salendo | Sta salendo (stato `scheletro`, azione inattiva) | gli stessi, `BaStatoPalco.scheletro` | — |
| 2 · palco-pieno | Palco pieno: «Mettiti in coda» | gli stessi di 1 | — |
| 2 bis · in-coda | In coda | gli stessi di 1 | — |
| 3 · palco-microfono-spento-io | Sul palco a microfono spento: sono io (disco chiaro) | `BaPresenza` (`microfonoSpento`, `io`), `BaGlifo`, `BaPalco` | — |
| 3 bis · …-altri | Microfono spento degli altri (disco scuro) | come 3 | — |
| 4 · palco-vuoto | Palco vuoto, persone in ascolto | `BaPalco` (invito), `BaPubblico` | — |
| 5 · consenso-avviso | Ascoltatore che vuole salire: avviso e consenso | `BaFoglio` (richiesta), `BaPillola` | nessuno dei componenti di base; i testi e il flusso sono da costruire |
| 5 bis · consenso-rifiutato | Dopo «Non ora» | come 5 | — |
| 6 · scheda-persona | Scheda di una persona a microfono spento | `BaFoglio` (scheda), `BaSchedaPersona`, `BaRigaAzione` | — |
| 7 · sotto-den-gruppo | Chi mi sente adesso: il gruppo | `BaPresenza`, `BaPalco` | la **fascia «chi mi sente»**: nessuna classe e nessun nome nell'Inventario; ci sono solo i token `BaAscoltoTokens` |
| 8 · sotto-den-parola (e 8 bis) | Hai ricevuto la parola: io / un altro del gruppo | `BaPresenza` (`haLaParola`, la tacca) | la fascia «chi mi sente» |
| 9 · sotto-den-solo-gruppo | Parola in mano, «Parla solo al gruppo» | `BaPillola` | la fascia «chi mi sente» |
| 10 · sotto-den-parola-revocata | Parola revocata | `BaPresenza` | la fascia «chi mi sente» |

La struttura della stanza è fatta di `BaIntestazione` (nome e marcatore, cinque stati), `BaRigaStato` (i fatti sopra, le mie preferenze sotto, senza spazio se una manca), `BaMarcatore` e `BaAlone` (task 029); la galleria li usa nella stanza finta al posto del testo provvisorio. Il prototipo mostra anche la **regola della barra** (tre posti e «Altro») e la scheda con le tre azioni fisse: sono `BaBarraAzioni` e `BaSchedaPersona`, che esistono. Le superfici di sistema del 002 (Live Activity, Dynamic Island, notifica Android) non sono schermate Flutter: `BaCardLive`, `BaIsola` e `BaNotificaAndroid` dell'Inventario (C5) **non esistono**; di esse c'è solo `BaPayloadStanza`.

## 2. Accesso: [Accesso 013](../../design/handoff/013/Accesso%20013.dc.html)

L'accesso dell'ascoltatore con email (D-031), il percorso «diventa partecipante» (numero, SMS, consenso) e «Torna ascoltatore». Note in [`changelog.md`](../../design/handoff/013/changelog.md); correzioni del 013b in [`013b/changelog.md`](../../design/handoff/013b/changelog.md). Il suo changelog marca come «superato dal task 013» l'accesso della Fase 2 (5a); D-031 sostituisce D-002.

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| A1 · email | Email | `BaCampoTesto`, `BaPillola`, `BaMessaggio`, `BaPuntoAggancio` (il posto per «Continua con…») | — |
| A2 · codice | Codice via email: sei caselle, sbagliato, scaduto, nuovo invio con attesa | `BaCampoCodice` (tutti e quattro gli stati), `BaPillola` | il conto del nuovo invio non c'è e non ci sarà a schermo: è una frase ferma; l'attesa (`BaAccessoTokens.nuovoInvioAttesa`, 30 s) è solo un valore del server; l'azione «Mandalo di nuovo» è del chiamante |
| A3 · onboarding · A4 · termini | Primo accesso; termini e privacy, con la frase «dichiari di avere almeno 18 anni» sopra l'azione (**ipotesi**: età minima 18, obiettivo 16, D-052) | `BaPillola` | i testi; nessun componente specifico (**da verificare**) |
| A5 · nickname · A5 bis | «Scegli un nickname»: obbligatorio, può ripetersi (D-052); A5 bis a campo vuoto con l'azione inattiva | `BaCampoTesto`, `BaPillola` | — |
| A6 · elenco | Elenco per l'ascoltatore, di soli DEN pubblici: un privato si apre solo su invito, da un percorso a parte (D-041) | `BaPillola`, `BaRigaDen`, `BaIntestazione` | il flusso «Sei stato invitato» non è disegnato |
| P1 · sali-avviso | Sali sul palco: avviso su voce e testo | `BaFoglioPassi` (passo `avviso`), `BaPillola` | — |
| P2 · sali-numero | Il numero | `BaFoglioPassi` (passo `numero`), `BaCampoTesto` (con il prefisso del chiamante), `BaPillola` | — |
| P3 · sali-codice | Codice SMS (**rimovibile**) | `BaFoglioPassi` (passo `codice`), `BaCampoCodice` | — |
| P4 · sali-consenso | Consenso a parlare: «il tuo account passa da ascoltatore a partecipante» (**ipotesi**: può servire un nuovo accesso, D-040) | `BaFoglioPassi` (passo `consenso`), `BaPillola` | — |
| P5 · sali-sale | Sale a microfono spento (P6, «numero già verificato», è stata tolta, D-040) | la stanza (vedi 002 · 1 bis) | — |
| T1–T4 · torna ascoltatore | Cambio di tipo di account dalle impostazioni: T1 la riga, T2 la prima conferma, T3 la seconda (**ipotesi**: nuovo accesso), T4 il risultato (D-040) | `BaPillola`, `BaRigaImpostazione` (`.azione`) | — |

Il foglio «Vuoi salire sul palco?» è **uno solo** che cresce passo per passo; ciò che sta sopra le azioni scorre, le azioni restano ancorate: è `BaFoglioPassi` (task 023a) sopra `BaFoglio`, con le altezze 0,80 e 0,62 (`BaAccessoTokens.foglioAltezza*`). Il passo lo dà il chiamante e «Non ora» c'è in ogni passo; al cambio di passo il focus va al titolo.

## 3. Creare e gestire i DEN: [Creare DEN 014](../../design/handoff/014/Creare%20DEN%20014.dc.html)

Creare un DEN in cinque passi, le due varianti del percorso da ascoltatore, gli stati, «Gestisci» e il sotto-DEN. Note in [`changelog.md`](../../design/handoff/014/changelog.md) e [`changelog-014b.md`](../../design/handoff/014/changelog-014b.md).

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| E1 · elenco | Elenco con «Crea un DEN» | `BaPillola`, `BaRigaDen` | — |
| C1 · tipo | Privato o pubblico: «Entra chiunque. Si trova nell'elenco.» e «Lo gestisci tu, con i co-amministratori che scegli.» per entrambi (D-043) | `BaPassiCreazione.tipo` (`BaSceltaDen`) | — |
| C2 · nome | Nome, con il campo «Quando» spento | `BaPassiCreazione.nome` (`BaCampoTesto`, `BaPuntoAggancio.quando`) | — |
| C3 · descrizione, tema e lingua | Un passo solo | `BaPassiCreazione.dettagli` (`BaCampoTesto` a più righe, `BaChipScelta`) | — |
| C4 · invita | Solo il privato | `BaPassiCreazione.invitati` (il posto è un `Widget` del chiamante: oggi `BaPuntoAggancio`) | — |
| C5 · riepilogo | «Crea il DEN» | `BaPassiCreazione.riepilogo` (`BaRigaValore`) | — |
| C6 · creato | Nella stanza; chi ha creato è sul palco a microfono spento (dal 014b: presenza normale con il disco chiaro, variante «io» del 002) | `BaPalco`, `BaPresenza` (`io`, `microfonoSpento`) | — |
| R1, R2 · percorso da ascoltatore | Varianti di P1 e P4 del 013 (R2 con la frase del cambio di account) | `BaFoglioPassi` (passi `avviso` e `consenso`, R2 senza la riga «Salirai a microfono spento») | — |
| S1 · limite · S2 · non riuscita | Limite di DEN attivi: segnato «non è deciso», **stato futuro del Pro, non attivo in alpha e beta (D-042): non va costruito**; creazione non riuscita | `BaPassiCreazione.nonCreato` (`BaMessaggio` errore) per S2; S1 non si costruisce | — |
| G1–G5 · gestisci | «Gestisci», per i DEN privati e per i pubblici creati da un utente (D-043), dall'«Altro» della barra: co-amministratori, persone, rimozione, termine, descrizione | `BaFoglioGestisci` (menu, descrizione, co-amministratori con un posto libero e al limite, persone, conferma; `BaRigaValore`, `BaRigaPersona`) | `BaBarraAzioni` («Altro») apre il foglio: è del task 024 |
| D1 · nuovo sotto-DEN | Un foglio: nome e regola | `BaFoglioSottoDen` | — |

Il percorso «Crea un DEN» è **un foglio solo** (`BaFoglioPassi`, task 023b): i passi C1–C5 e S2 sono valori `BaPassoFoglio` di `BaPassiCreazione` che il chiamante dà allo stesso foglio dell'accesso (R1 → P2 → P3 → R2 → C1 → …), così il passaggio da R2 a C1 non perde il focus né l'annuncio. «Gestisci» è `BaFoglioGestisci`: un `BaFoglioPassi` con un costruttore con nome per vista; il chiamante ricostruisce la vista nuova nello stesso punto. Il sotto-DEN è `BaFoglioSottoDen`, un foglio a parte (si apre dalla stanza). **Differenza dal prototipo 014:** «Rimuovi» (G3 bis) e «Termina il DEN» (G4) sono azioni attive (a filetto), non chiare, perché sono distruttive (`BaRegole` 1): da correggere nel design.

## 4. Coda e attesa: [Coda e attesa 015](../../design/handoff/015/Coda%20e%20attesa%20015.dc.html)

Mettersi in coda con l'ingresso automatico, «Le tue code», la notifica del posto libero, il sotto-DEN d'attesa, il posto conservato dopo la linea persa, la permanenza massima, gli stati. Note in [`changelog.md`](../../design/handoff/015/changelog.md), [`changelog-015b.md`](../../design/handoff/015/changelog-015b.md) e [`suono-e-vibrazione.md`](../../design/handoff/015/suono-e-vibrazione.md).

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| K2 · metti-in-coda | Mettiti in coda, con l'ingresso automatico | `BaFoglioMettitiInCoda` (K2, K2 bis, K2 ter: la seconda riga solo con la capacità), `BaInterruttoreRiga` | — |
| K1 · code | «Le tue code» | `BaFoglioLeTueCode`, `BaRigaCoda`, `BaIntestazione` | — |
| K3 · posto-libero-notifica | Notifica di sistema del posto offerto: «Hai pochi secondi per salire» (30 secondi, frase ferma, mai un conto alla rovescia, D-042); ingresso automatico spento | — | la **notifica**: `BaNotificaAndroid` e la Live Activity non esistono (C5) |
| K4 · posto-libero-stanza | Nella stanza: «Si è liberato un posto. Hai pochi secondi per salire» | `BaPalco`, `BaPillola`, `BaBarraAzioni` | — |
| K4 bis · posto-scaduto | «Il posto è passato alla persona dopo di te. Resti in coda» (**ipotesi**) | `BaMessaggio` o `BaBandaPosto` (**da verificare**) | — |
| K6 · vuoi-passare-di-qua | Già in un DEN: «Si è liberato un posto in X. Vuoi passare di qua?», con «Passa» e «Resta qui» | `BaFoglioPassaDiQua` | — |
| K7 · K8 · richiamo | Il richiamo come notifica a schermo bloccato (non un annuncio in stanza, D-034); la riga «Richiamo» spenta nelle impostazioni (**ipotesi**) | `BaRigaImpostazione` | la **notifica** (C5) |
| K5 · ingresso-auto-stanza | Ingresso automatico: sul palco | `BaPalco` | — |
| W1 · attesa-entra · W2 · attesa-dentro | «Aspetta con altri»; nel gruppo d'attesa | `BaFoglioAspettaConAltri` (W1), `BaInterruttoreRiga`, `BaFasciaAttesa`, `BaPresenza` | — |
| W3 · attesa-passaggio | Il posto si libera: dal gruppo al palco | `BaPalco`, `BaFasciaAttesa` | — |
| P1 · linea-persa · P2 · posto-tornato · P3 · posto-passato | Il posto resta tuo; la linea è tornata, il posto c'è o è passato | `BaBandaPosto`, `BaStatoPalco.congelato`, `BaPresenza` (persa), `BaCodaTokens.oraDelPosto` | — |
| M1 · M1 bis · permanenza-massima | Permanenza massima per ascoltatori e parlatori, tempi da definire (D-044); M1 bis sul palco; punto di aggancio | `BaBandaPosto` (variante tratteggiata), `BaPuntoAggancio` | — |
| S1 · coda-piena · S2 · uscita-coda | Stati della coda (la vecchia «non puoi metterti in coda» è stata tolta: nessun limite in alpha e beta, D-042) | `BaFoglioCodaPiena` (S1); S2 è la stanza con una frase | — |

## 4 bis. Account chiuso e controlli a schermo bloccato: [Account e controlli 027](../../design/handoff/027/Account%20e%20controlli%20027.dc.html)

Due schermate nuove del task 027: l'account chiuso dalla moderazione (D-049) e i controlli a schermo bloccato (D-050). Note in [`changelog.md`](../../design/handoff/027/changelog.md) e [`suono-e-vibrazione.md`](../../design/handoff/027/suono-e-vibrazione.md).

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| B1 · account chiuso | La schermata che copre tutto, con un messaggio e «Richiedi revisione» come unica azione | `BaSchermataCopertura` (task 029) | — |
| B1 bis · blocco temporaneo | Come B1, con un blocco a tempo (**ipotesi**: la durata, 1 o 7 giorni) | `BaSchermataCopertura` (con la riga della durata) | — |
| B2 · richiesta inviata | Dopo «Richiedi revisione» | `BaSchermataCopertura` (`richiestaInviata`) | — |
| L1–L4 · controlli a schermo bloccato | Notifica fissa, Live Activity o widget: sul palco con il microfono acceso e spento (si può solo **spegnere**, D-025), per il pubblico in diretta e in pausa; «Prossimo DEN» come etichetta provvisoria | — | `BaControlliBloccato`: **non è un widget Flutter** (l'Inventario lo elenca in C4; sono superfici di sistema, come in C5); la fonte del «next» è da definire (D-050) |

## 4 ter. Persone, inviti e richiamo: [Persone e inviti 030](../../design/handoff/030/Persone%20e%20inviti%20030.dc.html)

Aggiungere persone, la rubrica, «Chi può trovarmi», il selettore degli invitati e del co-amministratore, «Sei stato invitato» e il richiamo con un consenso per persona. **Sono proposte di Luca (D-055), segnate «ipotesi» e ancora aperte** (vedi [aperte](aperte.md)). Principio che non si rompe: nessuna schermata mostra o lascia dedurre che una persona è online o in un DEN senza il suo consenso. Note in [`changelog.md`](../../design/handoff/030/changelog.md).

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| P1–P6 · aggiungere persone | Il «+» apre una ricerca con i suggeriti; due nickname uguali con l'alias; nessun suggerito; nessun risultato («Invita con un link»); persona aggiunta; errore di rete | `BaRicercaPersone`, `BaRigaPersona` (voci, alias), `BaFoglio`, `BaPillola`, `BaFraseErrore` | la pagina intera e la fonte dei suggeriti (task 024c) |
| R1–R3 · rubrica | Il foglio del permesso (due azioni alla pari, il rifiuto senza colpa), lo stato dopo il rifiuto, «Dalla rubrica» | `BaFoglioPassi`/`BaFoglio` (richiesta), `BaRigaPersona` | il collegamento alla rubrica (task 024c) |
| V1, V2 · chi può trovarmi | Una riga nelle impostazioni con la sua conseguenza e la scelta fra nessuno, chi conosco, tutti | `BaRigaImpostazione`, `BaSceltaDen` (la scelta esclusiva), `BaFoglio` | — |
| S1–S3 · selettore | Gli invitati (nessuno scelto, due scelti) e il co-amministratore: lo **stesso** selettore | `BaSelettorePersone` (nel posto di `BaPassiCreazione.invitati` e di `BaFoglioGestisci.coAmministratori`), `BaRicercaPersone`, `BaRigaPersona` | — |
| I1, I2 · sei stato invitato (chi ha BA) | La notifica a schermo bloccato (senza azioni) e il foglio «Entra» / «Non ora» | `BaFoglioInvito` (`.valido`) | la **notifica** (superficie di sistema, non un widget) |
| I3, I3 bis · scaduto e annullato | «Questo invito è scaduto», «non è più valido»; «Ho capito» | `BaFoglioInvito` (`.scaduto`, `.annullato`) | — |
| I4–I6 · chi non ha BA | La mail, la pagina d'arrivo web (fuori dall'app, ipotesi), l'accesso del 013 e l'ingresso diretto come ascoltatore | l'accesso del 013 (vedi §2) | la mail e la pagina web **non sono componenti dell'app** (D-030) |
| C1–C5 · richiamo | Spento di partenza, un consenso per persona, la conferma prima di accendere, «Chi può avvisarti» | `BaRigaImpostazione.interruttore`, `BaRigaConsenso`, `BaFoglio` (la conferma, composta dal chiamante) | la notifica del richiamo (015 K7: superficie di sistema) |

**Differenze dal prototipo 030, da correggere nel design:** «Entra» è attiva (a filetto) e non piena; il raggio dell'azione di una riga di persona è 16 (il token) e il prototipo lo disegna a 24. Un invito ricevuto mentre si è già in un DEN usa «Vuoi passare di qua?» del 015 (D-042): non è disegnato.

## 5. Prototipi precedenti

Due prototipi più vecchi restano nella repo come storia: [Schermate 001](../../design/handoff/001/Schermate%20001.dc.html) (accesso, impostazioni, superfici di sistema) e [Schermate 004](../../design/handoff/004/Schermate%20004.dc.html) (accesso, elenco dei DEN, stanza, attesa, impostazioni). Non sono la fonte da seguire per costruire: l'accesso del 013 è più recente, e la stanza e le attese sono nel 002 e nel 015. **Da verificare**, schermata per schermata, se qualcosa dei due vecchi prototipi vale ancora. `design/system/md/fase-2-schermate.md` e `stanza-den.md` sono esplorazione e storia, non norma (lo dice `CLAUDE.md`).

## Collegate nel prototipo (task 024)

Il [prototipo navigabile](prototipo.md) collega le pagine e i fogli già costruiti, con dati finti. **024a** (sì, in Chrome): accesso A1–A5 (013), elenco A6 e E1, stanza (002: pubblico, sul palco a microfono spento e acceso, palco vuoto, scheda persona, «Altro»), P1–P4 e R1–R2 («diventa partecipante»), impostazioni T1–T4 e persone bloccate (001, 013). **024b** (sì, in Chrome): coda e attesa (015: K1, K2 con e senza «Aspetta con altri», K4, K4 bis, K5, K6, K7, W1, S1), «Crea un DEN» C1–C5 e S2, «Gestisci» G1–G5, sotto-DEN D1 (014), linea persa e ritorno (015 P1–P3), il permesso del microfono negato, account chiuso B1, B1 bis, B2 e schermo bloccato L1–L4 (027), questi ultimi **simulati**. **024c** (sì, in Chrome): persone e inviti (030): P1–P6 aggiungere persone, R1–R3 rubrica, V1–V2 «Chi può trovarmi», S1–S3 il selettore (invitati e co-amministratore, con le persone aggiunte), I1–I6 gli inviti (anche per chi non ha BA, con la mail e la pagina fuori dall'app simulate), C1–C5 il richiamo. **Non collegate:** la scoperta e i creator (031). Dove i documenti tacciono (da dove si aprono le impostazioni, dove porta «Esci»…) le proposte sono in [prototipo](prototipo.md) e in [aperte](aperte.md).

## Che cosa resta da costruire

Mettendo insieme le tabelle, i componenti che servono alle schermate e **non esistono**. Con il task 022 sono stati costruiti i nove componenti dei task 013–015 (campo di testo, codice, scelta del tipo, chip, punto di aggancio, interruttore di riga, riga di coda, fascia d'attesa, banda del posto) , con il 023a i contenuti dei fogli dell'accesso a parlare e della coda (`BaFoglioPassi` e i cinque fogli della coda), con il 023b quelli di creare e gestire i DEN (`BaPassiCreazione`, `BaFoglioGestisci`, `BaFoglioSottoDen`, `BaRigaValore`, `BaRigaPersona`), con il 029 i componenti della stanza, dell'elenco e dell'account chiuso (`BaIntestazione`, `BaMarcatore`, `BaRigaStato`, `BaAlone`, `BaRigaDen`, `BaRigaImpostazione`, `BaRigaBloccata`, `BaSchermataCopertura`) e con il 033 quelli delle persone e degli inviti (`BaRicercaPersone`, `BaRigaPersona` estesa, `BaSelettorePersone`, `BaRigaConsenso`, `BaFoglioInvito`); restano:

| Componente | Serve a | Sezione dell'Inventario |
| --- | --- | --- |
| la **fascia «chi mi sente»** | il sotto-DEN (002) | nessun nome nell'Inventario; token `BaAscoltoTokens` |
| `BaCardLive`, `BaIsola`, `BaNotificaAndroid` | superfici di sistema | C5 (non sono widget Flutter) |
| `BaControlliBloccato` | i controlli a schermo bloccato (027: L1–L4): l'Inventario lo mette in C4, ma sono superfici di sistema (come C5), non un widget Flutter | C4 |

Oltre ai componenti, **mancano le schermate**, la navigazione, l'accesso, l'audio, la connessione, il server: vedi [produzione](produzione.md). Nell'elenco dei task (`docs/tasks/README.md`) i task 022 (i nove componenti), 023a (i fogli dell'accesso e della coda), 023b (i fogli di creare e gestire i DEN) 029 (i componenti della stanza e dell'elenco) e 033 (persone e inviti) sono costruiti o in corso; il prototipo navigabile in locale è il 024, «brief da scrivere».
