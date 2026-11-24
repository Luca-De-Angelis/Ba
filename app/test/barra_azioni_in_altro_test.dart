import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/barra_azioni.dart';
import 'package:ba/design_system/tokens.dart';

// `inAltro` di BaAzioneBarra (task 034): le azioni segnate vanno in «Altro» qualunque
// sia la loro posizione. I test della barra (`barra_azioni_test.dart`) non cambiano.

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(alignment: Alignment.topLeft, child: SizedBox(width: larghezza, child: child)),
        ),
      ),
    );

BaAzioneBarra _prim(String t) => BaAzioneBarra(ruolo: BaRuoloAzione.primaria, testo: t, semanticsLabel: t, onTap: () {});
BaAzioneBarra _sec(String t, {bool fissa = false, bool inAltro = false}) =>
    BaAzioneBarra(ruolo: BaRuoloAzione.secondaria, testo: t, semanticsLabel: t, onTap: () {}, fissa: fissa, inAltro: inAltro);

BaBarraAzioni _barra(List<BaAzioneBarra> a) => BaBarraAzioni(azioni: a, onAltro: () {}, semanticsLabelAltro: 'Altro');

/// L'ascoltatore del 015 e del 027: la primaria, «Esci» e «Altro» con due voci dentro.
List<BaAzioneBarra> _ascoltatore() => [
      _prim('Sali sul palco'),
      _sec('Esci', fissa: true),
      _sec('Impostazioni', inAltro: true),
      _sec('Persone bloccate', inAltro: true),
    ];

void main() {
  group('l\'ascoltatore: primaria, «Esci» e «Altro»', () {
    testWidgets('«Altro» compare e le due voci inAltro non sono pillole della barra', (tester) async {
      await tester.pumpWidget(_app(_barra(_ascoltatore())));
      expect(find.text('Sali sul palco'), findsOneWidget);
      expect(find.text('Esci'), findsOneWidget);
      expect(find.byKey(BaBarraAzioni.chiaveAltro), findsOneWidget);
      expect(find.text('Impostazioni'), findsNothing);
      expect(find.text('Persone bloccate'), findsNothing);
    });

    test('eccedenti dà le due voci, nell\'ordine in cui sono date', () {
      expect(BaBarraAzioni.eccedenti(_ascoltatore()).map((a) => a.testo), ['Impostazioni', 'Persone bloccate']);
    });

    testWidgets('«Esci» e «Altro» stanno sulla stessa riga, sotto la primaria', (tester) async {
      await tester.pumpWidget(_app(_barra(_ascoltatore())));
      final prim = tester.getRect(find.text('Sali sul palco'));
      final esci = tester.getRect(find.text('Esci'));
      final altro = tester.getRect(find.byKey(BaBarraAzioni.chiaveAltro));
      expect(esci.top, greaterThan(prim.bottom));
      expect(altro.left, greaterThan(esci.right));
      expect(altro.center.dy, closeTo(esci.center.dy, 1));
    });

    testWidgets('a testo 2,0 e a 744 nulla sborda', (tester) async {
      for (final larghezza in [360.0, 744.0]) {
        await tester.pumpWidget(_app(_barra(_ascoltatore()), testo: BaScalaTokens.maxTesto, larghezza: larghezza));
        expect(tester.takeException(), isNull);
        expect(tester.getRect(find.byKey(BaBarraAzioni.chiaveAltro)).right, lessThanOrEqualTo(larghezza));
      }
    });

    testWidgets('«Altro» chiama onAltro', (tester) async {
      var aperto = 0;
      await tester.pumpWidget(_app(BaBarraAzioni(azioni: _ascoltatore(), onAltro: () => aperto++, semanticsLabelAltro: 'Altro')));
      await tester.tap(find.byKey(BaBarraAzioni.chiaveAltro));
      expect(aperto, 1);
    });
  });

  group('la regola di prima non cambia', () {
    testWidgets('tre azioni senza inAltro: nessun «Altro»', (tester) async {
      await tester.pumpWidget(_app(_barra([_prim('Sali'), _sec('Esci', fissa: true), _sec('Scendi')])));
      expect(find.byKey(BaBarraAzioni.chiaveAltro), findsNothing);
    });

    test('dalla quarta azione: eccedenti è skip(3)', () {
      final a = [_prim('P'), _sec('A', fissa: true), _sec('B', fissa: true), _sec('C'), _sec('D')];
      expect(BaBarraAzioni.eccedenti(a).map((x) => x.testo), ['C', 'D']);
    });

    testWidgets('una azione inAltro con una sola altra: «Altro» c\'è', (tester) async {
      await tester.pumpWidget(_app(_barra([_prim('Sali'), _sec('Impostazioni', inAltro: true)])));
      expect(find.byKey(BaBarraAzioni.chiaveAltro), findsOneWidget);
      expect(find.text('Impostazioni'), findsNothing);
    });

    testWidgets('le pillole visibili hanno lo stesso aspetto con inAltro o con la quarta azione', (tester) async {
      final base = [_prim('Microfono'), _sec('Scendi dal palco', fissa: true), _sec('Esci', fissa: true)];
      await tester.pumpWidget(_app(_barra([...base, _sec('Impostazioni')])));
      final normale = [for (final t in ['Microfono', 'Scendi dal palco', 'Esci']) tester.getRect(find.text(t))];
      await tester.pumpWidget(_app(_barra([...base, _sec('Impostazioni', inAltro: true)])));
      final conParametro = [for (final t in ['Microfono', 'Scendi dal palco', 'Esci']) tester.getRect(find.text(t))];
      expect(conParametro, normale, reason: 'stesso testo, stessa altezza, stesse posizioni');
    });

    test('inAltro mescolato: le azioni segnate vanno in «Altro» e i posti li hanno le altre', () {
      final a = [_prim('P'), _sec('Esci', fissa: true), _sec('X'), _sec('Y', inAltro: true), _sec('Z')];
      expect(BaBarraAzioni.eccedenti(a).map((x) => x.testo), ['Y', 'Z']);
    });

    test('il default è falso', () {
      expect(_sec('A').inAltro, isFalse);
    });
  });

  group('la primaria e le azioni fisse non possono essere inAltro (assert in debug)', () {
    test('la primaria', () {
      expect(
        () => BaAzioneBarra(ruolo: BaRuoloAzione.primaria, testo: 'P', semanticsLabel: 'P', inAltro: true),
        throwsAssertionError,
      );
    });

    test('un\'azione fissa', () {
      expect(
        () => BaAzioneBarra(ruolo: BaRuoloAzione.secondaria, testo: 'Esci', semanticsLabel: 'Esci', fissa: true, inAltro: true),
        throwsAssertionError,
      );
    });

    test('una fissa che, tolte le inAltro, sta oltre i tre posti, finirebbe ancora in «Altro»', () {
      expect(
        () => BaBarraAzioni(azioni: [_prim('P'), _sec('Imp', inAltro: true), _sec('A'), _sec('B'), _sec('C', fissa: true)]),
        throwsAssertionError,
      );
    });
  });
}
