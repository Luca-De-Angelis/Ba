# Task 001 — changelog

> Le sei segnalazioni sotto sono state decise in review: vedi DECISIONS.md (D-024, D-025), il giro 001b e le voci "Aperte".

7 novembre 2026 · Claude Design · documenti aggiornati in `design/system/`, schermate in `design/handoff/001/Schermate 001.dc.html`, screenshot in `design/handoff/001/screenshots/`.

**Non ancora applicato:** *BA · Fase 2 schermate* non era tra i file ricevuti. I punti 2 (5h), 4 (5i), la parte Fase 2 dei punti 5 (5j), 7 e 8 (5f, premuto) restano da fare su quel file. Le schermate nuove di 5a, 5d, 5j e delle superfici di sistema sono disegnate a parte e vanno sostituite in Fase 2 quando arriva.

## Modifiche

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| Fase 2 (nuovo file) | 5a Accesso | flusso con codice di invito | numero → codice SMS (rimovibile) → onboarding → termini e privacy → consenso a parlare → nome (spazio aperto) → elenco, partecipante o ascoltatore | D-002, D-013 |
| Fase 2 (nuovo file) | 5a.3 Onboarding | — | avviso su voce e testo, segnaposto per il legale | D-004, D-013 |
| Fase 2 (nuovo file) | 5a.5 Consenso a parlare | — | "Acconsento" (azione chiara) oppure "Entra come ascoltatore" (hairline) con "Ascolti ogni DEN come chiunque altro, senza parlare." | D-002, regola 1 |
| Fase 2 (nuovo file) | 5d Impostazioni | interruttore della trascrizione, nota "nessuna riga nomina il trattamento della voce" | riga "Torna ascoltatore" con la conseguenza; riga finale con il contenuto dell'onboarding; nota tolta | D-003, D-004 |
| Fase 2 (nuovo file) | 5j | due gruppi | "Persone bloccate", un gruppo "bloccate da te" con Sblocca; il gruppo "ricevuti" si aggiunge sotto in beta | D-005 |
| Fase 2 (nuovo file) | superfici di sistema | "Muta", "Mutami" | "Spegni il microfono"; stato "Microfono spento", solo informativo, resta "Esci" | D-008; 001b: dal telefono bloccato il microfono non si riaccende |
| §7 | 7.5 tabella | luce 20 dp | 17 dp | D-009 |
| §7 | 7.6 | "20 pt di luce" | "17 pt di luce" | D-009 |
| §7 | 7.7 inviluppo | attacco 70 ms · rilascio 350 ms | comparsa 70 ms, solo canale veloce · rilascio del respiro 600 ms | D-009 |
| §7 | 7.8 | solo il caso a due voci | + regola oltre le due: escursione × 1,12/n | D-010 |
| §7 | 7.9 | "Abbassata da me", "voce abbassata", "abbassato" | "Voce mutata da me", "voce mutata", "mutata" | D-008 |
| §7 | 7.10 bis | regola alpha | spostata nella nuova sezione "Beta — da non precludere"; "potrà rimuovermi" nei DEN privati; in alpha "Persone bloccate" con un gruppo | D-005 |
| §7 | 7.11 | "il pubblico esiste solo da nove persone in su" | chi entra sta nel pubblico e sale se c'è posto; con 1–3 persone il campione le mostra tutte e il numero coincide con le bolle; a zero la riga non si disegna | D-006 |
| §7 | 7.12 | "voce abbassata da te", annuncio "abbassata" | "voce mutata da te", "voce mutata" | D-008 |
| §7 | 7.12 bis | "come per la Loggia" | "come per i sotto-DEN" | D-008 |
| §7 | 7.13 | "abbassa questa voce" | "muta questa voce" | D-008 |
| §7 | 7.14 | "1 abbassata"; "rimosso" in elenco | "1 mutata"; "rimosso" marcato beta | D-008, D-005 |
| §7 | 7.16, aperto 2 | "chi è abbassato", "abbassata che parla" | "voce mutata" | D-008 |
| Inventario | C1 BaPresenza | stati "abbassata", variante "pubblico (muta)" | "mutata", "pubblico (senza iniziali)" | D-008 |
| Inventario | C1 BaPubblico | — | token `campionePubblico` | D-010 |
| Inventario | C3 BaGlifo | "microfono barrato (abbassata)" | "altoparlante barrato (voce mutata)", token `BaPresenza.glifo*` | D-008: il microfono è solo il proprio |
| Inventario | C4 BaRigaDen | variante "rimosso" | marcata beta | D-005 |
| Inventario | C4 BaRigaImpostazione | — | azione con conseguenza "Torna ascoltatore"; nessun interruttore della trascrizione | D-003 |
| Inventario | C4 BaRigaBloccata | "ricevuto" | marcata beta; schermata alpha "Persone bloccate", un gruppo | D-005 |
| Inventario | C5 | "microfono chiuso" (due righe) | "microfono spento"; paragrafo sul lessico di sistema, stato spento solo informativo | D-008, 001b |
| Inventario | C6 | "fino a 92", "sotto i 92" | 88 | D-009 |
| Inventario | C7 accessibilità | "microfono chiuso" | "microfono spento" + "voce mutata da te" | D-008 |
| Inventario | C7 bis | premuto 94,5%; rimosso e due gruppi essenziali | scala 0,98; rimosso beta; un gruppo in alpha | D-009, D-005 |
| Inventario | C8 regola 2 | "abbassata" | "voce mutata" | D-008 |
| Token | T4 | `presenza/abbassata` · "microfono chiuso" | `presenza/mutata` · "voce mutata da me" | D-008 |
| Token | T6 ter (nuova) | — | 15 token con nome, valore e "dove" | D-010 |
| Token | T7 bis | scala .98 | scala .98 = `premutoScala`, con la motivazione | D-009 |
| Token | T8 | premuto "al 94,5%"; "con 350 ms"; "glifo dell'abbassata" | "a scala 0,98"; "con un rilascio più corto"; "voce mutata, da 0,45 a 1" | D-009, D-008 |
| Token | T9 regola 2, 3 | "abbassata"; rimozione fra le memorie alpha | "voce mutata"; memorie alpha: blocco, profilo, testo trascritto; rimozione beta | D-008, D-004, D-005 |
| tokens.dart | vedi `tokens.diff.md` | | | D-008, D-009, D-010 |
| Stanza DEN | testa | — | avvertenza: documento storico della Fase 1, fa fede tokens.dart | punto 10 |

**Premuto: scala 0,98.** È il solo dei tre valori con cui una riga larga quanto lo schermo cede senza staccarsi dal margine, e i vicini restano fermi come chiede T8.

## Segnalazioni (D-001: il brief vince, ma lo dico)

1. **Le memorie non sono più "tre e non aumentano".** D-004 aggiunge il testo trascritto, che resta per un periodo. Ho riscritto T9 e `BaRegole` 3 con le tre memorie alpha. §7.10 ("il blocco è l'unica cosa che l'app ricorda di una persona") e la scheda 4b ("È l'unica cosa che BA ricorda") ora sono imprecisi. Non li ho toccati perché fuori elenco: vanno decisi.
2. **Chi ascolta non ha un modo per tornare a parlare.** D-003 prevede solo il ritiro del consenso. Per questo 5a.5 non promette "puoi cambiare idea". Senza una via di ritorno, la scelta all'accesso pesa più di quanto la schermata faccia sentire. Propongo una riga "Diventa partecipante" in 5d, se il brief la ammette.
3. **Limiter oltre le due voci.** Ho scelto la regola × 1,12/n perché riproduce i valori a due voci (1,042 · 0,66) e da lì tiene costante l'energia. Va vista con tre o più voci vere.
4. **Aperto 9 del §7** ("da dire una volta, all'ingresso in stanza") è superato da D-004, che lo colloca nell'onboarding, al consenso e nelle impostazioni. Non l'ho riscritto perché non era nell'elenco.
5. **§7.9 "#4A3F4A→#332B33 per la prugna"** è il risultato del filtro `mutata*` su una tinta, non un token. Resta un numero senza nome: o diventa un esempio dichiarato, o si toglie.
6. **Stanza DEN** conserva "abbassa", "Abbassa questa voce" e il premuto a 0,945 perché il task chiede solo l'avvertenza. Il controllo di accettazione sul lessico vale per tutti gli altri documenti.

## Tedesco

Le etichette nuove hanno la versione tedesca (proprietà `lingua = de` del file delle schermate) a 360 dp. "Nutzungsbedingungen und Datenschutz", "Als Zuhörer:in eintreten", "Wieder nur zuhören" e "Mikrofon ausschalten" vanno a capo dentro controlli ad altezza minima e non si troncano. Le traduzioni sono mie e vanno riviste da un madrelingua. Gli screenshot sono in italiano.

## Giro 001b

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| Fase 2 (file nuovo) | Superfici di sistema | "Microfono spento · riaccendilo" con l'aspetto di un'azione | "Microfono spento", solo testo; resta "Esci"; nella notifica Android nessuna azione sul microfono | dal telefono bloccato il microfono si spegne e non si riaccende |
| Inventario | C5 | stato "Microfono spento · riaccendilo" | "Microfono spento", solo informativo | come sopra |
| tokens.dart | BaPresenza | opacità dello scheletro solo in un commento | `scheletroOpacitaMin` 0,30 · `scheletroOpacitaMax` 0,62 | D-010 |
| Token | T6 ter | — | riga `presenza/scheletro` | D-010 |
| §7 | 7.9 | "#4A3F4A→#332B33 per la prugna" | esempio dichiarato, derivato da mutataSaturazione e mutataOpacita | D-010 |
| §7 | 7.10 | "l'unica cosa che l'app ricorda di una persona" | "l'unica cosa che l'app ricorda di una persona per tua scelta, finché non la togli: il testo trascritto resta per un periodo e poi va, il blocco resta" | D-004 |
| Stanza DEN | 4b scheda | "È l'unica cosa che BA ricorda di una persona." | "Resta finché non lo togli, dalle impostazioni." | D-004 |
| §7 | aperto 9 | "da dire una volta, all'ingresso in stanza" | l'avviso sta in onboarding, consenso a parlare e impostazioni; la stanza non porta marcatori | D-004 |

Restano provvisori il limiter × 1,12/n e il premuto 0,98. 

### 001b.2 — Fase 2 schermate (`design/system/BA - Fase 2 schermate.dc.html`)

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| Fase 2 | 5a | accesso con codice di invito | sostituita dal flusso nuovo (5a.1–5a.7b) | D-002, D-013 |
| Fase 2 | 5d | righe Blocchi "3 persone · 1 DEN"; riga finale "Le conversazioni non vengono registrate"; nota "Nessuna riga nomina il trattamento della voce"; nota "superata da 5j" | righe originali tenute; "Persone bloccate · 3 persone"; nuova riga "Torna ascoltatore" con la conseguenza; riga finale con l'avviso; nota "Torna ascoltatore, non un interruttore"; gruppo "bloccate da te" e nota sul gruppo ricevuti in beta | D-003, D-004, D-005 |
| Fase 2 | 5d Persone bloccate | "È l'unica cosa che BA ricorda di qualcuno." | "Restano finché non le sblocchi." | D-004 |
| Fase 2 | 5j | "È tutta la memoria che BA tiene." | "Restano finché non li togli." | D-004 |
| Fase 2 | 5e bis | — | badge "5e bis" per il blocco con i due stati nuovi | leggibilità |
| Fase 2 | 5e | "Muta", "Mutami", "Microfono chiuso · riaprilo" | "Spegni il microfono"; "Microfono spento" solo informativo; aggiunto il blocco 5e-stati con i due stati nuovi | D-008, 001b.1 |
| Fase 2 | 5e note | "microfono chiuso, uscito" | "microfono spento, uscito" | D-008 |
| Fase 2 | 5f | presenze a 92; "Otto presenze a 92 pt sono il limite inferiore leggibile" | 88; "Otto presenze a 88 pt sono il fondo della scala a testo normale" | D-009 |
| Fase 2 | 5f, 5p | "abbassata", "Il microfono è già chiuso" | "voce mutata", "già spento" | D-008 |
| Fase 2 | 5i | "Fuori dall'interfaccia, adesso": interruttore tolto perché "accettato alla registrazione" | nessun interruttore della trascrizione; consenso all'accesso, ritiro con "Torna ascoltatore"; Sottotitoli preferenza di visualizzazione distinta da ascoltatore/partecipante | D-003 |
| Fase 2 | 5h | codice di invito "uguale a quello dell'accesso" | vale solo per i DEN privati; all'accesso non serve nessun codice | D-002 |
| Fase 2 | 5j | rimozione in alpha, due gruppi, riga "Blocchi" | marcata "beta · da non precludere"; memoria e riga "Blocchi" dichiarate beta | D-005 |

Premuto: in questa versione di Fase 2 non c'è un valore di premuto scritto né disegnato, quindi non c'era niente da allineare. Vale `premutoScala` 0,98.

5e: le schermate esistenti (lock screen, Dynamic Island, notifica) restano, corrette nel lessico; gli stati nuovi stanno nel blocco 5e-stati accanto. L'isola espansa non era nelle schermate nuove.
