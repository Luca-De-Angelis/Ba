import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/alone.dart';
import 'package:ba/design_system/azioni_in_coppia.dart';
import 'package:ba/design_system/banda_posto.dart';
import 'package:ba/design_system/campo_codice.dart';
import 'package:ba/design_system/campo_testo.dart';
import 'package:ba/design_system/chip_scelta.dart';
import 'package:ba/design_system/fascia_attesa.dart';
import 'package:ba/design_system/interruttore_riga.dart';
import 'package:ba/design_system/punto_aggancio.dart';
import 'package:ba/design_system/riga_coda.dart';
import 'package:ba/design_system/ricerca_persone.dart';
import 'package:ba/design_system/riga_consenso.dart';
import 'package:ba/design_system/selettore_persone.dart';
import 'package:ba/design_system/intestazione.dart';
import 'package:ba/design_system/riga_bloccata.dart';
import 'package:ba/design_system/riga_den.dart';
import 'package:ba/design_system/riga_stato.dart';
import 'package:ba/design_system/schermata_copertura.dart';
import 'package:ba/design_system/riga_persona.dart';
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
    // Il menu della galleria va a capo su più righe: con una vista bassa la presenza
    // finirebbe sotto il bordo.
    _vistaAlta(tester);
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

  group('la pagina «Fogli di creazione e gestione»', () {
    Future<void> apri(WidgetTester tester) async {
      _vistaAlta(tester);
      await tester.pumpWidget(const GalleriaApp());
      await tester.pump();
      await _tocca(tester, 'Fogli di creazione e gestione');
    }

    Future<void> sale(WidgetTester tester) => tester.pump(const Duration(milliseconds: 300));

    Future<void> chiudiFoglio(WidgetTester tester, String azione) async {
      await _tocca(tester, azione);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(BaFoglio), findsNothing, reason: 'dopo «$azione»');
    }

    /// Dal tipo al riepilogo, scrivendo davvero i campi.
    Future<void> alRiepilogo(WidgetTester tester, {required bool privato}) async {
      await _tocca(tester, 'Crea un DEN');
      await sale(tester);
      expect(find.text('Che DEN vuoi creare?'), findsOneWidget);
      if (!privato) await _tocca(tester, 'Pubblico');
      await _tocca(tester, 'Continua');
      expect(find.text('Come si chiama?'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'Cena senza fretta');
      await tester.pump();
      await _tocca(tester, 'Continua');
      expect(find.text('Descrizione, tema e lingua'), findsOneWidget);
      await _tocca(tester, 'Cucina');
      await _tocca(tester, 'Continua');
      if (privato) {
        expect(find.text('Chi inviti?'), findsOneWidget);
        await _tocca(tester, 'Continua');
      }
      expect(find.text('Tutto pronto?'), findsOneWidget);
    }

    testWidgets('«Crea un DEN» privato: cinque passi in un foglio solo, i campi si scrivono, il riepilogo li ripete', (tester) async {
      await apri(tester);
      await alRiepilogo(tester, privato: true);
      expect(find.byType(BaFoglio), findsOneWidget, reason: 'sempre lo stesso foglio');
      expect(find.text('Cena senza fretta'), findsOneWidget);
      expect(find.text('Cucina'), findsOneWidget);
      expect(find.text('Privato'), findsOneWidget);
      expect(find.text('Invitati'), findsOneWidget);
      expect(find.text('Salirai a microfono spento.'), findsOneWidget);
      await chiudiFoglio(tester, 'Crea il DEN');
    });

    testWidgets('«Crea un DEN» pubblico: niente passo «Invitati» e niente riga nel riepilogo; il tipo non dice «senza amministratore»', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Crea un DEN');
      await sale(tester);
      await _tocca(tester, 'Pubblico');
      expect(find.text('Lo gestisci tu, con i co-amministratori che scegli.'), findsOneWidget);
      expect(find.textContaining('senza amministratore', findRichText: true), findsNothing);
      await _tocca(tester, 'Non ora');
      await tester.pump(const Duration(milliseconds: 300));

      await alRiepilogo(tester, privato: false);
      expect(find.text('Pubblico'), findsOneWidget);
      expect(find.text('Invitati'), findsNothing);
      expect(find.text('Chi inviti?'), findsNothing);
    });

    testWidgets('il nome: vuoto mostra l\'errore e non va avanti; «Quando» è spento e non si tocca', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Crea un DEN');
      await sale(tester);
      await _tocca(tester, 'Continua');
      expect(find.byType(BaPuntoAggancio), findsOneWidget);
      await _tocca(tester, 'Continua');
      expect(find.text('Scrivi un nome per il DEN.'), findsOneWidget);
      expect(find.text('Come si chiama?'), findsOneWidget);
      // «Quando» non è un controllo: toccarlo non fa niente.
      await tester.tap(find.text('Adesso'), warnIfMissed: false);
      await tester.pump();
      expect(find.byType(EditableText), findsOneWidget);
      // Scrivere toglie l'errore.
      await tester.enterText(find.byType(EditableText), 'Cena');
      await tester.pump();
      expect(find.text('Scrivi un nome per il DEN.'), findsNothing);
    });

    testWidgets('con «Nome: già usato» l\'errore c\'è una volta, poi si va avanti', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Nome: libero');
      await _tocca(tester, 'Crea un DEN');
      await sale(tester);
      await _tocca(tester, 'Continua');
      await tester.enterText(find.byType(EditableText), 'Cena senza fretta');
      await tester.pump();
      await _tocca(tester, 'Continua');
      expect(find.text("C'è già un DEN con questo nome. Cambialo o aggiungi una parola."), findsOneWidget);
      await _tocca(tester, 'Continua');
      expect(find.text('Descrizione, tema e lingua'), findsOneWidget);
    });

    testWidgets('«Indietro (di prova)» torna al passo prima e quello che era scritto resta', (tester) async {
      await apri(tester);
      await alRiepilogo(tester, privato: true);
      await _tocca(tester, 'Indietro (di prova)');
      expect(find.text('Chi inviti?'), findsOneWidget);
      await _tocca(tester, 'Indietro (di prova)');
      expect(find.text('Descrizione, tema e lingua'), findsOneWidget);
      await _tocca(tester, 'Indietro (di prova)');
      expect(tester.widget<EditableText>(find.byType(EditableText)).controller.text, 'Cena senza fretta');
    });

    testWidgets('con «Creazione: non riesce» l\'errore è annunciato e «Riprova» riporta al riepilogo con i dati', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Creazione: riesce');
      await alRiepilogo(tester, privato: true);
      await _tocca(tester, 'Crea il DEN');
      expect(find.text('Il DEN non è stato creato'), findsOneWidget);
      expect(find.text('Non siamo riusciti ad aprirlo. Controlla la connessione e riprova.'), findsOneWidget);
      expect(find.text('Quello che hai scritto è ancora qui.'), findsOneWidget);
      expect(find.byType(BaFoglio), findsOneWidget);
      await _tocca(tester, 'Riprova');
      expect(find.text('Tutto pronto?'), findsOneWidget);
      expect(find.text('Cena senza fretta'), findsOneWidget);
    });

    testWidgets('il sotto-DEN: il nome non è vuoto, la regola e la nota, e «Crea il sotto-DEN» chiude', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Nuovo sotto-DEN');
      await sale(tester);
      expect(find.text('Fino a 8 persone. Sente il DEN e parla al proprio gruppo.'), findsOneWidget);
      expect(find.text('Chi ne fa parte lo scegli dopo, dalla stanza.'), findsOneWidget);
      await _tocca(tester, 'Crea il sotto-DEN');
      expect(find.text('Scrivi un nome per il sotto-DEN.'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'Tavolo 2');
      await tester.pump();
      await chiudiFoglio(tester, 'Crea il sotto-DEN');
    });

    testWidgets('«Gestisci» con un posto libero: il menu mostra «0 di 1», le viste si aprono e si chiudono', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Gestisci, con un posto libero');
      await sale(tester);
      expect(find.text('0 di 1'), findsOneWidget);
      expect(find.byType(BaFoglio), findsOneWidget);

      await _tocca(tester, 'Descrizione');
      expect(find.byType(BaCampoTesto), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'Una nuova descrizione');
      await tester.pump();
      await _tocca(tester, 'Salva');
      expect(find.text('Una nuova descrizione'), findsOneWidget, reason: 'il menu mostra la descrizione salvata');

      await _tocca(tester, 'Co-amministratori');
      expect(find.byType(BaPuntoAggancio), findsOneWidget);
      await _tocca(tester, 'Aggiungi un co-amministratore');
      expect(find.text('Hai raggiunto il limite di co-amministratori. Per aggiungerne un altro, togli Marta.'), findsOneWidget);
      expect(find.byType(BaFoglio), findsOneWidget, reason: 'le viste sono lo stesso foglio');
      await _tocca(tester, 'Chiudi');
      expect(find.text('1 di 1'), findsOneWidget);
      await chiudiFoglio(tester, 'Chiudi');
    });

    testWidgets('«Gestisci» al limite: «Togli» libera il posto; chi è co-amministratore non ha «Rimuovi»', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Gestisci, al limite');
      await sale(tester);
      expect(find.text('1 di 1'), findsOneWidget);

      await _tocca(tester, 'Persone nel DEN');
      expect(find.byType(BaRigaPersona), findsNWidgets(4));
      expect(find.text('Rimuovi'), findsNWidgets(3));
      expect(find.text('co-amministratore'), findsOneWidget);
      await _tocca(tester, 'Chiudi');

      await _tocca(tester, 'Co-amministratori');
      expect(find.text('Togli'), findsOneWidget);
      await _tocca(tester, 'Togli');
      expect(find.byType(BaPuntoAggancio), findsOneWidget, reason: 'tolto il co-amministratore il posto è libero');
      await _tocca(tester, 'Chiudi');
      expect(find.text('0 di 1'), findsOneWidget);
      await chiudiFoglio(tester, 'Chiudi');
    });

    testWidgets('rimozione e termine hanno una conferma; la rimozione toglie la persona', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Gestisci, con un posto libero');
      await sale(tester);
      await _tocca(tester, 'Persone nel DEN');
      await tester.tap(find.text('Rimuovi').first);
      await tester.pump();
      expect(find.text('Rimuovere Marta?'), findsOneWidget, reason: 'il primo «Rimuovi» è quello di Marta');
      await _tocca(tester, 'Non ora');
      expect(find.byType(BaRigaPersona), findsNWidgets(4), reason: '«Non ora» non toglie nessuno');
      await tester.tap(find.text('Rimuovi').first);
      await tester.pump();
      await _tocca(tester, 'Rimuovi');
      expect(find.byType(BaRigaPersona), findsNWidgets(3));
      expect(find.text('Marta'), findsNothing);
      await _tocca(tester, 'Chiudi');

      await _tocca(tester, 'Termina il DEN');
      expect(find.text('Terminare il DEN?'), findsOneWidget);
      expect(find.text('Tutte le persone escono dalla stanza.'), findsWidgets);
      await _tocca(tester, 'Non ora');
      expect(find.text('Gestisci il DEN'), findsWidgets);
      await _tocca(tester, 'Termina il DEN');
      await chiudiFoglio(tester, 'Termina il DEN');
    });

    testWidgets('regge 744, il testo 2,0 e «riduci movimento» in ogni contenuto', (tester) async {
      await apri(tester);
      for (final c in ['Larghezza 360', 'Testo 1,0', 'Riduci movimento']) {
        await _tocca(tester, c);
      }
      final aperture = <String, String>{
        'Crea un DEN': 'Non ora',
        'Nuovo sotto-DEN': 'Non ora',
        'Gestisci, con un posto libero': 'Chiudi',
        'Gestisci, al limite': 'Chiudi',
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
      // Anche i passi più alti (dettagli con i chip, riepilogo, errore) a 2,0 e a 744.
      await _tocca(tester, 'Creazione: riesce');
      await _tocca(tester, 'Crea un DEN');
      await tester.pump();
      for (final azione in ['Continua', 'Continua', 'Continua', 'Continua', 'Crea il DEN']) {
        if (azione == 'Continua' && find.text('Come si chiama?').evaluate().isNotEmpty) {
          await tester.enterText(find.byType(EditableText), 'Cena senza fretta');
          await tester.pump();
        }
        await _tocca(tester, azione);
        expect(tester.takeException(), isNull);
      }
      expect(find.text('Il DEN non è stato creato'), findsOneWidget);
    });
  });

  group('la pagina «Stanza ed elenco»', () {
    Future<void> apri(WidgetTester tester) async {
      _vistaAlta(tester);
      await tester.pumpWidget(const GalleriaApp());
      await tester.pump();
      await _tocca(tester, 'Stanza ed elenco');
    }

    testWidgets('l\'intestazione nei cinque stati, la riga di stato, l\'alone e le righe dell\'elenco', (tester) async {
      await apri(tester);
      expect(find.byType(BaIntestazione), findsNWidgets(5));
      expect(find.text('LINEA PERSA'), findsOneWidget);
      expect(find.byType(BaRigaStato), findsNWidgets(4));
      expect(find.byType(BaAlone), findsNWidgets(2));
      expect(find.byType(BaRigaDen), findsNWidgets(4));
      expect(find.text('Vuoto. Puoi restare e ti avviso.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('le impostazioni: la conseguenza scritta, lo stato negato con la via d\'uscita, l\'interruttore che cambia', (tester) async {
      await apri(tester);
      expect(find.text('Non potrai più parlare. Se stai parlando, esci dalla stanza.'), findsOneWidget);
      expect(find.text('Negate — senza queste non posso avvisarti'), findsOneWidget);
      expect(find.text('Apri'), findsNWidgets(2));
      final spenti = find.text('SPENTO').evaluate().length;
      await _tocca(tester, 'Avvisami se si libera');
      expect(find.text('ACCESO'), findsOneWidget);
      expect(find.text('SPENTO').evaluate().length, spenti - 1);
    });

    testWidgets('le persone bloccate: «Sblocca» passa a «Sblocco…», inattivo, e la riga sbloccata sparisce', (tester) async {
      await apri(tester);
      expect(find.byType(BaRigaBloccata), findsNWidgets(2));
      await tester.ensureVisible(find.text('Sblocca').first);
      await tester.pump();
      await tester.tap(find.text('Sblocca').first);
      await tester.pump();
      expect(find.text('Sblocco…'), findsOneWidget);
      expect(tester.widget<BaPillola>(find.widgetWithText(BaPillola, 'Sblocco…')).onTap, isNull);
      await _tocca(tester, 'Dario V.: sbloccoInCorso');
      expect(find.text('Dario V.'), findsNothing, reason: 'sbloccata: esce dall\'elenco');
      expect(find.byType(BaRigaBloccata), findsNWidgets(2), reason: 'il widget resta, non disegna niente');
      expect(find.byType(BaPillola).evaluate().where((e) => (e.widget as BaPillola).testo == 'Sblocca').length, 1);
    });

    testWidgets('l\'account chiuso copre tutta la schermata: B1, B1 bis e B2, con una sola azione', (tester) async {
      await apri(tester);
      expect(find.byType(BaSchermataCopertura), findsNothing);
      await _tocca(tester, 'Account chiuso: nessuno');
      expect(find.byType(BaSchermataCopertura), findsOneWidget);
      expect(find.text('Questo account non può più usare BA'), findsOneWidget);
      expect(find.text('Richiedi revisione'), findsOneWidget);
      await _tocca(tester, 'Richiedi revisione');
      expect(find.text('Richiesta inviata'), findsOneWidget);
      expect(tester.widget<BaPillola>(find.widgetWithText(BaPillola, 'Richiesta inviata')).onTap, isNull);

      await _tocca(tester, 'Account chiuso: B1');
      expect(find.text("L'accesso a BA è sospeso"), findsOneWidget);
      expect(find.text('Potrai rientrare il 21 novembre alle 21:40.'), findsOneWidget);
      expect(find.text('Richiedi revisione'), findsOneWidget, reason: 'B1 bis riparte da «Richiedi revisione»');

      await _tocca(tester, 'Account chiuso: B1 bis');
      expect(find.text('Richiesta inviata'), findsOneWidget, reason: 'B2 è lo stato dopo il tocco');
      expect(find.text('Questo account non può più usare BA'), findsOneWidget);

      await _tocca(tester, 'Account chiuso: B2');
      expect(find.byType(BaSchermataCopertura), findsNothing);
    });

    testWidgets('regge 744, il testo 2,0 e «riduci movimento», anche con l\'account chiuso', (tester) async {
      await apri(tester);
      for (final c in ['Larghezza 360', 'Testo 1,0', 'Riduci movimento']) {
        await _tocca(tester, c);
        expect(tester.takeException(), isNull, reason: c);
      }
      for (final c in ['Account chiuso: nessuno', 'Account chiuso: B1', 'Account chiuso: B1 bis', 'Account chiuso: B2']) {
        await _tocca(tester, c);
        expect(tester.takeException(), isNull, reason: c);
      }
    });
  });

  group('la pagina «Persone e inviti»', () {
    Future<void> apri(WidgetTester tester) async {
      _vistaAlta(tester);
      await tester.pumpWidget(const GalleriaApp());
      await tester.pump();
      await _tocca(tester, 'Persone e inviti');
    }

    Future<void> sale(WidgetTester tester) => tester.pump(const Duration(milliseconds: 300));

    testWidgets('la ricerca nei suoi stati: vuota, due Sara con l\'alias, nessun risultato, errore di rete', (tester) async {
      await apri(tester);
      expect(find.byType(BaRicercaPersone), findsNWidgets(7), reason: 'quattro campi e tre selettori');
      expect(find.text('@sara.m'), findsWidgets);
      expect(find.text('@sara.rossi'), findsWidgets);
      expect(find.text('Due persone si chiamano Sara: l\'alias le distingue.'), findsOneWidget);
      expect(find.text('Nessuna persona trovata per «xyzq».'), findsOneWidget);
      expect(find.text('Invita con un link'), findsOneWidget);
      expect(find.text('Non riusciamo a cercare adesso. Controlla la connessione e riprova.'), findsOneWidget);
      expect(find.text('Riprova'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('le righe nei loro stati: «Aggiungi» passa ad «Aggiunta» e non si ritocca', (tester) async {
      await apri(tester);
      final prima = find.text('Aggiungi').evaluate().length;
      await tester.ensureVisible(find.text('Aggiungi').first);
      await tester.pump();
      await tester.tap(find.text('Aggiungi').first);
      await tester.pump();
      expect(find.text('Aggiungi').evaluate().length, prima - 1);
      expect(find.text('Aggiunta'), findsWidgets);
      expect(find.text('Nell\'invito'), findsWidgets);
      expect(find.text('Scegli'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('il richiamo parte spento e si accende solo dopo la conferma', (tester) async {
      await apri(tester);
      expect(find.byType(BaRigaConsenso), findsNWidgets(3));
      final spenti = find.text('SPENTO').evaluate().length;
      expect(spenti, greaterThanOrEqualTo(2));
      await tester.ensureVisible(find.text('Marta').last);
      await tester.pump();
      await tester.tap(find.byType(BaRigaConsenso).first);
      await tester.pump();
      await sale(tester);
      expect(find.text('Avvisare Marta?'), findsOneWidget);
      expect(find.text('SPENTO').evaluate().length, spenti, reason: 'non è ancora acceso: c\'è la conferma');
      await _tocca(tester, 'Non ora');
      await sale(tester);
      expect(find.text('SPENTO').evaluate().length, spenti, reason: '«Non ora» lascia spento');

      await tester.tap(find.byType(BaRigaConsenso).first);
      await tester.pump();
      await sale(tester);
      await _tocca(tester, 'Avvisa Marta');
      await sale(tester);
      expect(find.text('SPENTO').evaluate().length, spenti - 1, reason: 'confermato: acceso');
    });

    testWidgets('il posto riempito: «Invita» ha il selettore e l\'azione sempre attiva', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Invita: il posto riempito');
      await sale(tester);
      expect(find.text('Chi inviti?'), findsOneWidget);
      expect(find.byType(BaSelettorePersone), findsWidgets);
      expect(find.byType(BaPuntoAggancio), findsNothing, reason: 'il posto è riempito dal selettore');
      await _tocca(tester, 'Continua');
      await sale(tester);
      expect(find.byType(BaFoglio), findsNothing);
    });

    testWidgets('il posto riempito: il co-amministratore ha l\'azione inattiva finché non si sceglie', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Co-amministratore: il posto riempito');
      await sale(tester);
      BaPillola aggiungi() => tester.widget<BaPillola>(find.widgetWithText(BaPillola, 'Aggiungi un co-amministratore'));
      expect(aggiungi().onTap, isNull);
      final scegli = find.descendant(of: find.byType(BaFoglio), matching: find.text('Scegli')).first;
      await tester.ensureVisible(scegli);
      await tester.pump();
      await tester.tap(scegli);
      await tester.pump();
      expect(aggiungi().onTap, isNotNull);
      expect(find.descendant(of: find.byType(BaFoglio), matching: find.textContaining('Hai raggiunto il limite')), findsOneWidget);
      await _tocca(tester, 'Aggiungi un co-amministratore');
      await sale(tester);
      expect(find.byType(BaFoglio), findsNothing);
    });

    testWidgets('«Sei stato invitato», scaduto e annullato', (tester) async {
      await apri(tester);
      await _tocca(tester, 'Sei stato invitato');
      await sale(tester);
      expect(find.text('Marta ti ha invitato a Cena senza fretta'), findsOneWidget);
      expect(find.text('Entra'), findsOneWidget);
      await _tocca(tester, 'Non ora');
      await sale(tester);

      await _tocca(tester, 'Invito scaduto');
      await sale(tester);
      expect(find.text('Questo invito è scaduto'), findsOneWidget);
      expect(find.descendant(of: find.byType(BaFoglio), matching: find.byType(BaPillola)), findsOneWidget);
      await _tocca(tester, 'Ho capito');
      await sale(tester);

      await _tocca(tester, 'Invito annullato');
      await sale(tester);
      expect(find.text('Questo invito non è più valido'), findsOneWidget);
      await _tocca(tester, 'Ho capito');
      await sale(tester);
      expect(find.byType(BaFoglio), findsNothing);
    });

    testWidgets('regge 744, il testo 2,0 e «riduci movimento» in ogni foglio', (tester) async {
      await apri(tester);
      for (final c in ['Larghezza 360', 'Testo 1,0', 'Riduci movimento']) {
        await _tocca(tester, c);
        expect(tester.takeException(), isNull, reason: c);
      }
      final aperture = <String, String>{
        'Invita: il posto riempito': 'Non ora',
        'Co-amministratore: il posto riempito': 'Chiudi',
        'Sei stato invitato': 'Non ora',
        'Invito scaduto': 'Ho capito',
        'Invito annullato': 'Ho capito',
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
