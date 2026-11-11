# Aggiornamento del brief dopo il catalogo dei servizi (v2.3)

10 novembre 2026

I soci hanno consegnato il catalogo dei servizi LIVE.BA (138 servizi) e hanno già risposto a due domande. Questo documento aggiorna la v2.2 e, dove diverge, **vale questo**. Le decisioni sono in `docs/DECISIONS.md` (D-031 e D-032); il registro delle funzionalità è `docs/FEATURES.md`, che ora usa i codici del catalogo.

## Cosa cambia

| § | Oggi (v2.2) | Con la v2.3 |
| --- | --- | --- |
| 5.A · Accesso | Numero di telefono, codice SMS, termini, consenso a parlare, nome, elenco | **Email e codice via email, termini, elenco dei DEN pubblici.** L'account di base è da ascoltatore, senza voce. Google e Apple arrivano dopo l'alpha (A02) |
| 5.A · Diventare partecipante | Si chiede il consenso quando l'ascoltatore tocca «Sali sul palco» (D-024) | Lì si chiedono anche **la verifica del numero di telefono (SMS)** e il consenso a parlare, in un solo percorso |
| Ascoltatore | Chi ha rifiutato il secondo consenso, dopo aver verificato il numero | Account senza numero, con email. Non è mai trascritto |
| Partecipante | Account con consenso a parlare | Account con numero verificato **e** consenso a parlare (A03) |
| Elenco DEN | Tutti i DEN, anche su invito | L'ascoltatore vede **solo i DEN pubblici** (A01). Da chiarire: ingresso in un DEN privato su invito |
| Radio | Le emittenti radio possono programmare DEN (D-018) | **Superata (D-032).** La «radio» è la **modalità radio** (B10): quando il DEN finisce o si svuota, si passa da soli a uno simile per tema e lingua. B10 è «Nuovo»: per ora **solo annotata**, non si progetta (D-033) |

## Cosa resta invariato

L'onboarding con l'avviso su voce e testo al primo accesso (D-013); l'avviso ripetuto in «Sali sul palco» (D-024); «Torna ascoltatore» (D-003); tutti gli stati della stanza e del palco (task 002); i token e i componenti.

## Cosa serve al design (task 013, Claude Design)

1. Ridisegnare il flusso 5a.1–5a.7: email → codice email → onboarding → termini e privacy → elenco dei DEN pubblici. Senza numero, SMS né consenso a parlare.
2. Estendere il foglio «Vuoi salire sul palco?» del task 002: avviso su voce e testo → numero → codice SMS → consenso → si sale a microfono spento. Una sola azione chiara per schermata.
3. Ipotesi da confermare: dopo «Torna ascoltatore» il numero **resta verificato**; salire di nuovo chiede solo il consenso.

## Perimetro di lavoro (D-033)

Si lavora solo sui servizi del catalogo segnati Confermato, Ipotesi o Previsto, più i verdi con un punto aperto (48). Gli altri 67 sono annotati in `docs/FEATURES.md`, colonna «In lavorazione» = No.

## Domande ancora aperte per i soci

- Un ascoltatore può entrare in un DEN privato su invito (D01)?
- Dopo «Torna ascoltatore», il numero resta verificato?
- Le voci «Domanda ai soci» di `FEATURES.md` che sono in lavorazione: D07, E06, G10.
