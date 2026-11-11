# Task 012d — Applicare l'esito del 012c: token dei glifi e geometria corretta

12 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Claude Design ha consegnato il 012c: `tokens.dart` con `BaPresenzaTokens.badgeBordo` (1,5) e la classe nuova `BaGlifoTokens` (tutte le proporzioni dei tre glifi), i documenti corretti, il prototipo `Stati critici 002.dc.html` che ora disegna anche l'altoparlante e il cerchio, e `design/handoff/012c/`. Lo zip è in `Import/BA_design_12018a.zip` (cartella già ignorata da git, non committarlo). Il `tokens.dart` nuovo compila (parser Dart, zero errori) e rispetto a quello di `main` ha **solo righe aggiunte**. Tre correzioni di Claude Design cambiano il disegno: onde dell'altoparlante con raggio 12 % e 26 % del lato e centro al 60 %; cerchio barrato al 72 % invece dell'84 %, con la barra dello stesso diametro; bordo del disco 1,5 come token. Questo task le porta nel codice.

## Do

1. **Branch** `task/012d-glifi-token`, da `main` aggiornato.
2. **Documenti.** Dallo zip copia `design/system/*.dc.html` (sostituiscono quelli di oggi), `design/handoff/002/` (il prototipo è cambiato) e `design/handoff/012c/`. Non copiare `tokens.dart` in `design/`; le altre cartelle `handoff/` dello zip sono già nella repo.
3. **`tokens.dart`.** Sostituisci `app/lib/design_system/tokens.dart` con quello dello zip. Il `git diff` deve contenere solo righe aggiunte: `badgeBordo` in `BaPresenzaTokens` e la classe `BaGlifoTokens`. Con lo script temporaneo (non committato) controlla che l'ARGB dei colori già esistenti coincida. Riporta l'esito nel report.
4. **`glifo.dart`.** Togli le costanti private delle proporzioni e usa `BaGlifoTokens.*`. Corpo, cono (con `conoBocca`, lato stretto in frazione dell'altezza), onde (`ondeCentroX`, i due raggi, `ondeGradi`) e cerchio (`cerchioLato`) seguono i token e il prototipo. La barra è lunga `barraLato` (0,84) per microfono e altoparlante e `cerchioLato` (0,72) per il cerchio, con alone `barraAlone`; il tratto è `BaGlifoTokens.tratto`. Aggiorna i commenti: l'altoparlante e il cerchio non sono più una proposta, sono confermati dal 012c.
5. **`BaDiscoGlifo`.** Il bordo del disco è `badgeBordo`, al posto del valore ricavato da `parolaTaccaSporge`. Le proporzioni dei token sono in frazione del lato del disco **misurato dentro il bordo**: il glifo occupa `badgeDiametro(d)` meno due volte `badgeBordo`. La tacca resta com'è, salvo che il prototipo dica altrimenti: segnalalo nel report.
6. **Test.** Aggiorna quelli che controllano la geometria (altoparlante, cerchio, barra, bordo, lato dentro il bordo) e aggiungi: lo stesso tratto di 2 dp a 28 e a 44 di lato; le due onde distano più del tratto a 28 di lato; il cerchio e la sua barra hanno lo stesso diametro. Tutti gli altri test restano invariati.
7. **Copie Markdown.** Le fornisce Luca: copiale da `Import/copie-di-lettura-md-012d/` in `design/system/md/`, in un commit separato.
8. **Documenti di progetto.** `docs/tasks/README.md`: 012 «Concluso», 012c «Concluso», 012d «In corso».

## Do NOT

- Non modificare altri stati o componenti, né i valori consegnati.
- Non aggiungere token oltre a quelli consegnati; se manca qualcosa, segnalalo.
- Niente Material, niente nuove dipendenze, niente golden, nessun numero di design a mano.

## Acceptance check

- [ ] `git diff` di `tokens.dart`: solo righe aggiunte, solo `badgeBordo` e `BaGlifoTokens`.
- [ ] Nessuna costante di proporzione dei glifi resta nel codice: tutte da `BaGlifoTokens`.
- [ ] `flutter analyze` e `flutter test` verdi; CI verde.
- [ ] Nella galleria, la verifica di Luca: le due onde dell'altoparlante si distinguono a 28; il cerchio barrato è più piccolo di prima, a circa 4 dp dal bordo del disco; i tre glifi pesano ugualmente; a 88 dp i segni restano leggibili.

## Cosa restituire

Branch `task/012d-glifi-token`, report in `docs/reports/012d.md` (massimo 15 righe): esito del confronto dei colori, differenze inattese in `tokens.dart`, tempo della suite. Pull request con il template.
