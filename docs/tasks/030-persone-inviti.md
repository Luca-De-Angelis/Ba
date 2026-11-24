# Task 030 — Persone, inviti e richiamo (proposta)

24 novembre 2026 · chat di orchestrazione · per Claude Design

## Context

Il design ha l'accesso, la creazione dei DEN, la coda e gli stati critici; **non ha le persone**. Le risposte di Andrea e i documenti di origine dicono che esistono: D-039 (persone e inviti), D-038 («disponibile a chiacchierare» ti rende trovabile), D-041 (un ascoltatore entra in un DEN privato **solo se invitato**), D-042 (il richiamo) e D-054. Andrea ha chiesto di procedere con **proposte di Luca**: dove i documenti tacciono, **proponi e segna «ipotesi»**. Fonti: `DECISIONS.md` (D-038…D-042, D-052, D-055), `GLOSSARY.md`, `docs/origine/` (registro delle decisioni v4: nickname, following «fra persone»; tipologie di account; guida per il prototipatore: «cosa contiene un profilo, oltre al nickname» è una domanda aperta), `Creare DEN 014.dc.html` (C4 e il «posto» degli invitati, G2), `Coda e attesa 015.dc.html` (K7, K8: il richiamo), `Accesso 013.dc.html` (A1–A3, le impostazioni), `Account e controlli 027.dc.html`, `tokens.dart`.

## Do

1. **Aggiungere persone.** Il tasto «+» apre una superficie con un **campo di ricerca che filtra** (nickname o alias, mail, telefono) e una lista di **suggeriti** (chi hai frequentato di più). Una riga per persona: sagoma, nickname, e l'azione per aggiungere. **Il nome dell'azione** («segui/aggiungi») è da decidere: proponilo. I nickname possono ripetersi (registro v4): proponi come si distinguono (per esempio un alias unico, segnalato «ipotesi»). Stati: nessun suggerito, nessun risultato (con «Invita con un link»), persona aggiunta, errore di rete.
2. **La rubrica.** Il foglio di richiesta del permesso (titolo, testo, due azioni; il rifiuto è senza colpa), lo stato dopo il rifiuto, e la lista «Dalla rubrica» con chi c'è già su BA.
3. **Chi può trovarmi.** Una voce nelle impostazioni (`BaRigaImpostazione`) con le scelte nessuno, i miei contatti, tutti, e la sua conseguenza scritta; proponi il valore di partenza. Il profilo «pubblico» di «disponibile a chiacchierare» è del task di scoperta: qui solo la visibilità.
4. **Il posto degli invitati (C4).** Sostituisce la riga tratteggiata con la scelta delle persone aggiunte (lista e ricerca) e lo stato «invitato»; lo **stesso selettore** serve per il co-amministratore (G2). Mostra anche il passo con nessuna persona ancora scelta.
5. **«Sei stato invitato».** L'invito a un DEN privato **a chi ha BA** (notifica anche da schermo bloccato, e un foglio «Marta ti ha invitato a… · Entra · Non ora») e **a chi non ha BA** (la mail o il link, la pagina di arrivo, poi l'accesso con email del 013 e l'ingresso diretto nel DEN come ascoltatore, D-041). Stati: invito scaduto o annullato.
6. **Il richiamo (D-042).** La notifica esiste (015). Disegna **chi può mandarlo e chi può riceverlo** e come si spegne. **Principio che non si rompe:** nessuno deve poter sapere che una persona è online o in un DEN senza **il suo consenso esplicito**; il valore di partenza è spento. Proponi la forma (per esempio un consenso per persona o per gruppo) e segnala «ipotesi».
7. **Telefono e tablet.** Ogni schermata a 360 dp e a larghezza tablet; tedesco e testo 2,0 dove il testo è lungo (T11), con lo scorrimento mostrato.
8. **Token e documenti.** Nessun valore esistente cambia; un valore nuovo ha nome e riga «dove» in T6 ter (due livelli, D-019). Aggiorna `decisioni consolidate` (una sezione nuova), l'Inventario (i componenti nuovi) e `Fase 2 schermate`.

## Do NOT

- Non disegnare la scoperta, i creator, il podcast, l'abbonamento, l'account chiuso né i controlli a schermo bloccato; non cambiare la stanza, il palco e gli stati dei task 002, 011, 012.
- Niente contatori di follower o di amici, classifiche, stato «online», «visto da», segni del pagante, né chat testuali.
- Non cambiare i valori esistenti di `tokens.dart` (valori nuovi: nome e riga «dove»; controlla a mano ogni riga: niente testo dopo un «;» che non sia un commento, solo `widgets.dart`).

## Acceptance check

- [ ] Una sola azione chiara per schermata; il colore non porta mai l'informazione da solo.
- [ ] Nessuna schermata mostra o lascia dedurre che una persona è online o in un DEN senza il suo consenso.
- [ ] I nickname ripetuti hanno un modo per distinguersi; il rifiuto della rubrica è senza colpa e ha uno stato.
- [ ] «Sei stato invitato» esiste per chi ha BA e per chi non ce l'ha, fino all'ingresso nel DEN.
- [ ] Ogni ipotesi è segnata; ogni schermata a 360 dp e tablet; `tokens.dart` compila e ha solo righe aggiunte.

## Cosa restituire

In `design/handoff/030/`: screenshot con nomi parlanti (per esempio `persone-ricerca-360.png`, `invito-ricevuto-lock-360.png`), `changelog.md`, e lo zip del progetto con `tokens.dart` e i documenti aggiornati. In chat: il changelog in tabella (documento, sezione, prima, dopo, motivo) e ogni punto del brief che ti ha ostacolato, oppure «nessuno». Non rigenerare `tokens.diff.md`.
