import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/presenza.dart';
import 'package:ba/galleria/main_galleria.dart';

Future<void> _tocca(WidgetTester tester, String testo) async {
  final f = find.text(testo);
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pump();
  expect(tester.takeException(), isNull, reason: "dopo «$testo»");
}

void main() {
  testWidgets('la galleria di BaTouchable si costruisce a 360 e a 744, con le aree e senza movimento',
      (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    expect(find.text('BaTouchable'), findsWidgets);

    // I tre controlli di sviluppo: nessuna eccezione di layout.
    await _tocca(tester, 'Mostra le aree toccabili');
    await _tocca(tester, 'Riduci movimento');
    await _tocca(tester, 'Larghezza 360');
    expect(find.text('Larghezza 744'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('la pagina delle presenze: 5 diametri, 12 tinte, 5 sagome e tutti i controlli',
      (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPresenza');
    expect(find.byType(BaPresenza), findsNWidgets(5 + 12 + 5));

    for (final c in [
      'Parla',
      'Ampiezza 0,5',
      'Ampiezza 1',
      'Voci 2',
      'Voci 3',
      'Linea instabile',
      'Persa',
      'Scheletro',
      'Immagine fallita',
      'Riduci movimento',
    ]) {
      await _tocca(tester, c);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: c);
    }

    // Simula voce: una ampiezza nuova a ogni campionamento. Si spegne per
    // fermare il timer.
    await _tocca(tester, 'Simula voce');
    await tester.pump(const Duration(milliseconds: 600));
    await _tocca(tester, 'Simula voce');
    expect(tester.takeException(), isNull);
  });

  testWidgets('toccare una presenza aggiorna il conteggio', (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPresenza');
    expect(find.textContaining('TOCCHI: 0'), findsOneWidget);
    await tester.ensureVisible(find.byType(BaPresenza).first);
    await tester.pump();
    await tester.tap(find.byType(BaPresenza).first);
    await tester.pump();
    expect(find.textContaining('TOCCHI: 1'), findsOneWidget);
  });

  testWidgets('la pagina del palco: 1 persona a 208, 8 a 88, testo grande, 744, vuoto e lingue',
      (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPalco');

    double diametro() =>
        tester.getSize(find.byType(BaPresenza).first).width - 2 * BaPresenza.banda;

    // Una persona, testo normale: a 208 dp.
    expect(find.byType(BaPresenza), findsOneWidget);
    expect(diametro(), 208);

    // Otto persone: 88.
    for (var i = 0; i < 7; i++) {
      await _tocca(tester, 'Persone +');
    }
    expect(find.byType(BaPresenza), findsNWidgets(8));
    expect(diametro(), 88);

    // Testo di sistema 2,0: il palco cede, nessuna presenza sparisce.
    await _tocca(tester, 'Testo 1,0');
    expect(find.byType(BaPresenza), findsNWidgets(8));
    expect(diametro(), lessThan(88));
    await _tocca(tester, 'Testo 2,0');

    // Tablet: presenze più grandi (otto: 132).
    await _tocca(tester, 'Larghezza 360');
    expect(diametro(), 132);
    await _tocca(tester, 'Larghezza 744');

    // Gli stati e i controlli, senza eccezioni.
    for (final c in [
      'Parlano: 0',
      'Parlano: 1',
      'Persa',
      'Scheletro',
      'Congelato',
      'Riduci movimento',
    ]) {
      await _tocca(tester, c);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: c);
    }

    // Palco vuoto: l'invito, nelle cinque lingue.
    await _tocca(tester, 'Congelato');
    await _tocca(tester, 'Persone −');
    for (var i = 0; i < 7; i++) {
      await _tocca(tester, 'Persone −');
    }
    expect(find.byType(BaPresenza), findsNothing);
    expect(find.text('Il palco è libero.'), findsOneWidget);
    // Ogni pressione passa alla lingua successiva: IT → EN → FR → ES → DE.
    for (final (da, lingua, testo) in [
      ('IT', 'EN', 'The stage is free.'),
      ('EN', 'FR', 'La scène est libre.'),
      ('FR', 'ES', 'El escenario está libre.'),
      ('ES', 'DE', 'Die Bühne ist frei.'),
    ]) {
      await _tocca(tester, 'Lingua: $da');
      expect(find.text(testo), findsOneWidget, reason: lingua);
    }
    expect(tester.takeException(), isNull);
  });
}
