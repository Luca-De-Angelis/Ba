# Task 023b — Fogli di contenuto: creare e gestire i DEN, sotto-DEN

24 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Dopo il 023a il design system ha il foglio a più passi (`BaFoglioPassi`) e i fogli dell'accesso a parlare e della coda. Questo task costruisce i contenuti del **014**, aggiornato dal 027: **«Crea un DEN»** (tipo, nome, descrizione, tema e lingua, invitati, riepilogo, errore), il **sotto-DEN** e **«Gestisci»** (descrizione, co-amministratori, persone, termine). Una novità da D-043: **un DEN pubblico creato da un utente ha come amministratore chi lo crea, come un privato**; quindi «Gestisci» è uno solo e vale per entrambi, e la frase del tipo non dice più «senza amministratore». **Nessuna navigazione, nessuna logica di flusso**: il design system non sa quale passo viene dopo; il prototipo navigabile è il task 024. Fonti: `design/handoff/014/Creare DEN 014.dc.html` (C1–C6, S2, D1, G1–G5) con il `changelog.md`; `design/handoff/027/changelog.md` (le correzioni a C1 e G); `design/system/md/inventario-componenti.md` (C4: `BaFoglioGestisci`); `token.md` (T6 ter, T11); `docs/handoff/componenti.md` e `schermate.md`; i componenti `BaFoglioPassi`, `BaFoglio`, `BaCampoTesto`, `BaSceltaDen`, `BaChipScelta`, `BaPuntoAggancio`, `BaMessaggio`, `BaRigaAzione`, `BaPillola`. Dove un documento tace, **proponi nel piano e segnala nel report**.

## Do

1. **Branch** `task/023b-fogli-creazione-gestione`, da `main` aggiornato (023a già unito).
2. **«Crea un DEN»**, sopra `BaFoglioPassi`, un passo per schermata del prototipo, testi dal chiamante: **tipo** (`BaSceltaDen` con la frase sotto che cambia con la scelta), **nome** (`BaCampoTesto`, e sotto `BaPuntoAggancio.quando`, il campo «Quando» spento), **descrizione, tema e lingua** (`BaCampoTesto` a più righe e due gruppi di `BaChipScelta` che vanno a capo), **invitati** (il posto è uno spazio che il chiamante riempie: oggi `BaPuntoAggancio`, domani l'elenco con la ricerca; l'API deve permettere di sostituirlo senza toccare il passo), **riepilogo** (righe etichetta e valore: proponi un piccolo componente e il suo nome), e lo stato **«Il DEN non è stato creato»** con una frase d'errore annunciata e «Riprova». Chi crea può andare avanti anche a campi vuoti dove il design lo prevede: il componente non valida niente, mostra l'errore che il chiamante dà.
3. **Sotto-DEN.** Un foglio con il nome (`BaCampoTesto`), la frase «Fino a 8 persone…» e la nota «Chi ne fa parte lo scegli dopo, dalla stanza», «Crea il sotto-DEN» e «Non ora».
4. **`BaFoglioGestisci`.** Il menu del prototipo (G1): **Descrizione**, **Co-amministratori** con il limite («0 di 1»: **solo il limite, mai il livello**, il numero lo dà il chiamante), **Persone nel DEN**, **Termina il DEN**, e «Chiudi». Le quattro viste (G2–G5): **descrizione** (campo e «Salva»), **co-amministratori** (con un posto libero: l'aggancio e «Aggiungi un co-amministratore» a filetto; al limite: il co-amministratore con «Togli», la frase «Hai raggiunto il limite…» e l'azione spenta), **persone** (una riga per persona con nome, ruolo o stato e «Rimuovi»; proponi un componente di riga e il suo nome; chi è co-amministratore non ha «Rimuovi»), e **conferma** di rimozione e di termine («Terminare il DEN?», «Tutte le persone escono dalla stanza»). Come passano da una vista all'altra lo decide il chiamante: proponi se riusare `BaFoglioPassi` (con «Indietro» o «Chiudi» come `nonOra`) o una struttura a parte. Vale uguale per DEN privati e pubblici.
5. **Galleria.** Pagina nuova «Fogli di creazione e gestione», testi fissi in italiano dal prototipo (galleria esente da l10n, D-030), controlli di sempre (testo 1,0 e 2,0, riduci movimento, 360 e 744): «Crea un DEN» percorribile con «Continua» e «Indietro» di prova, scrivendo davvero i campi e provando l'errore; il sotto-DEN; «Gestisci» con le sue viste, con il posto libero e al limite.
6. **Documenti** (regola «Impatto sull'handoff»): `docs/handoff/componenti.md` (le righe nuove; il test le impone, e vanno tolte da «Non ancora costruiti» insieme a `BaFoglioGestisci`), `schermate.md` e `aperte.md` dove dicono «non costruito», `avvio.md`, `app/README.md`, `docs/tasks/README.md` (023b «In corso», 024 resta «Brief da scrivere»).

## Do NOT

- Non costruire **«Limite di DEN attivi»** (014 · S1): è uno stato futuro del Pro, non attivo in alpha e beta (D-042).
- Non costruire la fonte degli invitati, l'elenco con la ricerca né «Sei stato invitato» (pacchetto «persone e inviti», dopo la call); non costruire la stanza che si apre dopo la creazione (task 024).
- Niente logica di flusso, validazione, timer o conto alla rovescia; nessun segno del pagante: il limite dei co-amministratori si mostra come numero dato dal chiamante, mai come livello.
- Non toccare `tokens.dart` né i componenti esistenti. Se manca un valore, segnalalo nel report.
- Niente Material o Cupertino, nuove dipendenze, golden, numeri di design a mano; ogni import oltre `widgets.dart` va motivato nel file e in `CLAUDE.md`.

## Acceptance check

- [ ] «Crea un DEN» ha un passo per schermata, con una sola azione chiara per passo dove il gesto è obbligato e «Non ora» sempre; il tipo pubblico non dice «senza amministratore».
- [ ] Il campo «Quando» è spento e non toccabile; il posto degli invitati si sostituisce senza toccare il passo.
- [ ] «Gestisci» è uno solo per privati e pubblici; mostra il limite dei co-amministratori, mai il livello; chi è co-amministratore non ha «Rimuovi»; rimozione e termine hanno una conferma.
- [ ] Un errore di creazione è annunciato e non è il solo colore; a testo 2,0 nulla si taglia e le azioni restano ancorate.
- [ ] `flutter analyze` e `flutter test` verdi; CI verde; il test sulla documentazione passa; nessun componente esistente modificato.
- [ ] Nella galleria, la verifica di Luca: il percorso di creazione con i chip che vanno a capo, il riepilogo, l'errore, «Gestisci» con tutte le viste, a 2,0 e a 744.

## Cosa restituire

Branch `task/023b-fogli-creazione-gestione`, report in `docs/reports/023b.md` (massimo 30 righe) con le **proposte dove i documenti tacciono** (il componente del riepilogo, quello della riga persona, come si passa fra le viste di «Gestisci», l'API dello spazio per gli invitati), i valori mancanti nei token, ciò che non hai potuto verificare e la riga «Impatto sull'handoff». Pull request con il template.
