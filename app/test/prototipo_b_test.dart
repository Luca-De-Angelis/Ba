import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/foglio.dart';
import 'package:ba/design_system/palco.dart';
import 'package:ba/prototipo/schermo_bloccato.dart';
import 'package:ba/prototipo/stato.dart';

import 'prototipo_aiuti.dart';

// Il prototipo navigabile, seconda parte (task 024b): la coda e il posto offerto, la creazione
// dei DEN e «Gestisci», il sotto-DEN, le simulazioni dal pannello (a un colpo, senza timer), il
// permesso del microfono, l'account chiuso e lo schermo bloccato simulato. Si prova con i
// widget, non con un browser.

/// Un tocco sullo schermo bloccato simulato (la stanza sotto ha gli stessi testi, ma è coperta).
Future<void> _nelBloccato(WidgetTester tester, String testo) async {
  await tester.tap(
    find
        .descendant(
          of: find.byType(SchermoBloccato),
          matching: find.text(testo),
        )
        .first,
  );
  await tester.pump();
}

Finder _inBloccato(String testo) => find.descendant(
  of: find.byType(SchermoBloccato),
  matching: find.text(testo),
);

/// Nella stanza «Tavolo lungo» (palco pieno) e in coda.
Future<StatoProto> _inCoda(WidgetTester tester) async {
  final stato = await _dentro(tester);
  await _tocca(tester, 'Tavolo lungo');
  await _tocca(tester, 'Mettiti in coda');
  await _sale(tester);
  await _nelFoglio(tester, 'Mettiti in coda');
  await _sale(tester);
  return stato;
}

// Gli aiuti comuni stanno in `prototipo_aiuti.dart`.
final _dentro = dentro;
final _tocca = tocca;
final _nelFoglio = nelFoglio;
final _sale = sale;
final _altro = altro;
final _inFoglio = inFoglio;
final _pillola = pillolaDi;

void main() {
  group('la coda (015)', () {
    testWidgets('la coda (015): scenari riuniti, un passo per scenario', (
      tester,
    ) async {
      // passo: palco pieno: «Mettiti in coda», senza «Aspetta con altri» la riga non esiste; si resta nel pubblico, in coda
      await passo('palco pieno: «Mettiti in coda», senza «Aspetta con altri» la riga non esiste; si resta nel pubblico, in coda', () async {
        final stato = await _dentro(tester);
        await _tocca(tester, 'Tavolo lungo');
        expect(find.text('Sali sul palco'), findsNothing);
        await _tocca(tester, 'Mettiti in coda');
        await _sale(tester);
        expect(_inFoglio('Fammi entrare automaticamente'), findsOneWidget);
        expect(
          _inFoglio('Aspetta con altri'),
          findsNothing,
          reason:
              'senza la capacità la riga non esiste: né etichetta né traccia',
        );
        expect(_inFoglio('Salirai a microfono spento.'), findsOneWidget);
        await _nelFoglio(tester, 'Mettiti in coda');
        await _sale(tester);
        expect(stato.ruolo, Ruolo.inCoda);
        expect(stato.code, ['tavolo']);
        expect(find.text('Esci dalla coda'), findsOneWidget);
        expect(find.text('Altro'), findsNothing);
      });
      // passo: con la capacità: «Aspetta con altri» → «Entra nel gruppo» → la fascia d\'attesa e «Lascia il gruppo»
      await passo('con la capacità: «Aspetta con altri» → «Entra nel gruppo» → la fascia d\'attesa e «Lascia il gruppo»', () async {
        final stato = await _dentro(tester);
        await _tocca(tester, 'capacità di aspettare con altri');
        await _tocca(tester, 'Tavolo lungo');
        await _tocca(tester, 'Mettiti in coda');
        await _sale(tester);
        expect(_inFoglio('Aspetta con altri'), findsOneWidget);
        await _nelFoglio(tester, 'Aspetta con altri');
        expect(
          stato.aspettaConAltri,
          isTrue,
          reason: 'l\'interruttore cambia davvero',
        );
        await _nelFoglio(tester, 'Mettiti in coda');
        await _sale(tester);
        expect(_inFoglio('Entra nel gruppo'), findsOneWidget);
        await _nelFoglio(tester, 'Entra nel gruppo');
        await _sale(tester);
        expect(stato.inGruppo, isTrue);
        expect(
          find.text('Parli al gruppo di chi aspetta. Il palco non ti sente.'),
          findsOneWidget,
        );
        await _tocca(tester, 'Lascia il gruppo');
        expect(
          find.text('Parli al gruppo di chi aspetta. Il palco non ti sente.'),
          findsNothing,
        );
        expect(
          stato.ruolo,
          Ruolo.inCoda,
          reason: 'lasciare il gruppo non toglie dalla coda',
        );
      });
      // passo: «Le tue code»: la riga con «Esci dalla coda»; la coda piena apre S1 e si resta nel pubblico
      await passo('«Le tue code»: la riga con «Esci dalla coda»; la coda piena apre S1 e si resta nel pubblico', () async {
        final stato = await _inCoda(tester);
        await _altro(tester);
        await _nelFoglio(tester, 'Le tue code');
        await _sale(tester);
        expect(_inFoglio('Tavolo lungo'), findsOneWidget);
        expect(_inFoglio('In coda · entri a microfono spento'), findsOneWidget);
        await _nelFoglio(tester, 'Esci dalla coda');
        expect(stato.code, isEmpty);
        await _nelFoglio(tester, 'Chiudi');
        await _sale(tester);

        await _tocca(tester, 'Esci');
        await _tocca(tester, 'Serra');
        await _tocca(tester, 'Mettiti in coda');
        await _sale(tester);
        expect(_inFoglio('La coda è piena adesso'), findsOneWidget);
        await _nelFoglio(tester, 'Ho capito');
        await _sale(tester);
        expect(stato.ruolo, Ruolo.pubblico);
        expect(stato.code, isEmpty);
      });
    });
  });

  group('il posto offerto (K3–K6)', () {
    testWidgets(
      'il posto offerto (K3–K6): scenari riuniti, un passo per scenario',
      (tester) async {
        // passo: si libera un posto: la nota con «pochi secondi», il banner, si sale a microfono spento
        await passo('si libera un posto: la nota con «pochi secondi», il banner, si sale a microfono spento', () async {
          final stato = await _inCoda(tester);
          expect(_pillola(tester, 'si libera un posto').onTap, isNotNull);
          await _tocca(tester, 'si libera un posto');
          expect(
            find.text(
              'Si è liberato un posto sul palco. Hai pochi secondi per salire. Salirai a microfono spento.',
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              'Tavolo lungo · Si è liberato un posto sul palco. Hai pochi secondi per salire.',
            ),
            findsOneWidget,
            reason: 'il banner',
          );
          await _tocca(tester, 'Sali sul palco');
          expect(stato.ruolo, Ruolo.sulPalco);
          expect(
            stato.micAcceso,
            isFalse,
            reason: 'D-007: si sale a microfono spento',
          );
          expect(stato.code, isEmpty);
          expect(stato.banner, isNull);
        });
        // passo: con l\'ingresso automatico si sale subito, a microfono spento (K5)
        await passo(
          'con l\'ingresso automatico si sale subito, a microfono spento (K5)',
          () async {
            final stato = await _dentro(tester);
            await _tocca(tester, 'Tavolo lungo');
            await _tocca(tester, 'Mettiti in coda');
            await _sale(tester);
            await _nelFoglio(tester, 'Fammi entrare automaticamente');
            await _nelFoglio(tester, 'Mettiti in coda');
            await _sale(tester);
            await _tocca(tester, 'si libera un posto');
            expect(stato.ruolo, Ruolo.sulPalco);
            expect(stato.micAcceso, isFalse);
            expect(find.text('Accendi il microfono'), findsOneWidget);
          },
        );
        // passo: il posto scade (K4 bis): resti in coda, «In coda» è inattiva
        await passo(
          'il posto scade (K4 bis): resti in coda, «In coda» è inattiva',
          () async {
            final stato = await _inCoda(tester);
            expect(
              _pillola(tester, 'il posto scade').onTap,
              isNull,
              reason: 'senza un posto offerto non c\'è niente che scada',
            );
            await _tocca(tester, 'si libera un posto');
            await _tocca(tester, 'il posto scade');
            expect(
              find.text(
                'Il posto è passato alla persona dopo di te. Resti in coda.',
              ),
              findsOneWidget,
            );
            expect(_pillola(tester, 'In coda').onTap, isNull);
            expect(stato.ruolo, Ruolo.inCoda);
            // Ripetibile: il posto si libera di nuovo.
            await _tocca(tester, 'si libera un posto');
            expect(stato.posto, Posto.offerto);
          },
        );
        // passo: in un altro DEN: il banner porta a «Vuoi passare di qua?»; «Passa» entra nel DEN del posto
        await passo('in un altro DEN: il banner porta a «Vuoi passare di qua?»; «Passa» entra nel DEN del posto', () async {
          final stato = await _inCoda(tester);
          await _tocca(tester, 'Esci');
          await _tocca(tester, 'Cucina di notte');
          await _tocca(tester, 'si libera un posto');
          await _tocca(
            tester,
            'Tavolo lungo · Si è liberato un posto sul palco. Hai pochi secondi per salire.',
          );
          await _sale(tester);
          expect(
            _inFoglio('Vuoi passare di qua? Salirai a microfono spento.'),
            findsOneWidget,
          );
          expect(
            _inFoglio('Hai pochi secondi per decidere.'),
            findsOneWidget,
            reason: 'una frase ferma, nessun conto alla rovescia',
          );
          await _nelFoglio(tester, 'Resta qui');
          await _sale(tester);
          expect(stato.denCorrente!.id, 'cucina');
          expect(
            stato.banner,
            isNull,
            reason: 'il banner è stato tolto con il tocco',
          );
          // Il posto scade e si libera di nuovo: stavolta si passa.
          await _tocca(tester, 'il posto scade');
          await _tocca(tester, 'si libera un posto');
          await _tocca(
            tester,
            'Tavolo lungo · Si è liberato un posto sul palco. Hai pochi secondi per salire.',
          );
          await _sale(tester);
          await _nelFoglio(tester, 'Passa');
          await _sale(tester);
          expect(stato.denCorrente!.id, 'tavolo');
          expect(stato.ruolo, Ruolo.inCoda);
          expect(
            find.text('Sali sul palco'),
            findsOneWidget,
            reason: 'il posto è offerto: «Sali sul palco» è chiara',
          );
        });
      },
    );
  });

  group('creare un DEN (014)', () {
    Future<void> scrivi(WidgetTester tester, String testo) async {
      await tester.enterText(
        find
            .descendant(
              of: find.byType(BaFoglio),
              matching: find.byType(EditableText),
            )
            .first,
        testo,
      );
      await tester.pump();
    }

    testWidgets('creare un DEN (014): scenari riuniti, un passo per scenario', (
      tester,
    ) async {
      // passo: privato: i passi, gli invitati dal selettore, il riepilogo, si entra amministratore a microfono spento
      await passo('privato: i passi, gli invitati dal selettore, il riepilogo, si entra amministratore a microfono spento', () async {
        final stato = await _dentro(tester);
        stato.aggiungiPersona('marta');
        await _tocca(tester, 'Crea un DEN');
        await _sale(tester);
        expect(find.text('Che DEN vuoi creare?'), findsOneWidget);
        await _nelFoglio(tester, 'Continua');
        // «Il nome non è vuoto».
        await _nelFoglio(tester, 'Continua');
        expect(find.text('Scrivi un nome per il DEN.'), findsOneWidget);
        await scrivi(tester, 'Cena senza fretta');
        await _nelFoglio(tester, 'Continua');
        expect(find.text('Descrizione, tema e lingua'), findsOneWidget);
        await _nelFoglio(tester, 'Continua');
        expect(find.text('Chi inviti?'), findsOneWidget);
        await tester.tap(find.text('Invita').first);
        await tester.pump();
        expect(find.text('1 persona nell\'invito.'), findsOneWidget);
        await _nelFoglio(tester, 'Continua');
        expect(find.text('Tutto pronto?'), findsOneWidget);
        await _nelFoglio(tester, 'Crea il DEN');
        await _sale(tester);
        expect(stato.denCorrente!.nome, 'Cena senza fretta');
        expect(stato.denCorrente!.suInvito, isTrue);
        expect(stato.ruolo, Ruolo.sulPalco);
        expect(stato.micAcceso, isFalse, reason: 'si sale a microfono spento');
        expect(
          find.text('Hai creato Cena senza fretta. Sei amministratore.'),
          findsOneWidget,
        );
        expect(find.text('Accendi il microfono'), findsOneWidget);
      });
      // passo: pubblico: niente invitati; il DEN compare nell\'elenco
      await passo(
        'pubblico: niente invitati; il DEN compare nell\'elenco',
        () async {
          final stato = await _dentro(tester);
          await _tocca(tester, 'Crea un DEN');
          await _sale(tester);
          await _nelFoglio(tester, 'Pubblico');
          await _nelFoglio(tester, 'Continua');
          await scrivi(tester, 'Tavolo 9');
          await _nelFoglio(tester, 'Continua');
          await _nelFoglio(tester, 'Continua');
          expect(find.text('Chi inviti?'), findsNothing);
          expect(find.text('Tutto pronto?'), findsOneWidget);
          await _nelFoglio(tester, 'Crea il DEN');
          await _sale(tester);
          await _tocca(tester, 'Esci');
          expect(find.text('Tavolo 9'), findsOneWidget);
          expect(stato.den.last.suInvito, isFalse);
        },
      );
      // passo: non riesce: l\'errore con «Riprova», quello che si è scritto resta, e stavolta riesce
      await passo('non riesce: l\'errore con «Riprova», quello che si è scritto resta, e stavolta riesce', () async {
        final stato = await _dentro(tester);
        await _tocca(tester, 'la creazione non riesce');
        await _tocca(tester, 'Crea un DEN');
        await _sale(tester);
        await _nelFoglio(tester, 'Pubblico');
        await _nelFoglio(tester, 'Continua');
        await scrivi(tester, 'Tavolo 9');
        await _nelFoglio(tester, 'Continua');
        await _nelFoglio(tester, 'Continua');
        await _nelFoglio(tester, 'Crea il DEN');
        expect(find.text('Il DEN non è stato creato'), findsOneWidget);
        expect(
          find.text('Quello che hai scritto è ancora qui.'),
          findsOneWidget,
        );
        expect(stato.den.any((d) => d.creatoDaMe), isFalse);
        await _nelFoglio(tester, 'Riprova');
        expect(find.text('Tavolo 9'), findsWidgets);
        await _nelFoglio(tester, 'Crea il DEN');
        await _sale(tester);
        expect(stato.denCorrente!.nome, 'Tavolo 9');
      });
      // passo: da ascoltatore passa prima dall\'accesso a parlare, poi dai passi della creazione
      await passo('da ascoltatore passa prima dall\'accesso a parlare, poi dai passi della creazione', () async {
        final stato = await _dentro(tester, partecipante: false);
        await _tocca(tester, 'Crea un DEN');
        await _sale(tester);
        expect(
          find.text('Per creare un DEN bisogna diventare partecipante'),
          findsOneWidget,
        );
        await _nelFoglio(tester, 'Continua');
        await tester.enterText(
          find
              .descendant(
                of: find.byType(BaFoglio),
                matching: find.byType(EditableText),
              )
              .first,
          '320 000 0000',
        );
        await tester.pump();
        await _nelFoglio(tester, 'Ricevi il codice');
        await tester.enterText(
          find
              .descendant(
                of: find.byType(BaFoglio),
                matching: find.byType(EditableText),
              )
              .first,
          '123456',
        );
        await tester.pump();
        await _nelFoglio(tester, 'Conferma');
        await _nelFoglio(tester, 'Acconsento e continuo');
        await _sale(tester);
        expect(stato.partecipante, isTrue);
        expect(find.text('Che DEN vuoi creare?'), findsOneWidget);
      });
    });
  });

  group('«Gestisci» e il sotto-DEN', () {
    Future<StatoProto> creato(
      WidgetTester tester, {
      bool privato = false,
    }) async {
      final stato = await _dentro(tester);
      stato.aggiungiPersona('davide');
      stato.creaDen(
        nome: 'Tavolo 9',
        privato: privato,
        descrizione: 'Due chiacchiere',
        invitati: const [],
      );
      await tester.pump();
      return stato;
    }

    testWidgets(
      '«Gestisci» e il sotto-DEN: scenari riuniti, un passo per scenario',
      (tester) async {
        // passo: per un DEN pubblico creato: co-amministratore (limite), «Rimuovi» con la conferma, «Termina il DEN»
        await passo('per un DEN pubblico creato: co-amministratore (limite), «Rimuovi» con la conferma, «Termina il DEN»', () async {
          final stato = await creato(tester);
          await _altro(tester);
          expect(_inFoglio('Gestisci'), findsOneWidget);
          await _nelFoglio(tester, 'Gestisci');
          await _sale(tester);
          expect(
            _inFoglio('0 di 1'),
            findsOneWidget,
            reason: 'il limite è un numero, mai un livello',
          );
          await _nelFoglio(tester, 'Co-amministratori');
          expect(
            _pillola(tester, 'Aggiungi un co-amministratore').onTap,
            isNull,
            reason: 'inattiva finché non si sceglie',
          );
          await _nelFoglio(tester, 'Scegli');
          await _nelFoglio(tester, 'Aggiungi un co-amministratore');
          expect(stato.coAmministratori['mio-1']!.length, 1);
          expect(
            find.textContaining('Hai raggiunto il limite di co-amministratori'),
            findsOneWidget,
          );
          expect(
            _pillola(tester, 'Aggiungi un co-amministratore').onTap,
            isNull,
          );
          await _nelFoglio(tester, 'Chiudi');
          await _nelFoglio(tester, 'Persone nel DEN');
          // Le due persone del DEN hanno «Rimuovi»; dopo averne rimossa una ne resta una.
          expect(find.text('Rimuovi'), findsNWidgets(2));
          await _nelFoglio(tester, 'Rimuovi');
          expect(find.textContaining('Rimuovere'), findsOneWidget);
          await _nelFoglio(tester, 'Rimuovi');
          expect(find.text('Rimuovi'), findsOneWidget);
          await _nelFoglio(tester, 'Chiudi');
          await _nelFoglio(tester, 'Termina il DEN');
          expect(find.text('Terminare il DEN?'), findsOneWidget);
          await _nelFoglio(tester, 'Termina il DEN');
          await _sale(tester);
          expect(stato.denCorrente, isNull);
          expect(stato.den.any((d) => d.creatoDaMe), isFalse);
          expect(find.text('Tavolo 9'), findsNothing);
        });
        // passo: anche per un privato; non per un DEN che non è creato da chi usa il prototipo
        await passo('anche per un privato; non per un DEN che non è creato da chi usa il prototipo', () async {
          await creato(tester, privato: true);
          await _altro(tester);
          expect(_inFoglio('Gestisci'), findsOneWidget);
          expect(_inFoglio('Nuovo sotto-DEN'), findsOneWidget);
        });
        // passo: il sotto-DEN: il nome non è vuoto; la stanza ne prende nota
        await passo(
          'il sotto-DEN: il nome non è vuoto; la stanza ne prende nota',
          () async {
            await creato(tester);
            await _altro(tester);
            await _nelFoglio(tester, 'Nuovo sotto-DEN');
            await _sale(tester);
            await _nelFoglio(tester, 'Crea il sotto-DEN');
            expect(
              find.text('Scrivi un nome per il sotto-DEN.'),
              findsOneWidget,
            );
            await tester.enterText(
              find
                  .descendant(
                    of: find.byType(BaFoglio),
                    matching: find.byType(EditableText),
                  )
                  .first,
              'Tavolo 2',
            );
            await tester.pump();
            await _nelFoglio(tester, 'Crea il sotto-DEN');
            await _sale(tester);
            expect(find.text('Sotto-DEN: Tavolo 2'), findsOneWidget);
          },
        );
        // passo: in un DEN di prova non ci sono né «Gestisci» né «Nuovo sotto-DEN»
        await passo(
          'in un DEN di prova non ci sono né «Gestisci» né «Nuovo sotto-DEN»',
          () async {
            await _dentro(tester);
            await _tocca(tester, 'Cucina di notte');
            await _altro(tester);
            expect(_inFoglio('Gestisci'), findsNothing);
            expect(_inFoglio('Nuovo sotto-DEN'), findsNothing);
          },
        );
      },
    );
  });

  group('le simulazioni dal pannello', () {
    testWidgets(
      'le simulazioni dal pannello: scenari riuniti, un passo per scenario',
      (tester) async {
        // passo: qualcuno parla: l\'anello passa alla persona dopo, e poi a nessuno
        await passo(
          'qualcuno parla: l\'anello passa alla persona dopo, e poi a nessuno',
          () async {
            final stato = await _dentro(tester);
            await _tocca(tester, 'Cucina di notte');
            String? chiParla() {
              final p = tester
                  .widget<BaPalco>(find.byType(BaPalco))
                  .persone
                  .where((p) => p.parla);
              return p.isEmpty ? null : p.first.id;
            }

            expect(chiParla(), 'mb');
            await _tocca(tester, 'qualcuno parla');
            expect(chiParla(), 'ah');
            for (var i = 0; i < 3; i++) {
              await _tocca(tester, 'qualcuno parla');
            }
            expect(chiParla(), isNull);
            expect(stato.parla, isNull);
          },
        );
        // passo: perdo la linea (P1), il posto c\'era (P2); il posto è stato preso (P3)
        await passo('perdo la linea (P1), il posto c\'era (P2); il posto è stato preso (P3)', () async {
          final stato = await _dentro(tester);
          await _tocca(tester, 'Cucina di notte');
          expect(
            _pillola(tester, 'perdo la linea').onTap,
            isNull,
            reason: 'serve essere sul palco',
          );
          await _tocca(tester, 'Sali sul palco');
          await _tocca(tester, 'Accendi il microfono');
          await _tocca(tester, 'perdo la linea');
          expect(
            find.text(
              'Hai perso la linea. Il posto resta tuo ancora per un momento.',
            ),
            findsOneWidget,
          );
          expect(
            stato.micAcceso,
            isFalse,
            reason: 'senza linea il microfono è spento',
          );
          expect(_pillola(tester, 'Sto riprovando…').onTap, isNull);
          await _tocca(tester, 'torno in linea');
          expect(
            find.text(
              'Sei di nuovo in linea. Il tuo posto c\'era: sei sul palco, a microfono spento.',
            ),
            findsOneWidget,
          );
          expect(stato.ruolo, Ruolo.sulPalco);

          await _tocca(tester, 'perdo la linea');
          await _tocca(tester, 'il posto scade');
          await _tocca(tester, 'torno in linea');
          expect(
            find.text(
              'Sei di nuovo in linea. Il tuo posto sul palco è stato preso: sei fra il pubblico.',
            ),
            findsOneWidget,
          );
          expect(stato.ruolo, Ruolo.pubblico);
          expect(
            find.text('Mettiti in coda'),
            findsOneWidget,
            reason: 'il palco è di nuovo pieno',
          );
        });
        // passo: una persona che ho scelto entra in un DEN pubblico: il banner porta in «Famiglia»; da una stanza apre «Vuoi passare di qua?»
        await passo('una persona che ho scelto entra in un DEN pubblico: il banner porta in «Famiglia»; da una stanza apre «Vuoi passare di qua?»', () async {
          final stato = await _dentro(tester);
          expect(
            _pillola(
              tester,
              'una persona che ho scelto entra in un DEN pubblico',
            ).onTap,
            isNull,
            reason: 'il richiamo parte spento',
          );
          stato.impostaRichiamo(true);
          await tester.pump();
          expect(
            find.text(
              'il richiamo arriva solo da chi ti ha scelto e solo per DEN pubblici (proposta 030)',
            ),
            findsOneWidget,
          );
          await _tocca(
            tester,
            'una persona che ho scelto entra in un DEN pubblico',
          );
          await _tocca(
            tester,
            'Marta è entrato nel DEN Famiglia · vuoi passare?',
          );
          expect(stato.denCorrente!.id, 'famiglia');
          expect(
            stato.denCorrente!.suInvito,
            isFalse,
            reason: 'il richiamo è solo per DEN pubblici',
          );
          expect(stato.ruolo, Ruolo.pubblico);

          await _tocca(tester, 'Esci');
          await _tocca(tester, 'Cucina di notte');
          await _tocca(
            tester,
            'una persona che ho scelto entra in un DEN pubblico',
          );
          await _tocca(
            tester,
            'Marta è entrato nel DEN Famiglia · vuoi passare?',
          );
          await _sale(tester);
          expect(_inFoglio('Marta è entrato nel DEN Famiglia'), findsOneWidget);
          await _nelFoglio(tester, 'Passa');
          await _sale(tester);
          expect(stato.denCorrente!.id, 'famiglia');
        });
        // passo: il permesso del microfono: negato mostra «Apri»; senza permesso «Accendi il microfono» apre Fase 2
        await passo('il permesso del microfono: negato mostra «Apri»; senza permesso «Accendi il microfono» apre Fase 2', () async {
          final stato = await _dentro(tester);
          await _tocca(tester, 'microfono negato');
          await _tocca(tester, 'Impostazioni');
          expect(
            find.text('Negato — senza il microfono non puoi parlare'),
            findsOneWidget,
          );
          expect(find.text('Apri'), findsOneWidget);
          await _tocca(tester, 'Apri');
          expect(
            find.text('Consentito'),
            findsOneWidget,
            reason: '«Apri» simula il ritorno dalle impostazioni con il permesso dato',
          );
          expect(stato.permessoMic, isTrue);

          await _tocca(tester, 'microfono negato');
          await _tocca(tester, 'Indietro');
          await _tocca(tester, 'Radio insonni');
          await _tocca(tester, 'Sali sul palco');
          await _tocca(tester, 'Accendi il microfono');
          await _sale(tester);
          expect(
            find.text('Senza microfono non posso farti parlare'),
            findsOneWidget,
          );
          expect(stato.micAcceso, isFalse);
          await _nelFoglio(tester, 'Resto ad ascoltare');
          await _sale(tester);
          expect(stato.micAcceso, isFalse);
          expect(stato.ruolo, Ruolo.sulPalco);
        });
      },
    );
  });

  group('l\'account chiuso (027 B1, B1 bis, B2)', () {
    testWidgets(
      'chiuso → «Richiedi revisione» → «Richiesta inviata» inattiva; il blocco temporaneo ha la sua durata',
      (tester) async {
        final stato = await _dentro(tester);
        await _tocca(tester, 'l\'account viene chiuso');
        expect(
          find.text('Questo account non può più usare BA'),
          findsOneWidget,
        );
        expect(
          find.text('Un contenuto non rispetta le regole di BA.'),
          findsOneWidget,
        );
        expect(
          find.text('Se pensi che sia un errore, puoi chiedere una revisione.'),
          findsOneWidget,
        );
        await _tocca(tester, 'Richiedi revisione');
        expect(
          find.text(
            'Abbiamo ricevuto la richiesta di revisione. Ti scriviamo all\'email dell\'account.',
          ),
          findsOneWidget,
        );
        expect(_pillola(tester, 'Richiesta inviata').onTap, isNull);
        expect(stato.revisioneRichiesta, isTrue);

        await _tocca(tester, 'blocco temporaneo');
        expect(find.text('L\'accesso a BA è sospeso'), findsOneWidget);
        expect(
          find.text('Potrai rientrare il 21 novembre alle 21:40.'),
          findsOneWidget,
        );
        expect(
          find.text('Richiedi revisione'),
          findsOneWidget,
          reason: 'una nuova chiusura riparte dalla richiesta',
        );
        await _tocca(tester, 'riapri l\'account');
        expect(find.text('L\'accesso a BA è sospeso'), findsNothing);
        expect(stato.chiusura, isNull);
      },
    );
  });

  group('lo schermo bloccato simulato (027 L1–L4, D-050)', () {
    testWidgets(
      'lo schermo bloccato simulato (027 L1–L4, D-050): scenari riuniti, un passo per scenario',
      (tester) async {
        // passo: sul palco: acceso si può spegnere (L1), spento non si accende (L2)
        await passo(
          'sul palco: acceso si può spegnere (L1), spento non si accende (L2)',
          () async {
            final stato = await _dentro(tester);
            expect(
              _pillola(tester, 'schermo bloccato').onTap,
              isNull,
              reason: 'serve una stanza aperta',
            );
            await _tocca(tester, 'Radio insonni');
            await _tocca(tester, 'Sali sul palco');
            await _tocca(tester, 'Accendi il microfono');
            expect(stato.micAcceso, isTrue);
            await _tocca(tester, 'schermo bloccato');
            expect(find.text('SCHERMO BLOCCATO · SIMULAZIONE'), findsOneWidget);
            expect(
              _inBloccato('Spegni il microfono'),
              findsOneWidget,
              reason: 'L1: si può spegnere',
            );
            await _nelBloccato(tester, 'Spegni il microfono');
            expect(stato.micAcceso, isFalse);
            expect(_inBloccato('Microfono spento'), findsOneWidget);
            expect(
              _inBloccato('Accendi il microfono'),
              findsNothing,
              reason: 'L2: nessuna azione per accenderlo (D-025)',
            );
            expect(
              find
                  .text('Accendi il microfono', skipOffstage: false)
                  .hitTestable(),
              findsNothing,
              reason: 'la stanza sotto è coperta',
            );
            stato.cambiaMic();
            expect(
              stato.micAcceso,
              isFalse,
              reason: 'dal telefono bloccato il microfono non si accende',
            );
            expect(_pillola(tester, 'Prossimo DEN').onTap, isNull);
            await _nelBloccato(tester, 'Sblocca');
            expect(find.text('SCHERMO BLOCCATO · SIMULAZIONE'), findsNothing);
            stato.cambiaMic();
            expect(stato.micAcceso, isTrue, reason: 'sbloccato si riaccende');
          },
        );
        // passo: nel pubblico: «Pausa» (L3) e «Riprendi dal vivo» (L4); «Esci» esce dalla stanza
        await passo('nel pubblico: «Pausa» (L3) e «Riprendi dal vivo» (L4); «Esci» esce dalla stanza', () async {
          final stato = await _dentro(tester);
          await _tocca(tester, 'Cucina di notte');
          await _tocca(tester, 'schermo bloccato');
          expect(_inBloccato('In diretta'), findsOneWidget);
          await _nelBloccato(tester, 'Pausa');
          expect(_inBloccato('In pausa'), findsOneWidget);
          await _nelBloccato(tester, 'Riprendi dal vivo');
          expect(_inBloccato('In diretta'), findsOneWidget);
          await _nelBloccato(tester, 'Esci');
          expect(stato.denCorrente, isNull);
          expect(stato.schermoBloccato, isFalse);
        });
      },
    );
  });

  group('a testo 2,0 e a 744 nulla si taglia', () {
    testWidgets(
      'la stanza in coda con il posto offerto e il banner, e il foglio «Mettiti in coda»',
      (tester) async {
        for (final larghezza in [360.0, 744.0]) {
          final stato = await _dentro(tester);
          if (larghezza == 744) await _tocca(tester, 'Larghezza 360');
          await _tocca(tester, 'Testo 1,0');
          await _tocca(tester, 'capacità di aspettare con altri');
          await _tocca(tester, 'Tavolo lungo');
          await _tocca(tester, 'Mettiti in coda');
          await _sale(tester);
          expect(tester.takeException(), isNull, reason: 'K2 a $larghezza');
          await _nelFoglio(tester, 'Mettiti in coda');
          await _sale(tester);
          await _tocca(tester, 'si libera un posto');
          expect(
            tester.takeException(),
            isNull,
            reason: 'stanza in coda a $larghezza',
          );
          expect(stato.posto, Posto.offerto);
          await tester.pumpWidget(const SizedBox());
        }
      },
    );
  });
}
