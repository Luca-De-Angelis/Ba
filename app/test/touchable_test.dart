import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

/// Un'app minima: direzione del testo, MediaQuery e le scorciatoie di
/// WidgetsApp (Enter e spazio → ActivateIntent), come nell'app vera.
Widget _app(Widget child, {bool riduciMovimento = false}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(
          size: const Size(800, 600),
          disableAnimations: riduciMovimento,
        ),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Center(child: child),
        ),
      ),
    );

const _chiave = ValueKey('contenuto');

Widget _contenuto([double lato = 20]) =>
    SizedBox(key: _chiave, width: lato, height: lato);

/// Scala corrente del contenuto (la Transform dell'AnimatedScale).
double _scala(WidgetTester tester) {
  final t = tester.widget<Transform>(find.descendant(
    of: find.byType(BaTouchable),
    matching: find.byType(Transform),
  ));
  return t.transform.entry(0, 0); // scala sull'asse x (getMaxScaleOnAxis conta anche z, che vale 1)
}

Finder _velo() => find.descendant(
      of: find.byType(BaTouchable),
      matching: find.byWidgetPredicate((w) =>
          w is DecoratedBox &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).color == BaColorTokens.premutoVelo),
    );

Finder _anello() => find.descendant(
      of: find.byType(BaTouchable),
      matching: find.byWidgetPredicate((w) {
        if (w is! DecoratedBox || w.decoration is! BoxDecoration) return false;
        final bordo = (w.decoration as BoxDecoration).border;
        return bordo is Border &&
            bordo.top.width == BaControlloTokens.focusSpessore &&
            bordo.top.color == BaColorTokens.focusAnello;
      }),
    );

/// Il nodo di BaTouchable (non lo scope della vista) fra quelli focalizzabili.
Iterable<FocusNode> _nodi() => FocusManager.instance.rootScope.traversalDescendants
    .where((n) => n.debugLabel == 'BaTouchable');

FocusNode _nodoDelTouchable() => _nodi().first;

/// Dopo un cambio di focus il rebuild parte nel frame successivo.
Future<void> _dopoFocus(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

void main() {
  group('area toccabile', () {
    testWidgets('mai sotto 44 × 44 anche con un contenuto di 20 × 20', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(
        BaTouchable(semanticsLabel: 'prova', onTap: () => tocchi++, child: _contenuto()),
      ));
      expect(tester.getSize(find.byType(BaTouchable)), const Size(44, 44));
      final centro = tester.getCenter(find.byKey(_chiave));

      await tester.tapAt(centro + const Offset(20, 0));
      expect(tocchi, 1, reason: 'a 20 dp dal centro');
      await tester.tapAt(centro + const Offset(23, 0));
      expect(tocchi, 1, reason: 'a 23 dp dal centro: fuori');
    });

    testWidgets('con estensione di 8 la soglia sale di 8', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(
        BaTouchable(
          semanticsLabel: 'prova',
          onTap: () => tocchi++,
          estensione: BaTouchable.estesa,
          child: _contenuto(),
        ),
      ));
      final centro = tester.getCenter(find.byKey(_chiave));

      await tester.tapAt(centro + const Offset(28, 0));
      expect(tocchi, 1, reason: 'a 28 dp: dentro');
      await tester.tapAt(centro + const Offset(31, 0));
      expect(tocchi, 1, reason: 'a 31 dp: fuori');
    });

    testWidgets('l\'estensione non sposta il layout', (tester) async {
      await tester.pumpWidget(_app(
        BaTouchable(semanticsLabel: 'a', onTap: () {}, child: _contenuto()),
      ));
      final senza = tester.getRect(find.byType(BaTouchable));
      await tester.pumpWidget(_app(
        BaTouchable(
          semanticsLabel: 'a',
          onTap: () {},
          estensione: BaTouchable.estesa,
          child: _contenuto(),
        ),
      ));
      expect(tester.getRect(find.byType(BaTouchable)), senza);
    });

    testWidgets('coppia con gap 10: mezzo gap a testa, nessuna sovrapposizione', (tester) async {
      final tocchi = <String>[];
      const mezzoGap = BaControlloTokens.gapCoppia / 2;
      await tester.pumpWidget(_app(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BaTouchable(
              semanticsLabel: 'sinistra',
              onTap: () => tocchi.add('sinistra'),
              estensione: const EdgeInsets.only(right: mezzoGap),
              child: const SizedBox(width: 100, height: BaControlloTokens.coppia),
            ),
            const SizedBox(width: BaControlloTokens.gapCoppia),
            BaTouchable(
              semanticsLabel: 'destra',
              onTap: () => tocchi.add('destra'),
              estensione: const EdgeInsets.only(left: mezzoGap),
              child: const SizedBox(width: 100, height: BaControlloTokens.coppia),
            ),
          ],
        ),
      ));
      final sinistra = tester.getRect(find.bySemanticsLabel('sinistra'));
      final y = sinistra.center.dy;

      await tester.tapAt(Offset(sinistra.right + 3, y));
      await tester.tapAt(Offset(sinistra.right + 7, y));
      expect(tocchi, ['sinistra', 'destra']);
    });
  });

  group('premuto, variante standard', () {
    testWidgets('scala 0,98 dopo 90 ms, di nuovo 1 dopo il rilascio e 140 ms; fondo premutoVelo', (tester) async {
      await tester.pumpWidget(_app(
        BaTouchable(semanticsLabel: 'p', onTap: () {}, child: _contenuto(100)),
      ));
      expect(_scala(tester), 1);

      final gesto = await tester.startGesture(tester.getCenter(find.byKey(_chiave)));
      await tester.pump();
      await tester.pump(BaMovimentoTokens.premutoAndata);
      expect(_scala(tester), closeTo(BaControlloTokens.premutoScala, 1e-6));
      expect(_velo(), findsOneWidget);

      await gesto.up();
      await tester.pump();
      await tester.pump(BaMovimentoTokens.premutoRitorno);
      expect(_scala(tester), closeTo(1, 1e-6));
    });

    testWidgets('un secondo BaTouchable accanto non cambia posizione', (tester) async {
      await tester.pumpWidget(_app(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BaTouchable(semanticsLabel: 'a', onTap: () {}, child: _contenuto(100)),
            BaTouchable(semanticsLabel: 'b', onTap: () {}, child: _contenuto(100)),
          ],
        ),
      ));
      final accanto = find.bySemanticsLabel('b');
      final prima = tester.getTopLeft(accanto);

      final gesto = await tester.startGesture(tester.getCenter(find.bySemanticsLabel('a')));
      await tester.pump();
      await tester.pump(BaMovimentoTokens.premutoAndata);
      expect(tester.getTopLeft(accanto), prima);
      await gesto.up();
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(accanto), prima);
    });

    testWidgets('con riduci movimento: scala sempre 1, fondo presente', (tester) async {
      await tester.pumpWidget(_app(
        BaTouchable(semanticsLabel: 'p', onTap: () {}, child: _contenuto(100)),
        riduciMovimento: true,
      ));
      final gesto = await tester.startGesture(tester.getCenter(find.byKey(_chiave)));
      await tester.pump();
      await tester.pump(BaMovimentoTokens.premutoAndata);
      expect(_scala(tester), 1);
      expect(_velo(), findsOneWidget);
      await gesto.up();
    });
  });

  group('variante suPresenza', () {
    testWidgets('nessuna scala e nessun velo; il builder vede premuto', (tester) async {
      BaStatoTocco? visto;
      await tester.pumpWidget(_app(
        BaTouchable(
          semanticsLabel: 'presenza',
          onTap: () {},
          variante: BaVarianteTocco.suPresenza,
          builder: (context, stato) {
            visto = stato;
            return _contenuto(88);
          },
        ),
      ));
      expect(visto!.premuto, isFalse);

      final gesto = await tester.startGesture(tester.getCenter(find.byKey(_chiave)));
      await tester.pump();
      await tester.pump(BaMovimentoTokens.premutoAndata);
      expect(visto!.premuto, isTrue);
      expect(find.descendant(of: find.byType(BaTouchable), matching: find.byType(Transform)), findsNothing);
      expect(_velo(), findsNothing);

      await gesto.up();
      await tester.pump();
      expect(visto!.premuto, isFalse);
    });
  });

  group('focus', () {
    testWidgets('requestFocus programmatico: anello subito, anche con il tocco come ultima interazione', (tester) async {
      FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTouch;
      addTearDown(() => FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic);
      await tester.pumpWidget(_app(
        BaTouchable(semanticsLabel: 'f', onTap: () {}, child: _contenuto(100)),
      ));
      expect(_anello(), findsNothing);

      _nodoDelTouchable().requestFocus();
      await _dopoFocus(tester);
      expect(_anello(), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse, reason: 'l\'anello non si anima');

      _nodoDelTouchable().unfocus();
      await _dopoFocus(tester);
      expect(_anello(), findsNothing);
    });

    testWidgets('l\'anello è fuori dal contenuto: il layout non cambia', (tester) async {
      await tester.pumpWidget(_app(
        BaTouchable(semanticsLabel: 'f', onTap: () {}, child: _contenuto(100)),
      ));
      final prima = tester.getRect(find.byType(BaTouchable));
      _nodoDelTouchable().requestFocus();
      await _dopoFocus(tester);
      expect(tester.getRect(find.byType(BaTouchable)), prima);
      final anello = tester.getRect(_anello());
      const fuori = BaControlloTokens.focusStacco + BaControlloTokens.focusSpessore;
      expect(anello, tester.getRect(find.byKey(_chiave)).inflate(fuori));
    });

    testWidgets('un tocco non dà il focus e non disegna l\'anello', (tester) async {
      await tester.pumpWidget(_app(
        BaTouchable(semanticsLabel: 'f', onTap: () {}, child: _contenuto(100)),
      ));
      await tester.tap(find.byKey(_chiave));
      await tester.pump();
      expect(_anello(), findsNothing);
      expect(_nodoDelTouchable().hasFocus, isFalse);
    });

    testWidgets('con suChiara l\'anello prende il colore scuro', (tester) async {
      await tester.pumpWidget(_app(
        BaTouchable(semanticsLabel: 'f', onTap: () {}, suChiara: true, child: _contenuto(100)),
      ));
      _nodoDelTouchable().requestFocus();
      await _dopoFocus(tester);
      final anello = find.descendant(
        of: find.byType(BaTouchable),
        matching: find.byWidgetPredicate((w) =>
            w is DecoratedBox &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).border is Border &&
            ((w.decoration as BoxDecoration).border as Border).top.color ==
                BaColorTokens.focusAnelloSuChiara),
      );
      expect(anello, findsOneWidget);
    });
  });

  group('inattivo', () {
    testWidgets('il tocco non fa niente, non prende focus, enabled falso', (tester) async {
      final semantica = tester.ensureSemantics();
      BaStatoTocco? visto;
      await tester.pumpWidget(_app(
        BaTouchable(
          semanticsLabel: 'spento',
          builder: (context, stato) {
            visto = stato;
            return _contenuto(100);
          },
        ),
      ));
      expect(visto!.inattivo, isTrue);

      final gesto = await tester.startGesture(tester.getCenter(find.byKey(_chiave)));
      await tester.pump();
      await tester.pump(BaMovimentoTokens.premutoAndata);
      expect(visto!.premuto, isFalse);
      expect(find.descendant(of: find.byType(BaTouchable), matching: find.byType(Transform)), findsOneWidget);
      expect(_scala(tester), 1);
      await gesto.up();

      expect(_nodi(), isEmpty);
      expect(
        tester.getSemantics(find.byType(BaTouchable)),
        matchesSemantics(label: 'spento', isButton: true, hasEnabledState: true, isEnabled: false),
      );
      semantica.dispose();
    });
  });

  group('semantica e tastiera', () {
    testWidgets('etichetta, flag button e azione di tocco', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(
        BaTouchable(semanticsLabel: 'Esci', onTap: () {}, child: _contenuto(100)),
      ));
      expect(
        tester.getSemantics(find.byType(BaTouchable)),
        matchesSemantics(
          label: 'Esci',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
        ),
      );
      semantica.dispose();
    });

    testWidgets('Enter e spazio attivano onTap', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(
        BaTouchable(semanticsLabel: 'x', onTap: () => tocchi++, child: _contenuto(100)),
      ));
      _nodoDelTouchable().requestFocus();
      await _dopoFocus(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(tocchi, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(tocchi, 2);
    });
  });

  group('parametri', () {
    test('uno solo fra child e builder', () {
      expect(() => BaTouchable(semanticsLabel: 'x', onTap: () {}), throwsAssertionError);
      expect(
        () => BaTouchable(
          semanticsLabel: 'x',
          onTap: () {},
          child: const SizedBox(),
          builder: (c, s) => const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    test('BaTouchable.estesa dà areaEstesa su ogni lato', () {
      expect(BaTouchable.estesa, const EdgeInsets.all(BaControlloTokens.areaEstesa));
      expect(BaTouchable.estesa.left, 8);
    });
  });

  group('bordo', () {
    testWidgets('l\'anello di focus e il velo seguono gli angoli ellittici di bordo', (tester) async {
      final bordo = BaSagomaTokens.bordo(0, 100);
      await tester.pumpWidget(_app(
        BaTouchable(
          semanticsLabel: 'b',
          onTap: () {},
          bordo: bordo,
          raggio: 3, // ignorato: bordo ha la precedenza
          child: _contenuto(100),
        ),
      ));
      // Il velo (a riposo trasparente) ha gli angoli di bordo.
      expect(
        find.descendant(
          of: find.byType(BaTouchable),
          matching: find.byWidgetPredicate((w) =>
              w is DecoratedBox &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).borderRadius == bordo),
        ),
        findsOneWidget,
      );

      _nodoDelTouchable().requestFocus();
      await _dopoFocus(tester);
      const fuori = BaControlloTokens.focusStacco + BaControlloTokens.focusSpessore;
      final anello = tester.widget<DecoratedBox>(_anello());
      final r = (anello.decoration as BoxDecoration).borderRadius! as BorderRadius;
      expect(r.topLeft, Radius.elliptical(bordo.topLeft.x + fuori, bordo.topLeft.y + fuori));
      expect(r.bottomRight, Radius.elliptical(bordo.bottomRight.x + fuori, bordo.bottomRight.y + fuori));
      expect(r.topLeft.x, isNot(r.topLeft.y), reason: 'gli angoli restano ellittici');
    });
  });
}
