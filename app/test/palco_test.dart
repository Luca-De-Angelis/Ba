import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/anello.dart';
import 'package:ba/design_system/palco.dart';
import 'package:ba/design_system/palco/disposizione.dart';
import 'package:ba/design_system/presenza.dart';
import 'package:ba/design_system/tokens.dart';

const _telefono = Size(360, 800);
const _tablet = Size(744, 1000);
const _scatola = Size(320, 420);

Widget _app(
  Widget child, {
  Size schermo = _telefono,
  double testo = 1,
}) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: schermo, textScaler: TextScaler.linear(testo)),
        child: Align(alignment: Alignment.topLeft, child: child),
      ),
    );

/// Il palco in una scatola di misura data.
Widget _palco(
  List<BaPersonaPalco> persone, {
  Size scatola = _scatola,
  Size schermo = _telefono,
  BaStatoPalco stato = const BaStatoPalco.vivo(),
  bool invito = true,
}) =>
    SizedBox.fromSize(
      size: scatola,
      child: BaPalco(
        persone: persone,
        larghezzaSchermo: schermo.width,
        stato: stato,
        semanticsLabel: 'Palco di prova',
        invitoTitolo: invito ? 'Il palco è libero.' : null,
        invitoTesto: invito ? 'Puoi salire quando vuoi.' : null,
      ),
    );

List<BaPersonaPalco> _persone(
  int n, {
  Set<int> parlano = const {},
  Set<int> perse = const {},
  double ampiezza = 1,
}) =>
    [
      for (var i = 0; i < n; i++)
        BaPersonaPalco(
          id: 'p$i',
          indiceTinta: i,
          indiceSagoma: i % 5,
          iniziali: 'P$i',
          semanticsLabel: 'Persona $i',
          semanticsLabelParla: 'Persona $i, sta parlando',
          parla: parlano.contains(i),
          ampiezza: parlano.contains(i) ? ampiezza : 0,
          persa: perse.contains(i),
          onTap: () {},
        ),
    ];

Finder _presenze() => find.byType(BaPresenza);

/// Gli anelli che stanno davvero disegnando una voce (`parla`).
List<BaAnello> _anelli(WidgetTester tester) =>
    tester.widgetList<BaAnello>(find.byType(BaAnello)).where((a) => a.parla).toList();

/// Il diametro: l'ingombro di una presenza meno la banda dell'anello.
double _diametro(WidgetTester tester) =>
    tester.getSize(_presenze().first).width - 2 * BaPresenza.banda;

/// I centri delle presenze, relativi all'angolo del palco, nell'ordine della
/// lista.
List<Offset> _centri(WidgetTester tester) {
  final origine = tester.getTopLeft(find.byType(BaPalco));
  return [
    for (var i = 0; i < _presenze().evaluate().length; i++)
      tester.getCenter(_presenze().at(i)) - origine,
  ];
}

/// Quante presenze per riga (righe dall'alto in basso).
List<int> _righe(List<Offset> centri) {
  final righe = <double, int>{};
  for (final c in centri) {
    final chiave = righe.keys.firstWhere(
      (y) => (y - c.dy).abs() < 0.5,
      orElse: () => c.dy,
    );
    righe[chiave] = (righe[chiave] ?? 0) + 1;
  }
  final ordinate = righe.keys.toList()..sort();
  return [for (final y in ordinate) righe[y]!];
}

/// Esegue [corpo] con `debugPrint` deviato su [messaggi] (e ripristinato prima
/// della fine del test, come vuole il binding).
Future<void> _cattura(List<String?> messaggi, Future<void> Function() corpo) async {
  final vecchio = debugPrint;
  debugPrint = (message, {wrapWidth}) => messaggi.add(message);
  try {
    await corpo();
  } finally {
    debugPrint = vecchio;
  }
}

List<Offset> _attesi(int n, Size scatola, Size schermo) =>
    disponiPalco(persone: n, scatola: scatola, larghezzaSchermo: schermo.width).centri;

void main() {
  group('disposizione', () {
    testWidgets('1 persona, schermo 360, scatola 320 × 420: 208, al centro', (tester) async {
      await tester.pumpWidget(_app(_palco(_persone(1))));
      expect(_presenze(), findsOneWidget);
      expect(_diametro(tester), 208);
      expect(_centri(tester).single, const Offset(160, 210));
    });

    testWidgets('8 persone: 88, righe 3+2+3', (tester) async {
      await tester.pumpWidget(_app(_palco(_persone(8))));
      expect(_presenze(), findsNWidgets(8));
      expect(_diametro(tester), 88);
      expect(_righe(_centri(tester)), [3, 2, 3]);
    });

    testWidgets('schermo 744: i diametri del tablet (312 per una persona)', (tester) async {
      const scatola = Size(680, 600);
      await tester.pumpWidget(_app(_palco(_persone(1), scatola: scatola, schermo: _tablet), schermo: _tablet));
      expect(_diametro(tester), 312);
      await tester.pumpWidget(_app(_palco(_persone(2), scatola: scatola, schermo: _tablet), schermo: _tablet));
      expect(_diametro(tester), 234);
    });

    testWidgets('i centri sono quelli di disponiPalco, nell\'ordine della lista', (tester) async {
      for (final n in [2, 3, 5, 7]) {
        await tester.pumpWidget(_app(_palco(_persone(n))));
        final centri = _centri(tester);
        final attesi = _attesi(n, _scatola, _telefono);
        for (var i = 0; i < n; i++) {
          expect(centri[i].dx, closeTo(attesi[i].dx, 1e-6), reason: 'n = $n, i = $i');
          expect(centri[i].dy, closeTo(attesi[i].dy, 1e-6), reason: 'n = $n, i = $i');
        }
      }
    });

    testWidgets('cambio del numero di persone: disposizione nuova al primo fotogramma, senza animazioni',
        (tester) async {
      await tester.pumpWidget(_app(_palco(_persone(2))));
      await tester.pumpWidget(_app(_palco(_persone(5))));
      expect(_presenze(), findsNWidgets(5));
      final centri = _centri(tester);
      final attesi = _attesi(5, _scatola, _telefono);
      for (var i = 0; i < 5; i++) {
        expect(centri[i].dx, closeTo(attesi[i].dx, 1e-6));
        expect(centri[i].dy, closeTo(attesi[i].dy, 1e-6));
      }
      expect(tester.hasRunningAnimations, isFalse);
      await tester.pumpWidget(_app(_palco(_persone(3))));
      expect(_presenze(), findsNWidgets(3));
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('8 persone: nessuna sparisce al restringersi della scatola', (tester) async {
      // L'avviso di sfora è atteso.
      await _cattura([], () async {
        var precedente = double.infinity;
        for (final lato in [320.0, 260.0, 200.0, 150.0, 120.0, 90.0]) {
          await tester.pumpWidget(_app(_palco(_persone(8), scatola: Size(lato, lato + 100))));
          expect(_presenze(), findsNWidgets(8), reason: 'scatola $lato');
          final d = _diametro(tester);
          expect(d, lessThanOrEqualTo(precedente), reason: 'non cresce mai');
          expect(d, greaterThanOrEqualTo(BaPresenzaTokens.minimo));
          precedente = d;
        }
      });
      expect(tester.takeException(), isNull);
    });
  });

  group('stato vuoto', () {
    testWidgets('0 persone: nessuna presenza e l\'invito', (tester) async {
      await tester.pumpWidget(_app(_palco(const [])));
      expect(_presenze(), findsNothing);
      expect(find.text('Il palco è libero.'), findsOneWidget);
      expect(find.text('Puoi salire quando vuoi.'), findsOneWidget);
    });

    testWidgets('l\'invito c\'è solo in vivo e con 0 persone', (tester) async {
      await tester.pumpWidget(_app(_palco(_persone(1))));
      expect(find.text('Il palco è libero.'), findsNothing);
      await tester.pumpWidget(_app(_palco(const [], stato: const BaStatoPalco.congelato())));
      expect(find.text('Il palco è libero.'), findsNothing);
      await tester.pumpWidget(_app(_palco(const [], stato: const BaStatoPalco.scheletro(0))));
      expect(find.text('Il palco è libero.'), findsNothing);
      await tester.pumpWidget(_app(_palco(const [], invito: false)));
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('l\'invito non mette pressione: nessun conteggio, nessuna azione', (tester) async {
      await tester.pumpWidget(_app(_palco(const [])));
      expect(find.byType(Text), findsNWidgets(2));
      expect(find.byType(GestureDetector), findsNothing);
    });
  });

  group('le voci insieme', () {
    double scalaAnello(WidgetTester tester, int i) => tester
        .widget<ScaleTransition>(find.descendant(
          of: _presenze().at(i),
          matching: find.byType(ScaleTransition),
        ))
        .scale
        .value;

    testWidgets('due che parlano: tutte e due ricevono voci 2, anello più piccolo', (tester) async {
      await tester.pumpWidget(_app(_palco(_persone(3, parlano: {0}))));
      final unaVoce = scalaAnello(tester, 0);
      expect(_anelli(tester).map((a) => a.voci), [1]);

      await tester.pumpWidget(_app(_palco(_persone(3, parlano: {0, 2}))));
      expect(_anelli(tester).map((a) => a.voci), [2, 2]);
      expect(scalaAnello(tester, 0), lessThan(unaVoce));
      expect(scalaAnello(tester, 2), lessThan(unaVoce));
      expect(scalaAnello(tester, 0), closeTo(scalaAnello(tester, 2), 1e-9));
    });

    testWidgets('tre voci: voci 3; chi ha perso la linea non conta', (tester) async {
      await tester.pumpWidget(_app(_palco(_persone(4, parlano: {0, 1, 2}))));
      expect(_anelli(tester).map((a) => a.voci), [3, 3, 3]);
      await tester.pumpWidget(_app(_palco(_persone(4, parlano: {0, 1, 2}, perse: {2}))));
      expect(_anelli(tester).map((a) => a.voci), [2, 2]);
    });
  });

  group('stati', () {
    testWidgets('congelato: tutte persa, stessa disposizione', (tester) async {
      await tester.pumpWidget(_app(_palco(_persone(5, parlano: {1}))));
      final prima = _centri(tester);
      final diametro = _diametro(tester);
      await tester.pumpWidget(_app(_palco(
        _persone(5, parlano: {1}),
        stato: const BaStatoPalco.congelato(),
      )));
      // L'anello di chi parlava esce in 140 ms (canale veloce).
      await tester.pump();
      await tester.pump(BaMovimentoTokens.voceScomparsa + const Duration(milliseconds: 1));
      expect(find.byType(ColorFiltered), findsNWidgets(5));
      expect(find.byType(ScaleTransition), findsNothing, reason: 'nessun anello disegnato');
      expect(_centri(tester), prima);
      expect(_diametro(tester), diametro);
      for (final p in tester.widgetList<BaPresenza>(_presenze())) {
        expect(p.persa, isTrue);
      }
    });

    testWidgets('scheletro: conteggio presenze senza iniziali, con la disposizione di conteggio',
        (tester) async {
      await tester.pumpWidget(_app(_palco(
        const [],
        stato: const BaStatoPalco.scheletro(4),
      )));
      expect(_presenze(), findsNWidgets(4));
      for (final p in tester.widgetList<BaPresenza>(_presenze())) {
        expect(p.scheletro, isTrue);
      }
      expect(find.byType(Text), findsNothing, reason: 'nessuna iniziale, nessun invito');
      final attesi = _attesi(4, _scatola, _telefono);
      final centri = _centri(tester);
      for (var i = 0; i < 4; i++) {
        expect(centri[i].dx, closeTo(attesi[i].dx, 1e-6));
        expect(centri[i].dy, closeTo(attesi[i].dy, 1e-6));
      }
      expect(_diametro(tester), BaPresenzaTokens.diametro(4, 360));
    });

    testWidgets('scheletro: le persone si ignorano', (tester) async {
      await tester.pumpWidget(_app(_palco(_persone(8), stato: const BaStatoPalco.scheletro(2))));
      expect(_presenze(), findsNWidgets(2));
    });
  });

  group('testo di sistema', () {
    /// Una stanza di prova: intestazione e riga sotto crescono col testo, il
    /// palco prende quello che avanza.
    Widget stanza(double testo) => _app(
          SizedBox(
            width: 320,
            height: 345,
            child: Column(
              children: [
                Text('Intestazione', style: BaTestoTokens.stanza),
                Expanded(
                  child: BaPalco(
                    persone: _persone(8),
                    larghezzaSchermo: 360,
                    semanticsLabel: 'Palco di prova',
                  ),
                ),
                Text('Riga di stato', style: BaTestoTokens.minore),
              ],
            ),
          ),
          testo: testo,
        );

    testWidgets('a 2,0 il diametro scende, nessuna presenza sparisce, le iniziali non crescono',
        (tester) async {
      await tester.pumpWidget(stanza(1));
      final d1 = _diametro(tester);
      final iniziali1 = tester.widget<Text>(find.text('P0')).style!.fontSize!;
      expect(_presenze(), findsNWidgets(8));

      await _cattura([], () async {
        await tester.pumpWidget(stanza(2));
        final d2 = _diametro(tester);
        final testo2 = tester.widget<Text>(find.text('P0'));
        expect(_presenze(), findsNWidgets(8));
        expect(d2, lessThan(d1));
        expect(testo2.style!.fontSize, BaPresenzaTokens.iniziali(d2));
        expect(testo2.style!.fontSize!, lessThanOrEqualTo(iniziali1));
        expect(testo2.textScaler, TextScaler.noScaling);
      });
    });
  });

  group('accessibilità', () {
    /// Le etichette «Persona n» nell'ordine di traversal dello screen reader.
    List<String> lettura(WidgetTester tester) {
      final fuori = <String>[];
      void visita(SemanticsNode nodo) {
        if (nodo.label.startsWith('Persona')) fuori.add(nodo.label);
        for (final f in nodo.debugListChildrenInOrder(DebugSemanticsDumpOrder.traversalOrder)) {
          visita(f);
        }
      }

      visita(tester.getSemantics(find.byType(BaPalco)));
      return fuori;
    }

    testWidgets('ordine di lettura uguale all\'ordine dei centri', (tester) async {
      final semantica = tester.ensureSemantics();
      for (final n in [2, 3, 5, 7, 8]) {
        await tester.pumpWidget(_app(_palco(_persone(n))));
        final centri = _centri(tester);
        // L'ordine della lista è anche l'ordine dei centri (dall'alto in
        // basso, da sinistra a destra)...
        final ordinati = [...centri]..sort((a, b) {
            final y = a.dy.compareTo(b.dy);
            return y != 0 ? y : a.dx.compareTo(b.dx);
          });
        for (var i = 0; i < n; i++) {
          expect(centri[i].dx, closeTo(ordinati[i].dx, 1e-6), reason: 'n = $n');
          expect(centri[i].dy, closeTo(ordinati[i].dy, 1e-6), reason: 'n = $n');
        }
        // ...e lo screen reader legge le persone in quell'ordine.
        expect(lettura(tester), [for (var i = 0; i < n; i++) 'Persona $i'], reason: 'n = $n');
      }
      semantica.dispose();
    });

    testWidgets('il palco ha la sua etichetta; chi parla porta «sta parlando»', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_palco(_persone(3, parlano: {1}))));
      expect(find.bySemanticsLabel('Palco di prova'), findsOneWidget);
      expect(find.bySemanticsLabel('Persona 1, sta parlando'), findsOneWidget);
      expect(find.bySemanticsLabel('Persona 0'), findsOneWidget);
      semantica.dispose();
    });

    testWidgets('lo scheletro è fuori dalla semantica', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(_palco(const [], stato: const BaStatoPalco.scheletro(3))));
      expect(lettura(tester), isEmpty);
      for (final p in tester.widgetList<BaPresenza>(_presenze())) {
        expect(p.onTap, isNull);
      }
      semantica.dispose();
    });

    testWidgets('nessun annuncio all\'ingresso o all\'uscita di una persona', (tester) async {
      final semantica = tester.ensureSemantics();
      final annunci = <Object?>[];
      tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<dynamic>(
        SystemChannels.accessibility,
        (messaggio) async {
          annunci.add(messaggio);
        },
      );
      addTearDown(() => tester.binding.defaultBinaryMessenger
          .setMockDecodedMessageHandler<dynamic>(SystemChannels.accessibility, null));

      await tester.pumpWidget(_app(_palco(_persone(2))));
      await tester.pumpWidget(_app(_palco(_persone(3))));
      await tester.pumpWidget(_app(_palco(_persone(2))));
      await tester.pump(const Duration(seconds: 1));
      expect(annunci, isEmpty);

      // E nessun nodo è una regione «live», che annuncerebbe i cambiamenti.
      var live = 0;
      void visita(SemanticsNode nodo) {
        if (nodo.getSemanticsData().flagsCollection.isLiveRegion) live++;
        nodo.visitChildren((f) {
          visita(f);
          return true;
        });
      }

      visita(tester.getSemantics(find.byType(BaPalco)));
      expect(live, 0);
      semantica.dispose();
    });
  });

  group('errori e avvisi', () {
    testWidgets('oltre 8 persone è un errore', (tester) async {
      await tester.pumpWidget(_app(_palco(_persone(9))));
      expect(tester.takeException(), isArgumentError);
    });

    testWidgets('lo stesso id su due persone è un errore in debug', (tester) async {
      final doppie = [..._persone(2), _persone(2).first];
      await tester.pumpWidget(_app(_palco(doppie)));
      final errore = tester.takeException();
      expect(errore, isA<FlutterError>());
      expect(errore.toString(), contains('p0'));
    });

    testWidgets('sfora: avviso in debug una volta sola, nessuna presenza tolta', (tester) async {
      final messaggi = <String?>[];
      await _cattura(messaggi, () async {
        const piccola = Size(60, 60);
        await tester.pumpWidget(_app(_palco(_persone(8), scatola: piccola)));
        expect(_presenze(), findsNWidgets(8));
        expect(messaggi.where((m) => m!.contains('BaPalco')), hasLength(1));
        await tester.pumpWidget(_app(_palco(_persone(8), scatola: piccola)));
        expect(messaggi.where((m) => m!.contains('BaPalco')), hasLength(1), reason: 'non si ripete');

        messaggi.clear();
        await tester.pumpWidget(_app(_palco(_persone(8))));
        expect(messaggi, isEmpty);
      });
    });

    testWidgets('una scatola senza altezza limitata è un errore in debug', (tester) async {
      await tester.pumpWidget(_app(SingleChildScrollView(
        child: BaPalco(
          persone: _persone(1),
          larghezzaSchermo: 360,
          semanticsLabel: 'Palco',
        ),
      )));
      expect(tester.takeException(), isAssertionError);
    });
  });
}
