# Task 002 — Gli stati critici della stanza

6 novembre 2026 · chat di orchestrazione · per Claude Design

Disegnare gli stati della stanza che il brief chiama critici, perché un errore lì è un incidente e non un fastidio. Per i rilasci vicini servono in alta fedeltà quelli del palco; quelli del sotto-DEN servono come concetto con i segnali già definiti.

## Context

Fonti: brief v2.1 §6 e §7 con le modifiche della v2.2 (aggiornamento del brief), registro D-001…D-020, sintesi tecnica sull'audio del 28 ottobre. Vale la regola D-001: se il design diverge da una decisione di prodotto, vince il brief.

**Perché ora.** La Fase 2 mostra sempre il microfono aperto per chi è sul palco: lo stato "sul palco a microfono spento" non esiste in nessuna schermata. Con D-006 si entra nel pubblico, quindi diventa possibile un DEN con persone in ascolto e nessuno sul palco. Con i due tipi di account, chi è solo ascoltatore deve diventare partecipante prima di salire. E con D-011 la moderazione lavora a blocchi di 8 tramite i sotto-DEN, che diventano centrali.

**Priorità.** Gli stati del palco servono in alta fedeltà per la beta 1. Gli stati del sotto-DEN arrivano dopo l'alpha: servono come concetto, ma con segnali visivi, sonori e aptici già definiti, perché sono quelli in cui un errore espone una persona davanti a tutti.

**Tecnica utile.** Nel sotto-DEN il telefono tiene due connessioni: il DEN principale in solo ascolto e il sotto-DEN in ascolto e voce, ciascuna con il suo interruttore del microfono. L'app non accende mai il microfono da sola, e dallo schermo bloccato il microfono si può solo spegnere.

**Ordine.** Questo task va fatto dopo il 001 e insieme al 004, o subito dopo: usa i token a due livelli e i breakpoint del 004.

## Do

### Alta fedeltà, per la beta 1

1. **Salire sul palco.** L'azione "Sali sul palco" dal pubblico, nella metà bassa dello schermo, e lo stato "sta salendo". Con il palco pieno, l'azione diventa "Mettiti in coda": la coda è beta, ma la stanza deve poterla accogliere.
2. **Sul palco, microfono spento (D-007).** Si sale sempre a microfono spento, anche dalla coda e con l'ingresso automatico. Serve:
    - la variante di `BaPresenza` "sul palco, microfono spento", per sé ("sono io") e per gli altri;
    - l'azione per accendere il microfono, nella metà bassa;
    - una controparte sonora o aptica, perché lo stato deve essere impossibile da fraintendere anche con il telefono in tasca.
3. **Palco vuoto con persone in ascolto (D-006).** Nessuno sul palco, qualcuno nel pubblico. Deve invitare a salire senza mettere pressione: nessun conto alla rovescia, nessun "tocca a te".
4. **Ascoltatore che vuole salire.** Chi non ha dato il consenso a parlare tocca "Sali sul palco". Si spiega che per parlare bisogna diventare partecipante, si ripete l'avviso su voce e testo (D-013), si chiede il consenso e poi si sale a microfono spento. Se rifiuta, resta nel pubblico senza attrito e senza toni punitivi.

### Concetto con segnali definiti, per la beta 2

5. **Chi mi sente adesso.** Dentro un sotto-DEN deve essere leggibile in ogni momento, non solo al cambio, se si parla a 8 persone o a tutto il DEN. Il brief lo dice così: se dopo trenta secondi una persona può dimenticarsene, il design non ha funzionato.
6. **Hai ricevuto la parola.** Da quel momento tutti ti sentono. Il segnale arriva insieme a tutti e otto i membri del sotto-DEN, con la stessa forza del microfono acceso.
7. **Microfono pubblico abbassato pur avendo la parola.** Si parla di nuovo solo al proprio gruppo senza perdere il turno. Deve distinguersi a colpo d'occhio da "ho la parola e sto trasmettendo".
8. **Parola revocata.** Chiaro, e non umiliante.

### Per tutti gli stati

9. **Suono e vibrazione.** Una tabella evento per evento con suono, vibrazione o niente, e il motivo in una riga. Pochi eventi, scelti bene. Da coprire almeno: microfono acceso e spento, salita sul palco, parola ricevuta e revocata, microfono pubblico abbassato, connessione persa e ripresa. L'ingresso di altre persone resta senza suono (ingresso morbido).
10. **Token.** Ogni nuovo valore va in `tokens.dart`, con nome e riga "dove" nel documento Token: colori e segnali per "microfono spento sul palco" e "hai la parola", durate, nomi dei pattern aptici. Segui i due livelli alla Tailwind del task 004 (D-019).
11. **Accessibilità.** Etichetta per lo screen reader e annuncio per ogni nuovo stato, per esempio "Sei sul palco, microfono spento".
12. **Punti di aggancio.** È in arrivo un elenco di funzionalità aggiuntive (`docs/FEATURES.md`). Disegna gli stati in modo che possano accogliere funzioni nuove senza essere rifatti: la barra delle azioni in basso deve poter ricevere altre azioni, per esempio con una regola su quante restano visibili e dove vanno le altre; la scheda di una persona deve poter ospitare azioni nuove, come "connettiti". Mostra la regola, non le funzioni ipotetiche.
13. **Telefono e tablet (D-020).** Mobile first: ogni stato ad alta fedeltà si disegna prima a 360 dp, poi a larghezza tablet in verticale, con i breakpoint del task 004. Il layout dipende dalla larghezza, mai dall'orientamento.

## Do NOT

- Non cambiare la direzione consolidata: sagome, scala delle presenze, tinte assegnate dalla stanza, anello di chi parla.
- Non disegnare home, connessioni, ascolto condiviso o DEN delle radio: sono il task 003, in attesa di risposte dagli stakeholder.
- Non affidare uno stato critico solo al colore o solo alla vista.
- Non annunciare l'arrivo di nessuno, né con suoni né con animazioni.
- Non far sembrare l'ascoltatore inferiore al partecipante, né chi ha la parola superiore agli altri: sono funzioni, non status.
- Non aggiungere animazioni continue: il movimento accompagna un cambio di stato e poi si ferma.
- Non usare parole fuori dal glossario: "microfono acceso/spento" per il proprio, "muta una voce" per quella di un altro (D-008).

## Acceptance check

- [ ] "Sul palco, microfono spento" si distingue a colpo d'occhio da "microfono acceso" e da "voce mutata", anche in scala di grigi.
- [ ] Ogni stato critico ha una riga nella tabella di suono e vibrazione; l'ingresso di altre persone non ha suono.
- [ ] "Chi mi sente adesso" resta leggibile per tutta la durata dello stato, non solo nel momento del cambio.
- [ ] Ricevere la parola raggiunge tutti e otto i membri del sotto-DEN nello stesso momento.
- [ ] Le azioni "Sali sul palco" e "Accendi il microfono" stanno nella metà bassa dello schermo, con aree da almeno 44 pt.
- [ ] Il palco vuoto invita a salire senza pressione.
- [ ] L'ascoltatore che vuole salire rivede l'avviso su voce e testo prima del consenso; se rifiuta, resta nel pubblico senza attrito.
- [ ] Ogni nuovo stato ha etichetta e annuncio per lo screen reader.
- [ ] Ogni nuovo valore esiste in `tokens.dart` con nome e impiego.
- [ ] Le etichette nuove reggono il tedesco senza troncarsi.
- [ ] La barra delle azioni e la scheda di una persona hanno una regola scritta per accogliere azioni nuove senza essere ridisegnate.
- [ ] Ogni stato ad alta fedeltà esiste a 360 dp e a larghezza tablet in verticale.

## Cosa restituire

In `design/handoff/002/`, non i file HTML interi:

1. Uno screenshot per ogni stato del Do, con la variante "sono io" dove serve, a 360 dp e su tablet.
2. `suono-e-vibrazione.md`: evento, segnale, motivo in una riga.
3. `tokens.diff.md`: le sole righe nuove o cambiate di `tokens.dart`.
4. `changelog.md`: tabella dei documenti toccati, con il motivo di ogni modifica in una riga.

Se un punto di questo brief ostacola una buona soluzione, va detto nel changelog invece di aggirarlo. La review di Claude AI torna con un verdetto: approvato, oppure un elenco breve di correzioni.
