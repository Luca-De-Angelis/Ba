import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/interruttore_riga.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(alignment: Alignment.topCenter, child: SizedBox(width: larghezza, child: child)),
        ),
      ),
    );

Widget _riga({bool acceso = false, ValueChanged<bool>? onCambia, String? descrizione = 'Quando si libera un posto, entri tu.'}) =>
    BaInterruttoreRiga(
      titolo: 'Fammi entrare automaticamente',
      descrizione: descrizione,
      acceso: acceso,
      parolaAcceso: 'Acceso',
      parolaSpento: 'Spento',
      onCambia: onCambia,
    );

/// L'interruttore: il SizedBox 44 × 26 dei token.
Finder _interruttore() => find.byWidgetPredicate(
      (w) => w is SizedBox && w.width == BaCodaTokens.interruttoreLarghezza && w.height == BaCodaTokens.interruttoreAltezza,
    );

BoxDecoration _decorazione(WidgetTester tester) =>
    tester.widget<DecoratedBox>(find.descendant(of: _interruttore(), matching: find.byType(DecoratedBox)).first).decoration as BoxDecoration;

/// Il pallino: il quadrato di interruttorePallino.
Finder _pallino() => find.byWidgetPredicate(
      (w) => w is SizedBox && w.width == BaCodaTokens.interruttorePallino && w.height == BaCodaTokens.interruttorePallino,
    );

void main() {
  group('stati', () {
    testWidgets('spento: bordo sottile, pallino a sinistra, la parola «Spento»', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: false, onCambia: (_) {})));
      final deco = _decorazione(tester);
      expect((deco.border! as Border).top.width, BaCodaTokens.interruttoreBordo);
      expect(deco.gradient, isNull);
      final sw = tester.getRect(_interruttore());
      expect(tester.getRect(_pallino()).center.dx, lessThan(sw.center.dx));
      expect(find.text('SPENTO'), findsOneWidget);
      expect(find.text('ACCESO'), findsNothing);
    });

    testWidgets('acceso: bordo spesso, pallino a destra e la parola «Acceso» — non solo il colore', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {})));
      final deco = _decorazione(tester);
      expect((deco.border! as Border).top.width, BaCodaTokens.interruttoreBordoAcceso);
      expect(BaCodaTokens.interruttoreBordoAcceso, greaterThan(BaCodaTokens.interruttoreBordo));
      expect(deco.gradient, isNotNull);
      final sw = tester.getRect(_interruttore());
      expect(tester.getRect(_pallino()).center.dx, greaterThan(sw.center.dx));
      expect(find.text('ACCESO'), findsOneWidget);
    });

    testWidgets('l\'interruttore è 44 × 26 con il pallino da 16', (tester) async {
      await tester.pumpWidget(_app(_riga(onCambia: (_) {})));
      expect(tester.getSize(_interruttore()), const Size(44, 26));
      expect(tester.getSize(_pallino()), const Size(16, 16));
    });

    testWidgets('il cambio è immediato: nessuna animazione del pallino', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: false, onCambia: (_) {})));
      final prima = tester.getRect(_pallino()).center.dx;
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {})));
      expect(tester.getRect(_pallino()).center.dx, greaterThan(prima), reason: 'già dall\'altra parte, al primo frame');
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('tocco', () {
    testWidgets('tutta la riga è toccabile e chiama onCambia col valore nuovo', (tester) async {
      final valori = <bool>[];
      await tester.pumpWidget(_app(_riga(acceso: false, onCambia: valori.add)));
      // Tocco sul testo, lontano dall'interruttore.
      await tester.tap(find.text('Fammi entrare automaticamente'));
      expect(valori, [true]);
      await tester.tap(find.text('SPENTO'));
      expect(valori, [true, true]);
    });

    testWidgets('da acceso chiama con falso', (tester) async {
      final valori = <bool>[];
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: valori.add)));
      await tester.tap(find.text('Quando si libera un posto, entri tu.'));
      expect(valori, [false]);
    });

    testWidgets('senza onCambia è inattivo: il tocco non fa niente', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: false)));
      await tester.tap(find.text('Fammi entrare automaticamente'), warnIfMissed: false);
      expect(tester.takeException(), isNull);
    });

    testWidgets('area ≥ areaMinima, a 1,0 e a 2,0', (tester) async {
      for (final testo in [1.0, 2.0]) {
        await tester.pumpWidget(_app(_riga(onCambia: (_) {}), testo: testo));
        expect(tester.getSize(find.byType(BaInterruttoreRiga)).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima), reason: '$testo');
      }
    });
  });

  group('semantica', () {
    testWidgets('è un interruttore: etichetta, bottone, acceso', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {})));
      expect(
        tester.getSemantics(find.byType(BaInterruttoreRiga)),
        matchesSemantics(
          label: 'Fammi entrare automaticamente. Quando si libera un posto, entri tu.',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasToggledState: true,
          isToggled: true,
          hasTapAction: true,
        ),
      );
      semantica.dispose();
    });

    testWidgets('spento e inattivo: non abilitato', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_riga(acceso: false)));
      expect(
        tester.getSemantics(find.byType(BaInterruttoreRiga)),
        matchesSemantics(
          label: 'Fammi entrare automaticamente. Quando si libera un posto, entri tu.',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
          hasToggledState: true,
          isToggled: false,
        ),
      );
      semantica.dispose();
    });
  });

  group('testo grande', () {
    testWidgets('a 2,0 il testo va a capo e l\'interruttore resta a destra, senza overflow', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {})));
      final alto1 = tester.getRect(find.text('Fammi entrare automaticamente')).height;
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {}), testo: 2.0));
      expect(tester.takeException(), isNull);
      final riga = tester.getRect(find.byType(BaInterruttoreRiga));
      final sw = tester.getRect(_interruttore());
      expect(sw.right, lessThanOrEqualTo(riga.right));
      expect(sw.center.dx, greaterThan(riga.center.dx), reason: 'a destra');
      final titolo = tester.getRect(find.text('Fammi entrare automaticamente'));
      expect(titolo.right, lessThanOrEqualTo(sw.left), reason: 'il testo non finisce sotto l\'interruttore');
      expect(titolo.height, greaterThan(alto1 * 2), reason: 'a 2,0 il titolo va a capo: più alto del doppio di una riga a 1,0');
    });

    testWidgets('senza descrizione regge l\'altezza minima', (tester) async {
      await tester.pumpWidget(_app(_riga(descrizione: null, onCambia: (_) {})));
      expect(tester.getSize(find.byType(BaInterruttoreRiga)).height, greaterThanOrEqualTo(BaControlloTokens.primario));
    });
  });
}
