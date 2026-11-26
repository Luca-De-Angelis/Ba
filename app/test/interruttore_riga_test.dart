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
      expect(deco.color, BaCodaTokens.interruttoreFondoAcceso, reason: 'task 032: il fondo acceso è un colore piatto (prima un gradiente)');
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
    // Task 032c: prima a 2,0 l'interruttore restava a destra e il testo, stretto, spezzava
    // «automaticamente» a metà; ora, da 1,3, titolo e descrizione hanno tutta la larghezza e
    // l'interruttore sta sotto, a sinistra.
    testWidgets('a 2,0 titolo e descrizione a tutta larghezza e l\'interruttore sotto, a sinistra, senza overflow', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {})));
      final accanto = tester.getRect(_interruttore());
      expect(tester.getRect(find.text('Fammi entrare automaticamente')).right, lessThanOrEqualTo(accanto.left), reason: 'a 1,0 è com\'era: l\'interruttore a destra');
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {}), testo: 2.0));
      expect(tester.takeException(), isNull);
      final riga = tester.getRect(find.byType(BaInterruttoreRiga));
      final sw = tester.getRect(_interruttore());
      final titolo = tester.getRect(find.text('Fammi entrare automaticamente'));
      final descrizione = tester.getRect(find.text('Quando si libera un posto, entri tu.'));
      expect(sw.right, lessThanOrEqualTo(riga.right));
      expect(sw.top, greaterThanOrEqualTo(descrizione.bottom), reason: 'sotto la descrizione');
      expect(sw.left, lessThanOrEqualTo(titolo.left + 40), reason: 'a sinistra (la parola sotto lo centra)');
      expect(titolo.right, lessThanOrEqualTo(riga.right));
    });

    testWidgets('la soglia è azioneSottoDa: a 1,29 l\'interruttore sta ancora a destra', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {}), testo: 1.29));
      expect(tester.getRect(_interruttore()).left, greaterThan(tester.getRect(find.byType(BaInterruttoreRiga)).center.dx));
    });

    testWidgets('senza descrizione regge l\'altezza minima', (tester) async {
      await tester.pumpWidget(_app(_riga(descrizione: null, onCambia: (_) {})));
      expect(tester.getSize(find.byType(BaInterruttoreRiga)).height, greaterThanOrEqualTo(BaControlloTokens.primario));
    });
  });

  group('il fondo e il pallino (task 032)', () {
    testWidgets('acceso: il fondo è sabbia300 a16, un colore piatto, non il gradiente della pillola', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {})));
      final deco = _decorazione(tester);
      expect(deco.color, BaCodaTokens.interruttoreFondoAcceso);
      expect(deco.gradient, isNull);
      expect(deco.color, isNot(BaColorTokens.azioneAttivaFondo.first));
    });

    testWidgets('spento: nessun fondo e il pallino è a metà opacità', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: false, onCambia: (_) {})));
      expect(_decorazione(tester).color, isNull);
      final pallino = tester.widget<DecoratedBox>(find.ancestor(of: _pallino(), matching: find.byType(DecoratedBox)).first).decoration as BoxDecoration;
      expect(pallino.color!.a, closeTo(BaCodaTokens.interruttorePallinoSpentoOpacita, 0.01));
      expect(pallino.color!.toARGB32() & 0x00FFFFFF, BaColorTokens.testoPrimo.toARGB32() & 0x00FFFFFF);
    });

    testWidgets('acceso: il pallino è pieno, del colore dell\'azione', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {})));
      final pallino = tester.widget<DecoratedBox>(find.ancestor(of: _pallino(), matching: find.byType(DecoratedBox)).first).decoration as BoxDecoration;
      expect(pallino.color, BaColorTokens.azioneChiara);
    });
  });
}
