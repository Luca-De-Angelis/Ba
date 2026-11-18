import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/messaggio.dart';
import 'package:ba/design_system/tokens.dart';

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

const _lungo = 'Il codice non è corretto. Controlla le sei cifre e riprova, oppure chiedine uno nuovo.';

Finder _riquadro() => find.descendant(
      of: find.byType(BaMessaggio),
      matching: find.byWidgetPredicate((w) =>
          w is DecoratedBox && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null && (w.decoration as BoxDecoration).shape == BoxShape.rectangle),
    );

BoxDecoration _decorazione(WidgetTester tester) => tester.widget<DecoratedBox>(_riquadro().first).decoration as BoxDecoration;

void main() {
  group('errore', () {
    testWidgets('ha il filetto, il segno e il testo, e nessun fondo pieno', (tester) async {
      await tester.pumpWidget(_app(const BaMessaggio(testo: 'Non è andata', variante: BaVarianteMessaggio.errore)));
      final d = _decorazione(tester);
      expect((d.border! as Border).top.color, BaColorTokens.erroreFiletto);
      expect(d.color, isNull, reason: 'mai un colore di fondo');
      expect(d.gradient, isNull, reason: 'mai un gradiente');
      expect(d.borderRadius, BorderRadius.circular(BaRaggioTokens.riquadro));
      expect(find.text('!'), findsOneWidget);
      expect(find.text('Non è andata'), findsOneWidget);
      // Il segno: cerchio di erroreSegnoLato con tratto erroreSegnoTratto.
      final segno = tester.getSize(find.ancestor(of: find.text('!'), matching: find.byType(SizedBox)).first);
      expect(segno, const Size.square(BaAccessoTokens.erroreSegnoLato));
      expect(BaAccessoTokens.erroreSegnoLato, 22);
    });

    testWidgets('nessun DecoratedBox del messaggio ha un fondo', (tester) async {
      await tester.pumpWidget(_app(const BaMessaggio(testo: 'x', variante: BaVarianteMessaggio.errore)));
      for (final d in tester.widgetList<DecoratedBox>(find.descendant(of: find.byType(BaMessaggio), matching: find.byType(DecoratedBox)))) {
        final deco = d.decoration as BoxDecoration;
        expect(deco.color, isNull);
        expect(deco.gradient, isNull);
      }
    });

    testWidgets('il testo e il segno hanno il colore dell\'errore', (tester) async {
      await tester.pumpWidget(_app(const BaMessaggio(testo: 'Non è andata', variante: BaVarianteMessaggio.errore)));
      expect(tester.widget<Text>(find.text('Non è andata')).style!.color, BaColorTokens.erroreTesto);
      expect(tester.widget<Text>(find.text('!')).style!.color, BaColorTokens.erroreTesto);
    });

    testWidgets('è annunciato: regione viva', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(const BaMessaggio(testo: 'Non è andata', variante: BaVarianteMessaggio.errore)));
      expect(
        tester.getSemantics(find.byType(BaMessaggio)),
        matchesSemantics(label: 'Non è andata', isLiveRegion: true),
      );
      semantica.dispose();
    });
  });

  group('neutro', () {
    testWidgets('ha il filetto leggero, nessun segno e nessun fondo', (tester) async {
      await tester.pumpWidget(_app(const BaMessaggio(testo: 'Ti scriviamo un codice')));
      final d = _decorazione(tester);
      expect((d.border! as Border).top.color, BaColorTokens.filettoBase);
      expect(d.color, isNull);
      expect(find.text('!'), findsNothing);
      expect(tester.widget<Text>(find.text('Ti scriviamo un codice')).style!.color, BaColorTokens.testoSecondo);
    });

    testWidgets('non è annunciato', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(const BaMessaggio(testo: 'Ti scriviamo un codice')));
      expect(
        tester.getSemantics(find.byType(BaMessaggio)),
        matchesSemantics(label: 'Ti scriviamo un codice', isLiveRegion: false),
      );
      semantica.dispose();
    });
  });

  group('testo grande', () {
    for (final variante in BaVarianteMessaggio.values) {
      testWidgets('a testo 2,0 il testo va a capo, senza tagli né overflow ($variante)', (tester) async {
        await tester.pumpWidget(_app(const BaMessaggio(testo: _lungo), testo: 1.0));
        final alto1 = tester.getSize(find.byType(BaMessaggio)).height;
        await tester.pumpWidget(_app(BaMessaggio(testo: _lungo, variante: variante), testo: 2.0));
        expect(tester.takeException(), isNull);
        final riquadro = tester.getRect(find.byType(BaMessaggio));
        final testo = tester.getRect(find.text(_lungo));
        expect(riquadro.height, greaterThan(alto1), reason: 'il riquadro cresce, non taglia');
        expect(riquadro.contains(testo.topLeft), isTrue);
        expect(riquadro.contains(testo.bottomRight - const Offset(0.01, 0.01)), isTrue);
        expect(riquadro.width, 360);
      });
    }
  });
}
