# Colori di Fase 2 fuori da tokens.dart — 004b

Tutti sono errori del mock: nessun token mancante, nessuna riga nuova in T6 ter. Corretti in `BA - Fase 2 schermate`; #24201E e #F0E6BE anche in `Schermate 001`.

| Colore | Dove compare | Esito | Token usato |
| --- | --- | --- | --- |
| #2F3273 (13) | 5c, 5f, 5g: stop scuro della tinta indaco | errore del mock | #33367A (indaco900) |
| #221E1C → #15120F (4) | 5b "Apri un DEN"; 5c e 5f "Il tuo microfono è aperto": fondo della pillola neutra | errore del mock | #1C1917 → #100F0E (pietra900 → pietra940); bordo e testo già a token |
| #1B1917 → #131110 (2 + 2) | 5f "Non c'è posto sul palco", "Sto entrando": fondo della pillola inerte | errore del mock | #1A1917 → #100F0E (pietra910 → pietra940) |
| #C9C2B9 (3) | 5b: nome dei DEN vuoti (Radio insonni, Tavolo lungo, Serra) | errore del mock: 5b stesso dice che i vuoti non vanno trattati come scarti | #F2EEE9 (testoPrimo) |
| #C9C2B9 (1) | 5e: pallino di 18 px "BA · in corso" | errore del mock | #A09890 (testoSecondo) |
| #1A1614 → #0E0D0C → #08080A (3) | 5e: sfondo del lock screen e della Dynamic Island | errore del mock: lo sfondo è del telefono, non nostro; il mock usa la sequenza della stanza | #171413 → #100F0E → #0B0A09 (fondoStanza) |
| #24201E (2) | 5e-stati, e Schermate 001: fondo dietro le card di sistema | errore del mock | #2A2927 (pietra850) |
| #F0E6BE (1) | 5, hover dei link nell'intestazione del documento | errore del mock, non è un colore dell'app | #EDE7DC (sabbia100) |

## Non corretti

Alfa dei filetti fuori scala (.06 · .10 · .12 · .14): .09 (24 usi), .07 (5), .08 (6), .16 (19), .18, .22, .24 e altri sparsi, più rgba(201,194,185,.55) in 5e. Sono differenze di 1–2 punti percentuali, non si risolvono con una sostituzione semplice senza vedere ogni caso, e non sono colori nuovi. Da allineare nel prossimo giro di Fase 2.

Se Luca vuole che la pillola neutra abbia un fondo proprio, diverso da pietra900 → pietra940, il nome proposto è `BaColorTokens.pillolaFondo` con #221E1C → #15120F. Non l'ho aggiunto: nelle schermate del 004 la pillola è senza fondo e nessuno ha chiesto altro.
