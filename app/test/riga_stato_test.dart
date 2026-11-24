import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/marcatore.dart';
import 'package:ba/design_system/riga_stato.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget child, {double testo = 1.0}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: const Size(360, 800), textScaler: TextScaler.linear(testo)),
        child: Align(alignment: Alignment.topLeft, child: SizedBox(width: 360, child: child)),
      ),
    );

void main() {
  testWidgets('due righe: i fatti sopra, le mie preferenze sotto, a distanza sm', (tester) async {
    await tester.pumpWidget(_app(const BaRigaStato(fatti: '3 sul palco', mie: 'Sei in coda')));
    final sopra = tester.getRect(find.text('3 SUL PALCO'));
    final sotto = tester.getRect(find.text('SEI IN CODA'));
    expect(sopra.bottom, lessThan(sotto.top));
    expect(sotto.top - sopra.bottom, BaSpazioTokens.sm);
    final marcatori = tester.widgetList<BaMarcatore>(find.byType(BaMarcatore)).toList();
    expect(marcatori[0].colore, BaColorTokens.testoSecondo);
    expect(marcatori[1].colore, BaColorTokens.testoTerzo);
  });

  testWidgets('senza righe non lascia né testo né spazio', (tester) async {
    await tester.pumpWidget(_app(const BaRigaStato()));
    expect(find.byType(BaMarcatore), findsNothing);
    expect(tester.getSize(find.byType(BaRigaStato)).height, 0);
    await tester.pumpWidget(_app(const BaRigaStato(fatti: '', mie: '')));
    expect(tester.getSize(find.byType(BaRigaStato)).height, 0, reason: "vuote come assenti");
  });

  testWidgets('le righe sono indipendenti: una sola non lascia lo spazio dell\'altra', (tester) async {
    await tester.pumpWidget(_app(const BaRigaStato(fatti: '3 sul palco')));
    final solaFatti = tester.getSize(find.byType(BaRigaStato)).height;
    expect(find.byType(BaMarcatore), findsOneWidget);
    await tester.pumpWidget(_app(const BaRigaStato(mie: 'Sei in coda')));
    expect(find.byType(BaMarcatore), findsOneWidget);
    expect(tester.getSize(find.byType(BaRigaStato)).height, solaFatti, reason: 'una riga, nessuna distanza in più');
    await tester.pumpWidget(_app(const BaRigaStato(fatti: '3 sul palco', mie: 'Sei in coda')));
    expect(tester.getSize(find.byType(BaRigaStato)).height, greaterThan(solaFatti * 2));
  });

  testWidgets('le due righe sono due elementi per lo screen reader', (tester) async {
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(_app(const BaRigaStato(fatti: '3 sul palco', mie: 'Sei in coda')));
    expect(find.bySemanticsLabel('3 sul palco'), findsOneWidget);
    expect(find.bySemanticsLabel('Sei in coda'), findsOneWidget);
    semantica.dispose();
  });

  testWidgets('nessun ticker e a testo 2,0 nulla sborda', (tester) async {
    await tester.pumpWidget(_app(const BaRigaStato(fatti: '8 sul palco · pieno · 14 in ascolto', mie: 'Ti avviso se si libera un posto'), testo: BaScalaTokens.maxTesto));
    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.getSize(find.byType(BaRigaStato)).width, lessThanOrEqualTo(360));
  });
}
