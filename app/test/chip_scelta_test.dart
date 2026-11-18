import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/chip_scelta.dart';
import 'package:ba/design_system/tokens.dart';

const _chiaveGruppo = ValueKey('gruppo');

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(alignment: Alignment.topLeft, child: SizedBox(width: larghezza, child: child)),
        ),
      ),
    );

/// Un gruppo di chip che vanno a capo, come lo compone chi li usa.
Widget _gruppo(List<String> testi, {int? scelto, void Function(int)? onTap}) => RepaintBoundary(
      key: _chiaveGruppo,
      child: Wrap(
        spacing: BaCreazioneTokens.chipGap,
        runSpacing: BaCreazioneTokens.chipGap,
        children: [
          for (var i = 0; i < testi.length; i++)
            BaChipScelta(testo: testi[i], scelto: i == scelto, onTap: () => onTap?.call(i)),
        ],
      ),
    );

const _temi = ['Cucina', 'Musica', 'Sport', 'Libri', 'Viaggi', 'Cinema', 'Notte'];

Finder _spunte() => find.descendant(
      of: find.byType(BaChipScelta),
      matching: find.byWidgetPredicate((w) => w is CustomPaint && w.painter != null),
    );

void main() {
  group('scelto e non scelto', () {
    testWidgets('scelto: bordo spesso e segno di spunta; non scelto: bordo sottile, niente spunta', (tester) async {
      await tester.pumpWidget(_app(_gruppo(['Cucina', 'Musica'], scelto: 0)));
      expect(_spunte(), findsOneWidget);
      final bordi = [
        for (final c in tester.widgetList<Container>(find.descendant(
          of: find.byType(BaChipScelta),
          matching: find.byWidgetPredicate((w) => w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null),
        )))
          ((c.decoration! as BoxDecoration).border! as Border).top.width,
      ];
      expect(bordi, [BaCreazioneTokens.sceltaBordoScelta, BaCreazioneTokens.sceltaBordo]);
    });

    testWidgets('la spunta NON è un carattere: nessun «✓» nell\'albero, non dipende da un font', (tester) async {
      await tester.pumpWidget(_app(_gruppo(['Cucina', 'Musica'], scelto: 1)));
      expect(find.text('✓'), findsNothing);
      expect(find.textContaining('✓'), findsNothing);
      expect(find.textContaining('✔'), findsNothing);
      final testi = tester.widgetList<Text>(find.descendant(of: find.byType(BaChipScelta), matching: find.byType(Text))).map((t) => t.data).toList();
      expect(testi, ['Cucina', 'Musica']);
    });

    testWidgets('la spunta è un disegno di due tratti, con il tratto e il colore dei token', (tester) async {
      await tester.pumpWidget(_app(_gruppo(['Cucina'], scelto: 0)));
      expect(
        _spunte(),
        paints..path(color: BaColorTokens.testoPrimo, strokeWidth: BaCreazioneTokens.sceltaBordoScelta, style: PaintingStyle.stroke),
      );
      expect(tester.getSize(_spunte()), const Size.square(BaSpazioTokens.l));
    });

    testWidgets('la spunta si vede davvero: pixel dipinti nel suo riquadro', (tester) async {
      await tester.pumpWidget(_app(_gruppo(['Cucina'], scelto: 0)));
      final confine = tester.renderObject<RenderRepaintBoundary>(find.byKey(_chiaveGruppo));
      final riquadro = tester.getRect(_spunte()).shift(-tester.getTopLeft(find.byKey(_chiaveGruppo)));
      final byte = await tester.runAsync(() async {
        final img = await confine.toImage(pixelRatio: 1);
        final dati = await img.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
        final larghezza = img.width;
        img.dispose();
        return (dati!, larghezza);
      });
      final (dati, larghezza) = byte!;
      var dipinti = 0;
      for (var y = riquadro.top.floor(); y < riquadro.bottom.ceil(); y++) {
        for (var x = riquadro.left.floor(); x < riquadro.right.ceil(); x++) {
          final a = Uint8List.view(dati.buffer)[(y * larghezza + x) * 4 + 3];
          if (a > 100) dipinti++;
        }
      }
      expect(dipinti, greaterThan(15), reason: 'i due tratti della spunta hanno pixel pieni');
    });
  });

  group('tocco', () {
    testWidgets('chiama onTap', (tester) async {
      final toccati = <int>[];
      await tester.pumpWidget(_app(_gruppo(['Cucina', 'Musica'], onTap: toccati.add)));
      await tester.tap(find.text('Musica'));
      expect(toccati, [1]);
    });

    testWidgets('ogni chip è alto almeno chipAltezza (48 ≥ 44)', (tester) async {
      await tester.pumpWidget(_app(_gruppo(_temi, scelto: 2)));
      for (var i = 0; i < _temi.length; i++) {
        final r = tester.getRect(find.byType(BaChipScelta).at(i));
        expect(r.height, greaterThanOrEqualTo(BaCreazioneTokens.chipAltezza), reason: _temi[i]);
        expect(r.height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
      }
      expect(BaCreazioneTokens.chipAltezza, 48);
    });
  });

  group('vanno a capo', () {
    testWidgets('sette chip non stanno in una riga a 320 dp: vanno a capo a distanza chipGap', (tester) async {
      await tester.pumpWidget(_app(_gruppo(_temi), larghezza: 320));
      final righe = {for (var i = 0; i < _temi.length; i++) tester.getRect(find.byType(BaChipScelta).at(i)).top.round()};
      expect(righe.length, greaterThan(1));
      final primo = tester.getRect(find.byType(BaChipScelta).at(0));
      final secondo = tester.getRect(find.byType(BaChipScelta).at(1));
      expect(secondo.left - primo.right, BaCreazioneTokens.chipGap);
      expect(BaCreazioneTokens.chipGap, 8);
    });

    testWidgets('a testo 2,0 la riga cresce e nessun chip si taglia né fa overflow', (tester) async {
      await tester.pumpWidget(_app(_gruppo(_temi, scelto: 0)));
      final alto1 = tester.getSize(find.byKey(_chiaveGruppo)).height;
      await tester.pumpWidget(_app(_gruppo(_temi, scelto: 0), testo: 2.0));
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byKey(_chiaveGruppo)).height, greaterThan(alto1));
      for (var i = 0; i < _temi.length; i++) {
        final chip = tester.getRect(find.byType(BaChipScelta).at(i));
        final testo = tester.getRect(find.text(_temi[i]));
        expect(chip.contains(testo.topLeft) && chip.contains(testo.bottomRight - const Offset(0.01, 0.01)), isTrue, reason: _temi[i]);
        expect(chip.right, lessThanOrEqualTo(360));
      }
    });
  });

  group('semantica', () {
    testWidgets('bottone selezionato se scelto, non selezionato se no', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_gruppo(['Cucina', 'Musica'], scelto: 0, onTap: (_) {})));
      expect(
        tester.getSemantics(find.text('Cucina')),
        matchesSemantics(
          label: 'Cucina',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasSelectedState: true,
          isSelected: true,
        ),
      );
      expect(
        tester.getSemantics(find.text('Musica')),
        matchesSemantics(
          label: 'Musica',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasSelectedState: true,
          isSelected: false,
        ),
      );
      semantica.dispose();
    });
  });
}
