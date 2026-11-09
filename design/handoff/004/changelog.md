# Task 004 — changelog

9 novembre 2026. Schermate in `design/handoff/004/Schermate 004.dc.html`; screenshot in `screenshots/` (italiano, testo 1,0) e `screenshots/de-testo-2/` (tedesco, testo 2,0). `tokens.diff.md` non è rigenerato, come richiesto.

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| tokens.dart | intestazione | un livello, valori assoluti | due livelli: primitive alla Tailwind v4, semantici che vi fanno riferimento; regola delle eccezioni | D-019 |
| tokens.dart | nuove classi | — | `BaPaletteTokens` (pietra, sabbia, corallo, 12 tinte, alfa) e `BaPrimitiveTokens` (sp*, text*, leading*, rounded*, border*, maxWLg, sm) | D-019 |
| tokens.dart | nomi delle classi | BaColor, BaTinta, BaSagoma, BaRaggio, BaPresenza, BaTesto, BaScala, BaSpazio, BaControllo, BaMovimento | stessi nomi + `Tokens` | D-021 |
| tokens.dart | BaColorTokens, BaTintaTokens | esadecimali letterali | `Color(_P.alfa \| _P.primitiva)`, stessi valori | D-019 |
| tokens.dart | BaTestoTokens | 15, 13, 11, 10 | 16, 14, 12, 12 | leggibilità; vedi mappa |
| tokens.dart | BaRaggioTokens | foglio 26, riquadro 14 | 24, 16 | allineati alla scala |
| tokens.dart | BaSpazioTokens, BaControlloTokens | numeri | primitive; sistemaLock, sistemaIsola, focusStacco eccezioni | D-019 |
| tokens.dart | BaPresenzaTokens | `diametro(n)`; per riga 3 nel codice | `diametro(n, larghezza)`, `scalaTablet` 1,5, `perRiga(larghezza)` | D-020 |
| tokens.dart | BaLayoutTokens (nuova) | nessun breakpoint | `sm` = 600, colonna 512, margine tablet 32; solo larghezza | D-020 |
| tokens.dart | ordine di cessione | da 208 a 88 | + sul tablet da 312 a 132, conti a 680 dp | D-020 |
| BA · Token | T5 | corpo 15, minore 13, marcatore 11, nota 10; "sotto i 13 pt" | 16, 14, 12, 12; "sotto i 14 pt solo mono, niente sotto il 12" | D-019 |
| BA · Token | T7 | foglio 26, riquadro 14; "scala a passo 2" | 24, 16; "base 4 con i mezzi passi" | D-019 |
| BA · Token | T11 (nuova) | — | due livelli, primitive, breakpoint, colonna, scala del palco sul tablet, azioni in fondo | D-019, D-020 |
| BA · §7 consolidato | 7.5 | solo il telefono | paragrafo sul tablet: scala × 1,5, quattro per riga, luce 17 e minimo 32 invariati | D-020 |
| BA · §7 consolidato | 7.8 | BaPresenza.quotaEscursione | BaPresenzaTokens.quotaEscursione | D-021 |
| BA · Inventario | C1, C4, C5, C6, C7 | BaPresenza.*, BaSagoma, BaTinta, BaColor.*, BaTesto.*, BaSpazio.*, BaRaggio.*, BaControllo.* | stessi con `Tokens`; i nomi dei widget restano | D-021 |
| BA · Inventario | C6 | "da 208 giù fino a 88" | + "(sul tablet da 312 a 132)" | D-020 |
| handoff/004 | Schermate 004 | — | accesso, elenco, stanza, attesa, impostazioni a 360 e 744 dp; tedesco, testo fino a 2,0, palco da 1 a 8 | D-020 |

## Decisioni

- **Soglia del tablet a 600, nome `sm`.** 744 ci sta; 768 lo escluderebbe. 600 e non 640 perché è la soglia con cui Android classifica i tablet e oltre la quale ignora il blocco dell'orientamento: con 640 un tablet Android da 8 pollici in verticale (circa 600 dp) avrebbe il layout del telefono e quello del tablet appena girato.
- **Le presenze crescono sul tablet, × 1,5.** Alla misura del telefono il gruppo occupa un terzo della larghezza; il tablet si guarda da più lontano e spesso appoggiato. 1,5 dà valori interi (312, 234, 195, 168, 132) e tiene i rapporti. Luce 17 e minimo 32 non scalano. Cambiano `diametro` (ora chiede la larghezza) e il tetto per riga (4 da sm).
- **Colonna di 512 per testi, elenchi e azioni; il palco ne esce.** Le azioni restano in fondo, larghe quanto la colonna. Sull'accesso il blocco di testo si centra nello spazio libero; le azioni non si muovono.

## Proposte (non applicate)

- Fondere `nota` in `marcatore`: dopo l'allineamento a 12 differiscono solo per la spaziatura.
- Verificare `rounded22` su un dispositivo: se iOS disegna il contenitore della Live Activity, il token serve solo ai mock e può sparire.

## Dove il modello Tailwind ostacola

- **Neutri scuri.** Il tema scuro ha dieci neutri sotto il 900 che differiscono di 1–3 unità. Una famiglia a 11 passi non li contiene: pietra ha passi intermedi (910, 920, 925, 940, 945, 975). Fonderli cambierebbe esadecimali che il brief vuole invariati.
- **Opacità e tempi.** Tailwind v4 accetta qualunque intero (`opacity-28`, `scale-98`, `border-3`), quindi "stare in scala" non vuol dire niente lì. Ho dichiarato eccezioni le opacità di stato, i tempi, la keyline 3, il focus 3 e il premuto 0,98, invece di fingere una scala.

## Residui

- Le schermate di Fase 2 e di Schermate 001 usano ancora 15, 13, 11 e 10 nei mock. Fa fede tokens.dart.
- Fase 2 usa valori fuori da tokens.dart: #221E1C → #15120F (pillola del microfono in stanza), #2F3273 (13 volte, al posto di #33367A), #131110, #1A1614, #0E0D0C, #08080A, #24201E, #1B1917. Nelle schermate 004 la pillola del microfono usa solo filetto marcato.
- A 360 dp con tedesco e testo 2,0 l'attesa non sta in uno schermo: il blocco sopra le azioni scorre, le azioni restano ferme.
