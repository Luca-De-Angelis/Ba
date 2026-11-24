import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/intestazione.dart';
import 'package:ba/design_system/marcatore.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Align(alignment: Alignment.topLeft, child: SizedBox(width: larghezza, child: child)),
      ),
    );

const _marcatori = {
  BaStatoIntestazione.pubblica: 'entra chiunque',
  BaStatoIntestazione.suInvito: 'su invito',
  BaStatoIntestazione.viva: '5 sul palco',
  BaStatoIntestazione.inIngresso: 'sto entrando',
  BaStatoIntestazione.disconnessa: 'linea persa',
};

Color? _coloreNome(WidgetTester tester) => tester.widget<Text>(find.text('Serata sul balcone')).style?.color;

Color _coloreMarcatore(WidgetTester tester) => tester.widget<BaMarcatore>(find.byType(BaMarcatore)).colore;

void main() {
  for (final MapEntry(key: stato, value: marcatore) in _marcatori.entries) {
    testWidgets('${stato.name}: il nome sopra, il marcatore sotto, il testo dal chiamante', (tester) async {
      await tester.pumpWidget(_app(BaIntestazione(nome: 'Serata sul balcone', marcatore: marcatore, stato: stato)));
      expect(find.text('Serata sul balcone'), findsOneWidget);
      expect(find.text(marcatore.toUpperCase()), findsOneWidget);
      expect(tester.getTopLeft(find.text('Serata sul balcone')).dy, lessThan(tester.getTopLeft(find.text(marcatore.toUpperCase())).dy));
      expect(tester.widget<Text>(find.text('Serata sul balcone')).style?.fontSize, BaTestoTokens.stanza.fontSize);
    });
  }

  testWidgets('pubblica, su invito, viva e in ingresso hanno lo stesso aspetto: cambia il testo', (tester) async {
    for (final stato in [BaStatoIntestazione.pubblica, BaStatoIntestazione.suInvito, BaStatoIntestazione.viva, BaStatoIntestazione.inIngresso]) {
      await tester.pumpWidget(_app(BaIntestazione(nome: 'Serata sul balcone', marcatore: 'x', stato: stato)));
      expect(_coloreNome(tester), BaColorTokens.testoPrimo, reason: stato.name);
      expect(_coloreMarcatore(tester), BaColorTokens.testoTerzo, reason: stato.name);
    }
  });

  testWidgets('disconnessa: nome e marcatore sono spenti, e il testo lo dice a parole', (tester) async {
    await tester.pumpWidget(_app(const BaIntestazione(nome: 'Serata sul balcone', marcatore: 'linea persa', stato: BaStatoIntestazione.disconnessa)));
    expect(_coloreNome(tester), BaColorTokens.testoTerzo);
    expect(_coloreMarcatore(tester), BaColorTokens.testoInattivo);
    expect(find.text('LINEA PERSA'), findsOneWidget, reason: 'lo stato non è il solo tono');
  });

  testWidgets('per lo screen reader è un\'intestazione sola: «nome. marcatore»', (tester) async {
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(_app(const BaIntestazione(nome: 'Serata sul balcone', marcatore: 'entra chiunque')));
    final nodo = tester.getSemantics(find.bySemanticsLabel('Serata sul balcone. entra chiunque'));
    expect(nodo.flagsCollection.isHeader, isTrue);
    semantica.dispose();
  });

  testWidgets('a testo 2,0 e a 744 non si taglia e non sborda', (tester) async {
    for (final larghezza in [360.0, 744.0]) {
      await tester.pumpWidget(_app(
        const BaIntestazione(nome: 'Serata sul balcone con un nome davvero lungo', marcatore: 'entra chiunque · 5 sul palco · 14 in ascolto'),
        testo: BaScalaTokens.maxTesto,
        larghezza: larghezza,
      ));
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(BaIntestazione)).width, lessThanOrEqualTo(larghezza));
    }
  });

  testWidgets('nessun ticker: è un fatto fermo', (tester) async {
    await tester.pumpWidget(_app(const BaIntestazione(nome: 'A', marcatore: 'b', stato: BaStatoIntestazione.inIngresso)));
    expect(tester.binding.transientCallbackCount, 0);
  });
}
