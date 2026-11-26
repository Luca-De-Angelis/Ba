# Task 032 — Consolidamento del design (changelog)

26 novembre 2026. Nessuna schermata o componente nuovo. Il glossario aggiornato è `GLOSSARY.md` in questa cartella (il file della repo è `docs/GLOSSARY.md`: va sostituito). Screenshot in `screenshots/`. Solo righe aggiunte in `tokens.dart`, tranne un valore cambiato (riga 3). `tokens.diff.md` non rigenerato. «Cambia il codice?» dice quale dei due vale; un task successivo porta la decisione nel codice.

## Punti 1–10

| N. | Documento · sezione | Prima | Dopo | Motivo | Cambia il codice? |
| --- | --- | --- | --- | --- | --- |
| 1 | tokens.dart · BaTestoTokens · T6 ter `testo/titolo-schermata` | B1 e B2 (027) a 28; il codice usa `stanza` (22); nessun token | **Vale 28.** `BaPrimitiveTokens.text28` (eccezione: fuori scala, fra 2xl e 3xl) e `BaTestoTokens.titoloSchermata` (28/600, tracking −0,26, leading tight). Dove: account chiuso (B1, B1 bis, B2) e le pagine del 030. Il 22 (`stanza`) resta il nome della stanza e i titoli dell'accesso e della creazione | un titolo di schermata intera non è il nome della stanza: sono due ruoli | **Sì.** `BaSchermataCopertura` passa a `titoloSchermata`; le pagine del 030 solo se il prototipo navigabile le ha a 22 |
| 2 | Inventario · BaSchermataCopertura; T6 ter `copertura/colonna` | 027 a 744: colonna e azione di 512; il componente ha l'azione più larga del testo | **Vale il prototipo.** Testo e azione stanno nella stessa colonna (`BaLayoutTokens.larghezzaColonna`, 512 a 744 dp): l'azione è larga come la colonna, non come lo schermo né come il suo testo. Nessun token nuovo | una sola colonna per leggere e toccare | **Sì.** L'azione dentro la colonna |
| 3 | tokens.dart · `BaPersoneTokens.azioneRaggio`; T6 ter `persone/riga` | token `rounded2xl` (16); prototipo 030 a 24 | **Vale 24:** `azioneRaggio = rounded3xl`. **Valore cambiato** (era 16) | la stessa forma delle altre azioni testuali (015, fogli): a una riga è una pillola, a capo cresce senza tagliare il testo | **Sì.** Il valore del token |
| 4 | Inventario · barra delle azioni (C3); T6 ter `barra/secondarie`; 015 e 030 | secondarie 16 nel codice, 14 nel prototipo 002; larghezze uguali: «Scendi dal palco» va su due righe a 360 dp | **Vale 14** (`BaTestoTokens.azione`) **e larghezza del testo più il riempimento**, pari altezza (48). Misurato a 360 dp, testo 1,0: «Scendi dal palco» è 104 dp di testo (128 con il riempimento), una riga; le due secondarie con «Altro» e gli spazi occupano 246 dp su 320. A testo grande il ripiego a colonna resta (T11). L'Inventario dice anche la regola `inAltro` (punto 8). Applicato ai prototipi 015 e 030 (stesse barre con larghezze uguali) | la secondaria è sotto la primaria nella gerarchia; con larghezze uguali la parola più lunga decide per tutte | **Sì.** Da 16 a 14 e larghezza dal contenuto |
| 5 | tokens.dart · `BaMovimentoTokens.curvaFoglio`; T8; T6 ter `movimento/curva-foglio` | «il foglio sale senza rimbalzo», a parole; il codice limita a 1 l'uscita di `curvaScheda` | **`cubic-bezier(.34,1,.64,1)`**: la stessa curva di `curva/scheda` con il secondo punto a 1, cioè senza rimbalzo. Un valore, non una terza famiglia | un rimbalzo lascia una striscia vuota sotto il foglio | **Sì.** `BaFoglio` usa `curvaFoglio` al posto del limite |
| 6a | tokens.dart · BaTestoTokens `campo` (20/400) e `cifra` (22/400) | stili senza token (20/400 del campo, 22/400 della cifra del codice) | token con nome; `foglio` (20/600) resta dei titoli | il campo non è un titolo | **Sì.** `BaCampoTesto` e `BaCampoCodice` li usano |
| 6b | tokens.dart · `BaCreazioneTokens.tratteggio*`; T6 ter `tratteggio` | il tratteggio senza token (il browser disegna 3 e 3) | tratto `sp1_5` (6), vuoto `sp1` (4), colore `a32` su pietra100: **vale il codice**; il tratteggio del prototipo è un'approssimazione | i valori sono già quelli di `BaTratteggio` | Solo il nome (stessi valori) |
| 6c | tokens.dart · `BaCodaTokens.interruttoreFondoAcceso` (con `BaPaletteTokens.a16`) e `interruttorePallinoSpentoOpacita` (0,5) | il codice usa `azioneAttivaFondo` per l'interruttore acceso; fondo .16 e pallino .5 senza token | **Vale il prototipo:** sabbia300 a16 e pallino a 0,5 | `azioneAttivaFondo` è il fondo della pillola «attiva», non un tono di stato | **Sì.** Il fondo dell'interruttore |
| 6d | tokens.dart · `BaCreazioneTokens.sceltaPuntoLato` (`sp2_5`) | il punto interno della scelta usa `BaSpazioTokens.sm`, senza token dedicato | token con nome, 10 | stesso valore | Solo il nome |
| 7 | 014 · G3 bis, G4; 030 · I2 | «Rimuovi», «Termina il DEN» e «Entra» chiare | **Attive (a filetto)** | BaRegole 1: la chiara solo dove l'app non prosegue senza il gesto; sono distruttive o non bloccano niente | **No:** il codice (023b, 033) è già così |
| 8 | Inventario · barra (C3) | la regola `inAltro` non c'era | scritta: un'azione può essere segnata «va in Altro»; l'ascoltatore ha primaria, «Esci» e «Altro», con «Impostazioni» e «Persone bloccate» dentro; primaria e azioni fisse non si segnano | come costruito nel 024a (task 034) | **No** |
| 9a | Inventario · C0 | «Venti widget Flutter (C1–C4)» | 35 righe nelle tabelle C1–C4: 33 widget Flutter, più `BaFasciaTesto` (rinviato) e `BaControlliBloccato` (superficie di sistema) | il numero non coincideva con le righe | **No** |
| 9b | Fase 2, Stanza DEN, 001, 002 | mock con 15, 13, 11 e 10 px (304 + 130 + 72 + 7 occorrenze) | portati a 16, 14, 12 e 12 (`corpo`, `minore`, `marcatore`, `nota`); nessun testo tagliato (controllo dei riquadri) | le taglie confermate dal task 004 | **No** |
| 9c | Inventario · barra | «(handoff 004b)» | «(T11)» | un avanzo del 004 | **No** |
| 10 | GLOSSARY.md, decisioni consolidate 5.F, 013, 014, 015, 030 | participi dipendenti dal genere | regola nel glossario e scansione (sotto) | un testo non deve scegliere il genere di una persona | Sì, nei testi e in `lib/l10n` |

## Scansione del genere nei testi (punto 10)

Regola: l'interfaccia italiana non usa participi o aggettivi che dipendano dal genere di una persona nominata né di chi usa l'app. Forme: l'evento come nome («Invito di Marta»), il presente («Sei dentro», «Sei sul palco»), «In lista», «Persona bloccata». Gli accordi con un sostantivo (posto passato, persona aggiunta) sono ammessi, ma non accanto al nome di una persona. I verbi con *avere* (hai lasciato) non si accordano. Il tedesco usa già le forme inclusive e i suoi participi non si accordano.

| Dove | Prima | Dopo |
| --- | --- | --- |
| 030 · I1 notifica | «Marta ti ha invitato.» | «Invito di Marta.» |
| 030 · I2, I4, I5 titolo | «Marta ti ha invitato a Cena senza fretta» | «Invito di Marta a Cena senza fretta» |
| 030 · gruppo I | «Sei stato invitato» | «Hai un invito» |
| 030 · I6 | «Sei entrato su invito di Marta. Ascolti.» | «Sei dentro, su invito di Marta. Ascolti.» |
| 030 · P5 | «✓ Aggiunta» (accanto a «Davide») | «✓ In lista» |
| 015 · K7 richiamo | «Ciccio è entrato nel DEN Famiglia · vuoi passare?» | «In Famiglia c'è Ciccio · vuoi passare?» |
| 015 · K3 bis | «Sei salito sul palco · …» | «Sei sul palco · …» |
| 015 · K5 | «Sei salito sul palco. Il microfono è spento.» | «Sei sul palco. Il microfono è spento.» |
| 015 · S2 | «Sei uscito dalla coda di …» | «Hai lasciato la coda di …» |
| 013 · T3 | «Ne sei sicuro?» | «Confermi?» |
| 014 · S2 | «Non siamo riusciti ad aprirlo.» | «Non è stato possibile aprirlo.» |
| 013 · intestazione e A6 | «solo se invitato» | «solo su invito» |
| codice · `lib/l10n` (non nei prototipi: il 001 mostra «Dario V. · in aprile») | «Dario V.: bloccata» | «Persona bloccata: Dario V.» |
| decisioni consolidate 5.E, glossario (Richiamo, Invito) | le frasi sopra | le frasi nuove |

**Non cambiati:** il tedesco; i nomi di ruolo («ascoltatore», «partecipante», «co-amministratore», «Torna ascoltatore»), che sono termini del glossario e restano al maschile finché non si decide una forma neutra.

## Fuori da questo giro, nei documenti della repo

`docs/handoff/aperte.md`, `schermate.md` e `componenti.md` (non in questo progetto) citano ancora «Marta ti ha invitato», «Sei stato invitato» e le «differenze dal prototipo» di «Rimuovi», «Termina il DEN», «Entra», il raggio a 16 e il titolo a 28: ora sono chiuse e si possono togliere.

## Dove il brief ostacola

- **Il glossario non è nel progetto.** Ho riscritto `GLOSSARY.md` dalla copia allegata: va sostituito in `docs/GLOSSARY.md`.
- **I nomi di ruolo** («ascoltatore», «co-amministratore»…) hanno un genere. Non si risolve senza una decisione sui termini del glossario: è una voce aperta.
- **Due titoli di schermata intera.** 22 (accesso, creazione) e 28 (account chiuso, 030). Li ho dichiarati entrambi con il loro uso; uniformarli cambia il design e non è di questo task.
- **«Mock 15, 13, 11 e 10»:** l'ho letto come le taglie di testo dei mock. Se intendevi altro, dimmelo.
- **014:** le barre sullo sfondo dei fogli di «Gestisci» sono ancora la riga vecchia («Esci · azione · ⋯»): sono coperte dal velo e non le ho rifatte.
- **«Entra nel gruppo» (015 W1) e «Ho capito» (S1)** sono ancora chiare: non erano nel task, e per BaRegole 1 «Entra nel gruppo» dovrebbe essere a filetto. Da confermare.
- **Il cambio di 24 al raggio** (punto 3) cambia un valore esistente: l'unico.
