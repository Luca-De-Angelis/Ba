import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/riga_impostazione.dart';
import 'package:ba/design_system/tokens.dart';

// `BaRigaImpostazione.stato` (task 034): la riga di stato della disponibilità. A testo normale
// l'azione sta a destra, sulla stessa riga del titolo; da `azioneSottoDa` (1,3) sotto la frase, a
// sinistra. Il file è nuovo: `riga_impostazione_test.dart` (e `.negata`) non cambiano.
//
// Import oltre widgets.dart (solo in questo test): `package:flutter/services.dart`, per `FontLoader`
// e `rootBundle` (come `misure_font_vero_test.dart`); nessun import nuovo in `lib/`.

const _titolo = 'Sei disponibile a chiacchierare';
const _frase = 'Compari fra le persone da invitare.';

Future<void> _caricaFont() async {
  for (final nome in ['Regular', 'Medium', 'SemiBold']) {
    final f = FontLoader('Instrument Sans')..addFont(rootBundle.load('assets/fonts/instrument-sans/InstrumentSans-$nome.ttf'));
    await f.load();
  }
}

Widget _app({double testo = 1.0, double larghezza = 360, VoidCallback? onAzione}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: larghezza - 2 * BaLayoutTokens.margine(larghezza),
            child: BaRigaImpostazione.stato(titolo: _titolo, frase: _frase, azione: 'Spegni', onAzione: onAzione ?? () {}),
          ),
        ),
      ),
    );

void main() {
  setUpAll(_caricaFont);

  testWidgets('a testo 1,0 l\'azione sta a destra e sulla stessa riga del titolo', (tester) async {
    await tester.pumpWidget(_app());
    final titolo = tester.getRect(find.text(_titolo));
    final frase = tester.getRect(find.text(_frase));
    final azione = tester.getRect(find.widgetWithText(BaPillola, 'Spegni'));
    expect(azione.left, greaterThanOrEqualTo(titolo.right), reason: 'a destra del testo');
    expect(azione.center.dy, greaterThan(titolo.top));
    expect(azione.top, lessThan(titolo.bottom), reason: 'sulla riga del titolo');
    expect(azione.right, lessThanOrEqualTo(360 - BaLayoutTokens.margine(360) + 0.01), reason: 'al bordo destro della colonna');
    expect(frase.top, greaterThanOrEqualTo(titolo.bottom));
    expect(azione.height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
    expect(tester.widget<BaPillola>(find.widgetWithText(BaPillola, 'Spegni')).variante, BaVariantePillola.spenta);
  });

  for (final testo in [1.3, 1.4, BaScalaTokens.maxTesto]) {
    testWidgets('a testo $testo l\'azione sta sotto la frase, a sinistra', (tester) async {
      await tester.pumpWidget(_app(testo: testo));
      final titolo = tester.getRect(find.text(_titolo));
      final frase = tester.getRect(find.text(_frase));
      final azione = tester.getRect(find.widgetWithText(BaPillola, 'Spegni'));
      expect(azione.top, greaterThanOrEqualTo(frase.bottom), reason: 'sotto la frase');
      expect(azione.left, titolo.left, reason: 'a sinistra, allineata al testo');
      expect(azione.height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
    });
  }

  testWidgets('a 1,29 l\'azione sta ancora a destra: la soglia è azioneSottoDa', (tester) async {
    await tester.pumpWidget(_app(testo: BaPersoneTokens.azioneSottoDa - 0.01));
    expect(tester.getRect(find.widgetWithText(BaPillola, 'Spegni')).left, greaterThan(tester.getRect(find.text(_frase)).left + 50));
    expect(tester.getRect(find.widgetWithText(BaPillola, 'Spegni')).top, lessThan(tester.getRect(find.text(_frase)).bottom));
  });

  testWidgets('a 360 dp con il font vero nessuna parola si spezza, a 1,0 e a 2,0', (tester) async {
    for (final testo in [1.0, BaScalaTokens.maxTesto]) {
      await tester.pumpWidget(_app(testo: testo));
      expect(tester.takeException(), isNull);
      for (final t in tester.widgetList<Text>(find.byType(Text)).where((t) => t.data == _titolo || t.data == _frase)) {
        final larghezza = tester.getSize(find.byWidget(t)).width;
        for (final parola in t.data!.split(' ')) {
          final p = TextPainter(text: TextSpan(text: parola, style: t.style), textDirection: TextDirection.ltr, textScaler: TextScaler.linear(testo))..layout();
          expect(p.width, lessThanOrEqualTo(larghezza + 0.01), reason: '«$parola» a $testo');
          p.dispose();
        }
      }
    }
  });

  testWidgets('la semantica legge titolo e frase, l\'azione è un pulsante, mai «negat…»', (tester) async {
    final semantica = tester.ensureSemantics();
    var tocchi = 0;
    await tester.pumpWidget(_app(onAzione: () => tocchi++));
    expect(find.bySemanticsLabel('$_titolo. $_frase'), findsOneWidget);
    expect(find.bySemanticsLabel('Spegni'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('negat', caseSensitive: false)), findsNothing);
    await tester.tap(find.text('Spegni'));
    expect(tocchi, 1);
    semantica.dispose();
  });

  testWidgets('senza onAzione l\'azione è inattiva', (tester) async {
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(360, 800)),
        child: BaRigaImpostazione.stato(titolo: _titolo, frase: _frase, azione: 'Spegni'),
      ),
    ));
    expect(tester.widget<BaPillola>(find.widgetWithText(BaPillola, 'Spegni')).onTap, isNull);
  });
}
