// Il prototipo navigabile in locale (task 024): una pagina web in Chrome che parte
// dal login e si naviga il più possibile come un'app, con dati finti, collegando le
// pagine e i fogli già costruiti. D-030: il web è uno strumento di sviluppo e di
// dimostrazione, non una piattaforma di prodotto; il prototipo non è un'app.
//
//   cd app
//   flutter run -d chrome -t lib/prototipo/main_prototipo.dart
//
// Non tocca la galleria né il design system. Niente backend, audio,
// autenticazione vera, persistenza, notifiche di sistema, timer: lo stato è in
// memoria e ricaricare la pagina riparte dal login. Vedi `docs/handoff/prototipo.md`.
import 'package:flutter/widgets.dart';

import 'cornice.dart';

void main() => runApp(const PrototipoApp());
