import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/campo_codice.dart';
import 'package:ba/design_system/campo_testo.dart';
import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/foglio_passi.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/tokens.dart';

// I passi di «diventa partecipante» (task 023a): P1–P4 del 013, R1 e R2 del 014.
// Il caso P6 (numero già verificato) non esiste più (D-040).

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

Future<void> _mostra(WidgetTester tester, BaPassoFoglio passo) async {
  await tester.pumpWidget(WidgetsApp(
    color: BaColorTokens.fondoApp,
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
    home: BaFoglioPassi(nome: 'Diventa partecipante', passo: passo, nonOra: _azione('Non ora')),
  ));
  await tester.pump();
}

BaPassoFoglio _avviso({String titolo = 'Vuoi salire sul palco?'}) => BaPassoFoglio.avviso(
      id: 'avviso',
      titolo: titolo,
      paragrafi: const [
        BaParagrafoPasso('Per parlare bisogna diventare partecipante.'),
        BaParagrafoPasso('Mentre parli, la tua voce si registra per poco tempo.'),
        BaParagrafoPasso('Nessuna conversazione si può riascoltare.', evidenza: true),
      ],
      azione: _azione('Continua'),
    );

BaPassoFoglio _numero({String? errore, String prefisso = '+39', TextEditingController? controller}) =>
    BaPassoFoglio.numero(
      id: 'numero',
      titolo: 'Il tuo numero',
      controller: controller ?? TextEditingController(),
      etichetta: 'Numero di telefono',
      prefisso: prefisso,
      segnaposto: '320 000 0000',
      errore: errore,
      nota: 'Ti mandiamo un codice per SMS. Il numero serve solo per parlare.',
      azione: _azione('Ricevi il codice'),
    );

BaPassoFoglio _codice({
  BaStatoCodice stato = BaStatoCodice.scrittura,
  String? fraseStato,
  VoidCallback? onMandaDiNuovo,
}) =>
    BaPassoFoglio.codice(
      id: 'codice',
      titolo: 'Il codice',
      frase: 'Mandato al +39 ••• ••• 0000.',
      codiceSemanticsLabel: 'Codice di sei cifre',
      stato: stato,
      fraseStato: fraseStato,
      mandaDiNuovo: 'Mandalo di nuovo',
      onMandaDiNuovo: onMandaDiNuovo,
      azione: _azione('Conferma'),
    );

BaPassoFoglio _consenso({String? rigaSale = 'Salirai a microfono spento.', String azione = 'Acconsento e salgo'}) =>
    BaPassoFoglio.consenso(
      id: 'consenso',
      titolo: 'Vuoi parlare?',
      paragrafi: const [
        BaParagrafoPasso('Acconsenti che, mentre parli, la tua voce si registri per poco tempo.'),
        BaParagrafoPasso('Con il consenso il tuo account passa da ascoltatore a partecipante.', evidenza: true),
      ],
      rigaSale: rigaSale,
      azione: _azione(azione),
    );

BaPillola _pillola(WidgetTester tester, String testo) =>
    tester.widget<BaPillola>(find.widgetWithText(BaPillola, testo));

Color? _coloreTesto(WidgetTester tester, String testo) =>
    tester.widget<Text>(find.text(testo)).style?.color;

void main() {
  group('avviso (P1, R1)', () {
    testWidgets('titolo, paragrafi dal chiamante e l\'azione chiara', (tester) async {
      _vista(tester);
      await _mostra(tester, _avviso());
      expect(find.text('Vuoi salire sul palco?'), findsOneWidget);
      expect(find.text('Per parlare bisogna diventare partecipante.'), findsOneWidget);
      expect(_pillola(tester, 'Continua').variante, BaVariantePillola.chiara,
          reason: 'è il gesto che nessuno può fare al posto della persona (BaRegole 1)');
      expect(_pillola(tester, 'Non ora').variante, BaVariantePillola.spenta);
    });

    testWidgets('il paragrafo in evidenza ha il testo primo, gli altri il secondo', (tester) async {
      _vista(tester);
      await _mostra(tester, _avviso());
      expect(_coloreTesto(tester, 'Nessuna conversazione si può riascoltare.'), BaColorTokens.testoPrimo);
      expect(_coloreTesto(tester, 'Per parlare bisogna diventare partecipante.'), BaColorTokens.testoSecondo);
    });

    testWidgets('R1 è lo stesso passo con un altro titolo', (tester) async {
      _vista(tester);
      await _mostra(tester, _avviso(titolo: 'Per creare un DEN bisogna diventare partecipante'));
      expect(find.text('Per creare un DEN bisogna diventare partecipante'), findsOneWidget);
      expect(find.text('Vuoi salire sul palco?'), findsNothing);
    });
  });

  group('numero (P2)', () {
    testWidgets('il prefisso è un parametro del chiamante, e il numero non si valida', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      await _mostra(tester, _numero(controller: c, prefisso: '+39'));
      expect(find.text('+39'), findsOneWidget);
      expect(find.text('Ti mandiamo un codice per SMS. Il numero serve solo per parlare.'), findsOneWidget);
      expect(tester.widget<BaCampoTesto>(find.byType(BaCampoTesto)).tastiera, TextInputType.phone);

      await tester.enterText(find.byType(EditableText), 'abc');
      await tester.pump();
      expect(c.text, 'abc', reason: 'il componente non valida il numero');

      await _mostra(tester, _numero(controller: c, prefisso: '+44'));
      expect(find.text('+44'), findsOneWidget);
      expect(find.text('+39'), findsNothing);
    });

    testWidgets('mostra l\'errore che gli si dà, annunciato', (tester) async {
      _vista(tester);
      final handle = tester.ensureSemantics();
      await _mostra(tester, _numero(errore: 'Il numero non sembra giusto.'));
      expect(find.text('Il numero non sembra giusto.'), findsOneWidget);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Il numero non sembra giusto.')),
        matchesSemantics(label: 'Il numero non sembra giusto.', isLiveRegion: true),
      );
      handle.dispose();
    });

    testWidgets('senza errore non c\'è la frase', (tester) async {
      _vista(tester);
      await _mostra(tester, _numero());
      expect(find.byType(BaFraseErrore), findsNothing);
    });
  });

  group('codice (P3)', () {
    testWidgets('in scrittura: la frase, il campo, «Mandalo di nuovo» attivo', (tester) async {
      _vista(tester);
      var richieste = 0;
      await _mostra(tester, _codice(onMandaDiNuovo: () => richieste++));
      expect(find.text('Mandato al +39 ••• ••• 0000.'), findsOneWidget);
      expect(find.byType(BaCampoCodice), findsOneWidget);
      await tester.tap(find.text('Mandalo di nuovo'));
      await tester.pump();
      expect(richieste, 1);
      expect(_coloreTesto(tester, 'Mandalo di nuovo'), BaColorTokens.testoSecondo);
    });

    testWidgets('durante l\'attesa «Mandalo di nuovo» è inattivo e c\'è una frase ferma', (tester) async {
      _vista(tester);
      final handle = tester.ensureSemantics();
      await _mostra(
        tester,
        _codice(stato: BaStatoCodice.attesa, fraseStato: 'Ne puoi chiedere un altro fra poco.'),
      );
      expect(find.text('Ne puoi chiedere un altro fra poco.'), findsOneWidget);
      expect(_coloreTesto(tester, 'Mandalo di nuovo'), BaColorTokens.testoTerzo);
      final s = tester.getSemantics(find.bySemanticsLabel('Mandalo di nuovo'));
      expect(s, matchesSemantics(label: 'Mandalo di nuovo', isButton: true, hasEnabledState: true, isEnabled: false),
          reason: 'inattivo: non si tocca e non si focalizza');
      expect(s.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      // Nessun conto alla rovescia: nessuna animazione in corso.
      expect(tester.binding.transientCallbackCount, 0);
      handle.dispose();
    });

    testWidgets('scaduto: «Mandalo di nuovo» non c\'è, l\'azione che serve è la primaria', (tester) async {
      _vista(tester);
      await _mostra(
        tester,
        BaPassoFoglio.codice(
          id: 'codice',
          titolo: 'Il codice',
          frase: 'Mandato al +39 ••• ••• 0000.',
          codiceSemanticsLabel: 'Codice di sei cifre',
          stato: BaStatoCodice.scaduto,
          fraseStato: 'Il codice è scaduto. Te ne mandiamo uno nuovo.',
          azione: _azione('Manda un nuovo codice'),
        ),
      );
      expect(find.text('Mandalo di nuovo'), findsNothing);
      expect(find.text('Manda un nuovo codice'), findsOneWidget);
      expect(find.text('Il codice è scaduto. Te ne mandiamo uno nuovo.'), findsOneWidget);
    });

    testWidgets('sbagliato e scaduto mostrano la loro frase', (tester) async {
      _vista(tester);
      await _mostra(tester, _codice(stato: BaStatoCodice.sbagliato, fraseStato: 'Il codice non è giusto.'));
      expect(find.text('Il codice non è giusto.'), findsOneWidget);
      await _mostra(tester, _codice(stato: BaStatoCodice.scaduto, fraseStato: 'Il codice è scaduto.'));
      expect(find.text('Il codice è scaduto.'), findsOneWidget);
    });
  });

  group('consenso (P4, R2)', () {
    testWidgets('P4: la riga «Salirai a microfono spento» e l\'azione che dice cosa succede', (tester) async {
      _vista(tester);
      await _mostra(tester, _consenso());
      expect(find.text('Con il consenso il tuo account passa da ascoltatore a partecipante.'), findsOneWidget);
      expect(find.text('Salirai a microfono spento.'), findsOneWidget);
      expect(find.text('Acconsento e salgo'), findsOneWidget);
      expect(_pillola(tester, 'Acconsento e salgo').variante, BaVariantePillola.chiara);
    });

    testWidgets('R2: senza la riga, e senza spazio vuoto dopo l\'ultimo paragrafo', (tester) async {
      _vista(tester);
      await _mostra(tester, _consenso(rigaSale: null, azione: 'Acconsento e continuo'));
      expect(find.text('Salirai a microfono spento.'), findsNothing);
      expect(find.text('Acconsento e continuo'), findsOneWidget);
      final corpo = find.descendant(of: find.byType(SingleChildScrollView), matching: find.byType(Column)).first;
      final ultimo = find.text('Con il consenso il tuo account passa da ascoltatore a partecipante.');
      expect(tester.getRect(corpo).bottom, closeTo(tester.getRect(ultimo).bottom, 0.5));
    });

    testWidgets('il consenso è un\'azione sola: una primaria chiara e «Non ora»', (tester) async {
      _vista(tester);
      await _mostra(tester, _consenso());
      expect(find.byType(BaPillola), findsNWidgets(2));
    });
  });

  group('tutti i passi a testo 2,0 e sul tablet', () {
    final passi = <String, BaPassoFoglio Function()>{
      'avviso': _avviso,
      'numero': () => _numero(errore: 'Il numero non sembra giusto.'),
      'codice': () => _codice(stato: BaStatoCodice.sbagliato, fraseStato: 'Il codice non è giusto.'),
      'consenso': _consenso,
    };
    for (final MapEntry(key: nome, value: passo) in passi.entries) {
      testWidgets('$nome: si costruisce a 2,0 e le azioni restano visibili', (tester) async {
        _vista(tester, testo: BaScalaTokens.maxTesto);
        await _mostra(tester, passo());
        expect(tester.takeException(), isNull);
        expect(find.text('Non ora'), findsOneWidget);
        final r = tester.getRect(find.text('Non ora'));
        expect(r.bottom, lessThanOrEqualTo(800));
        expect(r.top, greaterThan(0));
      });

      testWidgets('$nome: sul tablet sta nella colonna', (tester) async {
        _vista(tester, larghezza: 744, altezza: 1000);
        await _mostra(tester, passo());
        expect(tester.takeException(), isNull);
        expect(tester.getSize(find.byType(BaFoglio)).width, 744);
      });
    }
  });
}
