import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/tokens.dart';
import 'package:ba/prototipo/stato.dart';
import 'package:ba/prototipo/testi.dart';

import 'prototipo_aiuti.dart';

// I titoli (task 036): 28 solo per ciò che sostituisce tutto e non è un flusso (l'account chiuso e la
// pagina d'arrivo fuori dall'app); 22 per i flussi e le impostazioni, comprese le pagine del 030.

double _taglia(WidgetTester tester, String testo) => tester.widget<Text>(find.text(testo).first).style!.fontSize!;

void main() {
  testWidgets('le pagine del 030 e le impostazioni hanno il titolo a 22; l\'account chiuso e la pagina d\'arrivo a 28', (tester) async {
    final stato = await dentro(tester);
    final stanza = BaTestoTokens.stanza.fontSize!;
    expect(stanza, 22);

    // passo: persone, rubrica, «Chi può trovarmi», richiamo: tutte a 22
    for (final (pagina, titolo) in [
      (Pagina.aggiungiPersone, T.aggiungiPersone),
      (Pagina.rubrica, T.rubricaNonCollegata),
      (Pagina.chiPuoTrovarmi, T.chiPuoTrovarmi),
      (Pagina.chiPuoiAvvisare, T.chiPuoiAvvisare),
      (Pagina.chiPuoAvvisarti, T.chiPuoAvvisarti),
    ]) {
      stato.vai(Rotta(pagina));
      await tester.pump();
      expect(find.text(titolo), findsWidgets, reason: 'passo: $titolo');
      expect(_taglia(tester, titolo), stanza, reason: 'passo: «$titolo» è un titolo di flusso: 22');
      stato.indietro();
      await tester.pump();
    }

    // passo: le impostazioni a 22
    stato.vai(const Rotta(Pagina.impostazioni));
    await tester.pump();
    expect(_taglia(tester, T.impostazioniTitolo), stanza, reason: 'passo: impostazioni');
    stato.indietro();
    await tester.pump();

    // passo: l'account chiuso (sostituisce tutto) a 28
    stato.chiudiAccount(Chiusura.chiuso);
    await tester.pump();
    expect(_taglia(tester, T.chiusoTitolo), BaTestoTokens.titoloSchermata.fontSize, reason: 'passo: account chiuso');
    expect(BaTestoTokens.titoloSchermata.fontSize, 28);
  });

  testWidgets('la pagina d\'arrivo fuori dall\'app, per chi non ha BA, ha il titolo a 28', (tester) async {
    final stato = await dentro(tester);
    stato.arrivaInvitoSenzaBa();
    await tester.pump();
    final titolo = T.invitoTitolo('Marta', 'Cena senza fretta');
    expect(_taglia(tester, titolo), 28, reason: 'passo: la mail');
    stato.vaiAllaPagina();
    await tester.pump();
    expect(_taglia(tester, titolo), 28, reason: 'passo: la pagina d\'arrivo');
  });
}
