# Task 027 — Aggiornamento dei design 013–015 dopo le risposte degli stakeholder

20 novembre 2026 · chat di orchestrazione · per Claude Design

## Context

Andrea ha risposto alle 19 domande e ha allegato i documenti di origine (registro delle decisioni v4, tipologie di account, brief di design v2.4). Le decisioni sono D-035…D-054 (`decisioni-da-aggiungere-2.md`); quelle che toccano il design sono **deliberate e senza punti aperti**, tranne dove è scritto «ipotesi». Questo task **corregge i prototipi 013, 014 e 015** e aggiunge **due schermate piccole**. Le ipotesi vecchie di quei task, dove la risposta le ha chiuse, **si tolgono**; quelle nuove si segnano. Fonti: `DECISIONS.md` (D-040…D-054 appena registrate), `GLOSSARY.md`, `Accesso 013.dc.html`, `Creare DEN 014.dc.html`, `Coda e attesa 015.dc.html` con i changelog, `Stati critici 002.dc.html`, `suono-e-vibrazione.md`, `tokens.dart`. **Non toccare** la stanza, il palco e gli stati dei task 002, 011 e 012.

## Do — correzioni

1. **013, registrazione (D-052).** Il passo del nome diventa **nickname obbligatorio** (anche ripetibile). In «Termini e privacy» entra la dichiarazione **«ho almeno 18 anni»** per tutti: una sola azione per schermata, quindi proponi la forma (una frase dentro «Accetto» o un passo a sé); l'età minima è 18, con l'obiettivo di 16 da decidere con il legale: segnala «ipotesi».
2. **013, consenso e tipo di account (D-040).** Il consenso **cambia il tipo di account**, non è un tap. Riprogetta «Torna ascoltatore» nelle impostazioni come cambio di tipo di account, con **doppia conferma**; se si è in conversazione, si esce dalla stanza. Il passaggio a partecipante può richiedere un nuovo accesso: segna «ipotesi · da definire con lo sviluppo». **Togli** il segno «il numero resta verificato» e il caso P6 (numero già verificato).
3. **013, elenco (D-041).** Togli il segno «nessun DEN privato su invito per l'ascoltatore»: **un ascoltatore entra in un DEN privato se invitato**. L'elenco resta di soli DEN pubblici (i privati non si trovano): l'invito è un percorso a parte (il pacchetto «persone e inviti», dopo la call).
4. **014, DEN pubblici (D-043).** Un DEN pubblico **creato da un utente ha come amministratore chi lo crea**, come un privato; la differenza è solo che si trova nell'elenco. Cambia la frase del tipo («Un DEN pubblico non ha un amministratore: lo modera l'app», che è vera solo per il DEN creato dal sistema, che non si crea da qui). **«Gestisci» esiste anche per i pubblici.**
5. **015, posto offerto e un solo DEN attivo (D-042).** Quando si libera un posto in coda si hanno **30 secondi** (valore variabile) per entrare, oppure vale il flag «accedi automaticamente». Mostralo come **frase ferma** («hai pochi secondi per salire»), senza conto alla rovescia, e disegna cosa succede quando scade (se si resta in coda: **ipotesi**). Se si è **già in un DEN**, non si entra da soli: arriva un avviso «si è liberato un posto in X, vuoi passare di qua?» con «Passa» e «Resta qui».
6. **015, il richiamo (D-042).** Una notifica («Ciccio è entrato nel DEN Famiglia · vuoi passare?») anche da schermo bloccato; è una **notifica, non un annuncio in stanza** (D-034). Chi può mandarlo e riceverlo e come si spegne è aperto: segna «ipotesi» e lascialo spento nelle impostazioni (la riga c'è, il resto aspetta).
7. **015, il resto.** **Togli** lo stato «Non puoi metterti in coda adesso» (code multiple libere). La permanenza massima (B05) vale per **ascoltatori e parlatori**: aggiorna il segno e mostra anche la variante sul palco. Il posto conservato resta com'è (tempi da definire).

## Do — due schermate nuove

8. **Account bannato (D-049).** Una schermata che **copre tutto**, all'apertura o al login, con un messaggio e **«Richiedi revisione» come unica azione**. Senza ban lievi (D-049). Per un eventuale blocco temporaneo, una riga opzionale con la durata: segna «ipotesi».
9. **Controlli a schermo bloccato (D-050).** Notifica fissa, Live Activity o widget con **mute/pausa, stop e next**. Il significato per stato: **sul palco**, «muta» spegne il microfono e **non può accenderlo** (D-025), «esci» è lo stop; **fra il pubblico**, «pausa» mette in silenzio l'audio e al ritorno si riprende dal vivo, «esci» è lo stop; **«next»** passa al DEN successivo: la fonte è da definire, segna «ipotesi». Mostra i due stati.

## Do NOT

- Non cambiare la stanza, il palco, gli stati dei task 002, 011, 012, né i componenti; non disegnare persone e inviti, la scoperta, i creator, il podcast, l'abbonamento.
- Niente conti alla rovescia, contatori che accumulano, segno del pagante; nessun annuncio dell'ingresso di altri nella stanza.
- Non cambiare i valori esistenti di `tokens.dart` (valori nuovi: due livelli, nome e riga «dove» in T6 ter; controlla a mano ogni riga: niente testo dopo un «;» che non sia un commento, solo `widgets.dart`).

## Acceptance check

- [ ] Nickname e «ho almeno 18 anni» nel flusso di registrazione, una sola azione per schermata.
- [ ] «Torna ascoltatore» è un cambio di tipo di account con doppia conferma; non esiste più il caso del numero già verificato.
- [ ] Il tipo «pubblico» non dice più «senza amministratore»; «Gestisci» vale anche per i pubblici.
- [ ] Il posto offerto ha una frase ferma e una scadenza; «vuoi passare di qua?» esiste; lo stato «non puoi metterti in coda» non c'è più.
- [ ] La schermata dell'account bannato ha una sola azione; i controlli a schermo bloccato hanno i due stati.
- [ ] Ogni ipotesi vecchia chiusa è tolta; ogni ipotesi nuova è segnata; ogni schermata a 360 dp e tablet, tedesco e testo 2,0 dove c'è testo lungo; il colore non porta mai l'informazione da solo.

## Cosa restituire

In `design/handoff/027/`: screenshot con nomi parlanti e `changelog.md`; i prototipi 013, 014 e 015 aggiornati nello zip del progetto con `tokens.dart` e i documenti (`decisioni consolidate`, Inventario, Fase 2). In chat: il changelog in tabella (documento, sezione, prima, dopo, motivo) e ogni punto del brief che ti ha ostacolato, oppure «nessuno». Non rigenerare `tokens.diff.md`.
