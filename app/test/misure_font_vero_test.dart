import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/barra_azioni.dart';
import 'package:ba/design_system/campo_testo.dart';
import 'package:ba/design_system/interruttore_riga.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/riga_persona.dart';
import 'package:ba/design_system/riga_impostazione.dart';
import 'package:ba/design_system/riga_valore.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

// Misure con il **font vero** (task 032c). I widget test, da soli, disegnano con Ahem, in cui ogni
// lettera è larga quanto la taglia: «Scendi dal palco» a 14 vale 224 dp invece di 104, e «una riga»
// non si può dimostrare. Qui si registra Instrument Sans con `FontLoader`, leggendo gli asset del
// pubspec, e si misura la barra e la riga di una persona come le vedrebbe chi usa l'app.
//
// **Import oltre widgets.dart (solo in questo test, non in `lib/`):** `package:flutter/services.dart`,
// perché `FontLoader` e `rootBundle` stanno lì e `widgets.dart` non li esporta; e `rendering.dart`,
// per `RenderParagraph` (le righe di un testo, come negli altri test della barra). Nessun import nuovo
// in `lib/design_system/` (CLAUDE.md).
//
// I numeri misurati compaiono nell'uscita del test (e nel report 032c).

const _famiglia = 'Instrument Sans';

/// Registra i tre pesi della famiglia (400, 500, 600), come fa l'app dal pubspec.
Future<void> _caricaFont() async {
  final nomi = {'Regular': FontWeight.w400, 'Medium': FontWeight.w500, 'SemiBold': FontWeight.w600};
  for (final MapEntry(key: nome, value: peso) in nomi.entries) {
    final f = FontLoader(_famiglia)..addFont(rootBundle.load('assets/fonts/instrument-sans/InstrumentSans-$nome.ttf'));
    await f.load();
    expect(peso, isNotNull);
  }
}

double _larghezzaTesto(String testo, TextStyle stile, {double scala = 1.0}) {
  final p = TextPainter(
    text: TextSpan(text: testo, style: stile),
    textDirection: TextDirection.ltr,
    textScaler: TextScaler.linear(scala),
  )..layout();
  final w = p.width;
  p.dispose();
  return w;
}

double _altezzaUnaRiga(TextStyle stile, {double scala = 1.0}) {
  final p = TextPainter(
    text: TextSpan(text: 'x', style: stile),
    textDirection: TextDirection.ltr,
    textScaler: TextScaler.linear(scala),
  )..layout();
  final h = p.height;
  p.dispose();
  return h;
}

/// La barra in una colonna larga [larghezza] (320 a 360 dp: margini di 20), con il testo di sistema.
Widget _app(Widget barra, {double testo = 1.0, double schermo = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(schermo, 800), textScaler: TextScaler.linear(testo)),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: BaLayoutTokens.margine(schermo)),
            child: SizedBox(width: BaLayoutTokens.larghezzaColonna(schermo), child: barra),
          ),
        ),
      ),
    );

BaBarraAzioni _barra(List<String> testi) => BaBarraAzioni(
      azioni: [
        for (var i = 0; i < testi.length; i++)
          BaAzioneBarra(
            ruolo: i == 0 ? BaRuoloAzione.primaria : BaRuoloAzione.secondaria,
            testo: testi[i],
            semanticsLabel: testi[i],
            fissa: i < 3,
            onTap: () {},
          ),
      ],
      onAltro: () {},
      semanticsLabelAltro: 'Altro',
    );

int _righe(WidgetTester tester, String testo) {
  final p = tester.renderObject<RenderParagraph>(find.text(testo));
  return (p.size.height / _altezzaUnaRiga(p.text.style!, scala: p.textScaler.scale(1))).round();
}

void main() {
  setUpAll(_caricaFont);

  group('il font vero si carica', () {
    test('«Scendi dal palco» a 14 non è più 224 dp (Ahem) ma circa 104', () {
      final w = _larghezzaTesto('Scendi dal palco', BaTestoTokens.azione);
      expect(w, isNot(224), reason: 'se vale 224 il font non si è caricato: la misura NON è verificata');
      expect(w, closeTo(104, 2), reason: 'i 104 dp del changelog del 032');
    });
  });

  group('«Scendi dal palco» nella barra, a 360 dp e testo 1,0', () {
    testWidgets('una riga: la pillola è alta 48 e il testo ha una sola riga', (tester) async {
      await tester.pumpWidget(_app(_barra(['Accendi il microfono', 'Scendi dal palco', 'Esci'])));
      expect(tester.takeException(), isNull);
      expect(_righe(tester, 'Scendi dal palco'), 1);
      expect(_righe(tester, 'Esci'), 1);
      final scendi = tester.getRect(find.byType(BaPillola).at(1));
      final esci = tester.getRect(find.byType(BaPillola).at(2));
      expect(scendi.height, BaControlloTokens.coppia);
      expect(esci.height, BaControlloTokens.coppia);
      expect(scendi.top, esci.top, reason: 'affiancate, sulla stessa riga');
      final testo = _larghezzaTesto('Scendi dal palco', BaTestoTokens.azione);
      final minima = BaPillola.larghezzaNecessaria(tester.element(find.byType(BaBarraAzioni)), testo: 'Scendi dal palco', stile: BaTestoTokens.azione, riempimento: BaSpazioTokens.m);
      expect(scendi.width, greaterThanOrEqualTo(minima));
      // ignore: avoid_print
      print('MISURA 360 dp, testo 1,0, 3 azioni: testo «Scendi dal palco» ${testo.toStringAsFixed(1)} dp; '
          'pillola minima ${minima.toStringAsFixed(1)} dp (riempimento 12+12 delle secondarie e filetto 1+1); '
          'pillola disegnata ${scendi.width.toStringAsFixed(1)} dp; «Esci» ${esci.width.toStringAsFixed(1)} dp; '
          'riga di ${BaLayoutTokens.larghezzaColonna(360).toStringAsFixed(0)} dp');
    });

    testWidgets('con «Altro»: ancora una riga, e le due secondarie, «Altro» e gli spazi stanno nella riga', (tester) async {
      await tester.pumpWidget(_app(_barra(['Accendi il microfono', 'Scendi dal palco', 'Esci', 'Impostazioni'])));
      expect(tester.takeException(), isNull);
      expect(_righe(tester, 'Scendi dal palco'), 1);
      final scendi = tester.getRect(find.byType(BaPillola).at(1));
      final esci = tester.getRect(find.byType(BaPillola).at(2));
      final altro = tester.getRect(find.byKey(BaBarraAzioni.chiaveAltro));
      expect(scendi.height, BaControlloTokens.coppia);
      expect(scendi.top, esci.top);
      expect(altro.size, const Size(48, 48));
      final occupato = esci.right - scendi.left + BaControlloTokens.gapCoppia + altro.width;
      expect(occupato, lessThanOrEqualTo(BaLayoutTokens.larghezzaColonna(360) + 0.01));
      final contesto = tester.element(find.byType(BaBarraAzioni));
      final minime = BaPillola.larghezzaNecessaria(contesto, testo: 'Scendi dal palco', stile: BaTestoTokens.azione, riempimento: BaSpazioTokens.m) +
          BaPillola.larghezzaNecessaria(contesto, testo: 'Esci', stile: BaTestoTokens.azione, riempimento: BaSpazioTokens.m) +
          2 * BaControlloTokens.gapCoppia +
          BaBarraAzioniTokens.altroLato;
      // ignore: avoid_print
      print('MISURA 360 dp, testo 1,0, con «Altro»: le due secondarie al minimo, «Altro» e gli spazi occupano '
          '${minime.toStringAsFixed(1)} dp su ${BaLayoutTokens.larghezzaColonna(360).toStringAsFixed(0)} '
          '(il design dice 246: qui 250, più i due filetti di ogni pillola)');
      expect(minime, lessThanOrEqualTo(BaLayoutTokens.larghezzaColonna(360)));
    });

    testWidgets('a testo 1,3 e 1,5 la barra è ancora in riga (italiano), senza parole spezzate né sbordi', (tester) async {
      for (final scala in [1.3, 1.5]) {
        await tester.pumpWidget(_app(_barra(['Accendi il microfono', 'Scendi dal palco', 'Esci', 'Impostazioni']), testo: scala));
        expect(tester.takeException(), isNull, reason: 'testo $scala');
        final barra = tester.getRect(find.byType(BaBarraAzioni));
        for (final r in tester.widgetList<Text>(find.descendant(of: find.byType(BaBarraAzioni), matching: find.byType(Text)))) {
          expect(tester.getRect(find.byWidget(r)).right, lessThanOrEqualTo(barra.right + 0.01), reason: '${r.data} a $scala');
        }
        // Una parola non si spezza mai: la più larga entra, intera, nella larghezza utile della pillola.
        final scendi = tester.getRect(find.byType(BaPillola).at(1));
        final utile = scendi.width - 2 * BaSpazioTokens.m - 2; // riempimento 12 delle secondarie (task 036)
        for (final parola in 'Scendi dal palco'.split(' ')) {
          expect(_larghezzaTesto(parola, BaTestoTokens.azione, scala: scala), lessThanOrEqualTo(utile), reason: '$parola a $scala');
        }
        // ignore: avoid_print
        print('MISURA 360 dp, testo $scala: «Scendi dal palco» su ${_righe(tester, 'Scendi dal palco')} riga/righe, pillola ${scendi.width.toStringAsFixed(0)} dp');
      }
    });

    testWidgets('a testo 2,0 il ripiego a colonna non spezza parole e non taglia', (tester) async {
      await tester.pumpWidget(_app(_barra(['Accendi il microfono', 'Scendi dal palco', 'Esci', 'Impostazioni']), testo: 2.0));
      expect(tester.takeException(), isNull);
      final scendi = tester.getRect(find.byType(BaPillola).at(1));
      final esci = tester.getRect(find.byType(BaPillola).at(2));
      expect(esci.top, greaterThanOrEqualTo(scendi.bottom), reason: 'in colonna');
      expect(scendi.width, BaLayoutTokens.larghezzaColonna(360));
      final barra = tester.getRect(find.byType(BaBarraAzioni));
      for (final r in tester.widgetList<Text>(find.descendant(of: find.byType(BaBarraAzioni), matching: find.byType(Text)))) {
        final rect = tester.getRect(find.byWidget(r));
        expect(rect.right, lessThanOrEqualTo(barra.right + 0.01), reason: r.data);
        expect(rect.left, greaterThanOrEqualTo(barra.left - 0.01), reason: r.data);
      }
      // Nessuna parola spezzata: la parola più larga entra, intera, nella larghezza utile della pillola.
      final utile = scendi.width - 2 * BaSpazioTokens.m - 2; // riempimento 12 delle secondarie (task 036)
      for (final parola in 'Scendi dal palco'.split(' ')) {
        expect(_larghezzaTesto(parola, BaTestoTokens.azione, scala: 2.0), lessThanOrEqualTo(utile), reason: parola);
      }
      // ignore: avoid_print
      print('MISURA 360 dp, testo 2,0: «Scendi dal palco» su ${_righe(tester, 'Scendi dal palco')} riga/righe, in colonna a ${scendi.width.toStringAsFixed(0)} dp');
    });
  });

  group('«In lista» nella riga di una persona, con il font vero', () {
    Widget app(Widget riga, {double testo = 1.0, double schermo = 360}) => Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(size: Size(schermo, 800), textScaler: TextScaler.linear(testo)),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: BaLayoutTokens.larghezzaColonna(schermo), child: SingleChildScrollView(child: riga)),
            ),
          ),
        );

    BaRigaPersona riga(String nome, String? alias) => BaRigaPersona(
          nome: nome,
          alias: alias,
          tinta: 1,
          sagoma: 1,
          voce: BaVoceRigaPersona.aggiunta,
          azione: 'In lista',
        );

    for (final (nome, alias) in [('Davide', '@davide.k'), ('Sara', '@sara.rossi'), ('Maria Antonietta', '@maria.antonietta')]) {
      testWidgets('$nome $alias a 360 dp, testo 1,0: «In lista» è su una riga e sta sulla riga del nome', (tester) async {
        await tester.pumpWidget(app(riga(nome, alias)));
        expect(tester.takeException(), isNull);
        final stile = BaTestoTokens.minore;
        final testo = tester.getRect(find.text('In lista'));
        expect(testo.height, closeTo(_altezzaUnaRiga(stile), 0.5), reason: 'una sola riga');
        expect(_righe(tester, 'In lista'), 1);
        final n = tester.getRect(find.text(nome));
        expect(testo.left, greaterThan(n.right), reason: 'a destra del nome, non a capo sotto');
        expect(testo.center.dy, lessThan(n.bottom + _altezzaUnaRiga(BaTestoTokens.minore) + 8), reason: 'sulla stessa riga della sagoma');
        // ignore: avoid_print
        print('MISURA riga «$nome $alias» 360 dp: «In lista» ${testo.width.toStringAsFixed(1)} × ${testo.height.toStringAsFixed(1)} dp, una riga, a destra del nome');
      });
    }

    for (final scala in [1.5, 2.0]) {
      testWidgets('a testo $scala «In lista» resta su una riga (va a capo la parte destra intera, mai la parola)', (tester) async {
        await tester.pumpWidget(app(riga('Maria Antonietta', '@maria.antonietta'), testo: scala));
        expect(tester.takeException(), isNull);
        expect(_righe(tester, 'In lista'), 1);
        final r = tester.getRect(find.byType(BaRigaPersona));
        expect(tester.getRect(find.text('In lista')).right, lessThanOrEqualTo(r.right + 0.01));
      });
    }
  });

  group('lista di persone a testo 2,0, con il font vero (task 032c)', () {
    // Come negli screenshot del 030 con il testo grande: Marta «In lista», Davide e Luca «Aggiungi».
    final righe = <BaRigaPersona>[
      BaRigaPersona(nome: 'Marta', tinta: 1, sagoma: 1, voce: BaVoceRigaPersona.aggiunta, azione: 'In lista'),
      BaRigaPersona(nome: 'Davide', tinta: 2, sagoma: 2, voce: BaVoceRigaPersona.daAggiungere, azione: 'Aggiungi', onAzione: () {}),
      BaRigaPersona(nome: 'Luca', tinta: 3, sagoma: 3, voce: BaVoceRigaPersona.daAggiungere, azione: 'Aggiungi', onAzione: () {}),
      BaRigaPersona(nome: 'Maria Antonietta Bianchi-Rossi', tinta: 4, sagoma: 4, voce: BaVoceRigaPersona.daAggiungere, azione: 'Aggiungi', onAzione: () {}),
    ];
    const nomi = ['Marta', 'Davide', 'Luca', 'Maria Antonietta Bianchi-Rossi'];

    Widget app(double testo) => Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(size: const Size(360, 800), textScaler: TextScaler.linear(testo)),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: 320, child: SingleChildScrollView(child: Column(children: righe))),
            ),
          ),
        );

    Rect azione(WidgetTester tester, int i) {
      final r = find.byWidget(righe[i]);
      if (i == 0) return tester.getRect(find.descendant(of: r, matching: find.byType(CustomPaint)).first).expandToInclude(tester.getRect(find.descendant(of: r, matching: find.text('In lista'))));
      return tester.getRect(find.descendant(of: r, matching: find.byType(BaTouchable)));
    }

    testWidgets('a 2,0 tutte le azioni hanno lo stesso bordo sinistro e stanno sotto il nome', (tester) async {
      await tester.pumpWidget(app(2.0));
      expect(tester.takeException(), isNull);
      final bordi = <double>{};
      for (var i = 0; i < righe.length; i++) {
        final nome = tester.getRect(find.descendant(of: find.byWidget(righe[i]), matching: find.text(nomi[i])));
        final a = azione(tester, i);
        expect(a.top, greaterThanOrEqualTo(nome.bottom), reason: '${nomi[i]}: sotto il nome');
        bordi.add(a.left);
      }
      expect(bordi, hasLength(1), reason: 'stesso bordo sinistro: $bordi');
    });

    testWidgets('a 1,0 le azioni di Marta, Davide e Luca stanno accanto al nome', (tester) async {
      await tester.pumpWidget(app(1.0));
      for (var i = 0; i < 3; i++) {
        final nome = tester.getRect(find.descendant(of: find.byWidget(righe[i]), matching: find.text(nomi[i])));
        expect(azione(tester, i).left, greaterThan(nome.right), reason: nomi[i]);
        expect(azione(tester, i).center.dy, lessThan(nome.bottom + 20), reason: '${nomi[i]}: sulla riga del nome');
      }
    });
  });

  group('valori e campi a testo 2,0, con il font vero (task 032c)', () {
    Widget app(Widget figlio, double testo) => Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(size: const Size(360, 800), textScaler: TextScaler.linear(testo)),
            child: Align(alignment: Alignment.topLeft, child: SizedBox(width: 320, child: SingleChildScrollView(child: figlio))),
          ),
        );

    testWidgets('in una lista di righe con valore, a 2,0 tutti i valori stanno sotto l\'etichetta, a sinistra', (tester) async {
      const coppie = [('Lingua', 'Italiano'), ('Microfono', 'Consentito'), ('Chi può trovarmi', 'Chi conosco'), ('Persone bloccate', '3 persone')];
      await tester.pumpWidget(app(Column(children: [for (final (e, v) in coppie) BaRigaValore(etichetta: e, valore: v)]), 2.0));
      expect(tester.takeException(), isNull);
      final bordi = <double>{};
      for (final (e, v) in coppie) {
        expect(tester.getRect(find.text(v)).top, greaterThanOrEqualTo(tester.getRect(find.text(e)).bottom), reason: e);
        bordi.add(tester.getRect(find.text(v)).left);
      }
      expect(bordi, hasLength(1), reason: '$bordi');
    });

    testWidgets('a 1,0 «Lingua Italiano» sta ancora su una riga', (tester) async {
      await tester.pumpWidget(app(const BaRigaValore(etichetta: 'Lingua', valore: 'Italiano'), 1.0));
      expect(tester.getRect(find.text('Italiano')).left, greaterThan(tester.getRect(find.text('Lingua')).right));
    });

    BaCampoTesto campo(String segnaposto, {bool piuRighe = false}) => BaCampoTesto(
          controller: TextEditingController(),
          etichetta: 'Campo',
          segnaposto: segnaposto,
          segnapostoSuPiuRighe: piuRighe,
        );

    testWidgets('a 2,0 «nome@esempio.it» e «320 000 0000» stanno su una riga (con i puntini), mai spezzati', (tester) async {
      for (final segnaposto in ['nome@esempio.it', '320 000 0000']) {
        await tester.pumpWidget(app(campo(segnaposto), 2.0));
        expect(tester.takeException(), isNull);
        expect(_righe(tester, segnaposto), 1, reason: segnaposto);
        // ignore: avoid_print
        print('MISURA campo a 2,0 e 360 dp: «$segnaposto» su ${_righe(tester, segnaposto)} riga');
      }
    });

    testWidgets('il segnaposto della ricerca va a capo fra le parole, mai a metà: ogni parola entra intera', (tester) async {
      const testo = 'Nickname, alias, email o numero';
      await tester.pumpWidget(app(campo(testo, piuRighe: true), 2.0));
      expect(tester.takeException(), isNull);
      final larghezza = tester.getSize(find.text(testo)).width;
      for (final parola in testo.split(' ')) {
        expect(_larghezzaTesto(parola, BaTestoTokens.campo, scala: 2.0), lessThanOrEqualTo(larghezza), reason: parola);
      }
      expect(_righe(tester, testo), greaterThan(1), reason: 'a capo fra le parole');
    });
  });

  group('nessuna parola spezzata a testo 2,0 e 360 dp, con il font vero (task 032c)', () {
    // La regola generale: in ogni testo delle righe, la parola più lunga sta nella larghezza che il
    // testo ha davvero. Un paragrafo con una parola spezzata ha per riga più larga tutta la sua
    // larghezza disponibile, minore della parola: il test fallisce e dice quale.
    const lunga = 'Quando si libera un posto, la notifica ti porta alla stanza, automaticamente.';
    final casi = <String, Widget>{
      'BaInterruttoreRiga': BaInterruttoreRiga(
        titolo: 'Fammi entrare automaticamente',
        descrizione: lunga,
        acceso: false,
        parolaAcceso: 'Acceso',
        parolaSpento: 'Spento',
        onCambia: (_) {},
      ),
      'BaRigaValore': const BaRigaValore(etichetta: 'Chi può trovarmi', valore: 'Chi conosco', sottotitolo: 'Impostazioni dell\'account, automaticamente.'),
      'BaRigaPersona (azione)': BaRigaPersona(nome: 'Maria Antonietta Bianchi-Rossi', alias: '@maria.antonietta', voce: BaVoceRigaPersona.daAggiungere, azione: 'Aggiungi', onAzione: () {}),
      'BaRigaPersona (interruttore)': BaRigaPersona(nome: 'Maria Antonietta', alias: '@maria.antonietta', acceso: true, parolaAcceso: 'Acceso', parolaSpento: 'Spento', onCambia: (_) {}),
      'BaRigaImpostazione.interruttore': BaRigaImpostazione.interruttore(
        titolo: 'Richiamo',
        descrizione: lunga,
        acceso: true,
        parolaAcceso: 'Acceso',
        parolaSpento: 'Spento',
        onCambia: (_) {},
      ),
      'BaRigaImpostazione.valore': BaRigaImpostazione.valore(titolo: 'Persone bloccate', valore: '3 persone', sottotitolo: 'Restano finché non le sblocchi.'),
    };

    testWidgets('la parola più lunga di ogni testo sta nella larghezza disponibile', (tester) async {
      for (final MapEntry(key: nome, value: riga) in casi.entries) {
        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(size: Size(360, 800), textScaler: TextScaler.linear(2.0)),
            child: Align(alignment: Alignment.topLeft, child: SizedBox(width: 320, child: SingleChildScrollView(child: riga))),
          ),
        ));
        expect(tester.takeException(), isNull, reason: nome);
        for (final r in tester.renderObjectList<RenderParagraph>(find.descendant(of: find.byWidget(riga), matching: find.byType(RichText)))) {
          final testo = r.text.toPlainText();
          for (final parola in testo.split(RegExp(r'\s+')).where((p) => p.isNotEmpty)) {
            final misura = TextPainter(text: TextSpan(text: parola, style: r.text.style), textDirection: TextDirection.ltr, textScaler: r.textScaler)..layout();
            expect(misura.width, lessThanOrEqualTo(r.size.width + 0.5), reason: '$nome: «$parola» (in «$testo») si spezza: ${misura.width.toStringAsFixed(1)} dp in ${r.size.width.toStringAsFixed(1)}');
            misura.dispose();
          }
        }
      }
    });
  });

  group('il ripiego della barra si misura (task 036)', () {
    // Nessun numero per lingua nel codice: la barra resta in riga finché ogni secondaria sta intera su
    // una riga. Qui si misura con il font vero, a 360 dp (riga di 320), e le soglie si stampano.
    const palcoIt = ['Accendi il microfono', 'Scendi dal palco', 'Esci', 'Impostazioni'];
    const palcoDe = ['Mikrofon einschalten', 'Von der Bühne gehen', 'Verlassen', 'Einstellungen'];

    Widget barraDe(List<String> testi, {bool ascoltatore = false}) => BaBarraAzioni(
          azioni: [
            for (var i = 0; i < testi.length; i++)
              BaAzioneBarra(
                ruolo: i == 0 ? BaRuoloAzione.primaria : BaRuoloAzione.secondaria,
                testo: testi[i],
                semanticsLabel: testi[i],
                fissa: i < 3 && !(ascoltatore && i == 2),
                inAltro: ascoltatore && i == 2,
                onTap: () {},
              ),
          ],
          onAltro: () {},
          semanticsLabelAltro: 'Altro',
        );

    /// Le secondarie sono una sotto l'altra?
    bool ripiegata(WidgetTester tester) {
      final a = tester.getRect(find.byType(BaPillola).at(1));
      final b = tester.getRect(find.byType(BaPillola).at(2));
      return b.top >= a.bottom;
    }

    /// La prima scala (a passi di 0,05) a cui la barra si ripiega, o null se non succede fino a 2,0.
    Future<double?> sogliaDi(WidgetTester tester, Widget barra) async {
      for (var passo = 20; passo <= 40; passo++) {
        final scala = passo / 20;
        await tester.pumpWidget(_app(barra, testo: scala));
        expect(tester.takeException(), isNull, reason: 'testo $scala');
        if (ripiegata(tester)) return scala;
      }
      return null;
    }

    testWidgets('italiano: «Scendi dal palco» su una riga a 1,4 e a 1,5; si ripiega da circa 1,6 e non peggiora a 2,0', (tester) async {
      for (final scala in [1.4, 1.5]) {
        await tester.pumpWidget(_app(_barra(palcoIt), testo: scala));
        expect(_righe(tester, 'Scendi dal palco'), 1, reason: 'a $scala una riga');
        expect(ripiegata(tester), isFalse, reason: 'a $scala in riga');
        expect(tester.getRect(find.byType(BaPillola).at(1)).height, BaControlloTokens.coppia, reason: 'a $scala alta 48');
      }
      final soglia = await sogliaDi(tester, _barra(palcoIt));
      // ignore: avoid_print
      print('MISURA barra del palco, italiano, 360 dp: in riga fino a ${soglia == null ? 'oltre 2,0' : (soglia - 0.05).toStringAsFixed(2)}, ripiegata da $soglia');
      expect(soglia, isNotNull);
      expect(soglia, greaterThan(1.5), reason: 'il design: in riga fino a 1,5');
      expect(soglia, lessThanOrEqualTo(1.7), reason: 'il design: ripiegata da 1,6');
      // A 2,0 non peggiora: in colonna, a tutta larghezza, nessuna parola spezzata, niente che sborda.
      await tester.pumpWidget(_app(_barra(palcoIt), testo: 2.0));
      expect(ripiegata(tester), isTrue);
      expect(tester.getRect(find.byType(BaPillola).at(1)).width, BaLayoutTokens.larghezzaColonna(360));
    });

    testWidgets('tedesco: a 1,4 la barra è già a colonna, senza parole spezzate; la soglia è più bassa dell\'italiano', (tester) async {
      await tester.pumpWidget(_app(barraDe(palcoDe), testo: 1.4));
      expect(tester.takeException(), isNull);
      expect(ripiegata(tester), isTrue, reason: 'a 1,4 in tedesco la barra è a colonna');
      final scendi = tester.getRect(find.byType(BaPillola).at(1));
      final utile = scendi.width - 2 * BaSpazioTokens.m - 2;
      for (final parola in 'Von der Bühne gehen'.split(' ')) {
        expect(_larghezzaTesto(parola, BaTestoTokens.azione, scala: 1.4), lessThanOrEqualTo(utile), reason: parola);
      }
      final barra = tester.getRect(find.byType(BaBarraAzioni));
      for (final r in tester.widgetList<Text>(find.descendant(of: find.byType(BaBarraAzioni), matching: find.byType(Text)))) {
        expect(tester.getRect(find.byWidget(r)).right, lessThanOrEqualTo(barra.right + 0.01), reason: r.data);
      }
      final de = await sogliaDi(tester, barraDe(palcoDe));
      final it = await sogliaDi(tester, _barra(palcoIt));
      // ignore: avoid_print
      print('MISURA barra del palco, tedesco, 360 dp: ripiegata da $de (italiano: da $it)');
      expect(de, isNotNull);
      expect(de, lessThan(it!), reason: 'la soglia dipende dalla lingua: nessun numero fisso');
      expect(de, lessThanOrEqualTo(1.3), reason: 'il design: da 1,2 circa');
    });

    testWidgets('l\'ascoltatore (una sola secondaria, «Esci», e «Altro») non si ripiega mai, nemmeno a 2,0', (tester) async {
      final ascoltatore = barraDe(['Sali sul palco', 'Esci', 'Impostazioni'], ascoltatore: true);
      for (var passo = 20; passo <= 40; passo += 4) {
        await tester.pumpWidget(_app(ascoltatore, testo: passo / 20));
        expect(tester.takeException(), isNull, reason: 'testo ${passo / 20}');
        final esci = tester.getRect(find.byType(BaPillola).at(1));
        final altro = tester.getRect(find.byKey(BaBarraAzioni.chiaveAltro));
        expect(altro.left, greaterThanOrEqualTo(esci.right), reason: '«Altro» a destra di «Esci», sulla stessa riga (testo ${passo / 20})');
        expect(altro.center.dy, closeTo(esci.center.dy, 0.01));
      }
    });

    testWidgets('con «Altro» in colonna: a destra sulla riga dell\'ultima, 48 × 48, e le pillole della stessa riga hanno la stessa altezza', (tester) async {
      await tester.pumpWidget(_app(barraDe(palcoDe), testo: 1.4));
      final a = tester.getRect(find.byType(BaPillola).at(1));
      final b = tester.getRect(find.byType(BaPillola).at(2));
      final altro = tester.getRect(find.byKey(BaBarraAzioni.chiaveAltro));
      expect(altro.size, const Size(48, 48));
      expect(altro.center.dy, closeTo(b.center.dy, 0.01));
      expect(altro.left, greaterThanOrEqualTo(b.right));
      expect(a.width, BaLayoutTokens.larghezzaColonna(360));
    });
  });

  group('le regole del testo grande: i campi (task 036)', () {
    Widget app(Widget figlio, double testo) => Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(size: const Size(360, 800), textScaler: TextScaler.linear(testo)),
            child: Align(alignment: Alignment.topLeft, child: SizedBox(width: 320, child: SingleChildScrollView(child: figlio))),
          ),
        );

    testWidgets('il segnaposto di più parole (la ricerca) va a capo fra le parole a 1,4 e a 2,0, mai a metà', (tester) async {
      const testo = 'Nickname, alias, email o numero';
      for (final scala in [1.4, 2.0]) {
        await tester.pumpWidget(app(
          BaCampoTesto(controller: TextEditingController(), etichetta: 'Cerca', segnaposto: testo, segnapostoSuPiuRighe: true),
          scala,
        ));
        expect(tester.takeException(), isNull, reason: 'testo $scala');
        final larghezza = tester.getSize(find.text(testo)).width;
        for (final parola in testo.split(' ')) {
          expect(_larghezzaTesto(parola, BaTestoTokens.campo, scala: scala), lessThanOrEqualTo(larghezza), reason: '«$parola» a $scala');
        }
        // A 2,0 il segnaposto di più parole va a capo; a 1,4 può starci in una riga o in due, mai spezzato.
        if (scala == 2.0) expect(_righe(tester, testo), greaterThan(1), reason: 'a capo fra le parole');
      }
    });

    testWidgets('il testo scritto non va a capo: una riga che scorre in orizzontale, e si vede la fine', (tester) async {
      const lungo = 'nome.cognome.molto.lungo@esempio-di-dominio-lungo.it';
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(BaCampoTesto(controller: controller, etichetta: 'Email'), 2.0));
      await tester.enterText(find.byType(EditableText), lungo);
      await tester.pump();
      expect(tester.takeException(), isNull);
      final scorrimento = tester.state<ScrollableState>(find.descendant(of: find.byType(EditableText), matching: find.byType(Scrollable)).first);
      expect(scorrimento.position.axis, Axis.horizontal, reason: 'scorre in orizzontale');
      expect(scorrimento.position.maxScrollExtent, greaterThan(0), reason: 'il testo è più largo del campo');
      expect(tester.getSize(find.byType(EditableText)).height, closeTo(_altezzaUnaRiga(BaTestoTokens.campo, scala: 2.0), 1.5), reason: 'una sola riga');
    });

    testWidgets('la descrizione (multilinea) va a capo, anche il suo segnaposto', (tester) async {
      await tester.pumpWidget(app(
        BaCampoTesto(controller: TextEditingController(), etichetta: 'Descrizione', segnaposto: 'Due chiacchiere dopo cena, senza un argomento fisso.', minRighe: 3, maxRighe: 6),
        2.0,
      ));
      expect(tester.takeException(), isNull);
      expect(_righe(tester, 'Due chiacchiere dopo cena, senza un argomento fisso.'), greaterThan(1));
    });
  });
}
