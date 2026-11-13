import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/barra_azioni.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget barra, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(width: larghezza, child: barra),
        ),
      ),
    );

/// `n` azioni: la prima è la primaria, la seconda e la terza sono fisse.
List<BaAzioneBarra> _azioni(int n, {VoidCallback? onTap}) => [
      for (var i = 0; i < n; i++)
        BaAzioneBarra(
          ruolo: i == 0 ? BaRuoloAzione.primaria : BaRuoloAzione.secondaria,
          testo: 'Azione ${i + 1}',
          semanticsLabel: 'azione ${i + 1}',
          fissa: i < 3,
          onTap: onTap ?? () {},
        ),
    ];

Widget _barra(int n, {VoidCallback? onAltro, VoidCallback? onTap}) => BaBarraAzioni(
      azioni: _azioni(n, onTap: onTap),
      onAltro: onAltro,
      semanticsLabelAltro: 'Altro',
    );

void main() {
  group('i tre posti e «Altro»', () {
    for (final n in [1, 2, 3]) {
      testWidgets('con $n azioni non c\'è «Altro»', (tester) async {
        await tester.pumpWidget(_app(_barra(n)));
        expect(find.byKey(BaBarraAzioni.chiaveAltro), findsNothing);
        expect(find.byType(BaPillola), findsNWidgets(n));
        expect(BaBarraAzioniTokens.inAltro(n), 0);
      });
    }

    for (final (n, inAltro) in [(4, 1), (5, 2), (6, 3)]) {
      testWidgets('con $n azioni compare «Altro», 48 × 48, e ne restano $inAltro dentro', (tester) async {
        await tester.pumpWidget(_app(_barra(n)));
        expect(find.byType(BaPillola), findsNWidgets(3));
        expect(
          tester.getSize(find.byKey(BaBarraAzioni.chiaveAltro)),
          const Size(BaBarraAzioniTokens.altroLato, BaBarraAzioniTokens.altroLato),
        );
        expect(BaBarraAzioniTokens.altroLato, 48);
        expect(BaBarraAzioniTokens.inAltro(n), inAltro);
        expect(find.text('Azione 4'), findsNothing); // nel foglio, non qui
      });
    }

    testWidgets('«Altro» chiama onAltro', (tester) async {
      var chiamate = 0;
      await tester.pumpWidget(_app(_barra(4, onAltro: () => chiamate++)));
      await tester.tap(find.byKey(BaBarraAzioni.chiaveAltro));
      expect(chiamate, 1);
    });

    testWidgets('«Altro» sta a destra delle due secondarie, sulla loro riga', (tester) async {
      await tester.pumpWidget(_app(_barra(4)));
      final altro = tester.getRect(find.byKey(BaBarraAzioni.chiaveAltro));
      final seconda = tester.getRect(find.text('Azione 3'));
      expect(altro.left, greaterThan(seconda.right));
      expect(altro.center.dy, closeTo(seconda.center.dy, 1));
    });
  });

  group('disposizione e ordine', () {
    testWidgets('la primaria sopra a tutta larghezza, le secondarie sotto nell\'ordine passato',
        (tester) async {
      await tester.pumpWidget(_app(_barra(3)));
      final primaria = tester.getRect(find.byType(BaPillola).at(0));
      final s1 = tester.getRect(find.byType(BaPillola).at(1));
      final s2 = tester.getRect(find.byType(BaPillola).at(2));
      expect(primaria.width, 360);
      expect(primaria.height, greaterThanOrEqualTo(BaControlloTokens.primario));
      expect(s1.top, greaterThan(primaria.bottom));
      expect(s1.top, s2.top);
      expect(s1.left, lessThan(s2.left));
      expect(find.text('Azione 2'), findsOneWidget);
      expect(tester.getRect(find.text('Azione 2')).left, lessThan(tester.getRect(find.text('Azione 3')).left));
    });

    testWidgets('la primaria non in testa alla lista sta comunque sopra', (tester) async {
      await tester.pumpWidget(_app(BaBarraAzioni(
        azioni: const [
          BaAzioneBarra(ruolo: BaRuoloAzione.secondaria, testo: 'Esci', semanticsLabel: 'e', fissa: true),
          BaAzioneBarra(ruolo: BaRuoloAzione.primaria, testo: 'Parla', semanticsLabel: 'p'),
          BaAzioneBarra(ruolo: BaRuoloAzione.secondaria, testo: 'Altra', semanticsLabel: 'a'),
        ],
      )));
      expect(tester.getRect(find.text('Parla')).top, lessThan(tester.getRect(find.text('Esci')).top));
    });

    testWidgets('con due azioni la secondaria è una, centrata', (tester) async {
      await tester.pumpWidget(_app(_barra(2)));
      final p = tester.getRect(find.byType(BaPillola).at(0));
      final s = tester.getRect(find.byType(BaPillola).at(1));
      expect(s.center.dx, closeTo(p.center.dx, 0.01));
      expect(s.width, closeTo((360 - BaControlloTokens.gapCoppia) / 2, 0.01));
    });

    testWidgets('variante di default: primaria attiva, secondarie spente; la chiara la sceglie chi chiama',
        (tester) async {
      await tester.pumpWidget(_app(_barra(3)));
      final v = tester.widgetList<BaPillola>(find.byType(BaPillola)).map((p) => p.variante).toList();
      expect(v, [BaVariantePillola.attiva, BaVariantePillola.spenta, BaVariantePillola.spenta]);

      await tester.pumpWidget(_app(BaBarraAzioni(
        azioni: const [
          BaAzioneBarra(
            ruolo: BaRuoloAzione.primaria,
            testo: 'Sali sul palco',
            semanticsLabel: 's',
            variante: BaVariantePillola.chiara,
          ),
          BaAzioneBarra(ruolo: BaRuoloAzione.secondaria, testo: 'Esci', semanticsLabel: 'e', fissa: true),
        ],
      )));
      expect(tester.widget<BaPillola>(find.byType(BaPillola).first).variante, BaVariantePillola.chiara);
    });
  });

  group('assert in debug', () {
    test('la primaria fuori dalle prime tre', () {
      expect(
        () => BaBarraAzioni(azioni: [
          for (var i = 0; i < 4; i++)
            BaAzioneBarra(
              ruolo: i == 3 ? BaRuoloAzione.primaria : BaRuoloAzione.secondaria,
              testo: 't$i',
              semanticsLabel: 's$i',
            ),
        ]),
        throwsAssertionError,
      );
    });

    test('un\'azione fissa che finirebbe in «Altro»', () {
      final azioni = _azioni(4).toList()
        ..[3] = const BaAzioneBarra(
          ruolo: BaRuoloAzione.secondaria,
          testo: 'Esci',
          semanticsLabel: 'e',
          fissa: true,
        );
      expect(() => BaBarraAzioni(azioni: azioni), throwsAssertionError);
    });

    test('nessuna primaria, o due', () {
      expect(() => BaBarraAzioni(azioni: const []), throwsAssertionError);
      expect(
        () => BaBarraAzioni(azioni: const [
          BaAzioneBarra(ruolo: BaRuoloAzione.primaria, testo: 'a', semanticsLabel: 'a'),
          BaAzioneBarra(ruolo: BaRuoloAzione.primaria, testo: 'b', semanticsLabel: 'b'),
        ]),
        throwsAssertionError,
      );
    });

    test('più di una pillola chiara', () {
      expect(
        () => BaBarraAzioni(azioni: const [
          BaAzioneBarra(
            ruolo: BaRuoloAzione.primaria,
            testo: 'a',
            semanticsLabel: 'a',
            variante: BaVariantePillola.chiara,
          ),
          BaAzioneBarra(
            ruolo: BaRuoloAzione.secondaria,
            testo: 'b',
            semanticsLabel: 'b',
            variante: BaVariantePillola.chiara,
          ),
        ]),
        throwsAssertionError,
      );
    });

    test('una chiara sola va bene', () {
      expect(
        () => BaBarraAzioni(azioni: const [
          BaAzioneBarra(
            ruolo: BaRuoloAzione.primaria,
            testo: 'a',
            semanticsLabel: 'a',
            variante: BaVariantePillola.chiara,
          ),
        ]),
        returnsNormally,
      );
    });
  });

  group('testo grande', () {
    for (final n in [3, 6]) {
      testWidgets('a testo 2,0 con $n azioni nessuna azione si perde, nessun overflow', (tester) async {
        await tester.pumpWidget(_app(_barra(n), testo: 2.0));
        expect(tester.takeException(), isNull);
        expect(find.byType(BaPillola), findsNWidgets(3));
        expect(find.text('Azione 1'), findsOneWidget);
        expect(find.text('Azione 2'), findsOneWidget);
        expect(find.text('Azione 3'), findsOneWidget);
        expect(find.byKey(BaBarraAzioni.chiaveAltro), n > 3 ? findsOneWidget : findsNothing);
      });
    }

    testWidgets('la barra resta ancorata in basso e cresce solo verso l\'alto', (tester) async {
      await tester.pumpWidget(_app(_barra(4), testo: 1.0));
      final basso1 = tester.getRect(find.byType(BaBarraAzioni)).bottom;
      final alto1 = tester.getRect(find.byType(BaBarraAzioni)).top;
      await tester.pumpWidget(_app(_barra(4), testo: 2.0));
      final r = tester.getRect(find.byType(BaBarraAzioni));
      expect(r.bottom, basso1);
      expect(r.top, lessThanOrEqualTo(alto1));
    });
  });

  group('stessa altezza e ripiego in colonna (020b)', () {
    List<BaAzioneBarra> conTesti(List<String> testi) => [
          for (var i = 0; i < testi.length; i++)
            BaAzioneBarra(
              ruolo: i == 0 ? BaRuoloAzione.primaria : BaRuoloAzione.secondaria,
              testo: testi[i],
              semanticsLabel: testi[i],
              fissa: i < 3,
              onTap: () {},
            ),
        ];
    Widget barra(List<String> testi) => BaBarraAzioni(
          azioni: conTesti(testi),
          onAltro: () {},
          semanticsLabelAltro: 'Altro',
        );

    /// Quante righe occupa un testo di una pillola e quante ne avrebbe se nessuna
    /// parola si spezzasse: se sono uguali, nessuna parola è spezzata.
    int righe(WidgetTester tester, String testo) {
      final p = tester.renderObject<RenderParagraph>(find.text(testo));
      final una = TextPainter(
        text: TextSpan(text: 'x', style: p.text.style),
        textDirection: TextDirection.ltr,
        textScaler: p.textScaler,
      )..layout();
      return (p.size.height / una.height).round();
    }

    testWidgets('due pillole nella stessa riga, etichette di lunghezza diversa: stessa altezza', (tester) async {
      await tester.pumpWidget(_app(barra(['Microfono', 'Esci', 'Scendi dal palco ora'])));
      final a = tester.getRect(find.byType(BaPillola).at(1));
      final b = tester.getRect(find.byType(BaPillola).at(2));
      expect(a.top, b.top, reason: 'sulla stessa riga');
      expect(a.height, b.height);
      expect(b.height, greaterThan(BaControlloTokens.coppia), reason: 'la lunga va a capo e alza la riga');
    });

    testWidgets('con «Altro»: stessa altezza e «Altro» 48 × 48, centrato sulla riga', (tester) async {
      await tester.pumpWidget(_app(barra(['Microfono', 'Esci', 'Scendi dal palco ora', 'Invita'])));
      final a = tester.getRect(find.byType(BaPillola).at(1));
      final b = tester.getRect(find.byType(BaPillola).at(2));
      final altro = tester.getRect(find.byKey(BaBarraAzioni.chiaveAltro));
      expect(a.height, b.height);
      expect(altro.size, const Size(48, 48));
      expect(altro.center.dy, closeTo(a.center.dy, 0.01));
    });

    testWidgets('testo 1,0: «Scendi dal palco» e «Esci» restano affiancate', (tester) async {
      await tester.pumpWidget(_app(barra(['Microfono', 'Scendi dal palco', 'Esci'])));
      final a = tester.getRect(find.byType(BaPillola).at(1));
      final b = tester.getRect(find.byType(BaPillola).at(2));
      expect(a.top, b.top);
      expect(a.left, lessThan(b.left));
    });

    testWidgets('testo 2,0: le secondarie vanno in colonna, a tutta larghezza, senza parole spezzate',
        (tester) async {
      await tester.pumpWidget(_app(barra(['Microfono', 'Scendi dal palco', 'Esci']), testo: 2.0));
      expect(tester.takeException(), isNull);
      final a = tester.getRect(find.byType(BaPillola).at(1));
      final b = tester.getRect(find.byType(BaPillola).at(2));
      expect(b.top, greaterThanOrEqualTo(a.bottom), reason: 'una sotto l\'altra');
      expect(a.width, 360);
      expect(b.width, 360);
      expect(righe(tester, 'Scendi dal palco'), 2, reason: 'a capo fra le parole: «Scendi» e «dal palco»');
      expect(righe(tester, 'Esci'), 1);
      expect(find.byType(BaPillola), findsNWidgets(3));
    });

    testWidgets('testo 2,0 con «Altro»: in colonna, «Altro» a destra in fondo sulla riga dell\'ultima, 48 × 48',
        (tester) async {
      await tester.pumpWidget(_app(barra(['Microfono', 'Scendi dal palco', 'Esci', 'Invita']), testo: 2.0));
      expect(tester.takeException(), isNull);
      final a = tester.getRect(find.byType(BaPillola).at(1));
      final b = tester.getRect(find.byType(BaPillola).at(2));
      final altro = tester.getRect(find.byKey(BaBarraAzioni.chiaveAltro));
      expect(b.top, greaterThanOrEqualTo(a.bottom));
      expect(a.width, 360);
      expect(altro.size, const Size(48, 48));
      expect(altro.left, greaterThanOrEqualTo(b.right));
      expect(altro.right, a.right);
      expect(altro.center.dy, closeTo(b.center.dy, 0.01));
      expect(righe(tester, 'Scendi dal palco'), 2);
      expect(find.byType(BaPillola), findsNWidgets(3));
    });

    testWidgets('con il testo normale la disposizione non cambia: «Altro» 48 × 48 e tre pillole',
        (tester) async {
      await tester.pumpWidget(_app(barra(['Microfono', 'Scendi dal palco', 'Esci', 'Invita'])));
      expect(find.byType(BaPillola), findsNWidgets(3));
      expect(tester.getSize(find.byKey(BaBarraAzioni.chiaveAltro)), const Size(48, 48));
      final a = tester.getRect(find.byType(BaPillola).at(1));
      final b = tester.getRect(find.byType(BaPillola).at(2));
      expect(a.top, b.top);
    });
  });
}
