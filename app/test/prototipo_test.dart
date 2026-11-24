import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/barra_azioni.dart';
import 'package:ba/design_system/campo_codice.dart';
import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/presenza.dart';
import 'package:ba/design_system/riga_den.dart';
import 'package:ba/prototipo/cornice.dart';

// Il prototipo navigabile (task 024a): dal login alla stanza, «diventa partecipante»,
// le impostazioni con le due conferme. Si prova con i widget, non con un browser.

void _vista(WidgetTester tester, {double larghezza = 1500, double altezza = 1000}) {
  tester.view.physicalSize = Size(larghezza, altezza);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _avvia(WidgetTester tester, {double larghezza = 1500, double altezza = 1000}) async {
  _vista(tester, larghezza: larghezza, altezza: altezza);
  await tester.pumpWidget(const PrototipoApp());
  await tester.pump();
}

/// Un tocco, con un fotogramma dopo.
Future<void> _tocca(WidgetTester tester, String testo) async {
  final f = find.text(testo).first;
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pump();
}

/// Un tocco su un testo dentro il foglio aperto (quello della pagina sotto ha lo stesso testo).
Future<void> _toccaNelFoglio(WidgetTester tester, String testo) async {
  final f = find.descendant(of: find.byType(BaFoglio), matching: find.text(testo)).first;
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pump();
}

/// Un foglio sale in 240 ms.
Future<void> _sale(WidgetTester tester) => tester.pump(const Duration(milliseconds: 300));

Finder _campoCodice() => find.descendant(of: find.byType(BaCampoCodice), matching: find.byType(EditableText));

/// L'accesso intero: email, codice, «Ho capito», «Accetto», nickname, «Continua».
Future<void> _accedi(WidgetTester tester, {String nickname = 'Sara'}) async {
  await tester.enterText(find.byType(EditableText).first, 'sara.m@example.it');
  await tester.pump();
  await _tocca(tester, 'Ricevi il codice');
  await tester.enterText(_campoCodice(), '123456');
  await tester.pump();
  await _tocca(tester, 'Conferma');
  await _tocca(tester, 'Ho capito');
  await _tocca(tester, 'Accetto');
  await tester.enterText(find.byType(EditableText).first, nickname);
  await tester.pump();
  await _tocca(tester, 'Continua');
}

/// «Diventa partecipante»: avviso, numero, codice, consenso. [azione] è l'ultima.
Future<void> _diventaPartecipante(WidgetTester tester, String azione) async {
  await _sale(tester);
  await _tocca(tester, 'Continua');
  await tester.enterText(find.descendant(of: find.byType(BaFoglio), matching: find.byType(EditableText)).first, '320 000 0000');
  await tester.pump();
  await _tocca(tester, 'Ricevi il codice');
  await tester.enterText(_campoCodice(), '123456');
  await tester.pump();
  await _tocca(tester, 'Conferma');
  await _tocca(tester, azione);
  await _sale(tester);
}

BaPillola _pillola(WidgetTester tester, String testo) => tester.widget<BaPillola>(find.widgetWithText(BaPillola, testo));

void main() {
  group('l\'accesso', () {
    testWidgets('parte dal login: la cornice col prodotto, il pannello fuori, i codici di prova', (tester) async {
      await _avvia(tester);
      expect(find.text('La tua email'), findsOneWidget);
      expect(find.text('Strumento'), findsOneWidget);
      expect(find.text('codice giusto: 123456 · scaduto: 000000 · altri: sbagliato'), findsOneWidget);
      // Il pannello sta fuori dalla cornice.
      final cornice = tester.getRect(find.text('La tua email'));
      final pannello = tester.getRect(find.text('Strumento'));
      expect(pannello.left, greaterThan(cornice.right));
    });

    testWidgets('dal login all\'elenco, da ascoltatore, con tocchi e testo', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      expect(find.text('Cucina di notte'), findsOneWidget);
      expect(find.text('SEI ASCOLTATORE'), findsOneWidget);
      expect(find.text('Corridoio lungo'), findsNothing, reason: 'un privato su invito non si vede da ascoltatore (D-041)');
    });

    testWidgets('l\'email che non sembra giusta dà un errore e non va avanti', (tester) async {
      await _avvia(tester);
      await tester.enterText(find.byType(EditableText).first, 'sara');
      await tester.pump();
      await _tocca(tester, 'Ricevi il codice');
      expect(find.text('Questa email non sembra giusta. Controllala e riprova.'), findsOneWidget);
      expect(find.text('La tua email'), findsOneWidget);
    });

    testWidgets('il codice: sbagliato, scaduto, nuovo invio con attesa', (tester) async {
      await _avvia(tester);
      await tester.enterText(find.byType(EditableText).first, 'sara.m@example.it');
      await tester.pump();
      await _tocca(tester, 'Ricevi il codice');
      expect(find.text('Mandato a sara.m@example.it.'), findsOneWidget);

      await tester.enterText(_campoCodice(), '481902');
      await tester.pump();
      await _tocca(tester, 'Conferma');
      expect(find.text('Il codice non è giusto. Controlla l\'email e riprova.'), findsOneWidget);

      await tester.enterText(_campoCodice(), '000000');
      await tester.pump();
      await _tocca(tester, 'Conferma');
      expect(find.text('Il codice è scaduto. Te ne mandiamo uno nuovo.'), findsOneWidget);
      expect(find.text('Mandalo di nuovo'), findsNothing, reason: 'scaduto: l\'azione che serve è la primaria');

      await _tocca(tester, 'Manda un nuovo codice');
      expect(find.text('Ne puoi chiedere un altro fra poco.'), findsOneWidget);
      expect(_pillola(tester, 'Mandalo di nuovo').onTap, isNull, reason: 'in attesa: inattivo, nessun conto alla rovescia');
      expect(_pillola(tester, 'Conferma').onTap, isNull);

      // Scrivere di nuovo finisce l'attesa.
      await tester.enterText(_campoCodice(), '1');
      await tester.pump();
      expect(find.text('Ne puoi chiedere un altro fra poco.'), findsNothing);
    });

    testWidgets('il nickname vuoto dà la frase e l\'azione è inattiva; «Indietro» c\'è in ogni pagina dopo la prima', (tester) async {
      await _avvia(tester);
      await tester.enterText(find.byType(EditableText).first, 'sara.m@example.it');
      await tester.pump();
      await _tocca(tester, 'Ricevi il codice');
      expect(find.text('Indietro'), findsOneWidget);
      await tester.enterText(_campoCodice(), '123456');
      await tester.pump();
      await _tocca(tester, 'Conferma');
      expect(find.text('Indietro'), findsOneWidget);
      await _tocca(tester, 'Ho capito');
      expect(find.text('Indietro'), findsOneWidget);
      await _tocca(tester, 'Accetto');
      expect(find.text('Scegli un nickname'), findsOneWidget);
      await tester.enterText(find.byType(EditableText).first, 'S');
      await tester.pump();
      await tester.enterText(find.byType(EditableText).first, '');
      await tester.pump();
      expect(find.text('Scegli un nickname per continuare.'), findsOneWidget);
      expect(_pillola(tester, 'Continua').onTap, isNull);
      await _tocca(tester, 'Indietro');
      expect(find.text('Termini e privacy'), findsOneWidget);
    });
  });

  group('l\'elenco e la stanza', () {
    testWidgets('le righe nei loro stati; il tocco porta nella stanza come pubblico', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      final righe = tester.widgetList<BaRigaDen>(find.byType(BaRigaDen)).toList();
      expect(righe.map((r) => r.nome), ['Cucina di notte', 'Fra due turni', 'Radio insonni']);
      expect(righe.map((r) => r.stato), [BaStatoRigaDen.viva, BaStatoRigaDen.viva, BaStatoRigaDen.spenta]);
      await _tocca(tester, 'Cucina di notte');
      expect(find.text('Sali sul palco'), findsOneWidget);
      expect(find.text('5 SUL PALCO'), findsOneWidget);
      expect(find.text('SEI IN ASCOLTO'), findsOneWidget);
      expect(find.text('Salirai a microfono spento.'), findsOneWidget);
      expect(find.text('Esci'), findsOneWidget);
    });

    testWidgets('«Esci» torna all\'elenco; il palco vuoto invita', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Radio insonni');
      expect(find.text('Il palco è libero.'), findsOneWidget);
      await _tocca(tester, 'Esci');
      expect(find.text('Cucina di notte'), findsOneWidget);
      expect(find.text('Sali sul palco'), findsNothing);
    });

    testWidgets('da ascoltatore «Sali sul palco» apre i quattro passi e si sale a microfono spento', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Cucina di notte');
      await _tocca(tester, 'Sali sul palco');
      expect(find.text('Vuoi salire sul palco?'), findsOneWidget);
      await _diventaPartecipante(tester, 'Acconsento e salgo');
      expect(find.byType(BaFoglio), findsNothing);
      expect(find.text('Accendi il microfono'), findsOneWidget, reason: 'si sale a microfono spento (D-007)');
      expect(find.text('6 SUL PALCO'), findsOneWidget);
      expect(find.text('TU · MICROFONO SPENTO'), findsOneWidget);
    });

    testWidgets('il microfono si accende e si spegne; si scende dal palco', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Cucina di notte');
      await _tocca(tester, 'Sali sul palco');
      await _diventaPartecipante(tester, 'Acconsento e salgo');
      await _tocca(tester, 'Accendi il microfono');
      expect(find.text('Spegni il microfono'), findsOneWidget);
      expect(find.text('TU · MICROFONO ACCESO'), findsOneWidget);
      await _tocca(tester, 'Spegni il microfono');
      expect(find.text('Accendi il microfono'), findsOneWidget);
      await _tocca(tester, 'Scendi dal palco');
      expect(find.text('Sali sul palco'), findsOneWidget);
      expect(find.text('5 SUL PALCO'), findsOneWidget);
    });

    testWidgets('da partecipante si sale subito, sempre a microfono spento', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Cucina di notte');
      await _tocca(tester, 'Sali sul palco');
      await _diventaPartecipante(tester, 'Acconsento e salgo');
      await _tocca(tester, 'Esci');
      expect(find.text('SEI PARTECIPANTE'), findsOneWidget);
      expect(find.text('Corridoio lungo'), findsOneWidget, reason: 'un partecipante vede il privato su invito');
      await _tocca(tester, 'Fra due turni');
      await _tocca(tester, 'Sali sul palco');
      expect(find.byType(BaFoglio), findsNothing, reason: 'il consenso è già dato');
      expect(find.text('Accendi il microfono'), findsOneWidget);
    });

    testWidgets('«Altro» raccoglie le azioni oltre le tre e porta alle impostazioni', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Cucina di notte');
      await _tocca(tester, 'Sali sul palco');
      await _diventaPartecipante(tester, 'Acconsento e salgo');
      expect(find.byType(BaBarraAzioni), findsOneWidget);
      final semantica = tester.ensureSemantics();
      await tester.tap(find.bySemanticsLabel('Altro'));
      await tester.pump();
      await _sale(tester);
      expect(find.byType(BaFoglio), findsOneWidget);
      await _toccaNelFoglio(tester, 'Impostazioni');
      semantica.dispose();
      expect(find.text('Persone bloccate'), findsOneWidget);
      await _tocca(tester, 'Indietro');
      expect(find.text('Accendi il microfono'), findsOneWidget, reason: '«Indietro» riporta alla stanza');
    });

    Finder presenza(String iniziali) => find.byWidgetPredicate((w) => w is BaPresenza && w.iniziali == iniziali);

    testWidgets('«Blocca» dalla scheda: la scheda si chiude, la persona sul palco ha il glifo «bloccata» e sta fra le bloccate; «Sblocca» la ripristina', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Cucina di notte');
      expect(tester.widget<BaPresenza>(presenza('MB')).bloccata, isFalse);

      await tester.tap(presenza('MB'));
      await tester.pump();
      await _sale(tester);
      expect(find.byType(BaFoglio), findsOneWidget, reason: 'la scheda di Marta B.');
      await _toccaNelFoglio(tester, 'Blocca');
      await _sale(tester);
      expect(find.byType(BaFoglio), findsNothing, reason: 'la scheda si chiude');
      expect(tester.widget<BaPresenza>(presenza('MB')).bloccata, isTrue, reason: 'il glifo «bloccata» sul palco');
      expect(tester.widget<BaPresenza>(presenza('SL')).bloccata, isFalse, reason: 'solo lei');

      await _tocca(tester, 'Esci');
      await _tocca(tester, 'Impostazioni');
      expect(find.text('4 persone'), findsOneWidget);
      await _tocca(tester, 'Persone bloccate');
      expect(find.text('Marta B.'), findsOneWidget);

      await tester.tap(find.widgetWithText(BaPillola, 'Sblocca').last);
      await tester.pump();
      await _tocca(tester, 'Indietro');
      await _tocca(tester, 'Indietro');
      await _tocca(tester, 'Cucina di notte');
      expect(tester.widget<BaPresenza>(presenza('MB')).bloccata, isFalse, reason: '«Sblocca» la ripristina');
    });

    testWidgets('«Altro» c\'è sempre: per l\'ascoltatore e per il partecipante, in ascolto e sul palco', (tester) async {
      final semantica = tester.ensureSemantics();
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Cucina di notte');
      // Ascoltatore, in ascolto: la barra ha quattro azioni, «Altro» raccoglie la quarta.
      expect(find.bySemanticsLabel('Altro'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Altro'));
      await tester.pump();
      await _sale(tester);
      expect(find.byType(BaFoglio), findsOneWidget);
      await _toccaNelFoglio(tester, 'Persone bloccate');
      expect(find.text('Dario V.'), findsOneWidget);
      await _tocca(tester, 'Indietro');
      await _tocca(tester, 'Sali sul palco');
      await _diventaPartecipante(tester, 'Acconsento e salgo');

      // Partecipante, sul palco: «Altro» raccoglie «Impostazioni» e «Persone bloccate».
      expect(find.bySemanticsLabel('Altro'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Altro'));
      await tester.pump();
      await _sale(tester);
      expect(find.descendant(of: find.byType(BaFoglio), matching: find.text('Impostazioni')), findsOneWidget);
      expect(find.descendant(of: find.byType(BaFoglio), matching: find.text('Persone bloccate')), findsOneWidget);
      await _toccaNelFoglio(tester, 'Chiudi');
      await _sale(tester);

      // Partecipante, in ascolto in un'altra stanza: «Altro» c'è ancora.
      await _tocca(tester, 'Esci');
      await _tocca(tester, 'Fra due turni');
      expect(find.bySemanticsLabel('Altro'), findsOneWidget);
      semantica.dispose();
    });
  });

  group('le impostazioni', () {
    Future<void> alleImpostazioni(WidgetTester tester) async {
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Impostazioni');
    }

    testWidgets('da ascoltatore la riga è un fatto: «Sei ascoltatore»', (tester) async {
      await alleImpostazioni(tester);
      expect(find.text('Sei ascoltatore'), findsOneWidget);
      expect(find.text('Torna ascoltatore'), findsNothing);
      expect(find.text('3 persone'), findsOneWidget);
      expect(find.text('Italiano'), findsOneWidget);
      expect(find.text('Consentito'), findsOneWidget);
    });

    testWidgets('«Torna ascoltatore» chiede due conferme e poi la riga diventa un fatto', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Cucina di notte');
      await _tocca(tester, 'Sali sul palco');
      await _diventaPartecipante(tester, 'Acconsento e salgo');
      await _tocca(tester, 'Esci');
      await _tocca(tester, 'Impostazioni');
      expect(find.text('Torna ascoltatore'), findsOneWidget);

      await _tocca(tester, 'Torna ascoltatore');
      await _sale(tester);
      expect(find.text('Tornare ascoltatore?'), findsOneWidget);
      await _tocca(tester, 'Non ora');
      await _sale(tester);
      expect(find.text('Torna ascoltatore'), findsOneWidget, reason: '«Non ora» non cambia niente');

      await _tocca(tester, 'Torna ascoltatore');
      await _sale(tester);
      await _toccaNelFoglio(tester, 'Continua');
      expect(find.text('Ne sei sicuro?'), findsOneWidget, reason: 'la seconda conferma');
      expect(find.text('Sei ascoltatore'), findsNothing, reason: 'ancora partecipante');
      await _toccaNelFoglio(tester, 'Torna ascoltatore');
      await _sale(tester);
      expect(find.text('Sei ascoltatore'), findsOneWidget);
      expect(find.text('Per parlare di nuovo, sali sul palco di un DEN e dai il consenso.'), findsOneWidget);
    });

    testWidgets('«Persone bloccate»: «Sblocca» toglie la riga e il conto', (tester) async {
      await alleImpostazioni(tester);
      await _tocca(tester, 'Persone bloccate');
      expect(find.text('Dario V.'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Sblocca Dario V.'), warnIfMissed: false);
      await _tocca(tester, 'Sblocca');
      await tester.pump();
      await _tocca(tester, 'Indietro');
      expect(find.text('2 persone'), findsOneWidget);
    });

    testWidgets('«Esci da BA» riporta al login', (tester) async {
      await alleImpostazioni(tester);
      await _tocca(tester, 'Esci da BA');
      expect(find.text('La tua email'), findsOneWidget);
    });
  });

  group('«Crea un DEN»', () {
    testWidgets('da ascoltatore apre «Per creare un DEN bisogna diventare partecipante» e finisce partecipante', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Crea un DEN');
      expect(find.text('Per creare un DEN bisogna diventare partecipante'), findsOneWidget);
      await _diventaPartecipante(tester, 'Acconsento e continuo');
      expect(find.text('SEI PARTECIPANTE'), findsOneWidget);
      expect(find.byType(BaFoglio), findsNothing);
    });

    testWidgets('da partecipante è inattivo finché il 024b non collega i passi', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      await _tocca(tester, 'Crea un DEN');
      await _diventaPartecipante(tester, 'Acconsento e continuo');
      expect(_pillola(tester, 'Crea un DEN').onTap, isNull);
    });
  });

  group('lo strumento', () {
    testWidgets('«Torna all\'inizio» riparte dal login', (tester) async {
      await _avvia(tester);
      await _accedi(tester);
      expect(find.text('Cucina di notte'), findsOneWidget);
      await _tocca(tester, 'Torna all\'inizio');
      expect(find.text('La tua email'), findsOneWidget);
    });

    testWidgets('il testo 2,0 e la larghezza 744 si leggono dentro la cornice, non fuori', (tester) async {
      await _avvia(tester, altezza: 1300);
      await _tocca(tester, 'Testo 1,0');
      await _tocca(tester, 'Larghezza 360');
      expect(find.text('Testo 2,0'), findsOneWidget);
      expect(find.text('Larghezza 744'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('focus e nome delle pagine', () {
    testWidgets('al cambio di pagina il titolo della pagina nuova prende il focus ed è un\'intestazione', (tester) async {
      final semantica = tester.ensureSemantics();
      await _avvia(tester);
      expect(Focus.of(tester.element(find.text('La tua email'))).hasPrimaryFocus, isTrue);
      await tester.enterText(find.byType(EditableText).first, 'sara.m@example.it');
      await tester.pump();
      await _tocca(tester, 'Ricevi il codice');
      await tester.pump();
      expect(Focus.of(tester.element(find.text('Il codice'))).hasPrimaryFocus, isTrue);
      expect(tester.getSemantics(find.bySemanticsLabel('Il codice').first).flagsCollection.isHeader, isTrue);
      semantica.dispose();
    });

    testWidgets('ogni pagina ha un nome per lo screen reader', (tester) async {
      final semantica = tester.ensureSemantics();
      await _avvia(tester);
      bool haNome(String nome) => find.byType(Semantics).evaluate().any((e) {
            final p = (e.widget as Semantics).properties;
            return p.namesRoute == true && p.label == nome;
          });
      expect(haNome('Accesso: email'), isTrue);
      await _accedi(tester);
      expect(haNome('Elenco dei DEN'), isTrue);
      await _tocca(tester, 'Cucina di notte');
      expect(haNome('Cucina di notte'), isTrue);
      semantica.dispose();
    });
  });

  group('a testo 2,0 e a 744 nulla si taglia', () {
    for (final (nome, larghezza, altezza) in [('360 a 2,0', 1500.0, 1000.0), ('744', 1500.0, 1400.0)]) {
      testWidgets('le pagine a $nome', (tester) async {
        await _avvia(tester, larghezza: larghezza, altezza: altezza);
        await _tocca(tester, 'Testo 1,0');
        if (nome == '744') {
          await _tocca(tester, 'Testo 2,0');
          await _tocca(tester, 'Larghezza 360');
        }
        expect(tester.takeException(), isNull);
        await _accedi(tester);
        expect(tester.takeException(), isNull);
        await _tocca(tester, 'Cucina di notte');
        expect(tester.takeException(), isNull);
        await _tocca(tester, 'Sali sul palco');
        await _sale(tester);
        expect(tester.takeException(), isNull);
        // Le azioni del foglio restano dentro la cornice.
        for (final p in tester.widgetList<BaPillola>(find.descendant(of: find.byType(BaFoglio), matching: find.byType(BaPillola)))) {
          expect(tester.getRect(find.byWidget(p)).bottom, lessThanOrEqualTo(altezza));
        }
      });
    }
  });

  group('nessun timer, nessun Material, nessuna dipendenza', () {
    final file = [
      for (final f in Directory('lib/prototipo').listSync(recursive: true).whereType<File>())
        if (f.path.endsWith('.dart')) f,
    ];

    test('ci sono i file del prototipo', () {
      expect(file.length, greaterThanOrEqualTo(10));
    });

    test('nessun Timer, nessun Future.delayed, nessun conto alla rovescia', () {
      for (final f in file) {
        final s = f.readAsStringSync();
        // Si guarda il codice, non i commenti che dicono che non ci sono.
        final codice = s.split('\n').where((r) => !r.trimLeft().startsWith('//')).join('\n');
        expect(codice, isNot(contains('Timer')), reason: f.path);
        expect(codice, isNot(contains('Future.delayed')), reason: f.path);
        expect(codice, isNot(contains('Stopwatch')), reason: f.path);
        expect(codice, isNot(contains('DateTime.now')), reason: f.path);
      }
    });

    test('nessun Material, nessun Cupertino e nessun import oltre widgets.dart', () {
      for (final f in file) {
        final importi = [
          for (final r in f.readAsLinesSync())
            if (r.startsWith('import ')) r,
        ];
        for (final r in importi) {
          final ammesso = r.contains("'package:flutter/widgets.dart'") ||
              r.contains("'../design_system/") ||
              RegExp(r"^import '[a-z_]+\.dart';$").hasMatch(r);
          expect(ammesso, isTrue, reason: '${f.path}: $r');
        }
      }
    });

    test('nessuna dipendenza della galleria né dell\'l10n', () {
      for (final f in file) {
        final s = f.readAsStringSync();
        expect(s, isNot(contains('galleria/')), reason: f.path);
        expect(s, isNot(contains('AppLocalizations')), reason: f.path);
      }
    });
  });

}
