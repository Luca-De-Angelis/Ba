import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/banda_posto.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/tratteggio.dart';

Widget _app(Widget child, {double testo = 1.0}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: const Size(360, 800), textScaler: TextScaler.linear(testo)),
        child: Align(alignment: Alignment.topCenter, child: SizedBox(width: 320, child: child)),
      ),
    );

/// Le due frasi della stessa banda, composte come le comporrà il chiamante:
/// sotto i due minuti «ancora per un momento», da due minuti in su un'ora.
String _frase(Duration durata) {
  final persa = DateTime(2026, 11, 18, 21, 40, 50);
  final ora = BaCodaTokens.oraDelPosto(persa, durata);
  return ora == null
      ? 'Il posto resta tuo ancora per un momento.'
      : 'Il posto resta tuo fino alle ${BaOra.hhmm(ora)}.';
}

void main() {
  group('la stessa banda regge 30 secondi e 5 minuti', () {
    testWidgets('30 secondi: «ancora per un momento», nessuna ora', (tester) async {
      await tester.pumpWidget(_app(BaBandaPosto(testo: _frase(BaCodaTokens.postoConservatoFree))));
      expect(find.text('Il posto resta tuo ancora per un momento.'), findsOneWidget);
      expect(find.textContaining('fino alle'), findsNothing);
    });

    testWidgets('5 minuti: l\'ora ferma, senza cambiare schermata né componente', (tester) async {
      await tester.pumpWidget(_app(BaBandaPosto(testo: _frase(const Duration(minutes: 5)))));
      expect(find.text('Il posto resta tuo fino alle 21:45.'), findsOneWidget);
    });

    testWidgets('si passa dall\'una all\'altra con lo stesso widget: cambia solo la frase', (tester) async {
      await tester.pumpWidget(_app(BaBandaPosto(testo: _frase(BaCodaTokens.postoConservatoFree), sottotesto: 'Il microfono è spento.')));
      final prima = tester.getSize(find.byType(BaBandaPosto));
      await tester.pumpWidget(_app(BaBandaPosto(testo: _frase(const Duration(minutes: 5)), sottotesto: 'Il microfono è spento.')));
      expect(find.byType(BaBandaPosto), findsOneWidget);
      expect(tester.getSize(find.byType(BaBandaPosto)).width, prima.width);
    });
  });

  group('un fatto fermo, mai un conto alla rovescia', () {
    testWidgets('nessun Ticker e nessuna animazione in corso', (tester) async {
      await tester.pumpWidget(_app(const BaBandaPosto(testo: 'Il posto resta tuo fino alle 21:43.')));
      expect(tester.hasRunningAnimations, isFalse);
      expect(SchedulerBinding.instance.transientCallbackCount, 0);
    });

    testWidgets('nessun Timer: il tempo che passa non cambia niente', (tester) async {
      await tester.pumpWidget(_app(const BaBandaPosto(testo: 'Il posto resta tuo fino alle 21:43.')));
      final prima = tester.getRect(find.byType(BaBandaPosto));
      await tester.pump(const Duration(minutes: 5));
      expect(find.text('Il posto resta tuo fino alle 21:43.'), findsOneWidget);
      expect(tester.getRect(find.byType(BaBandaPosto)), prima);
      expect(tester.hasRunningAnimations, isFalse);
      expect(tester.binding.hasScheduledFrame, isFalse, reason: 'niente si ridisegna da solo');
    });
  });

  group('varianti', () {
    testWidgets('posto: a filo, con il bordo e il raggio dei token', (tester) async {
      await tester.pumpWidget(_app(const BaBandaPosto(testo: 'Il posto resta tuo.')));
      expect(find.byType(BaTratteggio), findsNothing);
      final deco = tester.widget<DecoratedBox>(find.descendant(of: find.byType(BaBandaPosto), matching: find.byType(DecoratedBox)).first)
          .decoration as BoxDecoration;
      expect(deco.borderRadius, BorderRadius.circular(BaCodaTokens.bandaRaggio));
      final bordo = (deco.border! as Border).top;
      expect(bordo.width, BaCodaTokens.bandaBordo);
      expect(bordo.style, BorderStyle.solid);
      expect(deco.color, isNull, reason: 'nessun fondo');
    });

    testWidgets('permanenza: tratteggiata con il raggio e il bordo dei token', (tester) async {
      await tester.pumpWidget(_app(const BaBandaPosto(
        testo: 'Puoi restare fino alle 22:40. Poi puoi rientrare.',
        variante: BaVarianteBanda.permanenza,
      )));
      final t = tester.widget<BaTratteggio>(find.byType(BaTratteggio));
      expect(t.raggio, BaCodaTokens.bandaRaggio);
      expect(t.spessore, BaCodaTokens.bandaBordo);
      expect(t.colore, BaColorTokens.azioneAttivaBordo);
    });

    testWidgets('il sottotesto compare sotto la frase', (tester) async {
      await tester.pumpWidget(_app(const BaBandaPosto(testo: 'Frase', sottotesto: 'Sottotesto')));
      expect(tester.getTopLeft(find.text('Sottotesto')).dy, greaterThan(tester.getTopLeft(find.text('Frase')).dy));
    });
  });

  group('semantica', () {
    testWidgets('annuncia: regione viva con la frase e il sottotesto', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(const BaBandaPosto(testo: 'Hai perso la linea.', sottotesto: 'Il microfono è spento.', annuncia: true)));
      expect(
        tester.getSemantics(find.byType(BaBandaPosto)),
        matchesSemantics(label: 'Hai perso la linea. Il microfono è spento.', isLiveRegion: true),
      );
      semantica.dispose();
    });

    testWidgets('di default non annuncia (la permanenza)', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(const BaBandaPosto(testo: 'Puoi restare fino alle 22:40.', variante: BaVarianteBanda.permanenza)));
      expect(
        tester.getSemantics(find.byType(BaBandaPosto)),
        matchesSemantics(label: 'Puoi restare fino alle 22:40.', isLiveRegion: false),
      );
      semantica.dispose();
    });
  });

  for (final variante in BaVarianteBanda.values) {
    testWidgets('a testo 2,0 la frase va a capo e nulla si taglia ($variante)', (tester) async {
      await tester.pumpWidget(_app(
        BaBandaPosto(
          testo: 'Hai perso la linea. Il posto resta tuo fino alle 21:43, poi si libera.',
          sottotesto: 'Il microfono è spento.',
          variante: variante,
        ),
        testo: 2.0,
      ));
      expect(tester.takeException(), isNull);
      final banda = tester.getRect(find.byType(BaBandaPosto));
      for (final t in ['Hai perso la linea. Il posto resta tuo fino alle 21:43, poi si libera.', 'Il microfono è spento.']) {
        final r = tester.getRect(find.text(t));
        expect(banda.contains(r.topLeft) && banda.contains(r.bottomRight - const Offset(0.01, 0.01)), isTrue, reason: t);
      }
    });
  }
}
