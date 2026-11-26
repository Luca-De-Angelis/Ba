import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/riga_persona.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

// L'estensione di BaRigaPersona del task 033 (prototipo 030): alias, voci e
// interruttore. I test del task 023b (`riga_persona_test.dart`) e quelli di
// «Gestisci» non si toccano: sono la rete di sicurezza.

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(alignment: Alignment.topLeft, child: SizedBox(width: larghezza, child: SingleChildScrollView(child: child))),
        ),
      ),
    );

BaRigaPersona _voce(BaVoceRigaPersona voce, String parola, {VoidCallback? onAzione, String? alias = '@marta.v'}) =>
    BaRigaPersona(nome: 'Marta', alias: alias, voce: voce, azione: parola, onAzione: onAzione);

List<String?> _testi(WidgetTester tester) =>
    tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(Text))).map((t) => t.data).toList();

/// Ha il contorno dell'azione (un Container con il bordo di `azioneBordo`).
bool _conContorno(WidgetTester tester) => tester
    .widgetList<Container>(find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(Container)))
    .any((c) => c.decoration is BoxDecoration && (c.decoration! as BoxDecoration).border is Border && (c.decoration! as BoxDecoration).borderRadius != null);

bool _conSpunta(WidgetTester tester) =>
    find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(CustomPaint)).evaluate().isNotEmpty;

void main() {
  group('l\'alias e lo stato facoltativo', () {
    testWidgets('l\'alias sta sotto il nome, in secondo piano', (tester) async {
      await tester.pumpWidget(_app(const BaRigaPersona(nome: 'Sara', alias: '@sara.rossi')));
      expect(_testi(tester), ['Sara', '@sara.rossi']);
      expect(tester.widget<Text>(find.text('@sara.rossi')).style?.color, BaColorTokens.testoSecondo);
      expect(tester.getTopLeft(find.text('Sara')).dy, lessThan(tester.getTopLeft(find.text('@sara.rossi')).dy));
    });

    testWidgets('due persone con lo stesso nickname si distinguono con l\'alias', (tester) async {
      await tester.pumpWidget(_app(const Column(children: [
        BaRigaPersona(nome: 'Sara', alias: '@sara.m'),
        BaRigaPersona(nome: 'Sara', alias: '@sara.rossi'),
      ])));
      expect(find.text('Sara'), findsNWidgets(2));
      expect(find.text('@sara.m'), findsOneWidget);
      expect(find.text('@sara.rossi'), findsOneWidget);
    });

    testWidgets('con l\'alias e lo stato (la riga di «Gestisci») si leggono in ordine: nome, alias, stato', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(const BaRigaPersona(nome: 'Marta', alias: '@marta.v', stato: 'sul palco')));
      expect(find.bySemanticsLabel('Marta. @marta.v. sul palco'), findsOneWidget);
      semantica.dispose();
    });

    testWidgets('senza stato né alias il nome sta da solo', (tester) async {
      await tester.pumpWidget(_app(const BaRigaPersona(nome: 'Marta')));
      expect(_testi(tester), ['Marta']);
    });
  });

  group('le quattro voci: sempre una parola e un segno, mai il solo colore', () {
    testWidgets('da aggiungere: la parola in un\'azione con il contorno', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(_voce(BaVoceRigaPersona.daAggiungere, 'Aggiungi', onAzione: () => tocchi++)));
      expect(find.text('Aggiungi'), findsOneWidget);
      expect(_conContorno(tester), isTrue);
      expect(_conSpunta(tester), isFalse);
      await tester.tap(find.text('Aggiungi'));
      expect(tocchi, 1);
    });

    testWidgets('scegli: la parola in un\'azione con il contorno', (tester) async {
      await tester.pumpWidget(_app(_voce(BaVoceRigaPersona.scegli, 'Scegli', onAzione: () {})));
      expect(find.text('Scegli'), findsOneWidget);
      expect(_conContorno(tester), isTrue);
    });

    testWidgets('aggiunta: la spunta disegnata e la parola, senza contorno e senza tocco', (tester) async {
      await tester.pumpWidget(_app(_voce(BaVoceRigaPersona.aggiunta, 'Aggiunta')));
      expect(find.text('Aggiunta'), findsOneWidget);
      expect(_conSpunta(tester), isTrue, reason: 'il segno');
      expect(_conContorno(tester), isFalse);
      expect(find.byType(BaTouchable), findsNothing, reason: 'una persona aggiunta non si tocca');
      expect(_testi(tester).join(), isNot(contains('✓')), reason: 'la spunta è un disegno, non un carattere');
    });

    testWidgets('nell\'invito: la spunta e la parola, e si può toccare per toglierla', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(_voce(BaVoceRigaPersona.nellInvito, 'Nell\'invito', onAzione: () => tocchi++)));
      expect(_conSpunta(tester), isTrue);
      expect(_conContorno(tester), isFalse);
      await tester.tap(find.text('Nell\'invito'));
      expect(tocchi, 1);
      expect(tester.getSize(find.byType(BaTouchable)).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
    });

    testWidgets('l\'azione ha almeno areaMinima e il raggio azioneRaggio, non una pillola', (tester) async {
      await tester.pumpWidget(_app(_voce(BaVoceRigaPersona.daAggiungere, 'Aggiungi', onAzione: () {})));
      expect(tester.getSize(find.byType(BaTouchable)).height, greaterThanOrEqualTo(BaPersoneTokens.azioneAltezza));
      final contorno = tester
          .widgetList<Container>(find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(Container)))
          .map((c) => c.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((d) => d.border is Border && d.borderRadius != null);
      expect(contorno.borderRadius, BorderRadius.circular(BaPersoneTokens.azioneRaggio));
      expect(BaPersoneTokens.azioneRaggio, isNot(BaRaggioTokens.pillola));
    });

    testWidgets('per lo screen reader: il nome con l\'alias e, a parte, la parola', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(BaRigaPersona(
        nome: 'Marta',
        alias: '@marta.v',
        voce: BaVoceRigaPersona.daAggiungere,
        azione: 'Aggiungi',
        azioneSemanticsLabel: 'Aggiungi Marta',
        onAzione: () {},
      )));
      expect(find.bySemanticsLabel('Marta. @marta.v'), findsOneWidget);
      expect(tester.getSemantics(find.bySemanticsLabel('Aggiungi Marta')).flagsCollection.isButton, isTrue);
      semantica.dispose();
    });
  });

  group('a testo grande l\'azione va a capo', () {
    testWidgets('a 1,0 sta accanto al nome, a 2,0 sotto', (tester) async {
      await tester.pumpWidget(_app(_voce(BaVoceRigaPersona.daAggiungere, 'Aggiungi', onAzione: () {})));
      final nome = tester.getRect(find.text('Marta'));
      final azione = tester.getRect(find.byType(BaTouchable));
      expect(azione.left, greaterThan(nome.right), reason: 'a testo normale sta a destra');

      await tester.pumpWidget(_app(
        _voce(BaVoceRigaPersona.daAggiungere, 'Aggiungi', onAzione: () {}, alias: '@marta.verdi.milano'),
        testo: BaScalaTokens.maxTesto,
      ));
      expect(tester.takeException(), isNull);
      final testi = tester.getRect(find.text('@marta.verdi.milano'));
      final sotto = tester.getRect(find.byType(BaTouchable));
      expect(sotto.top, greaterThanOrEqualTo(testi.bottom), reason: 'a testo grande va a capo');
    });

    testWidgets('con il raggio 24 l\x27azione a capo su due righe non taglia il testo: gli angoli del testo stanno dentro l\x27arco', (tester) async {
      await tester.pumpWidget(_app(
        _voce(BaVoceRigaPersona.daAggiungere, 'Aggiungi alla lista', onAzione: () {}),
        testo: BaScalaTokens.maxTesto,
      ));
      expect(tester.takeException(), isNull);
      final contorno = find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(Container)).evaluate().map((e) => e.widget as Container).firstWhere(
            (c) => c.decoration is BoxDecoration && (c.decoration! as BoxDecoration).border is Border,
          );
      final pillola = tester.getRect(find.byWidget(contorno));
      final testo = tester.getRect(find.text('Aggiungi alla lista'));
      expect(BaPersoneTokens.azioneRaggio, 24);
      expect(testo.height, greaterThan(2 * 14 * BaScalaTokens.maxTesto * 1.0), reason: 'su due righe almeno');
      final arco = RRect.fromRectAndRadius(pillola, const Radius.circular(BaPersoneTokens.azioneRaggio));
      for (final angolo in [testo.topLeft, testo.topRight, testo.bottomLeft, testo.bottomRight]) {
        expect(arco.contains(angolo), isTrue, reason: 'l\x27angolo $angolo del testo esce dal contorno $pillola');
      }
    });

    for (final larghezza in [360.0, 744.0]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp nessuna voce si taglia né sborda', (tester) async {
        for (final riga in <Widget>[
          _voce(BaVoceRigaPersona.daAggiungere, 'Aggiungi', onAzione: () {}),
          _voce(BaVoceRigaPersona.scegli, 'Scegli', onAzione: () {}),
          _voce(BaVoceRigaPersona.aggiunta, 'Aggiunta'),
          _voce(BaVoceRigaPersona.nellInvito, 'Nell\'invito', onAzione: () {}),
          BaRigaPersona(nome: 'Maria Antonietta Bianchi-Rossi', alias: '@maria.antonietta.bianchi', acceso: false, parolaAcceso: 'Acceso', parolaSpento: 'Spento', onCambia: (_) {}),
        ]) {
          await tester.pumpWidget(_app(riga, testo: BaScalaTokens.maxTesto, larghezza: larghezza));
          expect(tester.takeException(), isNull);
          final r = tester.getRect(find.byType(BaRigaPersona));
          for (final t in tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(Text)))) {
            expect(tester.getRect(find.byWidget(t)).right, lessThanOrEqualTo(r.right), reason: t.data);
          }
        }
      });
    }
  });

  group('l\'interruttore, al posto dell\'azione', () {
    BaRigaPersona riga({required bool acceso, ValueChanged<bool>? onCambia}) => BaRigaPersona(
          nome: 'Marta',
          alias: '@marta.v',
          acceso: acceso,
          parolaAcceso: 'Acceso',
          parolaSpento: 'Spento',
          onCambia: onCambia,
        );

    testWidgets('lo stato è la parola, non solo la posizione', (tester) async {
      await tester.pumpWidget(_app(riga(acceso: false)));
      expect(find.text('SPENTO'), findsOneWidget);
      await tester.pumpWidget(_app(riga(acceso: true)));
      expect(find.text('ACCESO'), findsOneWidget);
      expect(find.text('SPENTO'), findsNothing);
    });

    testWidgets('tutta la riga è toccabile e chiama onCambia con il valore nuovo', (tester) async {
      bool? ultimo;
      await tester.pumpWidget(_app(riga(acceso: false, onCambia: (v) => ultimo = v)));
      await tester.tap(find.text('Marta'));
      expect(ultimo, isTrue);
      await tester.pumpWidget(_app(riga(acceso: true, onCambia: (v) => ultimo = v)));
      await tester.tap(find.text('Marta'));
      expect(ultimo, isFalse);
      expect(tester.getSize(find.byType(BaTouchable)).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
    });

    testWidgets('senza onCambia è inattivo', (tester) async {
      await tester.pumpWidget(_app(riga(acceso: false)));
      expect(tester.widget<BaTouchable>(find.byType(BaTouchable)).onTap, isNull);
    });

    testWidgets('per lo screen reader è un interruttore', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(riga(acceso: true, onCambia: (_) {})));
      final nodo = tester.getSemantics(find.bySemanticsLabel('Marta. @marta.v'));
      expect(nodo.flagsCollection.isToggled, isNotNull);
      semantica.dispose();
    });

    testWidgets('non ha l\'azione: l\'interruttore sta al suo posto', (tester) async {
      expect(
        () => BaRigaPersona(nome: 'Marta', azione: 'Rimuovi', acceso: true, parolaAcceso: 'Acceso', parolaSpento: 'Spento'),
        throwsAssertionError,
      );
    });

    testWidgets('senza le sue due parole non si costruisce', (tester) async {
      expect(() => BaRigaPersona(nome: 'Marta', acceso: true), throwsAssertionError);
    });
  });

  group('mai lo stato di presenza né il luogo', () {
    test('il sorgente non ha nessuna parola per mostrarli', () {
      final sorgente = File('lib/design_system/riga_persona.dart').readAsStringSync().toLowerCase();
      expect(sorgente, isNot(contains('online')));
      expect(sorgente, isNot(contains('in un den')));
    });

    test('nessun parametro di BaRigaPersona li ammette', () {
      // I soli parametri sono nome, stato (testo libero del chiamante), alias, indici,
      // azione, voce e interruttore: se qualcuno ne aggiunge uno che dice dove si trova
      // la persona, questo test va riletto con il principio del 030.
      const riga = BaRigaPersona(nome: 'a');
      expect(riga.voce, isNull);
      expect(riga.acceso, isNull);
      expect(riga.alias, isNull);
    });
  });
}
