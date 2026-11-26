# Task 035 — Misure dei test più lenti

Misura sulla macchina di lavoro di oggi (carica: oscilla da ~44 a ~64 s a parità di codice), con `flutter test --reporter json` **tre volte di seguito** prima di toccare niente e tre volte dopo la sola prova fatta; ogni numero è la **mediana delle tre corse**. «Prima» è `main` con il 032c (908 test + 1 saltato).

| | Corsa 1 | Corsa 2 | Corsa 3 | **Mediana** |
| --- | ---: | ---: | ---: | ---: |
| Prima: tempo del runner (s) | 54,0 | 45,2 | 46,0 | **46,0** |
| Prima: somma dei tempi dei test (s) | 137,8 | 130,6 | 129,9 | **130,6** |
| Prova «solo se serve»: tempo del runner (s) | 48,4 | 47,4 | 51,7 | **48,4** |
| Prova «solo se serve»: somma dei tempi dei test (s) | 128,3 | 129,6 | 129,4 | **129,4** |

**Che cosa ho provato.** Gli aiuti dei test del prototipo e della galleria chiamano `ensureVisible` a ogni tocco; ho provato a chiamarlo solo quando il bersaglio non è già sotto il dito (`hitTestable`). Nessun controllo tolto. **Risultato: nessun guadagno** (la somma dei test passa da 130,6 a 129,4 s, dentro il rumore; il runner da 46,0 a 48,4 s, in peggio per il rumore della macchina): **la prova è stata scartata e non c'è nessuna modifica ai test**. Il costo dei test lenti è un fotogramma dell'app intera per ogni tocco, 0,5–1 s per passo di uno scenario riunito (misurato passo per passo), senza un passo che pesi molto più degli altri.

| # | Test (file :: nome) | Prima (mediana, s) | Prova «solo se serve» (mediana, s) |
| --- | --- | ---: | ---: |
| 1 | prototipo_b_test.dart :: la coda (015): scenari riuniti, un passo per scenario | 4.90 | 4.78 |
| 2 | prototipo_b_test.dart :: il posto offerto (K3–K6): scenari riuniti, un passo per scenario | 3.66 | 3.97 |
| 3 | prototipo_c_test.dart :: aggiungere persone (030 P1–P6): scenari riuniti, un passo per scenario | 3.58 | 3.41 |
| 4 | prototipo_b_test.dart :: creare un DEN (014): scenari riuniti, un passo per scenario | 3.58 | 3.92 |
| 5 | prototipo_c_test.dart :: «Hai un invito» (030 I1–I6): scenari riuniti, un passo per scenario | 2.98 | 3.19 |
| 6 | prototipo_b_test.dart :: le simulazioni dal pannello: scenari riuniti, un passo per scenario | 2.24 | 2.43 |
| 7 | galleria_test.dart :: la pagina del palco: 1 persona a 208, 8 a 88, testo grande, 744, vuoto e lingue | 2.22 | 2.41 |
| 8 | prototipo_b_test.dart :: «Gestisci» e il sotto-DEN: scenari riuniti, un passo per scenario | 2.22 | 2.37 |
| 9 | galleria_test.dart :: la pagina delle presenze: 5 diametri, 12 tinte, 5 sagome e tutti i controlli | 1.75 | 1.66 |
| 10 | prototipo_c_test.dart :: «Chi può trovarmi» e il richiamo (030 V, C): scenari riuniti, un passo per scena… | 1.56 | 1.65 |
| 11 | prototipo_test.dart :: l'elenco e la stanza «Impostazioni» e «Persone bloccate» stanno dentro «Altro» per… | 1.42 | 1.58 |
| 12 | galleria_test.dart :: la galleria di BaTouchable si costruisce a 360 e a 744, con le aree e senza movimen… | 1.26 | 1.04 |
| 13 | prototipo_test.dart :: l'accesso parte dal login: la cornice col prodotto, il pannello fuori, i codici di… | 1.20 | 1.14 |
| 14 | prototipo_b_test.dart :: a testo 2,0 e a 744 nulla si taglia la stanza in coda con il posto offerto e il … | 1.16 | 1.24 |
| 15 | prototipo_test.dart :: l'elenco e la stanza il microfono si accende e si spegne; si scende dal palco | 1.16 | 1.14 |
| 16 | prototipo_test.dart :: l'elenco e la stanza da ascoltatore «Sali sul palco» apre i quattro passi e si sal… | 1.03 | 1.15 |
| 17 | prototipo_test.dart :: l'accesso dal login all'elenco, da ascoltatore, con tocchi e testo | 1.01 | 0.96 |
| 18 | foglio_gestisci_test.dart :: menu (G1) le quattro voci nell'ordine del prototipo e solo «Chiudi» in fondo… | 0.99 | 0.62 |
| 19 | galleria_test.dart :: la pagina «Fogli e messaggi»: ogni foglio si apre e si chiude, 2,0, 744 e il messag… | 0.99 | 0.94 |
| 20 | prototipo_test.dart :: l'elenco e la stanza «Blocca» dalla scheda: la scheda si chiude, la persona sul pa… | 0.98 | 1.10 |
