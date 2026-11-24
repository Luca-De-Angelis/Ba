import 'dart:ui' show SemanticsAction;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/riga_valore.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: larghezza, child: SingleChildScrollView(child: child)),
          ),
        ),
      ),
    );

List<String?> _testi(WidgetTester tester) =>
    tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaValore), matching: find.byType(Text))).map((t) => t.data).toList();

void main() {
  group('il riepilogo (senza onTap)', () {
    testWidgets('mostra etichetta e valore, ha il filetto e l\'altezza minima', (tester) async {
      await tester.pumpWidget(_app(const BaRigaValore(etichetta: 'Tipo', valore: 'Privato')));
      expect(_testi(tester), ['Tipo', 'Privato']);
      expect(tester.getSize(find.byType(BaRigaValore)).height, greaterThanOrEqualTo(BaControlloTokens.coppia));
      final deco = tester.widget<Container>(find.descendant(of: find.byType(BaRigaValore), matching: find.byType(Container)).first).decoration! as BoxDecoration;
      expect((deco.border! as Border).top.color, BaColorTokens.filettoDivisorio);
    });

    testWidgets('non è un bottone e non ha azioni: è testo', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(const BaRigaValore(etichetta: 'Nome', valore: 'Cena senza fretta')));
      final nodo = tester.getSemantics(find.byType(BaRigaValore));
      expect(nodo.label, 'Nome. Cena senza fretta');
      expect(nodo.flagsCollection.isButton, isFalse);
      expect(nodo.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      semantica.dispose();
    });

    testWidgets('senza onTap non c\'è la freccia', (tester) async {
      await tester.pumpWidget(_app(const BaRigaValore(etichetta: 'Tipo')));
      expect(find.descendant(of: find.byType(BaRigaValore), matching: find.byType(CustomPaint)), findsNothing);
    });
  });

  group('la voce del menu (con onTap)', () {
    testWidgets('senza valore ha la freccia disegnata e chiama onTap', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(BaRigaValore(etichetta: 'Descrizione', sottotitolo: 'Due chiacchiere', onTap: () => tocchi++)));
      expect(find.descendant(of: find.byType(BaRigaValore), matching: find.byType(CustomPaint)), findsOneWidget);
      // La freccia non è un carattere.
      expect(_testi(tester).join(), isNot(contains('›')));
      await tester.tap(find.text('Descrizione'));
      expect(tocchi, 1);
    });

    testWidgets('con un valore («0 di 1») non ha la freccia, come nel prototipo', (tester) async {
      await tester.pumpWidget(_app(BaRigaValore(etichetta: 'Co-amministratori', valore: '0 di 1', onTap: () {})));
      expect(find.descendant(of: find.byType(BaRigaValore), matching: find.byType(CustomPaint)), findsNothing);
      expect(_testi(tester), ['Co-amministratori', '0 di 1']);
    });

    testWidgets('per lo screen reader è un bottone con etichetta, sottotitolo e valore', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(BaRigaValore(
        etichetta: 'Co-amministratori',
        sottotitolo: 'Chi ti aiuta a gestire il DEN',
        valore: '0 di 1',
        onTap: () {},
      )));
      final nodo = tester.getSemantics(find.bySemanticsLabel('Co-amministratori. Chi ti aiuta a gestire il DEN. 0 di 1'));
      expect(nodo.flagsCollection.isButton, isTrue);
      semantica.dispose();
    });

    testWidgets('ha un\'area di tocco di almeno areaMinima', (tester) async {
      await tester.pumpWidget(_app(BaRigaValore(etichetta: 'Persone nel DEN', onTap: () {})));
      expect(tester.getSize(find.byType(BaRigaValore)).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
    });
  });

  group('testo grande e nomi lunghi', () {
    testWidgets('a 2,0 etichetta e valore vanno a capo e nulla si taglia', (tester) async {
      await tester.pumpWidget(_app(
        const BaRigaValore(etichetta: 'Descrizione del DEN che non finisce mai', valore: 'Cena senza fretta', sottotitolo: 'Una frase sotto'),
        testo: BaScalaTokens.maxTesto,
      ));
      expect(tester.takeException(), isNull);
      final riga = tester.getRect(find.byType(BaRigaValore));
      for (final t in tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaValore), matching: find.byType(Text)))) {
        final r = tester.getRect(find.byWidget(t));
        expect(r.left, greaterThanOrEqualTo(riga.left));
        expect(r.right, lessThanOrEqualTo(riga.right));
      }
    });
  });
}
