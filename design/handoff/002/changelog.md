# Task 002 — changelog

9 novembre 2026. Schermate in `design/handoff/002/Stati critici 002.dc.html`; screenshot in `screenshots/` (360 dp e 744 dp, nomi parlanti, variante «sono io» dove serve). `tokens.diff.md` non è rigenerato, come richiesto. Decisioni rispettate: D-007, D-013, D-024, D-025, D-026, D-027, D-028.

| Documento | Sezione | Prima | Dopo | Motivo |
| --- | --- | --- | --- | --- |
| tokens.dart | BaColorTokens | — | `glifoTratto`, `micSpentoFondo/Glifo/Bordo`, `micSpentoIoFondo/Glifo`, `parolaTacca/Bordo`, `ascoltoGruppoBordo`, `ascoltoTuttiFondo/Testo`, `veloSipario`: tutti composti da primitive e token già presenti; nessun colore nuovo | punti 2, 5–8, 10 |
| tokens.dart | BaPresenzaTokens | — | `badgeRapporto` 0,2, `badgeMax` sp11, `badgeCentro` 0,854, `badgeDiametro(d)`, `parolaTaccaAltezza/Rapporto/Sporge` | punti 2, 6 |
| tokens.dart | BaMovimentoTokens | — | `badgeMicrofono` (= glifo, 140 ms), `fasciaAscolto` (= ricompattamento, 200 ms), `salitaAttesaMax` 8 s | punto 10 |
| tokens.dart | BaBarraAzioniTokens (nuova) | — | 1 primario, 2 secondari, «Altro» 48, `visibili(n)`, `conAltro(n)` | punto 12 |
| tokens.dart | BaSchedaPersonaTokens (nuova) | — | 3 fisse, righe ≥ 48 | punto 12 |
| tokens.dart | BaAscoltoTokens (nuova) | — | fascia «chi mi sente»: altezza minima 72, bordo border1, cornice border2 raggio 28 | punto 5 |
| tokens.dart | BaPatternApticoTokens, BaApticaTokens (nuove) | — | 8 pattern con nome, durate e ampiezze; `connessioneRipresa` = `microfonoSpento` | punto 9 |
| tokens.dart | BaSuonoTokens (nuova) | — | 3 suoni (`ba_mic_spento`, `ba_conn_persa`, `ba_conn_ripresa`), volume 0,5, `consentito(microfonoAcceso)` | punto 9; un suono a microfono aperto finisce nella stanza |
| BA · Token | T6 ter | — | 20 righe nuove, con nome e «dove» | D-010; punto 10 |
| BA · Inventario | C1 | — | variante «sul palco, microfono spento» (disco, io/altri) e tacca della parola | punto 2 |
| BA · Inventario | C3 | — | barra delle azioni, scheda di una persona, fascia «chi mi sente» | punti 5, 12 |
| BA · §7 consolidato | 7.17 (nuova) | — | microfono spento, salita, palco vuoto, consenso dell'ascoltatore (D-024) | punti 1–4 |
| BA · §7 consolidato | 7.18 (nuova) | — | chi mi sente adesso, parola ricevuta, «solo gruppo», revocata | punti 5–8 |
| BA · §7 consolidato | 7.19 (nuova) | — | regola della barra e della scheda | punto 12 |
| BA · Fase 2 schermate | avviso in testa | solo taglie del testo | + «Fase 2 mostra sempre il microfono aperto per chi è sul palco» | il task lo motiva con Fase 2 |
| handoff/002 | Stati critici 002 | — | 15 stati × 360 e 744 dp, distinzione in colore e grigi, regole di barra e scheda, etichette e annunci | punti 1–13 |
| handoff/002 | suono-e-vibrazione.md | — | 13 eventi | punto 9 |

## Dove il task ostacola una buona soluzione

- **Punto 9, «Parla solo al gruppo» e «parola revocata» come eventi con segnale.** Il task chiede un segnale per ognuno e ho dato un pattern a ciascuno. Vanno provati su telefoni veri (voce aperta, a cura di Luca): se `soloGruppo` e `microfonoSpento` si confondono, il secondo perde la seconda pulsazione.
- **Punto 6 e «stessa forza del microfono acceso».** La forza è un'ampiezza (255) e vale solo su Android; su iOS Core Haptics non garantisce l'ampiezza sui modelli più vecchi. La differenza fra i segnali sta quindi nella durata e nel numero.
- **Punto 1, soglia degli otto secondi.** Accettata come eccezione dichiarata (`salitaAttesaMax`).
- **Il tablet in alta fedeltà.** Gli stati del sotto-DEN sono concetto, ma li ho disegnati anche a 744 dp perché la regola del tablet vale per tutto.

## Non fatto

- Il tedesco è sulle etichette e sul testo di interfaccia (proprietà `lingua`); le note di progetto restano in italiano.
- Nessun suono o vibrazione è udibile nel prototipo: la tabella e i pattern sono la specifica.
- Nessuna nuova superficie di sistema: lock screen e notifica Android restano quelle del 001b (D-025).
