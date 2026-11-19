import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/punto_aggancio.dart';
import 'package:ba/design_system/touchable.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/tratteggio.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: larghezza, child: child),
        ),
      ),
    );

const _aggancio = BaPuntoAggancio(titolo: 'Qui, le persone da invitare', sottotitolo: 'La fonte non è decisa');
const _quando = BaPuntoAggancio.quando(
  etichetta: 'Quando',
  titolo: 'Adesso',
  sottotitolo: 'Programmare un DEN arriverà dopo',
);

void main() {
  group('riquadro', () {
    testWidgets('è tratteggiato, con il raggio e l\'altezza dei token', (tester) async {
      await tester.pumpWidget(_app(_aggancio));
      final tratteggio = tester.widget<BaTratteggio>(find.byType(BaTratteggio));
      expect(tratteggio.raggio, BaCreazioneTokens.aggancioRaggio);
      expect(tratteggio.soloSopra, isFalse);
      expect(tester.getSize(find.byType(BaPuntoAggancio)).height, greaterThanOrEqualTo(BaCreazioneTokens.aggancioAltezza));
      expect(tester.getSize(find.byType(BaPuntoAggancio)).width, 360);
      expect(find.text('Qui, le persone da invitare'), findsOneWidget);
      expect(find.text('LA FONTE NON È DECISA'), findsOneWidget);
    });

    testWidgets('senza sottotitolo regge l\'altezza minima', (tester) async {
      await tester.pumpWidget(_app(const BaPuntoAggancio(titolo: 'Solo il titolo')));
      expect(tester.getSize(find.byType(BaPuntoAggancio)).height, greaterThanOrEqualTo(BaCreazioneTokens.aggancioAltezza));
    });
  });

  group('«Quando» spento', () {
    testWidgets('filetto tratteggiato in alto e interruttore spento 44 × 26 a destra', (tester) async {
      await tester.pumpWidget(_app(_quando));
      expect(tester.widgetList<BaTratteggio>(find.byType(BaTratteggio)).where((t) => t.soloSopra), hasLength(1));
      final interruttore = tester.getRect(find.byWidgetPredicate(
        (w) => w is SizedBox && w.width == BaCreazioneTokens.quandoInterruttoreLarghezza && w.height == BaCreazioneTokens.quandoInterruttoreAltezza,
      ));
      expect(interruttore.size, const Size(44, 26));
      final riga = tester.getRect(find.byType(BaPuntoAggancio));
      expect(interruttore.right, lessThanOrEqualTo(riga.right));
      expect(interruttore.center.dx, greaterThan(riga.center.dx), reason: 'a destra');
      expect(riga.height, greaterThanOrEqualTo(BaControlloTokens.primario));
      expect(find.text('QUANDO'), findsOneWidget);
      expect(find.text('Adesso'), findsOneWidget);
    });

    testWidgets('l\'interruttore è tratteggiato a stadio e senza segno di acceso', (tester) async {
      await tester.pumpWidget(_app(_quando));
      final pillola = tester.widgetList<BaTratteggio>(find.byType(BaTratteggio)).where((t) => !t.soloSopra).single;
      expect(pillola.raggio, BaRaggioTokens.pillola);
    });
  });

  for (final (nome, widget) in [('riquadro', _aggancio), ('«Quando»', _quando)]) {
    group('mai un\'azione ($nome)', () {
      testWidgets('niente BaTouchable, niente Focus, niente gesti', (tester) async {
        await tester.pumpWidget(_app(widget));
        final dentro = find.descendant(of: find.byType(BaPuntoAggancio), matching: find.byType(BaTouchable));
        expect(dentro, findsNothing);
        expect(find.descendant(of: find.byType(BaPuntoAggancio), matching: find.byType(Focus)), findsNothing);
        expect(find.descendant(of: find.byType(BaPuntoAggancio), matching: find.byType(GestureDetector)), findsNothing);
        expect(find.descendant(of: find.byType(BaPuntoAggancio), matching: find.byType(Listener)), findsNothing);
      });

      testWidgets('per lo screen reader è testo: né bottone né focalizzabile né con azione', (tester) async {
        final semantica = tester.ensureSemantics();
        await tester.pumpWidget(_app(widget));
        final nodo = tester.getSemantics(find.byType(BaPuntoAggancio));
        expect(nodo, isNot(matchesSemantics(isButton: true)));
        final dati = nodo.getSemanticsData();
        expect(dati.hasAction(SemanticsAction.tap), isFalse);
        expect(dati.flagsCollection.isButton, isFalse);
        expect(dati.label, isNotEmpty);
        semantica.dispose();
      });

      testWidgets('a testo 2,0 nulla si taglia e non fa overflow', (tester) async {
        await tester.pumpWidget(_app(widget, testo: 2.0));
        expect(tester.takeException(), isNull);
        final riquadro = tester.getRect(find.byType(BaPuntoAggancio));
        for (final testo in tester.widgetList<Text>(find.descendant(of: find.byType(BaPuntoAggancio), matching: find.byType(Text)))) {
          final r = tester.getRect(find.byWidget(testo));
          expect(riquadro.contains(r.topLeft) && riquadro.contains(r.bottomRight - const Offset(0.01, 0.01)), isTrue, reason: testo.data);
        }
      });
    });
  }
}
