# Task 031 — Scoperta (changelog, proposta)

27 novembre 2026. Schermate in `design/handoff/031/Scoperta 031.dc.html` (25 schermate, 360 dp e 744 dp, italiano e tedesco, testo fino a 2,0). Screenshot in `screenshots/` e, per tedesco a testo 2,0 con stato iniziale e scrollato, in `screenshots/de-testo-2/`. Solo righe aggiunte in `tokens.dart` (classe `BaScopertaTokens`). `tokens.diff.md` non rigenerato.

**Principio verificato su ogni schermata:** nessuna riga mostra o lascia dedurre che una persona è online o in un DEN senza il suo consenso. «Disponibile» è dichiarato da chi lo accende, mai rilevato, e porta una parola e un segno («● Disponibile»). Nessun segno del pagante, nessun contatore, nessuna classifica, nessuna distanza da persone, nessun timer.

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| handoff/031 | H1–H5 | L'elenco del 013, una sola lista | Home di chi ascolta: «Proposti per te» (con il motivo: tema o lingua) e «Aperti ora»; nessuna proposta; errore di rete; «Vuoi passare di qua?» (015 K6); punti di aggancio come regola | G01; riusa BaRigaDen |
| handoff/031 | D1–D6 | — | «Disponibile a chiacchierare»: spento, foglio prima di accendere, acceso, home con la riga di stato e «Spegni», interazione con «Chi può trovarmi», invito ricevuto (030) | G02, D-038 |
| handoff/031 | L1–L3 | — | Persone disponibili in una sezione di «Aggiungi persone» (alfabetico, nessun conteggio), foglio per invitarle, stato vuoto | punto 3; flusso del 030 |
| handoff/031 | N1–N7 | — | Avvisi sui DEN: permesso, dopo il rifiuto, impostazioni, scelta dei temi, spenti dal telefono, notifica a schermo bloccato, apertura a microfono spento | G09; mai per persone |
| handoff/031 | Z1–Z4 | — | Posizione: permesso, GPS rifiutato con la zona abituale, impostazioni, scelta della zona | G15 |
| tokens.dart | `BaScopertaTokens` (nuova) | — | `disponibileSegnoLato` sp2_5; `aggancioAltezzaMin` sp14; `aggancioRaggio` rounded2xl; `aggancioBordo`, `aggancioTratto`, `aggancioVuoto` dai token del tratteggio; `disponibileSiSpegneAdIngresso` (eccezione, ipotesi) | punto 9; D-019 |
| BA · Token | T6 ter | — | 3 righe: scoperta/segno-disponibile, scoperta/aggancio, scoperta/disponibile-ad-ingresso | punto 9 |
| BA · decisioni consolidate | 5.H (nuova) | — | scoperta: principi, home, disponibile, avvisi, posizione, ipotesi | punto 9 |
| BA · Inventario | dopo BaVoceRigaPersona | — | BaRigaDen · motivo, BaRigaPersona · Disponibile, BaPuntoAggancio, BaRichiestaPermesso | punto 9 |
| BA · Fase 2 schermate | in testa | — | rimando al 031 | punto 9 |

## Le proposte (D-055), segnate «ipotesi» nelle schermate

- **«Trovabile e invitabile»:** compari fra le persone che si possono invitare, solo per chi ti può trovare. **Interazione:** «Chi può trovarmi» non si allarga da solo; con «Nessuno» nessuno ti trova, e la schermata D5 lo dice.
- **Scadenza:** nessun timer. Si spegne in un tocco e **da solo quando si entra in un DEN**.
- **Dove si vedono:** una sezione di «Aggiungi persone» (030 P1), in ordine alfabetico.
- **Proposte:** vengono da tema e lingua scelti; il loro numero non è deciso. **Avvisi:** per DEN su temi e lingue, mai per persone; il loro numero non è deciso. **Temi:** lista di prova. **Zona:** una zona, non un indirizzo; il raggio fisso (G05) è solo annotato. Tema, lingua e zona abituale sono memorie in più da dichiarare nell'informativa.

## Regole del 032 e del 036 rispettate

Titolo a 22 per le schermate di un flusso o di impostazioni (nessuna sostituisce tutto); fogli a 20. Da testo 1,3 la voce, il valore e l'interruttore stanno sotto il nome in ogni riga (persone disponibili, interruttore). «Crea un DEN», «Consenti», «Salva», «Passa», «Invita» e «Accendi» hanno il filetto (BaRegole 1: si può non farlo). Nessun participio che dipenda dal genere («Invito di Marta», «Sei dentro», «Per cui vuoi un avviso», «Perché: tema Cucina»).

## Dove il brief ostacola

- **«Proposti per te»:** il brief chiede il motivo in una frase («tema o lingua») e nessuna classificazione di persone. Un motivo basato sul tema o sulla lingua è una memoria sull'utente: l'ho dichiarata come ipotesi, ma va decisa con l'informativa.
- **Dove sono «Aggiungi persone» e «Impostazioni» nella home:** il 013 non ha un'intestazione con azioni e il brief non dice dove stanno. Non li ho disegnati, e ho lasciato «Crea un DEN» come unica azione in fondo.
- **«Disponibile» e DEN privato:** l'invito porta fra il pubblico (D-006). Se chi invita è in un DEN pieno o non è in alcun DEN, il flusso del 014 si apre da «Invita»: non l'ho disegnato.
- **Dopo «Disponibile e niente di nuovo»:** ho scritto «Niente di nuovo per ora». Non è un contatore, ma dice che prima c'era qualcosa: da valutare.
- **Documenti della repo** (`aperte.md`, `schermate.md`, `componenti.md`) non aggiornati: sono fuori dal progetto.
- **Tablet:** a 744 dp i frame mantengono la colonna di 512; le sezioni della home non cambiano disposizione.
