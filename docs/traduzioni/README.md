# Revisione delle traduzioni

Qui ci sono i fogli per far rivedere le traduzioni dell'interfaccia ai madrelingua (D-045; `CLAUDE.md`: le chiavi nuove si rivedono **prima del rilascio**). C'è **un file per ogni lingua** diversa dall'italiano, che è il riferimento:

| File | Lingua |
| --- | --- |
| `revisione-en.csv` | inglese |
| `revisione-fr.csv` | francese |
| `revisione-es.csv` | spagnolo |
| `revisione-de.csv` | tedesco |

Li prepara `app/tool/revisione_traduzioni.dart` da **tutti** i file `app/lib/l10n/app_*.arb`: una lingua nuova negli ARB genera il suo file. Gli ARB non si toccano da qui.

## Cosa c'è in ogni file

Una riga per chiave, con queste colonne:

| Colonna | Che cosa è |
| --- | --- |
| `chiave` | il nome del testo nel codice; non si cambia |
| `contesto` | dove compare e a chi serve (la descrizione dell'ARB): leggila prima di giudicare il testo |
| `italiano` | il testo di partenza |
| `inglese (en)`, … | il testo della lingua da rivedere |
| `correzione` | **qui scrivi** il testo corretto, solo dove cambia; vuota = va bene così |
| `nota` | **qui scrivi** il perché, un dubbio o una domanda; vuota se non serve |
| `lunghezza` | i caratteri del testo attuale (il tedesco allunga le etichette fino al 30%: conta per i layout) |
| `segnaposto` | i nomi fra graffe che il testo contiene (`nome`, `n`); vuota se non ce ne sono |

## Come si apre

Il file è UTF-8 con BOM e le colonne sono separate da **punto e virgola** (`;`).

- **Excel**: doppio clic sul file. Se le colonne non si separano e tutto sta nella prima: *Dati → Da testo/CSV*, scegli il file, **Delimitatore: punto e virgola**, **Origine file: UTF-8**, *Carica*.
- **Google Fogli**: *File → Importa → Carica*, scegli il file, **Tipo di separatore: Personalizzato**, scrivi `;`, *Importa dati*.

Salva sempre come **CSV (UTF-8, delimitato da punto e virgola)**; altrimenti gli accenti si rovinano.

## Come si compila

1. Leggi `contesto` e `italiano`, poi il testo della tua lingua.
2. Se il testo va corretto, scrivi la versione giusta in `correzione`. Non modificare le altre colonne.
3. **Non cambiare i segnaposto**: `{nome}` e `{n}` restano uguali e fra graffe, anche se la frase cambia ordine. Nei plurali (`{n, plural, =0{…} =1{…} other{…}}`) cambiano solo i testi dentro le graffe, e i tre casi restano.
4. Usa `nota` per il perché o per un dubbio.
5. Restituisci il file con lo stesso nome.

**Una nota di contesto.** La chiave `presenzaBloccata` è stata cambiata in italiano da «{nome}, persona bloccata» a **«Persona bloccata: {nome}»**: la persona prima del nome, perché il nome non porti un genere (l'aggettivo dopo il nome si accorda con chi è nominato). Se nella tua lingua c'è lo stesso problema, adegua il testo e scrivilo in `correzione`.

## Come si riporta una correzione negli ARB

Lo fa chi sviluppa, **a mano**, e nessuno script scrive gli ARB:

1. Apri `app/lib/l10n/app_<lingua>.arb` e sostituisci il valore della chiave con la `correzione` (stessi segnaposto, stessa chiave).
2. `flutter gen-l10n` (o `flutter test`, che lo lancia da solo) e i test passano; se la correzione tocca un testo provato da un test (per esempio `app/test/l10n_palco_test.dart`), si aggiorna il test.
3. **Svuota** la cella `correzione` (e `nota`) di quella riga nel CSV, o rigenera il file (sotto).
4. Il commit dice quali chiavi e quale lingua.

## Come si rigenerano i file

Da `app/`: `dart run tool/revisione_traduzioni.dart`. Rilegge gli ARB e riscrive i CSV. Se un CSV ha già `correzione` o `nota` scritte **non lo sovrascrive** (così non si perde il lavoro dei madrelingua); dopo aver riportato le correzioni negli ARB, `dart run tool/revisione_traduzioni.dart --forza` lo riscrive da capo. Due corse sugli stessi ARB danno file identici (non c'è la data).

Lo script avvisa se una chiave manca in una lingua (la cella resta vuota) e finisce con un errore se i segnaposto di una lingua non coincidono con quelli dell'italiano.
