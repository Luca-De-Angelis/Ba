import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(
          size: Size(larghezza, 800),
          textScaler: TextScaler.linear(testo),
        ),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: larghezza, child: child),
          ),
        ),
      ),
    );

BoxDecoration _decorazione(WidgetTester tester) {
  final d = tester.widget<Container>(
    find.descendant(of: find.byType(BaPillola), matching: find.byType(Container)).first,
  );
  return d.decoration! as BoxDecoration;
}

void main() {
  group('altezza', () {
    for (final testo in [1.0, 2.0]) {
      testWidgets('mai sotto primario a testo $testo', (tester) async {
        await tester.pumpWidget(_app(
          BaPillola(testo: 'Esci', semanticsLabel: 'Esci', onTap: () {}),
          testo: testo,
        ));
        expect(
          tester.getSize(find.byType(BaPillola)).height,
          greaterThanOrEqualTo(BaControlloTokens.primario),
        );
      });
    }

    testWidgets('a testo 2,0 con etichetta lunga: nessun overflow, altezza cresce, testo dentro la pillola',
        (tester) async {
      await tester.pumpWidget(_app(
        BaPillola(
          testo: 'Scendi dal palco e torna in ascolto con tutti gli altri',
          semanticsLabel: 'Scendi dal palco',
          onTap: () {},
        ),
        testo: 2.0,
      ));
      expect(tester.takeException(), isNull);
      final pillola = tester.getRect(find.byType(BaPillola));
      final testoRect = tester.getRect(find.byType(Text));
      expect(pillola.height, greaterThan(BaControlloTokens.primario));
      expect(pillola.contains(testoRect.topLeft), isTrue);
      expect(pillola.contains(testoRect.bottomRight), isTrue);
      // Il testo sta lontano dalle estremità: almeno il padding orizzontale.
      expect(testoRect.left - pillola.left, greaterThanOrEqualTo(BaSpazioTokens.xl));
      expect(pillola.right - testoRect.right, greaterThanOrEqualTo(BaSpazioTokens.xl));
    });

    testWidgets('il raggio è sempre lo stadio, anche con il testo a capo', (tester) async {
      await tester.pumpWidget(_app(
        BaPillola(testo: 'Un testo molto molto lungo che va a capo', semanticsLabel: 'x', onTap: () {}),
        testo: 2.0,
      ));
      expect(_decorazione(tester).borderRadius, BorderRadius.circular(BaRaggioTokens.pillola));
    });
  });

  group('varianti', () {
    testWidgets('chiara: gradiente azioneChiaraPiena, nessun bordo, anello su chiara', (tester) async {
      await tester.pumpWidget(_app(BaPillola(
        testo: 'Sali sul palco',
        semanticsLabel: 'Sali sul palco',
        variante: BaVariantePillola.chiara,
        onTap: () {},
      )));
      final d = _decorazione(tester);
      expect((d.gradient! as LinearGradient).colors, BaColorTokens.azioneChiaraPiena);
      expect(d.border, isNull);
      expect(tester.widget<BaTouchable>(find.byType(BaTouchable)).suChiara, isTrue);
    });

    testWidgets('attiva: fondo e bordo azioneAttiva', (tester) async {
      await tester.pumpWidget(_app(BaPillola(
        testo: 'Spegni il microfono',
        semanticsLabel: 'Spegni il microfono',
        variante: BaVariantePillola.attiva,
        onTap: () {},
      )));
      final d = _decorazione(tester);
      expect((d.gradient! as LinearGradient).colors, BaColorTokens.azioneAttivaFondo);
      expect((d.border! as Border).top.color, BaColorTokens.azioneAttivaBordo);
      expect(tester.widget<BaTouchable>(find.byType(BaTouchable)).suChiara, isFalse);
    });

    testWidgets('spenta: solo il filetto marcato', (tester) async {
      await tester.pumpWidget(_app(BaPillola(
        testo: 'Esci',
        semanticsLabel: 'Esci',
        variante: BaVariantePillola.spenta,
        onTap: () {},
      )));
      final d = _decorazione(tester);
      expect(d.gradient, isNull);
      expect((d.border! as Border).top.color, BaColorTokens.filettoMarcato);
    });

    testWidgets('informativa: filetto leggero, niente BaTouchable', (tester) async {
      await tester.pumpWidget(_app(const BaPillola(
        testo: 'Sei in ascolto',
        semanticsLabel: 'Sei in ascolto',
        variante: BaVariantePillola.informativa,
      )));
      expect(find.byType(BaTouchable), findsNothing);
      expect((_decorazione(tester).border! as Border).top.color, BaColorTokens.filettoBase);
    });
  });

  group('stati', () {
    testWidgets('premuta: cede a scala 0,98 e torna', (tester) async {
      await tester.pumpWidget(_app(BaPillola(testo: 'Esci', semanticsLabel: 'Esci', onTap: () {})));
      final gesto = await tester.startGesture(tester.getCenter(find.byType(BaPillola)));
      await tester.pump(); // il frame che riceve lo stato premuto
      await tester.pump(BaMovimentoTokens.premutoAndata + const Duration(milliseconds: 1));
      double scala() => tester
          .widget<Transform>(find.descendant(of: find.byType(BaTouchable), matching: find.byType(Transform)))
          .transform
          .entry(0, 0);
      expect(scala(), closeTo(BaControlloTokens.premutoScala, 1e-6));
      await gesto.up();
      await tester.pump();
      await tester.pump(BaMovimentoTokens.premutoRitorno + const Duration(milliseconds: 1));
      expect(scala(), closeTo(1, 1e-6));
    });

    testWidgets('a fuoco: compare l\'anello', (tester) async {
      await tester.pumpWidget(_app(BaPillola(testo: 'Esci', semanticsLabel: 'Esci', onTap: () {})));
      Finder anello() => find.descendant(
            of: find.byType(BaPillola),
            matching: find.byWidgetPredicate((w) {
              if (w is! DecoratedBox || w.decoration is! BoxDecoration) return false;
              final b = (w.decoration as BoxDecoration).border;
              return b is Border && b.top.width == BaControlloTokens.focusSpessore;
            }),
          );
      expect(anello(), findsNothing);
      FocusManager.instance.rootScope.traversalDescendants
          .firstWhere((n) => n.debugLabel == 'BaTouchable')
          .requestFocus();
      await tester.pump();
      await tester.pump();
      expect(anello(), findsOneWidget);
    });

    testWidgets('inattiva: il tocco non fa niente, testoInattivo, enabled falso', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(const BaPillola(testo: 'Esci', semanticsLabel: 'Esci')));
      final t = tester.widget<Text>(find.byType(Text));
      expect(t.style!.color, BaColorTokens.testoInattivo);
      expect(
        tester.getSemantics(find.byType(BaPillola)),
        matchesSemantics(label: 'Esci', isButton: true, hasEnabledState: true, isEnabled: false),
      );
      semantica.dispose();
    });
  });

  group('semantica', () {
    testWidgets('etichetta, bottone, abilitata', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(BaPillola(testo: 'Esci', semanticsLabel: 'Esci dal DEN', onTap: () {})));
      expect(
        tester.getSemantics(find.byType(BaPillola)),
        matchesSemantics(
          label: 'Esci dal DEN',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
        ),
      );
      semantica.dispose();
    });

    testWidgets('informativa: etichetta, non è un bottone', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(const BaPillola(
        testo: 'Sei in ascolto',
        semanticsLabel: 'Sei in ascolto',
        variante: BaVariantePillola.informativa,
      )));
      expect(
        tester.getSemantics(find.byType(BaPillola)),
        matchesSemantics(label: 'Sei in ascolto', isButton: false, hasTapAction: false),
      );
      semantica.dispose();
    });
  });
}
