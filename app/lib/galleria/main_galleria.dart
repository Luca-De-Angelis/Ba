// Galleria di sviluppo (task 009, D-030): una pagina per vedere i componenti
// del design system in Chrome. Il web serve solo a questo e non è una
// piattaforma di prodotto. Non fa parte dell'app e non importa l10n: i testi
// sono fissi.
//
// Da app/:
//   flutter run -d chrome -t lib/galleria/main_galleria.dart
import 'package:flutter/widgets.dart';

import '../design_system/tokens.dart';
import 'galleria_touchable.dart';

void main() => runApp(const GalleriaApp());

class GalleriaApp extends StatelessWidget {
  const GalleriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: BaColorTokens.fondoApp,
      textStyle: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: const GalleriaTouchable(),
    );
  }
}
