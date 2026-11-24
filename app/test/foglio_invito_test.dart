import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/foglio_invito.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/tokens.dart';

// «Sei stato invitato» (task 033): I2, I3, I3 bis del prototipo 030.

void _vista(WidgetTester tester, {double larghezza = 360, double altezza = 800, double testo = 1.0}) {
  tester.view.physicalSize = Size(larghezza, altezza);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = testo;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

BaAzioneFoglio _azione(String testo, {VoidCallback? onTap, BaVariantePillola? variante}) =>
    BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: onTap ?? () {}, variante: variante);

Widget _app(Widget foglio) => WidgetsApp(
      color: BaColorTokens.fondoApp,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: foglio,
    );

BaFoglioInvito _valido({VoidCallback? onEntra, VoidCallback? onNonOra, BaVariantePillola? variante}) => BaFoglioInvito.valido(
      titolo: 'Marta ti ha invitato a Cena senza fretta',
      frase: 'Entri ad ascoltare.',
      entra: _azione('Entra', onTap: onEntra, variante: variante),
      nonOra: _azione('Non ora', onTap: onNonOra),
    );

BaFoglioInvito _scaduto() => BaFoglioInvito.scaduto(
      titolo: 'Questo invito è scaduto',
      frase: 'Chiedi a Marta di invitarti di nuovo.',
      haCapito: _azione('Ho capito'),
    );

BaFoglioInvito _annullato() => BaFoglioInvito.annullato(
      titolo: 'Questo invito non è più valido',
      frase: 'Chi lo ha mandato lo ha annullato.',
      haCapito: _azione('Ho capito'),
    );

BaPillola _pillola(WidgetTester tester, String testo) => tester.widget<BaPillola>(find.widgetWithText(BaPillola, testo));

Finder _riquadro() => find.byWidgetPredicate((w) =>
    w is DecoratedBox &&
    w.decoration is BoxDecoration &&
    (w.decoration as BoxDecoration).color == BaColorTokens.superficieFoglio);

void main() {
  group('valido', () {
    testWidgets('il titolo, la frase, «Entra» attiva e «Non ora» spenta', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_valido()));
      expect(find.text('Marta ti ha invitato a Cena senza fretta'), findsOneWidget);
      expect(find.text('Entri ad ascoltare.'), findsOneWidget);
      expect(_pillola(tester, 'Entra').variante, BaVariantePillola.attiva,
          reason: 'un invito non blocca niente e «Non ora» c\'è sempre (BaRegole 1): attiva, non chiara');
      expect(_pillola(tester, 'Non ora').variante, BaVariantePillola.spenta);
      expect(find.byType(BaPillola), findsNWidgets(2));
      expect(tester.widget<BaFoglioInvito>(find.byType(BaFoglioInvito)).stato, BaStatoInvito.valido);
    });

    testWidgets('«Entra» si può portare alla chiara con una variante', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_valido(variante: BaVariantePillola.chiara)));
      expect(_pillola(tester, 'Entra').variante, BaVariantePillola.chiara);
    });

    testWidgets('«Entra» e «Non ora» chiamano la loro callback', (tester) async {
      _vista(tester);
      var entra = 0;
      var nonOra = 0;
      await tester.pumpWidget(_app(_valido(onEntra: () => entra++, onNonOra: () => nonOra++)));
      await tester.tap(find.text('Entra'));
      await tester.tap(find.text('Non ora'));
      expect((entra, nonOra), (1, 1));
    });

    testWidgets('è un BaFoglio: il nome per lo screen reader è il titolo', (tester) async {
      _vista(tester);
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_valido()));
      expect(find.byType(BaFoglio), findsOneWidget);
      expect(find.bySemanticsLabel('Marta ti ha invitato a Cena senza fretta'), findsWidgets);
      semantica.dispose();
    });
  });

  group('scaduto e annullato', () {
    for (final (nome, foglio, titolo, frase, stato) in [
      ('scaduto', _scaduto(), 'Questo invito è scaduto', 'Chiedi a Marta di invitarti di nuovo.', BaStatoInvito.scaduto),
      ('annullato', _annullato(), 'Questo invito non è più valido', 'Chi lo ha mandato lo ha annullato.', BaStatoInvito.annullato),
    ]) {
      testWidgets('$nome: il titolo, la frase e una sola azione, «Ho capito», chiara', (tester) async {
        _vista(tester);
        await tester.pumpWidget(_app(foglio));
        expect(find.text(titolo), findsOneWidget);
        expect(find.text(frase), findsOneWidget);
        expect(find.byType(BaPillola), findsOneWidget);
        expect(_pillola(tester, 'Ho capito').variante, BaVariantePillola.chiara,
            reason: 'come nel prototipo e in «La coda è piena adesso» (023a)');
        expect(find.text('Entra'), findsNothing);
        expect(tester.widget<BaFoglioInvito>(find.byType(BaFoglioInvito)).stato, stato);
      });
    }

    testWidgets('l\'annullato non dice chi né perché, e nessuno dei due mostra un numero di giorni', (tester) async {
      _vista(tester);
      for (final foglio in [_scaduto(), _annullato()]) {
        await tester.pumpWidget(_app(foglio));
        final testi = tester.widgetList<Text>(find.byType(Text)).map((t) => t.data!).join(' ');
        expect(RegExp(r'\d').hasMatch(testi), isFalse, reason: 'l\'interfaccia non mostra il numero di giorni');
        expect(testi, isNot(contains('giorni')));
      }
    });
  });

  group('testo grande e larghezze', () {
    for (final (larghezza, altezza) in [(360.0, 800.0), (744.0, 1133.0)]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp nulla si taglia, le azioni restano ancorate e il foglio non supera il suo tetto', (tester) async {
        _vista(tester, larghezza: larghezza, altezza: altezza, testo: BaScalaTokens.maxTesto);
        for (final foglio in [_valido(), _scaduto(), _annullato()]) {
          await tester.pumpWidget(_app(foglio));
          expect(tester.takeException(), isNull);
          final tetto = altezza * (larghezza >= 600 ? BaAccessoTokens.foglioAltezzaTablet : BaAccessoTokens.foglioAltezzaTelefono);
          expect(tester.getSize(_riquadro()).height, lessThanOrEqualTo(tetto + 0.01));
          final ultima = tester.widgetList<BaPillola>(find.byType(BaPillola)).last;
          expect(tester.getRect(find.byWidget(ultima)).bottom, lessThanOrEqualTo(altezza));
        }
      });
    }
  });

  test('il sorgente non mostra lo stato di presenza né il luogo di chi invita', () {
    final s = File('lib/design_system/foglio_invito.dart').readAsStringSync().toLowerCase();
    expect(s, isNot(contains('online')));
    expect(s, isNot(contains('in un den')));
  });
}
