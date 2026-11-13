import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/azioni_in_coppia.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

Widget _app(Widget child, {double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800)),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: larghezza, child: child),
        ),
      ),
    );

void main() {
  testWidgets('due pillole distano gapCoppia (10)', (tester) async {
    await tester.pumpWidget(_app(BaAzioniInCoppia(
      prima: BaAzioneCoppia(testo: 'A', semanticsLabel: 'a', onTap: () {}),
      seconda: BaAzioneCoppia(testo: 'B', semanticsLabel: 'b', onTap: () {}),
    )));
    final a = tester.getRect(find.byType(BaPillola).first);
    final b = tester.getRect(find.byType(BaPillola).last);
    expect(b.left - a.right, BaControlloTokens.gapCoppia);
    expect(BaControlloTokens.gapCoppia, 10);
    expect(a.width, b.width);
    expect(a.height, greaterThanOrEqualTo(BaControlloTokens.coppia));
  });

  testWidgets('le aree si toccano e non si sovrappongono: 3 dp a sinistra, 7 dp a destra',
      (tester) async {
    var sinistra = 0, destra = 0;
    await tester.pumpWidget(_app(BaAzioniInCoppia(
      prima: BaAzioneCoppia(testo: 'A', semanticsLabel: 'a', onTap: () => sinistra++),
      seconda: BaAzioneCoppia(testo: 'B', semanticsLabel: 'b', onTap: () => destra++),
    )));
    final a = tester.getRect(find.byType(BaPillola).first);
    final y = a.center.dy;

    await tester.tapAt(Offset(a.right + 3, y));
    expect((sinistra, destra), (1, 0));
    await tester.tapAt(Offset(a.right + 7, y));
    expect((sinistra, destra), (1, 1));
  });

  testWidgets('la singola è centrata e larga come una delle due', (tester) async {
    await tester.pumpWidget(_app(const BaAzioniInCoppia(
      prima: BaAzioneCoppia(testo: 'A', semanticsLabel: 'a'),
    )));
    final r = tester.getRect(find.byType(BaPillola));
    final colonna = tester.getRect(find.byType(LayoutBuilder).first);
    expect(r.center.dx, colonna.center.dx);
    expect(r.width, (360 - BaControlloTokens.gapCoppia) / 2);
  });

  testWidgets('gli stati sono indipendenti: una inattiva, l\'altra no', (tester) async {
    await tester.pumpWidget(_app(BaAzioniInCoppia(
      prima: const BaAzioneCoppia(testo: 'A', semanticsLabel: 'a'),
      seconda: BaAzioneCoppia(testo: 'B', semanticsLabel: 'b', onTap: () {}),
    )));
    final stati = tester
        .widgetList<BaTouchable>(find.byType(BaTouchable))
        .map((t) => t.onTap == null)
        .toList();
    expect(stati, [true, false]);
  });
}
