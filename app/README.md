# App Flutter

Il progetto Flutter c'è (iOS, Android e, solo per la galleria, web). Lo stato oggi:

- **Token**: `lib/design_system/tokens.dart`, la copia unica dei valori di design, a due livelli (D-019).
- **Componenti** in `lib/design_system/`: `BaTouchable` (task 009), `BaRitratto`, `BaAnello` e `BaPresenza` con `BaDiametro` (task 010 e 010b, stati di base), `BaPalco` (task 011, widget sopra `disponiPalco` in `palco/disposizione.dart`). Manca `BaGlifo` con gli stati con glifo (task 012). I testi di `BaPalco` gli arrivano dal chiamante: non importa le traduzioni.
- **Traduzioni**: file ARB in `lib/l10n/`, `l10n.yaml`, `generate: true`. Cinque lingue (IT, EN, FR, ES, DE); per ora c'è solo la chiave di prova `appNome`.
- **Font**: Instrument Sans e IBM Plex Mono (OFL) in `assets/fonts/`, dichiarati nel `pubspec.yaml`.
- **Galleria di sviluppo**: vedi sotto.
- `lib/features/` e `lib/core/` (audio, servizio) sono ancora vuote. `main.dart` è uno schermo vuoto del colore di fondo, senza Material.

Struttura di `lib/`:

```
lib/
├── design_system/   # tokens.dart, BaTouchable, BaPresenza, palco/…
├── galleria/        # pagine di sviluppo (D-030), esenti da l10n
├── features/        # access, home, room, settings (vuota)
├── l10n/            # file ARB
├── core/            # audio (LiveKit), servizio (vuota)
└── main.dart
```

L'ordine di costruzione è in `design/system/md/inventario-componenti.md`: `BaTouchable` → `BaPresenza` con `BaRitratto` e `BaAnello` → `BaPalco` → i componenti con glifo.

Comandi, sempre da questa cartella: `flutter pub get`, `flutter analyze`, `flutter test`.

## Tablet e orientamento (D-020)

L'app gira su telefono e tablet dalla beta 1, per ora solo in verticale. Due punti tecnici da decidere con lo sviluppo:

- Su iPad, un'app che limita l'orientamento deve rinunciare a Split View e Slide Over (`UIRequiresFullScreen` in `Info.plist`). Se in futuro si aggiunge l'orizzontale, si può tornare indietro.
- Il blocco in verticale si imposta sia nella configurazione nativa sia con `SystemChrome.setPreferredOrientations`, ma il layout non deve dipenderne: i breakpoint usano la larghezza.

## Galleria di sviluppo (D-030)

Una pagina per vedere i componenti del design system in Chrome, senza emulatore né Mac. Il web serve solo a questo: i target restano iOS e Android.

Da questa cartella (`app/`):

```bash
flutter run -d chrome -t lib/galleria/main_galleria.dart
```

La galleria sta in `lib/galleria/`, usa solo i token e i suoi testi sono fissi (fuori da `l10n/`). Un menu in cima sceglie la pagina:

- **BaTouchable**: mostra le aree toccabili, riduci movimento, larghezza 360 o 744.
- **BaPresenza**: le presenze ai cinque diametri, le 12 tinte e le 5 sagome, con i controlli per parla, ampiezza (0, 0,5, 1), voci insieme (1, 2, 3), linea instabile, persa, scheletro, immagine caricata e fallita, riduci movimento e «Simula voce» (una ampiezza nuova ogni 500 ms). Per vedere insieme la voce al massimo e il focus sulla stessa presenza: Parla, Ampiezza 1, poi Tab.
- **BaPalco**: una stanza finta (intestazione, palco, riga sotto) con persone da 0 a 8, quante parlano (0–3), persa, scheletro, congelato, larghezza 360 o 744, testo di sistema 1,0 o 2,0, riduci movimento e lingua (IT, EN, FR, ES, DE); un indicatore mostra diametro, scatola e «sfora». Con 1 persona e testo normale: la stanza vuota con una persona a 208 dp.
