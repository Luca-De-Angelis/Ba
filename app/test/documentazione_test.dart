// Tiene allineata la documentazione di handoff (task 025) al codice.
//
//   1. Ogni file di lib/design_system/ che definisce un componente compare in
//      docs/handoff/componenti.md, e ogni widget pubblico `Ba…` vi è nominato.
//   2. Ogni link relativo dei file di docs/handoff/ punta a un file che esiste.
//   3. L'indice di docs/handoff/README.md elenca tutti i file della cartella.
//
// Se aggiungi un componente senza aggiornare componenti.md, il test fallisce con
// il nome del file. Se un file di design_system/ non è un componente, va
// elencato fra gli esenti qui sotto, con il motivo.
//
// I test girano da app/ (come in CI): la documentazione sta in ../docs/handoff.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final Directory _handoff = Directory('../docs/handoff');
final Directory _designSystem = Directory('lib/design_system');

/// I file di docs/handoff/ che devono esserci, nell'ordine dell'indice.
const List<String> _attesi = [
  'README.md',
  'avvio.md',
  'architettura.md',
  'componenti.md',
  'schermate.md',
  'regole.md',
  'aperte.md',
  'produzione.md',
];

/// I file di lib/design_system/ che NON sono componenti, con il motivo.
/// Vale il percorso relativo a lib/design_system/.
const Map<String, String> _esenti = {
  'tokens.dart': 'i valori di design (e BaOra, BaPayloadStanza, BaRegole): non è un widget',
  'forma.dart': 'una funzione di geometria (ingrandisci): non è un widget',
  'palco/disposizione.dart': 'la funzione pura disponiPalco: diametro e centri, senza widget',
};

/// Un componente è una classe pubblica `Ba…` che estende un widget, oppure la
/// funzione che apre un foglio (`showBa…`).
final RegExp _classeWidget = RegExp(
  r'^class\s+(Ba\w+)\s+extends\s+(?:StatelessWidget|StatefulWidget|InheritedWidget|'
  r'SingleChildRenderObjectWidget|LeafRenderObjectWidget)',
  multiLine: true,
);
final RegExp _funzioneApri = RegExp(r'^Future<[^>]*>\s+(showBa\w+)\s*(?:<[^>]*>)?\(', multiLine: true);

/// Tutti i file .dart sotto lib/design_system/, con il percorso relativo.
Map<String, String> _sorgenti() {
  final radice = _designSystem.absolute.path.replaceAll('\\', '/');
  return {
    for (final f in _designSystem.listSync(recursive: true).whereType<File>())
      if (f.path.endsWith('.dart'))
        f.absolute.path.replaceAll('\\', '/').substring(radice.length + 1): f.readAsStringSync(),
  };
}

/// I nomi dei componenti definiti in un sorgente.
List<String> _componenti(String sorgente) => [
      for (final m in _classeWidget.allMatches(sorgente)) m.group(1)!,
      for (final m in _funzioneApri.allMatches(sorgente)) m.group(1)!,
    ];

/// I link relativi `](percorso)` di un file Markdown, fuori dai blocchi di codice.
List<String> _link(String markdown) {
  final fuoriDalCodice = StringBuffer();
  var dentro = false;
  for (final riga in markdown.split('\n')) {
    if (riga.trimLeft().startsWith('```')) {
      dentro = !dentro;
      continue;
    }
    if (!dentro) fuoriDalCodice.writeln(riga);
  }
  return [
    for (final m in RegExp(r'\]\(([^)\s]+)\)').allMatches(fuoriDalCodice.toString())) m.group(1)!,
  ];
}

bool _relativo(String link) =>
    !link.startsWith('http://') &&
    !link.startsWith('https://') &&
    !link.startsWith('mailto:') &&
    !link.startsWith('#');

void main() {
  test('la cartella docs/handoff/ c\'è, con gli otto file', () {
    expect(
      _handoff.existsSync(),
      isTrue,
      reason: 'docs/handoff/ non si trova: i test vanno lanciati da app/ (come in CI)',
    );
    for (final nome in _attesi) {
      expect(File('${_handoff.path}/$nome').existsSync(), isTrue, reason: 'manca docs/handoff/$nome');
    }
  });

  group('componenti', () {
    late final String doc;
    late final Map<String, String> sorgenti;

    setUpAll(() {
      doc = File('${_handoff.path}/componenti.md').readAsStringSync();
      sorgenti = _sorgenti();
    });

    test('ogni file di design_system/ è un componente o un esente dichiarato', () {
      final mancanti = <String>[];
      for (final MapEntry(key: file, value: sorgente) in sorgenti.entries) {
        final eComponente = _componenti(sorgente).isNotEmpty;
        if (!eComponente && !_esenti.containsKey(file)) mancanti.add(file);
      }
      expect(
        mancanti,
        isEmpty,
        reason: 'questi file di lib/design_system/ non definiscono un componente e non sono '
            'elencati fra gli esenti di questo test (con il motivo): $mancanti',
      );
    });

    test('gli esenti esistono e non sono componenti (l\'esenzione non nasconde niente)', () {
      for (final MapEntry(key: file, value: motivo) in _esenti.entries) {
        expect(sorgenti.containsKey(file), isTrue, reason: '$file è esente ($motivo) ma non esiste più');
        expect(_componenti(sorgenti[file]!), isEmpty, reason: '$file definisce un componente: non è esente');
      }
    });

    test('ogni file che definisce un componente compare in componenti.md', () {
      final assenti = <String>[
        for (final MapEntry(key: file, value: sorgente) in sorgenti.entries)
          if (_componenti(sorgente).isNotEmpty && !doc.contains(file)) file,
      ];
      expect(
        assenti,
        isEmpty,
        reason: 'aggiungi una riga in docs/handoff/componenti.md per: $assenti',
      );
    });

    test('ogni widget pubblico Ba… è nominato in componenti.md', () {
      final assenti = <String>[
        for (final sorgente in sorgenti.values)
          for (final nome in _componenti(sorgente))
            if (!doc.contains(nome)) nome,
      ];
      expect(assenti, isEmpty, reason: 'nominali in docs/handoff/componenti.md: $assenti');
    });

    test('il criterio trova i componenti che conosciamo (il test non è vuoto)', () {
      final trovati = {for (final s in sorgenti.values) ..._componenti(s)};
      expect(trovati, containsAll(['BaTouchable', 'BaPresenza', 'BaPalco', 'BaFoglio', 'showBaFoglio']));
      expect(trovati.length, greaterThanOrEqualTo(13));
    });
  });

  group('link', () {
    test('ogni link relativo dei file di docs/handoff/ punta a un file che esiste', () {
      final rotti = <String>[];
      var controllati = 0;
      for (final f in _handoff.listSync(recursive: true).whereType<File>()) {
        if (!f.path.endsWith('.md')) continue;
        for (final link in _link(f.readAsStringSync())) {
          if (!_relativo(link)) continue;
          final senzaAncora = link.split('#').first.split('?').first;
          if (senzaAncora.isEmpty) continue;
          controllati++;
          final destinazione = f.parent.absolute.uri.resolve(senzaAncora).toFilePath();
          if (FileSystemEntity.typeSync(destinazione) == FileSystemEntityType.notFound) {
            rotti.add('${f.uri.pathSegments.last} → $link');
          }
        }
      }
      expect(rotti, isEmpty, reason: 'link rotti: $rotti');
      expect(controllati, greaterThan(0), reason: 'nessun link controllato: il test non vede i file');
    });
  });

  group('indice', () {
    test('il README di docs/handoff/ elenca tutti i file della cartella', () {
      final indice = File('${_handoff.path}/README.md').readAsStringSync();
      final link = _link(indice).where(_relativo).map((l) => l.split('#').first).toSet();
      final presenti = [
        for (final f in _handoff.listSync().whereType<File>())
          if (f.path.endsWith('.md')) f.uri.pathSegments.last,
      ];
      for (final nome in presenti) {
        if (nome == 'README.md') continue;
        expect(link, contains(nome), reason: 'l\'indice del README non elenca $nome');
      }
    });

    test('i file indicizzati sono quelli attesi, e non ce ne sono di più', () {
      final presenti = [
        for (final f in _handoff.listSync().whereType<File>())
          if (f.path.endsWith('.md')) f.uri.pathSegments.last,
      ]..sort();
      expect(presenti, [..._attesi]..sort());
    });
  });
}
