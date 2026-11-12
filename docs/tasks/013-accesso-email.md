# Task 013 — Accesso con email e verifica del numero per parlare

12 novembre 2026 · chat di orchestrazione · per Claude Design

## Context

I soci hanno confermato A01 (catalogo dei servizi): l'account di base è da **ascoltatore**, si entra con un **codice via email** e si vedono **solo i DEN pubblici**. Il **numero di telefono verificato** e il **consenso a parlare** servono solo per parlare (A03) e si chiedono quando l'ascoltatore tocca «Sali sul palco» (D-024). Google e Apple arrivano dopo l'alpha (A02). Questo sostituisce D-002, su cui è costruito il flusso 5a del task 001: numero, SMS e consenso a parlare all'ingresso. Fonti: `DECISIONS.md` (D-003, D-004, D-013, D-024, D-031), `GLOSSARY.md`, `aggiornamento-v2.3.md`, `FEATURES.md` (A01–A03), `Schermate 001.dc.html` e il task 002 («Vuoi salire sul palco?»), `tokens.dart`. Il lessico è quello del glossario: «ascoltatore» è l'account di base con email e senza numero; «partecipante» ha numero verificato e consenso a parlare.

## Do

1. **L'accesso dell'ascoltatore.** Una sola azione chiara per schermata: **email → codice via email → onboarding → termini e privacy → nome (decisione aperta: lascia lo spazio) → elenco dei DEN**. L'onboarding mantiene l'avviso su voce e testo del 001b (D-013). L'elenco mostra solo i DEN pubblici e il marcatore fermo «sei ascoltatore», senza invito a cambiare. Non ci sono più numero, SMS né consenso a parlare all'ingresso. Riusa `BaCampoCodice` per il codice. Disegna gli stati dell'errore: codice sbagliato, codice scaduto, nuovo invio con attesa. Senza colpevolizzare, in una frase.
2. **Un punto di aggancio.** A02 (Google e Apple) arriva dopo l'alpha. La schermata dell'email deve poter accogliere in seguito un'alternativa «Continua con…» senza essere ridisegnata. Mostra la regola, non i pulsanti.
3. **Il percorso «diventa partecipante».** Estendi il foglio «Vuoi salire sul palco?» del task 002. Per un ascoltatore **senza numero**: avviso su voce e testo → numero → codice SMS → consenso a parlare → sale a microfono spento («Salirai a microfono spento»). Per chi ha **già il numero verificato** (ipotesi, vedi sotto): solo avviso e consenso, come oggi. Una sola azione per passo, «Non ora» in ogni passo senza conseguenze, e il passo SMS deve poter sparire (verifica tramite operatore) senza ridisegnare gli altri.
4. **«Torna ascoltatore» (5d).** Aggiorna il testo della riga e lo stato dopo il tocco: non si parla più, ma il numero resta verificato e per tornare a parlare basta il consenso. È un'**ipotesi da confermare con i soci**: nella schermata, un segno visibile «da confermare» che si toglie in un punto solo.
5. **Telefono e tablet.** Ogni schermata a 360 dp e a larghezza tablet in verticale (colonna centrale e margini dei token). Tedesco e testo di sistema 2,0 per le schermate con testo lungo: vale la regola in T11 (ciò che sta sopra le azioni scorre, le azioni restano ancorate) e mostra lo stato scrollato.
6. **Token e documenti.** Nessun valore esistente cambia. Un valore nuovo va in `tokens.dart` con la regola dei due livelli (D-019), nome, e la riga «dove» in T6 ter. Aggiorna `Fase 2 schermate` (la sezione 5a), `decisioni consolidate` (§5.A) e l'Inventario dove cambiano.

## Ipotesi da segnare, in attesa dei soci

- Un ascoltatore **non** entra in un DEN privato su invito (D01): nel flusso non c'è nessun ingresso privato per l'ascoltatore.
- Dopo «Torna ascoltatore» il **numero resta verificato**.
- Il passo del **nome** resta aperto, come nel 001.

## Do NOT

- Non cambiare la stanza, il palco e gli stati disegnati nei task 002 e 012, né il lessico del glossario.
- Non disegnare Google e Apple (A02) oltre al punto di aggancio, né bio, dispositivi collegati o profilo (A04, A05).
- Non affidare uno stato solo al colore; niente conti alla rovescia che accumulano; niente codici di invito all'ingresso.
- Non cambiare i valori esistenti di `tokens.dart`; controlla a mano ogni riga che modifichi: niente testo dopo un «;» che non sia un commento.

## Acceptance check

- [ ] L'accesso dell'ascoltatore ha una sola azione per schermata e nessun numero, SMS o consenso a parlare.
- [ ] L'elenco mostra solo i DEN pubblici e il marcatore «sei ascoltatore».
- [ ] Il percorso «diventa partecipante» copre i due casi (senza numero e con numero), ha «Non ora» ovunque e il passo SMS è rimovibile.
- [ ] «Torna ascoltatore» ha il testo nuovo e il segno «da confermare».
- [ ] Ogni schermata esiste a 360 dp e a larghezza tablet; tedesco e testo 2,0 con scorrimento mostrato.
- [ ] Nessun termine vietato dal glossario; `tokens.dart` compila e ha solo righe aggiunte.

## Cosa restituire

In `design/handoff/013/`: screenshot con nomi parlanti (per esempio `email-360.png`, `codice-errore-360.png`, `sali-numero-360.png`), `changelog.md`, e lo zip del progetto con `tokens.dart` e i documenti aggiornati. In chat, come testo: il changelog in tabella (documento, sezione, prima, dopo, motivo) e ogni punto del brief che ti ha ostacolato, oppure «nessuno». Non rigenerare `tokens.diff.md`.
