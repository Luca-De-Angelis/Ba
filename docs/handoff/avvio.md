# Avvio: farlo girare

Come far partire il progetto sul tuo computer, lanciare analisi e test, e aprire la **galleria** (la pagina di sviluppo che mostra i componenti in Chrome). Tutti i comandi si lanciano da `app/`, salvo dove è scritto.

Torna all'[indice](README.md). Dopo questo file: [architettura](architettura.md).

## Che cosa serve

| Cosa | Valore | Dove è scritto |
| --- | --- | --- |
| Flutter | **3.47.9**, canale `stable`, fissato di proposito | [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml) (`flutter-version`) e la riga di [`CLAUDE.md`](../../CLAUDE.md) sulla CI |
| Dart | `^3.13.7` (arriva con Flutter) | [`app/pubspec.yaml`](../../app/pubspec.yaml) (`environment`) |
| Chrome | per la galleria (il web serve solo a questo, D-030) | — |
| Xcode, Android SDK, emulatori | per costruire l'app su iOS e Android | **da verificare**: in questa fase non sono stati provati (il lavoro è fatto con la galleria e i test) |

La versione di Flutter si aggiorna in un task a parte, e quando si aggiorna in locale si aggiorna anche in `ci.yml`: lo dice `CLAUDE.md`. La voce «Aggiornamento di Flutter» di [`DECISIONS.md`](../DECISIONS.md) (sezione «Aperte») elenca che cosa controllare quando lo si fa: i delegati Material e Cupertino del file di traduzioni generato e i test sensibili ai tempi.

Installare Flutter sul tuo computer non è descritto qui: segui la guida ufficiale di Flutter (**da verificare**: non provato, perché dipende dal sistema operativo). Per controllare di avere la versione giusta: `flutter --version` deve dire 3.47.9.

## I comandi

Provati il 18 novembre 2026 su Windows 11, con Flutter 3.47.9 (la versione fissata).

| Comando | A che cosa serve | Provato |
| --- | --- | --- |
| `flutter pub get` | installa le dipendenze: solo Flutter, `flutter_localizations` e `intl` (e `flutter_lints` per l'analisi) | sì: risolve e termina |
| `flutter analyze` | l'analisi statica, la stessa della CI | sì: nessun avviso |
| `flutter test` | tutti i test, la stessa cosa che fa la CI. Non ci sono test golden (immagini di riferimento) | sì: tutti verdi |
| `flutter run -d chrome -t lib/galleria/main_galleria.dart` | apre la **galleria** in Chrome | sì: compila, apre Chrome, avvia l'applicazione («Starting application from main method») e mostra i comandi interattivi (`r` hot reload, `R` hot restart, `q` esci). L'aspetto delle pagine non è verificabile da un comando: va guardato |
| `flutter build web -t lib/galleria/main_galleria.dart` | compila la galleria per il web senza aprirla | da verificare (vedi la nota in fondo) |

Note:

- **Le traduzioni si generano da sole.** `flutter pub get`, `flutter analyze` e `flutter test` rigenerano i file `lib/l10n/app_localizations*.dart` dai file `.arb` (`generate: true` in `pubspec.yaml`, configurazione in [`app/l10n.yaml`](../../app/l10n.yaml)). I file generati **non sono nella repo** (li esclude `app/.gitignore`) e l'analisi li ignora (`analysis_options.yaml`). Se cambi un `.arb` e un test vede il testo vecchio, lancia `flutter gen-l10n`.
- **Il prezzo del primo test.** Il primo `flutter test` compila tutto e ci mette di più; poi bastano pochi secondi per file. L'intera suite ha impiegato fra circa 30 secondi e circa due minuti, a seconda della macchina.
- **`main.dart` oggi è uno schermo vuoto** del colore di fondo, senza Material ([`app/lib/main.dart`](../../app/lib/main.dart)): l'app vera non esiste ancora. Per vedere qualcosa si usa la galleria.
- **La CI** lancia lo stesso: dipendenze, `flutter analyze`, `flutter test` e un controllo che nel design system non si importi Material né Cupertino. Vedi [produzione](produzione.md).

## La galleria

Sta in [`app/lib/galleria/`](../../app/lib/galleria/): una pagina per componente (o gruppo di componenti), con un menu in cima per scegliere. I suoi testi sono fissi (non passa dalle traduzioni, D-030) e usa solo i token. **Non fa parte dell'app.**

| Pagina | Che cosa mostra | Controlli (i nomi dei pulsanti) |
| --- | --- | --- |
| **BaTouchable** | le aree toccabili e il feedback di tocco | «Mostra le aree toccabili», «Riduci movimento», «Larghezza 360/744» |
| **BaPresenza** | le presenze ai cinque diametri, le 12 tinte, le 5 sagome, i glifi | «Parla», «Ampiezza», «Voci», «Linea instabile», «Persa», «Scheletro», «Mutata», «Bloccata», «Microfono spento: altri / io», «Ha la parola», «Immagine caricata / fallita», «Riduci movimento», «Simula voce» |
| **BaPalco** | una **stanza finta**: intestazione, palco, pubblico e barra delle azioni veri; toccando una presenza si apre la scheda, «Altro» apre le azioni oltre la terza | «Persone −/+», «Parlano», «Persa», «Scheletro», «Congelato», «Larghezza», «Altezza», «Testo 1,0/2,0», «Riduci movimento», «Prima persona» (cicla gli stati con glifo), «Lingua» (IT, EN, FR, ES, DE) |
| **Controlli** | le quattro varianti di pillola, la coppia, la barra con 1–6 azioni, il pubblico con 0, 1, 2, 3 e 14 | «Larghezza», «Testo», «Riduci movimento», «Azioni −/+» |
| **Fogli e messaggi** | una schermata finta con un pulsante per ogni foglio (richiesta, invito, scheda), e i due messaggi | «Larghezza», «Testo», «Riduci movimento», «Messaggio» (nessuno, neutro, errore) |

Che cosa fanno i controlli di sempre:

- **Testo 1,0 / 2,0**: il testo di sistema, normale o al massimo (2,0 è il tetto che l'app rispetta). A 2,0 nessun testo si deve tagliare e ciò che sta sopra le azioni scorre.
- **Larghezza 360 / 744**: il telefono più stretto di riferimento (D-022) e il tablet verticale. Il tablet si decide sulla **larghezza** dello schermo, da 600 dp, mai sull'orientamento (D-027).
- **Riduci movimento**: simula l'impostazione di sistema; le animazioni diventano immediate.
- **Lingua** (solo nella pagina del palco, che usa le chiavi di traduzione): cambia lingua alla stanza finta.
- **Altezza** (palco): fa cedere il palco senza ridimensionare la finestra, per vedere il diametro scendere.

Sui due fogli e sulla scheda: aprendoli nella stanza finta le presenze dietro si attenuano (`dietro` di `BaPalco`) finché il foglio è aperto.

Il dettaglio di ogni pagina è anche in [`app/README.md`](../../app/README.md). Per la mappa dei componenti vedi [componenti](componenti.md).
