import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/riga_coda.dart';
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

Widget _riga({String nome = 'Cucina di notte', String stato = 'In coda · entri a microfono spento', VoidCallback? onEsci}) => BaRigaCoda(
      nome: nome,
      stato: stato,
      uscitaTesto: 'Esci dalla coda',
      onEsci: onEsci ?? () {},
    );

void main() {
  group('la riga', () {
    testWidgets('mostra il DEN, lo stato e l\'uscita — e nient\'altro', (tester) async {
      await tester.pumpWidget(_app(_riga()));
      final testi = tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaCoda), matching: find.byType(Text))).map((t) => t.data).toList();
      expect(testi, ['Cucina di notte', 'In coda · entri a microfono spento', 'Esci dalla coda']);
      // Nessun numero a schermo: né posizione, né conteggio, né massimo.
      for (final t in testi) {
        expect(RegExp(r'\d').hasMatch(t!), isFalse, reason: t);
      }
    });

    testWidgets('l\'API non ha dove mettere posizione, conteggio o massimo', (tester) async {
      // I soli parametri sono testi e una callback: se qualcuno ne aggiunge uno,
      // questo test va riletto con la regola «nessuna posizione, nessun conteggio».
      const riga = BaRigaCoda(nome: 'a', stato: 'b', uscitaTesto: 'c');
      expect(riga.nome, 'a');
      expect(riga.stato, 'b');
      expect(riga.uscitaTesto, 'c');
      expect(riga.onEsci, isNull);
    });

    testWidgets('ha il filetto in alto e l\'altezza minima rigaAltezza', (tester) async {
      await tester.pumpWidget(_app(_riga()));
      expect(tester.getSize(find.byType(BaRigaCoda)).height, greaterThanOrEqualTo(BaCodaTokens.rigaAltezza));
      final deco = tester.widget<Container>(find.descendant(of: find.byType(BaRigaCoda), matching: find.byType(Container)).first).decoration! as BoxDecoration;
      expect((deco.border! as Border).top.color, BaColorTokens.filettoDivisorio);
    });
  });

  group('l\'uscita', () {
    testWidgets('è una pillola spenta alta almeno uscitaAltezza (44) e chiama onEsci', (tester) async {
      var uscite = 0;
      await tester.pumpWidget(_app(_riga(onEsci: () => uscite++)));
      final pillola = tester.widget<BaPillola>(find.byType(BaPillola));
      expect(pillola.variante, BaVariantePillola.spenta);
      expect(pillola.altezzaMinima, BaCodaTokens.uscitaAltezza);
      expect(tester.getSize(find.byType(BaPillola)).height, greaterThanOrEqualTo(BaCodaTokens.uscitaAltezza));
      expect(BaCodaTokens.uscitaAltezza, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
      await tester.tap(find.text('Esci dalla coda'));
      expect(uscite, 1);
    });

    testWidgets('senza onEsci è inattiva', (tester) async {
      await tester.pumpWidget(_app(const BaRigaCoda(nome: 'a', stato: 'b', uscitaTesto: 'Esci')));
      expect(tester.widget<BaPillola>(find.byType(BaPillola)).onTap, isNull);
    });
  });

  group('disposizione', () {
    testWidgets('a 1,0 nome e uscita stanno sulla stessa riga, l\'uscita a destra (stato breve)', (tester) async {
      // Con lo stato lungo del prototipo («In coda · entri a microfono spento») nome,
      // stato e uscita non stanno insieme in 320 dp: l'uscita va a capo, come nel
      // flex-wrap del prototipo. Qui, uno stato breve.
      await tester.pumpWidget(_app(const BaRigaCoda(nome: 'Cucina', stato: 'In coda', uscitaTesto: 'Esci')));
      final nome = tester.getRect(find.text('Cucina'));
      final uscita = tester.getRect(find.byType(BaPillola));
      expect(uscita.left, greaterThan(nome.right));
      expect(uscita.center.dy, closeTo(tester.getRect(find.byType(BaRigaCoda)).center.dy, 20));
      expect(uscita.right, closeTo(tester.getRect(find.byType(BaRigaCoda)).right, 0.01), reason: 'spinta a destra');
    });

    testWidgets('con testo grande l\'uscita va a capo sotto il nome', (tester) async {
      await tester.pumpWidget(_app(_riga(), testo: 2.0));
      expect(tester.takeException(), isNull);
      final nome = tester.getRect(find.text('Cucina di notte'));
      final stato = tester.getRect(find.text('In coda · entri a microfono spento'));
      final uscita = tester.getRect(find.byType(BaPillola));
      expect(uscita.top, greaterThanOrEqualTo(stato.bottom), reason: 'sotto nome e stato');
      expect(uscita.left, nome.left, reason: 'allineata al nome');
    });

    testWidgets('un nome lungo spinge l\'uscita a capo anche a testo normale', (tester) async {
      await tester.pumpWidget(_app(_riga(nome: 'Una serata molto lunga sul balcone con tutte le persone')));
      final stato = tester.getRect(find.text('In coda · entri a microfono spento'));
      expect(tester.getRect(find.byType(BaPillola)).top, greaterThanOrEqualTo(stato.bottom));
    });

    testWidgets('a 2,0 nulla si taglia: ogni testo sta dentro la riga', (tester) async {
      await tester.pumpWidget(_app(_riga(nome: 'Cucina di notte con gli amici'), testo: 2.0));
      expect(tester.takeException(), isNull);
      final riga = tester.getRect(find.byType(BaRigaCoda));
      for (final t in ['Cucina di notte con gli amici', 'In coda · entri a microfono spento', 'Esci dalla coda']) {
        final r = tester.getRect(find.text(t));
        expect(riga.contains(r.topLeft) && riga.contains(r.bottomRight - const Offset(0.01, 0.01)), isTrue, reason: t);
      }
    });
  });

  testWidgets('semantica: il nome con lo stato, e il bottone di uscita', (tester) async {
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(_app(_riga()));
    expect(
      tester.getSemantics(find.text('Cucina di notte')),
      matchesSemantics(label: 'Cucina di notte. In coda · entri a microfono spento'),
    );
    expect(
      tester.getSemantics(find.byType(BaPillola)),
      matchesSemantics(label: 'Esci dalla coda', isButton: true, hasEnabledState: true, isEnabled: true, isFocusable: true, hasTapAction: true),
    );
    semantica.dispose();
  });
}
