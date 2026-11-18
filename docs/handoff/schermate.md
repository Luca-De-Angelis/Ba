# Dalle schermate ai componenti

Per ogni prototipo di Claude Design in [`design/handoff/`](../../design/handoff/README.md): le schermate, i componenti che servono e **quali esistono già nel codice e quali no**. Serve a vedere che cosa resta da costruire.

Torna all'[indice](README.md). I componenti esistenti sono descritti in [componenti](componenti.md) (con la sezione «Non ancora costruiti»); le ipotesi segnate nelle schermate sono in [aperte](aperte.md).

**Come è fatta questa mappa.** Le schermate sono elencate dai prototipi (`.dc.html`: identificativi e titoli) e dai `changelog.md`; i componenti sono ricavati dai titoli e dalle note delle schermate e dalle tabelle C2 e C4 dell'Inventario, e confrontati con le classi che esistono in `app/lib/design_system/` (ricerca di `class <nome>`). Non è una lettura riga per riga dell'HTML: **chi costruisce una schermata guarda il prototipo**. Dove un componente è un'inferenza e non un nome dell'Inventario, c'è scritto.

**Che cosa è «esiste».** Vuol dire che nel codice c'è una classe con quel nome, con i suoi test e una pagina nella galleria. Non vuol dire che la schermata esista: **nessuna schermata è ancora costruita**. `main.dart` è uno schermo vuoto ([avvio](avvio.md)). Le schermate che oggi si vedono sono composizioni di prova nella galleria (la stanza finta e i fogli).

Le sigle dei prototipi (A1, P3, K1, C4…) sono quelle dei prototipi stessi.

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
| A1 · email | Email | `BaPillola`, `BaMessaggio` | il **campo di testo** (email): nessun nome nell'Inventario, ci sono i token `BaAccessoTokens.campo*` |
| A2 · codice | Codice via email: sei caselle, sbagliato, scaduto, nuovo invio con attesa | `BaMessaggio` (errore), `BaPillola` | `BaCampoCodice`; il conto del nuovo invio (`BaAccessoTokens.nuovoInvioAttesa`, 30 s, solo il valore) |
| A3 · onboarding · A4 · termini | Primo accesso, termini e privacy | `BaPillola` | i testi; nessun componente specifico (**da verificare**) |
| A5 · nome | Nome, decisione aperta | `BaPillola` | il campo di testo |
| A6 · elenco | Elenco per l'ascoltatore | `BaPillola` | `BaRigaDen`, `BaIntestazione` |
| P1 · sali-avviso | Sali sul palco: avviso su voce e testo | `BaFoglio` (richiesta), `BaPillola` | — |
| P2 · sali-numero | Il numero | `BaFoglio`, `BaPillola` | il campo di testo |
| P3 · sali-codice | Codice SMS (**rimovibile**) | `BaFoglio` | `BaCampoCodice` |
| P4 · sali-consenso | Consenso a parlare | `BaFoglio`, `BaPillola` | — |
| P5 · sali-sale · P6 · con numero | Sale a microfono spento; avviso e consenso se il numero c'è già | `BaFoglio`, la stanza (vedi 002 · 1 bis) | — |
| T1 · torna-prima · T2 · torna-dopo | Impostazioni: «Torna ascoltatore» | `BaPillola` | `BaRigaImpostazione` |

Il foglio «Vuoi salire sul palco?» è **uno solo** che cresce passo per passo; ciò che sta sopra le azioni scorre, le azioni restano ancorate: è `BaFoglio`, con le altezze 0,80 e 0,62 (`BaAccessoTokens.foglioAltezza*`).

## 3. Creare e gestire i DEN: [Creare DEN 014](../../design/handoff/014/Creare%20DEN%20014.dc.html)

Creare un DEN in cinque passi, le due varianti del percorso da ascoltatore, gli stati, «Gestisci» e il sotto-DEN. Note in [`changelog.md`](../../design/handoff/014/changelog.md) e [`changelog-014b.md`](../../design/handoff/014/changelog-014b.md).

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| E1 · elenco | Elenco con «Crea un DEN» | `BaPillola` | `BaRigaDen` |
| C1 · tipo | Privato o pubblico | `BaPillola` | `BaSceltaDen` |
| C2 · nome | Nome, con il campo «Quando» spento | `BaPillola` | il campo di testo; `BaPuntoAggancio`; il campo «Quando» spento (token `BaCreazioneTokens.quando*`) |
| C3 · descrizione, tema e lingua | Un passo solo | `BaPillola` | `BaChipScelta`; il campo della descrizione |
| C4 · invita | Solo il privato | `BaPillola` | `BaPuntoAggancio` |
| C5 · riepilogo | «Crea il DEN» | `BaPillola` (la chiara) | — |
| C6 · creato | Nella stanza; chi ha creato è sul palco a microfono spento (dal 014b: presenza normale con il disco chiaro, variante «io» del 002) | `BaPalco`, `BaPresenza` (`io`, `microfonoSpento`) | — |
| R1, R2 · percorso da ascoltatore | Varianti di P1 e P4 del 013 | `BaFoglio` | — |
| S1 · limite · S2 · non riuscita | Limite di DEN attivi; creazione non riuscita | `BaMessaggio` (errore) | — |
| G1–G5 · gestisci | «Gestisci» dall'«Altro» della barra: co-amministratori, persone, rimozione, termine, descrizione | `BaFoglio`, `BaRigaAzione`, `BaMessaggio`, `BaBarraAzioni` («Altro») | `BaFoglioGestisci` |
| D1 · nuovo sotto-DEN | Un foglio: nome e regola | `BaFoglio` | `BaFoglioGestisci` (D1 vi è nominato), il campo di testo |

## 4. Coda e attesa: [Coda e attesa 015](../../design/handoff/015/Coda%20e%20attesa%20015.dc.html)

Mettersi in coda con l'ingresso automatico, «Le tue code», la notifica del posto libero, il sotto-DEN d'attesa, il posto conservato dopo la linea persa, la permanenza massima, gli stati. Note in [`changelog.md`](../../design/handoff/015/changelog.md), [`changelog-015b.md`](../../design/handoff/015/changelog-015b.md) e [`suono-e-vibrazione.md`](../../design/handoff/015/suono-e-vibrazione.md).

| Schermata | Che cosa mostra | Esistono | Mancano |
| --- | --- | --- | --- |
| K2 · metti-in-coda | Mettiti in coda, con l'ingresso automatico | `BaPillola`, `BaFoglio` | `BaInterruttoreRiga` (token `BaCodaTokens.interruttore*`) |
| K1 · code | «Le tue code» | `BaPillola` | `BaRigaCoda`, `BaIntestazione` |
| K3 · posto-libero-notifica | Notifica di sistema, ingresso automatico spento | — | la **notifica**: `BaNotificaAndroid` e la Live Activity non esistono (C5) |
| K4 · posto-libero-stanza | Nella stanza | `BaPalco`, `BaPillola`, `BaBarraAzioni` | il nuovo stato «Si è liberato un posto» è un'**ipotesi** (vedi [aperte](aperte.md)) |
| K5 · ingresso-auto-stanza | Ingresso automatico: sul palco | `BaPalco` | — |
| W1 · attesa-entra · W2 · attesa-dentro | «Aspetta con altri»; nel gruppo d'attesa | `BaPresenza` | `BaFasciaAttesa`, `BaInterruttoreRiga` |
| W3 · attesa-passaggio | Il posto si libera: dal gruppo al palco | `BaPalco` | `BaFasciaAttesa` |
| P1 · linea-persa · P2 · posto-tornato · P3 · posto-passato | Il posto resta tuo; la linea è tornata, il posto c'è o è passato | `BaStatoPalco.congelato`, `BaPresenza` (persa), `BaCodaTokens.oraDelPosto` | `BaBandaPosto` |
| M1 · permanenza-massima | Permanenza massima, punto di aggancio | — | `BaBandaPosto`, `BaPuntoAggancio` |
| S1 · coda-non-disponibile · S2 · coda-piena · S3 · uscita-coda | Stati della coda | `BaMessaggio` | — |

## 5. Prototipi precedenti

Due prototipi più vecchi restano nella repo come storia: [Schermate 001](../../design/handoff/001/Schermate%20001.dc.html) (accesso, impostazioni, superfici di sistema) e [Schermate 004](../../design/handoff/004/Schermate%20004.dc.html) (accesso, elenco dei DEN, stanza, attesa, impostazioni). Non sono la fonte da seguire per costruire: l'accesso del 013 è più recente, e la stanza e le attese sono nel 002 e nel 015. **Da verificare**, schermata per schermata, se qualcosa dei due vecchi prototipi vale ancora. `design/system/md/fase-2-schermate.md` e `stanza-den.md` sono esplorazione e storia, non norma (lo dice `CLAUDE.md`).

## Che cosa resta da costruire

Mettendo insieme le tabelle, i componenti dell'Inventario che servono alle schermate e **non esistono**:

| Componente | Serve a | Sezione dell'Inventario |
| --- | --- | --- |
| `BaIntestazione`, `BaMarcatore`, `BaRigaStato`, `BaAlone` | la stanza (002), gli elenchi | C2 |
| `BaRigaDen`, `BaRigaImpostazione`, `BaRigaBloccata` | gli elenchi e le impostazioni (013, 014) | C4 |
| `BaCampoCodice` | accesso (A2) e codice SMS (P3) | C4 |
| `BaSceltaDen`, `BaChipScelta`, `BaPuntoAggancio` | creare un DEN (014) e la permanenza massima (015) | C4 |
| `BaFoglioGestisci` | «Gestisci» e il sotto-DEN (014) | C4 |
| `BaInterruttoreRiga`, `BaRigaCoda`, `BaFasciaAttesa`, `BaBandaPosto` | coda e attesa (015) | C4 |
| il **campo di testo** (email, numero, nome, descrizione) | 013 e 014 | nessun nome nell'Inventario; token `BaAccessoTokens.campo*` e `BaCreazioneTokens.descrizioneAltezza` |
| la **fascia «chi mi sente»** | il sotto-DEN (002) | nessun nome nell'Inventario; token `BaAscoltoTokens` |
| `BaCardLive`, `BaIsola`, `BaNotificaAndroid` | superfici di sistema | C5 (non sono widget Flutter) |

Oltre ai componenti, **mancano le schermate**, la navigazione, l'accesso, l'audio, la connessione, il server: vedi [produzione](produzione.md). Nell'elenco dei task (`docs/tasks/README.md`) i componenti dei task 013–015 sono il task 022 e i contenuti dei fogli il 023, entrambi «brief da scrivere»; il prototipo navigabile in locale è il 024.
