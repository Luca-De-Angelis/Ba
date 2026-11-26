import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/campo_testo.dart';
import 'package:ba/design_system/messaggio.dart';
import 'package:ba/design_system/segno_errore.dart';
import 'package:ba/design_system/tokens.dart';

// Il segno «!» è disegnato in un solo punto (task 035): BaFraseErrore e BaMessaggio lo condividono.

Widget _app(Widget child, {double testo = 1.0}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: const Size(360, 800), textScaler: TextScaler.linear(testo)),
        child: Align(alignment: Alignment.topLeft, child: SizedBox(width: 320, child: Align(alignment: Alignment.topLeft, child: child))),
      ),
    );

/// La decorazione del cerchio del segno.
BoxDecoration _cerchio(WidgetTester tester, Finder dentro) {
  final scatola = find.descendant(of: find.descendant(of: dentro, matching: find.byType(BaSegnoErrore)), matching: find.byType(DecoratedBox));
  return tester.widget<DecoratedBox>(scatola.first).decoration as BoxDecoration;
}

void main() {
  testWidgets('la frase d\'errore e il messaggio d\'errore usano lo stesso BaSegnoErrore, uno solo ciascuno', (tester) async {
    await tester.pumpWidget(_app(const Column(children: [
      BaFraseErrore(frase: 'Il codice non è giusto.'),
      BaMessaggio(testo: 'Qualcosa non è andato.', variante: BaVarianteMessaggio.errore),
    ])));
    final frase = find.byType(BaFraseErrore);
    final messaggio = find.byType(BaMessaggio);
    expect(find.descendant(of: frase, matching: find.byType(BaSegnoErrore)), findsOneWidget);
    expect(find.descendant(of: messaggio, matching: find.byType(BaSegnoErrore)), findsOneWidget);
    expect(find.byType(BaSegnoErrore), findsNWidgets(2));
    expect(_cerchio(tester, frase), _cerchio(tester, messaggio), reason: 'stesso cerchio: stesso aspetto');
  });

  testWidgets('il segno è un cerchio di erroreSegnoLato con il tratto e il colore dell\'errore, e un «!»', (tester) async {
    await tester.pumpWidget(_app(const BaSegnoErrore()));
    expect(tester.getSize(find.byType(BaSegnoErrore)), const Size.square(BaAccessoTokens.erroreSegnoLato));
    final deco = tester.widget<DecoratedBox>(find.descendant(of: find.byType(BaSegnoErrore), matching: find.byType(DecoratedBox)).first).decoration as BoxDecoration;
    expect(deco.shape, BoxShape.circle);
    final bordo = deco.border! as Border;
    expect(bordo.top.color, BaColorTokens.erroreTesto);
    expect(bordo.top.width, BaAccessoTokens.erroreSegnoTratto);
    final testo = tester.widget<Text>(find.text('!'));
    expect(testo.style!.color, BaColorTokens.erroreTesto);
    expect(testo.style!.fontSize, BaTestoTokens.azione.fontSize);
    expect(testo.style!.fontWeight, FontWeight.w600);
  });

  testWidgets('il segno non scala col testo: a 2,0 è grande come a 1,0', (tester) async {
    await tester.pumpWidget(_app(const BaSegnoErrore()));
    final a = tester.getSize(find.byType(BaSegnoErrore));
    final h = tester.getSize(find.text('!'));
    await tester.pumpWidget(_app(const BaSegnoErrore(), testo: 2.0));
    expect(tester.getSize(find.byType(BaSegnoErrore)), a);
    expect(tester.getSize(find.text('!')), h);
  });
}
