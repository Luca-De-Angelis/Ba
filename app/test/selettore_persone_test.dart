import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/foglio_passi.dart';
import 'package:ba/design_system/fogli_gestione.dart';
import 'package:ba/design_system/passi_creazione.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/ricerca_persone.dart';
import 'package:ba/design_system/riga_persona.dart';
import 'package:ba/design_system/selettore_persone.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

// Il selettore delle persone (task 033): lo stesso per gli invitati e per il co-amministratore.

void _vista(WidgetTester tester, {double larghezza = 360, double altezza = 800, double testo = 1.0}) {
  tester.view.physicalSize = Size(larghezza, altezza);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = testo;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

Widget _pagina(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery.fromView(
        view: WidgetsBinding.instance.platformDispatcher.views.first,
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Align(alignment: Alignment.topLeft, child: SingleChildScrollView(child: child)),
        ),
      ),
    );

Widget _app(Widget Function() foglio) => WidgetsApp(
      color: BaColorTokens.fondoApp,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: foglio(),
    );

BaAzioneFoglio _azione(String testo, {VoidCallback? onTap}) => BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: onTap);

BaRicercaPersone _ricerca(TextEditingController c) => BaRicercaPersone(controller: c, etichetta: 'Cerca', segnaposto: 'Nickname, alias, email o numero');

BaSelettorePersone _selettore(
  TextEditingController c, {
  required List<BaPersonaSelezionabile> persone,
  String scegli = 'Invita',
  String scelta = 'Nell\'invito',
  int? limite,
  String? frase,
  String? fraseLimite,
  String? intestazione = 'Persone che hai aggiunto',
}) =>
    BaSelettorePersone(
      ricerca: _ricerca(c),
      intestazione: intestazione,
      persone: persone,
      parolaScegli: scegli,
      parolaScelta: scelta,
      limite: limite,
      frase: frase,
      fraseLimite: fraseLimite,
    );

List<BaPersonaSelezionabile> _tre({Set<String> scelte = const {}, void Function(String)? onTap}) => [
      for (final (i, n) in ['Marta', 'Davide', 'Luca'].indexed)
        BaPersonaSelezionabile(nome: n, alias: '@${n.toLowerCase()}', tinta: i, sagoma: i, scelta: scelte.contains(n), onTap: () => onTap?.call(n)),
    ];

Iterable<BaRigaPersona> _righe(WidgetTester tester) => tester.widgetList<BaRigaPersona>(find.byType(BaRigaPersona));

void main() {
  group('nessuno scelto', () {
    testWidgets('le persone con la parola per scegliere, l\'intestazione e la frase', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      await tester.pumpWidget(_pagina(_selettore(c, persone: _tre(), frase: 'Nessuno nell\'invito. Puoi invitare anche dopo.')));
      expect(find.byType(BaRicercaPersone), findsOneWidget);
      expect(find.text('PERSONE CHE HAI AGGIUNTO'), findsOneWidget);
      expect(find.text('Invita'), findsNWidgets(3));
      expect(find.text('Nell\'invito'), findsNothing);
      expect(find.text('Nessuno nell\'invito. Puoi invitare anche dopo.'), findsOneWidget);
      expect(_righe(tester).every((r) => r.voce == BaVoceRigaPersona.scegli), isTrue);
    });

    test('haScelto è falso e il limite non c\'è', () {
      final s = _selettore(TextEditingController(), persone: _tre());
      expect(s.haScelto, isFalse);
      expect(s.scelti, 0);
      expect(s.limiteRaggiunto, isFalse);
    });
  });

  group('persone scelte', () {
    testWidgets('le scelte hanno la spunta e la parola, si tolgono toccandole; la frase le dice', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      String? toccata;
      await tester.pumpWidget(_pagina(_selettore(c, persone: _tre(scelte: {'Marta', 'Davide'}, onTap: (n) => toccata = n), frase: '2 persone nell\'invito.')));
      expect(find.text('Nell\'invito'), findsNWidgets(2));
      expect(find.text('Invita'), findsOneWidget);
      expect(find.text('2 persone nell\'invito.'), findsOneWidget);
      expect(tester.widget<Text>(find.text('2 persone nell\'invito.')).style?.color, BaColorTokens.testoPrimo, reason: 'a colore pieno quando c\'è chi è scelto');
      await tester.tap(find.text('Nell\'invito').first);
      expect(toccata, 'Marta');
    });

    test('haScelto e scelti seguono le persone scelte', () {
      final s = _selettore(TextEditingController(), persone: _tre(scelte: {'Luca'}));
      expect(s.haScelto, isTrue);
      expect(s.scelti, 1);
    });
  });

  group('limite raggiunto (il co-amministratore: uno)', () {
    testWidgets('le altre righe restano senza azione, la scelta si può togliere e la frase dice come uscirne', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      var toccate = <String>[];
      await tester.pumpWidget(_pagina(_selettore(
        c,
        scegli: 'Scegli',
        scelta: 'Scelto',
        limite: 1,
        persone: _tre(scelte: {'Davide'}, onTap: toccate.add),
        frase: 'Puoi averne uno.',
        fraseLimite: 'Hai raggiunto il limite di co-amministratori. Per sceglierne un altro, togli Davide.',
        intestazione: null,
      )));
      expect(find.text('Hai raggiunto il limite di co-amministratori. Per sceglierne un altro, togli Davide.'), findsOneWidget);
      expect(find.text('Puoi averne uno.'), findsNothing, reason: 'la frase del limite sostituisce l\'altra');
      final scegli = _righe(tester).where((r) => r.voce == BaVoceRigaPersona.scegli).toList();
      expect(scegli, hasLength(2));
      expect(scegli.every((r) => r.onAzione == null), isTrue, reason: 'al limite non si sceglie più');
      await tester.tap(find.text('Scelto'));
      expect(toccate, ['Davide'], reason: 'la scelta si toglie');
    });

    testWidgets('sotto il limite le righe si scelgono ancora', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      await tester.pumpWidget(_pagina(_selettore(c, limite: 1, persone: _tre(), scegli: 'Scegli', fraseLimite: 'limite')));
      expect(_righe(tester).every((r) => r.onAzione != null), isTrue);
      expect(find.text('limite'), findsNothing);
    });

    test('il limite è un numero dato dal chiamante: nessun parametro di livello', () {
      final s = BaSelettorePersone(
        ricerca: BaRicercaPersone(controller: _ctrlFinto, etichetta: 'x'),
        persone: [],
        parolaScegli: 'a',
        parolaScelta: 'b',
        limite: 3,
      );
      expect(s.limite, 3);
    });
  });

  group('uno solo per gli invitati e per il co-amministratore', () {
    testWidgets('lo stesso widget con altre parole', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      await tester.pumpWidget(_pagina(_selettore(c, persone: _tre())));
      expect(find.byType(BaSelettorePersone), findsOneWidget);
      expect(find.text('Invita'), findsNWidgets(3));
      await tester.pumpWidget(_pagina(_selettore(c, persone: _tre(), scegli: 'Scegli', scelta: 'Scelto', limite: 1)));
      expect(find.byType(BaSelettorePersone), findsOneWidget);
      expect(find.text('Scegli'), findsNWidgets(3));
      expect(find.text('Invita'), findsNothing);
    });

    testWidgets('è il posto degli invitati in BaPassiCreazione.invitati, senza cambiarne l\'API, e l\'azione resta attiva', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      var continua = 0;
      await tester.pumpWidget(_app(() => BaFoglioPassi(
            nome: 'Crea un DEN',
            passo: BaPassiCreazione.invitati(
              titolo: 'Chi inviti?',
              frase: 'Un DEN privato si apre solo a chi inviti.',
              posto: _selettore(c, persone: _tre()),
              azione: _azione('Continua', onTap: () => continua++),
            ),
            nonOra: _azione('Non ora', onTap: () {}),
          )));
      await tester.pump();
      expect(find.byType(BaSelettorePersone), findsOneWidget);
      expect(find.text('Chi inviti?'), findsOneWidget);
      expect(tester.widget<BaPillola>(find.widgetWithText(BaPillola, 'Continua')).onTap, isNotNull, reason: 'si può invitare anche dopo');
      await tester.tap(find.text('Continua'));
      expect(continua, 1);
    });

    testWidgets('è il posto dei co-amministratori in BaFoglioGestisci: l\'azione in fondo è inattiva finché non si sceglie', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      var scelti = <String>{};
      var aggiunti = 0;
      await tester.pumpWidget(_app(() => StatefulBuilder(
            builder: (context, setState) {
              final selettore = _selettore(
                c,
                scegli: 'Scegli',
                scelta: 'Scelto',
                limite: 1,
                intestazione: null,
                persone: _tre(
                  scelte: scelti,
                  onTap: (n) => setState(() => scelti.contains(n) ? scelti.remove(n) : scelti = {n}),
                ),
              );
              return BaFoglioGestisci.coAmministratori(
                nome: 'Gestisci il DEN',
                titolo: 'Co-amministratori',
                frase: 'Puoi averne uno. Sceglilo fra le persone che hai aggiunto.',
                posto: selettore,
                // L'azione in fondo è del foglio: inattiva finché non si sceglie.
                aggiungi: _azione('Aggiungi un co-amministratore', onTap: selettore.haScelto ? () => aggiunti++ : null),
                nonOra: _azione('Chiudi', onTap: () {}),
              );
            },
          )));
      await tester.pump();
      BaPillola aggiungi() => tester.widget<BaPillola>(find.widgetWithText(BaPillola, 'Aggiungi un co-amministratore'));
      expect(aggiungi().onTap, isNull, reason: 'nessuno scelto: inattiva');
      await tester.ensureVisible(find.text('Scegli').first);
      await tester.tap(find.text('Scegli').first);
      await tester.pump();
      expect(aggiungi().onTap, isNotNull, reason: 'scelto uno: attiva');
      await tester.tap(find.text('Aggiungi un co-amministratore'));
      expect(aggiunti, 1);
      await tester.ensureVisible(find.text('Scelto'));
      await tester.tap(find.text('Scelto'));
      await tester.pump();
      expect(aggiungi().onTap, isNull, reason: 'tolto: di nuovo inattiva');
    });
  });

  group('la ricerca dentro il selettore', () {
    testWidgets('la lista la filtra il chiamante con corrisponde: «sar» trova le due Sara, l\'alias le distingue', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      const tutte = [
        (nome: 'Sara', alias: '@sara.m'),
        (nome: 'Sara', alias: '@sara.rossi'),
        (nome: 'Marta', alias: '@marta.v'),
      ];
      await tester.pumpWidget(_pagina(StatefulBuilder(
        builder: (context, setState) => BaSelettorePersone(
          ricerca: BaRicercaPersone(controller: c, etichetta: 'Cerca', onRicerca: (_) => setState(() {})),
          persone: [
            for (final p in tutte)
              if (BaRicercaPersone.corrisponde(c.text, nickname: p.nome, alias: p.alias)) BaPersonaSelezionabile(nome: p.nome, alias: p.alias),
          ],
          parolaScegli: 'Invita',
          parolaScelta: 'Nell\'invito',
        ),
      )));
      expect(_righe(tester), hasLength(3));
      await tester.enterText(find.byType(EditableText), 'sar');
      await tester.pump();
      expect(_righe(tester), hasLength(2));
      expect(find.text('@sara.m'), findsOneWidget);
      expect(find.text('@sara.rossi'), findsOneWidget);
    });
  });

  group('testo grande, larghezze e tocco', () {
    for (final (larghezza, altezza) in [(360.0, 800.0), (744.0, 1133.0)]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp nulla si taglia né sborda e ogni tocco è ≥ 44', (tester) async {
        _vista(tester, larghezza: larghezza, altezza: altezza, testo: BaScalaTokens.maxTesto);
        final c = TextEditingController();
        addTearDown(c.dispose);
        await tester.pumpWidget(_pagina(_selettore(
          c,
          persone: _tre(scelte: {'Marta'}, onTap: (_) {}),
          frase: '1 persona nell\'invito.',
          limite: 1,
          fraseLimite: 'Hai raggiunto il limite. Per invitare un\'altra persona, togli Marta.',
        )));
        expect(tester.takeException(), isNull);
        final r = tester.getRect(find.byType(BaSelettorePersone));
        for (final t in tester.widgetList<Text>(find.descendant(of: find.byType(BaSelettorePersone), matching: find.byType(Text)))) {
          expect(tester.getRect(find.byWidget(t)).right, lessThanOrEqualTo(r.right), reason: t.data);
        }
        for (final t in tester.widgetList<BaTouchable>(find.descendant(of: find.byType(BaSelettorePersone), matching: find.byType(BaTouchable)))) {
          expect(tester.getSize(find.byWidget(t)).height, greaterThanOrEqualTo(BaControlloTokens.areaMinima));
        }
      });
    }
  });
}

final TextEditingController _ctrlFinto = TextEditingController();
