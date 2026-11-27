import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/punto_aggancio.dart';
import 'package:ba/design_system/richiesta_permesso.dart';
import 'package:ba/design_system/riga_den.dart';
import 'package:ba/design_system/riga_persona.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/galleria/main_galleria.dart';

// La pagina «Scoperta» della galleria (task 034): le righe e i fogli del 031, sulla schermata finta.
// Il file è nuovo: `galleria_test.dart` non cambia.

Future<void> _tocca(WidgetTester tester, String testo) async {
  final f = find.text(testo);
  await tester.ensureVisible(f.first);
  await tester.tap(f.first);
  await tester.pump();
  expect(tester.takeException(), isNull, reason: "dopo «$testo»");
}

Future<void> _apri(WidgetTester tester) async {
  tester.view.physicalSize = const Size(900, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const GalleriaApp());
  await tester.pump();
  await _tocca(tester, 'Scoperta');
}

Future<void> _sale(WidgetTester tester) => tester.pump(const Duration(milliseconds: 300));

void main() {
  testWidgets('le righe di «Proposti per te»: il motivo, «zona abituale» nel marcatore, e la riga di sempre senza motivo', (tester) async {
    await _apri(tester);
    expect(find.text('Perché: tema Cucina'), findsOneWidget);
    expect(find.text('Perché: in italiano'), findsOneWidget);
    expect(find.text('Perché: tema Musica'), findsOneWidget);
    expect(find.text('ZONA ABITUALE · ENTRA CHIUNQUE · 3 SUL PALCO'), findsOneWidget);
    expect(find.text('VICINO A TE · ENTRA CHIUNQUE · 2 SUL PALCO'), findsOneWidget);
    final righe = tester.widgetList<BaRigaDen>(find.byType(BaRigaDen)).toList();
    expect(righe.where((r) => r.motivo != null), hasLength(3));
    expect(righe.where((r) => r.motivo == null), hasLength(1), reason: '«Aperti ora»: la riga di sempre');
  });

  testWidgets('il testo corretto: «Per ora non ci sono proposte.», non «Niente di nuovo per ora.»', (tester) async {
    await _apri(tester);
    expect(find.text('Per ora non ci sono proposte. Scegli un tema o una lingua e ne compaiono.'), findsOneWidget);
    expect(find.textContaining('Niente di nuovo'), findsNothing);
  });

  testWidgets('tre punti di aggancio, con il nome della sezione e il codice: non si toccano e non hanno semantica d\'azione', (tester) async {
    final semantica = tester.ensureSemantics();
    await _apri(tester);
    expect(find.byType(BaPuntoAggancio), findsNWidgets(3));
    for (final (titolo, codice) in [('In evidenza ora', 'G14'), ('Avvisi per tema o lingua', 'G07'), ('DEN preferiti', 'G13')]) {
      expect(find.text(titolo), findsOneWidget);
      expect(find.text(codice), findsOneWidget);
      expect(find.bySemanticsLabel('$titolo. $codice'), findsOneWidget);
    }
    expect(find.descendant(of: find.byType(BaPuntoAggancio), matching: find.byType(BaPillola)), findsNothing);
    semantica.dispose();
  });

  testWidgets('le persone disponibili: «● Disponibile» con la parola, in ordine alfabetico, e «Invita» passa a «Nell\'invito»', (tester) async {
    await _apri(tester);
    final persone = tester.widgetList<BaRigaPersona>(find.byType(BaRigaPersona)).toList();
    expect(persone.map((p) => p.nome), ['Davide', 'Marta', 'Sara'], reason: 'alfabetico, nessun conteggio');
    expect(persone.every((p) => p.disponibile == 'Disponibile'), isTrue, reason: 'sempre la parola');
    expect(find.text('Disponibile'), findsNWidgets(3));
    await _tocca(tester, 'Invita');
    expect(find.text('Nell\'invito'), findsOneWidget);
    expect(find.text('Invita'), findsNWidgets(2));
  });

  testWidgets('«Disponibile a chiacchierare»: la conferma ha la frase corretta, «Accendi» accende, «Spegni» spegne, «Non ora» no', (tester) async {
    await _apri(tester);
    expect(find.text('Sei disponibile a chiacchierare'), findsNothing);
    await _tocca(tester, 'SPENTO');
    await _sale(tester);
    expect(find.byType(BaFoglio), findsOneWidget);
    expect(find.text('Essere disponibile a chiacchierare'), findsOneWidget);
    expect(find.text('Ti trova solo chi può trovarti secondo «Chi può trovarmi»: la visibilità non si allarga da sola.'), findsOneWidget);
    expect(find.textContaining('chi puoi essere trovato'), findsNothing, reason: 'la frase sbagliata del prototipo non c\'è');

    await _tocca(tester, 'Non ora');
    await _sale(tester);
    expect(find.text('Sei disponibile a chiacchierare'), findsNothing, reason: '«Non ora» non accende');

    await _tocca(tester, 'SPENTO');
    await _sale(tester);
    await _tocca(tester, 'Accendi');
    await _sale(tester);
    expect(find.text('Sei disponibile a chiacchierare'), findsOneWidget);
    expect(find.text('Compari fra le persone da invitare.'), findsOneWidget);
    await _tocca(tester, 'Spegni');
    expect(find.text('Sei disponibile a chiacchierare'), findsNothing);
    expect(find.text('Disponibile a chiacchierare'), findsOneWidget);
  });

  testWidgets('la riga di stato non si dice «negata» per lo screen reader: legge solo il titolo e la frase', (tester) async {
    final semantica = tester.ensureSemantics();
    await _apri(tester);
    await _tocca(tester, 'SPENTO');
    await _sale(tester);
    await _tocca(tester, 'Accendi');
    await _sale(tester);
    expect(find.bySemanticsLabel('Sei disponibile a chiacchierare. Compari fra le persone da invitare.'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('negat', caseSensitive: false)), findsNothing);
    expect(find.bySemanticsLabel('Spegni'), findsOneWidget);
    semantica.dispose();
  });

  group('il permesso: avvisi e posizione', () {
    final aperture = <String, (String, String)>{
      'Avvisi: la richiesta': ('Avvisi sui DEN', 'Non ora'),
      'Avvisi: dopo il rifiuto': ('Avvisi spenti', 'Chiudi'),
      'Posizione: la richiesta': ('Usa la posizione', 'Non ora'),
      'Posizione: dopo il rifiuto': ('Posizione', 'Chiudi'),
    };

    testWidgets('ogni foglio si apre col suo titolo, ha le sue azioni alla pari e si chiude', (tester) async {
      await _apri(tester);
      for (final MapEntry(key: apertura, value: (titolo, chiusura)) in aperture.entries) {
        await _tocca(tester, apertura);
        await _sale(tester);
        expect(find.byType(BaRichiestaPermesso), findsOneWidget, reason: apertura);
        expect(find.descendant(of: find.byType(BaFoglio), matching: find.text(titolo)), findsOneWidget, reason: apertura);
        final varianti = tester.widgetList<BaPillola>(find.descendant(of: find.byType(BaFoglio), matching: find.byType(BaPillola))).map((p) => p.variante);
        expect(varianti, isNot(contains(BaVariantePillola.chiara)), reason: '$apertura: nessuna chiara');
        await _tocca(tester, chiusura);
        await _sale(tester);
        expect(find.byType(BaFoglio), findsNothing, reason: 'dopo «$chiusura»');
      }
    });

    testWidgets('«Avvisi: la richiesta» ha «Consenti» e «Non ora» alla pari; il rifiuto non ha colpa', (tester) async {
      await _apri(tester);
      await _tocca(tester, 'Avvisi: la richiesta');
      await _sale(tester);
      expect(find.text('Consenti'), findsOneWidget);
      expect(tester.widget<BaPillola>(find.widgetWithText(BaPillola, 'Consenti')).variante, tester.widget<BaPillola>(find.widgetWithText(BaPillola, 'Non ora')).variante);
      await _tocca(tester, 'Non ora');
      await _sale(tester);
      await _tocca(tester, 'Avvisi: dopo il rifiuto');
      await _sale(tester);
      expect(find.text('Va bene così. Gli avvisi sui DEN restano spenti.'), findsOneWidget);
      expect(find.text('Apri le impostazioni del telefono'), findsOneWidget);
    });
  });

  testWidgets('regge 744, il testo 1,4 e 2,0 e «riduci movimento»: nessuna eccezione, in ogni foglio', (tester) async {
    await _apri(tester);
    expect(find.text('Testo 1,0'), findsOneWidget);
    await _tocca(tester, 'Testo 1,0');
    expect(find.text('Testo 1,4'), findsOneWidget, reason: 'il secondo giro è 1,4');
    for (final c in ['Larghezza 360', 'Riduci movimento']) {
      await _tocca(tester, c);
    }
    for (var giro = 0; giro < 2; giro++) {
      for (final apertura in ['Avvisi: la richiesta', 'Avvisi: dopo il rifiuto', 'Posizione: la richiesta', 'Posizione: dopo il rifiuto']) {
        await _tocca(tester, apertura);
        await tester.pump();
        expect(find.byType(BaFoglio), findsOneWidget, reason: apertura);
        expect(tester.takeException(), isNull, reason: apertura);
        await _tocca(tester, find.text('Chiudi').evaluate().isNotEmpty ? 'Chiudi' : 'Non ora');
        await tester.pump();
      }
      // I giri: da 1,4 a 2,0, poi da 2,0 a 1,0.
      final adesso = giro == 0 ? 'Testo 1,4' : 'Testo 2,0';
      final dopo = giro == 0 ? 'Testo 2,0' : 'Testo 1,0';
      await _tocca(tester, adesso);
      expect(find.text(dopo), findsOneWidget, reason: 'dopo $adesso');
    }
    expect(tester.takeException(), isNull);
    expect(BaScalaTokens.maxTesto, 2.0);
  });
}
