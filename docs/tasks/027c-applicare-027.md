# Task 027c — Applicare l'esito del 027 alla repo: token, documenti, glossario e «aperte»

20 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Claude Design ha consegnato il 027: i prototipi 013, 014 e 015 **aggiornati sul posto** con le decisioni degli stakeholder (D-040…D-054) e due schermate nuove (account chiuso, controlli a schermo bloccato). Lo zip è in `Import/Documenti_mancanti_del_progetto.zip` (**il nome è sbagliato: è la consegna del 027**; la cartella è ignorata da git, non committarlo). Il `tokens.dart` nuovo compila (parser Dart, zero errori, solo `widgets.dart` importato) e rispetto a quello di `main` ha **16 righe aggiunte e una sola modificata, solo nel commento** (`permanenzaMassima`: «eccezione: B05, tempi da definire (D-044)»); nessun colore nuovo. Come per 013c, 014c e 015c questo task porta tutto nella repo; **nessun widget**. In più aggiorna glossario, `aperte.md` e le «Aperte», perché il design ha recepito ciò che il task 028 aveva segnato «da aggiornare nel design (task 027)».

## Do

1. **Branch** `task/027c-applicare-027`, da `main` aggiornato (028 già unito).
2. **Documenti di design.** Confronta per hash lo zip con la repo e copia: i `design/system/*.dc.html` che cambiano (Token, Inventario, Fase 2, decisioni consolidate; Stanza DEN non cambia), le cartelle `design/handoff/013/`, `014/` e `015/` **aggiornate** (prototipi e screenshot nuovi) e `design/handoff/027/` (nuova: `Account e controlli 027.dc.html`, `changelog.md`, `suono-e-vibrazione.md`, `support.js`, screenshot compresi quelli in `de-testo-2/`). Non copiare `tokens.dart` in `design/` e non sostituire i file di `handoff/` che nello zip sono **più vecchi** di quelli della repo (come nei task precedenti). Gli screenshot vecchi di 013 e 014 che il 027 non rifà restano dove sono: segna nel report quali non rispecchiano più il prototipo (per esempio quelli del caso «numero già verificato»).
3. **`tokens.dart`.** Sostituisci `app/lib/design_system/tokens.dart` con quello dello zip. Il `git diff` deve mostrare 16 righe aggiunte (`postoOffertoFinestra` in `BaCodaTokens` e la classe `BaSchermoBloccatoTokens`) e **un solo commento cambiato**. Con lo script temporaneo (non committato) controlla che l'ARGB dei colori già esistenti coincida; riporta l'esito.
4. **Test nuovi** in `test/tokens_test.dart`: `BaCodaTokens.postoOffertoFinestra` è 30 secondi e `permanenzaMassima` resta 60 minuti; `BaSchermoBloccatoTokens`: `controlloAltezza` almeno `BaControlloTokens.areaMinima`, `controlloGap` 8, `controlloRaggio` uguale a `BaRaggioTokens.pillola`, `controlloBordo` 1.
5. **Copie Markdown.** Le fornisce Luca (nessuna installazione): da `Import/copie-di-lettura-md-027c/` a `design/system/md/`, in un commit separato, **solo le quattro che cambiano** (`token.md`, `inventario-componenti.md`, `fase-2-schermate.md`, `decisioni-consolidate.md`; `stanza-den.md` resta com'è). Dimensioni attese: 67283, 40657, 30195 e 31477 byte. Il convertitore è diverso dall'ultima volta: le tabelle possono avere un'impaginazione un po' diversa.
6. **Glossario.** In `docs/GLOSSARY.md` **aggiorna le voci che le decisioni hanno superato**: *DEN pubblico* (non ha amministratore solo se creato dal sistema; creato da un utente, l'amministratore è chi lo crea: D-043); *Partecipante* (il consenso a parlare cambia il tipo di account: D-040); *Torna ascoltatore* (cambio di tipo di account, dalle impostazioni, con doppia conferma; non è un tap); *Gestisci* (vale anche per i DEN pubblici creati da un utente). **Aggiungi**: *nickname* (obbligatorio, anche ripetibile: D-052), *tipo di account* (D-040), *DEN creato dal sistema* (D-043), *Prossimo DEN* (etichetta provvisoria dei controlli a schermo bloccato; la fonte è da definire: D-050). Non aggiungere «gruppo» né «Aspetta con altri»: la proposta del nome non è ancora approvata (D-054).
7. **`docs/handoff/`.** `aperte.md`: dove diceva «da aggiornare nel design (task 027)» scrivi «recepita nel design 027» (ipotesi dell'elenco 013, di P6, T1 e T2, del nome, di «Gestisci» ai pubblici, del posto offerto, della permanenza massima), **senza dare per risolta** nessuna ipotesi che il design ha solo segnato come nuova: età minima 18 e obiettivo 16 (D-052), nuovo accesso dopo il cambio di tipo di account, chi può mandare e ricevere il richiamo, blocco temporaneo con la durata, fonte del «Prossimo DEN». Aggiungi il caso **014 · S1 «Limite di DEN attivi»**: il design lo ha tenuto con il segno «non è deciso»; è uno stato futuro del Pro, **non attivo in alpha e beta** (D-042), e non va costruito. `schermate.md`: togli l'avviso del 028 e aggiorna le schermate dei prototipi 013, 014, 015 e 027 con i componenti che servono e quali esistono o no; `componenti.md`: aggiungi in «Non ancora costruiti» i componenti nuovi che l'Inventario nomina e che il codice non ha.
8. **`DECISIONS.md`, «Aperte».** Le voci dei task 013, 014 e 015: rimpiazza le frasi «in attesa dei soci» con «recepite nel design 027 (20/11/2026)» dove è vero, e lascia le voci che restano aperte. Non cancellare niente senza dirlo nel report.
9. **Elenco dei task.** `docs/tasks/README.md`: 027 «Concluso», 027c «In corso», e la riga **023b «Fogli di creare e gestire i DEN»** (Claude Code, brief da scrivere), che nel 028 mancava.
10. **Report** con la riga «Impatto sull'handoff».

## Do NOT

- Non scrivere widget, schermate né test di interfaccia; non toccare i componenti esistenti.
- Non modificare i valori consegnati né aggiungere token.
- Niente Material o Cupertino, nuove dipendenze, golden.

## Acceptance check

- [ ] `git diff` di `tokens.dart`: solo 16 righe aggiunte e il commento di `permanenzaMassima`.
- [ ] I colori che esistevano in `main` hanno lo stesso ARGB: esito nel report.
- [ ] Il glossario non contiene più «il DEN pubblico non ha amministratore» come regola generale; le quattro voci aggiornate e le quattro nuove ci sono.
- [ ] `aperte.md` non dà per risolta nessuna ipotesi che il design ha solo segnato; il test sulla documentazione, `flutter analyze` e `flutter test` sono verdi; CI verde.
- [ ] Nessun file di `app/lib/` cambia oltre a `tokens.dart`; nessun `tokens*.dart` in `design/`; nessuno zip tracciato.

## Cosa restituire

Branch `task/027c-applicare-027`, report in `docs/reports/027c.md` (massimo 20 righe): esito del confronto dei colori, cosa copiato e cosa no, screenshot vecchi non più allineati, le voci di glossario e di «aperte» cambiate, e la riga «Impatto sull'handoff». Pull request con il template.
