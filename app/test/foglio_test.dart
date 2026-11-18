import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

const _apri = ValueKey('apri');
const _titolo = 'Vuoi salire sul palco?';

/// Un'app minima con un solo Navigator (come l'app vera): uno schermo con un
/// pulsante che apre il foglio. La dimensione, il testo e «riduci movimento»
/// passano dalla vista di prova.
Widget _app(WidgetBuilder foglio) => WidgetsApp(
      color: BaColorTokens.fondoApp,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: Builder(
        builder: (context) => Align(
          alignment: Alignment.topLeft,
          child: BaTouchable(
            key: _apri,
            semanticsLabel: 'Apri',
            onTap: () => showBaFoglio<void>(context, builder: foglio, etichettaVelo: 'Chiudi'),
            child: const SizedBox(width: 100, height: 60),
          ),
        ),
      ),
    );

void _vista(WidgetTester tester, {double larghezza = 360, double altezza = 800, double testo = 1.0, bool riduci = false}) {
  tester.view.physicalSize = Size(larghezza, altezza);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = testo;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: riduci);
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
  });
}

class FakeAccessibilityFeatures implements AccessibilityFeatures {
  const FakeAccessibilityFeatures({this.disableAnimations = false});
  @override
  final bool disableAnimations;
  @override
  bool get accessibleNavigation => false;
  @override
  bool get boldText => false;
  @override
  bool get highContrast => false;
  @override
  bool get invertColors => false;
  @override
  bool get onOffSwitchLabels => false;
  @override
  bool get reduceMotion => disableAnimations;
  @override
  dynamic noSuchMethod(Invocation invocation) => false;
}

BaFoglio _richiesta({VoidCallback? onSali}) => BaFoglio.richiesta(
      titolo: _titolo,
      sottotitolo: 'Un solo gesto',
      paragrafi: const ['Accendi il microfono per parlare.'],
      azioni: [
        BaAzioneFoglio(testo: 'Sali', semanticsLabel: 'Sali sul palco', onTap: onSali ?? () {}),
        BaAzioneFoglio(testo: 'Non ora', semanticsLabel: 'Non ora', onTap: () {}),
      ],
    );

/// Un foglio con un corpo molto più alto dello schermo.
BaFoglio _lungo() => BaFoglio(
      semanticsLabel: 'Foglio lungo',
      corpo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 40; i++) Text('Riga $i del contenuto che scorre', key: ValueKey('riga$i')),
        ],
      ),
      azioni: [
        BaPillola(testo: 'Fatto', semanticsLabel: 'Fatto', onTap: () {}),
      ],
    );

Finder _sheet() => find.byWidgetPredicate((w) =>
    w is DecoratedBox &&
    w.decoration is BoxDecoration &&
    (w.decoration as BoxDecoration).color == BaColorTokens.superficieFoglio);

Future<void> _apriFoglio(WidgetTester tester) async {
  await tester.tap(find.byKey(_apri));
  await tester.pump();
}

double _cima(WidgetTester tester) => tester.getTopLeft(find.text(_titolo)).dy;

List<String> _etichette(WidgetTester tester) {
  final radice = tester.binding.renderViews.first.owner!.semanticsOwner!.rootSemanticsNode!;
  final out = <String>[];
  void visita(SemanticsNode n) {
    if (n.label.isNotEmpty) out.add(n.label);
    n.visitChildren((c) {
      visita(c);
      return true;
    });
  }

  visita(radice);
  return out;
}

void main() {
  group('salita', () {
    testWidgets('sale in 240 ms e si ferma', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app((_) => _richiesta()));
      await _apriFoglio(tester);
      final partenza = _cima(tester);
      expect(partenza, greaterThanOrEqualTo(800), reason: 'all\'inizio è sotto lo schermo');

      await tester.pump(const Duration(milliseconds: 100));
      final aMeta = _cima(tester);
      expect(aMeta, lessThan(partenza));

      await tester.pump(BaMovimentoTokens.foglio);
      await tester.pump(const Duration(milliseconds: 1));
      final arrivo = _cima(tester);
      expect(arrivo, lessThan(aMeta));
      expect(arrivo, lessThan(800));
      await tester.pump(const Duration(milliseconds: 300));
      expect(_cima(tester), arrivo, reason: 'fermo: nessun rimbalzo');
    });

    testWidgets('con «riduci movimento» è subito al suo posto', (tester) async {
      _vista(tester, riduci: true);
      await tester.pumpWidget(_app((_) => _richiesta()));
      await _apriFoglio(tester);
      await tester.pump();
      final arrivo = _cima(tester);
      expect(arrivo, lessThan(800));
      await tester.pump(const Duration(milliseconds: 300));
      expect(_cima(tester), arrivo);
    });

    testWidgets('la curva non supera mai la posizione finale (niente striscia vuota sotto)', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app((_) => _richiesta()));
      await _apriFoglio(tester);
      for (var ms = 0; ms <= 260; ms += 10) {
        final r = tester.getRect(_sheet());
        expect(r.bottom, greaterThanOrEqualTo(800 - 0.01), reason: 'a $ms ms il fondo non risale sopra lo schermo');
        await tester.pump(const Duration(milliseconds: 10));
      }
    });
  });

  group('chiusura', () {
    testWidgets('il velo chiude', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app((_) => _richiesta()));
      await _apriFoglio(tester);
      await tester.pumpAndSettle();
      expect(find.text(_titolo), findsOneWidget);
      await tester.tapAt(const Offset(180, 300));
      await tester.pumpAndSettle();
      expect(find.text(_titolo), findsNothing);
    });

    testWidgets('il gesto «indietro» del sistema chiude', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app((_) => _richiesta()));
      await _apriFoglio(tester);
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text(_titolo), findsNothing);
    });

    testWidgets('un\'azione chiude con Navigator.pop', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app((context) => BaFoglio.richiesta(
            titolo: _titolo,
            azioni: [
              BaAzioneFoglio(
                testo: 'Chiudi',
                semanticsLabel: 'Chiudi il foglio',
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          )));
      await _apriFoglio(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chiudi'));
      await tester.pumpAndSettle();
      expect(find.text(_titolo), findsNothing);
    });
  });

  group('contenuto più alto dello schermo', () {
    testWidgets('a testo 2,0 il corpo scorre e le azioni restano ancorate in basso', (tester) async {
      _vista(tester, testo: 2.0);
      await tester.pumpWidget(_app((_) => _lungo()));
      await _apriFoglio(tester);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
      expect(scroll.position.maxScrollExtent, greaterThan(0), reason: 'il corpo scorre');
      final pillola = find.byType(BaPillola);
      final prima = tester.getRect(pillola);
      expect(prima.bottom, lessThanOrEqualTo(800));

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(scroll.position.pixels, greaterThan(0));
      expect(tester.getRect(pillola), prima, reason: 'le azioni non si muovono');
    });

    testWidgets('altezza massima 0,80 sul telefono', (tester) async {
      _vista(tester, larghezza: 360, altezza: 800);
      await tester.pumpWidget(_app((_) => _lungo()));
      await _apriFoglio(tester);
      await tester.pumpAndSettle();
      expect(tester.getSize(_sheet()).height, closeTo(800 * BaAccessoTokens.foglioAltezzaTelefono, 1.01));
      expect(tester.getSize(_sheet()).width, 360);
    });

    testWidgets('altezza massima 0,62 sul tablet, nella colonna centrale', (tester) async {
      _vista(tester, larghezza: 744, altezza: 1000);
      await tester.pumpWidget(_app((_) => _lungo()));
      await _apriFoglio(tester);
      await tester.pumpAndSettle();
      final r = tester.getRect(_sheet());
      expect(r.height, closeTo(1000 * BaAccessoTokens.foglioAltezzaTablet, 1.01));
      expect(r.width, BaFoglio.larghezzaFoglio(744));
      expect(r.width, lessThan(744));
      expect(r.center.dx, closeTo(372, 0.01), reason: 'al centro');
    });

    testWidgets('un foglio breve non si alza fino al massimo', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app((_) => _richiesta()));
      await _apriFoglio(tester);
      await tester.pumpAndSettle();
      expect(tester.getSize(_sheet()).height, lessThan(800 * BaAccessoTokens.foglioAltezzaTelefono));
    });
  });

  group('focus', () {
    testWidgets('il focus entra nel foglio e Tab non ne esce', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app((_) => _richiesta()));
      final nodoApri = FocusManager.instance.rootScope.traversalDescendants
          .firstWhere((n) => n.debugLabel == 'BaTouchable');
      nodoApri.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter); // apre da tastiera
      await tester.pumpAndSettle();
      expect(find.text(_titolo), findsOneWidget);
      expect(nodoApri.hasPrimaryFocus, isFalse, reason: 'il focus è uscito dallo schermo');

      // Tab percorre «Sali» e «Non ora», poi ricomincia: mai lo schermo dietro.
      final visti = <String>{};
      for (var i = 0; i < 6; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final fuoco = FocusManager.instance.primaryFocus!;
        expect(fuoco, isNot(nodoApri), reason: 'Tab $i non torna allo schermo dietro');
        if (fuoco.debugLabel == 'BaTouchable') {
          expect(fuoco.context!.findAncestorWidgetOfExactType<BaFoglio>(), isNotNull, reason: 'Tab $i');
          visti.add(fuoco.hashCode.toString());
        }
      }
      expect(visti.length, 2, reason: 'le due azioni del foglio');
    });

    testWidgets('alla chiusura il focus torna all\'elemento che aveva il focus', (tester) async {
      _vista(tester);
      await tester.pumpWidget(_app((_) => _richiesta()));
      final nodoApri = FocusManager.instance.rootScope.traversalDescendants
          .firstWhere((n) => n.debugLabel == 'BaTouchable');
      nodoApri.requestFocus();
      await tester.pump();
      // Apertura da tastiera (senza il tocco, che non cambia il focus).
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text(_titolo), findsOneWidget);
      expect(nodoApri.hasPrimaryFocus, isFalse, reason: 'il focus è passato al foglio');

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text(_titolo), findsNothing);
      expect(nodoApri.hasPrimaryFocus, isTrue, reason: 'tornato dov\'era');
    });
  });

  group('semantica', () {
    testWidgets('il foglio è una finestra col suo nome e lo sfondo è escluso', (tester) async {
      final semantica = tester.ensureSemantics();
      _vista(tester);
      await tester.pumpWidget(_app((_) => _richiesta()));
      expect(_etichette(tester), contains('Apri'), reason: 'a foglio chiuso lo schermo c\'è');

      await _apriFoglio(tester);
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.bySemanticsLabel(_titolo).first),
        isSemantics(label: _titolo, namesRoute: true, scopesRoute: true),
      );
      final etichette = _etichette(tester);
      expect(etichette, contains(_titolo));
      expect(etichette, isNot(contains('Apri')), reason: 'ciò che sta dietro è escluso');
      semantica.dispose();
    });

    testWidgets('le azioni sono bottoni con la loro etichetta; nessun annuncio dell\'arrivo', (tester) async {
      final semantica = tester.ensureSemantics();
      _vista(tester);
      await tester.pumpWidget(_app((_) => _richiesta()));
      await _apriFoglio(tester);
      await tester.pumpAndSettle();
      expect(_etichette(tester), containsAll(['Sali sul palco', 'Non ora']));
      semantica.dispose();
    });
  });

  group('varianti', () {
    testWidgets('richiesta: la prima azione è chiara; invito: attiva; le altre spente', (tester) async {
      Future<List<BaVariantePillola>> varianti(BaFoglio Function() f) async {
        _vista(tester);
        await tester.pumpWidget(_app((_) => f()));
        await _apriFoglio(tester);
        await tester.pumpAndSettle();
        final v = tester.widgetList<BaPillola>(find.byType(BaPillola)).map((p) => p.variante).toList();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        return v;
      }

      expect(await varianti(() => _richiesta()), [BaVariantePillola.chiara, BaVariantePillola.spenta]);
      expect(
        await varianti(() => BaFoglio.invito(
              titolo: 'Ti invitano',
              azioni: const [
                BaAzioneFoglio(testo: 'Entra', semanticsLabel: 'Entra'),
                BaAzioneFoglio(testo: 'No', semanticsLabel: 'No'),
              ],
            )),
        [BaVariantePillola.attiva, BaVariantePillola.spenta],
      );
    });
  });
}
