# Task 004 — Token alla Tailwind e layout tablet

6 novembre 2026 · chat di orchestrazione · per Claude Design

## Context

Due decisioni nuove: token e scale seguono il modello di Tailwind restando in Flutter (D-019); l'app è mobile first e supporta il tablet in verticale dalla beta 1 (D-020). Oggi `tokens.dart` ha nomi semantici di BA con valori scelti caso per caso, e non ha breakpoint. Il task va fatto **dopo il 001**, che rinomina e corregge alcuni token, e **prima o insieme al 002**, che deve disegnare gli stati anche su tablet.

## Do

1. **Due livelli di token.** Scale primitive con nomi e passi alla Tailwind; token semantici di BA che vi fanno riferimento. I nomi semantici di oggi restano: cambia solo da dove prendono il valore.
2. **Spaziature su base 4.** Oggi: 4, 6, 8, 10, 12, 14, 16, 20, 24, 32, 44, margine dello schermo 20. Rientrano tutte nella scala di Tailwind con i mezzi passi (6 = 1.5, 10 = 2.5, 14 = 3.5, 44 = 11). Rinominale sulla scala.
3. **Tipografia.** Oggi: 22, 20, 18, 16, 15, 14, 13, 11, 10. Sulla scala standard di Tailwind esistono solo 20, 18, 16 e 14. Per gli altri, proponi caso per caso: allineare al passo più vicino, oppure tenere il valore come estensione con un nome, con il motivo in una riga. Attenzione a 10 e 11: sono sotto il passo più piccolo di Tailwind (12), e vanno verificati anche per la leggibilità.
4. **Raggi.** Oggi: 14, 22, 24, 26 e la pillola. Stesso metodo: allineare o estendere, con il motivo.
5. **Colori.** Primitive per famiglie con gradazioni alla Tailwind (50–950): neutri caldi e tinte del mazzo. I valori esadecimali di oggi non cambiano: trovano posto nella scala. Prima il tema scuro.
6. **Eccezioni decise.** I valori fissati in D-009 (luce fra le sagome 17, fondo della scala delle presenze 88) e la scala delle presenze (208, 156, 130, 112, 88, 32) restano token di componente: non si arrotondano senza dirlo. Se proponi di allinearli, scrivilo come proposta nel changelog.
7. **Breakpoint, mobile first.** Il valore base è il telefono, da 360 dp. Proponi la soglia del tablet con nomi alla Tailwind. Vincolo: un iPad mini in verticale (744 pt) deve ricevere il layout tablet, quindi la soglia `md` di Tailwind (768) da sola non basta.
8. **Layout tablet in verticale** per le cinque schermate dell'alpha (accesso, elenco DEN, stanza, attesa, impostazioni). Decidi come usare lo spazio in più: larghezza massima dei testi e degli elenchi, dimensione delle presenze sul palco, posizione delle azioni. Le azioni primarie restano raggiungibili; il principio "l'app è per lo più non guardata" vale anche sul tablet.
9. **Nomi delle classi (D-021).** Le classi di token prendono il suffisso `Tokens` (`BaPresenza` → `BaPresenzaTokens`, `BaColor` → `BaColorTokens`…), perché i nomi `Ba<Componente>` sono riservati ai widget. Aggiorna di conseguenza i riferimenti nei documenti di sistema.
10. **Indipendenza dall'orientamento.** Il layout dipende solo dalla larghezza: nessuna regola del tipo "se verticale".

## Do NOT

- Non introdurre Material o Cupertino, né valori fuori da `tokens.dart`.
- Non cambiare in silenzio i valori decisi (D-009): ogni modifica è una proposta motivata.
- Non disegnare l'orizzontale, né funzioni nuove della call (home, connessioni, radio).
- Non cambiare direzione visiva, palette o sagome.

## Acceptance check

- [ ] Ogni token semantico fa riferimento a una primitiva, oppure è un'eccezione documentata con il motivo.
- [ ] Le spaziature usano tutte la scala su base 4.
- [ ] Tipografia e raggi hanno una tabella vecchio valore → nuovo nome, con le estensioni motivate.
- [ ] I breakpoint esistono in `tokens.dart`, con nomi alla Tailwind, e un iPad mini in verticale riceve il layout tablet.
- [ ] Le cinque schermate dell'alpha esistono a 360 dp e a larghezza tablet.
- [ ] Nessun layout dipende dall'orientamento.
- [ ] I testi reggono il tedesco e il testo grande del sistema (Dynamic Type) anche su tablet.

## Cosa restituire

In `design/handoff/004/`:

1. `tokens.diff.md`: le righe nuove o cambiate di `tokens.dart`.
2. `mappa-token.md`: tabella vecchio nome e valore → nuova primitiva o eccezione, con il motivo.
3. Screenshot di ogni schermata a 360 dp e a larghezza tablet.
4. `changelog.md` dei documenti di sistema toccati.

Se il modello Tailwind ostacola una buona soluzione in un punto, dillo nel changelog invece di forzarlo.
