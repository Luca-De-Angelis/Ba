# Task 002b — changelog

9 novembre 2026. Il resto del 002 non è toccato. `tokens.diff.md` non rigenerato.

| Punto | Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- | --- |
| 1 | tokens.dart | BaBarraAzioniTokens | `visibili(n)` rendeva visibili due azioni dalla quarta in poi | `posti` = 3; `visibili(n)` = min(n, 3); nuovo `inAltro(n)` = n − 3; `conAltro(n)` = n > 3; commento: il microfono sta sempre in uno dei tre posti | ha ragione il testo: primario e due secondari, il resto in «Altro» |
| 1 | BA · §7 consolidato | 7.19 | — | + «il controllo del microfono sta sempre in uno dei tre posti: non finisce mai in un menu» | stessa regola, scritta |
| 1 | BA · Inventario | C3 | — | + «Altro» raccoglie le azioni oltre i tre posti (`inAltro(n)`) e mai il microfono | stessa regola |
| 2 | tokens.dart, BA · Token (T6 ter), handoff/002 | `pubblicoAbbassato` | pattern, riga di T6 ter, tabella, nota dello stato 9 | `soloGruppo` | «abbassato» è fuori glossario (D-008); l'interfaccia dice «Parla solo al gruppo» |
| 2 | handoff/002 | file e testi | `sotto-den-pubblico-abbassato-*.png`; stato «microfono pubblico abbassato»; annuncio «Pubblico abbassato» | `sotto-den-solo-gruppo-*.png`; «Parola in mano, «Parla solo al gruppo»»; «Solo gruppo, parola in mano» | stesso motivo |
| 3 | tokens.dart | BaApticaTokens | `parolaRevocata` [0,40,0,40,0,40]: con pause a zero, un solo impulso da 120 ms | `parolaRevocata` [0, 250], ampiezza 120: un impulso solo, lungo | si distingue per durata (250 ms contro 90 dell'acceso e 35 di soloGruppo) e per numero (uno, contro tre di parolaRicevuta e due di persa), senza contare sull'ampiezza |
| 3 | handoff/002 | suono-e-vibrazione.md | «tre impulsi corti che si spengono» | «un solo impulso, lungo (250 ms) e debole» | allineato al pattern |
| 4 | tokens.dart | BaSuonoTokens | commento senza i due microfoni | commento: nel sotto-DEN «acceso» = almeno uno dei due è aperto, e allora nessun suono | caso contrario irrappresentabile |
| 4 | handoff/002 | suono-e-vibrazione.md, regola 1 | — | stessa precisazione | punto 4 |
| 4 | handoff/002 | suono-e-vibrazione.md, connessione persa | «il microfono si spegne con la connessione (proposta)» | «lo stato del microfono appartiene alla connessione: cade il filo, il microfono è spento» | deciso (sintesi tecnica §1) |
| 5 | tokens.dart | BaAscoltoTokens | solo spessore e raggio della cornice | + `corniceSporge` = sp2 (8) e commento: la cornice sta fuori dalla scatola del palco | non toglie larghezza: 316 su 320 a 360 dp |
| 5 | BA · Inventario, BA · §7 consolidato | C3, 7.18 | — | stessa regola scritta | punto 5 |
| 5 | handoff/002 | Stati critici 002 | cornice come bordo della scatola del palco (toglieva 2 dp per lato) | cornice disegnata a 8 dp fuori dalla scatola, nel margine; screenshot degli stati 7–10 rifatti | coerenza con la regola |
| — | handoff/002 | changelog.md | ostacoli: connessione persa, soglia degli 8 s, cornice | rimossi o marcati accettati | decisioni di Luca |

## Dove il brief ostacola

Nessuno.

## Fuori dal perimetro

`BA - Stanza DEN` usa ancora «abbassare» e «abbassato» per la voce mutata (titolo «abbassare e bloccare»). È un testo del round precedente e fuori dal 002: da portare al glossario in un task a parte.
