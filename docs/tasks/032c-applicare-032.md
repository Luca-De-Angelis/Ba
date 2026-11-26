# Task 032c — Portare il consolidamento del design (032) nel codice

26 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Claude Design ha consegnato il 032 (consolidamento del design: dieci decisioni dove design e codice divergevano, più la regola sul genere grammaticale). Lo zip è in `Import/BA_design_032.zip` (cartella ignorata da git; non committarlo). Il `tokens.dart` nuovo compila (zero errori, solo `widgets.dart`) e rispetto a `main` ha **22 righe aggiunte e 2 modificate**: un commento e **un solo valore esistente cambiato**, `BaPersoneTokens.azioneRaggio` da 16 a 24 (`rounded3xl`); nessun colore esistente cambia (nuovo `a16` per il fondo dell'interruttore). Questo task fa in un colpo solo ciò che per 013–030 era diviso: **porta nella repo token, documenti e glossario, e applica al codice le decisioni segnate «cambia il codice: sì»**. Fonti: `design/handoff/032/changelog.md` (la tabella dei punti 1–10 con «prima, dopo, motivo, cambia il codice?» e la **scansione del genere**), `design/handoff/032/GLOSSARY.md`, le copie in `Import/copie-di-lettura-md-032/`, `docs/handoff/componenti.md`, `schermate.md` e `aperte.md`. Dove un documento tace, **proponi nel piano e segnala nel report**.

## Do

1. **Branch** `task/032c-applicare-032`, da `main` aggiornato (035 unito o no: non conta).
2. **Documenti di design** (commit a sé): confronta per hash lo zip con la repo e copia ciò che cambia (i `design/system/*.dc.html`, i prototipi `001`, `002`, `013`, `014`, `015` e `030` aggiornati, `design/handoff/032/` nuova con screenshot). Non copiare `tokens.dart` in `design/`; non sostituire file che nello zip sono più vecchi. Dimmi nel piano cosa copi e cosa no.
3. **`tokens.dart`** (commit a sé): sostituiscilo con quello dello zip; `git diff` = 22 righe aggiunte e 2 modificate; verifica con lo script temporaneo (non committato) che l'ARGB dei colori esistenti coincida. **Test nuovi** in `test/tokens_test.dart` per `text28`, `titoloSchermata`, `campo`, `cifra`, `curvaFoglio`, `sceltaPuntoLato`, `tratteggioTratto`/`Vuoto`/`Colore`, `interruttoreFondoAcceso`, `interruttorePallinoSpentoOpacita`; il test di `azioneRaggio` **cambia di proposito** (era `riquadro`, 16; ora `rounded3xl`, 24): è l'unico test esistente che si modifica per questo, e va detto.
4. **Copie Markdown.** Le fornisce Luca: da `Import/copie-di-lettura-md-032/` a `design/system/md/`, in un commit separato (cinque file: `token.md`, `inventario-componenti.md`, `fase-2-schermate.md`, `decisioni-consolidate.md`, `stanza-den.md`).
5. **Il codice, punto per punto** (un commit ciascuno, con i suoi test; ogni componente esistente toccato va nominato nel piano e **i test che cambiano vanno elencati**): **(1)** `BaSchermataCopertura` e i titoli di schermata intera (account chiuso e le pagine del 030) usano `BaTestoTokens.titoloSchermata`; **(2)** in `BaSchermataCopertura` testo e azione stanno nella stessa colonna (`BaLayoutTokens.larghezzaColonna`); **(3)** il raggio 24 si propaga a `BaRigaPersona` (verifica che con testo grande l'azione a capo non tagli); **(4)** `BaBarraAzioni`: le secondarie a 14 (`BaTestoTokens.azione`) e larghezza del testo, non uguale per tutte: «Scendi dal palco» sta su **una riga a 360 dp** a testo 1,0 (misura, e scrivi il numero nel report); il ripiego a colonna a testo grande resta; **(5)** il foglio sale con `curvaFoglio` (senza rimbalzo); **(6)** `campo`, `cifra`, `tratteggio*`, `interruttore*` e `sceltaPuntoLato` sostituiscono i valori a mano o equivalenti in `BaCampoTesto`, `BaCampoCodice`, `BaTratteggio`, `BaInterruttoreRiga`, `BaRigaPersona` (interruttore) e `BaChipScelta`/`BaSceltaDen`: **l'interruttore cambia aspetto di poco** (fondo .16 e pallino a metà da spento), tutto il resto resta uguale.
6. **I testi (genere grammaticale).** Applica la **scansione** del changelog (tabella «Scansione del genere nei testi»): «Invito di Marta», «Hai un invito», «Sei dentro, su invito di Marta», «✓ In lista», «In Famiglia c'è Ciccio · vuoi passare?», «Sei sul palco», «Hai lasciato la coda», «Confermi?», «Non è stato possibile aprirlo», «solo su invito» e, nel codice, «Persona bloccata: Dario V.» al posto di «Dario V.: bloccata»; cerca **ogni occorrenza** in `lib/l10n/` (ARB), `lib/prototipo/testi.dart`, `lib/galleria/` e nei test. **Non tradurre**: le altre lingue non cambiano (il changelog lo dice); verifica solo che le chiavi e i segnaposto coincidano. I **nomi di ruolo** («ascoltatore», «partecipante», «co-amministratore», «Torna ascoltatore») restano come sono: è una voce aperta del glossario.
7. **Glossario e documenti.** Sostituisci `docs/GLOSSARY.md` con `design/handoff/032/GLOSSARY.md` **dopo averlo confrontato con quello della repo**: Claude Design lo ha riscritto da una copia allegata e potrebbe non avere le voci aggiunte dopo (per esempio da 033); riporta ciò che manca e dimmelo nel report. Aggiorna `aperte.md`, `schermate.md`, `componenti.md` e `produzione.md`: chiudi le «differenze dal prototipo» ora risolte (titolo a 28, raggio a 16, «Rimuovi», «Termina il DEN», «Entra» a filetto, secondarie a 14), cita i testi nuovi dove compaiono («Marta ti ha invitato», «Sei stato invitato») e aggiungi le voci aperte: **due titoli di schermata intera** (22 per accesso e creazione, 28 per account chiuso e 030), **i nomi di ruolo con genere**, e le **barre sullo sfondo dei fogli di «Gestisci» nel 014** (vecchia riga, coperte dal velo). Elenco dei task: `docs/tasks/README.md` (032 concluso, 032c «In corso»).
8. **Report** con la riga «Impatto sull'handoff».

## Do NOT

- Non cambiare altri valori di `tokens.dart`; non toccare `design_system/` oltre ai componenti nominati al punto 5; niente Material o Cupertino, nuove dipendenze né numeri di design a mano.
- **«Entra nel gruppo» (015 W1) e «Ho capito» (S1) restano chiare**: sono gesti che solo la persona può fare o l'unica azione di un foglio di chiusura; non cambiare altre varianti.
- Non tradurre né modificare le lingue diverse dall'italiano.

## Acceptance check

- [ ] `git diff` di `tokens.dart`: 22 aggiunte e 2 modificate; ARGB dei colori esistenti invariati; il solo valore esistente cambiato è `azioneRaggio` (24).
- [ ] «Scendi dal palco» su una riga a 360 dp a testo 1,0 (misura nel report); a testo grande il ripiego a colonna non taglia.
- [ ] Nessun participio dipendente dal genere nei testi dell'italiano (`lib/l10n`, prototipo, galleria, test); le altre lingue invariate, segnaposto coerenti.
- [ ] `flutter analyze` e `flutter test` verdi (suite entro i 50 secondi); CI verde; il test sulla documentazione passa; i test esistenti modificati sono solo quelli elencati nel piano.

## Cosa restituire

Branch `task/032c-applicare-032`, report in `docs/reports/032c.md` (massimo 30 righe): esito del confronto dei colori, cosa copiato e cosa no, i test cambiati e perché, la misura di «Scendi dal palco», le voci del glossario riportate, ciò che non hai potuto verificare e la riga «Impatto sull'handoff». Pull request con il template.
