import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/scheda_persona.dart';
import 'package:ba/design_system/tokens.dart';
import 'package:ba/design_system/touchable.dart';

Widget _app(Widget child, {double testo = 1.0, double larghezza = 360}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(larghezza, 800), textScaler: TextScaler.linear(testo)),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: larghezza, child: child),
        ),
      ),
    );

BaSchedaPersona _scheda({
  bool parla = true,
  List<BaAzioneScheda> nuove = const [],
  VoidCallback? onMuta,
  VoidCallback? onBlocca,
  VoidCallback? onSegnala,
}) =>
    BaSchedaPersona(
      nome: 'Anna',
      stato: 'Mic spento',
      parla: parla,
      mutaTesto: 'Muta questa voce',
      mutaNonDisponibile: 'Si può mutare solo mentre parla',
      bloccaTesto: 'Blocca',
      segnalaTesto: 'Segnala',
      onMuta: onMuta ?? () {},
      onBlocca: onBlocca ?? () {},
      onSegnala: onSegnala ?? () {},
      nuove: nuove,
    );

List<BaAzioneScheda> _nuove(int n) => [
      for (var i = 1; i <= n; i++)
        BaAzioneScheda(titolo: 'Azione nuova $i', spiegazione: i == 1 ? 'Una conseguenza scritta' : null, onTap: () {}),
    ];

double _y(WidgetTester tester, String testo) => tester.getTopLeft(find.text(testo)).dy;

void main() {
  testWidgets('in alto nome e stato, poi le tre fisse nell\'ordine: muta, blocca, segnala', (tester) async {
    await tester.pumpWidget(_app(_scheda()));
    expect(BaSchedaPersonaTokens.fisse, 3);
    final nome = _y(tester, 'Anna');
    final stato = _y(tester, 'MIC SPENTO');
    final muta = _y(tester, 'Muta questa voce');
    final blocca = _y(tester, 'Blocca');
    final segnala = _y(tester, 'Segnala');
    expect(stato, closeTo(nome, 12), reason: 'nome e stato nella stessa riga');
    expect(nome, lessThan(muta));
    expect(muta, lessThan(blocca));
    expect(blocca, lessThan(segnala));
    // Le fisse sono tre righe, e a riposo non ce ne sono altre.
    expect(find.byType(BaRigaAzione), findsNWidgets(3));
  });

  testWidgets('«Muta questa voce» è attiva se la persona parla, senza spiegazione', (tester) async {
    var mute = 0;
    await tester.pumpWidget(_app(_scheda(parla: true, onMuta: () => mute++)));
    expect(find.text('Si può mutare solo mentre parla'), findsNothing);
    await tester.tap(find.text('Muta questa voce'));
    expect(mute, 1);
  });

  testWidgets('«Muta questa voce» è inattiva se non parla, e lo dice', (tester) async {
    var mute = 0;
    await tester.pumpWidget(_app(_scheda(parla: false, onMuta: () => mute++)));
    expect(find.text('Si può mutare solo mentre parla'), findsOneWidget);
    await tester.tap(find.text('Muta questa voce'), warnIfMissed: false);
    expect(mute, 0);
    final righe = tester.widgetList<BaRigaAzione>(find.byType(BaRigaAzione)).toList();
    expect(righe.first.onTap, isNull);
    expect(righe[1].onTap, isNotNull);
    final titolo = tester.widget<Text>(find.text('Muta questa voce'));
    expect(titolo.style!.color, BaColorTokens.testoInattivo);
  });

  testWidgets('blocca e segnala chiamano le loro callback', (tester) async {
    var blocca = 0, segnala = 0;
    await tester.pumpWidget(_app(_scheda(onBlocca: () => blocca++, onSegnala: () => segnala++)));
    await tester.tap(find.text('Blocca'));
    await tester.tap(find.text('Segnala'));
    expect((blocca, segnala), (1, 1));
  });

  testWidgets('le azioni nuove vengono dopo le fisse, una riga ciascuna, nell\'ordine passato', (tester) async {
    await tester.pumpWidget(_app(_scheda(nuove: _nuove(3))));
    expect(find.byType(BaRigaAzione), findsNWidgets(6));
    final segnala = _y(tester, 'Segnala');
    final n1 = _y(tester, 'Azione nuova 1');
    final n2 = _y(tester, 'Azione nuova 2');
    final n3 = _y(tester, 'Azione nuova 3');
    expect(segnala, lessThan(n1));
    expect(n1, lessThan(n2));
    expect(n2, lessThan(n3));
    expect(find.text('Una conseguenza scritta'), findsOneWidget);
  });

  testWidgets('le azioni nuove chiamano la loro callback', (tester) async {
    var chiamate = 0;
    await tester.pumpWidget(_app(_scheda(nuove: [
      BaAzioneScheda(titolo: 'Azione nuova 1', onTap: () => chiamate++),
    ])));
    await tester.tap(find.text('Azione nuova 1'));
    expect(chiamate, 1);
  });

  for (final testo in [1.0, 2.0]) {
    testWidgets('ogni riga ha un\'area ≥ areaMinima (testo $testo)', (tester) async {
      await tester.pumpWidget(_app(SingleChildScrollView(child: _scheda(parla: false, nuove: _nuove(2))), testo: testo));
      final righe = find.byType(BaTouchable);
      expect(righe, findsNWidgets(5), reason: 'anche la riga inattiva (muta) è un BaTouchable, ma non focalizzabile');
      for (var i = 0; i < 5; i++) {
        final r = tester.getRect(find.byType(BaRigaAzione).at(i));
        expect(r.height, greaterThanOrEqualTo(BaControlloTokens.areaMinima), reason: 'riga $i');
        expect(r.width, 360);
      }
    });
  }

  testWidgets('le fisse sono alte almeno rigaFissa, le nuove almeno rigaMinima', (tester) async {
    await tester.pumpWidget(_app(_scheda(nuove: _nuove(1))));
    for (var i = 0; i < 3; i++) {
      expect(tester.getSize(find.byType(BaRigaAzione).at(i)).height, greaterThanOrEqualTo(BaSchedaPersonaTokens.rigaFissa));
    }
    expect(tester.getSize(find.byType(BaRigaAzione).at(3)).height, greaterThanOrEqualTo(BaSchedaPersonaTokens.rigaMinima));
  });

  testWidgets('a testo 2,0 nessun overflow e nessun testo tagliato', (tester) async {
    await tester.pumpWidget(_app(SingleChildScrollView(child: _scheda(parla: false, nuove: _nuove(3))), testo: 2.0));
    expect(tester.takeException(), isNull);
    // Ogni testo sta dentro la sua riga.
    for (final testo in ['Muta questa voce', 'Si può mutare solo mentre parla', 'Blocca', 'Segnala', 'Azione nuova 1']) {
      final t = tester.getRect(find.text(testo));
      final riga = tester.getRect(find.ancestor(of: find.text(testo), matching: find.byType(BaRigaAzione)).first);
      expect(riga.contains(t.topLeft) && riga.contains(t.bottomRight - const Offset(0.01, 0.01)), isTrue, reason: testo);
    }
  });

  testWidgets('semantica: ogni riga è un bottone con titolo e spiegazione', (tester) async {
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(_app(_scheda(parla: false)));
    expect(
      tester.getSemantics(find.byType(BaRigaAzione).first),
      matchesSemantics(
        label: 'Muta questa voce. Si può mutare solo mentre parla',
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
      ),
    );
    semantica.dispose();
  });
}
