import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/marcatore.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Align(alignment: Alignment.topLeft, child: SizedBox(width: larghezza, child: child)),
      ),
    );

void main() {
  testWidgets('scrive il fatto in maiuscolo, in mono, con il tono di default', (tester) async {
    await tester.pumpWidget(_app(const BaMarcatore(testo: 'entra chiunque · 5 sul palco')));
    final t = tester.widget<Text>(find.byType(Text));
    expect(t.data, 'ENTRA CHIUNQUE · 5 SUL PALCO');
    expect(t.style?.fontFamily, BaTestoTokens.famigliaMono);
    expect(t.style?.color, BaColorTokens.testoTerzo);
  });

  testWidgets('il tono lo dà chi lo usa', (tester) async {
    await tester.pumpWidget(_app(const BaMarcatore(testo: 'linea persa', colore: BaColorTokens.testoInattivo)));
    expect(tester.widget<Text>(find.byType(Text)).style?.color, BaColorTokens.testoInattivo);
  });

  testWidgets('per lo screen reader si legge come l\'ha scritto il chiamante, non in maiuscolo', (tester) async {
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(_app(const BaMarcatore(testo: 'entra chiunque')));
    expect(find.bySemanticsLabel('entra chiunque'), findsOneWidget);
    semantica.dispose();
  });

  testWidgets('è un fatto fermo: nessuna animazione, nessun ticker, nessun timer', (tester) async {
    await tester.pumpWidget(_app(const BaMarcatore(testo: 'dalle 21:40')));
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pump(const Duration(minutes: 5));
    expect(tester.widget<Text>(find.byType(Text)).data, 'DALLE 21:40');
    expect(tester.takeException(), isNull);
  });

  testWidgets('a testo 2,0 cresce al massimo fino a maxMarcatore e va a capo senza tagliarsi', (tester) async {
    await tester.pumpWidget(_app(const BaMarcatore(testo: 'entra chiunque · 5 sul palco · 14 in ascolto'), testo: BaScalaTokens.maxTesto));
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(BaMarcatore)).width, lessThanOrEqualTo(360));
    expect(tester.widget<Text>(find.byType(Text)).textScaler, TextScaler.linear(BaScalaTokens.maxMarcatore));
  });
}
