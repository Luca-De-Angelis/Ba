import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/anello.dart';
import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/glifo.dart';
import 'package:ba/design_system/presenza.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

// Il movimento passa da `BaMovimentoTokens.durata()` / `statico` (task 036). `statico` è vero con
// «riduci movimento» (`disableAnimations`) **o** con lo screen reader (`accessibleNavigation`).
// I componenti che animano sono cinque: BaTouchable, BaGlifo, BaAnello, BaPresenza (il disco del
// glifo e lo scheletro) e il foglio (`showBaFoglio`).
//
// Tre cose si provano qui, per ognuno:
//   1. **movimento normale**: le durate sono quelle dei token, come prima (nulla è cambiato);
//   2. **movimento ridotto** e **screen reader** danno lo **stesso** risultato fermo (parità);
//   3. con uno dei due segnali non resta nessuna animazione in corso.
// I test esistenti di ogni componente (con `disableAnimations`) passano senza modifiche.

/// Le condizioni di movimento: normale, ridotto, screen reader, tutti e due.
const _condizioni = <(String, bool, bool)>[
  ('normale', false, false),
  ('movimento ridotto', true, false),
  ('screen reader', false, true),
  ('movimento ridotto e screen reader', true, true),
];

MediaQueryData _dati(bool ridotto, bool screenReader) =>
    MediaQueryData(size: const Size(800, 600), disableAnimations: ridotto, accessibleNavigation: screenReader);

Widget _app(Widget child, {bool ridotto = false, bool screenReader = false}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: _dati(ridotto, screenReader),
        child: Align(alignment: Alignment.topLeft, child: child),
      ),
    );

BaPresenza _presenza({bool microfonoSpento = false, bool scheletro = false}) => BaPresenza(
      semanticsLabel: 'Marta B.',
      indiceTinta: 4,
      indiceSagoma: 1,
      iniziali: 'MB',
      microfonoSpento: microfonoSpento,
      scheletro: scheletro,
      onTap: () {},
    );

void main() {
  group('durata() e statico', () {
    testWidgets('statico è vero con movimento ridotto o con lo screen reader; durata() vale zero allora, il valore del token altrimenti', (tester) async {
      late BuildContext contesto;
      for (final (nome, ridotto, screenReader) in _condizioni) {
        await tester.pumpWidget(_app(Builder(builder: (c) {
          contesto = c;
          return const SizedBox();
        }), ridotto: ridotto, screenReader: screenReader));
        final fermo = ridotto || screenReader;
        expect(BaMovimentoTokens.statico(contesto), fermo, reason: nome);
        for (final d in [BaMovimentoTokens.foglio, BaMovimentoTokens.glifo, BaMovimentoTokens.premutoAndata, BaMovimentoTokens.premutoRitorno]) {
          expect(BaMovimentoTokens.durata(contesto, d), fermo ? Duration.zero : d, reason: '$nome · $d');
        }
      }
    });

    test('i valori dei token di durata non sono cambiati', () {
      expect(BaMovimentoTokens.foglio, const Duration(milliseconds: 240));
      expect(BaMovimentoTokens.glifo, const Duration(milliseconds: 140));
    });
  });

  group('BaGlifo: la dissolvenza', () {
    for (final (nome, ridotto, screenReader) in _condizioni) {
      testWidgets('$nome: durata ${ridotto || screenReader ? 'zero' : 'del token (140 ms)'}', (tester) async {
        await tester.pumpWidget(_app(const BaGlifo(tipo: BaTipoGlifo.microfono, acceso: true), ridotto: ridotto, screenReader: screenReader));
        final durata = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).duration;
        expect(durata, ridotto || screenReader ? Duration.zero : BaMovimentoTokens.glifo);
      });
    }
  });

  group('BaTouchable: il premuto', () {
    for (final (nome, ridotto, screenReader) in _condizioni) {
      testWidgets('$nome: durata e scala del premuto', (tester) async {
        await tester.pumpWidget(_app(
          BaTouchable(semanticsLabel: 'Prova', onTap: () {}, child: const SizedBox(width: 100, height: 60)),
          ridotto: ridotto,
          screenReader: screenReader,
        ));
        final fermo = ridotto || screenReader;
        AnimatedScale scala() => tester.widget<AnimatedScale>(find.byType(AnimatedScale).first);
        expect(scala().duration, fermo ? Duration.zero : BaMovimentoTokens.premutoRitorno, reason: '$nome a riposo');
        final riposo = scala().scale;

        final gesto = await tester.startGesture(tester.getCenter(find.byType(BaTouchable)));
        await tester.pump();
        expect(scala().duration, fermo ? Duration.zero : BaMovimentoTokens.premutoAndata, reason: '$nome premuto');
        expect(scala().scale, fermo ? riposo : BaControlloTokens.premutoScala, reason: '$nome: la scala del premuto si omette solo da fermo');
        await gesto.up();
        await tester.pump();
      });
    }
  });

  group('BaAnello: il canale veloce', () {
    Widget anello(bool parla, {required bool ridotto, required bool screenReader}) => _app(
          SizedBox.square(
            dimension: 88,
            child: BaAnello(diametro: 88, bordo: BorderRadius.circular(44), parla: parla, ampiezza: 1, voci: 1, lineaInstabile: false, keyline: BaColorTokens.voceKeyline),
          ),
          ridotto: ridotto,
          screenReader: screenReader,
        );

    double comparsa(WidgetTester tester) => tester
        .widget<FadeTransition>(find.ancestor(of: find.byType(ScaleTransition), matching: find.byType(FadeTransition)))
        .opacity
        .value;

    for (final (nome, ridotto, screenReader) in _condizioni) {
      testWidgets('$nome: ${ridotto || screenReader ? 'compare subito, senza animazioni' : 'compare in 70 ms'}', (tester) async {
        await tester.pumpWidget(anello(false, ridotto: ridotto, screenReader: screenReader));
        await tester.pumpWidget(anello(true, ridotto: ridotto, screenReader: screenReader));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 35));
        if (ridotto || screenReader) {
          expect(comparsa(tester), 1.0, reason: '$nome: subito');
          expect(tester.hasRunningAnimations, isFalse, reason: '$nome: nessuna animazione in corso');
        } else {
          expect(comparsa(tester), closeTo(0.5, 0.01), reason: 'a metà dei 70 ms, come prima');
          expect(tester.hasRunningAnimations, isTrue);
        }
      });
    }
  });

  group('BaPresenza: il disco del glifo e lo scheletro', () {
    for (final (nome, ridotto, screenReader) in _condizioni) {
      testWidgets('$nome: il glifo ${ridotto || screenReader ? 'compare subito' : 'compare in 140 ms'}', (tester) async {
        await tester.pumpWidget(_app(BaDiametro(diametro: 88, child: _presenza()), ridotto: ridotto, screenReader: screenReader));
        await tester.pumpWidget(_app(BaDiametro(diametro: 88, child: _presenza(microfonoSpento: true)), ridotto: ridotto, screenReader: screenReader));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 70));
        final fade = find.ancestor(of: find.byType(BaGlifo), matching: find.byType(FadeTransition)).last;
        if (ridotto || screenReader) {
          expect(tester.widget<FadeTransition>(fade).opacity.value, 1.0, reason: nome);
          expect(tester.hasRunningAnimations, isFalse, reason: nome);
        } else {
          expect(tester.widget<FadeTransition>(fade).opacity.value, closeTo(0.5, 0.01), reason: 'a metà dei 140 ms, come prima');
        }
      });

      testWidgets('$nome: lo scheletro ${ridotto || screenReader ? 'sta fermo' : 'respira'}', (tester) async {
        await tester.pumpWidget(_app(BaDiametro(diametro: 88, child: _presenza(scheletro: true)), ridotto: ridotto, screenReader: screenReader));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.hasRunningAnimations, !(ridotto || screenReader), reason: nome);
      });
    }
  });

  group('il foglio sale', () {
    const apri = Key('apri');
    const titolo = 'Titolo del foglio';

    Widget app({required bool ridotto, required bool screenReader}) => WidgetsApp(
          color: BaColorTokens.fondoApp,
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(settings: settings, pageBuilder: (context, _, _) => builder(context)),
          home: MediaQuery(
            data: _dati(ridotto, screenReader).copyWith(size: const Size(360, 800)),
            child: Builder(
              builder: (context) => Align(
                alignment: Alignment.topLeft,
                child: BaTouchable(
                  key: apri,
                  semanticsLabel: 'Apri',
                  onTap: () => showBaFoglio<void>(context, builder: (_) => BaFoglio.richiesta(titolo: titolo, sottotitolo: 'Un solo gesto', paragrafi: const ['Accendi il microfono.'], azioni: [BaAzioneFoglio(testo: 'Sali', semanticsLabel: 'Sali', onTap: () {})]), etichettaVelo: 'Chiudi'),
                  child: const SizedBox(width: 100, height: 60),
                ),
              ),
            ),
          ),
        );

    Future<List<double>> posizioni(WidgetTester tester, bool ridotto, bool screenReader) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const SizedBox()); // un'app nuova a ogni scenario: il foglio di prima non resta
      await tester.pumpWidget(app(ridotto: ridotto, screenReader: screenReader));
      await tester.tap(find.byKey(apri));
      await tester.pump();
      final cime = <double>[];
      for (final ms in [0, 100, 140, 300]) {
        if (ms > 0) await tester.pump(Duration(milliseconds: ms == 100 ? 100 : ms == 140 ? 40 : 160));
        cime.add(tester.getTopLeft(find.text(titolo)).dy);
      }
      return cime;
    }

    testWidgets('con il movimento normale sale in 240 ms (a 100 ms è ancora in cammino); ridotto e screen reader danno la stessa posizione, già al primo fotogramma', (tester) async {
      final normale = await posizioni(tester, false, false);
      expect(normale.first, greaterThanOrEqualTo(800), reason: 'all\'inizio è sotto lo schermo');
      expect(normale[1], lessThan(normale.first), reason: 'a 100 ms è in cammino');
      expect(normale[1], greaterThan(normale.last), reason: 'ma non è ancora arrivato');
      expect(normale[2], greaterThan(normale.last - 0.01), reason: 'a 140 ms ancora in cammino o appena arrivato');
      expect(normale.last, lessThan(800));

      final ridotto = await posizioni(tester, true, false);
      final screenReader = await posizioni(tester, false, true);
      expect(ridotto, screenReader, reason: 'stesso risultato fermo');
      expect(ridotto.toSet(), hasLength(1), reason: 'sempre al suo posto, dal primo fotogramma');
      expect(ridotto.first, closeTo(normale.last, 0.01), reason: 'la posizione finale è la stessa');
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
