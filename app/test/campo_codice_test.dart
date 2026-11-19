import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/campo_codice.dart';
import 'package:ba/design_system/campo_testo.dart';
import 'package:ba/design_system/tokens.dart';

// Un EditableText con il focus fa lampeggiare il cursore (qui spento, ma il
// focus resta): niente pumpAndSettle, solo pump.

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: larghezza - 40, child: SingleChildScrollView(child: child)),
          ),
        ),
      ),
    );

Widget _codice({
  TextEditingController? controller,
  FocusNode? focusNode,
  BaStatoCodice stato = BaStatoCodice.scrittura,
  String? frase,
  ValueChanged<String>? onCompleto,
  ValueChanged<String>? onChanged,
}) =>
    BaCampoCodice(
      semanticsLabel: 'Codice di sei cifre',
      controller: controller,
      focusNode: focusNode,
      stato: stato,
      frase: frase,
      onCompleto: onCompleto,
      onChanged: onChanged,
    );

/// Il nodo semantico del campo: il Semantics con l'etichetta del chiamante.
Finder _campo() => find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'Codice di sei cifre');

/// Le sei caselle: i Container con il bordo.
List<Container> _caselle(WidgetTester tester) => tester
    .widgetList<Container>(find.descendant(
      of: find.byType(BaCampoCodice),
      matching: find.byWidgetPredicate((w) => w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null),
    ))
    .toList();

BorderSide _bordo(Container c) => ((c.decoration! as BoxDecoration).border! as Border).top;

/// Le cifre scritte nelle caselle (NBSP = vuota).
String _scritte(WidgetTester tester) => [
      for (final c in _caselle(tester)) (c.child! as Text).data!.replaceAll(' ', ''),
    ].join();

/// Quanti nodi `textField` ci sono nell'albero semantico.
int _nodiTesto(WidgetTester tester) {
  var n = 0;
  void visita(SemanticsNode nodo) {
    if (nodo.getSemanticsData().flagsCollection.isTextField) n++;
    nodo.visitChildren((c) {
      visita(c);
      return true;
    });
  }

  visita(tester.binding.renderViews.first.owner!.semanticsOwner!.rootSemanticsNode!);
  return n;
}

void main() {
  group('le sei caselle', () {
    testWidgets('sono sei, alte codiceAltezza, a distanza codiceGap, con il raggio dei token', (tester) async {
      await tester.pumpWidget(_app(_codice()));
      final caselle = find.byWidgetPredicate((w) => w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null);
      expect(caselle, findsNWidgets(BaAccessoTokens.codiceCaselle));
      expect(BaAccessoTokens.codiceCaselle, 6);
      final r = [for (var i = 0; i < 6; i++) tester.getRect(caselle.at(i))];
      for (final c in r) {
        expect(c.height, greaterThanOrEqualTo(BaAccessoTokens.codiceAltezza));
        expect(c.width, closeTo(r.first.width, 0.001));
      }
      expect(r[1].left - r[0].right, BaAccessoTokens.codiceGap);
      expect(BaAccessoTokens.codiceGap, 8);
      expect(((_caselle(tester).first.decoration! as BoxDecoration)).borderRadius, BorderRadius.circular(BaAccessoTokens.codiceRaggio));
    });

    testWidgets('a 360 dp ogni casella è larga ≥ 44 (46,7) e tutta l\'area è toccabile', (tester) async {
      await tester.pumpWidget(_app(_codice()));
      final caselle = find.byWidgetPredicate((w) => w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null);
      for (var i = 0; i < 6; i++) {
        final r = tester.getRect(caselle.at(i));
        expect(r.width, greaterThanOrEqualTo(BaControlloTokens.areaMinima), reason: 'casella $i');
        expect(r.height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
      }
    });
  });

  group('un campo solo per lo screen reader', () {
    testWidgets('un solo nodo di testo nell\'albero semantico, non sei', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_codice()));
      expect(_nodiTesto(tester), 1);
      expect(find.byType(EditableText), findsOneWidget, reason: 'un solo campo vero');
      semantica.dispose();
    });

    testWidgets('l\'etichetta è «codice di sei cifre» e il valore è letto cifra per cifra', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_codice()));
      await tester.enterText(find.byType(EditableText), '481');
      await tester.pump();
      final dati = tester.getSemantics(_campo()).getSemanticsData();
      expect(dati.label, 'Codice di sei cifre');
      expect(dati.value, '4 8 1', reason: 'cifre separate: lo screen reader le legge una a una');
      expect(dati.flagsCollection.isTextField, isTrue);
      semantica.dispose();
    });

    testWidgets('le caselle e il campo nascosto non sono nodi: nessuna cifra letta a parte', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_codice(controller: TextEditingController(text: '481'))));
      expect(find.bySemanticsLabel('4'), findsNothing);
      expect(find.bySemanticsLabel('8'), findsNothing);
      semantica.dispose();
    });

    testWidgets('l\'azione «scrivi» dello screen reader imposta il codice', (tester) async {
      final semantica = tester.ensureSemantics();
      final c = TextEditingController();
      await tester.pumpWidget(_app(_codice(controller: c)));
      final nodo = tester.getSemantics(_campo());
      tester.binding.renderViews.first.owner!.semanticsOwner!
          .performAction(nodo.id, SemanticsAction.setText, '481902');
      await tester.pump();
      expect(c.text, '481902');
      semantica.dispose();
    });

    testWidgets('un tocco su una casella dà il focus e apre la tastiera', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(_app(_codice(focusNode: focus)));
      expect(focus.hasFocus, isFalse);
      final quarta = find.byWidgetPredicate((w) => w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null).at(3);
      await tester.tap(quarta);
      await tester.pump();
      expect(focus.hasFocus, isTrue);
    });
  });

  group('solo cifre, al massimo sei', () {
    testWidgets('scrivere mostra le cifre nelle caselle e chiama onChanged ripulito', (tester) async {
      final valori = <String>[];
      await tester.pumpWidget(_app(_codice(onChanged: valori.add)));
      await tester.enterText(find.byType(EditableText), '481');
      await tester.pump();
      expect(_scritte(tester), '481');
      expect(valori.last, '481');
    });

    testWidgets('incolla sporco: «48a1-9» diventa «4819»', (tester) async {
      final c = TextEditingController();
      final valori = <String>[];
      await tester.pumpWidget(_app(_codice(controller: c, onChanged: valori.add)));
      await tester.enterText(find.byType(EditableText), '48a1-9');
      await tester.pump();
      expect(c.text, '4819');
      expect(_scritte(tester), '4819');
      expect(valori.last, '4819');
    });

    testWidgets('incolla lungo: «1234567890» si ferma a sei', (tester) async {
      final c = TextEditingController();
      await tester.pumpWidget(_app(_codice(controller: c)));
      await tester.enterText(find.byType(EditableText), '1234567890');
      await tester.pump();
      expect(c.text, '123456');
      expect(_scritte(tester), '123456');
    });

    testWidgets('l\'incolla con lo spazio («481 902») vale come 481902', (tester) async {
      final c = TextEditingController();
      await tester.pumpWidget(_app(_codice(controller: c)));
      await tester.enterText(find.byType(EditableText), '481 902');
      await tester.pump();
      expect(c.text, '481902');
    });

    testWidgets('cancellare funziona: le cifre tornano indietro', (tester) async {
      final c = TextEditingController();
      await tester.pumpWidget(_app(_codice(controller: c)));
      await tester.enterText(find.byType(EditableText), '481');
      await tester.pump();
      await tester.enterText(find.byType(EditableText), '48');
      await tester.pump();
      expect(_scritte(tester), '48');
      await tester.enterText(find.byType(EditableText), '');
      await tester.pump();
      expect(_scritte(tester), '');
    });

    testWidgets('la tastiera è numerica e l\'autocompilazione è il codice a uso singolo', (tester) async {
      await tester.pumpWidget(_app(_codice()));
      final e = tester.widget<EditableText>(find.byType(EditableText));
      expect(e.keyboardType, TextInputType.number);
      expect(e.autofillHints, [AutofillHints.oneTimeCode]);
    });
  });

  group('onCompleto', () {
    testWidgets('parte una volta a sei cifre, con il codice', (tester) async {
      final completati = <String>[];
      await tester.pumpWidget(_app(_codice(onCompleto: completati.add)));
      await tester.enterText(find.byType(EditableText), '481');
      await tester.pump();
      expect(completati, isEmpty);
      await tester.enterText(find.byType(EditableText), '481902');
      await tester.pump();
      expect(completati, ['481902']);
      // Altre cifre non lo rimandano.
      await tester.enterText(find.byType(EditableText), '4819021');
      await tester.pump();
      expect(completati, ['481902']);
    });

    testWidgets('l\'incolla di sei cifre in un colpo lo chiama', (tester) async {
      final completati = <String>[];
      await tester.pumpWidget(_app(_codice(onCompleto: completati.add)));
      await tester.enterText(find.byType(EditableText), '123456');
      await tester.pump();
      expect(completati, ['123456']);
    });

    testWidgets('cancellare e riarrivare a sei lo richiama', (tester) async {
      final completati = <String>[];
      await tester.pumpWidget(_app(_codice(onCompleto: completati.add)));
      await tester.enterText(find.byType(EditableText), '481902');
      await tester.pump();
      await tester.enterText(find.byType(EditableText), '48190');
      await tester.pump();
      await tester.enterText(find.byType(EditableText), '481907');
      await tester.pump();
      expect(completati, ['481902', '481907']);
    });
  });

  group('stati', () {
    testWidgets('in scrittura, con il focus: la casella dove si scrive ha il bordo spesso azioneChiara', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(_app(_codice(focusNode: focus, controller: TextEditingController(text: '48'))));
      // Senza focus nessuna casella è «attiva».
      expect(_caselle(tester).map((c) => _bordo(c).width).toSet(), {BaAccessoTokens.codiceBordo});
      focus.requestFocus();
      await tester.pump();
      await tester.pump();
      final bordi = _caselle(tester).map(_bordo).toList();
      expect(bordi[2].width, BaAccessoTokens.codiceBordoAttivo, reason: 'la terza, dove si scrive');
      expect(bordi[2].color, BaColorTokens.azioneChiara);
      for (final i in [0, 1, 3, 4, 5]) {
        expect(bordi[i].width, BaAccessoTokens.codiceBordo, reason: 'casella $i');
        expect(bordi[i].color, BaColorTokens.filettoMarcato);
      }
    });

    testWidgets('sbagliato: bordo erroreFiletto spesso su tutte, segno «!» e frase annunciata', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_codice(
        controller: TextEditingController(text: '481902'),
        stato: BaStatoCodice.sbagliato,
        frase: 'Il codice non è giusto. Controlla l\'email e riprova.',
      )));
      for (final c in _caselle(tester)) {
        expect(_bordo(c).color, BaColorTokens.erroreFiletto);
        expect(_bordo(c).width, BaAccessoTokens.codiceBordoAttivo);
      }
      expect(_scritte(tester), '481902', reason: 'le cifre restano');
      expect(find.text('!'), findsOneWidget);
      expect(find.text('Il codice non è giusto. Controlla l\'email e riprova.'), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(BaFraseErrore)),
        matchesSemantics(label: 'Il codice non è giusto. Controlla l\'email e riprova.', isLiveRegion: true),
      );
      semantica.dispose();
    });

    testWidgets('scaduto: caselle vuote e spente, campo in sola lettura, frase d\'errore', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_codice(
        controller: TextEditingController(text: '481'),
        stato: BaStatoCodice.scaduto,
        frase: 'Il codice è scaduto. Te ne mandiamo uno nuovo.',
      )));
      expect(_scritte(tester), '', reason: 'le caselle si svuotano');
      for (final c in _caselle(tester)) {
        expect(_bordo(c).color, BaColorTokens.filettoBase);
        expect(_bordo(c).width, BaAccessoTokens.codiceBordo);
      }
      expect(tester.widget<EditableText>(find.byType(EditableText)).readOnly, isTrue);
      expect(find.text('!'), findsOneWidget);
      expect(find.text('Il codice è scaduto. Te ne mandiamo uno nuovo.'), findsOneWidget);
      final dati = tester.getSemantics(_campo()).getSemanticsData();
      expect(dati.flagsCollection.isReadOnly, isTrue);
      semantica.dispose();
    });

    testWidgets('nuovo invio con attesa: caselle normali e una frase ferma, senza segno né conto alla rovescia',
        (tester) async {
      await tester.pumpWidget(_app(_codice(stato: BaStatoCodice.attesa, frase: 'Ne puoi chiedere un altro fra poco.')));
      expect(find.text('Ne puoi chiedere un altro fra poco.'), findsOneWidget);
      expect(find.text('!'), findsNothing, reason: 'non è un errore');
      expect(find.byType(BaFraseErrore), findsNothing);
      expect(find.textContaining(RegExp(r'\d')), findsNothing, reason: 'nessun numero che scende');
      expect(tester.hasRunningAnimations, isFalse);
      expect(tester.widget<EditableText>(find.byType(EditableText)).readOnly, isFalse, reason: 'si può scrivere il nuovo codice');
      expect(BaAccessoTokens.nuovoInvioAttesa, const Duration(seconds: 30), reason: 'è solo un valore');
    });

    testWidgets('in scrittura nessuna frase', (tester) async {
      await tester.pumpWidget(_app(_codice(frase: null)));
      expect(find.byType(BaFraseErrore), findsNothing);
    });

    test('sbagliato, scaduto e attesa vogliono la loro frase', () {
      expect(() => BaCampoCodice(semanticsLabel: 'c', stato: BaStatoCodice.sbagliato), throwsAssertionError);
      expect(() => BaCampoCodice(semanticsLabel: 'c', stato: BaStatoCodice.scaduto), throwsAssertionError);
      expect(() => BaCampoCodice(semanticsLabel: 'c', stato: BaStatoCodice.attesa), throwsAssertionError);
    });
  });

  group('testo grande', () {
    testWidgets('a 2,0 le caselle restano sei, alte uguali (vuote e piene), senza overflow né tagli', (tester) async {
      await tester.pumpWidget(_app(_codice(controller: TextEditingController(text: '48')), testo: 2.0));
      expect(tester.takeException(), isNull);
      final caselle = find.byWidgetPredicate((w) => w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null);
      expect(caselle, findsNWidgets(6));
      final altezze = {for (var i = 0; i < 6; i++) tester.getRect(caselle.at(i)).height};
      expect(altezze, hasLength(1), reason: 'caselle vuote e piene alte uguali');
      expect(altezze.single, greaterThanOrEqualTo(BaAccessoTokens.codiceAltezza));
      for (var i = 0; i < 2; i++) {
        final casella = tester.getRect(caselle.at(i));
        final cifra = tester.getRect(find.descendant(of: caselle.at(i), matching: find.byType(Text)));
        expect(casella.contains(cifra.topLeft) && casella.contains(cifra.bottomRight - const Offset(0.01, 0.01)), isTrue, reason: 'cifra $i');
      }
    });

    testWidgets('a 2,0 la frase d\'errore va a capo e nulla si taglia', (tester) async {
      await tester.pumpWidget(_app(
        _codice(stato: BaStatoCodice.sbagliato, frase: 'Il codice non è giusto. Controlla l\'email e riprova.'),
        testo: 2.0,
      ));
      expect(tester.takeException(), isNull);
      final campo = tester.getRect(find.byType(BaCampoCodice));
      final frase = tester.getRect(find.text('Il codice non è giusto. Controlla l\'email e riprova.'));
      expect(campo.contains(frase.topLeft) && campo.contains(frase.bottomRight - const Offset(0.01, 0.01)), isTrue);
    });
  });

  testWidgets('senza controller né focus il campo se li fa e li libera', (tester) async {
    await tester.pumpWidget(_app(_codice()));
    await tester.enterText(find.byType(EditableText), '481');
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
}
