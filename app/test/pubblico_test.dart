import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/pubblico.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget child, {double testo = 1.0}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: const Size(360, 800), textScaler: TextScaler.linear(testo)),
        child: Align(alignment: Alignment.topCenter, child: SizedBox(width: 360, child: child)),
      ),
    );

Widget _pubblico(int n) => BaPubblico(
      conteggio: n,
      testo: '$n in ascolto',
      tinte: const [0, 1, 2],
      sagome: const [0, 1, 2],
    );

Finder _sagome() => find.descendant(
      of: find.byType(BaPubblico),
      matching: find.byWidgetPredicate((w) =>
          w is SizedBox &&
          w.width == BaPresenzaTokens.pubblico &&
          w.height == BaPresenzaTokens.pubblico),
    );

void main() {
  testWidgets('con 0 non disegna niente', (tester) async {
    await tester.pumpWidget(_app(_pubblico(0)));
    expect(_sagome(), findsNothing);
    expect(find.byType(Text), findsNothing);
    expect(tester.getSize(find.byType(BaPubblico)).height, 0);
  });

  for (final n in [1, 2, 3]) {
    testWidgets('con $n ci sono $n sagome e il contatore', (tester) async {
      await tester.pumpWidget(_app(_pubblico(n)));
      expect(_sagome(), findsNWidgets(n));
      expect(find.text('$n IN ASCOLTO'), findsOneWidget);
    });
  }

  testWidgets('con 14 si vedono tre sagome e il contatore', (tester) async {
    await tester.pumpWidget(_app(_pubblico(14)));
    expect(_sagome(), findsNWidgets(BaPresenzaTokens.campionePubblico));
    expect(find.text('14 IN ASCOLTO'), findsOneWidget);
  });

  testWidgets('sagome senza iniziali, di misura pubblico, con la forma del mazzo', (tester) async {
    await tester.pumpWidget(_app(_pubblico(3)));
    expect(find.byType(Text), findsOneWidget); // solo il contatore
    expect(tester.getSize(_sagome().first), const Size.square(BaPresenzaTokens.pubblico));
    final decorazioni = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(BaPubblico), matching: find.byType(DecoratedBox)))
        .map((d) => (d.decoration as BoxDecoration).borderRadius)
        .toList();
    expect(decorazioni, [
      for (var i = 0; i < 3; i++) BaSagomaTokens.bordo(i, BaPresenzaTokens.pubblico),
    ]);
  });

  testWidgets('la riga è alta almeno areaMinima', (tester) async {
    await tester.pumpWidget(_app(_pubblico(2)));
    expect(tester.getSize(find.byType(BaPubblico)).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
  });

  testWidgets('una sola etichetta di semantica, con il conteggio', (tester) async {
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(_app(_pubblico(14)));
    expect(tester.getSemantics(find.byType(BaPubblico)), matchesSemantics(label: '14 in ascolto'));
    semantica.dispose();
  });

  testWidgets('nessuna animazione: cambiare il conteggio cambia subito le sagome', (tester) async {
    await tester.pumpWidget(_app(_pubblico(1)));
    expect(tester.hasRunningAnimations, isFalse);
    await tester.pumpWidget(_app(_pubblico(3)));
    expect(_sagome(), findsNWidgets(3)); // nessun pump di durata: sono già lì
    expect(tester.hasRunningAnimations, isFalse);
    await tester.pumpWidget(_app(_pubblico(0)));
    expect(_sagome(), findsNothing);
  });

  testWidgets('a testo 2,0 il contatore va a capo senza overflow', (tester) async {
    await tester.pumpWidget(_app(_pubblico(14), testo: 2.0));
    expect(tester.takeException(), isNull);
    expect(_sagome(), findsNWidgets(3));
  });
}
