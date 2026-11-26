import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Testi neutri rispetto al genere grammaticale (task 032c, regola del glossario): l'interfaccia
// italiana non usa participi o aggettivi che dipendano dal genere di una persona nominata né di chi
// usa l'app. Questo test tiene fuori le forme che la scansione del 032 ha cambiato, in tutto ciò
// che mostra testo (prototipo, galleria, l10n italiano) e nei commenti che le citano. Non può
// trovare un participio nuovo: è una rete contro il ritorno delle frasi vecchie.
//
// I nomi di ruolo (ascoltatore, partecipante, co-amministratore) restano come sono: è una voce
// aperta del glossario.

/// Le frasi del «prima» della tabella «Scansione del genere» di `design/handoff/032/changelog.md`.
final _vietate = <String, RegExp>{
  '«Marta ti ha invitato» → «Invito di Marta»': RegExp(r'ti ha invitato'),
  '«Sei stato invitato» → «Hai un invito»': RegExp(r'Sei stato invitato'),
  '«è entrato nel DEN» → «In Famiglia c\'è Ciccio»': RegExp(r'è entrato nel DEN'),
  '«Sei entrato su invito» → «Sei dentro, su invito»': RegExp(r'Sei entrato'),
  '«Sei salito» → «Sei sul palco»': RegExp(r'Sei salito'),
  '«Sei uscito» → «Hai lasciato la coda»': RegExp(r'Sei uscito'),
  '«Ne sei sicuro?» → «Confermi?»': RegExp(r'Ne sei sicuro'),
  '«Non siamo riusciti» → «Non è stato possibile»': RegExp(r'Non siamo riusciti'),
  '«solo se invitato» → «solo su invito»': RegExp(r'solo se invitat'),
  '«✓ Aggiunta» → «✓ In lista»': RegExp('[\'"«]Aggiunta[\'"»:]'),
  '«persona bloccata» dopo il nome → «Persona bloccata: nome»': RegExp(r'\{nome\}, persona bloccata'),
};

Iterable<File> _sorgenti() sync* {
  for (final cartella in ['lib/prototipo', 'lib/galleria', 'lib/design_system']) {
    yield* Directory(cartella).listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  }
  yield File('lib/l10n/app_it.arb');
}

void main() {
  test('le frasi che dipendevano dal genere non ci sono più (prototipo, galleria, design system, l10n italiano)', () {
    final trovate = <String>[];
    for (final file in _sorgenti()) {
      final testo = file.readAsStringSync();
      for (final MapEntry(key: nome, value: regola) in _vietate.entries) {
        if (regola.hasMatch(testo)) trovate.add('${file.path}: $nome');
      }
    }
    expect(trovate, isEmpty, reason: trovate.join('\n'));
  });

  test('il test trova una frase vecchia (non è vuoto)', () {
    for (final regola in _vietate.values) {
      expect(_sorgenti(), isNotEmpty);
      expect(regola.hasMatch('x'), isFalse);
    }
    expect(_vietate['«Sei stato invitato» → «Hai un invito»']!.hasMatch('foglio «Sei stato invitato»'), isTrue);
    expect(_vietate['«✓ Aggiunta» → «✓ In lista»']!.hasMatch("azione: 'Aggiunta'"), isTrue);
    expect(_vietate['«✓ Aggiunta» → «✓ In lista»']!.hasMatch('BaVoceRigaPersona.aggiunta'), isFalse);
  });

  test('le altre lingue non cambiano il loro senso: stesse chiavi e stessi segnaposto in tutte e cinque', () {
    Map<String, dynamic> carica(String lingua) =>
        jsonDecode(File('lib/l10n/app_$lingua.arb').readAsStringSync()) as Map<String, dynamic>;
    final it = carica('it');
    final chiavi = [for (final k in it.keys) if (!k.startsWith('@')) k];
    expect(chiavi, isNotEmpty);
    // I segnaposto sono quelli dichiarati in @chiave nell'italiano (gli altri file non hanno i
    // metadati; le parentesi del plurale non sono segnaposto): devono comparire in ogni lingua.
    Set<String> dichiarati(String k) {
      final meta = it['@$k'] as Map<String, dynamic>?;
      return ((meta?['placeholders'] as Map<String, dynamic>?)?.keys ?? const <String>[]).toSet();
    }

    for (final lingua in ['it', 'de', 'en', 'es', 'fr']) {
      final arb = carica(lingua);
      expect([for (final k in arb.keys) if (!k.startsWith('@')) k], chiavi, reason: lingua);
      for (final k in chiavi) {
        for (final nome in dichiarati(k)) {
          expect(arb[k] as String, contains('{$nome'), reason: '$lingua · $k: manca il segnaposto $nome');
        }
      }
    }
  });
}
