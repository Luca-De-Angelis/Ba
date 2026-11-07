Verifica il task $ARGUMENTS prima della pull request. Esegui i passi in ordine e non fermarti al primo errore: raccogli tutto.

1. Da `app/`: `flutter analyze`. Riporta ogni avviso.
2. Da `app/`: `flutter test`, compresi i test golden. Non aggiornare i golden.
3. Controlla che nessun file in `app/lib/design_system/` importi `package:flutter/material.dart` o `package:flutter/cupertino.dart`.
4. Cerca numeri scritti a mano nei widget modificati (dimensioni, colori, durate) che dovrebbero essere token.
5. Controlla che le stringhe nuove siano in `app/lib/l10n/` in tutte e cinque le lingue.
6. Rileggi l'acceptance check in `docs/tasks/$ARGUMENTS-*.md` e segna, per ogni punto, verificato / non verificato / non verificabile, con il motivo.
7. Scrivi `docs/reports/$ARGUMENTS.md` seguendo `docs/reports/_template.md`, massimo 30 righe.
8. Se hai cambiato `tokens.dart` o toccato una decisione, dillo in cima al report.
