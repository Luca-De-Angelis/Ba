import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/riga_impostazione.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';
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

// Si tocca il bersaglio che contiene il testo (la riga, l'interruttore), non il centro del testo: il centro
// di «SPENTO» non cade sul suo testo e flutter_test avviserebbe che il tocco non colpisce il widget cercato.
Future<void> _tocca(WidgetTester tester, String testo) async {
  final testoF = find.text(testo).first;
  final bersaglio = find.ancestor(of: testoF, matching: find.byType(BaTouchable));
  final f = bersaglio.evaluate().isNotEmpty ? bersaglio.first : testoF;
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pump();
}

Future<void> _accesa(WidgetTester tester) async {
  tester.view.physicalSize = const Size(900, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const GalleriaApp());
  await tester.pump();
  await _tocca(tester, 'Scoperta');
  await _tocca(tester, 'SPENTO');
  await tester.pump(const Duration(milliseconds: 300));
  await _tocca(tester, 'Accendi');
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  setUpAll(_caricaFont);

  // Un solo avvio della galleria e un solo caricamento del font: le tre misure seguono il tasto del testo
  // della galleria (1,0 di partenza, poi 1,4, poi 2,0); la schermata è già a 360 dp.
  testWidgets('a 360 dp: con 1,0 «Spegni» sta a destra, in alto accanto al titolo; con 1,4 e 2,0 sotto la frase, a sinistra', (tester) async {
    await _accesa(tester);
    expect(find.byType(BaRigaImpostazione), findsOneWidget, reason: 'la galleria usa .stato');
    expect(find.text('Spegni'), findsOneWidget);

    // passo: testo 1,0
    var titolo = tester.getRect(find.text(_titolo));
    var azione = tester.getRect(find.widgetWithText(BaPillola, 'Spegni'));
    expect(azione.left, greaterThanOrEqualTo(titolo.right), reason: 'a destra del titolo');
    expect(azione.top, closeTo(titolo.top, 0.5), reason: 'stessa altezza del titolo');
    expect(azione.right, tester.getRect(find.byType(BaRigaImpostazione)).right, reason: 'al bordo destro della riga');
    expect(azione.height, lessThan(BaControlloTokens.areaMinima + 16), reason: 'altezza naturale');
    expect(azione.height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));

    // passi: testo 1,4 e 2,0
    for (final (tasto, testo) in [('Testo 1,0', 1.4), ('Testo 1,4', BaScalaTokens.maxTesto)]) {
      await _tocca(tester, tasto);
      titolo = tester.getRect(find.text(_titolo));
      final frase = tester.getRect(find.text('Compari fra le persone da invitare.'));
      azione = tester.getRect(find.widgetWithText(BaPillola, 'Spegni'));
      expect(azione.top, greaterThanOrEqualTo(frase.bottom), reason: 'sotto la frase a $testo');
      expect(azione.left, titolo.left, reason: 'a sinistra a $testo');
      expect(azione.height, lessThan(BaControlloTokens.areaMinima * testo + 40), reason: 'altezza naturale a $testo');
    }
    expect(tester.takeException(), isNull);
  });
}

