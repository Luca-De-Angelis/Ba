import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/tokens.dart';
import 'package:ba/l10n/app_localizations.dart';
import 'package:ba/main.dart';

void main() {
  testWidgets('l\'app si avvia con lo schermo vuoto del colore di fondo',
      (tester) async {
    await tester.pumpWidget(const BaApp());
    await tester.pump();

    expect(find.byType(WidgetsApp), findsOneWidget);
    final fondo = tester.widget<ColoredBox>(find.byType(ColoredBox).first);
    expect(fondo.color, BaColorTokens.fondoApp);
  });

  testWidgets('la chiave di prova esiste nelle cinque lingue', (tester) async {
    const lingue = ['it', 'en', 'fr', 'es', 'de'];
    expect(
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
      lingue.toSet(),
    );
    for (final codice in lingue) {
      final l = await AppLocalizations.delegate.load(Locale(codice));
      expect(l.appNome, isNotEmpty, reason: codice);
    }
  });
}
