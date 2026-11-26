import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/foglio_passi.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/schermata_copertura.dart';
import 'package:ba/design_system/tokens.dart';

// L'account chiuso (task 029): B1, B1 bis e B2 del prototipo 027.

void _vista(WidgetTester tester, {double larghezza = 360, double altezza = 800, double testo = 1.0}) {
  tester.view.physicalSize = Size(larghezza, altezza);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = testo;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

Widget _app(Widget schermata) => WidgetsApp(
      color: BaColorTokens.fondoApp,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: schermata,
    );

const _b1 = [
  BaParagrafoPasso('Un contenuto non rispetta le regole di BA.'),
  BaParagrafoPasso('Se pensi che sia un errore, puoi chiedere una revisione.', evidenza: true),
];

BaSchermataCopertura _schermata({
  String titolo = 'Questo account non può più usare BA',
  List<BaParagrafoPasso> paragrafi = _b1,
  String? riga,
  bool inviata = false,
  VoidCallback? onRichiedi,
}) =>
    BaSchermataCopertura(
      titolo: titolo,
      paragrafi: paragrafi,
      riga: riga,
      richiedi: 'Richiedi revisione',
      onRichiedi: onRichiedi ?? () {},
      richiestaInviata: inviata,
      inviata: 'Richiesta inviata',
    );

void main() {
  group('B1 · account chiuso', () {
    testWidgets('il titolo è un titolo di schermata intera: 28/600 (titoloSchermata), non il 22 della stanza', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_schermata()));
      final stile = tester.widget<Text>(find.text('Questo account non può più usare BA')).style!;
      expect(stile.fontSize, 28);
      expect(stile.fontWeight, FontWeight.w600);
      expect(stile.fontSize, isNot(BaTestoTokens.stanza.fontSize));
      expect(stile.color, BaColorTokens.testoPrimo);
    });

    testWidgets('il titolo, i paragrafi e una sola azione: chiara', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_schermata()));
      expect(find.text('Questo account non può più usare BA'), findsOneWidget);
      expect(find.text('Un contenuto non rispetta le regole di BA.'), findsOneWidget);
      expect(find.byType(BaPillola), findsOneWidget, reason: 'una sola azione: nessun «Esci», nessun «Non ora»');
      final pillola = tester.widget<BaPillola>(find.byType(BaPillola));
      expect(pillola.testo, 'Richiedi revisione');
      expect(pillola.variante, BaVariantePillola.chiara);
      expect(pillola.onTap, isNotNull);
    });

    testWidgets('il paragrafo in evidenza ha il testo primo, gli altri il secondo', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_schermata()));
      expect(tester.widget<Text>(find.text('Se pensi che sia un errore, puoi chiedere una revisione.')).style?.color, BaColorTokens.testoPrimo);
      expect(tester.widget<Text>(find.text('Un contenuto non rispetta le regole di BA.')).style?.color, BaColorTokens.testoSecondo);
    });

    testWidgets('nessun segno d\'errore: il fatto è nel testo', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_schermata()));
      expect(find.text('!'), findsNothing);
      for (final t in tester.widgetList<Text>(find.byType(Text))) {
        expect(t.style?.color, isNot(BaColorTokens.erroreTesto), reason: t.data);
      }
    });
  });

  group('B1 bis · blocco temporaneo', () {
    testWidgets('la riga della durata sta dopo il primo paragrafo, in primo piano', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_schermata(
        titolo: 'L\'accesso a BA è sospeso',
        riga: 'Potrai rientrare il 21 novembre alle 21:40.',
      )));
      final primo = tester.getTopLeft(find.text('Un contenuto non rispetta le regole di BA.')).dy;
      final durata = tester.getTopLeft(find.text('Potrai rientrare il 21 novembre alle 21:40.')).dy;
      final secondo = tester.getTopLeft(find.text('Se pensi che sia un errore, puoi chiedere una revisione.')).dy;
      expect(primo, lessThan(durata));
      expect(durata, lessThan(secondo));
      expect(tester.widget<Text>(find.text('Potrai rientrare il 21 novembre alle 21:40.')).style?.color, BaColorTokens.testoPrimo);
    });

    testWidgets('è un fatto fermo: nessun ticker, nessun conto alla rovescia', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_schermata(riga: 'Potrai rientrare il 21 novembre alle 21:40.')));
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pump(const Duration(hours: 1));
      expect(find.text('Potrai rientrare il 21 novembre alle 21:40.'), findsOneWidget);
    });

    testWidgets('senza la riga non lascia traccia né spazio', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_schermata()));
      final conRiga = tester.getTopLeft(find.text('Se pensi che sia un errore, puoi chiedere una revisione.')).dy;
      await tester.pumpWidget(_app(_schermata(riga: 'Potrai rientrare.')));
      expect(tester.getTopLeft(find.text('Se pensi che sia un errore, puoi chiedere una revisione.')).dy, isNot(conRiga));
    });
  });

  group('B2 · richiesta inviata', () {
    testWidgets('dopo il tocco l\'azione dice «Richiesta inviata», è spenta e inattiva', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_schermata(
        paragrafi: const [BaParagrafoPasso('Abbiamo ricevuto la richiesta di revisione. Ti scriviamo all\'email dell\'account.', evidenza: true)],
        inviata: true,
      )));
      final pillola = tester.widget<BaPillola>(find.byType(BaPillola));
      expect(pillola.testo, 'Richiesta inviata');
      expect(pillola.variante, BaVariantePillola.spenta);
      expect(pillola.onTap, isNull);
      expect(find.byType(BaPillola), findsOneWidget);
    });

    testWidgets('non si può toccare due volte: dopo il primo tocco la callback non arriva più', (tester) async {
      _vista(tester);
      var richieste = 0;
      var inviata = false;
      await tester.pumpWidget(_app(StatefulBuilder(
        builder: (context, setState) => _schermata(
          inviata: inviata,
          onRichiedi: () => setState(() {
            richieste++;
            inviata = true;
          }),
        ),
      )));
      await tester.tap(find.text('Richiedi revisione'));
      await tester.pump();
      expect(richieste, 1);
      expect(find.text('Richiesta inviata'), findsOneWidget);
      await tester.tap(find.text('Richiesta inviata'), warnIfMissed: false);
      await tester.pump();
      await tester.tap(find.text('Richiesta inviata'), warnIfMissed: false);
      await tester.pump();
      expect(richieste, 1, reason: 'una sola richiesta, anche toccando ancora');
    });

    testWidgets('il cambio di stato si annuncia (regione viva)', (tester) async {
      _vista(tester);
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_schermata()));
      expect(tester.getSemantics(find.bySemanticsLabel('Richiedi revisione')).flagsCollection.isLiveRegion, isFalse);
      await tester.pumpWidget(_app(_schermata(inviata: true)));
      await tester.pump();
      var nodo = tester.getSemantics(find.bySemanticsLabel('Richiesta inviata'));
      var vivo = nodo.flagsCollection.isLiveRegion;
      for (var n = nodo; !vivo;) {
        final p = n.parent;
        if (p == null) break;
        n = p;
        vivo = n.flagsCollection.isLiveRegion;
      }
      expect(vivo, isTrue);
      semantica.dispose();
    });
  });

  group('una sola colonna (task 032)', () {
    testWidgets('a 744 dp il testo e l\x27azione stanno nella stessa colonna di 512: stesso bordo sinistro e stessa larghezza', (tester) async {
      _vista(tester, larghezza: 744, altezza: 1133);
      await tester.pumpWidget(_app(_schermata(titolo: 'Titolo breve', paragrafi: const [BaParagrafoPasso('Una frase.')])));
      final colonna = BaLayoutTokens.larghezzaColonna(744);
      expect(colonna, 512);
      final azione = tester.getRect(find.byType(BaPillola));
      expect(azione.width, colonna);
      expect(tester.getTopLeft(find.text('Titolo breve')).dx, azione.left, reason: 'il titolo, anche se corto, parte dal bordo della colonna');
      expect(tester.getTopLeft(find.text('Una frase.')).dx, azione.left);
    });

    testWidgets('a 360 dp la colonna e\x27 la larghezza meno i margini: 320', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_schermata(titolo: 'Titolo breve', paragrafi: const [BaParagrafoPasso('Una frase.')])));
      final azione = tester.getRect(find.byType(BaPillola));
      expect(azione.width, 320);
      expect(tester.getTopLeft(find.text('Titolo breve')).dx, azione.left);
    });
  });

  group('copre tutto', () {
    testWidgets('riempie lo spazio e non lascia passare i tocchi a ciò che sta sotto', (tester) async {
      _vista(tester);
      var sotto = 0;
      await tester.pumpWidget(_app(Stack(children: [
        GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => sotto++, child: const SizedBox.expand()),
        Positioned.fill(child: _schermata()),
      ])));
      expect(tester.getSize(find.byType(BaSchermataCopertura)), const Size(360, 800));
      await tester.tapAt(const Offset(180, 400));
      await tester.tapAt(const Offset(10, 10));
      expect(sotto, 0);
    });

    testWidgets('è una rotta con il suo nome per lo screen reader e non è un foglio', (tester) async {
      _vista(tester);
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_schermata()));
      expect(find.byType(Semantics).evaluate().any((e) {
        final w = e.widget as Semantics;
        return w.properties.namesRoute == true && w.properties.label == 'Questo account non può più usare BA';
      }), isTrue);
      semantica.dispose();
    });
  });

  group('testo grande e larghezze', () {
    for (final (larghezza, altezza) in [(360.0, 800.0), (744.0, 1133.0)]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp: il titolo è un\'intestazione, il contenuto scorre e l\'azione resta ancorata', (tester) async {
        _vista(tester, larghezza: larghezza, altezza: altezza, testo: BaScalaTokens.maxTesto);
        final semantica = tester.ensureSemantics();
        await tester.pumpWidget(_app(_schermata(
          titolo: 'L\'accesso a BA è sospeso',
          riga: 'Potrai rientrare il 21 novembre alle 21:40.',
          paragrafi: const [
            BaParagrafoPasso('Un contenuto non rispetta le regole di BA. Un contenuto non rispetta le regole di BA.'),
            BaParagrafoPasso('Se pensi che sia un errore, puoi chiedere una revisione. Se pensi che sia un errore, puoi chiedere una revisione.', evidenza: true),
          ],
        )));
        expect(tester.takeException(), isNull);

        // Il titolo è un'intestazione.
        expect(tester.getSemantics(find.text('L\'accesso a BA è sospeso')).flagsCollection.isHeader, isTrue);

        // L'azione è ancorata: dentro lo schermo, e ferma quando il contenuto scorre.
        final azione = find.widgetWithText(BaPillola, 'Richiedi revisione');
        final prima = tester.getRect(azione);
        expect(prima.bottom, lessThanOrEqualTo(altezza));
        expect(prima.left, greaterThanOrEqualTo(0));
        expect(prima.right, lessThanOrEqualTo(larghezza));
        final scorrimento = tester.state<ScrollableState>(find.byType(Scrollable).first);
        if (larghezza < 600) {
          expect(scorrimento.position.maxScrollExtent, greaterThan(0), reason: 'a 2,0 su un telefono il contenuto non entra: scorre');
        }
        scorrimento.position.jumpTo(scorrimento.position.maxScrollExtent);
        await tester.pump();
        expect(tester.getRect(azione), prima, reason: 'l\'azione non si muove con lo scorrimento');

        // Una sola azione, e nulla sborda a destra.
        expect(find.byType(BaPillola), findsOneWidget);
        for (final t in tester.widgetList<Text>(find.byType(Text))) {
          expect(tester.getRect(find.byWidget(t)).right, lessThanOrEqualTo(larghezza), reason: t.data);
        }
        semantica.dispose();
      });
    }

    testWidgets('a 2,0 dopo il tocco l\'azione inattiva resta in basso', (tester) async {
      _vista(tester, testo: BaScalaTokens.maxTesto);
      await tester.pumpWidget(_app(_schermata(inviata: true)));
      expect(tester.getRect(find.widgetWithText(BaPillola, 'Richiesta inviata')).bottom, lessThanOrEqualTo(800));
    });
  });
}
