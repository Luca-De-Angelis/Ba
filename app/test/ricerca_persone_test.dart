import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/campo_testo.dart';
import 'package:ba/design_system/ricerca_persone.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(alignment: Alignment.topLeft, child: SizedBox(width: larghezza, child: SingleChildScrollView(child: child))),
        ),
      ),
    );

BaRicercaPersone _ricerca(TextEditingController c, {String? errore, ValueChanged<String>? onRicerca}) => BaRicercaPersone(
      controller: c,
      etichetta: 'Cerca',
      segnaposto: 'Nickname, alias, email o numero',
      erroreRete: errore,
      onRicerca: onRicerca,
    );

void main() {
  group('gli stati', () {
    testWidgets('vuoto: l\'etichetta e il segnaposto, nessun errore', (tester) async {
      final c = TextEditingController();
      addTearDown(c.dispose);
      await tester.pumpWidget(_app(_ricerca(c)));
      expect(find.byType(BaCampoTesto), findsOneWidget);
      expect(find.text('CERCA'), findsOneWidget);
      expect(find.text('Nickname, alias, email o numero'), findsOneWidget);
      expect(find.byType(BaFraseErrore), findsNothing);
    });

    testWidgets('con testo: il segnaposto sparisce e il testo c\'è', (tester) async {
      final c = TextEditingController();
      addTearDown(c.dispose);
      await tester.pumpWidget(_app(_ricerca(c)));
      await tester.enterText(find.byType(EditableText), 'sar');
      await tester.pump();
      expect(c.text, 'sar');
      expect(find.text('Nickname, alias, email o numero'), findsNothing);
    });

    testWidgets('errore di rete: la frase con il segno «!», annunciata, non il solo colore', (tester) async {
      final c = TextEditingController(text: 'sar');
      addTearDown(c.dispose);
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_ricerca(c, errore: 'Non riusciamo a cercare adesso. Controlla la connessione e riprova.')));
      expect(find.text('Non riusciamo a cercare adesso. Controlla la connessione e riprova.'), findsOneWidget);
      expect(find.text('!'), findsOneWidget);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Non riusciamo a cercare adesso. Controlla la connessione e riprova.')).flagsCollection.isLiveRegion,
        isTrue,
      );
      semantica.dispose();
    });

    testWidgets('«Riprova» e «nessun risultato» non sono del campo', (tester) async {
      final c = TextEditingController();
      addTearDown(c.dispose);
      await tester.pumpWidget(_app(_ricerca(c, errore: 'Errore')));
      expect(find.text('Riprova'), findsNothing);
      expect(find.textContaining('Nessuna persona'), findsNothing);
    });
  });

  group('la soglia di due caratteri', () {
    testWidgets('sotto la soglia avvisa con il vuoto (tornano i suggeriti), da due caratteri con il testo', (tester) async {
      final c = TextEditingController();
      addTearDown(c.dispose);
      final ricevuti = <String>[];
      await tester.pumpWidget(_app(_ricerca(c, onRicerca: ricevuti.add)));
      await tester.enterText(find.byType(EditableText), 's');
      await tester.enterText(find.byType(EditableText), 'sa');
      await tester.enterText(find.byType(EditableText), 'sar');
      await tester.enterText(find.byType(EditableText), ' s ');
      expect(ricevuti, ['', 'sa', 'sar', '']);
    });

    test('attiva: almeno ricercaCaratteriMin caratteri, senza gli spazi ai bordi', () {
      expect(BaPersoneTokens.ricercaCaratteriMin, 2);
      expect(BaRicercaPersone.attiva(''), isFalse);
      expect(BaRicercaPersone.attiva('s'), isFalse);
      expect(BaRicercaPersone.attiva(' s '), isFalse);
      expect(BaRicercaPersone.attiva('sa'), isTrue);
    });
  });

  group('corrisponde: nickname, alias, email e numero', () {
    test('sotto la soglia corrisponde chiunque', () {
      expect(BaRicercaPersone.corrisponde('s', nickname: 'Marta'), isTrue);
      expect(BaRicercaPersone.corrisponde('', nickname: 'Marta'), isTrue);
    });

    test('il nickname, senza distinguere le maiuscole', () {
      expect(BaRicercaPersone.corrisponde('SAR', nickname: 'Sara'), isTrue);
      expect(BaRicercaPersone.corrisponde('sar', nickname: 'Marta'), isFalse);
    });

    test('l\'alias, con o senza la «@»', () {
      expect(BaRicercaPersone.corrisponde('rossi', nickname: 'Sara', alias: '@sara.rossi'), isTrue);
      expect(BaRicercaPersone.corrisponde('@sara.m', nickname: 'Sara', alias: '@sara.m'), isTrue);
      expect(BaRicercaPersone.corrisponde('sara.m', nickname: 'Sara', alias: '@sara.rossi'), isFalse);
    });

    test('l\'email e il numero (gli spazi non contano)', () {
      expect(BaRicercaPersone.corrisponde('marta@', email: 'marta@esempio.it'), isTrue);
      expect(BaRicercaPersone.corrisponde('320 000', numero: '320000 1111'), isTrue);
      expect(BaRicercaPersone.corrisponde('999', numero: '320 000 1111'), isFalse);
    });

    test('due Sara con alias diversi: la ricerca «sar» le trova tutte e due, l\'alias le distingue', () {
      const persone = [
        (nickname: 'Sara', alias: '@sara.m'),
        (nickname: 'Sara', alias: '@sara.rossi'),
        (nickname: 'Marta', alias: '@marta.v'),
      ];
      expect(persone.where((p) => BaRicercaPersone.corrisponde('sar', nickname: p.nickname, alias: p.alias)).length, 2);
      expect(persone.where((p) => BaRicercaPersone.corrisponde('sara.r', nickname: p.nickname, alias: p.alias)).length, 1);
    });
  });

  group('testo grande e larghezze', () {
    for (final larghezza in [360.0, 744.0]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp nulla si taglia né sborda, anche con l\'errore', (tester) async {
        final c = TextEditingController(text: 'sara.rossi@esempio.it');
        addTearDown(c.dispose);
        await tester.pumpWidget(_app(
          _ricerca(c, errore: 'Non riusciamo a cercare adesso. Controlla la connessione e riprova.'),
          testo: BaScalaTokens.maxTesto,
          larghezza: larghezza,
        ));
        expect(tester.takeException(), isNull);
        expect(tester.getSize(find.byType(BaRicercaPersone)).width, lessThanOrEqualTo(larghezza));
        expect(tester.getSize(find.byType(BaRicercaPersone)).height, greaterThanOrEqualTo(BaPersoneTokens.ricercaAltezza));
      });
    }

    test('l\'altezza della riga è quella del campo: ricercaAltezza = campoAltezza', () {
      expect(BaPersoneTokens.ricercaAltezza, BaAccessoTokens.campoAltezza);
    });
  });
}
