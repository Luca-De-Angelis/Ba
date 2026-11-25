import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/barra_azioni.dart';
import 'package:ba/design_system/campo_codice.dart';
import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/pillola.dart';
import 'package:ba/prototipo/cornice.dart';
import 'package:ba/prototipo/navigatore.dart';
import 'package:ba/prototipo/stato.dart';

// Gli aiuti comuni dei test del prototipo (task 024c): una sola copia, invece di una per file.

void vista(
  WidgetTester tester, {
  double larghezza = 1500,
  double altezza = 1000,
}) {
  tester.view.physicalSize = Size(larghezza, altezza);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Lo stato finto del prototipo in esecuzione.
StatoProto statoDi(WidgetTester tester) =>
    ProtoScope.leggi(tester.element(find.byType(ProtoNavigatore)));

/// Costruisce il prototipo. Se c'è già (più scenari nello stesso test) riparte dal login con
/// «Torna all'inizio»: lo stato è nuovo, la costruzione dell'app no. Le impostazioni dello **strumento**
/// (testo, larghezza) restano: chi le cambia non unisce i suoi scenari.
Future<StatoProto> avvia(
  WidgetTester tester, {
  double larghezza = 1500,
  double altezza = 1000,
}) async {
  vista(tester, larghezza: larghezza, altezza: altezza);
  if (find.byType(PrototipoApp).evaluate().isNotEmpty) {
    final torna = find.text("Torna all'inizio").first;
    await tester.ensureVisible(torna);
    await tester.tap(torna, warnIfMissed: false);
    await tester.pump();
  } else {
    await tester.pumpWidget(const PrototipoApp());
    await tester.pump();
  }
  return statoDi(tester);
}

/// Uno scenario di un test riunito: se un controllo cade, il messaggio dice quale passo.
Future<void> passo(String nome, Future<void> Function() corpo) async {
  try {
    await corpo();
  } on TestFailure catch (e) {
    throw TestFailure('passo «$nome»: ${e.message}');
  }
}

/// Dall'elenco, con l'accesso già fatto (l'accesso lo prova `prototipo_test.dart`).
Future<StatoProto> dentro(
  WidgetTester tester, {
  bool partecipante = true,
  double larghezza = 1500,
  double altezza = 1000,
}) async {
  final stato = await avvia(tester, larghezza: larghezza, altezza: altezza);
  stato.finisciAccesso('Sara');
  if (partecipante) stato.diventaPartecipante();
  await tester.pump();
  return stato;
}

/// Un tocco, con un fotogramma dopo.
Future<void> tocca(WidgetTester tester, String testo) async {
  final f = find.text(testo).first;
  await tester.ensureVisible(f);
  await tester.tap(f, warnIfMissed: false);
  await tester.pump();
}

/// Un tocco dentro il foglio aperto (la pagina sotto può avere lo stesso testo; se il titolo e
/// un'azione hanno lo stesso testo, vince l'azione).
Future<void> nelFoglio(WidgetTester tester, String testo) async {
  final pillola = find.descendant(
    of: find.byType(BaFoglio),
    matching: find.widgetWithText(BaPillola, testo),
  );
  final f = pillola.evaluate().isNotEmpty
      ? pillola.first
      : find
            .descendant(of: find.byType(BaFoglio), matching: find.text(testo))
            .first;
  await tester.ensureVisible(f);
  await tester.tap(f, warnIfMissed: false);
  await tester.pump();
}

Finder inFoglio(String testo) =>
    find.descendant(of: find.byType(BaFoglio), matching: find.text(testo));

/// Un foglio sale in 240 ms.
Future<void> sale(WidgetTester tester) =>
    tester.pump(const Duration(milliseconds: 300));

Future<void> altro(WidgetTester tester) async {
  await tester.tap(find.byKey(BaBarraAzioni.chiaveAltro));
  await tester.pump();
  await sale(tester);
}

BaPillola pillolaDi(WidgetTester tester, String testo) =>
    tester.widget<BaPillola>(find.widgetWithText(BaPillola, testo).first);

Finder campoCodice() => find.descendant(
  of: find.byType(BaCampoCodice),
  matching: find.byType(EditableText),
);

/// Scrive nel primo campo di testo della pagina.
Future<void> scriviNellaPagina(WidgetTester tester, String testo) async {
  await tester.enterText(find.byType(EditableText).first, testo);
  await tester.pump();
}

/// L'accesso intero: email, codice, «Ho capito», «Accetto», nickname, «Continua».
Future<void> accedi(WidgetTester tester, {String nickname = 'Sara'}) async {
  await scriviNellaPagina(tester, 'sara.m@example.it');
  await tocca(tester, 'Ricevi il codice');
  await tester.enterText(campoCodice(), '123456');
  await tester.pump();
  await tocca(tester, 'Conferma');
  await tocca(tester, 'Ho capito');
  await tocca(tester, 'Accetto');
  await scriviNellaPagina(tester, nickname);
  await tocca(tester, 'Continua');
}
