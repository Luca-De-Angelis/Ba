import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/campo_testo.dart';
import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/foglio_passi.dart';
import 'package:ba/design_system/fogli_gestione.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/design_system/punto_aggancio.dart';
import 'package:ba/design_system/riga_persona.dart';
import 'package:ba/design_system/riga_valore.dart';
import 'package:ba/design_system/tokens.dart';

// «Gestisci» (G1–G5) e il foglio del sotto-DEN (D1), task 023b.

void _vista(WidgetTester tester, {double larghezza = 360, double altezza = 800, double testo = 1.0}) {
  tester.view.physicalSize = Size(larghezza, altezza);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = testo;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

BaAzioneFoglio _azione(String testo, {VoidCallback? onTap, BaVariantePillola? variante}) =>
    BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: onTap ?? () {}, variante: variante);

Widget _app(Widget foglio) => WidgetsApp(
      color: BaColorTokens.fondoApp,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: foglio,
    );

Future<void> _mostra(WidgetTester tester, Widget foglio) async {
  await tester.pumpWidget(_app(foglio));
  await tester.pump();
}

BaPillola _pillola(WidgetTester tester, String testo) =>
    tester.widget<BaPillola>(find.widgetWithText(BaPillola, testo));

Finder _foglio() => find.byWidgetPredicate((w) =>
    w is DecoratedBox &&
    w.decoration is BoxDecoration &&
    (w.decoration as BoxDecoration).color == BaColorTokens.superficieFoglio);

const _nome = 'Gestisci il DEN';

BaFoglioGestisci _menu({String limite = '0 di 1', VoidCallback? onCoAmm}) => BaFoglioGestisci.menu(
      nome: _nome,
      titolo: 'Gestisci il DEN',
      descrizione: BaRigaValore(etichetta: 'Descrizione', sottotitolo: 'Due chiacchiere dopo cena.', onTap: () {}),
      coAmministratori: BaRigaValore(
        etichetta: 'Co-amministratori',
        sottotitolo: 'Chi ti aiuta a gestire il DEN',
        valore: limite,
        onTap: onCoAmm ?? () {},
      ),
      persone: BaRigaValore(etichetta: 'Persone nel DEN', sottotitolo: 'Rimuovi chi non deve restare', onTap: () {}),
      termina: BaRigaValore(etichetta: 'Termina il DEN', sottotitolo: 'Tutte le persone escono dalla stanza.', onTap: () {}),
      nonOra: _azione('Chiudi'),
    );

BaRigaPersona _persona(String nome, String stato, {String? azione, VoidCallback? onAzione, int i = 0}) =>
    BaRigaPersona(nome: nome, stato: stato, tinta: i, sagoma: i, azione: azione, onAzione: onAzione);

BaFoglioGestisci _coAmmLibero({List<BaRigaPersona> persone = const [], VoidCallback? onAggiungi}) =>
    BaFoglioGestisci.coAmministratori(
      nome: _nome,
      titolo: 'Co-amministratori',
      frase: 'Un co-amministratore gestisce il DEN con te. Puoi averne uno.',
      persone: persone,
      posto: const BaPuntoAggancio(titolo: 'Qui: le persone fra cui scegliere', sottotitolo: 'punto di aggancio'),
      aggiungi: _azione('Aggiungi un co-amministratore', onTap: onAggiungi),
      nonOra: _azione('Chiudi'),
    );

BaFoglioGestisci _coAmmLimite() => BaFoglioGestisci.coAmministratoriAlLimite(
      nome: _nome,
      titolo: 'Co-amministratori',
      persone: [_persona('Davide', 'co-amministratore', azione: 'Togli', onAzione: () {}, i: 1)],
      fraseLimite: 'Hai raggiunto il limite di co-amministratori. Per aggiungerne un altro, togli Davide.',
      aggiungi: 'Aggiungi un co-amministratore',
      nonOra: _azione('Chiudi'),
    );

BaFoglioGestisci _persone() => BaFoglioGestisci.persone(
      nome: _nome,
      titolo: 'Persone nel DEN',
      persone: [
        _persona('Marta', 'sul palco', azione: 'Rimuovi', onAzione: () {}),
        _persona('Davide', 'co-amministratore', i: 1),
        _persona('Sara', 'nel pubblico', azione: 'Rimuovi', onAzione: () {}, i: 2),
        _persona('Luca', 'nel pubblico', azione: 'Rimuovi', onAzione: () {}, i: 3),
      ],
      nonOra: _azione('Chiudi'),
    );

BaFoglioGestisci _conferma({
  Object id = 'rimuovi-marta',
  String titolo = 'Rimuovere Marta?',
  String frase = 'Marta esce dal DEN.',
  String azione = 'Rimuovi',
  BaVariantePillola? variante,
  VoidCallback? onTap,
}) =>
    BaFoglioGestisci.conferma(
      nome: _nome,
      id: id,
      titolo: titolo,
      frase: frase,
      azione: _azione(azione, variante: variante, onTap: onTap),
      nonOra: _azione('Non ora'),
    );

BaFoglioGestisci _descrizione(TextEditingController c) => BaFoglioGestisci.descrizione(
      nome: _nome,
      titolo: 'Descrizione',
      controller: c,
      etichetta: 'Descrizione',
      maxRighe: 6,
      salva: _azione('Salva'),
      nonOra: _azione('Non ora'),
    );

List<String?> _tuttiITesti(WidgetTester tester) => tester.widgetList<Text>(find.byType(Text)).map((t) => t.data).toList();

void main() {
  group('menu (G1)', () {
    testWidgets('le quattro voci nell\'ordine del prototipo e solo «Chiudi» in fondo, senza primaria', (tester) async {
      _vista(tester);
      await _mostra(tester, _menu());
      final voci = [for (final r in tester.widgetList<BaRigaValore>(find.byType(BaRigaValore))) r.etichetta];
      expect(voci, ['Descrizione', 'Co-amministratori', 'Persone nel DEN', 'Termina il DEN']);
      final pillole = tester.widgetList<BaPillola>(find.byType(BaPillola)).toList();
      expect(pillole.map((p) => p.testo), ['Chiudi']);
      expect(pillole.single.variante, BaVariantePillola.spenta);
    });

    testWidgets('mostra il limite come il numero che gli si dà, mai il livello', (tester) async {
      _vista(tester);
      await _mostra(tester, _menu(limite: '0 di 3'));
      expect(find.text('0 di 3'), findsOneWidget);
      final tutto = _tuttiITesti(tester).join(' ');
      for (final parola in ['Free', 'Pro', 'livello', 'piano', 'abbonamento']) {
        expect(tutto, isNot(contains(parola)), reason: 'il limite si mostra, il livello mai');
      }
    });

    testWidgets('ogni voce è toccabile e chiama la sua callback', (tester) async {
      _vista(tester);
      var coamm = 0;
      await _mostra(tester, _menu(onCoAmm: () => coamm++));
      await tester.tap(find.byType(BaRigaValore).at(1));
      expect(coamm, 1);
    });
  });

  group('descrizione (G5)', () {
    testWidgets('il campo scrive nel controller, «Salva» è chiara e «Non ora» c\'è', (tester) async {
      _vista(tester);
      final c = TextEditingController(text: 'Due chiacchiere.');
      addTearDown(c.dispose);
      await _mostra(tester, _descrizione(c));
      final campo = tester.widget<BaCampoTesto>(find.byType(BaCampoTesto));
      expect(campo.minRighe, 3);
      expect(campo.maxRighe, 6);
      await tester.enterText(find.byType(EditableText), 'Una nuova descrizione');
      await tester.pump();
      expect(c.text, 'Una nuova descrizione');
      expect(_pillola(tester, 'Salva').variante, BaVariantePillola.chiara);
      expect(find.widgetWithText(BaPillola, 'Non ora'), findsOneWidget);
    });
  });

  group('co-amministratori (G2)', () {
    testWidgets('con un posto libero: la frase, il posto e «Aggiungi» attiva e toccabile', (tester) async {
      _vista(tester);
      var aggiunte = 0;
      await _mostra(tester, _coAmmLibero(onAggiungi: () => aggiunte++));
      expect(find.text('Un co-amministratore gestisce il DEN con te. Puoi averne uno.'), findsOneWidget);
      expect(find.byType(BaPuntoAggancio), findsOneWidget);
      expect(_pillola(tester, 'Aggiungi un co-amministratore').variante, BaVariantePillola.attiva);
      await tester.tap(find.text('Aggiungi un co-amministratore'));
      expect(aggiunte, 1);
    });

    testWidgets('il posto si può non dare: nessuna traccia', (tester) async {
      _vista(tester);
      await _mostra(
        tester,
        BaFoglioGestisci.coAmministratori(
          nome: _nome,
          titolo: 'Co-amministratori',
          frase: 'Un co-amministratore gestisce il DEN con te.',
          aggiungi: _azione('Aggiungi un co-amministratore'),
          nonOra: _azione('Chiudi'),
        ),
      );
      expect(find.byType(BaPuntoAggancio), findsNothing);
      expect(find.byType(BaRigaPersona), findsNothing);
    });

    testWidgets('al limite: il co-amministratore con «Togli», la frase e l\'azione inattiva', (tester) async {
      _vista(tester);
      await _mostra(tester, _coAmmLimite());
      expect(find.text('Davide'), findsOneWidget);
      expect(find.text('Togli'), findsOneWidget);
      expect(find.text('Hai raggiunto il limite di co-amministratori. Per aggiungerne un altro, togli Davide.'), findsOneWidget);
      expect(find.byType(BaPuntoAggancio), findsNothing);
      final aggiungi = _pillola(tester, 'Aggiungi un co-amministratore');
      expect(aggiungi.onTap, isNull, reason: 'al limite l\'azione è inattiva');
      await tester.tap(find.text('Aggiungi un co-amministratore'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('persone (G3)', () {
    testWidgets('una riga per persona e «Rimuovi» solo dove si dà: il co-amministratore non ce l\'ha', (tester) async {
      _vista(tester);
      await _mostra(tester, _persone());
      expect(find.byType(BaRigaPersona), findsNWidgets(4));
      expect(find.text('Rimuovi'), findsNWidgets(3));
      final davide = find.ancestor(of: find.text('Davide'), matching: find.byType(BaRigaPersona));
      expect(find.descendant(of: davide, matching: find.text('Rimuovi')), findsNothing);
      expect(find.descendant(of: davide, matching: find.text('co-amministratore')), findsOneWidget);
    });
  });

  group('conferme (G3 bis, G4)', () {
    testWidgets('la conseguenza in una frase; l\'azione è ATTIVA (a filetto), non chiara; «Non ora» c\'è', (tester) async {
      _vista(tester);
      await _mostra(tester, _conferma());
      expect(find.text('Rimuovere Marta?'), findsOneWidget);
      expect(find.text('Marta esce dal DEN.'), findsOneWidget);
      expect(_pillola(tester, 'Rimuovi').variante, BaVariantePillola.attiva,
          reason: 'è distruttiva e «Non ora» c\'è sempre: la chiara solo dove l\'app non prosegue senza il gesto (BaRegole 1)');
      expect(_pillola(tester, 'Non ora').variante, BaVariantePillola.spenta);

      await _mostra(
        tester,
        _conferma(id: 'termina', titolo: 'Terminare il DEN?', frase: 'Tutte le persone escono dalla stanza.', azione: 'Termina il DEN'),
      );
      expect(find.text('Terminare il DEN?'), findsOneWidget);
      expect(_pillola(tester, 'Termina il DEN').variante, BaVariantePillola.attiva);
    });

    testWidgets('il chiamante può scegliere un\'altra variante', (tester) async {
      _vista(tester);
      await _mostra(tester, _conferma(variante: BaVariantePillola.chiara));
      expect(_pillola(tester, 'Rimuovi').variante, BaVariantePillola.chiara);
    });

    testWidgets('«Rimuovi» e «Termina il DEN» chiamano la loro callback', (tester) async {
      _vista(tester);
      var fatti = 0;
      await _mostra(tester, _conferma(onTap: () => fatti++));
      await tester.tap(find.text('Rimuovi'));
      expect(fatti, 1);
    });
  });

  group('«Non ora» in ogni vista, comprese le conferme di rimozione e di termine', () {
    final viste = <String, Widget Function()>{
      'menu': _menu,
      'descrizione': () => _descrizione(TextEditingController()),
      'co-amministratori (posto libero)': _coAmmLibero,
      'co-amministratori (al limite)': _coAmmLimite,
      'persone': _persone,
      'conferma di rimozione': _conferma,
      'conferma di termine': () => _conferma(id: 'termina', titolo: 'Terminare il DEN?', frase: 'Tutte le persone escono dalla stanza.', azione: 'Termina il DEN'),
    };
    for (final MapEntry(key: nome, value: vista) in viste.entries) {
      testWidgets('$nome: l\'ultima azione è quella di chiusura e chiude', (tester) async {
        _vista(tester);
        await _mostra(tester, vista());
        final pillole = tester.widgetList<BaPillola>(find.byType(BaPillola)).toList();
        expect(pillole.last.testo, anyOf('Chiudi', 'Non ora'));
        expect(pillole.last.variante, BaVariantePillola.spenta);
        expect(pillole.last.onTap, isNotNull);
      });
    }
  });

  group('il cambio di vista', () {
    testWidgets('il foglio resta lo stesso: il focus va al titolo della vista nuova, anche tornando indietro', (tester) async {
      _vista(tester);
      final vista = ValueNotifier<int>(0);
      addTearDown(vista.dispose);
      final viste = [_menu(), _persone(), _conferma()];
      await _mostra(tester, ValueListenableBuilder<int>(valueListenable: vista, builder: (_, i, _) => viste[i]));
      expect(find.byType(BaFoglioPassi), findsOneWidget);
      final stato = tester.state(find.byType(BaFoglioPassi));

      vista.value = 1;
      await tester.pump();
      await tester.pump();
      expect(tester.state(find.byType(BaFoglioPassi)), same(stato), reason: 'lo stesso foglio: il tipo non cambia fra le viste');
      expect(Focus.of(tester.element(find.text('Persone nel DEN').first)).hasPrimaryFocus, isTrue);
      expect(find.text('Descrizione'), findsNothing);

      vista.value = 2;
      await tester.pump();
      await tester.pump();
      expect(Focus.of(tester.element(find.text('Rimuovere Marta?'))).hasPrimaryFocus, isTrue);

      vista.value = 0;
      await tester.pump();
      await tester.pump();
      expect(Focus.of(tester.element(find.text('Gestisci il DEN').first)).hasPrimaryFocus, isTrue);
    });

    testWidgets('due conferme con id diversi sono due viste; con lo stesso id no', (tester) async {
      _vista(tester);
      expect(_conferma(id: 'a').passo.id, isNot(_conferma(id: 'b').passo.id));
      expect(_coAmmLibero().passo.id, _coAmmLimite().passo.id,
          reason: 'è la stessa vista: togliere una persona non è un cambio di vista');
    });
  });

  group('testo grande e larghezze', () {
    for (final (larghezza, altezza) in [(360.0, 800.0), (744.0, 1133.0)]) {
      testWidgets('a 2,0 su ${larghezza.round()} dp: il menu e le persone scorrono, nulla sborda e le azioni restano ancorate', (tester) async {
        _vista(tester, larghezza: larghezza, altezza: altezza, testo: BaScalaTokens.maxTesto);
        for (final foglio in [_menu(), _persone(), _coAmmLimite(), _conferma()]) {
          await _mostra(tester, foglio);
          expect(tester.takeException(), isNull);
          final tetto = altezza * (larghezza >= 600 ? BaAccessoTokens.foglioAltezzaTablet : BaAccessoTokens.foglioAltezzaTelefono);
          expect(tester.getSize(_foglio()).height, lessThanOrEqualTo(tetto + 0.01));
          final ultima = tester.widgetList<BaPillola>(find.byType(BaPillola)).last;
          expect(tester.getRect(find.byWidget(ultima)).bottom, lessThanOrEqualTo(altezza));
        }
      });
    }
  });

  group('il sotto-DEN (D1)', () {
    BaFoglioSottoDen sotto({TextEditingController? c, String? errore, VoidCallback? onCrea}) => BaFoglioSottoDen(
          titolo: 'Nuovo sotto-DEN',
          controller: c ?? TextEditingController(),
          etichetta: 'Nome del sotto-DEN',
          errore: errore,
          frase: 'Fino a 8 persone. Sente il DEN e parla al proprio gruppo.',
          nota: 'Chi ne fa parte lo scegli dopo, dalla stanza.',
          crea: _azione('Crea il sotto-DEN', onTap: onCrea),
          nonOra: _azione('Non ora'),
        );

    testWidgets('il nome, la regola, la nota, «Crea il sotto-DEN» chiara e «Non ora» spenta', (tester) async {
      _vista(tester);
      await _mostra(tester, sotto());
      expect(find.text('Nuovo sotto-DEN'), findsOneWidget);
      expect(find.byType(BaCampoTesto), findsOneWidget);
      expect(find.text('Fino a 8 persone. Sente il DEN e parla al proprio gruppo.'), findsOneWidget);
      expect(find.text('Chi ne fa parte lo scegli dopo, dalla stanza.'), findsOneWidget);
      expect(_pillola(tester, 'Crea il sotto-DEN').variante, BaVariantePillola.chiara);
      expect(tester.widgetList<BaPillola>(find.byType(BaPillola)).last.testo, 'Non ora');
    });

    testWidgets('scrive nel controller, non valida e non sceglie i membri', (tester) async {
      _vista(tester);
      final c = TextEditingController();
      addTearDown(c.dispose);
      var crea = 0;
      await _mostra(tester, sotto(c: c, onCrea: () => crea++));
      await tester.tap(find.text('Crea il sotto-DEN'));
      expect(crea, 1, reason: 'a nome vuoto il componente non blocca niente');
      await tester.enterText(find.byType(EditableText), 'Tavolo 2');
      await tester.pump();
      expect(c.text, 'Tavolo 2');
      expect(find.byType(BaRigaPersona), findsNothing, reason: 'i membri si scelgono dopo, dalla stanza');
    });

    testWidgets('mostra l\'errore che gli si dà', (tester) async {
      _vista(tester);
      await _mostra(tester, sotto(errore: 'Scrivi un nome per il sotto-DEN.'));
      expect(find.text('Scrivi un nome per il sotto-DEN.'), findsOneWidget);
      expect(find.text('!'), findsOneWidget);
    });

    testWidgets('a 2,0 scorre e le azioni restano ancorate', (tester) async {
      _vista(tester, testo: BaScalaTokens.maxTesto);
      await _mostra(tester, sotto());
      expect(tester.takeException(), isNull);
      expect(tester.getSize(_foglio()).height, lessThanOrEqualTo(800 * BaAccessoTokens.foglioAltezzaTelefono + 0.01));
      expect(tester.getRect(find.widgetWithText(BaPillola, 'Non ora')).bottom, lessThanOrEqualTo(800));
    });
  });
}
