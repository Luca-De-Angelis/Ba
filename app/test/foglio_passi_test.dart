import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/campo_codice.dart';
import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/foglio_passi.dart';
import 'package:ba/design_system/tokens.dart';

// Un EditableText con il focus fa lampeggiare il cursore: niente pumpAndSettle
// dove c'è un campo a fuoco, solo pump.

const _nome = 'Diventa partecipante';
const _tAvviso = 'Vuoi salire sul palco?';
const _tNumero = 'Il tuo numero';
const _tCodice = 'Il codice';

const _lungo =
    'Per parlare bisogna diventare partecipante. Servono un numero di telefono verificato e il consenso '
    'a parlare. Mentre parli, la tua voce si registra per poco tempo e si trascrive; il testo serve alla '
    'moderazione e a costruire il tuo profilo. Nessuna conversazione si può riascoltare.';

void _vista(WidgetTester tester, {double larghezza = 360, double altezza = 800, double testo = 1.0}) {
  tester.view.physicalSize = Size(larghezza, altezza);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = testo;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

/// Il foglio a più passi con tre passi e un indice che si cambia dal test.
class _Prova extends StatefulWidget {
  const _Prova({required this.indice, required this.numero, required this.focusNumero});

  final ValueNotifier<int> indice;
  final TextEditingController numero;
  final FocusNode focusNumero;

  @override
  State<_Prova> createState() => _ProvaState();
}

class _ProvaState extends State<_Prova> {
  @override
  void initState() {
    super.initState();
    widget.indice.addListener(_cambia);
  }

  void _cambia() => setState(() {});

  @override
  void dispose() {
    widget.indice.removeListener(_cambia);
    super.dispose();
  }

  BaPassoFoglio get _passo => switch (widget.indice.value) {
        0 => BaPassoFoglio.avviso(
            id: 'avviso',
            titolo: _tAvviso,
            paragrafi: const [
              BaParagrafoPasso(_lungo),
              BaParagrafoPasso(_lungo),
              BaParagrafoPasso(_lungo, evidenza: true),
            ],
            azione: BaAzioneFoglio(testo: 'Continua', semanticsLabel: 'Continua', onTap: () {}),
          ),
        1 => BaPassoFoglio.numero(
            id: 'numero',
            titolo: _tNumero,
            controller: widget.numero,
            focusNode: widget.focusNumero,
            etichetta: 'Numero di telefono',
            prefisso: '+39',
            nota: 'Ti mandiamo un codice per SMS.',
            azione: BaAzioneFoglio(testo: 'Ricevi il codice', semanticsLabel: 'Ricevi il codice', onTap: () {}),
          ),
        _ => BaPassoFoglio.codice(
            id: 'codice',
            titolo: _tCodice,
            frase: 'Mandato al +39 ••• ••• 0000.',
            codiceSemanticsLabel: 'Codice di sei cifre',
            mandaDiNuovo: 'Mandalo di nuovo',
            azione: BaAzioneFoglio(testo: 'Conferma', semanticsLabel: 'Conferma', onTap: () {}),
          ),
      };

  @override
  Widget build(BuildContext context) => BaFoglioPassi(
        nome: _nome,
        passo: _passo,
        nonOra: BaAzioneFoglio(testo: 'Non ora', semanticsLabel: 'Non ora', onTap: () {}),
      );
}

Widget _app(ValueNotifier<int> indice, TextEditingController numero, FocusNode focusNumero) => WidgetsApp(
      color: BaColorTokens.fondoApp,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: _Prova(indice: indice, numero: numero, focusNumero: focusNumero),
    );

class _Banco {
  _Banco() {
    addTearDown(() {
      indice.dispose();
      numero.dispose();
      focusNumero.dispose();
    });
  }

  final indice = ValueNotifier<int>(0);
  final numero = TextEditingController();
  final focusNumero = FocusNode();
}

Future<_Banco> _apri(WidgetTester tester) async {
  final b = _Banco();
  await tester.pumpWidget(_app(b.indice, b.numero, b.focusNumero));
  await tester.pump();
  return b;
}

Future<void> _vai(WidgetTester tester, _Banco b, int passo) async {
  b.indice.value = passo;
  await tester.pump();
  await tester.pump();
}

/// Il nodo di focus del titolo: quello del `Focus` sopra il testo.
FocusNode _nodoTitolo(WidgetTester tester, String titolo) =>
    Focus.of(tester.element(find.text(titolo)));

/// Il riquadro del foglio (il suo fondo), non lo schermo intero.
Finder _foglio() => find.byWidgetPredicate((w) =>
    w is DecoratedBox &&
    w.decoration is BoxDecoration &&
    (w.decoration as BoxDecoration).color == BaColorTokens.superficieFoglio);

SemanticsNode _semanticaTitolo(WidgetTester tester, String titolo) =>
    tester.getSemantics(find.bySemanticsLabel(titolo));

void main() {
  group('«Non ora»', () {
    testWidgets('c\'è in ogni passo, in fondo, e si può toccare', (tester) async {
      _vista(tester);
      final b = await _apri(tester);
      for (var i = 0; i < 3; i++) {
        await _vai(tester, b, i);
        expect(find.text('Non ora'), findsOneWidget, reason: 'passo $i');
        expect(find.text('Non ora').evaluate().length, 1);
      }
      // È l'ultima azione: sta sotto la primaria.
      final primaria = tester.getTopLeft(find.text('Conferma')).dy;
      final nonOra = tester.getTopLeft(find.text('Non ora')).dy;
      expect(nonOra, greaterThan(primaria));
    });
  });

  group('il passo cambia', () {
    testWidgets('al primo passo il focus è sul titolo, senza regione viva', (tester) async {
      _vista(tester);
      final handle = tester.ensureSemantics();
      await _apri(tester);
      expect(_nodoTitolo(tester, _tAvviso).hasPrimaryFocus, isTrue);
      final s = _semanticaTitolo(tester, _tAvviso);
      expect(s.getSemanticsData().flagsCollection.isHeader, isTrue);
      expect(s.getSemanticsData().flagsCollection.isLiveRegion, isFalse,
          reason: 'all\'apertura parla già il nome del foglio');
      handle.dispose();
    });

    testWidgets('dal secondo passo il titolo è una regione viva e ha il focus, avanti e indietro', (tester) async {
      _vista(tester);
      final handle = tester.ensureSemantics();
      final b = await _apri(tester);

      await _vai(tester, b, 1);
      expect(find.text(_tAvviso), findsNothing);
      expect(_nodoTitolo(tester, _tNumero).hasPrimaryFocus, isTrue);
      var s = _semanticaTitolo(tester, _tNumero).getSemanticsData();
      expect(s.flagsCollection.isLiveRegion, isTrue);
      expect(s.flagsCollection.isHeader, isTrue);

      await _vai(tester, b, 2);
      expect(_nodoTitolo(tester, _tCodice).hasPrimaryFocus, isTrue);

      await _vai(tester, b, 0);
      expect(_nodoTitolo(tester, _tAvviso).hasPrimaryFocus, isTrue, reason: 'anche tornando indietro');
      s = _semanticaTitolo(tester, _tAvviso).getSemanticsData();
      expect(s.flagsCollection.isLiveRegion, isTrue, reason: 'dopo il primo cambio il titolo si annuncia sempre');
      handle.dispose();
    });

    testWidgets('il foglio resta lo stesso: un solo nome di foglio e la stessa rotta', (tester) async {
      _vista(tester);
      final handle = tester.ensureSemantics();
      final b = await _apri(tester);
      final rotta = ModalRoute.of(tester.element(find.byType(BaFoglio)));
      await _vai(tester, b, 1);
      expect(find.byType(BaFoglio), findsOneWidget);
      expect(identical(ModalRoute.of(tester.element(find.byType(BaFoglio))), rotta), isTrue, reason: 'nessuna rotta nuova');
      expect(find.bySemanticsLabel(_nome), findsOneWidget);
      handle.dispose();
    });

    testWidgets('dal numero al codice: il campo perde il focus, la tastiera si chiude, il titolo nuovo è a fuoco',
        (tester) async {
      _vista(tester);
      final b = await _apri(tester);
      await _vai(tester, b, 1);

      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(b.focusNumero.hasFocus, isTrue, reason: 'si è toccato il campo');
      expect(tester.testTextInput.hasAnyClients, isTrue, reason: 'la tastiera è aperta');
      await tester.enterText(find.byType(EditableText), '320 000 0000');
      await tester.pump();

      await _vai(tester, b, 2);
      expect(b.focusNumero.hasFocus, isFalse, reason: 'il campo del numero non c\'è più');
      expect(_nodoTitolo(tester, _tCodice).hasPrimaryFocus, isTrue);
      expect(tester.testTextInput.hasAnyClients, isFalse, reason: 'la tastiera si chiude');
    });

    testWidgets('il campo del passo nuovo non prende il focus da solo', (tester) async {
      _vista(tester);
      final b = await _apri(tester);
      await _vai(tester, b, 1);
      expect(b.focusNumero.hasFocus, isFalse);
      await _vai(tester, b, 2);
      expect(find.byType(BaCampoCodice), findsOneWidget);
      expect(tester.testTextInput.hasAnyClients, isFalse);
    });
  });

  group('testo grande', () {
    testWidgets('a 2,0 il corpo scorre e le azioni restano ancorate nella stessa posizione', (tester) async {
      _vista(tester, testo: BaScalaTokens.maxTesto);
      final b = await _apri(tester);
      final prima = tester.getTopLeft(find.text('Non ora'));
      final titoloPrima = tester.getTopLeft(find.text(_tAvviso)).dy;

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pump();
      expect(tester.getTopLeft(find.text('Non ora')), prima, reason: 'le azioni non scorrono');
      expect(tester.getTopLeft(find.text(_tAvviso)).dy, lessThan(titoloPrima), reason: 'il corpo è scorso');
      expect(b.indice.value, 0);
    });

    testWidgets('l\'altezza massima è 0,80 dello schermo sul telefono', (tester) async {
      _vista(tester, testo: BaScalaTokens.maxTesto);
      await _apri(tester);
      expect(tester.getSize(_foglio()).height, lessThanOrEqualTo(800 * BaAccessoTokens.foglioAltezzaTelefono + 0.01));
    });

    testWidgets('sul tablet il foglio non supera 0,62 dell\'altezza', (tester) async {
      _vista(tester, larghezza: 744, altezza: 1000, testo: BaScalaTokens.maxTesto);
      await _apri(tester);
      expect(tester.getSize(_foglio()).height, lessThanOrEqualTo(1000 * BaAccessoTokens.foglioAltezzaTablet + 0.01));
    });

    testWidgets('cambiando passo il corpo torna in alto', (tester) async {
      _vista(tester, testo: BaScalaTokens.maxTesto);
      final b = await _apri(tester);
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pump();
      final scrollato = tester.state<ScrollableState>(find.byType(Scrollable).first).position.pixels;
      expect(scrollato, greaterThan(0));

      await _vai(tester, b, 2);
      expect(tester.state<ScrollableState>(find.byType(Scrollable).first).position.pixels, 0);
    });
  });

  testWidgets('nessuna animazione né timer: il cambio di passo è subito al suo posto', (tester) async {
    _vista(tester);
    final b = await _apri(tester);
    await _vai(tester, b, 2);
    expect(tester.binding.transientCallbackCount, 0);
    expect(find.text(_tCodice), findsOneWidget);
  });
}
