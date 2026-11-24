import 'dart:ui' show SemanticsAction;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/riga_persona.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: larghezza, child: SingleChildScrollView(child: child)),
          ),
        ),
      ),
    );

List<String?> _testi(WidgetTester tester) =>
    tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(Text))).map((t) => t.data).toList();

void main() {
  group('la riga', () {
    testWidgets('mostra nome, stato e azione, alta almeno sceltaAltezza, con il filetto', (tester) async {
      await tester.pumpWidget(_app(BaRigaPersona(nome: 'Marta', stato: 'sul palco', azione: 'Rimuovi', onAzione: () {})));
      expect(_testi(tester), ['Marta', 'sul palco', 'Rimuovi']);
      expect(tester.getSize(find.byType(BaRigaPersona)).height, greaterThanOrEqualTo(BaCreazioneTokens.sceltaAltezza));
      final deco = tester.widget<Container>(find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(Container)).first).decoration! as BoxDecoration;
      expect((deco.border! as Border).top.color, BaColorTokens.filettoDivisorio);
    });

    testWidgets('la sagoma è quella dell\'indice, con la tinta dell\'indice (e giri sul mazzo)', (tester) async {
      await tester.pumpWidget(_app(const BaRigaPersona(nome: 'Davide', stato: 'co-amministratore', tinta: 1, sagoma: 2)));
      final deco = tester
          .widgetList<DecoratedBox>(find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(DecoratedBox)))
          .map((d) => d.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((d) => d.gradient != null);
      expect(deco.gradient, BaTintaTokens.mazzo[1].gradiente);
      expect(deco.borderRadius, BaSagomaTokens.bordo(2, BaCodaTokens.gruppoPresenzaLato));
      // Un indice oltre il mazzo non rompe niente.
      await tester.pumpWidget(_app(const BaRigaPersona(nome: 'Luca', stato: 'nel pubblico', tinta: 99, sagoma: 99)));
      expect(tester.takeException(), isNull);
    });
  });

  group('l\'azione', () {
    testWidgets('chiama onAzione e ha almeno areaMinima', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(BaRigaPersona(nome: 'Sara', stato: 'nel pubblico', azione: 'Rimuovi', onAzione: () => tocchi++)));
      final t = find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(BaTouchable));
      expect(tester.getSize(t).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
      await tester.tap(find.text('Rimuovi'));
      expect(tocchi, 1);
    });

    testWidgets('senza azione la riga non lascia né testo né spazio né bottone', (tester) async {
      await tester.pumpWidget(_app(const BaRigaPersona(nome: 'Davide', stato: 'co-amministratore')));
      expect(_testi(tester), ['Davide', 'co-amministratore']);
      expect(find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(BaTouchable)), findsNothing);
      expect(find.text('Rimuovi'), findsNothing);
      // Lo spazio dell'azione non c'è: il testo arriva fino al margine destro.
      final riga = tester.getRect(find.byType(BaRigaPersona));
      final nome = tester.getRect(find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(Expanded)));
      expect(nome.right, riga.right);
    });

    testWidgets('con il testo ma senza onAzione è inattiva', (tester) async {
      await tester.pumpWidget(_app(const BaRigaPersona(nome: 'Marta', stato: 'sul palco', azione: 'Rimuovi')));
      final t = tester.widget<BaTouchable>(find.byType(BaTouchable));
      expect(t.onTap, isNull);
    });
  });

  group('per lo screen reader', () {
    testWidgets('due elementi: il nome con lo stato e il bottone con la sua etichetta', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(BaRigaPersona(
        nome: 'Marta',
        stato: 'sul palco',
        azione: 'Rimuovi',
        azioneSemanticsLabel: 'Rimuovi Marta',
        onAzione: () {},
      )));
      final testo = tester.getSemantics(find.bySemanticsLabel('Marta. sul palco'));
      expect(testo.flagsCollection.isButton, isFalse);
      expect(testo.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      final bottone = tester.getSemantics(find.bySemanticsLabel('Rimuovi Marta'));
      expect(bottone.flagsCollection.isButton, isTrue);
      semantica.dispose();
    });
  });

  group('testo grande e nomi lunghi', () {
    testWidgets('a 2,0 e con un nome lungo nulla si taglia né sborda', (tester) async {
      await tester.pumpWidget(_app(
        BaRigaPersona(nome: 'Maria Antonietta Bianchi-Rossi', stato: 'co-amministratore', azione: 'Togli', onAzione: () {}),
        testo: BaScalaTokens.maxTesto,
      ));
      expect(tester.takeException(), isNull);
      final riga = tester.getRect(find.byType(BaRigaPersona));
      for (final t in tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(Text)))) {
        final r = tester.getRect(find.byWidget(t));
        expect(r.left, greaterThanOrEqualTo(riga.left));
        expect(r.right, lessThanOrEqualTo(riga.right));
      }
    });
  });
}
