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
| 1 · pubblico-sali | Dal pubblico: «Sali sul palco» | `BaPalco`, `BaPresenza`, `BaPubblico`, `BaBarraAzioni`, `BaPillola` (la chiara) | `BaIntestazione`, `BaMarcatore`, `BaRigaStato` (C2), `BaAlone` |
| 1 bis · sta-salendo | Sta salendo (stato `scheletro`, azione inattiva) | gli stessi, `BaStatoPalco.scheletro` | gli stessi di 1 |
| 2 · palco-pieno | Palco pieno: «Mettiti in coda» | gli stessi di 1 | gli stessi di 1 |
| 2 bis · in-coda | In coda | gli stessi di 1 | gli stessi di 1 |
| 3 · palco-microfono-spento-io | Sul palco a microfono spento: sono io (disco chiaro) | `BaPresenza` (`microfonoSpento`, `io`), `BaGlifo`, `BaPalco` | come 1 |
| 3 bis · …-altri | Microfono spento degli altri (disco scuro) | come 3 | come 1 |
| 4 · palco-vuoto | Palco vuoto, persone in ascolto | `BaPalco` (invito), `BaPubblico` | come 1 |
| 5 · consenso-avviso | Ascoltatore che vuole salire: avviso e consenso | `BaFoglio` (richiesta), `BaPillola` | nessuno dei componenti di base; i testi e il flusso sono da costruire |
| 5 bis · consenso-rifiutato | Dopo «Non ora» | come 5 | — |
| 6 · scheda-persona | Scheda di una persona a microfono spento | `BaFoglio` (scheda), `BaSchedaPersona`, `BaRigaAzione` | — |
| 7 · sotto-den-gruppo | Chi mi sente adesso: il gruppo | `BaPresenza`, `BaPalco` | la **fascia «chi mi sente»**: nessuna classe e nessun nome nell'Inventario; ci sono solo i token `BaAscoltoTokens` |
| 8 · sotto-den-parola (e 8 bis) | Hai ricevuto la parola: io / un altro del gruppo | `BaPresenza` (`haLaParola`, la tacca) | la fascia «chi mi sente» |
| 9 · sotto-den-solo-gruppo | Parola in mano, «Parla solo al gruppo» | `BaPillola` | la fascia «chi mi sente» |
| 10 · sotto-den-parola-revocata | Parola revocata | `BaPresenza` | la fascia «chi mi sente» |

Il prototipo mostra anche la **regola della barra** (tre posti e «Altro») e la scheda con le tre azioni fisse: sono `BaBarraAzioni` e `BaSchedaPersona`, che esistono. Le superfici di sistema del 002 (Live Activity, Dynamic Island, notifica Android) non sono schermate Flutter: `BaCardLive`, `BaIsola` e `BaNotificaAndroid` dell'Inventario (C5) **non esistono**; di esse c'è solo `BaPayloadStanza`.

## 2. Accesso: [Accesso 013](../../design/handoff/013/Accesso%20013.dc.html)

L'accesso dell'ascoltatore con email (D-031), il percorso «diventa partecipante» (numero, SMS, consenso) e «Torna ascoltatore». Note in [`changelog.md`](../../design/handoff/013/changelog.md); correzioni del 013b in [`013b/changelog.md`](../../design/handoff/013b/changelog.md). Il suo changelog marca come «superato dal task 013» l'accesso della Fase 2 (5a); D-031 sostituisce D-002.

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| A1 · email | Email | `BaCampoTesto`, `BaPillola`, `BaMessaggio`, `BaPuntoAggancio` (il posto per «Continua con…») | — |
| A2 · codice | Codice via email: sei caselle, sbagliato, scaduto, nuovo invio con attesa | `BaCampoCodice` (tutti e quattro gli stati), `BaPillola` | il conto del nuovo invio non c'è e non ci sarà a schermo: è una frase ferma; l'attesa (`BaAccessoTokens.nuovoInvioAttesa`, 30 s) è solo un valore del server; l'azione «Mandalo di nuovo» è del chiamante |
| A3 · onboarding · A4 · termini | Primo accesso; termini e privacy, con la frase «dichiari di avere almeno 18 anni» sopra l'azione (**ipotesi**: età minima 18, obiettivo 16, D-052) | `BaPillola` | i testi; nessun componente specifico (**da verificare**) |
| A5 · nickname · A5 bis | «Scegli un nickname»: obbligatorio, può ripetersi (D-052); A5 bis a campo vuoto con l'azione inattiva | `BaCampoTesto`, `BaPillola` | — |
| A6 · elenco | Elenco per l'ascoltatore, di soli DEN pubblici: un privato si apre solo su invito, da un percorso a parte (D-041) | `BaPillola` | `BaRigaDen`, `BaIntestazione`; il flusso «Sei stato invitato» non è disegnato |
| P1 · sali-avviso | Sali sul palco: avviso su voce e testo | `BaFoglioPassi` (passo `avviso`), `BaPillola` | — |
| P2 · sali-numero | Il numero | `BaFoglioPassi` (passo `numero`), `BaCampoTesto` (con il prefisso del chiamante), `BaPillola` | — |
| P3 · sali-codice | Codice SMS (**rimovibile**) | `BaFoglioPassi` (passo `codice`), `BaCampoCodice` | — |
| P4 · sali-consenso | Consenso a parlare: «il tuo account passa da ascoltatore a partecipante» (**ipotesi**: può servire un nuovo accesso, D-040) | `BaFoglioPassi` (passo `consenso`), `BaPillola` | — |
| P5 · sali-sale | Sale a microfono spento (P6, «numero già verificato», è stata tolta, D-040) | la stanza (vedi 002 · 1 bis) | — |
| T1–T4 · torna ascoltatore | Cambio di tipo di account dalle impostazioni: T1 la riga, T2 la prima conferma, T3 la seconda (**ipotesi**: nuovo accesso), T4 il risultato (D-040) | `BaPillola` | `BaRigaImpostazione` |

Il foglio «Vuoi salire sul palco?» è **uno solo** che cresce passo per passo; ciò che sta sopra le azioni scorre, le azioni restano ancorate: è `BaFoglioPassi` (task 023a) sopra `BaFoglio`, con le altezze 0,80 e 0,62 (`BaAccessoTokens.foglioAltezza*`). Il passo lo dà il chiamante e «Non ora» c'è in ogni passo; al cambio di passo il focus va al titolo.

## 3. Creare e gestire i DEN: [Creare DEN 014](../../design/handoff/014/Creare%20DEN%20014.dc.html)

Creare un DEN in cinque passi, le due varianti del percorso da ascoltatore, gli stati, «Gestisci» e il sotto-DEN. Note in [`changelog.md`](../../design/handoff/014/changelog.md) e [`changelog-014b.md`](../../design/handoff/014/changelog-014b.md).

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| E1 · elenco | Elenco con «Crea un DEN» | `BaPillola` | `BaRigaDen` |
| C1 · tipo | Privato o pubblico: «Entra chiunque. Si trova nell'elenco.» e «Lo gestisci tu, con i co-amministratori che scegli.» per entrambi (D-043) | `BaSceltaDen`, `BaPillola` | — |
| C2 · nome | Nome, con il campo «Quando» spento | `BaCampoTesto`, `BaPuntoAggancio.quando`, `BaPillola` | — |
| C3 · descrizione, tema e lingua | Un passo solo | `BaCampoTesto` (a più righe), `BaChipScelta`, `BaPillola` | — |
| C4 · invita | Solo il privato | `BaPuntoAggancio`, `BaPillola` | — |
| C5 · riepilogo | «Crea il DEN» | `BaPillola` (la chiara) | — |
| C6 · creato | Nella stanza; chi ha creato è sul palco a microfono spento (dal 014b: presenza normale con il disco chiaro, variante «io» del 002) | `BaPalco`, `BaPresenza` (`io`, `microfonoSpento`) | — |
| R1, R2 · percorso da ascoltatore | Varianti di P1 e P4 del 013 (R2 con la frase del cambio di account) | `BaFoglioPassi` (passi `avviso` e `consenso`, R2 senza la riga «Salirai a microfono spento») | — |
| S1 · limite · S2 · non riuscita | Limite di DEN attivi: segnato «non è deciso», **stato futuro del Pro, non attivo in alpha e beta (D-042): non va costruito**; creazione non riuscita | `BaMessaggio` (errore) | — |
| G1–G5 · gestisci | «Gestisci», per i DEN privati e per i pubblici creati da un utente (D-043), dall'«Altro» della barra: co-amministratori, persone, rimozione, termine, descrizione | `BaFoglio`, `BaRigaAzione`, `BaMessaggio`, `BaBarraAzioni` («Altro») | `BaFoglioGestisci` |
| D1 · nuovo sotto-DEN | Un foglio: nome e regola | `BaFoglio`, `BaCampoTesto` | `BaFoglioGestisci` (D1 vi è nominato) |

## 4. Coda e attesa: [Coda e attesa 015](../../design/handoff/015/Coda%20e%20attesa%20015.dc.html)

Mettersi in coda con l'ingresso automatico, «Le tue code», la notifica del posto libero, il sotto-DEN d'attesa, il posto conservato dopo la linea persa, la permanenza massima, gli stati. Note in [`changelog.md`](../../design/handoff/015/changelog.md), [`changelog-015b.md`](../../design/handoff/015/changelog-015b.md) e [`suono-e-vibrazione.md`](../../design/handoff/015/suono-e-vibrazione.md).

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| K2 · metti-in-coda | Mettiti in coda, con l'ingresso automatico | `BaFoglioMettitiInCoda` (K2, K2 bis, K2 ter: la seconda riga solo con la capacità), `BaInterruttoreRiga` | — |
| K1 · code | «Le tue code» | `BaFoglioLeTueCode`, `BaRigaCoda` | `BaIntestazione` |
| K3 · posto-libero-notifica | Notifica di sistema del posto offerto: «Hai pochi secondi per salire» (30 secondi, frase ferma, mai un conto alla rovescia, D-042); ingresso automatico spento | — | la **notifica**: `BaNotificaAndroid` e la Live Activity non esistono (C5) |
| K4 · posto-libero-stanza | Nella stanza: «Si è liberato un posto. Hai pochi secondi per salire» | `BaPalco`, `BaPillola`, `BaBarraAzioni` | — |
| K4 bis · posto-scaduto | «Il posto è passato alla persona dopo di te. Resti in coda» (**ipotesi**) | `BaMessaggio` o `BaBandaPosto` (**da verificare**) | — |
| K6 · vuoi-passare-di-qua | Già in un DEN: «Si è liberato un posto in X. Vuoi passare di qua?», con «Passa» e «Resta qui» | `BaFoglioPassaDiQua` | — |
| K7 · K8 · richiamo | Il richiamo come notifica a schermo bloccato (non un annuncio in stanza, D-034); la riga «Richiamo» spenta nelle impostazioni (**ipotesi**) | — | la **notifica** (C5); `BaRigaImpostazione` |
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
| B1 · account chiuso | La schermata che copre tutto, con un messaggio e «Richiedi revisione» come unica azione | `BaPillola` | `BaSchermataCopertura` (Inventario, C4) |
| B1 bis · blocco temporaneo | Come B1, con un blocco a tempo (**ipotesi**: la durata, 1 o 7 giorni) | `BaPillola` | `BaSchermataCopertura` |
| B2 · richiesta inviata | Dopo «Richiedi revisione» | `BaPillola` | `BaSchermataCopertura` |
| L1–L4 · controlli a schermo bloccato | Notifica fissa, Live Activity o widget: sul palco con il microfono acceso e spento (si può solo **spegnere**, D-025), per il pubblico in diretta e in pausa; «Prossimo DEN» come etichetta provvisoria | — | `BaControlliBloccato`: **non è un widget Flutter** (l'Inventario lo elenca in C4; sono superfici di sistema, come in C5); la fonte del «next» è da definire (D-050) |

## 5. Prototipi precedenti

Due prototipi più vecchi restano nella repo come storia: [Schermate 001](../../design/handoff/001/Schermate%20001.dc.html) (accesso, impostazioni, superfici di sistema) e [Schermate 004](../../design/handoff/004/Schermate%20004.dc.html) (accesso, elenco dei DEN, stanza, attesa, impostazioni). Non sono la fonte da seguire per costruire: l'accesso del 013 è più recente, e la stanza e le attese sono nel 002 e nel 015. **Da verificare**, schermata per schermata, se qualcosa dei due vecchi prototipi vale ancora. `design/system/md/fase-2-schermate.md` e `stanza-den.md` sono esplorazione e storia, non norma (lo dice `CLAUDE.md`).

## Che cosa resta da costruire

Mettendo insieme le tabelle, i componenti che servono alle schermate e **non esistono**. Con il task 022 sono stati costruiti i nove componenti dei task 013–015 (campo di testo, codice, scelta del tipo, chip, punto di aggancio, interruttore di riga, riga di coda, fascia d'attesa, banda del posto) e con il 023a i contenuti dei fogli dell'accesso a parlare e della coda (`BaFoglioPassi` e i cinque fogli della coda); restano:

| Componente | Serve a | Sezione dell'Inventario |
| --- | --- | --- |
| `BaIntestazione`, `BaMarcatore`, `BaRigaStato`, `BaAlone` | la stanza (002), gli elenchi | C2 |
| `BaRigaDen`, `BaRigaImpostazione`, `BaRigaBloccata` | gli elenchi e le impostazioni (013, 014) | C4 |
| `BaFoglioGestisci` | «Gestisci» e il sotto-DEN (014): task 023b | C4 |
| la **fascia «chi mi sente»** | il sotto-DEN (002) | nessun nome nell'Inventario; token `BaAscoltoTokens` |
| `BaCardLive`, `BaIsola`, `BaNotificaAndroid` | superfici di sistema | C5 (non sono widget Flutter) |
| `BaSchermataCopertura` | l'account chiuso (027: B1, B1 bis, B2) | C4 |
| `BaControlliBloccato` | i controlli a schermo bloccato (027: L1–L4): l'Inventario lo mette in C4, ma sono superfici di sistema (come C5), non un widget Flutter | C4 |

Oltre ai componenti, **mancano le schermate**, la navigazione, l'accesso, l'audio, la connessione, il server: vedi [produzione](produzione.md). Nell'elenco dei task (`docs/tasks/README.md`) i task 022 (i nove componenti) e 023a (i contenuti dei fogli dell'accesso e della coda) sono costruiti o in corso; i fogli di «Crea un DEN» e «Gestisci» sono il 023b e il prototipo navigabile in locale il 024, entrambi «brief da scrivere».
