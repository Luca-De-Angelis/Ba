// Galleria di sviluppo (task 009, D-030): una pagina per vedere i componenti
// del design system in Chrome. Il web serve solo a questo e non è una
// piattaforma di prodotto. Non fa parte dell'app e non importa l10n: i testi
// sono fissi.
//
// Da app/:
//   flutter run -d chrome -t lib/galleria/main_galleria.dart
import 'package:flutter/widgets.dart';

import '../design_system/tokens.dart';
import 'comuni.dart';
import 'galleria_presenza.dart';
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
      home: const _Galleria(),
    );
  }
}

/// Le pagine della galleria, una per componente (o gruppo di componenti).
enum _Pagina { touchable, presenza }

class _Galleria extends StatefulWidget {
  const _Galleria();

  @override
  State<_Galleria> createState() => _GalleriaState();
}

class _GalleriaState extends State<_Galleria> {
  _Pagina _pagina = _Pagina.touchable;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BaColorTokens.fondoApp,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(BaSpazioTokens.l),
            child: Align(
              alignment: Alignment.centerLeft,
              // Menu: i comandi sono BaTouchable, come nel resto della galleria.
              child: Wrap(
                spacing: BaControlloTokens.gapCoppia,
                runSpacing: BaControlloTokens.gapCoppia,
                children: [
                  galleriaInterruttore(
                    'BaTouchable',
                    _pagina == _Pagina.touchable,
                    () => setState(() => _pagina = _Pagina.touchable),
                  ),
                  galleriaInterruttore(
                    'BaPresenza',
                    _pagina == _Pagina.presenza,
                    () => setState(() => _pagina = _Pagina.presenza),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: switch (_pagina) {
              _Pagina.touchable => const GalleriaTouchable(),
              _Pagina.presenza => const GalleriaPresenza(),
            },
          ),
        ],
      ),
    );
  }
}
