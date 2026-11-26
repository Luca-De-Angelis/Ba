import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/revisione_traduzioni.dart';

// Lo script che prepara il foglio di revisione delle traduzioni (task 035): una riga per chiave in
// ogni lingua, segnaposto che coincidono, formato (BOM, «;», virgolette), e il rifiuto di
// sovrascrivere correzioni. Tutti i test girano sugli ARB veri, o su ARB finti in memoria.

const _cartellaArb = 'lib/l10n';
const _cartellaCsv = '../docs/traduzioni';

FileArb _arb(String codice, Map<String, dynamic> contenuto) => FileArb(codice, contenuto);

FileArb _vero(String codice) => leggiArb('$_cartellaArb/app_$codice.arb');

List<String> _lingueVere() => [
      for (final f in Directory(_cartellaArb).listSync().whereType<File>())
        if (RegExp(r'app_(\w+)\.arb$').hasMatch(f.path)) RegExp(r'app_(\w+)\.arb$').firstMatch(f.path)!.group(1)!,
    ]..sort();

void main() {
  final it = _vero('it');
  final altre = [for (final c in _lingueVere()) if (c != 'it') _vero(c)];

  group('sugli ARB veri', () {
    test('trova le lingue dagli ARB: it di riferimento, e le altre quattro', () {
      expect(arbDiRiferimento('l10n.yaml'), 'app_it.arb');
      expect(altre.map((a) => a.codice), ['de', 'en', 'es', 'fr']);
    });

    test('ogni lingua ha una riga per chiave, nell\'ordine dell\'italiano, e nessuna chiave in più', () {
      expect(it.chiavi, isNotEmpty);
      for (final lingua in altre) {
        final righe = leggiCsv(generaCsv(it, lingua));
        expect(righe.length, it.chiavi.length + 1, reason: '${lingua.codice}: testata più una riga per chiave');
        expect([for (final r in righe.skip(1)) r.first], it.chiavi, reason: lingua.codice);
        expect(lingua.chiavi, it.chiavi, reason: '${lingua.codice}: le stesse chiavi dell\'italiano');
      }
    });

    test('i segnaposto coincidono fra le lingue: nessun problema', () {
      for (final lingua in altre) {
        expect(verifica(it, lingua), isEmpty, reason: lingua.codice);
      }
    });

    test('le colonne sono quelle del foglio, e correzione e nota sono vuote', () {
      final righe = leggiCsv(generaCsv(it, _vero('en')));
      expect(righe.first, ['chiave', 'contesto', 'italiano', 'inglese (en)', 'correzione', 'nota', 'lunghezza', 'segnaposto']);
      for (final r in righe) {
        expect(r.length, 8, reason: '${r.first}: otto colonne');
      }
      final iCorrezione = righe.first.indexOf('correzione');
      final iNota = righe.first.indexOf('nota');
      expect([for (final r in righe.skip(1)) r[iCorrezione] + r[iNota]].join(), isEmpty);
    });

    test('contesto, lunghezza e segnaposto: la descrizione dell\'italiano, i caratteri del testo, i nomi fra graffe', () {
      final righe = leggiCsv(generaCsv(it, _vero('de')));
      final per = {for (final r in righe.skip(1)) r.first: r};
      expect(per['palcoLibero']![1], it.descrizione('palcoLibero'));
      expect(per['palcoLibero']![2], it.testo('palcoLibero'));
      expect(per['palcoLibero']![3], _vero('de').testo('palcoLibero'));
      expect(per['palcoLibero']![6], '${_vero('de').testo('palcoLibero')!.runes.length}');
      expect(per['palcoLibero']![7], isEmpty, reason: 'senza segnaposto');
      expect(per['presenzaParla']![7], 'nome');
      expect(per['palcoEtichetta']![7], 'n', reason: 'il plurale ha il suo segnaposto, non i rami');
    });

    test('il file è UTF-8 con BOM, separato da «;», con a capo CRLF', () {
      final csv = generaCsv(it, _vero('fr'));
      expect(csv.codeUnitAt(0), 0xFEFF);
      expect(csv.contains('\r\n'), isTrue);
      expect(csv.split('\r\n').first, contains(';'));
      expect(csv.contains(RegExp(r'[^\r]\n')), isFalse, reason: 'solo CRLF fuori dai campi fra virgolette');
    });

    test('i CSV committati in docs/traduzioni/ hanno le chiavi degli ARB, uno per lingua', () {
      for (final lingua in altre) {
        final file = File('$_cartellaCsv/revisione-${lingua.codice}.csv');
        expect(file.existsSync(), isTrue, reason: 'manca ${file.path}: dart run tool/revisione_traduzioni.dart');
        final righe = leggiCsv(file.readAsStringSync());
        expect([for (final r in righe.skip(1)) r.first], it.chiavi, reason: '${lingua.codice}: rigenera il foglio');
      }
    });
  });

  group('segnaposto e controlli, su ARB finti', () {
    final riferimento = _arb('it', {
      'saluto': 'Ciao {nome}',
      '@saluto': {'description': 'Saluto.', 'placeholders': {'nome': {'type': 'String'}}},
      'conta': '{n, plural, =0{Nessuno} =1{Uno} other{{n} persone}}',
      '@conta': {'placeholders': {'n': {'type': 'int'}}},
      'fisso': 'Va bene',
    });

    test('i rami di un plurale non sono segnaposto', () {
      expect(segnapostoNelTesto('{n, plural, =0{Palco, nessuna persona} =1{Palco, 1 persona} other{Palco, {n} persone}}'), {'n'});
      expect(segnapostoNelTesto('{nome}, sta parlando'), {'nome'});
      expect(segnapostoNelTesto('Nessun segnaposto'), isEmpty);
    });

    test('tutto coincide: nessun problema', () {
      final en = _arb('en', {'saluto': 'Hello {nome}', 'conta': '{n, plural, =0{Nobody} =1{One} other{{n} people}}', 'fisso': 'All good'});
      expect(verifica(riferimento, en), isEmpty);
    });

    test('un segnaposto diverso, o che manca, è un problema e dice quale chiave', () {
      final sbagliata = _arb('en', {'saluto': 'Hello {name}', 'conta': '{n, plural, other{{n} people}}', 'fisso': 'x'});
      final problemi = verifica(riferimento, sbagliata);
      expect(problemi, hasLength(1));
      expect(problemi.single, contains('saluto'));
      final senza = _arb('en', {'saluto': 'Hello', 'conta': '{n, plural, other{{n} people}}', 'fisso': 'x'});
      expect(verifica(riferimento, senza).single, contains('saluto'));
    });

    test('una chiave che manca o che è in più è un problema; la cella del foglio resta vuota', () {
      final en = _arb('en', {'saluto': 'Hello {nome}', 'fisso': 'x', 'extra': 'y'});
      final problemi = verifica(riferimento, en);
      expect(problemi.any((p) => p.contains('manca la chiave «conta»')), isTrue);
      expect(problemi.any((p) => p.contains('«extra»')), isTrue);
      final righe = leggiCsv(generaCsv(riferimento, en));
      expect(righe.length, 4, reason: 'una riga per chiave del riferimento, anche se manca');
      expect(righe.firstWhere((r) => r.first == 'conta')[3], isEmpty);
    });
  });

  group('il formato regge i testi difficili', () {
    test('punto e virgola, virgolette e a capo dentro un campo tornano uguali', () {
      final riferimento = _arb('it', {'k': 'a; b', '@k': {'description': 'Dice "così"; e va\na capo.'}});
      final en = _arb('en', {'k': 'x;y "z"\nw'});
      final csv = generaCsv(riferimento, en);
      final righe = leggiCsv(csv);
      expect(righe[1][1], 'Dice "così"; e va\na capo.');
      expect(righe[1][2], 'a; b');
      expect(righe[1][3], 'x;y "z"\nw');
      expect(righe[1].length, 8);
    });

    test('campo mette le virgolette solo dove servono', () {
      expect(campo('semplice'), 'semplice');
      expect(campo('a;b'), '"a;b"');
      expect(campo('dice "sì"'), '"dice ""sì"""');
    });
  });

  group('non perde le correzioni', () {
    late Directory cartella;
    setUp(() => cartella = Directory.systemTemp.createTempSync('revisione_'));
    tearDown(() => cartella.deleteSync(recursive: true));

    int esegui({bool forza = false}) => prepara(
          cartellaArb: _cartellaArb,
          cartellaUscita: cartella.path,
          nomeRiferimento: 'app_it.arb',
          forza: forza,
          log: (_) {},
          errori: (_) {},
        );

    test('una corsa scrive un file per lingua; due corse danno file identici', () {
      expect(esegui(), 0);
      final prima = {for (final f in cartella.listSync().whereType<File>()) f.path: f.readAsStringSync()};
      expect(prima.keys.map((p) => p.split(RegExp(r'[\\/]')).last).toList()..sort(), ['revisione-de.csv', 'revisione-en.csv', 'revisione-es.csv', 'revisione-fr.csv']);
      expect(esegui(), 0);
      expect({for (final f in cartella.listSync().whereType<File>()) f.path: f.readAsStringSync()}, prima);
    });

    test('un CSV con una correzione non si sovrascrive senza --forza, e con --forza sì', () {
      expect(esegui(), 0);
      final en = File('${cartella.path}/revisione-en.csv');
      final righe = leggiCsv(en.readAsStringSync());
      righe[1][righe.first.indexOf('correzione')] = 'The stage is empty.';
      en.writeAsStringSync('﻿${righe.map((r) => r.map(campo).join(separatore)).join('\r\n')}\r\n');
      expect(haCorrezioni(en.readAsStringSync()), isTrue);
      final scritto = en.readAsStringSync();

      expect(esegui(), 3, reason: 'file non sovrascritto');
      expect(en.readAsStringSync(), scritto, reason: 'le correzioni restano');
      expect(esegui(forza: true), 0);
      expect(haCorrezioni(en.readAsStringSync()), isFalse);
    });

    test('un CSV appena generato non ha correzioni', () {
      expect(haCorrezioni(generaCsv(it, _vero('en'))), isFalse);
    });
  });
}
