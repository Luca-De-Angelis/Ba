# Task 012 — BaGlifo e gli stati della presenza con glifo

11 novembre 2026 · chat di orchestrazione · per Claude Code

## Context

Quarto passo dell'ordine di costruzione. Il 010 ha dato a `BaPresenza` gli stati ferma, parla, persa, scheletro, premuta e a fuoco; l'011 ha messo le presenze sul palco. Mancano gli stati che hanno bisogno di un **glifo**: **mutata**, **mutata che parla**, **bloccata**, e le due cose nate con il task 002: il **disco del microfono spento** e la **tacca della parola**. Fonti: `design/system/md/inventario-componenti.md` (C1, C3), `token.md` (T4, T6 ter, T8), `tokens.dart` (`BaPresenzaTokens.glifo*`, `badge*`, `parolaTacca*`, `mutata*`, `inizialiMutataOpacita`, `inizialiBloccataOpacita`; `BaColorTokens.glifoTratto`, `micSpento*`, `parolaTacca*`, `neutroBloccata`, `veloMutataImmagine`; `BaMovimentoTokens.glifo`, `badgeMicrofono`) e il prototipo `design/handoff/002/Stati critici 002.dc.html` per la **geometria dei glifi**, che lì è disegnata con forme in percentuale (capsula, arco, stelo, barra a −45° con un fondo scuro sotto il tratto chiaro): cerca `bGlifo` e `bFondo`. Dove un documento tace, **proponi nel piano e segnala nel report**.

## Do

1. **Branch** `task/012-glifi`, da `main` aggiornato.
2. **`BaGlifo`** (`lib/design_system/glifo.dart`). Tre glifi: **microfono barrato** (microfono spento), **altoparlante barrato** (voce mutata), **cerchio barrato** (bloccata). Lato 28 (`glifo`); 32 (`glifoRipiego`) solo se il chiamante lo chiede, perché a 28 non si legge: cresce, non si colora. Stato **spento** a opacità 0,45 (`glifoOpacitaSpento`) e **acceso** a 1: il passaggio dura 140 ms (`BaMovimentoTokens.glifo`) e con "riduci movimento" è immediato. Il glifo è decorativo: fuori dalla semantica, perché l'etichetta la porta la presenza. Proporzioni dal prototipo, in percentuale del lato; la barra diagonale ha il suo fondo scuro sotto il tratto chiaro. Disegnalo con quello che `widgets.dart` ti dà; se ti serve un import in più, **proponilo nel piano** (come per `semantics.dart`).
3. **Stati di `BaPresenza`** (si aggiungono ai sei del 010):
   - **mutata**: sagoma con `mutataSaturazione` e `mutataOpacita`, iniziali a `inizialiMutataOpacita`, con immagine il velo `veloMutataImmagine`; **nel disco** (punto 4) il glifo altoparlante barrato, spento. Le iniziali non si coprono mai: nessun glifo al centro della presenza;
   - **mutata che parla**: lo stesso, ma il glifo nel disco si accende. Proponi nel piano se l'anello compare o no (T4 dice solo che il glifo si accende);
   - **bloccata**: gradiente `neutroBloccata` al posto della tinta, iniziali a `inizialiBloccataOpacita`, **nel disco** il glifo cerchio barrato, **mai l'anello**, anche con `parla`;
   - **persa è un filtro sopra**, non uno stato esclusivo: avvolge qualunque aspetto la presenza abbia (grigio, opacità `persaOpacita`, nessun anello; il disco si attenua insieme). Una persona bloccata che perde la linea resta neutra, non mostra la tinta in grigio. Lo **scheletro batte tutto**.
4. **Il disco** (§7.17, prototipo Stati critici 002: «un disco da 28 dp all'angolo in basso a destra»). **Tutti e tre i glifi stanno nello stesso disco**: microfono barrato per il microfono spento, altoparlante barrato per la voce mutata, cerchio barrato per la bloccata. Un disco generico (`BaDiscoGlifo`) di `badgeDiametro(d)`, centrato a `badgeCentro` (0,854) × d sui due assi, cioè sul punto della sagoma a 45° in basso a destra. Colori «altri» (fondo `micSpentoFondo`, glifo `micSpentoGlifo`, bordo `micSpentoBordo`); la variante **io** (fondo `micSpentoIoFondo`, glifo `micSpentoIoGlifo`) vale solo per il microfono spento, perché la mia presenza si trova fra le altre. **Un solo disco: vince bloccata, poi mutata, poi microfono spento.** Per la mutata il disco c'è sempre e il glifo dentro è spento (0,45); se parla si accende (1) in 140 ms. Per il microfono spento il glifo è sempre acceso. Il disco compare e sparisce in 140 ms (`badgeMicrofono`), immediato con "riduci movimento". Non è toccabile da solo. Il segno è una forma e non un colore: in scala di grigi si legge uguale. La tacca della parola (punto 5) è indipendente dal disco.
5. **Tacca della parola** (sotto-DEN). Una barra sotto la sagoma: colore `parolaTacca`, bordo `parolaTaccaBordo`, altezza `parolaTaccaAltezza`, larghezza `parolaTaccaRapporto` × d, che sporge `parolaTaccaSporge` (9) sotto la sagoma. Sporge oltre `BaPresenza.ingombro`: sta nello spazio che il palco riserva fra le presenze. Non deve essere tagliata.
6. **`BaPersonaPalco` e `BaPalco`.** Aggiungi i campi `mutata`, `bloccata`, `microfonoSpento`, `haLaParola` e `io`, e inoltrali alla presenza. Il limiter conta solo le voci con anello: `parla && !persa && !mutata && !bloccata`. Proponi se è giusto.
7. **Etichette e traduzioni.** Le etichette arrivano già composte dal chiamante. Aggiungi le chiavi ARB nelle cinque lingue per la galleria: «{nome}, voce mutata da te», «{nome}, bloccata», «{nome}, microfono spento», «{nome}, ha la parola». Il tedesco prendilo da `Stati critici 002.dc.html` dove c'è. Le altre sono bozze **da far rivedere a madrelingua**, nel report.
8. **Galleria.** Nella pagina delle presenze: controlli per mutata, mutata che parla, bloccata, microfono spento (altri e io), ha la parola, e una riga con i tre glifi a 28 e 32, spenti e accesi. Nella pagina del palco: un controllo che dà alla prima persona uno di questi stati. **E sistema il difetto della stanza finta:** a testo 2,0 l'intestazione, che va a capo, deve occupare la sua altezza naturale e il palco deve partire sotto di essa, senza sovrapporsi alle presenze.
9. **Documenti.** `docs/tasks/README.md`: 011 «Concluso», 012 «In corso». `app/README.md`: i componenti nuovi.

## Test (di widget, senza golden)

- **Glifo:** lato 28 e, a richiesta, 32; opacità 0,45 da spento e 1 da acceso dopo 140 ms; immediato con "riduci movimento"; fuori dalla semantica.
- **Mutata:** saturazione e opacità dei token, iniziali a 0,80, **disco con altoparlante** e glifo spento; mutata che parla: glifo acceso entro 140 ms, nessun anello.
- **Bloccata:** gradiente neutro a due stop, iniziali a 0,70, **disco con cerchio barrato**, nessun anello nemmeno con `parla`. **Disco: bloccata > mutata > microfono spento**, uno solo. **Persa è un filtro** sopra qualunque aspetto (bloccata resta neutra); scheletro batte tutto.
- **Disco:** diametro `badgeDiametro(d)` a 88, 112, 130, 156 e 208; centro a 0,854 × d; colori altri contro io; comparsa in 140 ms e immediata senza movimento; l'area toccabile della presenza non cambia.
- **Tacca:** larghezza 0,42 × d, altezza 6, sporge 9 sotto la sagoma e non è tagliata.
- **Palco:** i campi nuovi arrivano alle presenze; il limiter non conta mutate né bloccate; l'ordine di lettura non cambia.
- **Traduzioni:** le chiavi nuove esistono in cinque lingue.

## Do NOT

- Non costruire `BaPubblico`, la variante sistema, `BaRigaBloccata`, né le altre righe e pillole.
- Non scrivere codice di suono né di vibrazione, né file audio: sono task successivi.
- Non toccare `tokens.dart`; se manca un valore, segnalalo.
- Niente Material o Cupertino, niente nuove dipendenze, niente golden, nessun numero di design a mano.

## Acceptance check

- [ ] I test passano; `flutter analyze` e `flutter test` verdi; CI verde.
- [ ] Nessun numero di design a mano; ogni import oltre `widgets.dart` motivato nel file e in `CLAUDE.md`.
- [ ] Nella galleria, la verifica di Luca: i tre glifi leggibili a 28; la mutata sbiadita, con l'altoparlante barrato nel disco che si accende quando parla; la bloccata grigia, con il cerchio barrato nel disco e senza anello; il disco a 45° in basso a destra, con il microfono barrato chiaro per me e scuro per gli altri; le iniziali mai coperte; la tacca sotto la sagoma; in scala di grigi i quattro stati si distinguono ancora.

## Cosa restituire

Branch `task/012-glifi`, report in `docs/reports/012.md` (massimo 30 righe) con le proposte fatte dove i documenti tacciono, le traduzioni da rivedere e ciò che non hai potuto verificare. Pull request con il template.
