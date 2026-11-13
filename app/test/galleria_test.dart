import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/azioni_in_coppia.dart';
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

    // Testo di sistema 2,0 e altezza della stanza 980 → 930 → 880 → 830: il
    // palco cede in modo continuo, nessuna presenza sparisce.
    await _tocca(tester, 'Testo 1,0');
    final diametri = [diametro()];
    for (final altezza in [980, 930, 880]) {
      await _tocca(tester, 'Altezza: $altezza');
      diametri.add(diametro());
      expect(find.byType(BaPresenza), findsNWidgets(8), reason: 'altezza $altezza');
    }
    for (var i = 1; i < diametri.length; i++) {
      expect(diametri[i], lessThanOrEqualTo(diametri[i - 1]), reason: 'non cresce mai');
    }
    expect(diametri.last, lessThan(88), reason: 'a 830 dp il palco è sceso sotto 88');
    expect(diametri.last, greaterThanOrEqualTo(BaPresenzaTokens.minimo));
    expect(diametri.toSet().length, 4, reason: 'scende per gradi, non di colpo');

    // La riga di debug sta nel flusso, sopra il palco, e va a capo: non esce dal
    // bordo e non copre le presenze.
    await tester.pump();
    _controllaStanza(tester);
    await _tocca(tester, 'Altezza: 830'); // torna a 980
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
    for (final altezza in [980, 930, 880]) {
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
}
