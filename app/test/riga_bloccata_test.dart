import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/presenza.dart';
import 'package:ba/design_system/riga_bloccata.dart';
import 'package:ba/design_system/tokens.dart';

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

BaRigaBloccata _riga({BaStatoRigaBloccata stato = BaStatoRigaBloccata.bloccata, VoidCallback? onSblocca, String nome = 'Dario V.'}) => BaRigaBloccata(
      nome: nome,
      iniziali: 'DV',
      tinta: 1,
      sagoma: 2,
      data: 'in aprile',
      stato: stato,
      sbloccaTesto: 'Sblocca',
      sbloccoInCorsoTesto: 'Sblocco…',
      onSblocca: onSblocca ?? () {},
    );

BaPillola _azione(WidgetTester tester) => tester.widget<BaPillola>(find.byType(BaPillola));

void main() {
  group('bloccata', () {
    testWidgets('la sagoma neutra, il nome, la data in mono e «Sblocca»', (tester) async {
      await tester.pumpWidget(_app(_riga()));
      final presenza = tester.widget<BaPresenza>(find.byType(BaPresenza));
      expect(presenza.bloccata, isTrue);
      expect(find.text('Dario V.'), findsOneWidget);
      expect(find.text('IN APRILE'), findsOneWidget);
      expect(find.text('Sblocca'), findsOneWidget);
      expect(_azione(tester).variante, BaVariantePillola.spenta);
    });

    testWidgets('la sagoma ha il diametro BaPresenzaTokens.minimo (32), non 44', (tester) async {
      await tester.pumpWidget(_app(_riga()));
      expect(tester.widget<BaDiametro>(find.byType(BaDiametro)).diametro, BaPresenzaTokens.minimo);
    });

    testWidgets('«Sblocca» ha almeno areaMinima e chiama onSblocca', (tester) async {
      var sbloccate = 0;
      await tester.pumpWidget(_app(_riga(onSblocca: () => sbloccate++)));
      expect(tester.getSize(find.byType(BaPillola)).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
      await tester.tap(find.text('Sblocca'));
      expect(sbloccate, 1);
    });
  });

  group('sblocco in corso', () {
    testWidgets('l\'azione è inattiva e dice la frase ferma del chiamante: nessuno spinner, nessun timer', (tester) async {
      var sbloccate = 0;
      await tester.pumpWidget(_app(_riga(stato: BaStatoRigaBloccata.sbloccoInCorso, onSblocca: () => sbloccate++)));
      expect(find.text('Sblocco…'), findsOneWidget);
      expect(find.text('Sblocca'), findsNothing);
      expect(_azione(tester).onTap, isNull, reason: 'non si tocca due volte');
      await tester.tap(find.text('Sblocco…'), warnIfMissed: false);
      expect(sbloccate, 0);
      expect(tester.binding.transientCallbackCount, 0);
      expect(find.text('Dario V.'), findsOneWidget, reason: 'la persona è ancora nell\'elenco');
    });

    testWidgets('senza un testo suo l\'azione resta «Sblocca», ma inattiva', (tester) async {
      await tester.pumpWidget(_app(const BaRigaBloccata(nome: 'Dario V.', stato: BaStatoRigaBloccata.sbloccoInCorso, sbloccaTesto: 'Sblocca')));
      expect(find.text('Sblocca'), findsOneWidget);
      expect(_azione(tester).onTap, isNull);
    });
  });

  group('sbloccata', () {
    testWidgets('esce dall\'elenco: la riga non si disegna e non lascia spazio', (tester) async {
      await tester.pumpWidget(_app(_riga(stato: BaStatoRigaBloccata.sbloccata)));
      expect(find.text('Dario V.'), findsNothing);
      expect(find.byType(BaPillola), findsNothing);
      expect(find.byType(BaPresenza), findsNothing);
      expect(tester.getSize(find.byType(BaRigaBloccata)).height, 0);
    });
  });

  group('per lo screen reader', () {
    testWidgets('due elementi: il nome con la data e il bottone, e la sagoma non si ripete', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_riga()));
      expect(find.bySemanticsLabel('Dario V.. in aprile'), findsOneWidget);
      expect(find.bySemanticsLabel('Dario V.'), findsNothing, reason: 'la sagoma non ha un\'etichetta sua');
      expect(tester.getSemantics(find.bySemanticsLabel('Sblocca')).flagsCollection.isButton, isTrue);
      semantica.dispose();
    });
  });

  group('testo grande e larghezze', () {
    for (final larghezza in [360.0, 744.0]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp: un nome lungo non si taglia né sborda', (tester) async {
        for (final stato in [BaStatoRigaBloccata.bloccata, BaStatoRigaBloccata.sbloccoInCorso]) {
          await tester.pumpWidget(_app(_riga(stato: stato, nome: 'Maria Antonietta Bianchi-Rossi'), testo: BaScalaTokens.maxTesto, larghezza: larghezza));
          expect(tester.takeException(), isNull);
          final r = tester.getRect(find.byType(BaRigaBloccata));
          for (final t in tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaBloccata), matching: find.byType(Text)))) {
            expect(tester.getRect(find.byWidget(t)).right, lessThanOrEqualTo(r.right), reason: t.data);
          }
        }
      });
    }
  });
}
