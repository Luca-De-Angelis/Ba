import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/riga_den.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

// I componenti della scoperta (task 034, prototipo 031): la riga del motivo di `BaRigaDen`, il segno
// «● Disponibile» di `BaRigaPersona`, il punto di aggancio della home e la riga di stato. I test
// esistenti di quei componenti non cambiano: qui c'è solo ciò che è nuovo e la prova che, senza i
// parametri nuovi, la riga è quella di prima.

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

String _senzaCommenti(String sorgente) => sorgente.split('\n').where((r) => !r.trimLeft().startsWith('//')).join('\n');

void main() {
  group('BaRigaDen · il motivo', () {
    BaRigaDen riga({String? motivo, String marcatore = 'Entra chiunque · 5 sul palco', String? frase, VoidCallback? onTap}) => BaRigaDen(
          nome: 'Cucina di notte',
          marcatore: marcatore,
          frase: frase,
          motivo: motivo,
          presenze: 5,
          tinte: const [0, 1, 2],
          sagome: const [0, 1, 2],
          onTap: onTap,
        );

    testWidgets('con il motivo: una riga in più sotto, a 14 in secondo piano', (tester) async {
      await tester.pumpWidget(_app(riga(motivo: 'Perché: tema Cucina')));
      final testo = tester.widget<Text>(find.text('Perché: tema Cucina'));
      expect(testo.style!.fontSize, BaTestoTokens.minore.fontSize);
      expect(testo.style!.fontSize, 14);
      expect(testo.style!.color, BaColorTokens.testoSecondo);
      final nome = tester.getRect(find.text('Cucina di notte'));
      expect(tester.getRect(find.text('Perché: tema Cucina')).top, greaterThan(nome.bottom));
    });

    testWidgets('senza il motivo la riga è identica a prima: stessa altezza e stessi testi, con motivo nullo esplicito o senza il parametro', (tester) async {
      await tester.pumpWidget(_app(riga()));
      final altezza = tester.getSize(find.byType(BaRigaDen)).height;
      final testi = tester.widgetList<Text>(find.byType(Text)).length;
      await tester.pumpWidget(_app(const BaRigaDen(nome: 'Cucina di notte', marcatore: 'Entra chiunque · 5 sul palco', presenze: 5, tinte: [0, 1, 2], sagome: [0, 1, 2])));
      expect(tester.getSize(find.byType(BaRigaDen)).height, altezza, reason: 'nessuno spazio in più senza il motivo');
      expect(tester.widgetList<Text>(find.byType(Text)).length, testi);
    });

    testWidgets('il motivo aggiunge una riga e il suo respiro, niente di più', (tester) async {
      await tester.pumpWidget(_app(riga()));
      final senza = tester.getSize(find.byType(BaRigaDen)).height;
      await tester.pumpWidget(_app(riga(motivo: 'Perché: in italiano')));
      final con = tester.getSize(find.byType(BaRigaDen)).height;
      final riga1 = tester.getSize(find.text('Perché: in italiano')).height;
      expect(con - senza, closeTo(riga1 + BaSpazioTokens.s, 0.01));
    });

    testWidgets('«zona abituale» e «vicino a te» arrivano nel marcatore, dal chiamante: il componente non ha un parametro per questo', (tester) async {
      await tester.pumpWidget(_app(riga(marcatore: 'zona abituale · entra chiunque · 5 sul palco', motivo: 'Perché: tema Cucina')));
      expect(find.text('ZONA ABITUALE · ENTRA CHIUNQUE · 5 SUL PALCO'), findsOneWidget);
      expect(find.text('Perché: tema Cucina'), findsOneWidget);
    });

    testWidgets('per lo screen reader: nome, marcatore, frase e motivo, come un solo elemento; il tocco è del chiamante', (tester) async {
      final semantica = tester.ensureSemantics();
      var tocchi = 0;
      await tester.pumpWidget(_app(riga(motivo: 'Perché: tema Cucina', frase: 'Marta sta parlando', onTap: () => tocchi++)));
      expect(find.bySemanticsLabel('Cucina di notte. Entra chiunque · 5 sul palco. Marta sta parlando. Perché: tema Cucina'), findsOneWidget);
      await tester.tap(find.byType(BaTouchable));
      expect(tocchi, 1);
      semantica.dispose();
    });

    testWidgets('a 2,0 e a 744 il motivo non si taglia né sborda', (tester) async {
      for (final larghezza in [360.0, 744.0]) {
        await tester.pumpWidget(_app(riga(motivo: 'Perché: tema Cucina e una lingua molto lunga, scelta da te', frase: 'Marta sta parlando'), testo: BaScalaTokens.maxTesto, larghezza: larghezza));
        expect(tester.takeException(), isNull);
        final r = tester.getRect(find.byType(BaRigaDen));
        expect(tester.getRect(find.textContaining('Perché:')).right, lessThanOrEqualTo(r.right + 0.01));
      }
    });
  });

  group('il principio del 030: nessuna parola «online» né «in un DEN» nel codice dei componenti nuovi', () {
    // I file dei componenti che questo task estende o aggiunge, senza i commenti (che dicono il divieto).
    test('riga_den.dart e richiesta_permesso.dart non scrivono «online» né «in un DEN» nel codice', () {
      for (final file in ['lib/design_system/riga_den.dart', 'lib/design_system/richiesta_permesso.dart']) {
        final codice = _senzaCommenti(File(file).readAsStringSync()).toLowerCase();
        expect(codice.contains('online'), isFalse, reason: file);
        expect(RegExp(r'in un den(?! pubblico)').hasMatch(codice), isFalse, reason: file);
      }
    });
  });
}
