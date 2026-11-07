# BA

Social vocale basato sulla presenza. Questa repo tiene insieme app, design e documenti di progetto: è l'unica fonte di verità per Claude Code, Claude Design e la chat di orchestrazione.

## Struttura

```
ba/
├── CLAUDE.md           # istruzioni per Claude Code
├── .claude/commands/   # /verify
├── .github/            # CI e template della pull request
├── docs/               # decisioni, funzionalità, glossario, brief, ADR, task, report, ricerca
├── design/             # export di Claude Design, consegne per task, marchio
└── app/                # Flutter (da creare, vedi app/README.md)
```

## Chi fa cosa

| Strumento | Ruolo | Scrive in |
| --- | --- | --- |
| Claude AI (chat di orchestrazione) | Requisiti, decisioni, brief dei task, review del diff, documenti per gli stakeholder | `docs/` tramite te o Claude Code |
| Claude Design | Superfici nuove: schermate, stati, testi, token | `design/handoff/NNN/`, `design/system/` |
| Claude Code (VS Code) | Tutto il codice, test, report, pull request | `app/`, `docs/reports/` |
| Git e GitHub | Storia, branch, review, rilasci | — |

## Ciclo di un task

1. Il brief del task va in `docs/tasks/NNN-nome.md`.
2. Se c'è interfaccia nuova, Claude Design consegna in `design/handoff/NNN/`.
3. Claude Code, in Plan mode, propone il piano; lo approvi.
4. Claude Code lavora su `task/NNN-nome`, lancia `/verify NNN`, scrive il report e apre la pull request.
5. Review: porti alla chat di orchestrazione il diff (`gh pr diff NNN > NNN.patch`), il report e gli screenshot. Torna un verdetto: approvato o correzioni.
6. Merge su `main`; a ogni rilascio un tag (`alpha`, `beta-1`, `beta-2`).

Per un bugfix rapido: descrivi il sintomo a Claude Code, che riproduce, corregge, verifica e fa il commit. Passa dalla chat di orchestrazione solo se il fix tocca una decisione, il consenso, i dati personali o gli stati critici.

## Primi passi

- [ ] Crea una repo **privata** su GitHub e carica questo scheletro.
- [ ] Proteggi `main`: niente push diretti, pull request obbligatoria con CI verde.
- [ ] In `app/`, crea il progetto Flutter (vedi `app/README.md`).
- [ ] Esporta in Markdown i Claude Docs e salvali: aggiornamento del brief v2.2 in `docs/brief/`, task 001 e 002 in `docs/tasks/`.
- [ ] Aggiungi la sintesi tecnica sull'audio in `docs/research/`.
- [ ] Chiedi al team di sviluppo se esiste già una repo con gli ADR e `BA_Decisioni_Consolidate.md`: se sì, unisci i registri in `docs/DECISIONS.md` e porta gli ADR in `docs/adr/`.
- [ ] Decidi dove vivono server, LiveKit e trascrizione: qui in `server/` e `infra/`, oppure in una repo separata. In quel caso, linkala da questo README.
