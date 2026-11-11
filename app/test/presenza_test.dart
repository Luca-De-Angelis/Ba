import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/presenza.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

const double _banda = BaPresenzaTokens.anelloKeyline + BaPresenzaTokens.anelloTratto;

Widget _app(Widget child, {double d = 88, bool riduciMovimento = false}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: const Size(800, 600), disableAnimations: riduciMovimento),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Center(child: BaDiametro(diametro: d, child: child)),
        ),
      ),
    );

BaPresenza _presenza({
  int tinta = 0,
  int sagoma = 0,
  bool parla = false,
  double ampiezza = 0,
  bool persa = false,
  bool scheletro = false,
  VoidCallback? onTap,
  String? iniziali = 'MB',
}) =>
    BaPresenza(
      semanticsLabel: 'Marta B.',
      semanticsLabelParla: 'Marta B., sta parlando',
      indiceTinta: tinta,
      indiceSagoma: sagoma,
      iniziali: iniziali,
      parla: parla,
      ampiezza: ampiezza,
      persa: persa,
      scheletro: scheletro,
      onTap: onTap ?? () {},
    );

/// La sagoma colorata: l'unica DecoratedBox con un gradiente.
Finder _sagoma() => find.byWidgetPredicate(
      (w) => w is DecoratedBox && (w.decoration as BoxDecoration).gradient != null,
    );

Finder _bordoDi(Color colore, double spessore) => find.byWidgetPredicate((w) {
      if (w is! DecoratedBox || w.decoration is! BoxDecoration) return false;
      final b = (w.decoration as BoxDecoration).border;
      return b is Border && b.top.color == colore && b.top.width == spessore;
    });

Iterable<FocusNode> _nodi() => FocusManager.instance.rootScope.traversalDescendants
    .where((n) => n.debugLabel == 'BaTouchable');

Future<void> _dopoFocus(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

void main() {
  group('diametro, sagoma e tinta', () {
    testWidgets('il diametro viene da BaDiametro', (tester) async {
      for (final d in [88.0, 130.0, 208.0]) {
        await tester.pumpWidget(_app(_presenza(), d: d));
        expect(tester.getSize(_sagoma()), Size(d, d), reason: 'd = $d');
        expect(tester.getSize(find.byType(BaPresenza)), Size(d + 2 * _banda, d + 2 * _banda));
      }
    });

    testWidgets('senza BaDiametro è un errore in debug', (tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(800, 600)),
          child: _presenza(),
        ),
      ));
      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('sagoma e tinta secondo gli indici', (tester) async {
      for (final (tinta, sagoma) in [(0, 0), (4, 2), (11, 4)]) {
        await tester.pumpWidget(_app(_presenza(tinta: tinta, sagoma: sagoma)));
        final deco = tester.widget<DecoratedBox>(_sagoma()).decoration as BoxDecoration;
        expect(deco.borderRadius, BaSagomaTokens.bordo(sagoma, 88));
        expect(deco.gradient, BaTintaTokens.mazzo[tinta].gradiente);
      }
    });

    testWidgets('le iniziali stanno sulla sagoma con la taglia del diametro', (tester) async {
      await tester.pumpWidget(_app(_presenza(), d: 130));
      expect(tester.widget<Text>(find.text('MB')).style!.fontSize, 38);
    });
  });

  group('semantica', () {
    testWidgets('«nome» a riposo, «nome, sta parlando» quando parla', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_presenza()));
      expect(find.bySemanticsLabel('Marta B.'), findsOneWidget);
      expect(find.bySemanticsLabel('Marta B., sta parlando'), findsNothing);
      expect(
        tester.getSemantics(find.byType(BaTouchable)),
        matchesSemantics(
          label: 'Marta B.',
          isButton: true,
          isEnabled: true,
          isFocusable: true,
          hasEnabledState: true,
          hasTapAction: true,
        ),
      );

      await tester.pumpWidget(_app(_presenza(parla: true)));
      expect(find.bySemanticsLabel('Marta B., sta parlando'), findsOneWidget);
      expect(find.bySemanticsLabel('MB'), findsNothing, reason: 'le iniziali non sono accessibili');
      semantica.dispose();
    });
  });

  group('persa', () {
    testWidgets('scala di grigi e opacità 0,34, nessun anello', (tester) async {
      await tester.pumpWidget(_app(_presenza(parla: true, ampiezza: 1, persa: true)));
      final opacita = tester.widget<Opacity>(find.ancestor(
        of: find.byType(ColorFiltered),
        matching: find.byType(Opacity),
      ));
      expect(opacita.opacity, 0.34);
      expect(find.byType(ColorFiltered), findsOneWidget);
      expect(find.byType(ScaleTransition), findsNothing, reason: 'nessun anello');
    });

    testWidgets('senza persa non c\'è filtro', (tester) async {
      await tester.pumpWidget(_app(_presenza()));
      expect(find.byType(ColorFiltered), findsNothing);
    });
  });

  group('scheletro', () {
    testWidgets('senza iniziali, opacità fra 0,30 e 0,62, non si tocca', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(_presenza(scheletro: true, onTap: () => tocchi++)));
      expect(find.text('MB'), findsNothing);
      for (var i = 0; i < 6; i++) {
        final o = tester.widget<FadeTransition>(find.ancestor(
          of: _sagoma(),
          matching: find.byType(FadeTransition),
        )).opacity.value;
        expect(o, inInclusiveRange(BaPresenzaTokens.scheletroOpacitaMin, BaPresenzaTokens.scheletroOpacitaMax));
        await tester.pump(const Duration(milliseconds: 300));
      }
      await tester.tap(find.byType(BaPresenza));
      expect(tocchi, 0);
    });

    testWidgets('respira: un ciclo completo in 1,8 s', (tester) async {
      await tester.pumpWidget(_app(_presenza(scheletro: true)));
      double o() => tester.widget<FadeTransition>(find.ancestor(
            of: _sagoma(),
            matching: find.byType(FadeTransition),
          )).opacity.value;
      await tester.pump();
      expect(o(), closeTo(BaPresenzaTokens.scheletroOpacitaMin, 0.01));
      await tester.pump(BaMovimentoTokens.skeleton ~/ 2);
      expect(o(), closeTo(BaPresenzaTokens.scheletroOpacitaMax, 0.01));
      await tester.pump(BaMovimentoTokens.skeleton ~/ 2);
      expect(o(), closeTo(BaPresenzaTokens.scheletroOpacitaMin, 0.01));
    });

    testWidgets('riduci movimento: fermo al valore più alto', (tester) async {
      await tester.pumpWidget(_app(_presenza(scheletro: true), riduciMovimento: true));
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
      final o = tester.widget<FadeTransition>(find.ancestor(
        of: _sagoma(),
        matching: find.byType(FadeTransition),
      )).opacity.value;
      expect(o, BaPresenzaTokens.scheletroOpacitaMax);
    });

    testWidgets('semantica: non attiva', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_presenza(scheletro: true)));
      expect(
        tester.getSemantics(find.byType(BaTouchable)),
        matchesSemantics(
          label: 'Marta B.',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      semantica.dispose();
    });
  });

  group('premuta', () {
    testWidgets('keyline premutoKeyline, nessuna scala, layout fermo', (tester) async {
      await tester.pumpWidget(_app(_presenza(onTap: () {})));
      final prima = tester.getSize(find.byType(BaPresenza));
      expect(_bordoDi(BaColorTokens.premutoKeyline, BaPresenzaTokens.anelloKeyline), findsNothing);

      final dito = await tester.startGesture(tester.getCenter(find.byType(BaPresenza)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(_bordoDi(BaColorTokens.premutoKeyline, BaPresenzaTokens.anelloKeyline), findsOneWidget);
      expect(
        find.descendant(of: find.byType(BaTouchable), matching: find.byType(Transform)),
        findsNothing,
        reason: 'nessuna scala sulle presenze',
      );
      expect(tester.getSize(find.byType(BaPresenza)), prima);

      await dito.up();
      await tester.pump();
      expect(_bordoDi(BaColorTokens.premutoKeyline, BaPresenzaTokens.anelloKeyline), findsNothing);
    });

    testWidgets('mentre parla è la keyline dell\'anello a scurirsi', (tester) async {
      await tester.pumpWidget(_app(_presenza(parla: true)));
      expect(_bordoDi(BaColorTokens.voceKeyline, BaPresenzaTokens.anelloKeyline), findsOneWidget);
      final dito = await tester.startGesture(tester.getCenter(find.byType(BaPresenza)));
      await tester.pump();
      expect(_bordoDi(BaColorTokens.premutoKeyline, BaPresenzaTokens.anelloKeyline), findsOneWidget);
      expect(_bordoDi(BaColorTokens.voceKeyline, BaPresenzaTokens.anelloKeyline), findsNothing);
      await dito.up();
    });
  });

  group('a fuoco', () {
    testWidgets('l\'anello di focus sta fuori dall\'anello della voce', (tester) async {
      await tester.pumpWidget(_app(_presenza(parla: true)));
      _nodi().first.requestFocus();
      await _dopoFocus(tester);
      final focus = _bordoDi(BaColorTokens.focusAnello, BaControlloTokens.focusSpessore);
      expect(focus, findsOneWidget);
      final sagoma = tester.getRect(_sagoma());
      const fuori = BaControlloTokens.focusStacco + BaControlloTokens.focusSpessore;
      // 5 di banda dell'anello a riposo + 3 di stacco + 2 di tratto = 10.
      expect(tester.getRect(focus), sagoma.inflate(_banda + fuori));
      expect(sagoma.inflate(_banda + fuori).width, sagoma.width + 20);
    });

    testWidgets('l\'anello di focus segue gli angoli della sagoma', (tester) async {
      await tester.pumpWidget(_app(_presenza(sagoma: 3)));
      _nodi().first.requestFocus();
      await _dopoFocus(tester);
      final focus = tester.widget<DecoratedBox>(
        _bordoDi(BaColorTokens.focusAnello, BaControlloTokens.focusSpessore),
      );
      final r = (focus.decoration as BoxDecoration).borderRadius! as BorderRadius;
      final s = BaSagomaTokens.bordo(3, 88);
      const fuori = _banda + BaControlloTokens.focusStacco + BaControlloTokens.focusSpessore;
      expect(r.topLeft, Radius.elliptical(s.topLeft.x + fuori, s.topLeft.y + fuori));
      expect(r.topLeft.x, isNot(r.topLeft.y));
    });
  });

  group('tocco', () {
    testWidgets('area di almeno 44 anche a 88, e onTap parte', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(_presenza(onTap: () => tocchi++)));
      expect(tester.getSize(find.byType(BaPresenza)).width, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
      final centro = tester.getCenter(find.byType(BaPresenza));
      await tester.tapAt(centro);
      await tester.tapAt(centro + const Offset(BaControlloTokens.areaMinima / 2 - 1, 0));
      await tester.tapAt(centro + const Offset(0, BaControlloTokens.areaMinima / 2 - 1));
      expect(tocchi, 3);
    });

    testWidgets('un tocco non dà il focus', (tester) async {
      await tester.pumpWidget(_app(_presenza(onTap: () {})));
      await tester.tap(find.byType(BaPresenza));
      await _dopoFocus(tester);
      expect(_bordoDi(BaColorTokens.focusAnello, BaControlloTokens.focusSpessore), findsNothing);
    });
  });
}
