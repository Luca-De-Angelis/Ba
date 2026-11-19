import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/campo_testo.dart';
import 'package:ba/design_system/tokens.dart';

// Un EditableText con il focus fa lampeggiare il cursore di continuo: in questi
// test mai pumpAndSettle, solo pump.

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

/// Il colore della linea sotto il campo.
Color _linea(WidgetTester tester) {
  final scatole = tester.widgetList<DecoratedBox>(find.descendant(of: find.byType(BaCampoTesto), matching: find.byType(DecoratedBox)));
  for (final d in scatole) {
    final deco = d.decoration;
    if (deco is BoxDecoration && deco.border is Border && (deco.border! as Border).bottom.width == BaAccessoTokens.campoLinea) {
      return (deco.border! as Border).bottom.color;
    }
  }
  throw StateError('nessuna linea');
}

Widget _campo({
  TextEditingController? controller,
  FocusNode? focusNode,
  String? errore,
  String? aiuto = 'Ti mandiamo un codice. Niente password.',
  String? segnaposto,
  String? prefisso,
  TextInputType? tastiera,
  ValueChanged<String>? onChanged,
  int minRighe = 1,
  int maxRighe = 1,
}) =>
    BaCampoTesto(
      controller: controller ?? TextEditingController(),
      focusNode: focusNode,
      etichetta: 'Email',
      aiuto: aiuto,
      segnaposto: segnaposto,
      prefisso: prefisso,
      errore: errore,
      tastiera: tastiera,
      autofillHints: const [AutofillHints.email],
      onChanged: onChanged,
      minRighe: minRighe,
      maxRighe: maxRighe,
    );

void main() {
  group('la linea, non una scatola', () {
    testWidgets('ha solo la linea sotto, spessa campoLinea, e nessun bordo intorno', (tester) async {
      await tester.pumpWidget(_app(_campo()));
      final deco = tester.widgetList<DecoratedBox>(find.descendant(of: find.byType(BaCampoTesto), matching: find.byType(DecoratedBox)))
          .map((d) => d.decoration).whereType<BoxDecoration>().firstWhere((d) => d.border != null);
      final bordo = deco.border! as Border;
      expect(bordo.bottom.width, BaAccessoTokens.campoLinea);
      expect(BaAccessoTokens.campoLinea, 2);
      expect(bordo.top, BorderSide.none);
      expect(bordo.left, BorderSide.none);
      expect(bordo.right, BorderSide.none);
      expect(deco.borderRadius, isNull, reason: 'non è una scatola');
      expect(deco.color, isNull);
    });

    testWidgets('l\'altezza minima è campoAltezza (56)', (tester) async {
      await tester.pumpWidget(_app(_campo(aiuto: null)));
      expect(BaAccessoTokens.campoAltezza, 56);
      final altezzaCampo = tester.getSize(find.byType(EditableText)).height;
      expect(altezzaCampo, greaterThan(0));
      final scatola = tester.getRect(find.byType(BaCampoTesto));
      expect(scatola.height, greaterThanOrEqualTo(BaAccessoTokens.campoAltezza));
    });

    testWidgets('l\'etichetta è in marcatore, maiuscola, sopra la linea', (tester) async {
      await tester.pumpWidget(_app(_campo()));
      expect(find.text('EMAIL'), findsOneWidget);
      expect(tester.getTopLeft(find.text('EMAIL')).dy, lessThan(tester.getTopLeft(find.byType(EditableText)).dy));
    });
  });

  group('stati', () {
    testWidgets('vuoto: il segnaposto si vede; scrivendo sparisce', (tester) async {
      final c = TextEditingController();
      await tester.pumpWidget(_app(_campo(controller: c, segnaposto: 'nome@esempio.it')));
      expect(find.text('nome@esempio.it'), findsOneWidget);
      c.text = 'sara@esempio.it';
      await tester.pump();
      expect(find.text('nome@esempio.it'), findsNothing);
    });

    testWidgets('a riposo la linea è filettoMarcato, a fuoco azioneChiara', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(_app(_campo(focusNode: focus)));
      expect(_linea(tester), BaColorTokens.filettoMarcato);
      focus.requestFocus();
      await tester.pump();
      expect(_linea(tester), BaColorTokens.azioneChiara);
      focus.unfocus();
      await tester.pump();
      await tester.pump();
      expect(_linea(tester), BaColorTokens.filettoMarcato);
    });

    testWidgets('compilato: il valore c\'è e la linea è a riposo', (tester) async {
      await tester.pumpWidget(_app(_campo(controller: TextEditingController(text: 'sara@esempio.it'))));
      expect(find.text('sara@esempio.it'), findsOneWidget);
      expect(_linea(tester), BaColorTokens.filettoMarcato);
    });

    testWidgets('errore: linea erroreFiletto, segno «!» e frase — non il solo colore', (tester) async {
      await tester.pumpWidget(_app(_campo(errore: 'Questa email non è valida.')));
      expect(_linea(tester), BaColorTokens.erroreFiletto);
      expect(find.text('!'), findsOneWidget);
      expect(find.text('Questa email non è valida.'), findsOneWidget);
      expect(find.text('Ti mandiamo un codice. Niente password.'), findsNothing, reason: 'l\'aiuto cede il posto all\'errore');
      final segno = tester.getSize(find.ancestor(of: find.text('!'), matching: find.byType(SizedBox)).first);
      expect(segno, const Size.square(BaAccessoTokens.erroreSegnoLato));
    });

    testWidgets('l\'errore è annunciato: regione viva', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_campo(errore: 'Questa email non è valida.')));
      expect(
        tester.getSemantics(find.byType(BaFraseErrore)),
        matchesSemantics(label: 'Questa email non è valida.', isLiveRegion: true),
      );
      semantica.dispose();
    });

    testWidgets('l\'aiuto sta sotto la linea quando non c\'è errore', (tester) async {
      await tester.pumpWidget(_app(_campo()));
      expect(tester.getTopLeft(find.text('Ti mandiamo un codice. Niente password.')).dy, greaterThan(tester.getBottomLeft(find.byType(EditableText)).dy));
    });
  });

  group('scrittura', () {
    testWidgets('enterText aggiorna il controller e chiama onChanged', (tester) async {
      final c = TextEditingController();
      final valori = <String>[];
      await tester.pumpWidget(_app(_campo(controller: c, onChanged: valori.add)));
      await tester.enterText(find.byType(EditableText), 'sara@esempio.it');
      await tester.pump();
      expect(c.text, 'sara@esempio.it');
      expect(valori, ['sara@esempio.it']);
    });

    testWidgets('toccare la linea o il vuoto dà il focus al campo', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(_app(_campo(focusNode: focus)));
      expect(focus.hasFocus, isFalse);
      await tester.tap(find.text('EMAIL'), warnIfMissed: false); // l'etichetta non lo dà
      await tester.tapAt(tester.getBottomLeft(find.byType(EditableText)) + const Offset(60, 8));
      await tester.pump();
      expect(focus.hasFocus, isTrue);
    });

    testWidgets('senza focusNode il campo se ne fa uno e lo libera', (tester) async {
      await tester.pumpWidget(_app(_campo()));
      await tester.enterText(find.byType(EditableText), 'ciao');
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });

    testWidgets('la tastiera e i suggerimenti arrivano dal chiamante', (tester) async {
      await tester.pumpWidget(_app(_campo(tastiera: TextInputType.emailAddress)));
      final e = tester.widget<EditableText>(find.byType(EditableText));
      expect(e.keyboardType, TextInputType.emailAddress);
      expect(e.autofillHints, [AutofillHints.email]);
    });

    testWidgets('il prefisso («+39») sta davanti al valore', (tester) async {
      await tester.pumpWidget(_app(_campo(prefisso: '+39')));
      expect(tester.getRect(find.text('+39')).right, lessThan(tester.getRect(find.byType(EditableText)).left));
    });
  });

  group('la descrizione, a più righe', () {
    testWidgets('non scende sotto descrizioneAltezza (96) e usa la tastiera multilinea', (tester) async {
      await tester.pumpWidget(_app(_campo(minRighe: 3, maxRighe: 6, aiuto: null)));
      expect(BaCreazioneTokens.descrizioneAltezza, 96);
      expect(tester.getSize(find.byType(BaCampoTesto)).height, greaterThanOrEqualTo(BaCreazioneTokens.descrizioneAltezza));
      final e = tester.widget<EditableText>(find.byType(EditableText));
      expect(e.minLines, 3);
      expect(e.maxLines, 6);
      expect(e.keyboardType, TextInputType.multiline);
    });
  });

  group('semantica', () {
    testWidgets('un campo di testo con l\'etichetta, una volta sola', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_campo(controller: TextEditingController(text: 'sara'))));
      final nodo = tester.getSemantics(find.byType(EditableText));
      final dati = nodo.getSemanticsData();
      expect(dati.flagsCollection.isTextField, isTrue);
      expect(dati.label, 'Email');
      expect(dati.value, 'sara');
      // L'etichetta visiva non è un secondo nodo: «EMAIL» non è letta a parte.
      expect(find.bySemanticsLabel('EMAIL'), findsNothing);
      semantica.dispose();
    });
  });

  group('testo grande', () {
    testWidgets('a 2,0 la linea scende con il testo e nulla fa overflow', (tester) async {
      await tester.pumpWidget(_app(_campo(controller: TextEditingController(text: 'sara@esempio.it'))));
      final alto1 = tester.getSize(find.byType(BaCampoTesto)).height;
      await tester.pumpWidget(_app(_campo(controller: TextEditingController(text: 'sara@esempio.it'), errore: 'Questa email non è valida, controlla e riprova.'), testo: 2.0));
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(BaCampoTesto)).height, greaterThan(alto1));
      final campo = tester.getRect(find.byType(BaCampoTesto));
      final frase = tester.getRect(find.text('Questa email non è valida, controlla e riprova.'));
      expect(campo.contains(frase.topLeft) && campo.contains(frase.bottomRight - const Offset(0.01, 0.01)), isTrue);
    });
  });
}
