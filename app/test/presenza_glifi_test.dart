import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/anello.dart';
import 'package:ba/design_system/glifo.dart';
import 'package:ba/design_system/presenza.dart';
import 'package:ba/design_system/tokens.dart';

// Un PNG sintetico di 1 × 1 pixel: nessuna voce né volto veri nella repo.
final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

const _diametri = [88.0, 112.0, 130.0, 156.0, 208.0];

Widget _app(Widget child, {double d = 88, bool riduciMovimento = false}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: const Size(800, 600), disableAnimations: riduciMovimento),
        child: Align(alignment: Alignment.topLeft, child: BaDiametro(diametro: d, child: child)),
      ),
    );

BaPresenza _p({
  bool parla = false,
  bool persa = false,
  bool scheletro = false,
  bool mutata = false,
  bool bloccata = false,
  bool microfonoSpento = false,
  bool io = false,
  bool haLaParola = false,
  ImageProvider? immagine,
  VoidCallback? onTap,
}) =>
    BaPresenza(
      semanticsLabel: 'Marta B.',
      indiceTinta: 4,
      indiceSagoma: 1,
      iniziali: 'MB',
      immagine: immagine,
      parla: parla,
      ampiezza: 1,
      persa: persa,
      scheletro: scheletro,
      mutata: mutata,
      bloccata: bloccata,
      microfonoSpento: microfonoSpento,
      io: io,
      haLaParola: haLaParola,
      onTap: onTap ?? () {},
    );

/// La sagoma colorata: l'unica DecoratedBox con un gradiente.
Finder _sagoma() => find.byWidgetPredicate(
      (w) => w is DecoratedBox && (w.decoration as BoxDecoration).gradient != null,
    );

Finder _glifo() => find.byType(BaGlifo);
Finder _disco() => find.byType(BaDiscoGlifo);
Finder _tacca() => find.byType(BaTaccaParola);

BaTipoGlifo _tipo(WidgetTester tester) => tester.widget<BaGlifo>(_glifo()).tipo;

double _opacitaGlifo(WidgetTester tester) => tester
    .widget<FadeTransition>(find.descendant(of: _glifo(), matching: find.byType(FadeTransition)))
    .opacity
    .value;

/// L'opacità delle iniziali: l'Opacity subito sopra il testo.
double _opacitaIniziali(WidgetTester tester) => tester
    .widget<Opacity>(find.ancestor(of: find.text('MB'), matching: find.byType(Opacity)).first)
    .opacity;

LinearGradient _gradiente(WidgetTester tester) =>
    (tester.widget<DecoratedBox>(_sagoma()).decoration as BoxDecoration).gradient! as LinearGradient;

Future<void> _avanza(WidgetTester tester, int ms) async {
  await tester.pump();
  await tester.pump(Duration(milliseconds: ms));
}

bool _anello(WidgetTester tester) =>
    tester.widgetList<BaAnello>(find.byType(BaAnello)).any((a) => a.parla);

BoxDecoration _decoDisco(WidgetTester tester) => tester
    .widget<DecoratedBox>(find.descendant(of: _disco(), matching: find.byType(DecoratedBox)))
    .decoration as BoxDecoration;

void main() {
  group('mutata', () {
    testWidgets('sagoma desaturata e più opaca, iniziali a 0,80', (tester) async {
      await tester.pumpWidget(_app(_p(mutata: true)));
      final filtro = tester.widget<ColorFiltered>(find.byType(ColorFiltered));
      // saturate(0,25) con i pesi di luminanza Rec. 709.
      final numeri = RegExp(r'-?\d+(?:\.\d+)?(?:e-?\d+)?')
          .allMatches(filtro.colorFilter.toString().split('(').last)
          .map((m) => double.parse(m.group(0)!))
          .toList();
      const attesi = <double>[
        0.40945, 0.5364, 0.05415, 0, 0, //
        0.15945, 0.7864, 0.05415, 0, 0,
        0.15945, 0.5364, 0.30415, 0, 0,
        0, 0, 0, 1, 0,
      ];
      expect(numeri, hasLength(20));
      for (var i = 0; i < 20; i++) {
        expect(numeri[i], closeTo(attesi[i], 1e-9), reason: 'elemento $i');
      }
      expect(BaPresenzaTokens.mutataSaturazione, 0.25);
      final opacita = tester.widget<Opacity>(
        find.ancestor(of: find.byType(ColorFiltered), matching: find.byType(Opacity)).first,
      );
      expect(opacita.opacity, BaPresenzaTokens.mutataOpacita);
      expect(_opacitaIniziali(tester), BaPresenzaTokens.inizialiMutataOpacita);
      expect(_opacitaIniziali(tester), 0.80);
    });

    testWidgets('con immagine: il velo è veloMutataImmagine', (tester) async {
      final immagine = MemoryImage(_png);
      await tester.pumpWidget(_app(_p(mutata: true, immagine: immagine)));
      await tester.runAsync(() => precacheImage(immagine, tester.element(find.byType(BaPresenza))));
      await tester.pump();
      await tester.pump();
      expect(
        find.byWidgetPredicate((w) => w is ColoredBox && w.color == BaColorTokens.veloMutataImmagine),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) => w is ColoredBox && w.color == BaColorTokens.veloImmagine),
        findsNothing,
      );
    });

    testWidgets("l'altoparlante sta nel disco, spento; le iniziali restano scoperte", (tester) async {
      await tester.pumpWidget(_app(_p(mutata: true)));
      expect(_glifo(), findsOneWidget);
      expect(_tipo(tester), BaTipoGlifo.altoparlante);
      expect(_opacitaGlifo(tester), BaPresenzaTokens.glifoOpacitaSpento);
      // Il glifo non è al centro: sta nel disco in basso a destra.
      final centro = tester.getCenter(_sagoma());
      expect(tester.getCenter(_glifo()).dx, greaterThan(centro.dx));
      expect(tester.getCenter(_glifo()).dy, greaterThan(centro.dy));
      expect(
        tester.getRect(_glifo()).overlaps(tester.getRect(find.text('MB'))),
        isFalse,
        reason: 'le iniziali non si coprono mai',
      );
    });

    testWidgets("mutata che parla: il glifo si accende entro 140 ms, e non c'è anello", (tester) async {
      await tester.pumpWidget(_app(_p(mutata: true)));
      await tester.pumpWidget(_app(_p(mutata: true, parla: true)));
      await _avanza(tester, 70);
      expect(_opacitaGlifo(tester), closeTo(0.45 + 0.55 / 2, 0.01));
      await tester.pump(const Duration(milliseconds: 71));
      expect(_opacitaGlifo(tester), 1.0);
      expect(_anello(tester), isFalse, reason: "l'anello direbbe il falso (§7.9)");
      expect(find.byType(ScaleTransition), findsNothing);
      // E si spegne quando smette.
      await tester.pumpWidget(_app(_p(mutata: true)));
      await _avanza(tester, 141);
      expect(_opacitaGlifo(tester), 0.45);
    });

    testWidgets('con «riduci movimento» il glifo resta acceso mentre parla, subito', (tester) async {
      await tester.pumpWidget(_app(_p(mutata: true), riduciMovimento: true));
      await tester.pumpWidget(_app(_p(mutata: true, parla: true), riduciMovimento: true));
      await tester.pump();
      expect(_opacitaGlifo(tester), 1.0);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('bloccata', () {
    testWidgets('gradiente neutro a due stop, iniziali a 0,70', (tester) async {
      await tester.pumpWidget(_app(_p(bloccata: true)));
      expect(_gradiente(tester).colors, BaColorTokens.neutroBloccata);
      expect(BaColorTokens.neutroBloccata, hasLength(2));
      expect(_opacitaIniziali(tester), BaPresenzaTokens.inizialiBloccataOpacita);
      expect(_opacitaIniziali(tester), 0.70);
    });

    testWidgets('cerchio barrato nel disco, acceso; nessun anello nemmeno con parla', (tester) async {
      await tester.pumpWidget(_app(_p(bloccata: true, parla: true)));
      await _avanza(tester, 300);
      expect(_tipo(tester), BaTipoGlifo.bloccata);
      expect(_opacitaGlifo(tester), 1.0);
      expect(_anello(tester), isFalse);
      expect(find.byType(ScaleTransition), findsNothing);
    });

    testWidgets('la foto non si mostra: neutra, con le iniziali', (tester) async {
      await tester.pumpWidget(_app(_p(bloccata: true, immagine: MemoryImage(_png))));
      expect(find.byType(Image), findsNothing);
      expect(find.text('MB'), findsOneWidget);
    });
  });

  group('precedenze', () {
    testWidgets('bloccata batte mutata: aspetto neutro, nessuna desaturazione', (tester) async {
      await tester.pumpWidget(_app(_p(mutata: true, bloccata: true)));
      expect(find.byType(ColorFiltered), findsNothing);
      expect(_opacitaIniziali(tester), 0.70);
      expect(_tipo(tester), BaTipoGlifo.bloccata);
    });

    testWidgets('un solo disco: bloccata > mutata > microfono spento', (tester) async {
      await tester.pumpWidget(_app(_p(microfonoSpento: true)));
      expect(_tipo(tester), BaTipoGlifo.microfono);
      await tester.pumpWidget(_app(_p(microfonoSpento: true, mutata: true)));
      expect(_glifo(), findsOneWidget);
      expect(_tipo(tester), BaTipoGlifo.altoparlante);
      await tester.pumpWidget(_app(_p(microfonoSpento: true, mutata: true, bloccata: true)));
      expect(_glifo(), findsOneWidget);
      expect(_tipo(tester), BaTipoGlifo.bloccata);
    });

    testWidgets('persa è un filtro sopra: la bloccata resta neutra, il disco si attenua insieme',
        (tester) async {
      await tester.pumpWidget(_app(_p(bloccata: true, persa: true, parla: true, haLaParola: true)));
      await _avanza(tester, 300);
      expect(_gradiente(tester).colors, BaColorTokens.neutroBloccata);
      final persa = find.byWidgetPredicate(
        (w) => w is Opacity && w.opacity == BaPresenzaTokens.persaOpacita,
      );
      expect(persa, findsOneWidget);
      // Sagoma, disco e tacca stanno sotto lo stesso filtro.
      for (final dentro in [_sagoma(), _glifo(), _tacca()]) {
        expect(find.descendant(of: persa, matching: dentro), findsOneWidget);
      }
      expect(find.descendant(of: persa, matching: find.byType(ColorFiltered)), findsOneWidget);
      expect(_anello(tester), isFalse);
    });

    testWidgets('persa sopra la mutata: i due filtri si compongono', (tester) async {
      await tester.pumpWidget(_app(_p(mutata: true, persa: true)));
      expect(find.byType(ColorFiltered), findsNWidgets(2));
      expect(_tipo(tester), BaTipoGlifo.altoparlante);
    });

    testWidgets('lo scheletro batte tutto', (tester) async {
      await tester.pumpWidget(_app(_p(
        scheletro: true,
        bloccata: true,
        mutata: true,
        microfonoSpento: true,
        haLaParola: true,
        persa: true,
        parla: true,
      )));
      expect(_glifo(), findsNothing);
      expect(_tacca(), findsNothing);
      expect(find.text('MB'), findsNothing);
      expect(find.byType(ColorFiltered), findsNothing);
      expect(_gradiente(tester).colors, isNot(BaColorTokens.neutroBloccata));
      expect(_anello(tester), isFalse);
    });
  });

  group('disco', () {
    for (final d in _diametri) {
      testWidgets('a ${d.toInt()} dp: diametro badgeDiametro, centro a 0,854 × d', (tester) async {
        await tester.pumpWidget(_app(_p(microfonoSpento: true), d: d));
        expect(tester.getSize(_disco()), Size.square(BaPresenzaTokens.badgeDiametro(d)));
        final sagoma = tester.getTopLeft(_sagoma());
        final centro = tester.getCenter(_disco()) - sagoma;
        expect(centro.dx, closeTo(BaPresenzaTokens.badgeCentro * d, 1e-6));
        expect(centro.dy, closeTo(BaPresenzaTokens.badgeCentro * d, 1e-6));
      });
    }

    test('il diametro cresce con la presenza, fra 28 e 44', () {
      expect(BaPresenzaTokens.badgeDiametro(88), 28);
      expect(BaPresenzaTokens.badgeDiametro(208), closeTo(41.6, 1e-9));
      for (final d in _diametri) {
        expect(BaPresenzaTokens.badgeDiametro(d), inInclusiveRange(28, 44));
      }
    });

    for (final d in _diametri) {
      testWidgets('a ${d.toInt()} dp: bordo badgeBordo, glifo grande quanto il disco dentro il bordo',
          (tester) async {
        await tester.pumpWidget(_app(_p(microfonoSpento: true), d: d));
        final bordo = ((_decoDisco(tester).border! as Border).top).width;
        expect(bordo, BaPresenzaTokens.badgeBordo);
        expect(BaPresenzaTokens.badgeBordo, 1.5);
        // Le proporzioni dei glifi sono in frazione del lato misurato dentro il bordo.
        final dentro = BaPresenzaTokens.badgeDiametro(d) - 2 * BaPresenzaTokens.badgeBordo;
        expect(tester.getSize(_glifo()), Size.square(dentro));
        // E il glifo è centrato nel disco.
        expect(tester.getCenter(_glifo()).dx, closeTo(tester.getCenter(_disco()).dx, 1e-6));
        expect(tester.getCenter(_glifo()).dy, closeTo(tester.getCenter(_disco()).dy, 1e-6));
      });
    }

    testWidgets('altri: scuro; io: chiaro, solo per il microfono', (tester) async {
      Color bordo() => (_decoDisco(tester).border! as Border).top.color;

      await tester.pumpWidget(_app(_p(microfonoSpento: true)));
      expect(_decoDisco(tester).color, BaColorTokens.micSpentoFondo);
      expect(bordo(), BaColorTokens.micSpentoBordo);
      expect(tester.widget<BaGlifo>(_glifo()).tratto, BaColorTokens.micSpentoGlifo);

      await tester.pumpWidget(_app(_p(microfonoSpento: true, io: true)));
      expect(_decoDisco(tester).color, BaColorTokens.micSpentoIoFondo);
      expect(bordo(), BaColorTokens.voceKeyline);
      expect(tester.widget<BaGlifo>(_glifo()).tratto, BaColorTokens.micSpentoIoGlifo);
      expect(tester.widget<BaGlifo>(_glifo()).fondo, BaColorTokens.micSpentoIoFondo);

      // Mutata e bloccata usano sempre i colori «altri», anche per me.
      await tester.pumpWidget(_app(_p(mutata: true, io: true)));
      expect(_decoDisco(tester).color, BaColorTokens.micSpentoFondo);
      await tester.pumpWidget(_app(_p(bloccata: true, io: true)));
      expect(_decoDisco(tester).color, BaColorTokens.micSpentoFondo);
    });

    testWidgets('compare e sparisce in 140 ms', (tester) async {
      await tester.pumpWidget(_app(_p()));
      expect(_glifo(), findsNothing);
      await tester.pumpWidget(_app(_p(microfonoSpento: true)));
      await _avanza(tester, 70);
      final fade = find.ancestor(of: _glifo(), matching: find.byType(FadeTransition)).last;
      expect(tester.widget<FadeTransition>(fade).opacity.value, closeTo(0.5, 0.01));
      await tester.pump(const Duration(milliseconds: 71));
      expect(tester.widget<FadeTransition>(fade).opacity.value, 1.0);

      await tester.pumpWidget(_app(_p()));
      await _avanza(tester, 70);
      expect(_glifo(), findsOneWidget, reason: 'sta ancora uscendo');
      await tester.pump(const Duration(milliseconds: 71));
      expect(_glifo(), findsNothing);
    });

    testWidgets('con «riduci movimento» compare e sparisce subito', (tester) async {
      await tester.pumpWidget(_app(_p(), riduciMovimento: true));
      await tester.pumpWidget(_app(_p(microfonoSpento: true), riduciMovimento: true));
      await tester.pump();
      expect(_glifo(), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
      await tester.pumpWidget(_app(_p(), riduciMovimento: true));
      await tester.pump();
      expect(_glifo(), findsNothing);
    });

    testWidgets("l'area toccabile della presenza non cambia, e il disco non è toccabile da solo",
        (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(_p(onTap: () => tocchi++)));
      final senza = tester.getSize(find.byType(BaPresenza));
      await tester.pumpWidget(_app(_p(microfonoSpento: true, haLaParola: true, onTap: () => tocchi++)));
      expect(tester.getSize(find.byType(BaPresenza)), senza);
      expect(senza, Size.square(BaPresenza.ingombro(88)));
      // Toccare dove sta il disco tocca la presenza: il disco non ha tocco suo.
      await tester.tapAt(tester.getCenter(_disco()));
      expect(tocchi, 1);
      expect(find.descendant(of: _disco(), matching: find.byType(GestureDetector)), findsNothing);
      expect(find.descendant(of: _disco(), matching: find.byType(IgnorePointer)), findsWidgets);
    });

    testWidgets("fuori dalla semantica: l'etichetta la porta la presenza", (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_p(microfonoSpento: true, haLaParola: true)));
      expect(find.bySemanticsLabel('Marta B.'), findsOneWidget);
      expect(find.descendant(of: _disco(), matching: find.byType(ExcludeSemantics)), findsWidgets);
      expect(find.descendant(of: _tacca(), matching: find.byType(ExcludeSemantics)), findsOneWidget);
      semantica.dispose();
    });
  });

  group('tacca', () {
    for (final d in _diametri) {
      testWidgets('a ${d.toInt()} dp: larghezza 0,42 × d, altezza 6, sporge 9', (tester) async {
        await tester.pumpWidget(_app(_p(haLaParola: true), d: d));
        final sagoma = tester.getRect(_sagoma());
        final tacca = tester.getRect(_tacca());
        expect(tacca.width, closeTo(0.42 * d, 1e-6));
        expect(tacca.width, closeTo(BaPresenzaTokens.parolaTaccaRapporto * d, 1e-6));
        final deco = tester
            .widget<DecoratedBox>(find.descendant(of: _tacca(), matching: find.byType(DecoratedBox)))
            .decoration as BoxDecoration;
        final bordo = (deco.border! as Border).top.width;
        // 6 di tacca + il bordo su ciascun lato = 9 che sporgono.
        expect(tacca.height - 2 * bordo, BaPresenzaTokens.parolaTaccaAltezza);
        expect(BaPresenzaTokens.parolaTaccaAltezza, 6);
        expect(tacca.bottom - sagoma.bottom, BaPresenzaTokens.parolaTaccaSporge);
        expect(BaPresenzaTokens.parolaTaccaSporge, 9);
        expect(tacca.top, sagoma.bottom, reason: 'il bordo alto è a filo della sagoma');
        expect(tacca.center.dx, closeTo(sagoma.center.dx, 1e-6));
        expect((deco.border! as Border).top.color, BaColorTokens.parolaTaccaBordo);
        expect(deco.color, BaColorTokens.parolaTacca);
      });
    }

    testWidgets('non è tagliata: sporge oltre il riquadro e nessun ritaglio la copre', (tester) async {
      await tester.pumpWidget(_app(_p(haLaParola: true)));
      final presenza = tester.getRect(find.byType(BaPresenza));
      final tacca = tester.getRect(_tacca());
      expect(tacca.bottom, greaterThan(presenza.bottom), reason: 'sporge: 9 contro i 5 della banda');
      for (final ritaglio in [ClipRRect, ClipRect, ClipPath, ClipOval]) {
        expect(
          find.ancestor(
            of: _tacca(),
            matching: find.byWidgetPredicate((w) => w.runtimeType == ritaglio),
          ),
          findsNothing,
          reason: '$ritaglio taglierebbe la tacca',
        );
      }
    });

    testWidgets('è indipendente dal disco e dagli stati, tranne lo scheletro', (tester) async {
      await tester.pumpWidget(_app(_p(haLaParola: true)));
      expect(_tacca(), findsOneWidget);
      expect(_glifo(), findsNothing);
      await tester.pumpWidget(_app(_p(haLaParola: true, bloccata: true)));
      expect(_tacca(), findsOneWidget);
      expect(_glifo(), findsOneWidget);
      await tester.pumpWidget(_app(_p(haLaParola: true, microfonoSpento: true, io: true)));
      expect(_tacca(), findsOneWidget);
      expect(_glifo(), findsOneWidget);
      await tester.pumpWidget(_app(_p()));
      expect(_tacca(), findsNothing);
      await tester.pumpWidget(_app(_p(haLaParola: true, scheletro: true)));
      expect(_tacca(), findsNothing);
    });

    testWidgets("chi parla ha anello e tacca insieme", (tester) async {
      await tester.pumpWidget(_app(_p(parla: true, haLaParola: true)));
      await tester.pump();
      expect(_anello(tester), isTrue);
      expect(_tacca(), findsOneWidget);
    });
  });
}
