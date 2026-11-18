// I tratti chiari dei glifi (task 021b): dove due tratti semitrasparenti si
// incrociano non devono lasciare punti più chiari. Si prova sui PIXEL, senza
// immagini di riferimento: si disegna il glifo, si legge l'alfa di ogni pixel e
// si controlla che nessun punto superi quella di un tratto isolato (`glifoTratto`).
// Prima del ritocco due tratti sovrapposti davano 1 − (1 − .62)² ≈ .86.
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/glifo.dart';
import 'package:ba/design_system/tokens.dart';

const double _lato = 120;
const _chiave = ValueKey('glifo');

/// Il glifo, da solo su sfondo trasparente, senza casing visibile (`fondo`
/// trasparente): l'alfa di ogni pixel è quella dei soli tratti chiari.
Widget _app(BaTipoGlifo tipo) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(400, 400)),
        child: Align(
          alignment: Alignment.topLeft,
          child: RepaintBoundary(
            key: _chiave,
            child: BaGlifo(
              tipo: tipo,
              acceso: true,
              lato: _lato,
              fondo: const Color(0x00000000),
            ),
          ),
        ),
      ),
    );

/// L'alfa (0–255) di ogni pixel del glifo, riga per riga.
Future<Uint8List> _alfa(WidgetTester tester) async {
  final confine = tester.renderObject<RenderRepaintBoundary>(find.byKey(_chiave));
  final byte = await tester.runAsync(() async {
    final immagine = await confine.toImage(pixelRatio: 1);
    final dati = await immagine.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
    immagine.dispose();
    return dati!;
  });
  final rgba = byte!;
  return Uint8List.fromList([for (var i = 3; i < rgba.lengthInBytes; i += 4) rgba.getUint8(i)]);
}

int get _alfaTratto => (BaColorTokens.glifoTratto.a * 255).round();

void main() {
  testWidgets('cerchio barrato: all\'incrocio della barra con l\'anello l\'alfa è quella di un tratto solo',
      (tester) async {
    await tester.pumpWidget(_app(BaTipoGlifo.bloccata));
    final alfa = await _alfa(tester);
    final massimo = alfa.reduce(math.max);
    expect(massimo, lessThanOrEqualTo(_alfaTratto + 1), reason: 'nessun punto più chiaro di un tratto isolato');
    expect(massimo, greaterThanOrEqualTo(_alfaTratto - 1), reason: 'e i tratti ci sono');
  });

  for (final tipo in [BaTipoGlifo.microfono, BaTipoGlifo.altoparlante]) {
    testWidgets('$tipo: nel corpo del glifo (fuori dalla barra) nessuna giuntura è più chiara', (tester) async {
      await tester.pumpWidget(_app(tipo));
      final alfa = await _alfa(tester);
      // La barra è la diagonale per il centro; il suo casing è largo barraAlone.
      // Si escludono i pixel entro il casing: lì il casing scuro copre il corpo.
      final rad = BaGlifoTokens.barraGradi * math.pi / 180;
      final nx = -math.sin(rad), ny = math.cos(rad); // normale alla barra
      final esclusione = BaGlifoTokens.barraAlone / 2 + 1.5;
      var massimo = 0;
      for (var y = 0; y < _lato; y++) {
        for (var x = 0; x < _lato; x++) {
          final distanza = ((x + .5 - _lato / 2) * nx + (y + .5 - _lato / 2) * ny).abs();
          if (distanza <= esclusione) continue;
          massimo = math.max(massimo, alfa[y * _lato.toInt() + x]);
        }
      }
      expect(massimo, lessThanOrEqualTo(_alfaTratto + 1), reason: 'giunture del corpo');
      expect(massimo, greaterThanOrEqualTo(_alfaTratto - 1), reason: 'e il corpo c\'è');
    });
  }

  group('struttura: i tratti chiari opachi dentro un livello', () {
    final opaco = BaColorTokens.glifoTratto.withValues(alpha: 1);
    Finder pittura() => find.descendant(of: find.byType(BaGlifo), matching: find.byType(CustomPaint));

    testWidgets('cerchio barrato: anello e barra opachi nello stesso livello, poi restore', (tester) async {
      await tester.pumpWidget(_app(BaTipoGlifo.bloccata));
      expect(
        pittura(),
        paints
          ..circle(color: opaco, strokeWidth: BaGlifoTokens.tratto)
          ..line(color: opaco, strokeWidth: BaGlifoTokens.tratto)
          ..restore(),
      );
      expect(opaco.a, 1.0);
      expect(BaColorTokens.glifoTratto.a, lessThan(1.0), reason: 'il token resta semitrasparente');
    });

    testWidgets('microfono: corpo opaco, chiusura del livello, casing scuro, barra opaca', (tester) async {
      await tester.pumpWidget(_app(BaTipoGlifo.microfono));
      expect(
        pittura(),
        paints
          ..rrect(color: opaco, strokeWidth: BaGlifoTokens.tratto)
          ..path(color: opaco, strokeWidth: BaGlifoTokens.tratto)
          ..line(color: opaco, strokeWidth: BaGlifoTokens.tratto)
          ..restore() // chiude il livello del corpo
          ..line(color: const Color(0x00000000), strokeWidth: BaGlifoTokens.barraAlone) // il casing, com'era
          ..line(color: opaco, strokeWidth: BaGlifoTokens.tratto)
          ..restore(),
      );
    });

    testWidgets('altoparlante: corpo, cono e onde opachi, poi il casing, poi la barra opaca', (tester) async {
      await tester.pumpWidget(_app(BaTipoGlifo.altoparlante));
      expect(
        pittura(),
        paints
          ..rect(color: opaco, style: PaintingStyle.fill)
          ..path(color: opaco, style: PaintingStyle.fill)
          ..arc(color: opaco, strokeWidth: BaGlifoTokens.tratto)
          ..arc(color: opaco, strokeWidth: BaGlifoTokens.tratto)
          ..restore()
          ..line(color: const Color(0x00000000), strokeWidth: BaGlifoTokens.barraAlone)
          ..line(color: opaco, strokeWidth: BaGlifoTokens.tratto)
          ..restore(),
      );
    });

    testWidgets('con un tratto già opaco (il disco «io») il colore resta lo stesso', (tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(400, 400)),
          child: Align(
            alignment: Alignment.topLeft,
            child: BaGlifo(
              tipo: BaTipoGlifo.bloccata,
              acceso: true,
              lato: _lato,
              tratto: BaColorTokens.micSpentoIoGlifo,
            ),
          ),
        ),
      ));
      expect(
        find.descendant(of: find.byType(BaGlifo), matching: find.byType(CustomPaint)),
        paints
          ..circle(color: BaColorTokens.micSpentoIoGlifo)
          ..line(color: BaColorTokens.micSpentoIoGlifo),
      );
    });
  });
}
