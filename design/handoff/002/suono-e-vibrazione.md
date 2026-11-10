# Suono e vibrazione — task 002

Tre regole che reggono la tabella.

1. Un suono mentre il microfono è aperto finisce nella stanza. Per questo i tre suoni esistono solo a microfono spento, e `BaSuonoTokens.consentito(microfonoAcceso: true)` è falso: il caso contrario non si può scrivere. Nel sotto-DEN i microfoni sono due (DEN principale e sotto-DEN): «acceso» vuol dire che almeno uno dei due è aperto, e in quel caso nessun suono.
2. Con il telefono in tasca la forza non si legge. I pattern si distinguono per numero e durata degli impulsi, non per ampiezza (`BaApticaTokens`, `BaPatternApticoTokens`).
3. Niente per le azioni di altri, né per chi entra o esce (ingresso morbido). Il segnale è di chi lo riceve e riguarda la sua scelta o il suo stato.

| Evento | Segnale | Motivo |
| --- | --- | --- |
| Microfono acceso | vibrazione `microfonoAcceso`: un impulso lungo e pieno (90 ms, 255). Nessun suono | Un suono a microfono aperto finisce nella stanza; il tatto basta e dice "aperto" |
| Microfono spento | suono `ba_mic_spento` (due note che scendono, 180 ms) e vibrazione `microfonoSpento`: due impulsi corti e leggeri (35 ms, 140) | Lo stato che conta di più con il telefono in tasca: il suono è sicuro perché il microfono è già chiuso |
| Salita sul palco | vibrazione `salitaSulPalco`: tre impulsi che salgono, pausa, e la firma di «spento». Nessun suono | Dice "sei salito" e "il microfono è spento" in un solo gesto; vale anche dalla coda e con l'ingresso automatico (D-007) |
| «Sto salendo…», «Mettiti in coda», «Sei in coda» | niente | Sono attese, non cambi di stato per cui agire |
| Posto libero, dalla coda | come «Salita sul palco» | È la salita |
| Parola ricevuta | vibrazione `parolaRicevuta`: tre impulsi uguali, pieni (50 ms, 255). Nessun suono | Stessa forza del microfono acceso; programmata su un istante del server perché arrivi insieme agli otto membri; un suono finirebbe nella stanza |
| «Parla a tutti» (con la parola in mano) | vibrazione `parolaRicevuta` | Da quel momento ti sentono tutti: lo stesso fatto, lo stesso segnale |
| «Parla solo al gruppo», con la parola in mano | vibrazione `soloGruppo`: un impulso corto e leggero (35 ms, 140). Nessun suono | Si distingue dal microfono acceso per durata e forza; la parola resta, quindi nessun suono di chiusura |
| Parola revocata | vibrazione `parolaRevocata`: un solo impulso, lungo (250 ms) e debole. Nessun suono | Si distingue per durata e non per forza: più lungo dell'acceso (90 ms), senza la ripetizione della parola ricevuta; senza urto e senza tono di colpa, la fascia dice il resto |
| Connessione persa | suono `ba_conn_persa` (una nota bassa, 300 ms) e vibrazione `connessionePersa`: due impulsi lunghi e deboli (200 ms, 90) | Il filo è caduto e la persona deve saperlo anche senza guardare. Lo stato del microfono appartiene alla connessione: cade il filo, il microfono è spento, quindi il suono è sicuro |
| Connessione ripresa | suono `ba_conn_ripresa` (due note che salgono, 220 ms) e vibrazione `connessioneRipresa` (= `microfonoSpento`) | Il filo è tornato; la firma di «spento» dice che il microfono non si è riacceso da solo |
| Rifiuto del consenso («Non ora») | niente | Nessuna conseguenza, nessun segnale: chi rifiuta resta com'era |
| Ingresso o uscita di altre persone | niente | Ingresso morbido: nessun annuncio dell'arrivo di nessuno, né con suoni né con animazioni |
| Qualcuno ha spento il microfono; qualcuno ha la parola | niente | Si legge sul palco (disco, tacca); non si annuncia |

Il volume dei tre suoni è metà di quello dei contenuti (`BaSuonoTokens.volumeRelativo`) e rispetta il tasto silenzioso e le cuffie. Un'app con il telefono silenzioso resta con le sole vibrazioni.
