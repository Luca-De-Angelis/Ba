import 'package:flutter_test/flutter_test.dart';

import 'package:ba/prototipo/stato.dart';

import 'prototipo_aiuti.dart';

// Il prototipo navigabile con le persone (task 024c): aggiungere persone, la rubrica, «Chi può
// trovarmi», il richiamo, gli inviti con e senza BA. Gli scenari riuniti in un solo test hanno un
// commento «passo: …» e un messaggio nell'expect che dice quale passo è fallito.

void main() {
  group('aggiungere persone (030 P1–P6)', () {
    testWidgets('la ricerca filtra davvero; le due Sara; nessun risultato; aggiunta privata; errore di rete', (tester) async {
      final stato = await dentro(tester);
      // passo: l'ingresso è una riga nell'elenco, con i suggeriti
      await tocca(tester, 'Aggiungi persone');
      expect(find.text('CHI HAI FREQUENTATO DI PIÙ'), findsOneWidget, reason: 'passo: suggeriti');
      expect(find.text('Aggiungi'), findsNWidgets(3), reason: 'passo: suggeriti');

      // passo: due Sara, distinte dall'alias
      await scriviNellaPagina(tester, 'sar');
      expect(find.text('2 RISULTATI'), findsOneWidget, reason: 'passo: due Sara');
      expect(find.text('@sara.m'), findsOneWidget, reason: 'passo: alias');
      expect(find.text('@sara.rossi'), findsOneWidget, reason: 'passo: alias');
      expect(find.text('Due persone si chiamano Sara: l\'alias le distingue.'), findsOneWidget, reason: 'passo: alias');

      // passo: filtra per numero, e sotto i due caratteri non filtra
      await scriviNellaPagina(tester, '0002');
      expect(find.text('1 RISULTATO'), findsOneWidget, reason: 'passo: numero');
      expect(find.text('Davide'), findsOneWidget, reason: 'passo: numero');
      await scriviNellaPagina(tester, 's');
      expect(find.text('CHI HAI FREQUENTATO DI PIÙ'), findsOneWidget, reason: 'passo: sotto i due caratteri tornano i suggeriti');

      // passo: nessun risultato
      await scriviNellaPagina(tester, 'xyzq');
      expect(find.text('Nessuna persona trovata per «xyzq».'), findsOneWidget, reason: 'passo: nessun risultato');
      await tocca(tester, 'Invita con un link');
      await sale(tester);
      expect(inFoglio('Invita con un link'), findsOneWidget, reason: 'passo: il link');
      await nelFoglio(tester, 'Ho capito');
      await sale(tester);

      // passo: l'aggiunta è privata e non produce nessun avviso
      await scriviNellaPagina(tester, '');
      await tocca(tester, 'Aggiungi');
      expect(find.text('Aggiunta'), findsOneWidget, reason: 'passo: aggiunta');
      expect(stato.aggiunte, ['marta'], reason: 'passo: aggiunta');
      expect(stato.banner, isNull, reason: 'passo: nessun avviso');

      // passo: errore di rete provocato dal pannello, «Riprova» riesce
      await tocca(tester, 'la ricerca non riesce');
      await scriviNellaPagina(tester, 'sar');
      expect(find.text('Non riusciamo a cercare adesso. Controlla la connessione e riprova.'), findsOneWidget, reason: 'passo: errore di rete');
      await tocca(tester, 'Riprova');
      expect(find.text('2 RISULTATI'), findsOneWidget, reason: 'passo: «Riprova» riesce');
    });

    testWidgets('la rubrica: il rifiuto è senza colpa (R2); con il permesso «Su BA» e «Non ancora su BA» (R3)', (tester) async {
      final stato = await dentro(tester);
      await tocca(tester, 'Aggiungi persone');
      // passo: il foglio del permesso, il rifiuto
      await tocca(tester, 'Dalla rubrica');
      await sale(tester);
      expect(inFoglio('Trovare chi conosci'), findsOneWidget, reason: 'passo: R1');
      await nelFoglio(tester, 'Non ora');
      await sale(tester);
      expect(find.text('Rubrica non collegata'), findsOneWidget, reason: 'passo: R2');
      expect(find.text('Cerca una persona'), findsOneWidget, reason: 'passo: R2: nessun invito a ripensarci');
      await tocca(tester, 'Cerca una persona');
      // passo: dopo il rifiuto non si richiede
      await tocca(tester, 'Dalla rubrica');
      expect(find.text('Rubrica non collegata'), findsOneWidget, reason: 'passo: già rifiutato, nessun nuovo foglio');
      await tocca(tester, 'Cerca una persona');

      // passo: con il permesso
      stato.impostaPermessoRubrica(PermessoRubrica.nonChiesto);
      await tocca(tester, 'Dalla rubrica');
      await sale(tester);
      await nelFoglio(tester, 'Consenti l\'accesso');
      await sale(tester);
      expect(find.text('Su BA'.toUpperCase()), findsOneWidget, reason: 'passo: R3');
      expect(find.text('Non ancora su BA'.toUpperCase()), findsOneWidget, reason: 'passo: R3');
      expect(find.text('Giulia'), findsOneWidget, reason: 'passo: R3');
      expect(find.text('Invita'), findsOneWidget, reason: 'passo: R3');
    });
  });

  group('«Chi può trovarmi» e il richiamo (030 V, C)', () {
    testWidgets('parte «Chi conosco»; il richiamo parte spento; un consenso per persona in due versi', (tester) async {
      final stato = await dentro(tester);
      await tocca(tester, 'Impostazioni');
      // passo: «Chi può trovarmi»
      expect(stato.visibilita, Visibilita.conosco, reason: 'passo: valore di partenza');
      await tocca(tester, 'Chi può trovarmi');
      await tocca(tester, 'Nessuno');
      await tocca(tester, 'Salva');
      expect(stato.visibilita, Visibilita.nessuno, reason: 'passo: salvata');
      expect(find.text('Chi può trovarmi'), findsOneWidget, reason: 'passo: torna alle impostazioni');

      // passo: il richiamo parte spento
      expect(stato.richiamoAcceso, isFalse, reason: 'passo: parte spento');
      expect(find.textContaining('Parte spento.'), findsOneWidget, reason: 'passo: parte spento');
      expect(find.text('Chi puoi avvisare'), findsNothing, reason: 'passo: spento, nessuna lista');
      await tocca(tester, 'Richiamo');
      expect(stato.richiamoAcceso, isTrue, reason: 'passo: acceso');

      // passo: «Chi puoi avvisare» con la conferma
      stato.aggiungiPersona('marta');
      await tester.pump();
      await tocca(tester, 'Chi puoi avvisare');
      expect(stato.avvisoA, isEmpty, reason: 'passo: tutte spente');
      await tocca(tester, 'Marta');
      await sale(tester);
      expect(inFoglio('Avvisare Marta?'), findsOneWidget, reason: 'passo: conferma');
      await nelFoglio(tester, 'Avvisa Marta');
      await sale(tester);
      expect(stato.avvisoA, ['marta'], reason: 'passo: acceso dopo la conferma');
      await tocca(tester, 'Marta');
      expect(stato.avvisoA, isEmpty, reason: 'passo: spegnere è subito');

      // passo: «Chi può avvisarti»
      await tocca(tester, 'Indietro');
      await tocca(tester, 'Chi può avvisarti');
      expect(stato.avvisoDa, {'marta': true, 'davide': false}, reason: 'passo: Marta acceso, Davide spento');
    });

    testWidgets('il richiamo del pannello vale solo con il richiamo acceso e il consenso acceso', (tester) async {
      final stato = await dentro(tester);
      const tasto = 'una persona che ho scelto entra in un DEN pubblico';
      expect(pillolaDi(tester, tasto).onTap, isNull, reason: 'passo: richiamo spento');
      stato.impostaRichiamo(true);
      stato.impostaAvvisoDa('marta', false);
      await tester.pump();
      expect(pillolaDi(tester, tasto).onTap, isNull, reason: 'passo: nessuna persona con il consenso acceso');
      stato.impostaAvvisoDa('davide', true);
      await tester.pump();
      await tocca(tester, tasto);
      expect(find.text('Davide è entrato nel DEN Famiglia · vuoi passare?'), findsOneWidget, reason: 'passo: banner');
      expect(stato.denPerId('famiglia')!.suInvito, isFalse, reason: 'passo: solo DEN pubblici');
    });
  });

  group('«Sei stato invitato» (030 I1–I6)', () {
    testWidgets('ho BA: banner, foglio, «Non ora» senza conseguenze, «Entra» fra il pubblico del DEN privato', (tester) async {
      final stato = await dentro(tester, partecipante: false);
      await tocca(tester, 'arriva un invito (ho BA)');
      expect(find.text('Cena senza fretta · Marta ti ha invitato.'), findsOneWidget, reason: 'passo: banner');
      await tocca(tester, 'Cena senza fretta · Marta ti ha invitato.');
      await sale(tester);
      expect(inFoglio('Marta ti ha invitato a Cena senza fretta'), findsOneWidget, reason: 'passo: foglio');
      expect(inFoglio('Entri ad ascoltare.'), findsOneWidget, reason: 'passo: foglio');
      await nelFoglio(tester, 'Non ora');
      await sale(tester);
      expect(stato.denCorrente, isNull, reason: 'passo: «Non ora» chiude senza conseguenze');

      await tocca(tester, 'arriva un invito (ho BA)');
      await tocca(tester, 'Cena senza fretta · Marta ti ha invitato.');
      await sale(tester);
      await nelFoglio(tester, 'Entra');
      await sale(tester);
      expect(stato.denCorrente!.id, 'cena', reason: 'passo: entra');
      expect(stato.ruolo, Ruolo.pubblico, reason: 'passo: fra il pubblico (D-041)');
      expect(stato.partecipante, isFalse, reason: 'passo: resta ascoltatore');
      expect(find.text('Sei entrato su invito di Marta. Ascolti.'), findsOneWidget, reason: 'passo: la riga');
    });

    testWidgets('scaduto e annullato hanno il loro stato; già in un DEN apre «Vuoi passare di qua?»', (tester) async {
      final stato = await dentro(tester);
      // passo: scaduto
      await tocca(tester, 'l\'invito è scaduto');
      await tocca(tester, 'Cena senza fretta · Marta ti ha invitato.');
      await sale(tester);
      expect(inFoglio('Questo invito è scaduto'), findsOneWidget, reason: 'passo: scaduto');
      expect(inFoglio('Chiedi a Marta di invitarti di nuovo.'), findsOneWidget, reason: 'passo: scaduto');
      await nelFoglio(tester, 'Ho capito');
      await sale(tester);
      // passo: annullato
      await tocca(tester, 'l\'invito è annullato');
      await tocca(tester, 'Cena senza fretta · Marta ti ha invitato.');
      await sale(tester);
      expect(inFoglio('Questo invito non è più valido'), findsOneWidget, reason: 'passo: annullato');
      await nelFoglio(tester, 'Ho capito');
      await sale(tester);

      // passo: già in un DEN
      await tocca(tester, 'Cucina di notte');
      await tocca(tester, 'arriva un invito (ho BA)');
      await tocca(tester, 'Cena senza fretta · Marta ti ha invitato.');
      await sale(tester);
      expect(inFoglio('Vuoi passare di qua? Entri ad ascoltare.'), findsOneWidget, reason: 'passo: K6');
      await nelFoglio(tester, 'Passa');
      await sale(tester);
      expect(stato.denCorrente!.id, 'cena', reason: 'passo: passa');
      expect(stato.ruolo, Ruolo.pubblico, reason: 'passo: fra il pubblico');
    });

    testWidgets('non ho BA: la mail e la pagina fuori dall\'app, l\'accesso del 013 e l\'ingresso diretto', (tester) async {
      final stato = await dentro(tester);
      await tocca(tester, 'arriva un invito (non ho BA)');
      expect(find.text('FUORI DALL\'APP · SIMULAZIONE'), findsOneWidget, reason: 'passo: mail');
      expect(find.text('EMAIL · DA BA'), findsOneWidget, reason: 'passo: mail');
      await tocca(tester, 'Apri l\'invito');
      expect(find.text('PAGINA WEB · FUORI DALL\'APP'), findsOneWidget, reason: 'passo: pagina');
      await tocca(tester, 'Continua con la email');
      expect(find.text('FUORI DALL\'APP · SIMULAZIONE'), findsNothing, reason: 'passo: dentro l\'accesso');
      expect(find.text('La tua email'), findsOneWidget, reason: 'passo: accesso del 013');
      await accedi(tester);
      expect(stato.denCorrente!.id, 'cena', reason: 'passo: ingresso diretto, senza passare dall\'elenco');
      expect(stato.ruolo, Ruolo.pubblico, reason: 'passo: fra il pubblico');
      expect(find.text('Sei entrato su invito di Marta. Ascolti.'), findsOneWidget, reason: 'passo: I6');
    });

    testWidgets('un DEN privato pieno usa lo stesso «Mettiti in coda»', (tester) async {
      await dentro(tester);
      await tocca(tester, 'Salotto');
      await tocca(tester, 'Mettiti in coda');
      await sale(tester);
      expect(inFoglio('Mettiti in coda'), findsWidgets, reason: 'passo: K2 senza schermate nuove');
      expect(inFoglio('Fammi entrare automaticamente'), findsOneWidget, reason: 'passo: K2');
    });
  });

  group('a testo 2,0 e a 744 nulla si taglia', () {
    testWidgets('aggiungere persone e la pagina fuori dall\'app', (tester) async {
      final stato = await dentro(tester);
      await tocca(tester, 'Testo 1,0');
      await tocca(tester, 'Aggiungi persone');
      await scriviNellaPagina(tester, 'sar');
      expect(tester.takeException(), isNull, reason: 'passo: aggiungi persone a 2,0');
      stato.arrivaInvitoSenzaBa();
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'passo: fuori dall\'app a 2,0');
      await tocca(tester, 'Larghezza 360');
      expect(tester.takeException(), isNull, reason: 'passo: fuori dall\'app a 744');
    });
  });
}
