import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/riga_impostazione.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/galleria/main_galleria.dart';

// La riga di stato della disponibilità nella galleria «Scoperta», con il **font vero** e la larghezza
// reale della pagina (task 034): il test con Ahem di `galleria_scoperta_test.dart` non dimostra dove sta
// «Spegni». Import oltre widgets.dart solo qui: `services.dart` per `FontLoader` e `rootBundle`.

const _titolo = 'Sei disponibile a chiacchierare';

Future<void> _caricaFont() async {
  for (final nome in ['Regular', 'Medium', 'SemiBold']) {
    final f = FontLoader('Instrument Sans')..addFont(rootBundle.load('assets/fonts/instrument-sans/InstrumentSans-$nome.ttf'));
    await f.load();
  }
}

Future<void> _tocca(WidgetTester tester, String testo) async {
  final f = find.text(testo).first;
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pump();
}

Future<void> _accesa(WidgetTester tester, {required int giri}) async {
  tester.view.physicalSize = const Size(900, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const GalleriaApp());
  await tester.pump();
  await _tocca(tester, 'Scoperta');
  // La galleria ha il suo tasto del testo: 1,0 (di partenza), poi 1,4, poi 2,0; la schermata è già a 360 dp.
  for (var i = 0; i < giri; i++) {
    await _tocca(tester, ['Testo 1,0', 'Testo 1,4'][i]);
  }
  await _tocca(tester, 'SPENTO');
  await tester.pump(const Duration(milliseconds: 300));
  await _tocca(tester, 'Accendi');
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  setUpAll(_caricaFont);

  testWidgets('la galleria usa .stato per la riga di stato', (tester) async {
    await _accesa(tester, giri: 0);
    expect(find.byType(BaRigaImpostazione), findsOneWidget);
    expect(find.text('Spegni'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a 360 dp e testo 1,0 «Spegni» sta a destra, in alto accanto al titolo, e non si allunga', (tester) async {
    await _accesa(tester, giri: 0);
    final titolo = tester.getRect(find.text(_titolo));
    final azione = tester.getRect(find.widgetWithText(BaPillola, 'Spegni'));
    expect(azione.left, greaterThanOrEqualTo(titolo.right), reason: 'a destra del titolo');
    expect(azione.top, closeTo(titolo.top, 0.5), reason: 'stessa altezza del titolo');
    expect(azione.right, tester.getRect(find.byType(BaRigaImpostazione)).right, reason: 'al bordo destro della riga');
    expect(azione.height, lessThan(BaControlloTokens.areaMinima + 16), reason: 'altezza naturale');
    expect(azione.height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
  });

  for (final (giri, testo) in [(1, 1.4), (2, BaScalaTokens.maxTesto)]) {
    testWidgets('a 360 dp e testo $testo «Spegni» sta sotto la frase, a sinistra', (tester) async {
      await _accesa(tester, giri: giri);
      final titolo = tester.getRect(find.text(_titolo));
      final frase = tester.getRect(find.text('Compari fra le persone da invitare.'));
      final azione = tester.getRect(find.widgetWithText(BaPillola, 'Spegni'));
      expect(azione.top, greaterThanOrEqualTo(frase.bottom), reason: 'sotto la frase');
      expect(azione.left, titolo.left, reason: 'a sinistra');
      expect(azione.height, lessThan(BaControlloTokens.areaMinima * testo + 40));
    });
  }
}
