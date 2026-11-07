import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'design_system/tokens.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Solo verticale per ora (D-020). Il blocco è anche nella configurazione
  // nativa; il layout non deve dipenderne: i breakpoint usano la larghezza.
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const BaApp());
}

/// Radice dell'app: uno schermo vuoto del colore di fondo. Niente MaterialApp.
class BaApp extends StatelessWidget {
  const BaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: BaColor.fondoApp,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      home: const ColoredBox(color: BaColor.fondoApp),
    );
  }
}
