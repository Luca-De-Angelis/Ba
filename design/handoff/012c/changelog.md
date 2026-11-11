# Task 012c — conferma dei glifi

11 novembre 2026. Nessun valore esistente cambiato. `tokens.diff.md` non rigenerato. Il `tokens.dart` allegato era identico al nostro.

| Punto | Prima | Dopo | Motivo |
| --- | --- | --- | --- |
| 1 · microfono | glifo del prototipo | invariato | già approvato |
| 1 · altoparlante | corpo, cono e due onde da −40° a +40° | confermato; raggi delle onde 12% e 26% del lato, centro delle onde al 60% | le onde dividono lo spazio con il cono; a 28 dp la distanza fra le due è 3,5 dp, più del tratto da 2, quindi non si fondono |
| 1 · cerchio barrato | anello all'84% del lato | anello al 72%, barra dello stesso diametro (72%), −45° | a 84% l'anello sfiora il bordo del disco (2 dp a 28) e pesa più del microfono e dell'altoparlante, che occupano il 60–65% del lato; a 72% restano 4 dp dal bordo e la barra finisce sull'anello |
| 2 | bordo ricavato da `parolaTaccaSporge` e `parolaTaccaAltezza` | `BaPresenzaTokens.badgeBordo` = 1,5, eccezione dichiarata; riga in T6 ter | 1 sparisce a 28 dp e 2 mangia il glifo; Tailwind non ha 1,5 |
| 3 | proporzioni come costanti private del codice | sì, token: classe `BaGlifoTokens` (tratto `border2`, barra −45° 0,84 con alone 5, capsula, culla, stelo, corpo, cono, onde, cerchio 0,72); riga in T6 ter | il codice e il prototipo non possono più divergere; il file è la fonte |
| — | Inventario C1, prototipo | + bordo e glifi; distinzione con le onde e l'anello al 72% | allineati |

Screenshot: `screenshots/distinzione-glifi-corretti.png` (microfono, altoparlante e cerchio nel disco, a colori e in grigi).

## Dove il brief ostacola

Nessuno. Una nota: ho giudicato le proporzioni dagli screenshot, non dal codice della stanza. Se il codice usa valori diversi per le onde, i valori di `BaGlifoTokens` vanno copiati nel codice e non viceversa.
