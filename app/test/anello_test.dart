import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/anello.dart';
import 'package:ba/design_system/tokens.dart';

const _chiave = ValueKey('sagoma');

Widget _app({
  bool parla = true,
  double ampiezza = 0,
  int voci = 1,
  bool lineaInstabile = false,
  bool riduciMovimento = false,
  double d = 100,
  Color keyline = BaColorTokens.voceKeyline,
}) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: const Size(800, 600), disableAnimations: riduciMovimento),
        child: Center(
          child: SizedBox(
            key: _chiave,
            width: d,
            height: d,
            child: BaAnello(
              bordo: BorderRadius.circular(d / 2),
              parla: parla,
              ampiezza: ampiezza,
              voci: voci,
              lineaInstabile: lineaInstabile,
              keyline: keyline,
            ),
          ),
        ),
      ),
    );

/// Un frame a tempo zero (il ticker parte) e poi [ms] millisecondi.
Future<void> _avanza(WidgetTester tester, int ms) async {
  await tester.pump();
  await tester.pump(Duration(milliseconds: ms));
}

Finder _scalaF() => find.byType(ScaleTransition);

double _scala(WidgetTester tester) =>
    tester.widget<ScaleTransition>(_scalaF()).scale.value;

/// Il fade del canale veloce: quello fuori dalla scala.
double _comparsa(WidgetTester tester) => tester
    .widget<FadeTransition>(
      find.ancestor(of: _scalaF(), matching: find.byType(FadeTransition)),
    )
    .opacity
    .value;

Finder _fadeTratto() =>
    find.descendant(of: _scalaF(), matching: find.byType(FadeTransition));

/// Opacità del tratto: il fade del respiro.
double _opacita(WidgetTester tester) =>
    tester.widget<FadeTransition>(_fadeTratto()).opacity.value;

Color _coloreTratto(WidgetTester tester) {
  final d = tester.widget<DecoratedBox>(
    find.descendant(of: _fadeTratto(), matching: find.byType(DecoratedBox)),
  );
  return ((d.decoration as BoxDecoration).border! as Border).top.color;
}

/// Le due DecoratedBox dell'anello, dalla keyline al tratto.
List<DecoratedBox> _strati(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: _scalaF(), matching: find.byType(DecoratedBox)))
    .toList();

void main() {
  group('canale veloce', () {
    testWidgets('senza parla l\'anello non c\'è', (tester) async {
      await tester.pumpWidget(_app(parla: false));
      expect(_scalaF(), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('compare in 70 ms', (tester) async {
      await tester.pumpWidget(_app(parla: false));
      await tester.pumpWidget(_app(parla: true));
      await _avanza(tester, 35);
      expect(_comparsa(tester), closeTo(0.5, 0.01));
      await tester.pump(const Duration(milliseconds: 35));
      expect(_comparsa(tester), 1.0);
    });

    testWidgets('scompare in 140 ms', (tester) async {
      await tester.pumpWidget(_app(parla: true));
      await tester.pumpWidget(_app(parla: false));
      await _avanza(tester, 70);
      expect(_comparsa(tester), closeTo(0.5, 0.01));
      await tester.pump(const Duration(milliseconds: 70));
      // L'animazione finisce al primo frame oltre i 140 ms.
      await tester.pump(const Duration(milliseconds: 1));
      expect(_scalaF(), findsNothing);
    });
  });

  group('canale lento', () {
    testWidgets('a riposo: scala 1,00 e opacità 0,28', (tester) async {
      await tester.pumpWidget(_app(ampiezza: 0));
      expect(_scala(tester), closeTo(BaPresenzaTokens.anelloScalaRiposo, 0.001));
      expect(_opacita(tester), closeTo(BaPresenzaTokens.anelloOpacitaRiposo, 0.001));
    });

    testWidgets('ampiezza 1: scala 1,075 e opacità 0,95', (tester) async {
      await tester.pumpWidget(_app(ampiezza: 0));
      await tester.pumpWidget(_app(ampiezza: 1));
      await _avanza(tester, 500);
      expect(_scala(tester), closeTo(1.075, 0.001));
      expect(_opacita(tester), closeTo(0.95, 0.001));
    });

    testWidgets('con due voci: 1,042 e 0,66 (±0,01)', (tester) async {
      await tester.pumpWidget(_app(ampiezza: 0, voci: 2));
      await tester.pumpWidget(_app(ampiezza: 1, voci: 2));
      await _avanza(tester, 500);
      expect(_scala(tester), closeTo(BaPresenzaTokens.limiterDueScala, 0.01));
      expect(_opacita(tester), closeTo(BaPresenzaTokens.limiterDueOpacita, 0.01));
    });

    testWidgets('la salita è una rampa lineare lunga quanto il campionamento', (tester) async {
      await tester.pumpWidget(_app(ampiezza: 0));
      await tester.pumpWidget(_app(ampiezza: 1));
      await _avanza(tester, 250);
      expect(_scala(tester), closeTo(1.0375, 0.002), reason: 'a metà rampa');
    });

    testWidgets('dopo un calo il rilascio non è più corto di 500 ms', (tester) async {
      await tester.pumpWidget(_app(ampiezza: 1));
      expect(_scala(tester), closeTo(1.075, 0.001));
      await tester.pumpWidget(_app(ampiezza: 0));
      await _avanza(tester, 499);
      expect(_scala(tester), greaterThan(1.01), reason: 'a 499 ms è ancora in discesa');
      await tester.pump(const Duration(milliseconds: 101));
      expect(_scala(tester), closeTo(1.0, 0.001), reason: 'a 600 ms è a riposo');
    });

    testWidgets('l\'ampiezza fuori da 0–1 si limita', (tester) async {
      await tester.pumpWidget(_app(ampiezza: 3));
      expect(_scala(tester), closeTo(1.075, 0.001));
    });
  });

  group('linea instabile e riduci movimento', () {
    testWidgets('linea instabile: anello fermo a voceTrattoFermo (0,34)', (tester) async {
      await tester.pumpWidget(_app(lineaInstabile: true, ampiezza: 1));
      await _avanza(tester, 100);
      expect(_scala(tester), 1.0);
      expect(_opacita(tester), 1.0);
      expect(_coloreTratto(tester), BaColorTokens.voceTrattoFermo);
      expect(_coloreTratto(tester).a, closeTo(0.34, 0.01));
      await tester.pumpWidget(_app(lineaInstabile: true, ampiezza: 0.2));
      await _avanza(tester, 700);
      expect(_scala(tester), 1.0, reason: 'non respira');
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('riduci movimento: ferma, senza dissolvenza né respiro', (tester) async {
      await tester.pumpWidget(_app(parla: false, riduciMovimento: true));
      await tester.pumpWidget(_app(parla: true, ampiezza: 1, riduciMovimento: true));
      await tester.pump();
      expect(_comparsa(tester), 1.0, reason: 'subito, senza dissolvenza');
      expect(_scala(tester), 1.0);
      expect(_opacita(tester), 1.0);
      expect(_coloreTratto(tester), BaColorTokens.voceTratto);
      expect(tester.hasRunningAnimations, isFalse);

      await tester.pumpWidget(_app(parla: true, ampiezza: 0.3, riduciMovimento: true));
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
      expect(_scala(tester), 1.0);

      await tester.pumpWidget(_app(parla: false, riduciMovimento: true));
      await tester.pump();
      expect(_scalaF(), findsNothing, reason: 'lo stato resta: l\'anello sparisce');
    });
  });

  group('geometria', () {
    for (final d in [88.0, 208.0]) {
      testWidgets('aderente alla sagoma a ${d.toInt()} dp: 3 + 2, fissi a ogni scala',
          (tester) async {
        await tester.pumpWidget(_app(d: d));
        final sagoma = tester.getRect(find.byKey(_chiave));
        final strati = _strati(tester);
        expect(strati, hasLength(2));
        final rect = [
          for (final s in strati) tester.getRect(find.byWidget(s)),
        ];
        expect(rect[0], sagoma.inflate(BaPresenzaTokens.anelloKeyline));
        expect(
          rect[1],
          sagoma.inflate(BaPresenzaTokens.anelloKeyline + BaPresenzaTokens.anelloTratto),
        );
        final keyline = ((strati[0].decoration as BoxDecoration).border! as Border).top;
        final tratto = ((strati[1].decoration as BoxDecoration).border! as Border).top;
        expect(keyline.width, BaPresenzaTokens.anelloKeyline);
        expect(keyline.color, BaColorTokens.voceKeyline);
        expect(tratto.width, BaPresenzaTokens.anelloTratto);
      });
    }

    testWidgets('la keyline prende il colore che le si dà (premuta)', (tester) async {
      await tester.pumpWidget(_app(keyline: BaColorTokens.premutoKeyline));
      final keyline = ((_strati(tester)[0].decoration as BoxDecoration).border! as Border).top;
      expect(keyline.color, BaColorTokens.premutoKeyline);
    });

    testWidgets('non cambia il layout e non prende i tocchi', (tester) async {
      await tester.pumpWidget(_app(d: 88));
      expect(tester.getSize(find.byKey(_chiave)), const Size(88, 88));
      expect(find.descendant(of: find.byType(BaAnello), matching: find.byType(IgnorePointer)),
          findsWidgets);
    });
  });
}
