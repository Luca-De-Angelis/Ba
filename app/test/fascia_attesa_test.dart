import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/fascia_attesa.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: larghezza - 40, child: SingleChildScrollView(child: child)),
          ),
        ),
      ),
    );

const _frase = 'Parli al gruppo di chi aspetta. Il palco non ti sente.';

Widget _fascia({int n = 4, VoidCallback? onLascia, bool conLascia = true}) => BaFasciaAttesa(
      conteggio: n,
      tinte: const [0, 1, 2],
      sagome: const [0, 1, 2],
      frase: _frase,
      lasciaTesto: conLascia ? 'Lascia il gruppo' : null,
      onLascia: conLascia ? (onLascia ?? () {}) : null,
    );

Finder _sagome() => find.descendant(
      of: find.byType(BaFasciaAttesa),
      matching: find.byWidgetPredicate((w) =>
          w is SizedBox && w.width == BaCodaTokens.gruppoPresenzaLato && w.height == BaCodaTokens.gruppoPresenzaLato),
    );

void main() {
  group('le presenze', () {
    testWidgets('tante sagome quante sono, da 32, senza iniziali né numeri né segni', (tester) async {
      await tester.pumpWidget(_app(_fascia(n: 5)));
      expect(_sagome(), findsNWidgets(5));
      expect(BaCodaTokens.gruppoPresenzaLato, 32);
      expect(tester.getSize(_sagome().first), const Size.square(32));
      // Nessun testo nelle sagome: solo la frase e l'azione.
      final testi = tester.widgetList<Text>(find.descendant(of: find.byType(BaFasciaAttesa), matching: find.byType(Text))).map((t) => t.data).toList();
      expect(testi, [_frase, 'Lascia il gruppo']);
      expect(find.descendant(of: find.byType(BaFasciaAttesa), matching: find.textContaining(RegExp(r'\d'))), findsNothing, reason: 'nessun numero');
    });

    testWidgets('le sagome stanno a distanza gruppoPresenzaGap', (tester) async {
      await tester.pumpWidget(_app(_fascia(n: 3)));
      final a = tester.getRect(_sagome().at(0));
      final b = tester.getRect(_sagome().at(1));
      expect(b.left - a.right, BaCodaTokens.gruppoPresenzaGap);
    });

    testWidgets('otto sagome (il massimo) non fanno overflow a 360, vanno a capo se serve', (tester) async {
      await tester.pumpWidget(_app(_fascia(n: BaCodaTokens.gruppoMax)));
      expect(tester.takeException(), isNull);
      expect(_sagome(), findsNWidgets(8));
      final fascia = tester.getRect(find.byType(BaFasciaAttesa));
      for (var i = 0; i < 8; i++) {
        expect(fascia.contains(tester.getRect(_sagome().at(i)).bottomRight - const Offset(0.01, 0.01)), isTrue);
      }
    });

    test('più di otto o nessuna persona è un errore', () {
      expect(() => BaFasciaAttesa(conteggio: 9, tinte: const [0], sagome: const [0], frase: 'x'), throwsAssertionError);
      expect(() => BaFasciaAttesa(conteggio: 0, tinte: const [0], sagome: const [0], frase: 'x'), throwsAssertionError);
      expect(BaCodaTokens.gruppoMax, 8);
    });

    testWidgets('per lo screen reader le sagome non esistono: si legge la frase', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_fascia(n: 4)));
      expect(find.bySemanticsLabel(_frase), findsOneWidget);
      // Le sagome sono escluse dalla semantica.
      expect(find.descendant(of: find.byType(BaFasciaAttesa), matching: find.byType(ExcludeSemantics)), findsWidgets);
      semantica.dispose();
    });
  });

  group('«Lascia il gruppo»', () {
    testWidgets('con la callback: c\'è, è toccabile (≥ 44) e chiama onLascia', (tester) async {
      var lasciato = 0;
      await tester.pumpWidget(_app(_fascia(onLascia: () => lasciato++)));
      expect(find.text('Lascia il gruppo'), findsOneWidget);
      expect(tester.getSize(find.byType(BaTouchable)).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
      await tester.tap(find.text('Lascia il gruppo'));
      expect(lasciato, 1);
    });

    testWidgets('senza la callback la riga SPARISCE: nessun testo, nessun bottone, nessun vuoto', (tester) async {
      await tester.pumpWidget(_app(_fascia(conLascia: false)));
      expect(find.text('Lascia il gruppo'), findsNothing);
      expect(find.descendant(of: find.byType(BaFasciaAttesa), matching: find.byType(BaTouchable)), findsNothing);
      // Nessuno spazio vuoto: sotto la frase c'è solo il padding della fascia.
      final fascia = tester.getRect(find.byType(BaFasciaAttesa));
      final frase = tester.getRect(find.text(_frase));
      expect(fascia.bottom - frase.bottom, BaSpazioTokens.m, reason: 'solo il padding, niente riga vuota');
    });

    testWidgets('senza la riga la fascia è più bassa di quanto sarebbe con la riga', (tester) async {
      await tester.pumpWidget(_app(_fascia(conLascia: false)));
      final senza = tester.getSize(find.byType(BaFasciaAttesa)).height;
      await tester.pumpWidget(_app(_fascia(conLascia: true)));
      final con = tester.getSize(find.byType(BaFasciaAttesa)).height;
      expect(con - senza, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
    });

    test('testo e callback vanno insieme, o nessuno dei due', () {
      expect(() => BaFasciaAttesa(conteggio: 2, tinte: const [0], sagome: const [0], frase: 'x', lasciaTesto: 'Lascia'), throwsAssertionError);
      expect(() => BaFasciaAttesa(conteggio: 2, tinte: const [0], sagome: const [0], frase: 'x', onLascia: () {}), throwsAssertionError);
    });

    testWidgets('semantica: un bottone con la sua etichetta', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_fascia()));
      expect(
        tester.getSemantics(find.text('Lascia il gruppo')),
        matchesSemantics(label: 'Lascia il gruppo', isButton: true, hasEnabledState: true, isEnabled: true, isFocusable: true, hasTapAction: true),
      );
      semantica.dispose();
    });
  });

  group('la fascia', () {
    testWidgets('ha il bordo e il raggio della fascia «chi mi sente» e l\'altezza minima 72', (tester) async {
      await tester.pumpWidget(_app(_fascia(conLascia: false)));
      final deco = tester.widget<DecoratedBox>(find.descendant(of: find.byType(BaFasciaAttesa), matching: find.byType(DecoratedBox)).first).decoration as BoxDecoration;
      expect(deco.borderRadius, BorderRadius.circular(BaAscoltoTokens.raggio));
      expect((deco.border! as Border).top.color, BaColorTokens.ascoltoGruppoBordo);
      expect(tester.getSize(find.byType(BaFasciaAttesa)).height, greaterThanOrEqualTo(BaAscoltoTokens.altezzaMinima));
    });

    testWidgets('a testo 2,0 la frase va a capo e nulla si taglia', (tester) async {
      await tester.pumpWidget(_app(_fascia(), testo: 2.0));
      expect(tester.takeException(), isNull);
      final fascia = tester.getRect(find.byType(BaFasciaAttesa));
      for (final t in [_frase, 'Lascia il gruppo']) {
        final r = tester.getRect(find.text(t));
        expect(fascia.contains(r.topLeft) && fascia.contains(r.bottomRight - const Offset(0.01, 0.01)), isTrue, reason: t);
      }
    });
  });
}
