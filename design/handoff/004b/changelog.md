# Task 004b — changelog

9 novembre 2026. Tipografia 16/14/12/12, raggi 24 e 16 e scala del palco ×1,5 non toccati. `tokens.diff.md` non rigenerato.

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| tokens.dart | veloImmagine, veloMutataImmagine (righe 198, 199) | `...pietra975); · tetto di luminanza...` e `...; · voce mutata...`: commento senza `//`, il file non compilava | `// .34 · tetto di luminanza sulle foto, ColorFiltered` e `// .66 · voce mutata, con immagine` | punto 1. Controllo sul resto del file: nessun'altra riga ha testo dopo il `;` che non sia un commento; parentesi e graffe bilanciate |
| tokens.dart | BaPresenzaTokens | `perRiga(larghezza)`, commento "era una costante (3) nel codice del palco" | `perRigaMax(larghezza)`; commento: tetto assoluto per riga (3 telefono, 4 tablet), distinto da `tettoPerRiga` del palco ([0,1,2,2,2,2,2,3,3], in codice, non un token), serve quando il palco lo supera perché non ci starebbe | punto 2 |
| tokens.dart | ordine di cessione | "perRiga = 4" | "perRigaMax = 4" | punto 2 |
| BA · Token | T11 | riga `presenza/per-riga` | `presenza/per-riga-max`, con la distinzione da `tettoPerRiga` | punto 2 |
| BA · §7 consolidato | 7.5 | `perRiga` | `perRigaMax` | punto 2 |
| handoff/004 | mappa-token.md | `perRiga(larghezza)`, "sostituisce la costante 3" | `perRigaMax(larghezza)`, "tetto assoluto, distinto da tettoPerRiga" | punto 2 |
| BA · Token | T11 | — | regola: con testo grande, ciò che sta sopra le azioni scorre; le azioni restano ancorate in basso; il testo del consenso è sempre raggiungibile per intero | punto 3 |
| BA · Inventario | C6 Dynamic Type | — | stessa regola; il palco è la sola zona che non scorre e cede prima con la catena | punto 3 |
| handoff/004 | Schermate 004 | consenso e attesa senza scorrimento reale | nuova proprietà `scorri` (inizio · fine); i contenitori sopra le azioni scorrono, le azioni restano in basso; nota visibile che il prototipo non scorre | punto 3 |
| handoff/004b | screenshots | — | consenso e attesa, tedesco, testo 2,0, 360 dp: stato iniziale e stato scrollato in fondo (4 file) | punto 3 |
| BA · Fase 2 schermate | 5b, 5c, 5e, 5e-stati, 5f, 5g | 11 colori fuori da tokens.dart | allineati ai token esistenti; nessun token nuovo. Tabella in `colori-fuori-token.md` | punto 4 |
| Schermate 001 | superfici di sistema, intestazione | #24201E, #F0E6BE | #2A2927, #EDE7DC | punto 4 |
| BA · Fase 2 schermate | testa | — | avviso "Taglie del testo superate dal task 004; fa fede tokens.dart." | punto 5 |
| Schermate 001 | testa | — | stesso avviso | punto 5 |

## Dove il brief ostacola

- **Punto 4 e "token mancante".** Nessun colore si è rivelato un token mancante: tutti si allineano a un valore esistente con differenze visibili ma piccole (la pillola neutra perde il leggero rialzo di fondo). Se la pillola con fondo proprio è voluta, la proposta è in `colori-fuori-token.md`.
- **Alfa dei filetti.** Non risolvibili con una sostituzione semplice; lasciati e dichiarati.
- **Punto 3, "stato scrollato".** Il prototipo non scorre davvero: lo stato in fondo è simulato allineando il contenuto al fondo, e lo dichiara una nota in testa al file.
