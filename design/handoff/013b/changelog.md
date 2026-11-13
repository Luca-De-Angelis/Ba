# Task 013b — changelog

12 novembre 2026. Il resto del 013 non è toccato. `tokens.diff.md` non rigenerato.

| Punto | Prima | Dopo | Motivo |
| --- | --- | --- | --- |
| 1 · Termini e privacy | «Per parlare, il consenso lo chiedi quando sali sul palco.» · DE: «Zum Sprechen wird die Einwilligung beim Aufsteigen auf die Bühne gefragt.» | «Per parlare, ti chiediamo il consenso quando sali sul palco.» · DE: «Zum Sprechen fragen wir dich beim Aufsteigen auf die Bühne nach deiner Einwilligung.» | è BA che chiede il consenso, non la persona; il tedesco ora ha lo stesso soggetto |
| 2 · Nuovo invio del codice | azione «Mandalo di nuovo · fra poco» e frase «Ne puoi chiedere un altro fra poco.» | azione «Mandalo di nuovo» (inattiva) e la frase «Ne puoi chiedere un altro fra poco.» (DE: «Du kannst gleich einen weiteren anfordern.») | una sola frase dice l'attesa; l'azione resta inattiva senza ripeterla |
| 3 · Segno «ipotesi» | pillola `roundedFull`, `inline-flex`: a capo il testo cadeva sul bordo | `rounded2xl` (16), larghezza che segue il testo, massimo 26 em, padding 8 × 14; in `tokens.dart` `BaAccessoTokens.segnoRaggio` = `rounded2xl`, e la riga in T6 ter | con il testo a capo il bordo cresce con il testo; il raggio pieno lo taglierebbe |
| 4 · Numero negli screenshot | +39 347 120 4821 | +39 320 000 0000 (e «••• ••• 0000» nel passo SMS) | numero evidentemente fittizio |

Screenshot rifatti: elenco, nome, con numero, «Torna ascoltatore» (prima e dopo), termini, nuovo invio, numero e SMS del foglio, a 360 e 744 dp.

## Dove il brief ostacola

Nessuno.
