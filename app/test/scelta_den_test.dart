import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/scelta_den.dart';
import 'package:ba/design_system/tokens.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(alignment: Alignment.topCenter, child: SizedBox(width: larghezza, child: child)),
        ),
      ),
    );

const _opzioni = [
  BaOpzioneScelta(titolo: 'Privato', descrizione: 'Si entra solo su invito.'),
  BaOpzioneScelta(titolo: 'Pubblico', descrizione: 'Entra chiunque.'),
];

Widget _scelta({int? scelta, ValueChanged<int>? onScelta, String? frase}) => BaSceltaDen(
      opzioni: _opzioni,
      scelta: scelta,
      onScelta: onScelta ?? (_) {},
      fraseSotto: frase,
    );

/// Il riquadro di una riga: il Container con il bordo.
List<BoxDecoration> _righe(WidgetTester tester) => [
      for (final c in tester.widgetList<Container>(find.descendant(
        of: find.byType(BaSceltaDen),
        matching: find.byWidgetPredicate((w) => w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null),
      )))
        c.decoration! as BoxDecoration,
    ];

/// I punti pieni dentro i cerchi: quadrati di `sm` con fondo azioneChiara.
Finder _punti() => find.descendant(
      of: find.byType(BaSceltaDen),
      matching: find.byWidgetPredicate((w) =>
          w is SizedBox && w.width == BaCreazioneTokens.sceltaPuntoLato && w.height == BaCreazioneTokens.sceltaPuntoLato),
    );

void main() {
  group('scelta e non scelta', () {
    testWidgets('la scelta ha il bordo spesso e il cerchio pieno; l\'altra no', (tester) async {
      await tester.pumpWidget(_app(_scelta(scelta: 0)));
      final righe = _righe(tester);
      expect(righe, hasLength(2));
      expect((righe[0].border! as Border).top.width, BaCreazioneTokens.sceltaBordoScelta);
      expect((righe[1].border! as Border).top.width, BaCreazioneTokens.sceltaBordo);
      expect(BaCreazioneTokens.sceltaBordoScelta, greaterThan(BaCreazioneTokens.sceltaBordo));
      expect(_punti(), findsOneWidget, reason: 'un solo punto pieno: quello della scelta');
      // Il punto sta nella prima riga.
      expect(tester.getRect(_punti()).center.dy, lessThan(tester.getRect(find.text('Pubblico')).top));
    });

    testWidgets('non è mai il solo colore: senza il colore restano bordo e punto', (tester) async {
      await tester.pumpWidget(_app(_scelta(scelta: 1)));
      final righe = _righe(tester);
      expect((righe[1].border! as Border).top.width, greaterThan((righe[0].border! as Border).top.width));
      expect(_punti(), findsOneWidget);
    });

    testWidgets('senza scelta nessun punto e tutti i bordi sottili', (tester) async {
      await tester.pumpWidget(_app(_scelta(scelta: null)));
      expect(_punti(), findsNothing);
      for (final r in _righe(tester)) {
        expect((r.border! as Border).top.width, BaCreazioneTokens.sceltaBordo);
      }
    });

    testWidgets('il cerchio è sceltaSegnoLato (22) e il raggio è quello dei token', (tester) async {
      await tester.pumpWidget(_app(_scelta(scelta: 0)));
      expect(BaCreazioneTokens.sceltaSegnoLato, 22);
      final cerchi = find.byWidgetPredicate((w) => w is SizedBox && w.width == BaCreazioneTokens.sceltaSegnoLato);
      expect(cerchi, findsNWidgets(2));
      expect(_righe(tester).first.borderRadius, BorderRadius.circular(BaCreazioneTokens.sceltaRaggio));
    });
  });

  group('tocco', () {
    testWidgets('toccare una riga chiama onScelta con il suo indice', (tester) async {
      final scelte = <int>[];
      await tester.pumpWidget(_app(_scelta(scelta: 0, onScelta: scelte.add)));
      await tester.tap(find.text('Pubblico'));
      await tester.tap(find.text('Si entra solo su invito.'));
      expect(scelte, [1, 0]);
    });

    testWidgets('ogni riga è alta almeno sceltaAltezza (≥ 44) e larga come la colonna', (tester) async {
      await tester.pumpWidget(_app(_scelta(scelta: 0)));
      for (final testo in ['Privato', 'Pubblico']) {
        final riga = tester.getRect(find.ancestor(of: find.text(testo), matching: find.byWidgetPredicate((w) => w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null)).first);
        expect(riga.height, greaterThanOrEqualTo(BaCreazioneTokens.sceltaAltezza));
        expect(riga.height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
        expect(riga.width, 360);
      }
    });
  });

  group('la frase sotto', () {
    testWidgets('cambia con la scelta e c\'è una volta sola', (tester) async {
      await tester.pumpWidget(_app(_scelta(scelta: 0, frase: 'Invita chi vuoi tu.')));
      expect(find.text('Invita chi vuoi tu.'), findsOneWidget);
      await tester.pumpWidget(_app(_scelta(scelta: 1, frase: 'Chiunque può entrare.')));
      expect(find.text('Invita chi vuoi tu.'), findsNothing);
      expect(find.text('Chiunque può entrare.'), findsOneWidget);
    });

    testWidgets('è una regione viva: si legge quando cambia', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_scelta(scelta: 0, frase: 'Invita chi vuoi tu.')));
      expect(tester.getSemantics(find.text('Invita chi vuoi tu.')), matchesSemantics(label: 'Invita chi vuoi tu.', isLiveRegion: true));
      semantica.dispose();
    });

    testWidgets('senza frase non lascia spazio', (tester) async {
      await tester.pumpWidget(_app(_scelta(scelta: 0)));
      final altezzaSenza = tester.getSize(find.byType(BaSceltaDen)).height;
      await tester.pumpWidget(_app(_scelta(scelta: 0, frase: 'Una frase.')));
      expect(tester.getSize(find.byType(BaSceltaDen)).height, greaterThan(altezzaSenza));
    });
  });

  group('semantica: scelta esclusiva', () {
    testWidgets('ogni riga è un bottone nel gruppo, selezionata solo la scelta', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_scelta(scelta: 1)));
      expect(
        tester.getSemantics(find.text('Privato')),
        matchesSemantics(
          label: 'Privato. Si entra solo su invito.',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          isInMutuallyExclusiveGroup: true,
          hasSelectedState: true,
          isSelected: false,
        ),
      );
      expect(
        tester.getSemantics(find.text('Pubblico')),
        matchesSemantics(
          label: 'Pubblico. Entra chiunque.',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          isInMutuallyExclusiveGroup: true,
          hasSelectedState: true,
          isSelected: true,
        ),
      );
      semantica.dispose();
    });
  });

  testWidgets('a testo 2,0 nulla si taglia e non fa overflow', (tester) async {
    await tester.pumpWidget(_app(SingleChildScrollView(child: _scelta(scelta: 0, frase: 'Una frase abbastanza lunga da andare a capo con il testo grande.')), testo: 2.0));
    expect(tester.takeException(), isNull);
    for (final r in _righe(tester)) {
      expect(r.borderRadius, isNotNull);
    }
    final privato = tester.getRect(find.text('Privato'));
    final riga = tester.getRect(find.ancestor(of: find.text('Privato'), matching: find.byWidgetPredicate((w) => w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null)).first);
    expect(riga.contains(privato.topLeft) && riga.contains(privato.bottomRight - const Offset(0.01, 0.01)), isTrue);
  });

  test('una scelta vuole almeno due opzioni', () {
    expect(
      () => BaSceltaDen(opzioni: const [BaOpzioneScelta(titolo: 'Una')], scelta: 0, onScelta: (_) {}),
      throwsAssertionError,
    );
  });
}
