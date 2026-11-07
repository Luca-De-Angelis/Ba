# Task 001 — Allineamento del design al brief

17 ottobre 2026, aggiornato il 6 novembre 2026 · chat di orchestrazione · per Claude Design

## Registro decisioni

Dal 17 ottobre, quando il design diverge da una decisione di prodotto, vince il brief v2.1 con la Guida per il prototipatore; il design si corregge. Le decisioni sotto sono la base del task.

**Aggiornato il 6 novembre** con la sintesi tecnica sull'audio del 28 ottobre e con la call con gli stakeholder (aggiornamento del brief, v2.2). Cambiano D-002, D-003, D-004 e i punti 1, 3 e 4 del Do: chi rifiuta il consenso a parlare resta ascoltatore, l'interruttore della trascrizione non esiste più, e all'avviso su voce e testo si aggiunge l'onboarding al primo accesso.

| ID | Decisione | Fonte | Effetto sul design |
| --- | --- | --- | --- |
| D-001 | Su una divergenza di prodotto vince il brief; i vincoli estetici restano del design | Luca, 17 ottobre | Regola per tutti i task |
| D-002 | Accesso con numero di telefono e codice SMS, poi due consensi separati: termini e privacy (necessario) e consenso a parlare, cioè registrazione temporanea della voce, trascrizione, profilazione e moderazione (rifiutabile). Chi rifiuta il secondo resta ascoltatore. Al primissimo accesso c'è un onboarding con l'avviso su voce e testo (D-013). Il flusso regge la sparizione del passaggio SMS | Brief §5 n. 1; Guida §3, §5 | 5a da rifare, con l'onboarding; il codice di invito non serve all'accesso |
| D-003 | Il consenso a parlare si ritira dalle impostazioni con "Torna ascoltatore": non si parla più e, se si sta parlando, si esce dalla stanza. Non esiste un interruttore della trascrizione separato | Brief §5 n. 5; sintesi tecnica sull'audio §2 | 5d e 5i da correggere |
| D-004 | Nessuna conversazione si può riascoltare. La voce di chi parla si salva per poco tempo, solo per trascriverla, poi si cancella; il testo resta per un periodo. L'interfaccia lo dice nell'onboarding, quando si diventa partecipante e nelle impostazioni | Sintesi tecnica sull'audio §1, §2; D-013 | Onboarding e riga finale di 5d da scrivere |
| D-005 | La rimozione da un DEN è fuori dall'alpha: nei DEN pubblici non ci sono amministratori. Esisterà con i DEN privati, quindi non va preclusa | Brief §5.A; §7.13; Guida §4 | 5j, §7.10 bis, gruppo "ricevuti" e riga "rimosso" passano a beta |
| D-006 | Si entra in un DEN nel pubblico e si sale sul palco se c'è posto | Guida §5 | §7.11 da riscrivere |
| D-007 | Si sale sul palco sempre a microfono spento; si parla dopo averlo acceso a mano, anche con l'ingresso automatico | Guida §5; Brief §6 | Stato nuovo: task 002 |
| D-008 | Il lessico è quello del glossario, cioè del codice: "muta una voce" e "voce mutata" per la preferenza su un altro; "microfono acceso/spento" per il proprio; "sotto-DEN", mai "Loggia" | Guida §2 | Documenti, schermate, etichette di accessibilità e nomi in tokens.dart |
| D-009 | tokens.dart vince sui documenti: luce fra le sagome 17, rilascio del respiro 600 ms, fondo della scala 88 | Token T0 | Copie di lettura da correggere |
| D-010 | Ogni valore citato in un documento esiste in tokens.dart, con nome e impiego | Token T0; §7 intro | Valori mancanti da aggiungere |

## Context

Task per Claude Design: riallineare i materiali esistenti al brief v2.1, con le modifiche della v2.2, e alla Guida, applicando D-001…D-010, senza nuova esplorazione. Siamo nello studio e nel prototipo: non c'è ancora codice, e i documenti con tokens.dart diventeranno il riferimento per chi lo scriverà.

Documenti toccati: BA · Fase 2 schermate, BA · decisioni consolidate (§7), BA · Inventario componenti, BA · Token, tokens.dart. BA · Stanza DEN (Fase 1) è storico e riceve solo un'avvertenza in testa.

Gli stati critici nuovi (palco a microfono spento, salita, chi mi sente adesso, suono e aptica) sono il task 002 e qui non si disegnano.

## Do

1. **5a Accesso (D-002, D-013).** Rifai il flusso: numero di telefono, codice SMS, onboarding con l'avviso su voce e testo, consenso termini e privacy, consenso a parlare, nome o nickname (decisione aperta: lascia lo spazio), elenco DEN. L'avviso dice, in parole semplici: nessuna conversazione si può riascoltare; la voce di chi parla si salva per poco tempo per trascriverla, poi si cancella; il testo resta per un periodo. Il testo definitivo lo approva il legale: usa questo come segnaposto.
    - I due consensi sono controlli separati. Rifiutare il secondo significa entrare come ascoltatore: si ascolta tutto, non si parla. Dillo in modo semplice, senza far sentire penalizzati.
    - Il passaggio SMS deve poter sparire (verifica tramite operatore) senza ridisegnare il resto.
    - Vale la regola 1: una sola azione chiara per schermata.
2. **5h Lessico dell'invito.** Il "codice di invito" resta solo per i DEN privati: riscrivi la riga che lo dice uguale a quello dell'accesso.
3. **5d Impostazioni (D-003, D-004).** Non aggiungere un interruttore della trascrizione. Al suo posto, per chi è partecipante, la riga "Torna ascoltatore" (`BaRigaImpostazione`), con la conseguenza scritta: non potrai più parlare e, se stai parlando, uscirai dalla stanza. Riscrivi la riga finale con lo stesso contenuto dell'avviso dell'onboarding. Togli la nota "nessuna riga nomina il trattamento della voce".
4. **5i Sottotitoli.** "Sottotitoli" resta una preferenza futura di visualizzazione, distinta dalla scelta fra ascoltatore e partecipante: correggi il paragrafo "Fuori dall'interfaccia, adesso".
5. **5j, §7.10 bis, Inventario (D-005).** Sposta la rimozione nella sezione beta "da non precludere". In alpha la schermata delle impostazioni si chiama "Persone bloccate", con un gruppo solo e Sblocca, ma deve poter accogliere poi il gruppo "ricevuti" senza essere rifatta. Marca come beta la variante "rimosso" di `BaRigaDen` e "ricevuto" di `BaRigaBloccata`; aggiorna T9 regola 3 e il commento di `BaRegole` 3.
6. **§7.11 Pubblico (D-006).** Chi entra sta nel pubblico. Riscrivi "il pubblico esiste solo da nove persone in su" e dichiara come si legge il pubblico con poche persone.
7. **Lessico ovunque (D-008).** "Abbassa questa voce" diventa "Muta questa voce"; "abbassata" diventa "mutata" (etichette di accessibilità comprese: "Lucia C., voce mutata da te, sta parlando"). Sulle superfici di sistema "Muta" e "Mutami" diventano "Spegni il microfono", e lo stato "Microfono spento · riaccendilo". In tokens.dart rinomina `abbassataSaturazione` e `abbassataOpacita`, e il token `presenza/abbassata` (togli la nota "microfono chiuso"). Verifica la lunghezza in tedesco.
8. **Valori divergenti (D-009).** §7.5 e §7.6: luce 17, non 20. §7.7: rilascio 600 ms, attacco solo per la comparsa. Inventario C6, Fase 2 5f e due commenti di tokens.dart: fondo della scala 88, non 92. Premuto: oggi è scala 0,98 in T7 bis, 94,5% in T8 e 5,5% con i vicini che si spostano in Fase 2. Scegline uno, motivalo in una riga e mettilo in tokens.dart.
9. **Valori mancanti (D-010).** Aggiungi a tokens.dart, con nome e "dove" nel documento Token:
    - escursione dell'anello: scala 1,00→1,075, opacità 0,28→0,95, crescita al picco 4, respiro 8;
    - limiter a due voci: 1,042 e 0,66, con la regola oltre le due;
    - tetto di luminanza delle presenze 0,18, velo sulle immagini 0,34, velo della voce mutata con immagine 66%;
    - neutro della bloccata #3D3B39→#2A2927, opacità delle iniziali (mutata 80%, bloccata 70%);
    - glifo 28 pt (32 di ripiego) e dimensione del campione del pubblico (3);
    - opacità dello scheletro 0,30→0,62 (oggi solo in un commento accanto a `skeleton`);
    - colore della voce mutata (per esempio #4A3F4A→#332B33 per la prugna): se deriva dalla regola di saturazione, scrivilo accanto al token; se è un valore fisso per tinta, aggiungilo.
10. **Stanza DEN.** In testa, un'avvertenza: documento storico della Fase 1, valori superati, fa fede tokens.dart.

## Do NOT

- Non disegnare stati nuovi della stanza: palco a microfono spento, salita, ascoltatore che vuole salire, sotto-DEN, parola, suono e aptica sono il task 002. Home, connessioni, ascolto condiviso e DEN delle radio non fanno parte di questo task.
- Non cambiare direzione, palette, sagome, scala delle presenze o tipografia oltre a quanto elencato.
- Non rigenerare i documenti da capo: cambia solo i passaggi indicati, così il resto non deriva.
- Non scrivere un numero in un documento se non esiste in tokens.dart.
- Non aggiungere `erroreFondo`, un colore "successo", ombre o import di `material.dart`.
- Non toccare icona e versioni cromatiche del marchio.
- Se un punto del brief ostacola una buona soluzione, dillo nel changelog invece di aggirarlo.

## Acceptance check

- [ ] L'accesso va da numero di telefono a codice SMS, all'onboarding con l'avviso su voce e testo, a due consensi separati; nessun codice di invito né email nel flusso.
- [ ] Rifiutare il consenso a parlare porta all'elenco DEN come ascoltatore, con la conseguenza scritta e nessun tono punitivo.
- [ ] Le impostazioni non hanno un interruttore della trascrizione ma la riga "Torna ascoltatore"; la riga finale dice che la voce si salva per poco tempo e il testo resta per un periodo.
- [ ] In documenti, schermate e tokens.dart non compaiono più "abbassa", "abbassata", "Mutami", "Loggia", né "Muta" riferito al proprio microfono.
- [ ] Rimozione, gruppo "ricevuti" e riga "rimosso" sono marcati beta; le impostazioni alpha hanno un gruppo solo.
- [ ] Nessun documento riporta "20 pt di luce", "rilascio 350 ms" o 92 come fondo della scala.
- [ ] Il premuto ha un solo valore, in tokens.dart, citato uguale in T7 bis e T8.
- [ ] Ogni valore del punto 9 esiste in tokens.dart, con nome e riga "dove" nel documento Token.
- [ ] tokens.dart resta Dart valido e importa solo `widgets.dart`.
- [ ] Le etichette nuove reggono il tedesco senza troncarsi.

## Cosa restituire

In `design/handoff/001/`, non i file HTML interi:

1. `changelog.md`: tabella con documento, sezione, prima, dopo, motivo in una riga.
2. Screenshot delle schermate cambiate: il flusso 5a completo con l'onboarding, 5d e le superfici di sistema con il nuovo lessico.
3. `tokens.diff.md`: le sole righe cambiate di tokens.dart.

I documenti di sistema aggiornati vanno in `design/system/`. La review di Claude AI torna con un verdetto: approvato, oppure un elenco breve di correzioni.
