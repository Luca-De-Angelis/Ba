import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/glifo.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget child, {bool riduciMovimento = false}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: const Size(800, 600), disableAnimations: riduciMovimento),
        child: Align(alignment: Alignment.topLeft, child: child),
      ),
    );

Finder _opacita() => find.descendant(of: find.byType(BaGlifo), matching: find.byType(FadeTransition));

double _valore(WidgetTester tester) => tester.widget<FadeTransition>(_opacita()).opacity.value;

Future<void> _avanza(WidgetTester tester, int ms) async {
  await tester.pump();
  await tester.pump(Duration(milliseconds: ms));
}

void main() {
  group('lato', () {
    testWidgets('28 di norma, 32 a richiesta, o quello che si dà', (tester) async {
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.microfono)));
      expect(tester.getSize(find.byType(BaGlifo)), const Size(28, 28));
      expect(BaPresenzaTokens.glifo, 28);
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.microfono, ripiego: true)));
      expect(tester.getSize(find.byType(BaGlifo)), const Size(32, 32));
      expect(BaPresenzaTokens.glifoRipiego, 32);
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.bloccata, lato: 41.6)));
      expect(tester.getSize(find.byType(BaGlifo)), const Size.square(41.6));
    });

    test('ripiego e lato sono alternativi', () {
      expect(
        () => BaGlifo(tipo: BaTipoGlifo.microfono, ripiego: true, lato: 30),
        throwsAssertionError,
      );
    });
  });

  group('spento e acceso', () {
    for (final tipo in BaTipoGlifo.values) {
      testWidgets('$tipo: 0,45 da spento, 1 da acceso dopo 140 ms', (tester) async {
        await tester.pumpWidget(_app(BaGlifo(tipo: tipo)));
        expect(_valore(tester), BaPresenzaTokens.glifoOpacitaSpento);
        expect(_valore(tester), 0.45);

        await tester.pumpWidget(_app(BaGlifo(tipo: tipo, acceso: true)));
        await _avanza(tester, 70);
        expect(_valore(tester), closeTo(0.45 + (1 - 0.45) / 2, 0.01), reason: 'a metà, lineare');
        await tester.pump(const Duration(milliseconds: 71));
        expect(_valore(tester), 1.0);
        expect(tester.hasRunningAnimations, isFalse);
      });
    }

    testWidgets('con «riduci movimento» il passaggio è immediato', (tester) async {
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.altoparlante), riduciMovimento: true));
      await tester.pumpWidget(
        _app(const BaGlifo(tipo: BaTipoGlifo.altoparlante, acceso: true), riduciMovimento: true),
      );
      await tester.pump();
      expect(_valore(tester), 1.0);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('lo spegnimento dura 140 ms come l\'accensione', (tester) async {
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.microfono, acceso: true)));
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.microfono)));
      await _avanza(tester, 141);
      expect(_valore(tester), 0.45);
    });
  });

  group('semantica', () {
    testWidgets('il glifo è decorativo: fuori dalla semantica', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(Semantics(
        label: 'Marta B.',
        child: BaGlifo(tipo: BaTipoGlifo.altoparlante, acceso: true),
      )));
      expect(find.descendant(of: find.byType(BaGlifo), matching: find.byType(ExcludeSemantics)), findsOneWidget);
      // Nessun nodo di semantica porta qualcosa che non sia l'etichetta della presenza.
      final nodo = tester.getSemantics(find.byType(BaGlifo));
      expect(nodo.label, 'Marta B.');
      semantica.dispose();
    });
  });

  group('disegno', () {
    Finder pittura() => find.descendant(of: find.byType(BaGlifo), matching: find.byType(CustomPaint));

    testWidgets('microfono: capsula, culla, stelo e la barra a due tratti', (tester) async {
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.microfono, acceso: true)));
      expect(
        pittura(),
        paints
          ..rrect(color: BaColorTokens.glifoTratto, strokeWidth: BaPresenzaTokens.anelloTratto)
          ..path(color: BaColorTokens.glifoTratto, strokeWidth: BaPresenzaTokens.anelloTratto)
          ..line(color: BaColorTokens.glifoTratto, strokeWidth: BaPresenzaTokens.anelloTratto)
          // casing scuro sotto, tratto chiaro sopra
          ..line(
            color: BaColorTokens.voceKeyline,
            strokeWidth: BaPresenzaTokens.anelloKeyline + BaPresenzaTokens.anelloTratto,
          )
          ..line(color: BaColorTokens.glifoTratto, strokeWidth: BaPresenzaTokens.anelloTratto),
      );
    });

    testWidgets('altoparlante: corpo, due onde e la barra', (tester) async {
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.altoparlante, acceso: true)));
      expect(
        pittura(),
        paints
          ..path(color: BaColorTokens.glifoTratto)
          ..arc(color: BaColorTokens.glifoTratto)
          ..arc(color: BaColorTokens.glifoTratto)
          ..line(color: BaColorTokens.voceKeyline)
          ..line(color: BaColorTokens.glifoTratto),
      );
    });

    testWidgets('bloccata: cerchio e la barra', (tester) async {
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.bloccata, acceso: true)));
      expect(
        pittura(),
        paints
          ..circle(color: BaColorTokens.glifoTratto)
          ..line(color: BaColorTokens.voceKeyline)
          ..line(color: BaColorTokens.glifoTratto),
      );
    });

    testWidgets('i colori si danno: la variante io del disco', (tester) async {
      await tester.pumpWidget(_app(const BaGlifo(
        tipo: BaTipoGlifo.microfono,
        acceso: true,
        tratto: BaColorTokens.micSpentoIoGlifo,
        fondo: BaColorTokens.micSpentoIoFondo,
      )));
      expect(
        pittura(),
        paints
          ..rrect(color: BaColorTokens.micSpentoIoGlifo)
          ..path(color: BaColorTokens.micSpentoIoGlifo)
          ..line(color: BaColorTokens.micSpentoIoGlifo)
          ..line(color: BaColorTokens.micSpentoIoFondo)
          ..line(color: BaColorTokens.micSpentoIoGlifo),
      );
    });
  });
}
