import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/ritratto.dart';
import 'package:ba/design_system/tokens.dart';

// Un PNG sintetico di 1 × 1 pixel: nessuna voce né volto veri nella repo.
final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

Widget _app(Widget child, {double testo = 1}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(
          size: const Size(800, 600),
          textScaler: TextScaler.linear(testo),
        ),
        child: Center(child: SizedBox(width: 100, height: 100, child: child)),
      ),
    );

Finder _velo() => find.byWidgetPredicate(
      (w) => w is ColoredBox && w.color == BaColorTokens.veloImmagine,
    );

double _taglia(WidgetTester tester) => tester.widget<Text>(find.text('MB')).style!.fontSize!;

void main() {
  group('iniziali', () {
    // I valori di T6: round(d × 0,295) a ogni diametro del palco, e al fondo (32).
    final attesi = {208.0: 61.0, 156.0: 46.0, 130.0: 38.0, 112.0: 33.0, 88.0: 26.0, 32.0: 9.0};
    for (final e in attesi.entries) {
      testWidgets('a ${e.key.toInt()} dp la taglia è ${e.value.toInt()}', (tester) async {
        await tester.pumpWidget(_app(BaRitratto(diametro: e.key, iniziali: 'MB')));
        expect(_taglia(tester), e.value);
        expect(_taglia(tester), BaPresenzaTokens.iniziali(e.key));
      });
    }

    testWidgets('sotto 32 dp non c\'è nessuna iniziale', (tester) async {
      for (final d in [31.0, BaPresenzaTokens.pubblico]) {
        await tester.pumpWidget(_app(BaRitratto(diametro: d, iniziali: 'MB')));
        expect(find.text('MB'), findsNothing, reason: 'd = $d');
      }
    });

    testWidgets('senza iniziali resta la sagoma nuda', (tester) async {
      await tester.pumpWidget(_app(const BaRitratto(diametro: 88)));
      expect(find.byType(Text), findsNothing);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('le iniziali non scalano col testo di sistema e sono fuori dalla semantica',
        (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(const BaRitratto(diametro: 88, iniziali: 'MB'), testo: 2));
      final t = tester.widget<Text>(find.text('MB'));
      expect(t.textScaler, TextScaler.noScaling);
      expect(find.bySemanticsLabel('MB'), findsNothing);
      semantica.dispose();
    });
  });

  group('immagine', () {
    testWidgets('in carico: le iniziali, poi l\'immagine col velo', (tester) async {
      final immagine = MemoryImage(_png);
      await tester.pumpWidget(_app(BaRitratto(diametro: 88, iniziali: 'MB', immagine: immagine)));
      expect(find.text('MB'), findsOneWidget, reason: 'in carico');
      expect(_velo(), findsNothing);

      await tester.runAsync(() => precacheImage(immagine, tester.element(find.byType(BaRitratto))));
      await tester.pump();
      await tester.pump();
      expect(find.text('MB'), findsNothing, reason: 'caricata');
      expect(find.byType(Image), findsOneWidget);
      expect(_velo(), findsOneWidget);
    });

    testWidgets('fallita: iniziali, senza velo', (tester) async {
      final guasta = MemoryImage(Uint8List.fromList([1, 2, 3]));
      await tester.pumpWidget(_app(BaRitratto(diametro: 88, iniziali: 'MB', immagine: guasta)));
      await tester.runAsync(() => precacheImage(
            guasta,
            tester.element(find.byType(BaRitratto)),
            onError: (errore, traccia) {},
          ));
      await tester.pump();
      await tester.pump();
      expect(find.text('MB'), findsOneWidget);
      expect(_velo(), findsNothing);
    });

    testWidgets('assente: iniziali', (tester) async {
      await tester.pumpWidget(_app(const BaRitratto(diametro: 88, iniziali: 'MB')));
      expect(find.text('MB'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('immagine caricata sotto 32 dp: l\'immagine, nessuna iniziale', (tester) async {
      final immagine = MemoryImage(_png);
      await tester.pumpWidget(_app(
        BaRitratto(diametro: BaPresenzaTokens.pubblico, iniziali: 'MB', immagine: immagine),
      ));
      await tester.runAsync(() => precacheImage(immagine, tester.element(find.byType(BaRitratto))));
      await tester.pump();
      await tester.pump();
      expect(find.text('MB'), findsNothing);
      expect(_velo(), findsOneWidget);
    });
  });
}
