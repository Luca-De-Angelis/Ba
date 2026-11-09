# Mappa dei token — task 004

Riferimento: Tailwind v4. Primitive in `BaPaletteTokens` (colori, RGB senza alfa) e `BaPrimitiveTokens` (misure). "Eccezione" vuol dire che il valore resta com'è, con il motivo scritto in `tokens.dart`. Le classi semantiche prendono il suffisso `Tokens` (D-021).

## Spazio — tutto sulla scala, valori invariati

| Vecchio | Valore | Nuovo | Motivo |
| --- | --- | --- | --- |
| BaSpazio.xxs | 4 | sp1 | scala |
| BaSpazio.xs | 6 | sp1_5 | mezzo passo |
| BaSpazio.s | 8 | sp2 | scala |
| BaSpazio.sm | 10 | sp2_5 | mezzo passo |
| BaSpazio.m | 12 | sp3 | scala |
| BaSpazio.md | 14 | sp3_5 | mezzo passo |
| BaSpazio.l | 16 | sp4 | scala |
| BaSpazio.xl | 20 | sp5 | scala |
| BaSpazio.xxl | 24 | sp6 | scala |
| BaSpazio.xxxl | 32 | sp8 | scala |
| BaSpazio.sezione | 44 | sp11 | scala |
| BaSpazio.margineSchermo | 20 | sp5 | scala |

## Tipografia

| Vecchio | Valore | Nuovo | Motivo |
| --- | --- | --- | --- |
| BaTesto.stanza | 22 | text22 (estensione) | 20 è già il foglio; 24 ruba altezza al palco sul telefono più piccolo |
| BaTesto.foglio | 20 / 1,25 | textXl / leadingTight | scala |
| BaTesto.riga | 18 | textLg | scala |
| BaTesto.controllo | 16 | textBase | scala |
| BaTesto.corpo | 15 / 1,5 | textBase (16) / leadingNormal | allineato: è il testo più letto, e 16 è la base del testo di sistema |
| BaTesto.azione | 14 | textSm | scala |
| BaTesto.minore | 13 / 1,45 | textSm (14) / leadingSm (20/14) | allineato: secondo grigio su fondo scuro, a 13 si legge male di notte |
| BaTesto.marcatore | 11 / 0,66 | textXs (12) / 0,06em = 0,72 | allineato: mono maiuscolo a 11 sotto il passo minimo e al limite della leggibilità |
| BaTesto.nota | 10 / 0,5 | textXs (12) / trackingWider = 0,6 | allineato: 10 sotto ogni soglia di leggibilità; ora coincide con marcatore salvo la spaziatura |
| tracking dei titoli | -0,26 · -0,30 · -0,18 | eccezione | ottico per taglia; tracking-tight (-0,025em) è il doppio |
| trackingMarcatore | 0,06em | estensione | fra wider (0,05) e widest (0,1) |

## Raggi

| Vecchio | Valore | Nuovo | Motivo |
| --- | --- | --- | --- |
| BaRaggio.pillola | 999 | roundedFull (999) | Tailwind usa 9999: per una pillola è identico |
| BaRaggio.foglio | 26 | rounded3xl (24) | allineato: 2 dp su un foglio non si vedono |
| BaRaggio.cardSistema | 22 | rounded22 (estensione) | imita il contenitore della Live Activity, che non disegniamo noi |
| BaRaggio.cardNotifica | 24 | rounded3xl | scala |
| BaRaggio.riquadro | 14 | rounded2xl (16) | allineato: equidistante da 12 e 16; 16 resta più vicino alle sagome |

## Colori — esadecimali invariati

| Vecchio | Valore | Nuovo | Motivo |
| --- | --- | --- | --- |
| fondoApp | #0A0A09 | pietra950 | fondo dell'app = 950 |
| fondoStanza | #171413 · #100F0E · #0B0A09 | pietra920 · 940 · 945 | passi intermedi: il tema scuro vive sotto il 900 |
| fondoAlone | #E6DCBE · 0E | sabbia200 · a5_5 | alfa 5,5%, non arrotondato |
| superficieFoglio | #161412 | pietra925 | |
| superficieSistema | #1C1917 · DB | pietra900 · a86 | |
| superficieNotifica | #1A1917 | pietra910 | |
| superficieIsola | #000000 | nero | |
| testoPrimo · Secondo · Terzo · Spento · Inattivo | #F2EEE9 · A09890 · 8A837B · 6E6862 · 5E5952 | pietra100 · 400 · 500 · 600 · 700 | |
| testoSuTinta | #FFFFFF | bianco | |
| testoSuChiara, focusAnelloSuChiara | #100F0E | pietra940 | |
| filettoAppena · Base · Divisorio · Marcato | #F2EEE9 · 6/10/12/14% | pietra100 · a6 · a10 · a12 · a14 | modificatore /n |
| azioneChiara, focusAnello | #D9CFA8 | sabbia300 | |
| azioneChiaraPiena | #EDE7DC → #D2C9B6 | sabbia100 → sabbia400 | |
| azioneAttivaBordo | #D9CFA8 · 42% | sabbia300 · a42 | |
| azioneAttivaFondo | #302A25 → #1F1A15 | sabbia900 → sabbia950 | |
| erroreTesto · erroreFiletto | #E4705B · 32% | corallo400 · a32 | |
| voceKeyline | #080706 · 92% | pietra975 · a92 | |
| voceTratto | #F5F1EC | pietra50 | |
| voceTrattoFermo · Stanza · StanzaTenue | #F5F1EC · 34/62/55% | pietra50 · a34 · a62 · a55 | |
| neutroBloccata (001) | #3D3B39 → #2A2927 | pietra800 → pietra850 | |
| veloImmagine (001) | #080706 · 34% | pietra975 · a34 | |
| veloMutataImmagine (001) | #080706 · 66% | pietra975 · a66 | |
| premutoVelo (001) | #F2EEE9 · 6% | pietra100 · a6 | |
| premutoKeyline (001) | #080706 | pietra975 | |
| BaTinta.mazzo (12 × 2) | invariati | indaco, mattone, bosco, ocra, mare, lampone, oliva, viola, petrolio, malva, ruggine, muschio · 700 e 900 | 700 lo stop chiaro, 900 lo scuro |

## Presenza, anello, limiter, glifo, scheletro (001)

| Vecchio | Valore | Nuovo | Motivo |
| --- | --- | --- | --- |
| sola · xl · l · m · s | 208 · 156 · 130 · 112 · 88 | eccezione, invariati | scala delle presenze, D-009; nessuna primitiva anche dove coincide (208 = sp52) |
| minimo | 32 | eccezione | dominio delle iniziali; non scala sul tablet |
| sistema · sistemaIsola · sistemaNotifica · pubblico | 36 · 34 · 32 · 22 | eccezione | token di componente |
| **diametro(n)** | — | **diametro(n, larghezza)** | CAMBIATO: da sm la scala × 1,5 → 312 · 234 · 195 · 168 · 132 |
| **scalaTablet** (nuovo) | 1,5 | eccezione | rapporto; dà valori interi |
| **perRigaMax(larghezza)** (nuovo) | 3 · 4 da sm | — | nuovo: tetto assoluto (3 telefono, 4 tablet), distinto da tettoPerRiga del palco, che resta in codice |
| distanzaMinima | d + 17 | invariata, ora somma di token | D-009; vale anche sul tablet |
| anelloKeyline | 3 | eccezione | a 2 o 4 cambierebbe la luce di 17 |
| anelloTratto | 2 | border2 | |
| anelloCrescitaPicco | 4 | sp1 | |
| respiro | 8 | sp2 | |
| anelloScala/Opacità riposo e picco | 1,00 · 1,075 · 0,28 · 0,95 | eccezione | rapporti del respiro, §7.7 |
| limiterDueScala · DueOpacita · Fattore | 1,042 · 0,66 · 1,12 | eccezione | provvisorio, §7.8 |
| tettoLuminanza | 0,18 | eccezione | vincolo, non stile |
| glifo · glifoRipiego | 28 · 32 | sp7 · sp8 | |
| glifoOpacitaSpento | 0,45 | eccezione | opacità di stato |
| scheletroOpacitaMin · Max | 0,30 · 0,62 | eccezione | opacità di stato; 0,62 non è un passo da 5 |
| mutata*, iniziali*Opacita, persa, dietro | 0,25 · 0,78 · 0,80 · 0,70 · 0,34 · 0,22 · 1,5 | eccezione | stati del §7 |
| iniziali 0,295 · 0,35 | — | eccezione | rapporti con il loro dominio |

## Controlli e tocco

| Vecchio | Valore | Nuovo | Motivo |
| --- | --- | --- | --- |
| primario · coppia · gapCoppia | 56 · 48 · 10 | sp14 · sp12 · sp2_5 | |
| sistemaLock · sistemaIsola | 38 · 34 | eccezione | misure delle superfici di sistema |
| areaMinima · areaEstesa | 44 · 8 | sp11 · sp2 | |
| focusSpessore | 2 | border2 | |
| focusStacco | 3 | eccezione | a 2 tocca la keyline, a 4 si stacca dalla sagoma |
| premutoScala (001) | 0,98 | eccezione | D-009; Tailwind ha 95 e 100 |

## Movimento, Dynamic Type

| Vecchio | Valore | Nuovo | Motivo |
| --- | --- | --- | --- |
| tutte le durate e le due curve | invariate | eccezione | seguono campionamento e percezione (§7.7); con duration-* coincidono solo 200 e 500 |
| BaScala.maxTesto · maxMarcatore · iniziali | 2,0 · 1,6 · 1,0 | eccezione | rapporti, non misure |

## Nuovi

| Token | Valore | Primitiva | Uso |
| --- | --- | --- | --- |
| BaPrimitiveTokens.sm | 600 | estensione (Tailwind sm = 640) | soglia del tablet |
| BaLayoutTokens.colonna | 512 | maxWLg | testi, elenchi, azioni |
| BaLayoutTokens.margineTablet | 32 | sp8 | margine del palco e minimo della colonna |
| BaLayoutTokens.tablet(larghezza) · larghezzaColonna · larghezzaPalco | — | — | solo larghezza, mai orientamento |
