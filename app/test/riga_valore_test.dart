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

  group('a testo grande il valore sta sotto l\'etichetta in ogni riga (task 032c)', () {
    final righe = <Widget>[
      const BaRigaValore(etichetta: 'Lingua', valore: 'Italiano'),
      const BaRigaValore(etichetta: 'Microfono', valore: 'Consentito'),
      const BaRigaValore(etichetta: 'Chi può trovarmi', valore: 'Chi conosco'),
      const BaRigaValore(etichetta: 'Persone bloccate', valore: '3 persone'),
      const BaRigaValore(etichetta: 'Tipo', valore: 'Privato'),
    ];
    const coppie = [('Lingua', 'Italiano'), ('Microfono', 'Consentito'), ('Chi può trovarmi', 'Chi conosco'), ('Persone bloccate', '3 persone'), ('Tipo', 'Privato')];

    testWidgets('a 2,0 e 360 dp ogni valore è sotto la sua etichetta e tutti i valori hanno lo stesso bordo sinistro', (tester) async {
      await tester.pumpWidget(_app(Column(children: righe), testo: 2.0));
      expect(tester.takeException(), isNull);
      final bordi = <double>{};
      for (final (etichetta, valore) in coppie) {
        final e = tester.getRect(find.text(etichetta));
        final v = tester.getRect(find.text(valore));
        expect(v.top, greaterThanOrEqualTo(e.bottom), reason: '$etichetta: valore sotto');
        expect(v.left, e.left, reason: '$etichetta: stesso bordo sinistro dell\'etichetta');
        bordi.add(v.left);
      }
      expect(bordi, hasLength(1), reason: '$bordi');
    });

    testWidgets('a 1,0 il valore sta accanto all\'etichetta, come prima', (tester) async {
      await tester.pumpWidget(_app(Column(children: righe.take(1).toList())));
      expect(tester.getRect(find.text('Italiano')).left, greaterThan(tester.getRect(find.text('Lingua')).right));
    });

    testWidgets('la soglia è azioneSottoDa (1,3), la stessa delle righe di persona', (tester) async {
      const riga = BaRigaValore(etichetta: 'Io', valore: 'Sì');
      await tester.pumpWidget(_app(riga, testo: 1.29));
      expect(tester.getRect(find.text('Sì')).left, greaterThan(tester.getRect(find.text('Io')).right));
      await tester.pumpWidget(_app(riga, testo: BaPersoneTokens.azioneSottoDa));
      expect(tester.getRect(find.text('Sì')).top, greaterThanOrEqualTo(tester.getRect(find.text('Io')).bottom));
    });
  });
}
