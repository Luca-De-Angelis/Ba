import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/marcatore.dart';
import 'package:ba/design_system/riga_den.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

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

BaRigaDen _viva({int presenze = 5, VoidCallback? onTap, BaStatoRigaDen stato = BaStatoRigaDen.viva, String? frase, String marcatore = 'Entra chiunque · 5 sul palco'}) => BaRigaDen(
      nome: 'Cucina di notte',
      marcatore: marcatore,
      frase: frase,
      presenze: presenze,
      tinte: const [0, 1, 2],
      sagome: const [0, 1, 2],
      stato: stato,
      onTap: onTap,
    );

int _sagome(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: find.byType(BaRigaDen), matching: find.byType(DecoratedBox)))
    .map((d) => d.decoration)
    .whereType<BoxDecoration>()
    .where((d) => d.gradient != null)
    .length;

int _sagomeVuote(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: find.byType(BaRigaDen), matching: find.byType(DecoratedBox)))
    .map((d) => d.decoration)
    .whereType<BoxDecoration>()
    .where((d) => d.gradient == null && d.border is Border && d.borderRadius != null)
    .length;

void main() {
  group('viva e su invito', () {
    testWidgets('nome, campione di sagome e riga di marcatore', (tester) async {
      await tester.pumpWidget(_app(_viva()));
      expect(find.text('Cucina di notte'), findsOneWidget);
      expect(find.text('ENTRA CHIUNQUE · 5 SUL PALCO'), findsOneWidget);
      expect(_sagome(tester), BaPresenzaTokens.campionePubblico);
      expect(tester.widget<Text>(find.text('Cucina di notte')).style?.fontSize, BaTestoTokens.riga.fontSize);
      expect(_sagomeVuote(tester), 0);
    });

    testWidgets('il campione ha da 1 a campionePubblico sagome, mai di più', (tester) async {
      for (final (presenze, attese) in [(1, 1), (2, 2), (3, 3), (4, 3), (14, 3), (0, 0)]) {
        await tester.pumpWidget(_app(_viva(presenze: presenze)));
        expect(_sagome(tester), attese, reason: '$presenze presenze');
      }
    });

    testWidgets('su invito ha lo stesso aspetto della viva: cambia il testo', (tester) async {
      await tester.pumpWidget(_app(_viva(stato: BaStatoRigaDen.suInvito, marcatore: 'Su invito · 2 sul palco', presenze: 2)));
      expect(find.text('SU INVITO · 2 SUL PALCO'), findsOneWidget);
      expect(_sagome(tester), 2);
      expect(_sagomeVuote(tester), 0);
    });

    testWidgets('la frase sotto (chi parla) è facoltativa', (tester) async {
      await tester.pumpWidget(_app(_viva(frase: 'Marta sta parlando')));
      expect(find.text('Marta sta parlando'), findsOneWidget);
    });
  });

  group('spenta (DEN vuoto)', () {
    testWidgets('niente campione, la frase e la sagoma vuota a destra', (tester) async {
      await tester.pumpWidget(_app(_viva(stato: BaStatoRigaDen.spenta, presenze: 0, marcatore: 'Entra chiunque · vuoto', frase: 'Vuoto. Puoi restare e ti avviso.')));
      expect(_sagome(tester), 0);
      expect(_sagomeVuote(tester), 1);
      expect(find.text('Vuoto. Puoi restare e ti avviso.'), findsOneWidget);
      final riga = tester.getRect(find.byType(BaRigaDen));
      expect(tester.getRect(find.byType(DecoratedBox).evaluate().map((e) => find.byWidget(e.widget)).last).right, lessThanOrEqualTo(riga.right));
    });

    testWidgets('anche con presenze dichiarate la spenta non mostra il campione', (tester) async {
      await tester.pumpWidget(_app(_viva(stato: BaStatoRigaDen.spenta, presenze: 5)));
      expect(_sagome(tester), 0);
    });
  });

  group('nessun numero che accumula', () {
    testWidgets('il componente non stampa cifre sue: ogni testo è quello del chiamante', (tester) async {
      await tester.pumpWidget(_app(_viva(presenze: 5, marcatore: 'Entra chiunque · sul palco', frase: 'Marta sta parlando')));
      final testi = tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaDen), matching: find.byType(Text))).map((t) => t.data!).toList();
      expect(testi, ['Cucina di notte', 'ENTRA CHIUNQUE · SUL PALCO', 'Marta sta parlando']);
      for (final t in testi) {
        expect(RegExp(r'\d').hasMatch(t), isFalse, reason: t);
      }
    });

    testWidgets('nessun ticker: è un fatto fermo', (tester) async {
      await tester.pumpWidget(_app(_viva()));
      expect(tester.binding.transientCallbackCount, 0);
    });
  });

  group('il tocco', () {
    testWidgets('con onTap è un bottone alto almeno areaMinima e lo chiama', (tester) async {
      var tocchi = 0;
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_viva(onTap: () => tocchi++)));
      expect(find.byType(BaTouchable), findsOneWidget);
      expect(tester.getSize(find.byType(BaRigaDen)).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
      await tester.tap(find.byType(BaRigaDen));
      expect(tocchi, 1);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Cucina di notte. Entra chiunque · 5 sul palco')).flagsCollection.isButton,
        isTrue,
      );
      semantica.dispose();
    });

    testWidgets('senza onTap è solo testo: nessun bottone', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_viva()));
      expect(find.byType(BaTouchable), findsNothing);
      expect(tester.getSemantics(find.bySemanticsLabel('Cucina di notte. Entra chiunque · 5 sul palco')).flagsCollection.isButton, isFalse);
      semantica.dispose();
    });
  });

  group('testo grande e larghezze', () {
    for (final larghezza in [360.0, 744.0]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp: nulla si taglia né sborda', (tester) async {
        await tester.pumpWidget(_app(
          _viva(frase: 'Marta sta parlando e la serata va avanti da un po\'', marcatore: 'Entra chiunque · 5 sul palco · 14 in ascolto'),
          testo: BaScalaTokens.maxTesto,
          larghezza: larghezza,
        ));
        expect(tester.takeException(), isNull);
        final riga = tester.getRect(find.byType(BaRigaDen));
        for (final t in tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaDen), matching: find.byType(Text)))) {
          final r = tester.getRect(find.byWidget(t));
          expect(r.right, lessThanOrEqualTo(riga.right), reason: t.data);
        }
        expect(find.byType(BaMarcatore), findsOneWidget);
      });
    }
  });
}
