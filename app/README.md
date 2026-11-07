# App Flutter

Il progetto Flutter non è ancora stato creato. Per crearlo qui, da questa cartella:

```bash
flutter create --platforms=ios,android --org <dominio.rovesciato> --project-name ba .
```

Sostituisci `<dominio.rovesciato>` con l'identificativo dell'azienda (per esempio `com.nomeazienda`): va deciso con chi pubblicherà l'app sugli store.

`flutter create` non tocca `lib/design_system/tokens.dart`, che è già qui ed è la copia unica dei valori di design.

Due punti di configurazione, da fare alla creazione del progetto:

- **Traduzioni.** File ARB in `lib/l10n/`, `l10n.yaml` in `app/`, `generate: true` nel `pubspec.yaml`. Cinque lingue: IT, EN, FR, ES, DE.
- **Font.** Instrument Sans e IBM Plex Mono (licenza OFL) in `assets/fonts/`, dichiarati nel `pubspec.yaml` con i nomi di famiglia di `tokens.dart`.

Struttura prevista di `lib/`:

```
lib/
├── design_system/   # tokens.dart, BaTouchable, BaPresenza, BaPalco…
├── features/        # access, home, room, settings
├── l10n/            # file ARB
├── core/            # audio (LiveKit), servizio
└── main.dart
```

L'ordine di costruzione è in `design/system/md/inventario-componenti.md`: prima `BaTouchable`, poi `BaPresenza` con `BaRitratto` e `BaAnello`, poi `BaPalco` come funzione pura con i suoi test.

## Tablet e orientamento (D-020)

L'app gira su telefono e tablet dalla beta 1, per ora solo in verticale. Due punti tecnici da decidere con lo sviluppo:

- Su iPad, un'app che limita l'orientamento deve rinunciare a Split View e Slide Over (`UIRequiresFullScreen` in `Info.plist`). Se in futuro si aggiunge l'orizzontale, si può tornare indietro.
- Il blocco in verticale si imposta sia nella configurazione nativa sia con `SystemChrome.setPreferredOrientations`, ma il layout non deve dipenderne: i breakpoint usano la larghezza.

Nota: `tokens.dart` è la versione esportata da Claude Design prima del task 001, che ne corregge alcuni valori e nomi.
