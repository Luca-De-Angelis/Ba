import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/interruttore_riga.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/riga_impostazione.dart';
import 'package:ba/design_system/riga_valore.dart';
import 'package:ba/design_system/scheda_persona.dart';
import 'package:ba/design_system/tokens.dart';

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

const _conseguenza = 'Non potrai più parlare. Se stai parlando, esci dalla stanza.';
const _negata = 'Negate — senza queste non posso avvisarti';

BaRigaImpostazione _neg({VoidCallback? onApri}) =>
    BaRigaImpostazione.negata(titolo: 'Notifiche', frase: _negata, apri: 'Apri', onApri: onApri);

void main() {
  group('valore', () {
    testWidgets('titolo e valore: è una BaRigaValore', (tester) async {
      await tester.pumpWidget(_app(BaRigaImpostazione.valore(titolo: 'Lingua', valore: 'Italiano')));
      expect(find.byType(BaRigaValore), findsOneWidget);
      expect(find.text('Lingua'), findsOneWidget);
      expect(find.text('Italiano'), findsOneWidget);
    });

    testWidgets('con onTap e senza valore ha la freccia e chiama onTap', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(BaRigaImpostazione.valore(titolo: 'Persone bloccate', onTap: () => tocchi++)));
      await tester.tap(find.byType(BaRigaValore));
      expect(tocchi, 1);
      expect(find.descendant(of: find.byType(BaRigaValore), matching: find.byType(CustomPaint)), findsWidgets);
    });
  });

  group('interruttore', () {
    testWidgets('mostra la parola, non solo il colore, e cambia', (tester) async {
      var acceso = false;
      await tester.pumpWidget(_app(StatefulBuilder(
        builder: (context, setState) => BaRigaImpostazione.interruttore(
          titolo: 'Avvisami',
          descrizione: 'Quando si libera un posto.',
          acceso: acceso,
          parolaAcceso: 'Acceso',
          parolaSpento: 'Spento',
          onCambia: (v) => setState(() => acceso = v),
        ),
      )));
      expect(find.byType(BaInterruttoreRiga), findsOneWidget);
      expect(find.text('SPENTO'), findsOneWidget);
      await tester.tap(find.byType(BaInterruttoreRiga));
      await tester.pump();
      expect(acceso, isTrue);
      expect(find.text('ACCESO'), findsOneWidget);
    });
  });

  group('azione con la conseguenza scritta', () {
    testWidgets('«Torna all\'ascolto» mostra la frase di conseguenza e chiama onTap', (tester) async {
      var tocchi = 0;
      await tester.pumpWidget(_app(BaRigaImpostazione.azione(titolo: "Torna all'ascolto", conseguenza: _conseguenza, onTap: () => tocchi++)));
      expect(find.byType(BaRigaAzione), findsOneWidget);
      expect(find.text("Torna all'ascolto"), findsOneWidget);
      expect(find.text(_conseguenza), findsOneWidget);
      await tester.tap(find.byType(BaRigaAzione));
      expect(tocchi, 1);
    });

    testWidgets('la conseguenza è nella semantica, prima del tocco', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(BaRigaImpostazione.azione(titolo: "Torna all'ascolto", conseguenza: _conseguenza, onTap: () {})));
      expect(find.bySemanticsLabel("Torna all'ascolto. $_conseguenza"), findsOneWidget);
      semantica.dispose();
    });
  });

  group('negata dal sistema', () {
    testWidgets('titolo, frase di stato e via d\'uscita: lo stato è nelle parole', (tester) async {
      var apri = 0;
      await tester.pumpWidget(_app(_neg(onApri: () => apri++)));
      expect(find.text('Notifiche'), findsOneWidget);
      expect(find.text(_negata), findsOneWidget, reason: 'lo stato non è il solo colore');
      final pillola = tester.widget<BaPillola>(find.byType(BaPillola));
      expect(pillola.variante, BaVariantePillola.spenta);
      expect(pillola.altezzaMinima, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
      await tester.tap(find.text('Apri'));
      expect(apri, 1);
    });

    testWidgets('nessun colore d\'errore: la riga non si riempie e non si tinge', (tester) async {
      await tester.pumpWidget(_app(_neg()));
      for (final t in tester.widgetList<Text>(find.byType(Text))) {
        expect(t.style?.color, isNot(BaColorTokens.erroreTesto), reason: t.data);
      }
    });

    testWidgets('senza onApri la via d\'uscita è inattiva', (tester) async {
      await tester.pumpWidget(_app(_neg()));
      expect(tester.widget<BaPillola>(find.byType(BaPillola)).onTap, isNull);
    });

    testWidgets('per lo screen reader: il testo e, a parte, il bottone con la sua etichetta', (tester) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(_app(BaRigaImpostazione.negata(
        titolo: 'Microfono',
        frase: 'Negato — senza il microfono non puoi parlare',
        apri: 'Apri',
        apriSemanticsLabel: 'Apri le impostazioni del telefono',
        onApri: () {},
      )));
      expect(find.bySemanticsLabel('Microfono. Negato — senza il microfono non puoi parlare'), findsOneWidget);
      expect(tester.getSemantics(find.bySemanticsLabel('Apri le impostazioni del telefono')).flagsCollection.isButton, isTrue);
      semantica.dispose();
    });
  });

  group('testo grande e larghezze', () {
    for (final larghezza in [360.0, 744.0]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp nulla si taglia né sborda, in ogni forma', (tester) async {
        for (final riga in <Widget>[
          BaRigaImpostazione.valore(titolo: 'Persone bloccate', valore: '3 persone', sottotitolo: 'Restano finché non le sblocchi.'),
          BaRigaImpostazione.interruttore(titolo: 'Avvisami', descrizione: 'Quando si libera un posto.', acceso: true, parolaAcceso: 'Acceso', parolaSpento: 'Spento', onCambia: (_) {}),
          BaRigaImpostazione.azione(titolo: "Torna all'ascolto", conseguenza: _conseguenza, onTap: () {}),
          _neg(onApri: () {}),
        ]) {
          await tester.pumpWidget(_app(riga, testo: BaScalaTokens.maxTesto, larghezza: larghezza));
          expect(tester.takeException(), isNull);
          final r = tester.getRect(find.byType(BaRigaImpostazione));
          for (final t in tester.widgetList<Text>(find.descendant(of: find.byType(BaRigaImpostazione), matching: find.byType(Text)))) {
            expect(tester.getRect(find.byWidget(t)).right, lessThanOrEqualTo(r.right), reason: t.data);
          }
        }
      });
    }
  });
}
