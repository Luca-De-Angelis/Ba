# Design

- `system/` — export di Claude Design: Token, Inventario componenti, decisioni consolidate (§7), Fase 2 schermate, Stanza DEN (Fase 1, storico). Gli HTML sono l'originale; `system/md/` contiene copie di lettura in Markdown per Claude Code.
- `handoff/NNN/` — una cartella per ogni consegna di Claude Design legata a un task.
- `brand/` — icona e versioni cromatiche.

**`tokens.dart` non sta qui.** La copia unica è in `app/lib/design_system/tokens.dart`. Claude Design la riceve come input e restituisce solo le righe da cambiare nel suo handoff; le applica Claude Code nella pull request del task.

Quando Claude Design aggiorna un documento di sistema, sostituisci l'HTML in `system/` e rigenera la copia in `system/md/`, oppure chiedilo a Claude Code.
