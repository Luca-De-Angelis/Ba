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
          ..rrect(color: BaColorTokens.glifoTratto, strokeWidth: BaGlifoTokens.tratto)
          ..path(color: BaColorTokens.glifoTratto, strokeWidth: BaGlifoTokens.tratto)
          ..line(color: BaColorTokens.glifoTratto, strokeWidth: BaGlifoTokens.tratto)
          // alone scuro sotto, tratto chiaro sopra
          ..line(color: BaColorTokens.voceKeyline, strokeWidth: BaGlifoTokens.barraAlone)
          ..line(color: BaColorTokens.glifoTratto, strokeWidth: BaGlifoTokens.tratto),
      );
    });

    testWidgets('altoparlante: corpo e cono pieni, due onde a tratto e la barra a due tratti',
        (tester) async {
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.altoparlante, acceso: true)));
      expect(
        pittura(),
        paints
          ..rect(color: BaColorTokens.glifoTratto, style: PaintingStyle.fill) // corpo
          ..path(color: BaColorTokens.glifoTratto, style: PaintingStyle.fill) // cono
          ..arc(color: BaColorTokens.glifoTratto, strokeWidth: BaGlifoTokens.tratto)
          ..arc(color: BaColorTokens.glifoTratto, strokeWidth: BaGlifoTokens.tratto)
          ..line(color: BaColorTokens.voceKeyline, strokeWidth: BaGlifoTokens.barraAlone)
          ..line(color: BaColorTokens.glifoTratto, strokeWidth: BaGlifoTokens.tratto),
      );
    });

    testWidgets('bloccata: anello e barra del solo tratto, senza alone', (tester) async {
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.bloccata, acceso: true)));
      expect(
        pittura(),
        paints
          ..circle(color: BaColorTokens.glifoTratto, strokeWidth: BaGlifoTokens.tratto)
          ..line(color: BaColorTokens.glifoTratto, strokeWidth: BaGlifoTokens.tratto),
      );
      expect(
        pittura(),
        isNot(paints..line(color: BaColorTokens.voceKeyline)),
        reason: 'nel prototipo la barra del cerchio non ha alone',
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

  group('geometria dai token (012c)', () {
    Finder pittura() => find.descendant(of: find.byType(BaGlifo), matching: find.byType(CustomPaint));

    // Lo stesso tratto a ogni misura: a 28 un tratto da 1 sparisce, a 44 uno da 3 pesa.
    for (final lato in [28.0, 44.0]) {
      testWidgets('lo stesso tratto di 2 dp a lato ${lato.toInt()}, per tutti e tre i glifi',
          (tester) async {
        expect(BaGlifoTokens.tratto, 2);
        const t = BaGlifoTokens.tratto;
        // Microfono: capsula, culla e stelo, poi la barra (alone e tratto).
        await tester.pumpWidget(_app(BaGlifo(tipo: BaTipoGlifo.microfono, acceso: true, lato: lato)));
        expect(
          pittura(),
          paints
            ..rrect(strokeWidth: t)
            ..path(strokeWidth: t)
            ..line(strokeWidth: t)
            ..line(strokeWidth: BaGlifoTokens.barraAlone)
            ..line(strokeWidth: t),
        );
        // Altoparlante: due onde, poi la barra.
        await tester.pumpWidget(_app(BaGlifo(tipo: BaTipoGlifo.altoparlante, acceso: true, lato: lato)));
        expect(
          pittura(),
          paints
            ..arc(strokeWidth: t)
            ..arc(strokeWidth: t)
            ..line(strokeWidth: BaGlifoTokens.barraAlone)
            ..line(strokeWidth: t),
        );
        // Cerchio: anello e barra.
        await tester.pumpWidget(_app(BaGlifo(tipo: BaTipoGlifo.bloccata, acceso: true, lato: lato)));
        expect(pittura(), paints..circle(strokeWidth: t)..line(strokeWidth: t));
      });
    }

    testWidgets('le due onde distano più del tratto a 28 di lato', (tester) async {
      // A 28 di lato del disco, il glifo misura 28 − 2 × badgeBordo = 25 dentro il bordo.
      const dentro = 28 - 2 * BaPresenzaTokens.badgeBordo;
      const distanza = (BaGlifoTokens.ondaEsternaRaggio - BaGlifoTokens.ondaInternaRaggio) * dentro;
      expect(distanza, closeTo(3.5, 1e-9));
      expect(distanza, greaterThan(BaGlifoTokens.tratto));
      // E sono disegnate proprio a quei raggi, con il centro al 60 % del lato.
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.altoparlante, acceso: true, lato: dentro)));
      Rect onda(double raggio) => Rect.fromCircle(
            center: const Offset(BaGlifoTokens.ondeCentroX * dentro, dentro / 2),
            radius: raggio * dentro,
          );
      expect(
        pittura(),
        paints
          ..arc(rect: onda(BaGlifoTokens.ondaInternaRaggio))
          ..arc(rect: onda(BaGlifoTokens.ondaEsternaRaggio)),
      );
      // Anche a 28 e a 44 di lato: la distanza cresce col glifo, mai sotto il tratto.
      for (final lato in [28.0, 44.0]) {
        expect(
          (BaGlifoTokens.ondaEsternaRaggio - BaGlifoTokens.ondaInternaRaggio) * lato,
          greaterThan(BaGlifoTokens.tratto),
        );
      }
    });

    testWidgets('il cerchio e la sua barra hanno lo stesso diametro', (tester) async {
      const lato = 25.0;
      await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.bloccata, acceso: true, lato: lato)));
      const esterno = BaGlifoTokens.cerchioLato * lato;
      expect(
        pittura(),
        paints
          // l'anello è disegnato a metà tratto dentro il suo riquadro: il raggio
          // della linea è quello esterno meno mezzo tratto
          ..circle(
            x: lato / 2,
            y: lato / 2,
            radius: esterno / 2 - BaGlifoTokens.tratto / 2,
          )
          // la barra, nel sistema ruotato: lunga quanto il diametro esterno
          ..line(p1: const Offset(-esterno / 2, 0), p2: const Offset(esterno / 2, 0)),
      );
    });

    testWidgets("la barra di microfono e altoparlante è lunga barraLato, con l'alone", (tester) async {
      const lato = 25.0;
      for (final tipo in [BaTipoGlifo.microfono, BaTipoGlifo.altoparlante]) {
        await tester.pumpWidget(_app(BaGlifo(tipo: tipo, acceso: true, lato: lato)));
        const lunga = BaGlifoTokens.barraLato * lato;
        final matcher = paints;
        if (tipo == BaTipoGlifo.microfono) matcher.line(); // lo stelo, prima della barra
        expect(
          pittura(),
          matcher
            ..line(
              p1: const Offset(-lunga / 2, 0),
              p2: const Offset(lunga / 2, 0),
              color: BaColorTokens.voceKeyline,
              strokeWidth: BaGlifoTokens.barraAlone,
            )
            ..line(
              p1: const Offset(-lunga / 2, 0),
              p2: const Offset(lunga / 2, 0),
              color: BaColorTokens.glifoTratto,
              strokeWidth: BaGlifoTokens.tratto,
            ),
          reason: '$tipo',
        );
      }
    });
  });
}
