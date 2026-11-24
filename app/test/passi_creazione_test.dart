import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/campo_testo.dart';
import 'package:ba/design_system/chip_scelta.dart';
import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/foglio_passi.dart';
import 'package:ba/design_system/passi_creazione.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/punto_aggancio.dart';
import 'package:ba/design_system/scelta_den.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

// I passi di «Crea un DEN» (task 023b): C1–C5 e S2 del prototipo 014, dati allo
// stesso BaFoglioPassi di sempre.

void _vista(WidgetTester tester, {double larghezza = 360, double altezza = 800, double testo = 1.0}) {
  tester.view.physicalSize = Size(larghezza, altezza);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = testo;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

BaAzioneFoglio _azione(String testo, {VoidCallback? onTap}) =>
    BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: onTap ?? () {});

Widget _app(Widget Function() foglio) => WidgetsApp(
      color: BaColorTokens.fondoApp,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: foglio(),
    );

Future<void> _mostra(WidgetTester tester, BaPassoFoglio passo, {BaAzioneFoglio? nonOra}) async {
  await tester.pumpWidget(_app(() => BaFoglioPassi(nome: 'Crea un DEN', passo: passo, nonOra: nonOra ?? _azione('Non ora'))));
  await tester.pump();
}

BaPillola _pillola(WidgetTester tester, String testo) =>
    tester.widget<BaPillola>(find.widgetWithText(BaPillola, testo));

const _opzioni = [
  BaOpzioneScelta(titolo: 'Privato', descrizione: 'Entra chi inviti.'),
  BaOpzioneScelta(titolo: 'Pubblico', descrizione: 'Entra chiunque. Si trova nell\'elenco.'),
];

const _fraseGestisci = 'Lo gestisci tu, con i co-amministratori che scegli.';

BaPassoFoglio _tipo({int? scelta = 0, ValueChanged<int>? onScelta, String? frase = _fraseGestisci}) => BaPassiCreazione.tipo(
      titolo: 'Che DEN vuoi creare?',
      opzioni: _opzioni,
      scelta: scelta,
      onScelta: onScelta ?? (_) {},
      fraseSotto: frase,
      azione: _azione('Continua'),
    );

BaPuntoAggancio _quando() => const BaPuntoAggancio.quando(
      etichetta: 'Quando',
      titolo: 'Adesso',
      sottotitolo: 'Spento. Si accende più avanti, per chi crea DEN programmati.',
    );

BaPassoFoglio _nome({String? errore, TextEditingController? controller, VoidCallback? onContinua}) => BaPassiCreazione.nome(
      titolo: 'Come si chiama?',
      controller: controller ?? TextEditingController(),
      etichetta: 'Nome del DEN',
      errore: errore,
      quando: _quando(),
      azione: _azione('Continua', onTap: onContinua),
    );

const _temi = ['Chiacchiere', 'Musica', 'Libri', 'Cucina', 'Notte', 'Sport', 'Lavoro', 'Imparare'];
const _lingue = ['Italiano', 'Deutsch'];

BaPassoFoglio _dettagli({
  TextEditingController? descrizione,
  int? tema = 0,
  int? lingua = 0,
  ValueChanged<int>? onTema,
  ValueChanged<int>? onLingua,
}) =>
    BaPassiCreazione.dettagli(
      titolo: 'Descrizione, tema e lingua',
      descrizione: descrizione ?? TextEditingController(),
      descrizioneEtichetta: 'Descrizione',
      maxRighe: 6,
      temaEtichetta: 'Tema',
      temi: _temi,
      temaScelto: tema,
      onTema: onTema ?? (_) {},
      linguaEtichetta: 'Lingua',
      lingue: _lingue,
      linguaScelta: lingua,
      onLingua: onLingua ?? (_) {},
      azione: _azione('Continua'),
    );

void main() {
  group('tipo (C1, C1 bis)', () {
    testWidgets('il titolo, le due scelte, la frase sotto e una sola azione chiara con «Non ora»', (tester) async {
      _vista(tester);
      await _mostra(tester, _tipo());
      expect(find.text('Che DEN vuoi creare?'), findsOneWidget);
      expect(find.text('Privato'), findsOneWidget);
      expect(find.text('Pubblico'), findsOneWidget);
      expect(find.text(_fraseGestisci), findsOneWidget);
      expect(_pillola(tester, 'Continua').variante, BaVariantePillola.chiara);
      expect(_pillola(tester, 'Non ora').variante, BaVariantePillola.spenta);
      expect(find.byType(BaPillola), findsNWidgets(2));
    });

    testWidgets('il tipo pubblico non dice «senza amministratore» (D-043): lo scelgo e la frase resta quella data', (tester) async {
      _vista(tester);
      int? scelta = 0;
      await tester.pumpWidget(_app(() => StatefulBuilder(
            builder: (context, setState) => BaFoglioPassi(
              nome: 'Crea un DEN',
              passo: _tipo(scelta: scelta, onScelta: (i) => setState(() => scelta = i)),
              nonOra: _azione('Non ora'),
            ),
          )));
      await tester.pump();
      await tester.tap(find.descendant(of: find.byType(BaSceltaDen), matching: find.byType(BaTouchable)).at(1));
      await tester.pump();
      expect(scelta, 1);
      expect(tester.widget<BaSceltaDen>(find.byType(BaSceltaDen)).scelta, 1);
      expect(find.textContaining('senza amministratore', findRichText: true), findsNothing);
      expect(find.textContaining('non ha un amministratore', findRichText: true), findsNothing);
      expect(find.text(_fraseGestisci), findsOneWidget);
    });

    testWidgets('senza scelta ancora nessuna delle due è scelta', (tester) async {
      _vista(tester);
      await _mostra(tester, _tipo(scelta: null, frase: null));
      expect(tester.widget<BaSceltaDen>(find.byType(BaSceltaDen)).scelta, isNull);
    });
  });

  group('nome (C2, C2 bis, C2 ter)', () {
    testWidgets('il campo scrive nel controller e il componente non valida: «Continua» si può toccare a campo vuoto', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      var continua = 0;
      await _mostra(tester, _nome(controller: c, onContinua: () => continua++));
      await tester.tap(find.text('Continua'));
      await tester.pump();
      expect(continua, 1, reason: 'a campo vuoto il componente non blocca niente');
      await tester.enterText(find.byType(EditableText), 'Cena senza fretta');
      await tester.pump();
      expect(c.text, 'Cena senza fretta');
    });

    testWidgets('mostra l\'errore che gli si dà, con il segno, e senza errore non c\'è', (tester) async {
      _vista(tester);
      await _mostra(tester, _nome());
      expect(find.byType(BaFraseErrore), findsNothing);
      await _mostra(tester, _nome(errore: 'Scrivi un nome per il DEN.'));
      expect(find.text('Scrivi un nome per il DEN.'), findsOneWidget);
      expect(find.text('!'), findsOneWidget, reason: 'lo stato non è affidato al colore');
    });

    testWidgets('il campo «Quando» c\'è, è spento e non si tocca né prende il focus', (tester) async {
      _vista(tester);
      await _mostra(tester, _nome());
      final quando = find.byType(BaPuntoAggancio);
      expect(quando, findsOneWidget);
      expect(find.text('Adesso'), findsOneWidget);
      expect(find.descendant(of: quando, matching: find.byType(BaTouchable)), findsNothing);
      expect(find.descendant(of: quando, matching: find.byType(Focus)), findsNothing);
      // Il campo del nome è il solo che si scrive.
      expect(find.byType(EditableText), findsOneWidget);
      await tester.tap(find.text('Adesso'), warnIfMissed: false);
      await tester.pump();
      expect(find.byType(EditableText), findsOneWidget);
    });
  });

  group('dettagli (C3)', () {
    testWidgets('descrizione a più righe, i due gruppi di chip e la scelta con la spunta', (tester) async {
      _vista(tester);
      await _mostra(tester, _dettagli(tema: 1));
      final campo = tester.widget<BaCampoTesto>(find.byType(BaCampoTesto));
      expect(campo.minRighe, 3);
      expect(campo.maxRighe, 6);
      expect(find.text('TEMA'), findsOneWidget);
      expect(find.text('LINGUA'), findsOneWidget);
      final chip = tester.widgetList<BaChipScelta>(find.byType(BaChipScelta)).toList();
      expect(chip, hasLength(_temi.length + _lingue.length));
      expect([for (final c in chip.take(_temi.length)) c.scelto], [false, true, false, false, false, false, false, false]);
      expect([for (final c in chip.skip(_temi.length)) c.scelto], [true, false]);
    });

    testWidgets('toccare un chip chiama la callback del suo gruppo con l\'indice', (tester) async {
      _vista(tester);
      int? tema;
      int? lingua;
      await _mostra(tester, _dettagli(onTema: (i) => tema = i, onLingua: (i) => lingua = i));
      await tester.ensureVisible(find.text('Cucina'));
      await tester.tap(find.text('Cucina'));
      await tester.ensureVisible(find.text('Deutsch'));
      await tester.pump();
      await tester.tap(find.text('Deutsch'));
      expect(tema, 3);
      expect(lingua, 1);
    });

    testWidgets('i chip vanno a capo: a 360 sono su più righe e a 744 meno', (tester) async {
      _vista(tester);
      await _mostra(tester, _dettagli());
      int righe() => {for (var i = 0; i < _temi.length; i++) tester.getTopLeft(find.byType(BaChipScelta).at(i)).dy.round()}.length;
      final telefono = righe();
      expect(telefono, greaterThan(1));
      _vista(tester, larghezza: 744, altezza: 1133);
      await _mostra(tester, _dettagli());
      expect(righe(), lessThan(telefono));
    });

    testWidgets('a testo 2,0 nessun chip si taglia, il corpo scorre e le azioni restano ancorate', (tester) async {
      _vista(tester, testo: BaScalaTokens.maxTesto);
      await _mostra(tester, _dettagli());
      expect(tester.takeException(), isNull);
      final foglio = tester.getRect(_foglio());
      for (final c in find.byType(BaChipScelta).evaluate()) {
        final r = tester.getRect(find.byWidget(c.widget));
        expect(r.right, lessThanOrEqualTo(foglio.right), reason: 'un chip sborda');
      }
      final scorrimento = tester.state<ScrollableState>(find.byType(Scrollable).first);
      expect(scorrimento.position.maxScrollExtent, greaterThan(0), reason: 'a 2,0 il passo non entra: scorre');
      final continua = tester.getRect(find.widgetWithText(BaPillola, 'Continua'));
      final nonOra = tester.getRect(find.widgetWithText(BaPillola, 'Non ora'));
      expect(continua.bottom, lessThanOrEqualTo(nonOra.top));
      expect(nonOra.bottom, lessThanOrEqualTo(800));
      expect(foglio.height, lessThanOrEqualTo(800 * BaAccessoTokens.foglioAltezzaTelefono + 1));
    });
  });
}

/// Il riquadro del foglio (il suo fondo), non lo schermo intero.
Finder _foglio() => find.byWidgetPredicate((w) =>
    w is DecoratedBox &&
    w.decoration is BoxDecoration &&
    (w.decoration as BoxDecoration).color == BaColorTokens.superficieFoglio);
