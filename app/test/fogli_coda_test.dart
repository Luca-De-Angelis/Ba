import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/foglio_passi.dart';
import 'package:ba/design_system/fogli_coda.dart';
import 'package:ba/design_system/interruttore_riga.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/riga_coda.dart';
import 'package:ba/design_system/tokens.dart';

// I contenuti dei fogli della coda e dell'attesa (task 023a): K2, W1, K1, S1, K6.

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

Widget _app(Widget foglio) => WidgetsApp(
      color: BaColorTokens.fondoApp,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: foglio,
    );

Future<void> _mostra(WidgetTester tester, Widget foglio) async {
  await tester.pumpWidget(_app(foglio));
  await tester.pump();
}

BaInterruttoreRiga _ingresso({bool acceso = false, ValueChanged<bool>? onCambia}) => BaInterruttoreRiga(
      titolo: 'Fammi entrare automaticamente',
      descrizione: 'Quando si libera un posto, la notifica ti porta alla stanza.',
      acceso: acceso,
      parolaAcceso: 'Acceso',
      parolaSpento: 'Spento',
      onCambia: onCambia,
    );

BaInterruttoreRiga _aspetta({bool acceso = false, ValueChanged<bool>? onCambia}) => BaInterruttoreRiga(
      titolo: 'Aspetta con altri',
      descrizione: 'Un gruppo di chi aspetta, fino a 8. Non è il palco.',
      acceso: acceso,
      parolaAcceso: 'Acceso',
      parolaSpento: 'Spento',
      onCambia: onCambia,
    );

BaFoglioMettitiInCoda _mettiti({bool conAspetta = false, ValueChanged<bool>? onIngresso, ValueChanged<bool>? onAspetta}) =>
    BaFoglioMettitiInCoda(
      titolo: 'Mettiti in coda',
      frase: 'Il palco è pieno. Se si libera un posto, te lo diciamo.',
      ingressoAutomatico: _ingresso(onCambia: onIngresso ?? (_) {}),
      aspettaConAltri: conAspetta ? _aspetta(onCambia: onAspetta ?? (_) {}) : null,
      rigaSale: 'Salirai a microfono spento.',
      mettitiInCoda: _azione('Mettiti in coda'),
      nonOra: _azione('Non ora'),
    );

BaFoglioAspettaConAltri _attesa() => BaFoglioAspettaConAltri(
      titolo: 'Aspetta con altri',
      paragrafi: const [
        BaParagrafoPasso('Un gruppo di chi aspetta come te, fino a 8. Sentite il DEN e parlate fra voi.'),
        BaParagrafoPasso('Quando si libera un posto, lasci il gruppo e sali sul palco, a microfono spento.', evidenza: true),
      ],
      entra: _azione('Entra nel gruppo'),
      nonOra: _azione('Non ora'),
    );

BaFoglioLeTueCode _code() => BaFoglioLeTueCode(
      titolo: 'Le tue code',
      frase: 'Ti avvisiamo quando si libera un posto.',
      code: [
        BaRigaCoda(nome: 'Cucina di notte', stato: 'In coda · entri a microfono spento', uscitaTesto: 'Esci dalla coda', onEsci: () {}),
        BaRigaCoda(nome: 'Fra due turni', stato: 'In coda · entri a microfono spento', uscitaTesto: 'Esci dalla coda', onEsci: () {}),
      ],
      chiudi: _azione('Chiudi'),
    );

BaFoglioCodaPiena _piena() => BaFoglioCodaPiena(
      titolo: 'La coda è piena adesso',
      frase: 'Resti nel pubblico e ascolti. Riprova fra poco.',
      haCapito: _azione('Ho capito'),
    );

BaFoglioPassaDiQua _passa() => BaFoglioPassaDiQua(
      titolo: 'Si è liberato un posto in Cucina di notte',
      paragrafi: const [
        BaParagrafoPasso('Vuoi passare di qua? Salirai a microfono spento.'),
        BaParagrafoPasso('Hai pochi secondi per decidere.', evidenza: true),
      ],
      passa: _azione('Passa'),
      restaQui: _azione('Resta qui'),
    );

BaVariantePillola _variante(WidgetTester tester, String testo) =>
    tester.widget<BaPillola>(find.widgetWithText(BaPillola, testo)).variante;

/// Un foglio con gli interruttori che cambiano davvero.
class _MettitiVivo extends StatefulWidget {
  const _MettitiVivo();

  @override
  State<_MettitiVivo> createState() => _MettitiVivoState();
}

class _MettitiVivoState extends State<_MettitiVivo> {
  bool _ingressoAcceso = false;
  bool _aspettaAcceso = false;

  @override
  Widget build(BuildContext context) => BaFoglioMettitiInCoda(
        titolo: 'Mettiti in coda',
        frase: 'Il palco è pieno.',
        ingressoAutomatico: _ingresso(acceso: _ingressoAcceso, onCambia: (v) => setState(() => _ingressoAcceso = v)),
        aspettaConAltri: _aspetta(acceso: _aspettaAcceso, onCambia: (v) => setState(() => _aspettaAcceso = v)),
        rigaSale: 'Salirai a microfono spento.',
        mettitiInCoda: _azione('Mettiti in coda'),
        nonOra: _azione('Non ora'),
      );
}

void main() {
  group('«Mettiti in coda» (K2)', () {
    testWidgets('con «Aspetta con altri»: due interruttori e «Salirai a microfono spento»', (tester) async {
      _vista(tester);
      await _mostra(tester, _mettiti(conAspetta: true));
      expect(find.byType(BaInterruttoreRiga), findsNWidgets(2));
      expect(find.text('Aspetta con altri'), findsOneWidget);
      expect(find.text('Salirai a microfono spento.'), findsOneWidget);
    });

    testWidgets('senza la capacità la riga non lascia traccia: né etichetta, né spazio vuoto', (tester) async {
      _vista(tester);
      await _mostra(tester, _mettiti(conAspetta: true));
      final gap = tester.getTopLeft(find.byType(BaInterruttoreRiga).at(1)).dy -
          tester.getRect(find.byType(BaInterruttoreRiga).first).bottom;

      await _mostra(tester, _mettiti(conAspetta: false));
      expect(find.byType(BaInterruttoreRiga), findsOneWidget);
      expect(find.text('Aspetta con altri'), findsNothing);
      expect(find.textContaining('gruppo'), findsNothing, reason: 'nessun invito, nessun segno del pagante');
      final distanza = tester.getTopLeft(find.text('Salirai a microfono spento.')).dy -
          tester.getRect(find.byType(BaInterruttoreRiga).first).bottom;
      expect(distanza, closeTo(gap, 0.01), reason: 'la nota sta a distanza di una voce normale, senza buco');
    });

    testWidgets('«Mettiti in coda» è attiva (a filo), «Non ora» spenta', (tester) async {
      _vista(tester);
      await _mostra(tester, _mettiti(conAspetta: true));
      expect(_variante(tester, 'Mettiti in coda'), BaVariantePillola.attiva);
      expect(_variante(tester, 'Non ora'), BaVariantePillola.spenta);
    });

    testWidgets('gli interruttori cambiano stato dal chiamante', (tester) async {
      _vista(tester);
      await _mostra(tester, const _MettitiVivo());
      expect(find.text('SPENTO'), findsNWidgets(2));
      await tester.tap(find.text('Fammi entrare automaticamente'));
      await tester.pump();
      expect(find.text('ACCESO'), findsOneWidget);
      await tester.tap(find.text('Aspetta con altri'));
      await tester.pump();
      expect(find.text('ACCESO'), findsNWidgets(2));
    });
  });

  group('«Aspetta con altri» (W1)', () {
    testWidgets('due paragrafi, «Entra nel gruppo» chiara e «Non ora»', (tester) async {
      _vista(tester);
      await _mostra(tester, _attesa());
      expect(find.textContaining('Sentite il DEN'), findsOneWidget);
      expect(_variante(tester, 'Entra nel gruppo'), BaVariantePillola.chiara);
      expect(_variante(tester, 'Non ora'), BaVariantePillola.spenta);
    });
  });

  group('«Le tue code» (K1)', () {
    testWidgets('una riga per coda, nessuna posizione né conteggio, solo «Chiudi»', (tester) async {
      _vista(tester);
      await _mostra(tester, _code());
      expect(find.byType(BaRigaCoda), findsNWidgets(2));
      expect(find.text('Cucina di notte'), findsOneWidget);
      expect(find.text('Fra due turni'), findsOneWidget);
      // Le pillole: «Esci dalla coda» di ogni riga e l'unica azione del foglio.
      expect(find.byType(BaPillola), findsNWidgets(3));
      expect(_variante(tester, 'Chiudi'), BaVariantePillola.spenta);
      final tutti = find.byType(Text).evaluate().map((e) => (e.widget as Text).data ?? '').join(' ');
      expect(RegExp(r'\d').hasMatch(tutti), isFalse, reason: 'nessun numero: posizione, conteggio e massimo non esistono');
    });
  });

  group('«La coda è piena adesso» (S1)', () {
    testWidgets('la frase e «Ho capito» (chiara, come nel prototipo)', (tester) async {
      _vista(tester);
      await _mostra(tester, _piena());
      expect(find.text('La coda è piena adesso'), findsOneWidget);
      expect(find.text('Resti nel pubblico e ascolti. Riprova fra poco.'), findsOneWidget);
      expect(_variante(tester, 'Ho capito'), BaVariantePillola.chiara);
      expect(find.byType(BaPillola), findsOneWidget);
    });
  });

  group('«Vuoi passare di qua?» (K6)', () {
    testWidgets('«Passa» attiva, «Resta qui» spenta e una frase ferma, senza conto alla rovescia', (tester) async {
      _vista(tester);
      await _mostra(tester, _passa());
      expect(find.text('Hai pochi secondi per decidere.'), findsOneWidget);
      expect(_variante(tester, 'Passa'), BaVariantePillola.attiva);
      expect(_variante(tester, 'Resta qui'), BaVariantePillola.spenta);
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pump(const Duration(seconds: 40));
      expect(find.text('Hai pochi secondi per decidere.'), findsOneWidget, reason: 'nessun timer: la frase non cambia');
    });
  });

  group('tutti i fogli a testo 2,0 e sul tablet', () {
    final fogli = <String, Widget Function()>{
      'mettiti in coda': () => _mettiti(conAspetta: true),
      'mettiti in coda (senza la seconda riga)': () => _mettiti(),
      'aspetta con altri': _attesa,
      'le tue code': _code,
      'coda piena': _piena,
      'passa di qua': _passa,
    };
    for (final MapEntry(key: nome, value: foglio) in fogli.entries) {
      testWidgets('$nome: a 2,0 si costruisce e l\'ultima azione resta a vista', (tester) async {
        _vista(tester, testo: BaScalaTokens.maxTesto);
        await _mostra(tester, foglio());
        expect(tester.takeException(), isNull);
        final azioni = find.byType(BaPillola);
        final ultima = tester.getRect(azioni.last);
        expect(ultima.bottom, lessThanOrEqualTo(800));
        expect(ultima.top, greaterThan(0));
      });

      testWidgets('$nome: sul tablet si costruisce', (tester) async {
        _vista(tester, larghezza: 744, altezza: 1000);
        await _mostra(tester, foglio());
        expect(tester.takeException(), isNull);
        expect(find.byType(BaFoglio), findsOneWidget);
      });
    }
  });
}
