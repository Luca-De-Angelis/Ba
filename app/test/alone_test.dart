import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/alone.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget alone) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(360, 800)),
        child: Align(alignment: Alignment.topLeft, child: SizedBox(width: 360, height: 600, child: Stack(children: [Positioned.fill(child: alone)]))),
      ),
    );

BoxDecoration? _decorazione(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: find.byType(BaAlone), matching: find.byType(DecoratedBox)))
    .map((d) => d.decoration)
    .whereType<BoxDecoration>()
    .where((d) => d.gradient != null)
    .firstOrNull;

void main() {
  testWidgets('acceso: un gradiente radiale da fondoAlone a trasparente che riempie il genitore', (tester) async {
    await tester.pumpWidget(_app(const BaAlone()));
    final g = _decorazione(tester)!.gradient! as RadialGradient;
    expect(g.colors.first, BaColorTokens.fondoAlone);
    expect(g.colors.last.a, 0);
    expect(g.center, const Alignment(0, 2 * 0.42 - 1), reason: 'al 42 % dell\'altezza');
    expect(tester.getSize(find.byType(BaAlone)), const Size(360, 600));
  });

  testWidgets('spento: non disegna niente', (tester) async {
    await tester.pumpWidget(_app(const BaAlone(acceso: false)));
    expect(_decorazione(tester), isNull);
  });

  testWidgets('non riceve tocchi e non è nella semantica', (tester) async {
    final semantica = tester.ensureSemantics();
    var tocchi = 0;
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(360, 800)),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 360,
            height: 600,
            child: Stack(children: [
              GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => tocchi++, child: const SizedBox.expand()),
              const Positioned.fill(child: BaAlone()),
            ]),
          ),
        ),
      ),
    ));
    await tester.tapAt(const Offset(180, 250));
    expect(tocchi, 1, reason: 'l\'alone sta sopra ma non assorbe il tocco');
    expect(find.descendant(of: find.byType(BaAlone), matching: find.byType(Semantics)).evaluate().where((e) => (e.widget as Semantics).properties.label != null), isEmpty);
    semantica.dispose();
  });

  testWidgets('nessuna animazione: lo sfondo non pulsa', (tester) async {
    await tester.pumpWidget(_app(const BaAlone()));
    expect(tester.binding.transientCallbackCount, 0);
  });
}
