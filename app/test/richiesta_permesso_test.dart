import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/richiesta_permesso.dart';
import 'package:ba/design_system/segno_errore.dart';
import 'package:ba/design_system/tokens.dart';

// Il foglio che chiede un permesso (task 034): N1 (avvisi) e Z1 (posizione) del prototipo 031, con
// due azioni alla pari, e lo stato dopo il rifiuto, senza colpa.

void _vista(WidgetTester tester, {double larghezza = 360, double altezza = 800, double testo = 1.0}) {
  tester.view.physicalSize = Size(larghezza, altezza);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = testo;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

BaAzioneFoglio _azione(String testo, {VoidCallback? onTap, BaVariantePillola? variante}) =>
    BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: onTap ?? () {}, variante: variante);

Widget _app(Widget foglio) => WidgetsApp(
      color: BaColorTokens.fondoApp,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(settings: settings, pageBuilder: (context, _, _) => builder(context)),
      home: foglio,
    );

const _titolo = 'Avvisi sui DEN';
const _frase = 'BA può avvisarti quando si apre un DEN su un tema o una lingua che scegli. Non avvisa mai per le persone.';
const _titoloDopo = 'Avvisi spenti';
const _fraseDopo = 'Va bene così. Gli avvisi sui DEN restano spenti.';
const _seCambiIdea = 'Se cambi idea, li accendi dalle impostazioni del telefono.';

BaRichiestaPermesso _richiesta({VoidCallback? onConsenti, VoidCallback? onNonOra, BaVariantePillola? varianteConsenti, BaVariantePillola? varianteNonOra}) =>
    BaRichiestaPermesso(
      titolo: _titolo,
      frase: _frase,
      consenti: _azione('Consenti', onTap: onConsenti, variante: varianteConsenti),
      nonOra: _azione('Non ora', onTap: onNonOra, variante: varianteNonOra),
    );

BaRichiestaPermesso _dopo({VoidCallback? onApri, VoidCallback? onChiudi, bool conSeCambiIdea = true}) => BaRichiestaPermesso.dopoIlRifiuto(
      titolo: _titoloDopo,
      frase: _fraseDopo,
      fraseSeCambiIdea: conSeCambiIdea ? _seCambiIdea : null,
      apriImpostazioni: _azione('Apri le impostazioni del telefono', onTap: onApri),
      chiudi: _azione('Chiudi', onTap: onChiudi),
    );

const _seconda = 'Puoi spegnerli quando vuoi.';

BaRichiestaPermesso _richiestaConSeconda() => BaRichiestaPermesso(
      titolo: _titolo,
      frase: _frase,
      fraseOpzionale: _seconda,
      consenti: _azione('Consenti gli avvisi'),
      nonOra: _azione('Non ora'),
    );

BaPillola _pillola(WidgetTester tester, String testo) => tester.widget<BaPillola>(find.widgetWithText(BaPillola, testo));

Finder _riquadro() => find.byWidgetPredicate((w) =>
    w is DecoratedBox && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).color == BaColorTokens.superficieFoglio);

void main() {
  group('la richiesta: due azioni alla pari', () {
    testWidgets('il titolo, la frase sul perché, «Consenti» e «Non ora»', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_richiesta()));
      expect(find.text(_titolo), findsOneWidget);
      expect(find.text(_frase), findsOneWidget);
      expect(find.byType(BaPillola), findsNWidgets(2));
      expect(find.text('Consenti'), findsOneWidget);
      expect(find.text('Non ora'), findsOneWidget);
      expect(tester.widget<BaRichiestaPermesso>(find.byType(BaRichiestaPermesso)).stato, BaStatoRichiestaPermesso.richiesta);
    });

    testWidgets('nessuna delle due è «chiara»: tutte e due attive, a filetto, con lo stesso peso', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_richiesta()));
      expect(_pillola(tester, 'Consenti').variante, BaVariantePillola.attiva);
      expect(_pillola(tester, 'Non ora').variante, BaVariantePillola.attiva);
      for (final p in tester.widgetList<BaPillola>(find.byType(BaPillola))) {
        expect(p.variante, isNot(BaVariantePillola.chiara), reason: 'BaRegole 1: la chiara solo dove il gesto è obbligato');
      }
    });

    testWidgets('le varianti sono imposte: anche se il chiamante dà una «chiara», restano alla pari', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_richiesta(varianteConsenti: BaVariantePillola.chiara, varianteNonOra: BaVariantePillola.spenta)));
      expect(_pillola(tester, 'Consenti').variante, BaVariantePillola.attiva);
      expect(_pillola(tester, 'Non ora').variante, BaVariantePillola.attiva);
    });

    testWidgets('le due pillole hanno la stessa larghezza e la stessa altezza, una sotto l\'altra', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_richiesta()));
      final a = tester.getRect(find.widgetWithText(BaPillola, 'Consenti'));
      final b = tester.getRect(find.widgetWithText(BaPillola, 'Non ora'));
      expect(a.width, b.width);
      expect(a.height, b.height);
      expect(a.left, b.left);
      expect(b.top, greaterThanOrEqualTo(a.bottom));
    });

    testWidgets('le azioni fanno quello che dice il chiamante, e il componente non decide niente', (tester) async {
      _vista(tester);
      var consenti = 0, nonOra = 0;
      await tester.pumpWidget(_app(_richiesta(onConsenti: () => consenti++, onNonOra: () => nonOra++)));
      await tester.tap(find.text('Consenti'));
      await tester.tap(find.text('Non ora'));
      await tester.tap(find.text('Non ora'));
      expect((consenti, nonOra), (1, 2));
    });

    testWidgets('per lo screen reader è una finestra col nome del titolo', (tester) async {
      _vista(tester);
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_richiesta()));
      expect(find.bySemanticsLabel(_titolo), findsWidgets);
      semantica.dispose();
    });
  });

  group('la richiesta: la seconda frase, più piccola, è facoltativa', () {
    testWidgets('con la seconda frase sta sotto la prima, più piccola e nello stesso colore; senza, il foglio è quello di prima', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_richiestaConSeconda()));
      final prima = tester.widget<Text>(find.text(_frase));
      final seconda = tester.widget<Text>(find.text(_seconda));
      expect(tester.getTopLeft(find.text(_seconda)).dy, greaterThan(tester.getBottomLeft(find.text(_frase)).dy));
      expect(seconda.style?.fontSize, BaTestoTokens.minore.fontSize);
      expect(seconda.style!.fontSize!, lessThan(prima.style!.fontSize!));
      expect(seconda.style?.color, prima.style?.color);
      expect(_pillola(tester, 'Consenti gli avvisi').variante, BaVariantePillola.attiva);
      expect(_pillola(tester, 'Non ora').variante, BaVariantePillola.attiva);

      await tester.pumpWidget(_app(_richiesta()));
      expect(find.text(_frase), findsOneWidget);
      expect(find.text(_seconda), findsNothing);
      final soloUna = tester.getSize(_riquadro()).height;
      await tester.pumpWidget(_app(_richiestaConSeconda()));
      expect(tester.getSize(_riquadro()).height, greaterThan(soloUna), reason: 'la seconda frase si vede, non è nascosta');
    });
  });

  group('dopo il rifiuto: una frase senza colpa', () {
    testWidgets('ha il suo stato: la frase, «Se cambi idea…», «Apri le impostazioni del telefono» attiva e «Chiudi» spenta', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_dopo()));
      expect(tester.widget<BaRichiestaPermesso>(find.byType(BaRichiestaPermesso)).stato, BaStatoRichiestaPermesso.dopoIlRifiuto);
      expect(find.text(_titoloDopo), findsOneWidget);
      expect(find.text(_fraseDopo), findsOneWidget);
      expect(find.text(_seCambiIdea), findsOneWidget);
      expect(find.text('Consenti'), findsNothing);
      expect(_pillola(tester, 'Apri le impostazioni del telefono').variante, BaVariantePillola.attiva);
      expect(_pillola(tester, 'Chiudi').variante, BaVariantePillola.spenta);
      for (final p in tester.widgetList<BaPillola>(find.byType(BaPillola))) {
        expect(p.variante, isNot(BaVariantePillola.chiara));
      }
    });

    testWidgets('la seconda frase è facoltativa: senza, resta una frase sola', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_dopo(conSeCambiIdea: false)));
      expect(find.text(_fraseDopo), findsOneWidget);
      expect(find.text(_seCambiIdea), findsNothing);
    });

    testWidgets('non ha colpa: nessun segno d\'errore, nessun colore d\'errore, nessuna parola di rimprovero', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app(_dopo()));
      expect(find.byType(BaSegnoErrore), findsNothing);
      for (final t in tester.widgetList<Text>(find.byType(Text))) {
        expect(t.style?.color, isNot(BaColorTokens.erroreTesto), reason: t.data);
        expect(t.data, isNot(contains('errore')));
        expect(t.data, isNot(contains('sbagli')));
        expect(t.data, isNot(contains('colpa')));
        expect(t.data, isNot(contains('sicur')), reason: 'nessun «sei sicuro?»');
      }
    });

    testWidgets('le due azioni fanno quello che dice il chiamante', (tester) async {
      _vista(tester);
      var apri = 0, chiudi = 0;
      await tester.pumpWidget(_app(_dopo(onApri: () => apri++, onChiudi: () => chiudi++)));
      await tester.tap(find.text('Apri le impostazioni del telefono'));
      await tester.tap(find.text('Chiudi'));
      expect((apri, chiudi), (1, 1));
    });
  });

  group('testo grande e larghezze', () {
    for (final (larghezza, altezza) in [(360.0, 800.0), (744.0, 1133.0)]) {
      testWidgets('con la seconda frase, a 2,0 su ${larghezza.round()} dp nulla si taglia e le azioni restano ancorate', (tester) async {
        _vista(tester, larghezza: larghezza, altezza: altezza, testo: BaScalaTokens.maxTesto);
        await tester.pumpWidget(_app(_richiestaConSeconda()));
        expect(tester.takeException(), isNull);
        final tetto = altezza * (larghezza >= 600 ? BaAccessoTokens.foglioAltezzaTablet : BaAccessoTokens.foglioAltezzaTelefono);
        expect(tester.getSize(_riquadro()).height, lessThanOrEqualTo(tetto + 0.01));
        final pillole = tester.widgetList<BaPillola>(find.byType(BaPillola)).toList();
        expect(tester.getRect(find.byWidget(pillole.last)).bottom, lessThanOrEqualTo(altezza), reason: 'le azioni restano sullo schermo');
        expect(tester.getSize(find.byWidget(pillole.first)).width, tester.getSize(find.byWidget(pillole.last)).width, reason: 'righe uguali fra loro');
        for (final t in tester.widgetList<Text>(find.byType(Text))) {
          expect(tester.getRect(find.byWidget(t)).right, lessThanOrEqualTo(larghezza), reason: t.data);
        }
      });
    }

    for (final (larghezza, altezza) in [(360.0, 800.0), (744.0, 1133.0)]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp nulla si taglia, le azioni restano ancorate, le pillole di una coppia sono uguali', (tester) async {
        _vista(tester, larghezza: larghezza, altezza: altezza, testo: BaScalaTokens.maxTesto);
        for (final foglio in [_richiesta(), _dopo()]) {
          await tester.pumpWidget(_app(foglio));
          expect(tester.takeException(), isNull);
          final tetto = altezza * (larghezza >= 600 ? BaAccessoTokens.foglioAltezzaTablet : BaAccessoTokens.foglioAltezzaTelefono);
          expect(tester.getSize(_riquadro()).height, lessThanOrEqualTo(tetto + 0.01));
          final pillole = tester.widgetList<BaPillola>(find.byType(BaPillola)).toList();
          expect(tester.getRect(find.byWidget(pillole.last)).bottom, lessThanOrEqualTo(altezza), reason: 'le azioni restano sullo schermo');
          final rettangoli = [for (final p in pillole) tester.getRect(find.byWidget(p))];
          expect(rettangoli.first.width, rettangoli.last.width, reason: 'righe uguali fra loro');
          for (final t in tester.widgetList<Text>(find.byType(Text))) {
            expect(tester.getRect(find.byWidget(t)).right, lessThanOrEqualTo(larghezza), reason: t.data);
          }
        }
      });
    }
  });
}
