import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/riga_consenso.dart';
import 'package:ba/design_system/riga_persona.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

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

BaRigaConsenso _riga({bool? acceso, ValueChanged<bool>? onCambia, String nome = 'Marta'}) => acceso == null
    ? BaRigaConsenso(nome: nome, alias: '@marta.v', parolaAcceso: 'Acceso', parolaSpento: 'Spento', onCambia: onCambia)
    : BaRigaConsenso(nome: nome, alias: '@marta.v', acceso: acceso, parolaAcceso: 'Acceso', parolaSpento: 'Spento', onCambia: onCambia);

void main() {
  group('parte spenta', () {
    testWidgets('senza dire altro il richiamo è spento, e lo dice la parola', (tester) async {
      await tester.pumpWidget(_app(_riga()));
      expect(find.text('SPENTO'), findsOneWidget);
      expect(find.text('ACCESO'), findsNothing);
      expect(tester.widget<BaRigaPersona>(find.byType(BaRigaPersona)).acceso, isFalse);
    });

    test('il valore di partenza di acceso è falso', () {
      expect(const BaRigaConsenso(nome: 'a', parolaAcceso: 'Acceso', parolaSpento: 'Spento').acceso, isFalse);
    });
  });

  group('la parola, non solo la posizione', () {
    testWidgets('spenta: «Spento»; accesa: «Acceso» (e il pallino dall\'altra parte)', (tester) async {
      await tester.pumpWidget(_app(_riga(acceso: false)));
      final spento = tester.getTopLeft(find.byType(BaRigaPersona));
      expect(find.text('SPENTO'), findsOneWidget);
      await tester.pumpWidget(_app(_riga(acceso: true)));
      expect(find.text('ACCESO'), findsOneWidget);
      expect(find.text('SPENTO'), findsNothing);
      expect(tester.getTopLeft(find.byType(BaRigaPersona)), spento);
    });

    testWidgets('per lo screen reader è un interruttore col nome e l\'alias', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (_) {})));
      expect(find.bySemanticsLabel('Marta. @marta.v'), findsOneWidget);
      semantica.dispose();
    });
  });

  group('la conferma è del chiamante', () {
    testWidgets('toccare una riga spenta chiama onCambia(true) e non accende da sé', (tester) async {
      bool? voluto;
      await tester.pumpWidget(_app(_riga(acceso: false, onCambia: (v) => voluto = v)));
      await tester.tap(find.text('Marta'));
      expect(voluto, isTrue);
      expect(find.text('SPENTO'), findsOneWidget, reason: 'resta spenta finché chi la usa non passa acceso: true');
    });

    testWidgets('toccare una riga accesa chiama onCambia(false)', (tester) async {
      bool? voluto;
      await tester.pumpWidget(_app(_riga(acceso: true, onCambia: (v) => voluto = v)));
      await tester.tap(find.text('Marta'));
      expect(voluto, isFalse);
    });

    testWidgets('senza onCambia è inattiva', (tester) async {
      await tester.pumpWidget(_app(_riga()));
      expect(tester.widget<BaTouchable>(find.byType(BaTouchable)).onTap, isNull);
    });

    testWidgets('tutta la riga è un\'area di tocco di almeno areaMinima', (tester) async {
      await tester.pumpWidget(_app(_riga(onCambia: (_) {})));
      expect(tester.getSize(find.byType(BaTouchable)).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
    });
  });

  group('testo grande e larghezze', () {
    for (final larghezza in [360.0, 744.0]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp nulla si taglia né sborda', (tester) async {
        for (final acceso in [false, true]) {
          await tester.pumpWidget(_app(_riga(acceso: acceso, nome: 'Maria Antonietta Bianchi-Rossi', onCambia: (_) {}), testo: BaScalaTokens.maxTesto, larghezza: larghezza));
          expect(tester.takeException(), isNull);
          final r = tester.getRect(find.byType(BaRigaConsenso));
          for (final t in tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaConsenso), matching: find.byType(Text)))) {
            expect(tester.getRect(find.byWidget(t)).right, lessThanOrEqualTo(r.right), reason: t.data);
          }
        }
      });
    }
  });

  test('il sorgente non mostra lo stato di presenza né il luogo della persona', () {
    final s = File('lib/design_system/riga_consenso.dart').readAsStringSync().toLowerCase();
    expect(s, isNot(contains('online')));
    expect(s, isNot(contains('in un den')));
  });
}
