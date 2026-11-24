# Handoff: la porta d'ingresso

Se arrivi da fuori e non sai da dove cominciare, parti da qui. Questa cartella spiega che cosa è la repository, che cosa è il prototipo che contiene e che cosa **non** è, e dove si innesta il resto (il server, l'audio in tempo reale). Ogni affermazione è verificata nel codice o nei documenti; dove non si poteva, c'è scritto «da verificare».

Aggiornata il 18 novembre 2026, al task 025. La lingua del progetto è l'italiano: se serve l'inglese per il team, si chiede dopo.

## Che cos'è BA, in dieci righe

1. **Un social vocale basato sulla presenza.** Le persone stanno nei **DEN**: spazi vocali con un **palco di massimo 8 persone che parlano** e un pubblico che ascolta (`CLAUDE.md`, brief v2.1 §1).
2. **Si entra sempre nel pubblico** e si sale sul palco se c'è posto, sempre a microfono spento (D-006, D-007); chi ascolta può mettersi in coda.
3. **Dentro un DEN possono esistere sotto-DEN:** gruppi fino a 8 persone che ascoltano il DEN e parlano fra loro; chi riceve la parola è sentito da tutti.
4. **Tutto è effimero per scelta:** nessuna conversazione si può riascoltare, niente archivi né cronologie (D-004).
5. **L'app è per lo più non guardata:** si usa in tasca, al buio, a schermo spento. Gli stati critici (microfono acceso o spento, chi ti sente) non si affidano mai alla sola vista o al solo colore.
6. **L'ingresso è morbido:** si arriva senza essere annunciati, né con suoni né con animazioni (D-034). Non esiste una chat testuale nelle stanze.
7. **Il pubblico è il contenuto:** nessuna star al centro; un abbonato non deve apparire superiore, solo attrezzato meglio.
8. **Si comincia da ascoltatore** con un codice via email; il numero di telefono e il consenso a parlare si chiedono solo per salire sul palco (D-031, D-024).
9. **Un'app Flutter, iOS e Android,** una sola base di codice; tema unico scuro; telefono da 360 dp e tablet dalla beta 1, per ora solo in verticale (D-019, D-020, D-022).
10. **Cinque lingue** (italiano, inglese, francese, spagnolo, tedesco); il claim è «La Live sei tu».

## Che cosa contiene la repository

```
ba/
├── CLAUDE.md           le istruzioni per chi lavora al codice con Claude Code
├── README.md           lo scheletro della repo e il ciclo di un task
├── .github/            la CI (ci.yml) e il template della pull request
├── .claude/commands/   il comando /verify (la verifica prima della pull request)
├── docs/               decisioni, glossario, funzionalità, brief, task, report, ricerca, ADR, e questa cartella
├── design/             le consegne di Claude Design: token, inventario dei componenti, prototipi
└── app/                il progetto Flutter: design system, galleria, traduzioni, test
```

Le **fonti di verità, in ordine** (`CLAUDE.md`): [`docs/DECISIONS.md`](../DECISIONS.md) (le decisioni prese: non si cambiano senza chiedere), i brief in [`docs/brief/`](../brief/README.md) (dove divergono, vale l'ultimo), [`app/lib/design_system/tokens.dart`](../../app/lib/design_system/tokens.dart) (ogni valore visivo), i documenti di design in [`design/system/md/`](../../design/system/md/inventario-componenti.md) (sono copie di lettura: se divergono vale `tokens.dart`), i task in [`docs/tasks/`](../tasks/README.md) e le consegne in [`design/handoff/`](../../design/handoff/README.md). Il lessico è quello di [`docs/GLOSSARY.md`](../GLOSSARY.md), il registro delle funzionalità è [`docs/FEATURES.md`](../FEATURES.md).

## Che cos'è il prototipo, e che cosa non è

**È:** un **design system in Flutter** (i token e 40 componenti, ciascuno con i suoi test) e una **galleria** per vederli in Chrome, più la documentazione di progetto. Il lavoro è stato fatto con Claude Code, un task alla volta ([`docs/tasks/`](../tasks/README.md), con un report per ciascuno in [`docs/reports/`](../reports/)).

**Non è:**

- **un'app che funziona:** `main.dart` è uno schermo vuoto; non ci sono schermate, navigazione né accesso;
- **un server:** nessun codice del server, della connessione, della trascrizione;
- **audio:** nessuna integrazione con LiveKit o con altro; nessun suono, nessuna vibrazione (esistono solo i valori e la specifica);
- **dati veri:** persone, nomi e conteggi della galleria sono di prova; nessun servizio esterno è collegato.

Il team di sviluppo ha il suo server e il suo audio: **non stanno in questa repo** (`CLAUDE.md`). I punti dove il codice si innesta con il resto sono in [produzione](produzione.md).

## I file di questa cartella

| File | Che cosa trovi |
| --- | --- |
| [avvio.md](avvio.md) | Come farlo girare: la versione di Flutter, le dipendenze, la galleria in Chrome, analisi e test |
| [architettura.md](architettura.md) | Come è fatto: la struttura di `app/lib/`, i principi, il modello della stanza, come si aggiunge un componente o un token |
| [componenti.md](componenti.md) | La tabella dei componenti, ricavata dal codice: stati, token, test, fonte di design, note per la produzione; e quelli non ancora costruiti |
| [schermate.md](schermate.md) | Dalle schermate dei prototipi ai componenti: quali esistono e quali no |
| [regole.md](regole.md) | Le regole di prodotto che toccano il codice, in forma operativa, con la decisione di ciascuna |
| [aperte.md](aperte.md) | Tutte le ipotesi segnate, con la domanda agli stakeholder (1–19) e che cosa cambia se la risposta è diversa |
| [produzione.md](produzione.md) | Dal prototipo alla produzione: che cosa è finto, i punti d'innesto con server e audio, suono e vibrazione, accessibilità, traduzioni, CI |

## Da dove cominciare

**Se sviluppi in Flutter.** [avvio](avvio.md) per farlo girare e provare la galleria; poi [architettura](architettura.md) e [componenti](componenti.md); poi [regole](regole.md) (le regole che il codice deve rispettare) e [schermate](schermate.md) (che cosa resta da costruire). Quando aggiungi un componente, aggiungi la sua riga in [componenti](componenti.md): il test lo controlla.

**Se sviluppi il server o l'audio.** Parti da [produzione](produzione.md): che cosa si aspettano i componenti in ingresso (`BaPersonaPalco`, `parla`, `ampiezza`, `BaPayloadStanza`), che cosa non esiste, e il suono e la vibrazione. Poi [regole](regole.md) (D-025 il microfono si spegne solo da fuori, D-029 lo stato del microfono appartiene alla connessione, D-034 gli annunci) e le domande 18 e 19 in [aperte](aperte.md). La tabella degli eventi di suono e vibrazione è in [`design/handoff/015/suono-e-vibrazione.md`](../../design/handoff/015/suono-e-vibrazione.md).

**Se gestisci il prodotto.** Parti da [aperte](aperte.md) (le ipotesi e le domande ancora senza risposta), poi [schermate](schermate.md) e [regole](regole.md); per le funzionalità il registro [`docs/FEATURES.md`](../FEATURES.md) e per le decisioni [`docs/DECISIONS.md`](../DECISIONS.md).

## Come si tiene aggiornata

- **Quando si aggiunge un componente**, si aggiunge una riga in [componenti](componenti.md): il test [`app/test/documentazione_test.dart`](../../app/test/documentazione_test.dart) fallisce se manca, se un link relativo di questa cartella è rotto o se questo indice non elenca un file. Lo dice anche `CLAUDE.md`.
- **Quando cambia una decisione o una regola**, si aggiornano [regole](regole.md) e, se serve, [aperte](aperte.md). Una decisione non si cambia in silenzio: se ne aggiunge una nuova in `DECISIONS.md`.
- **Ogni report di task** ha una riga «Impatto sull'handoff» (che cosa cambia qui; «nessuno» se niente) e il template della pull request ha la stessa voce. L'aggiornamento completo di questa cartella è il task 026, prima della consegna, dopo le risposte degli stakeholder e dopo i task 022–024.
- **Le affermazioni «da verificare»** sono elencate nel report del task 025 ([`docs/reports/025.md`](../reports/025.md)): chi può verificarle le chiude qui.
