import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/azioni_in_coppia.dart';
import 'package:ba/design_system/banda_posto.dart';
import 'package:ba/design_system/campo_codice.dart';
import 'package:ba/design_system/campo_testo.dart';
import 'package:ba/design_system/chip_scelta.dart';
import 'package:ba/design_system/fascia_attesa.dart';
import 'package:ba/design_system/interruttore_riga.dart';
import 'package:ba/design_system/punto_aggancio.dart';
import 'package:ba/design_system/riga_coda.dart';
import 'package:ba/design_system/scelta_den.dart';
import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/messaggio.dart';
import 'package:ba/design_system/scheda_persona.dart';
import 'package:ba/design_system/barra_azioni.dart';
import 'package:ba/design_system/glifo.dart';
import 'package:ba/design_system/palco.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/presenza.dart';
import 'package:ba/design_system/pubblico.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/galleria/main_galleria.dart';

Future<void> _tocca(WidgetTester tester, String testo) async {
  final f = find.text(testo);
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pump();
  expect(tester.takeException(), isNull, reason: "dopo «$testo»");
}

/// La stanza finta a qualunque testo: intestazione, riga di debug e palco uno
/// sotto l'altro, ognuno a altezza naturale; le presenze dentro il palco e mai
/// sopra intestazione o riga di debug.
void _controllaStanza(WidgetTester tester) {
  final titolo = tester.getRect(find.text('Serata sul balcone'));
  final marcatore = tester.getRect(find.textContaining('SUL PALCO'));
  final indicatore = tester.getRect(find.textContaining('d = '));
  final palco = tester.getRect(find.byType(BaPalco));
  expect(marcatore.top, greaterThanOrEqualTo(titolo.bottom - 0.01), reason: 'marcatore sotto il titolo');
  expect(indicatore.top, greaterThanOrEqualTo(marcatore.bottom - 0.01), reason: "indicatore sotto l'intestazione");
  expect(palco.top, greaterThanOrEqualTo(indicatore.bottom - 0.01), reason: 'il palco parte sotto');
  expect(indicatore.left, greaterThanOrEqualTo(palco.left - 0.01));
  expect(indicatore.right, lessThanOrEqualTo(palco.right + 0.01), reason: 'va a capo, non esce dal bordo');
  for (var i = 0; i < find.byType(BaPresenza).evaluate().length; i++) {
    final p = tester.getRect(find.byType(BaPresenza).at(i));
    for (final sopra in [titolo, marcatore, indicatore]) {
      expect(p.overlaps(sopra), isFalse, reason: 'presenza $i sovrapposta a $sopra');
    }
    expect(p.top, greaterThanOrEqualTo(palco.top - 0.01), reason: 'presenza $i sopra il palco');
  }
}

/// La scatola della stanza finta (il Container con fondo e filetto), per
/// misurare le cose rispetto al suo fondo: la pagina scorre.
Rect _stanza(WidgetTester tester) => tester.getRect(find
    .ancestor(
      of: find.byType(BaBarraAzioni),
      matching: find.byWidgetPredicate((w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).color == BaColorTokens.fondoApp &&
          (w.decoration as BoxDecoration).border != null),
    )
    .first);


/// Una vista abbastanza alta da contenere la stanza finta intera (fino a 1060 dp):
/// i tocchi sul velo e sulle azioni dei fogli non cadono fuori dallo schermo.
void _vistaAlta(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('la galleria di BaTouchable si costruisce a 360 e a 744, con le aree e senza movimento',
      (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    expect(find.text('BaTouchable'), findsWidgets);

    // I tre controlli di sviluppo: nessuna eccezione di layout.
    await _tocca(tester, 'Mostra le aree toccabili');
    await _tocca(tester, 'Riduci movimento');
    await _tocca(tester, 'Larghezza 360');
    expect(find.text('Larghezza 744'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('la pagina delle presenze: 5 diametri, 12 tinte, 5 sagome e tutti i controlli',
      (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPresenza');
    expect(find.byType(BaPresenza), findsNWidgets(5 + 12 + 5));

    for (final c in [
      'Parla',
      'Ampiezza 0,5',
      'Ampiezza 1',
      'Voci 2',
      'Voci 3',
      'Linea instabile',
      'Persa',
      'Scheletro',
      'Immagine fallita',
      'Riduci movimento',
    ]) {
      await _tocca(tester, c);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: c);
    }

    // Simula voce: una ampiezza nuova a ogni campionamento. Si spegne per
    // fermare il timer.
    await _tocca(tester, 'Simula voce');
    await tester.pump(const Duration(milliseconds: 600));
    await _tocca(tester, 'Simula voce');
    expect(tester.takeException(), isNull);
  });

  testWidgets('toccare una presenza aggiorna il conteggio', (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPresenza');
    expect(find.textContaining('TOCCHI: 0'), findsOneWidget);
    await tester.ensureVisible(find.byType(BaPresenza).first);
    await tester.pump();
    await tester.tap(find.byType(BaPresenza).first);
    await tester.pump();
    expect(find.textContaining('TOCCHI: 1'), findsOneWidget);
  });

  testWidgets('la pagina del palco: 1 persona a 208, 8 a 88, testo grande, 744, vuoto e lingue',
      (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPalco');

    double diametro() =>
        tester.getSize(find.byType(BaPresenza).first).width - 2 * BaPresenza.banda;

    // Una persona, testo normale: a 208 dp.
    expect(find.byType(BaPresenza), findsOneWidget);
    expect(diametro(), 208);

    // Otto persone: 88.
    for (var i = 0; i < 7; i++) {
      await _tocca(tester, 'Persone +');
    }
    expect(find.byType(BaPresenza), findsNWidgets(8));
    expect(diametro(), 88);

    // Testo di sistema 2,0 e altezza della stanza 1060 → 1010 → 960 → 910: il
    // palco cede in modo continuo, nessuna presenza sparisce.
    await _tocca(tester, 'Testo 1,0');
    final diametri = [diametro()];
    for (final altezza in [1060, 1010, 960]) {
      await _tocca(tester, 'Altezza: $altezza');
      diametri.add(diametro());
      expect(find.byType(BaPresenza), findsNWidgets(8), reason: 'altezza $altezza');
    }
    for (var i = 1; i < diametri.length; i++) {
      expect(diametri[i], lessThanOrEqualTo(diametri[i - 1]), reason: 'non cresce mai');
    }
    expect(diametri.last, lessThan(88), reason: 'a 910 dp il palco è sceso sotto 88');
    expect(diametri.last, greaterThanOrEqualTo(BaPresenzaTokens.minimo));
    expect(diametri.toSet().length, 4, reason: 'scende per gradi, non di colpo');

    // La riga di debug sta nel flusso, sopra il palco, e va a capo: non esce dal
    // bordo e non copre le presenze.
    await tester.pump();
    _controllaStanza(tester);
    await _tocca(tester, 'Altezza: 910'); // torna a 1060
    await _tocca(tester, 'Testo 2,0');

    // Tablet: presenze più grandi (otto: 132).
    await _tocca(tester, 'Larghezza 360');
    expect(diametro(), 132);
    await _tocca(tester, 'Larghezza 744');

    // Gli stati e i controlli, senza eccezioni.
    for (final c in [
      'Parlano: 0',
      'Parlano: 1',
      'Persa',
      'Scheletro',
      'Congelato',
      'Riduci movimento',
    ]) {
      await _tocca(tester, c);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: c);
    }

    // Palco vuoto: l'invito, nelle cinque lingue.
    await _tocca(tester, 'Congelato');
    await _tocca(tester, 'Persone −');
    for (var i = 0; i < 7; i++) {
      await _tocca(tester, 'Persone −');
    }
    expect(find.byType(BaPresenza), findsNothing);
    expect(find.text('Il palco è libero.'), findsOneWidget);
    // Ogni pressione passa alla lingua successiva: IT → EN → FR → ES → DE.
    for (final (da, lingua, testo) in [
      ('IT', 'EN', 'The stage is free.'),
      ('EN', 'FR', 'La scène est libre.'),
      ('FR', 'ES', 'El escenario está libre.'),
      ('ES', 'DE', 'Die Bühne ist frei.'),
    ]) {
      await _tocca(tester, 'Lingua: $da');
      expect(find.text(testo), findsOneWidget, reason: lingua);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('la stanza finta a testo 2,0: intestazione, indicatore e palco non si sovrappongono',
      (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPalco');
    for (var i = 0; i < 7; i++) {
      await _tocca(tester, 'Persone +');
    }
    await tester.pump();
    _controllaStanza(tester);

    // Testo 2,0: l'intestazione va a capo e occupa la sua altezza naturale.
    final titoloNormale = tester.getRect(find.text('Serata sul balcone')).height;
    await _tocca(tester, 'Testo 1,0');
    await tester.pump();
    final titoloGrande = tester.getRect(find.text('Serata sul balcone')).height;
    expect(titoloGrande, greaterThan(titoloNormale), reason: 'a 2,0 il titolo va a capo e cresce');
    _controllaStanza(tester);

    // A ogni altezza della stanza, il palco parte sotto l'intestazione.
    for (final altezza in [1060, 1010, 960]) {
      await _tocca(tester, 'Altezza: $altezza');
      await tester.pump();
      _controllaStanza(tester);
      expect(find.byType(BaPresenza), findsNWidgets(8));
    }
  });

  testWidgets('la prima persona prende uno stato con glifo, e il glifo sta nel disco', (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPalco');
    await _tocca(tester, 'Persone +');
    await _tocca(tester, 'Persone +');

    BaTipoGlifo? glifo() {
      final g = find.byType(BaGlifo);
      return g.evaluate().isEmpty ? null : tester.widget<BaGlifo>(g.first).tipo;
    }

    expect(glifo(), isNull);
    final attesi = <(String, BaTipoGlifo?)>[
      ('nessuno', BaTipoGlifo.altoparlante), // → mutata
      ('mutata', BaTipoGlifo.altoparlante), // → mutata che parla
      ('mutata che parla', BaTipoGlifo.bloccata),
      ('bloccata', BaTipoGlifo.microfono),
      ('microfono spento', BaTipoGlifo.microfono), // io
      ('microfono spento (io)', null), // ha la parola: solo la tacca
    ];
    for (final (da, tipo) in attesi) {
      await _tocca(tester, 'Prima persona: $da');
      await tester.pump(const Duration(milliseconds: 200));
      expect(glifo(), tipo, reason: 'dopo «$da»');
    }
    expect(find.byType(BaTaccaParola), findsOneWidget);
    // La mutata che parla non ha anello, e il glifo non copre le iniziali.
    await _tocca(tester, 'Prima persona: ha la parola');
    await _tocca(tester, 'Prima persona: nessuno');
    await _tocca(tester, 'Prima persona: mutata');
    expect(
      tester.getRect(find.byType(BaGlifo)).overlaps(tester.getRect(find.text('MB'))),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('la pagina delle presenze: i controlli dei glifi e la riga dei dodici glifi', (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPresenza');
    // La riga: tre glifi, due lati, due stati.
    expect(find.byType(BaGlifo), findsNWidgets(12));
    for (final c in [
      'Mutata',
      'Parla',
      'Bloccata',
      'Microfono spento: altri',
      'Microfono spento: io',
      'Ha la parola',
    ]) {
      await _tocca(tester, c);
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.byType(BaTaccaParola), findsNWidgets(22));
    expect(tester.takeException(), isNull);
  });

  testWidgets('la stanza finta ha il pubblico e la barra veri; a testo 2,0 la barra resta in basso e il palco cede',
      (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPalco');
    for (var i = 0; i < 7; i++) {
      await _tocca(tester, 'Persone +');
    }
    await tester.pump();

    // Il pubblico (campione di tre sagome e contatore) e la barra a tre posti
    // con «Altro»: sono i componenti veri, non una riga di testo.
    expect(find.byType(BaPubblico), findsOneWidget);
    expect(find.text('12 IN ASCOLTO'), findsOneWidget);
    expect(find.byType(BaBarraAzioni), findsOneWidget);
    expect(find.byType(BaPillola), findsNWidgets(BaBarraAzioniTokens.posti));
    expect(find.byKey(BaBarraAzioni.chiaveAltro), findsOneWidget);

    final palcoNormale = tester.getSize(find.byType(BaPalco)).height;
    final barraNormale = tester.getRect(find.byType(BaBarraAzioni));
    final dalFondoNormale = _stanza(tester).bottom - barraNormale.bottom;

    await _tocca(tester, 'Testo 1,0'); // passa a 2,0
    await tester.pump();
    final palcoGrande = tester.getSize(find.byType(BaPalco)).height;
    final barraGrande = tester.getRect(find.byType(BaBarraAzioni));
    final dalFondoGrande = _stanza(tester).bottom - barraGrande.bottom;

    expect(palcoGrande, lessThan(palcoNormale), reason: 'il palco cede');
    expect(dalFondoGrande, closeTo(dalFondoNormale, 0.01), reason: 'la barra resta ancorata in basso');
    expect(barraGrande.height, greaterThan(barraNormale.height), reason: 'la barra cresce, non si taglia');
    expect(find.byType(BaPillola), findsNWidgets(BaBarraAzioniTokens.posti), reason: 'nessuna azione si perde');
    expect(find.byKey(BaBarraAzioni.chiaveAltro), findsOneWidget);
    expect(find.byType(BaPresenza), findsNWidgets(8));
    expect(tester.takeException(), isNull);
    _controllaStanza(tester);
  });

  testWidgets('la pagina dei controlli: pillole, coppia, barra da 1 a 6 azioni, pubblico, testo 2,0 e 744',
      (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'Controlli');

    expect(find.byType(BaPubblico), findsNWidgets(5));
    expect(find.byType(BaAzioniInCoppia), findsNWidgets(2));
    expect(find.byType(BaBarraAzioni), findsOneWidget);

    // La barra con 1…6 azioni: «Altro» dalla quarta.
    for (var i = 0; i < 6; i++) {
      await _tocca(tester, 'Azioni −');
    }
    expect(find.byKey(BaBarraAzioni.chiaveAltro), findsNothing);
    for (final (n, altro) in [(2, false), (3, false), (4, true), (5, true), (6, true)]) {
      await _tocca(tester, 'Azioni +');
      expect(find.byKey(BaBarraAzioni.chiaveAltro), altro ? findsOneWidget : findsNothing, reason: '$n azioni');
    }

    // Testo 2,0, 744 e riduci movimento: nessuna eccezione.
    for (final c in ['Testo 1,0', 'Larghezza 360', 'Riduci movimento']) {
      await _tocca(tester, c);
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('«Altro» apre il foglio con le azioni dalla quarta, dentro la stanza', (tester) async {
    _vistaAlta(tester);
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPalco');
    expect(find.text('Azione 4'), findsNothing, reason: 'in «Altro», non nella barra');

    final altro = find.byKey(BaBarraAzioni.chiaveAltro);
    await tester.ensureVisible(altro);
    await tester.tap(altro);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    expect(find.byType(BaFoglio), findsOneWidget);
    expect(find.text('Azione 4'), findsOneWidget);
    expect(find.text('Azione 5'), findsOneWidget);
    // Il foglio sta dentro la stanza finta e sale dal fondo.
    final foglio = tester.getRect(find.byWidgetPredicate((w) =>
        w is DecoratedBox && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).color == BaColorTokens.superficieFoglio));
    final stanza = _stanza(tester);
    expect(stanza.contains(foglio.topLeft), isTrue);
    expect(foglio.bottom, closeTo(stanza.bottom, 1.01));

    // Il velo chiude.
    await tester.tapAt(Offset(foglio.center.dx, foglio.top / 2 + stanza.top / 2));
    await tester.pumpAndSettle();
    expect(find.byType(BaFoglio), findsNothing);
  });

  testWidgets('toccare una presenza apre la scheda: tre fisse, azioni nuove, e «Muta» inattiva se non parla',
      (tester) async {
    _vistaAlta(tester);
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPalco');
    final presenza = find.byType(BaPresenza).first;
    await tester.ensureVisible(presenza);
    await tester.tap(presenza);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    expect(find.byType(BaFoglio), findsOneWidget);
    expect(find.byType(BaSchedaPersona), findsOneWidget);
    for (final t in ['Muta questa voce', 'Blocca', 'Segnala', 'Azione nuova 1', 'Azione nuova 2']) {
      expect(find.text(t), findsOneWidget, reason: t);
    }
    // Nessuno parla: «Muta questa voce» è inattiva e lo dice.
    expect(find.text('Si può mutare solo mentre parla'), findsOneWidget);
    await tester.tap(find.text('Chiudi'));
    await tester.pumpAndSettle();
    expect(find.byType(BaFoglio), findsNothing);

    // Se parla, «Muta questa voce» è attiva e la spiegazione non c'è.
    await _tocca(tester, 'Parlano: 0');
    await tester.tap(find.byType(BaPresenza).first);
    await tester.pumpAndSettle();
    expect(find.text('Si può mutare solo mentre parla'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a testo 2,0 il foglio di «Altro» e la scheda non tagliano niente', (tester) async {
    _vistaAlta(tester);
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPalco');
    await _tocca(tester, 'Testo 1,0'); // 2,0
    final altro = find.byKey(BaBarraAzioni.chiaveAltro);
    await tester.ensureVisible(altro);
    await tester.tap(altro);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(BaFoglio), findsOneWidget);
    await tester.tap(find.text('Chiudi'));
    await tester.pumpAndSettle();

    final presenza = find.byType(BaPresenza).first;
    await tester.ensureVisible(presenza);
    await tester.tap(presenza);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(BaSchedaPersona), findsOneWidget);
  });

  testWidgets('la pagina «Fogli e messaggi»: ogni foglio si apre e si chiude, 2,0, 744 e il messaggio',
      (tester) async {
    _vistaAlta(tester);
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'Fogli e messaggi');

    Future<void> provaFoglio(String pulsante, {String? chiudi}) async {
      await _tocca(tester, pulsante);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: pulsante);
      expect(find.byType(BaFoglio), findsOneWidget, reason: pulsante);
      await tester.tap(find.text(chiudi ?? 'Chiudi').last);
      await tester.pumpAndSettle();
      expect(find.byType(BaFoglio), findsNothing, reason: pulsante);
    }

    for (final (testo, chiudi) in [
      ('Corta', 'Non ora'),
      ('Lunga', 'Non ora'),
      ('Corto', 'No, grazie'),
      ('Lungo', 'No, grazie'),
      ('Senza azioni nuove', null),
      ('Con azioni nuove', null),
      ('Con molte azioni', null),
      ('Non parla', null),
    ]) {
      await provaFoglio(testo, chiudi: chiudi);
    }

    // Testo 2,0 e 744: il foglio lungo scorre e non fa overflow.
    await _tocca(tester, 'Testo 1,0');
    await _tocca(tester, 'Larghezza 360');
    await provaFoglio('Lunga', chiudi: 'Non ora');
    await provaFoglio('Con molte azioni');

    // Il messaggio: uno solo, nessuno → neutro → errore.
    expect(find.byType(BaMessaggio), findsNothing);
    await _tocca(tester, 'Messaggio: nessuno');
    expect(find.byType(BaMessaggio), findsOneWidget);
    expect(find.text('!'), findsNothing);
    await _tocca(tester, 'Messaggio: neutro');
    expect(find.byType(BaMessaggio), findsOneWidget);
    expect(find.text('!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('con un foglio aperto le presenze della stanza vanno dietro (0,22, sfocate), alla chiusura tornano',
      (tester) async {
    _vistaAlta(tester);
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'BaPalco');
    await tester.pumpAndSettle(); // la riga dell'indicatore compare al secondo frame
    bool dietro() => tester.widget<BaPalco>(find.byType(BaPalco)).dietro;
    double opacita() => tester
        .widget<Opacity>(find.descendant(
          of: find.byType(BaPalco),
          matching: find.byWidgetPredicate((w) => w is Opacity && w.child is ImageFiltered),
        ))
        .opacity;
    expect(dietro(), isFalse);
    expect(opacita(), 1);
    Rect relativa() => tester.getRect(find.byType(BaPresenza).first).shift(-_stanza(tester).topLeft);
    final prima = relativa();

    // La scheda.
    final presenza = find.byType(BaPresenza).first;
    await tester.ensureVisible(presenza);
    await tester.tap(presenza);
    await tester.pumpAndSettle();
    expect(find.byType(BaSchedaPersona), findsOneWidget);
    expect(dietro(), isTrue);
    expect(opacita(), BaPresenzaTokens.dietroOpacita);
    expect(relativa(), prima, reason: 'la disposizione non cambia');
    await tester.tap(find.text('Chiudi'));
    await tester.pumpAndSettle();
    expect(dietro(), isFalse);
    expect(opacita(), 1);

    // «Altro».
    final altro = find.byKey(BaBarraAzioni.chiaveAltro);
    await tester.ensureVisible(altro);
    await tester.tap(altro);
    await tester.pumpAndSettle();
    expect(dietro(), isTrue);
    await tester.tap(find.text('Chiudi'));
    await tester.pumpAndSettle();
    expect(dietro(), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('la pagina «Accesso, creazione e coda»: i nove componenti, il codice si scrive, le scelte cambiano',
      (tester) async {
    _vistaAlta(tester);
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'Accesso, creazione e coda');

    // Tutti i componenti, nei loro stati.
    expect(find.byType(BaCampoTesto), findsNWidgets(5));
    expect(find.byType(BaCampoCodice), findsOneWidget);
    expect(find.byType(BaSceltaDen), findsOneWidget);
    expect(find.byType(BaChipScelta), findsNWidgets(7));
    expect(find.byType(BaPuntoAggancio), findsNWidgets(2));
    expect(find.byType(BaInterruttoreRiga), findsNWidgets(2));
    expect(find.byType(BaRigaCoda), findsNWidgets(2));
    expect(find.byType(BaFasciaAttesa), findsNWidgets(2));
    expect(find.byType(BaBandaPosto), findsNWidgets(3));
    expect(find.text('Lascia il gruppo'), findsOneWidget, reason: 'solo la prima fascia ha la capacità');

    // La banda: la stessa banda, 30 secondi e 5 minuti.
    expect(find.textContaining('ancora per un momento'), findsOneWidget);
    expect(find.textContaining('fino alle 21:45'), findsOneWidget);

    // Il codice si scrive davvero e chiama onCompleto.
    final campoCodice = find.descendant(of: find.byType(BaCampoCodice), matching: find.byType(EditableText));
    await tester.ensureVisible(campoCodice);
    await tester.enterText(campoCodice, '48a1-9');
    await tester.pump();
    expect(find.text('Completo: —'), findsOneWidget, reason: 'quattro cifre: non è completo');
    await tester.enterText(campoCodice, '481902');
    await tester.pump();
    expect(find.text('Completo: 481902'), findsOneWidget);

    // Gli stati del codice: sbagliato, scaduto, attesa.
    await _tocca(tester, 'Codice: scrittura');
    expect(find.text('Il codice non è giusto. Controlla l\'email e riprova.'), findsOneWidget);
    await _tocca(tester, 'Codice: sbagliato');
    expect(find.text('Il codice è scaduto. Te ne mandiamo uno nuovo.'), findsOneWidget);
    await _tocca(tester, 'Codice: scaduto');
    expect(find.text('Ne puoi chiedere un altro fra poco.'), findsOneWidget);
    await _tocca(tester, 'Codice: attesa');

    // La scelta cambia la frase sotto.
    expect(find.text('Inviti tu chi vuoi: gli altri non lo vedono.'), findsOneWidget);
    await _tocca(tester, 'Pubblico');
    expect(find.text('Chiunque può entrare nel pubblico e ascoltare.'), findsOneWidget);

    // Un interruttore cambia la parola.
    final accesi = find.text('ACCESO').evaluate().length;
    await _tocca(tester, 'Aspetta con altri');
    expect(find.text('ACCESO').evaluate().length, accesi + 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('la pagina «Accesso, creazione e coda» regge 744, il testo 2,0 e «riduci movimento»', (tester) async {
    _vistaAlta(tester);
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    await _tocca(tester, 'Accesso, creazione e coda');
    for (final c in ['Larghezza 360', 'Testo 1,0', 'Riduci movimento']) {
      await _tocca(tester, c);
      expect(tester.takeException(), isNull, reason: c);
    }
    // Con il testo grande anche gli stati del codice non fanno overflow.
    await _tocca(tester, 'Codice: scrittura');
    await _tocca(tester, 'Codice: sbagliato');
    expect(tester.takeException(), isNull);
  });

  group('la pagina «Fogli di contenuto»', () {
    Future<void> apri(WidgetTester tester) async {
      _vistaAlta(tester);
      await tester.pumpWidget(const GalleriaApp());
      await tester.pump();
      await _tocca(tester, 'Fogli di contenuto');
    }

    // Un foglio sale in 240 ms (con «riduci movimento» subito).
    Future<void> sale(WidgetTester tester) => tester.pump(const Duration(milliseconds: 300));

    testWidgets('il percorso a quattro passi: il foglio resta uno, il numero e il codice si scrivono', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Sali sul palco');
      await sale(tester);
      expect(find.text('Vuoi salire sul palco?'), findsOneWidget);
      expect(find.byType(BaFoglio), findsOneWidget);

      await _tocca(tester, 'Continua');
      expect(find.text('Il tuo numero'), findsOneWidget);
      expect(find.byType(BaFoglio), findsOneWidget, reason: 'sempre lo stesso foglio');

      // Senza numero non si va avanti: l'unica prova della galleria.
      await _tocca(tester, 'Ricevi il codice');
      expect(find.text('Scrivi il tuo numero di telefono.'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), '320 000 0000');
      await tester.pump();
      await _tocca(tester, 'Ricevi il codice');
      expect(find.text('Il codice'), findsOneWidget);

      await tester.enterText(find.descendant(of: find.byType(BaCampoCodice), matching: find.byType(EditableText)), '481902');
      await tester.pump();
      await _tocca(tester, 'Conferma');
      expect(find.text('Vuoi parlare?'), findsOneWidget);
      expect(find.text('Con il consenso il tuo account passa da ascoltatore a partecipante.'), findsOneWidget);
      expect(find.text('Salirai a microfono spento.'), findsOneWidget);

      // «Indietro (di prova)» torna al codice; «Non ora» chiude il foglio.
      await _tocca(tester, 'Indietro (di prova)');
      expect(find.text('Il codice'), findsOneWidget);
      await _tocca(tester, 'Non ora');
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(BaFoglio), findsNothing);
    });

    testWidgets('«Crea un DEN»: R1 al posto di P1 e R2 senza «Salirai a microfono spento»', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Crea un DEN');
      await sale(tester);
      expect(find.text('Per creare un DEN bisogna diventare partecipante'), findsOneWidget);
      await _tocca(tester, 'Continua');
      await tester.enterText(find.byType(EditableText), '320 000 0000');
      await tester.pump();
      await _tocca(tester, 'Ricevi il codice');
      await _tocca(tester, 'Conferma');
      expect(find.text('Acconsento e continuo'), findsOneWidget);
      expect(find.text('Salirai a microfono spento.'), findsNothing);
    });

    testWidgets('il codice nei suoi stati: scaduto senza «Mandalo di nuovo», attesa con la frase ferma', (tester) async {
      await apri(tester);
      Future<void> alCodice() async {
        await _tocca(tester, 'Sali sul palco');
        await sale(tester);
        await _tocca(tester, 'Continua');
        await tester.enterText(find.byType(EditableText), '320 000 0000');
        await tester.pump();
        await _tocca(tester, 'Ricevi il codice');
      }

      await _tocca(tester, 'Codice: scrittura');
      await _tocca(tester, 'Codice: sbagliato');
      await alCodice();
      expect(find.text('Il codice è scaduto. Te ne mandiamo uno nuovo.'), findsOneWidget);
      expect(find.text('Mandalo di nuovo'), findsNothing);
      expect(find.text('Manda un nuovo codice'), findsOneWidget);
      await _tocca(tester, 'Non ora');
      await tester.pump(const Duration(milliseconds: 300));

      await _tocca(tester, 'Codice: scaduto');
      await alCodice();
      expect(find.text('Ne puoi chiedere un altro fra poco.'), findsOneWidget);
      expect(find.text('Mandalo di nuovo'), findsOneWidget);
      expect(find.text('Conferma'), findsOneWidget);
    });

    testWidgets('la coda con e senza «Aspetta con altri»: la riga non lascia traccia', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Mettiti in coda');
      await sale(tester);
      expect(find.byType(BaInterruttoreRiga), findsOneWidget);
      await _tocca(tester, 'Non ora');
      await tester.pump(const Duration(milliseconds: 300));

      await _tocca(tester, 'Mettiti in coda, con «Aspetta con altri»');
      await sale(tester);
      expect(find.byType(BaInterruttoreRiga), findsNWidgets(2));
      await _tocca(tester, 'Fammi entrare automaticamente');
      expect(find.text('ACCESO'), findsOneWidget);
      await _tocca(tester, 'Non ora');
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('«Le tue code», «Coda piena» e «Vuoi passare di qua?»', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Le tue code');
      await sale(tester);
      expect(find.byType(BaRigaCoda), findsNWidgets(2));
      await _tocca(tester, 'Chiudi');
      await tester.pump(const Duration(milliseconds: 300));

      await _tocca(tester, 'Coda piena');
      await sale(tester);
      expect(find.text('La coda è piena adesso'), findsOneWidget);
      await _tocca(tester, 'Ho capito');
      await tester.pump(const Duration(milliseconds: 300));

      await _tocca(tester, 'Vuoi passare di qua?');
      await sale(tester);
      expect(find.text('Hai pochi secondi per decidere.'), findsOneWidget);
      await _tocca(tester, 'Resta qui');
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(BaFoglio), findsNothing);
    });

    testWidgets('regge 744, il testo 2,0 e «riduci movimento» in ogni contenuto', (tester) async {
      await apri(tester);
      for (final c in ['Larghezza 360', 'Testo 1,0', 'Riduci movimento']) {
        await _tocca(tester, c);
      }
      final aperture = <String, String>{
        'Sali sul palco': 'Non ora',
        'Crea un DEN': 'Non ora',
        'Mettiti in coda': 'Non ora',
        'Mettiti in coda, con «Aspetta con altri»': 'Non ora',
        'Aspetta con altri': 'Non ora',
        'Le tue code': 'Chiudi',
        'Coda piena': 'Ho capito',
        'Vuoi passare di qua?': 'Resta qui',
      };
      for (final MapEntry(key: apertura, value: chiusura) in aperture.entries) {
        await _tocca(tester, apertura);
        await tester.pump();
        expect(find.byType(BaFoglio), findsOneWidget, reason: apertura);
        expect(tester.takeException(), isNull, reason: apertura);
        await _tocca(tester, chiusura);
        await tester.pump();
        expect(find.byType(BaFoglio), findsNothing, reason: 'dopo «$chiusura»');
      }
    });
  });
}
