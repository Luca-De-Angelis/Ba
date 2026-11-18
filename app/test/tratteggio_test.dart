// Il tratteggio si prova sui PIXEL, come i glifi: nessuna immagine di
// riferimento. Si disegna, si legge l'alfa lungo un lato e si controlla che
// alterni tratti e vuoti; un bordo pieno non alternerebbe mai.
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/tratteggio.dart';

const _chiave = ValueKey('tratteggio');
const double _larghezza = 160;
const double _altezza = 60;

Widget _app({double spessore = 1, double raggio = BaRaggioTokens.riquadro, Widget? figlio}) => Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: RepaintBoundary(
          key: _chiave,
          child: BaTratteggio(
            spessore: spessore,
            raggio: raggio,
            child: figlio ?? const SizedBox(width: _larghezza, height: _altezza),
          ),
        ),
      ),
    );

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

/// Le volte che l'alfa passa da «c'è» a «non c'è» lungo la riga [y], nel tratto
/// dritto del lato (fuori dagli angoli).
int _salti(Uint8List alfa, int y, {required int da, required int a}) {
  var salti = 0;
  var prima = alfa[y * _larghezza.toInt() + da] > 40;
  for (var x = da + 1; x < a; x++) {
    final ora = alfa[y * _larghezza.toInt() + x] > 40;
    if (prima && !ora) salti++;
    prima = ora;
  }
  return salti;
}

void main() {
  testWidgets('lungo un lato alterna tratti e vuoti', (tester) async {
    await tester.pumpWidget(_app());
    final alfa = await _alfa(tester);
    final raggio = BaRaggioTokens.riquadro.toInt();
    final salti = _salti(alfa, 0, da: raggio, a: _larghezza.toInt() - raggio);
    // Un lato di ~128 dp con tratti da 6 e vuoti da 4: più di dieci vuoti.
    expect(salti, greaterThan(8), reason: 'un bordo pieno darebbe 0');
    // E ci sono davvero dei vuoti: pixel senza niente sul lato dritto.
    final vuoti = [
      for (var x = raggio; x < _larghezza.toInt() - raggio; x++)
        if (alfa[x] == 0) x,
    ];
    expect(vuoti, isNotEmpty);
  });

  testWidgets('tratto e vuoto vengono dalla scala dello spazio', (tester) async {
    expect(BaTratteggio.tratto, BaSpazioTokens.xs);
    expect(BaTratteggio.vuoto, BaSpazioTokens.xxs);
  });

  testWidgets('il colore è quello dato e lo spessore è quello dato', (tester) async {
    await tester.pumpWidget(_app(spessore: 2));
    final alfa = await _alfa(tester);
    // A spessore 2 il tratto sta sulle righe 0 e 1 del lato in alto.
    expect(alfa.sublist(0, _larghezza.toInt()).any((a) => a > 40), isTrue);
    expect(alfa.sublist(_larghezza.toInt(), 2 * _larghezza.toInt()).any((a) => a > 40), isTrue);
    expect(alfa.sublist(3 * _larghezza.toInt() + 30, 4 * _larghezza.toInt() - 30).every((a) => a == 0), isTrue,
        reason: 'dentro il bordo non c\'è niente');
  });

  testWidgets('il bordo sta sopra al contenuto e non lo sposta', (tester) async {
    await tester.pumpWidget(_app(figlio: const SizedBox(key: ValueKey('dentro'), width: 100, height: 40)));
    expect(tester.getSize(find.byKey(const ValueKey('dentro'))), const Size(100, 40));
    expect(tester.getSize(find.byType(BaTratteggio)), const Size(100, 40));
  });

  testWidgets('a stadio con il raggio pillola e senza contenuto non fa eccezioni', (tester) async {
    await tester.pumpWidget(_app(raggio: BaRaggioTokens.pillola, figlio: const SizedBox(width: 44, height: 26)));
    expect(tester.takeException(), isNull);
  });

  testWidgets('non è toccabile e non è nella semantica', (tester) async {
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(_app());
    expect(find.descendant(of: find.byType(BaTratteggio), matching: find.byType(GestureDetector)), findsNothing);
    expect(find.descendant(of: find.byType(BaTratteggio), matching: find.byType(Focus)), findsNothing);
    expect(find.byType(Semantics).evaluate().where((e) => (e.widget as Semantics).properties.label != null), isEmpty);
    semantica.dispose();
  });

  testWidgets('.sopra disegna solo il lato in alto, tratteggiato', (tester) async {
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: RepaintBoundary(
          key: _chiave,
          child: const BaTratteggio.sopra(child: SizedBox(width: _larghezza, height: _altezza)),
        ),
      ),
    ));
    final alfa = await _alfa(tester);
    final w = _larghezza.toInt();
    expect(_salti(alfa, 0, da: 4, a: w - 4), greaterThan(8), reason: 'in alto alterna');
    // Né i lati né il fondo: tutto il resto è vuoto.
    expect(alfa.sublist(w).every((a) => a == 0), isTrue, reason: 'sotto la prima riga non c\'è niente');
  });
}
