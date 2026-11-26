// Prepara il foglio di revisione delle traduzioni (task 035, D-045): da tutti i file ARB di
// `lib/l10n/`, **un file CSV per ogni lingua** diversa dal riferimento, da dare ai madrelingua.
// Dart puro (`dart:io`, `dart:convert`): nessuna dipendenza. Non scrive mai negli ARB.
//
// Da `app/`:   dart run tool/revisione_traduzioni.dart [--forza] [--arb DIR] [--out DIR]
//
// - La lingua di riferimento è `template-arb-file` di `l10n.yaml` (oggi `app_it.arb`); le altre
//   lingue sono i file `app_<codice>.arb` che trova in `lib/l10n/`: una lingua nuova genera il suo
//   file senza toccare lo script.
// - Una riga per chiave (quelle che non iniziano con `@`), nell'ordine del riferimento.
// - Colonne: chiave; contesto (la `description` di `@chiave`); italiano; la lingua; correzione
//   (vuota); nota (vuota); lunghezza (caratteri del testo della lingua); segnaposto (i nomi
//   dichiarati in `@chiave.placeholders` che il testo contiene, vuota se non ce ne sono).
// - Formato: UTF-8 con BOM, a capo CRLF, separatore «;» (Excel con le impostazioni italiane non
//   apre bene la virgola), campi fra virgolette doppie dove serve. Nessuna data: due corse sugli
//   stessi ARB danno file identici.
// - Controlli: una chiave che manca in una lingua lascia la cella vuota; segnaposto diversi da
//   quelli del riferimento sono un problema. Le due cose finiscono su stderr, e i segnaposto
//   diversi chiudono con codice 1.
// - **Non perde il lavoro**: se un CSV esistente ha celle `correzione` o `nota` piene, non lo
//   sovrascrive senza `--forza` (le correzioni vivono lì finché non si riportano negli ARB).
import 'dart:convert';
import 'dart:io';

/// I nomi delle lingue per la testata della colonna; per un codice nuovo vale il codice.
const _nomiLingue = {
  'de': 'tedesco',
  'en': 'inglese',
  'es': 'spagnolo',
  'fr': 'francese',
  'it': 'italiano',
  'pt': 'portoghese',
  'nl': 'olandese',
};

/// Il separatore dei campi: il punto e virgola, che Excel in italiano apre in colonne.
const separatore = ';';

const _bom = '﻿';
const _acapo = '\r\n';

/// Un ARB letto: il suo codice e il suo contenuto (testi e metadati).
class FileArb {
  FileArb(this.codice, this.contenuto);

  final String codice;
  final Map<String, dynamic> contenuto;

  /// Le chiavi dei testi, nell'ordine del file (i metadati `@…` non sono chiavi).
  List<String> get chiavi => [for (final k in contenuto.keys) if (!k.startsWith('@')) k];

  String? testo(String chiave) => contenuto[chiave] as String?;

  /// La descrizione di `@chiave`, o vuota.
  String descrizione(String chiave) {
    final meta = contenuto['@$chiave'];
    return meta is Map && meta['description'] is String ? meta['description'] as String : '';
  }

  /// I nomi dichiarati in `@chiave.placeholders`.
  List<String> segnaposto(String chiave) {
    final meta = contenuto['@$chiave'];
    final p = meta is Map ? meta['placeholders'] : null;
    return p is Map ? [for (final k in p.keys) k as String] : const [];
  }
}

/// I nomi in graffe di un testo ARB, come `{nome}` o `{n, plural, …}`: non i rami del plurale
/// (`=0{…}`, `other{…}`), che iniziano subito dopo una parola o un «=».
Set<String> segnapostoNelTesto(String testo) =>
    {for (final m in RegExp(r'(?<![\w=])\{(\w+)\s*[},]').allMatches(testo)) m.group(1)!};

/// Il codice lingua di un nome di file `app_<codice>.arb` (con `@@locale` se c'è).
String _codiceDa(String percorso, Map<String, dynamic> contenuto) {
  final locale = contenuto['@@locale'];
  if (locale is String && locale.isNotEmpty) return locale;
  final nome = percorso.split(RegExp(r'[\\/]')).last;
  return nome.replaceFirst(RegExp(r'^app_'), '').replaceFirst(RegExp(r'\.arb$'), '');
}

FileArb leggiArb(String percorso) {
  final contenuto = jsonDecode(File(percorso).readAsStringSync()) as Map<String, dynamic>;
  return FileArb(_codiceDa(percorso, contenuto), contenuto);
}

/// Il nome del file di riferimento da `l10n.yaml` (`template-arb-file`), o `app_it.arb`.
String arbDiRiferimento(String l10nYaml) {
  if (!File(l10nYaml).existsSync()) return 'app_it.arb';
  final m = RegExp(r'^template-arb-file:\s*(\S+)', multiLine: true).firstMatch(File(l10nYaml).readAsStringSync());
  return m?.group(1) ?? 'app_it.arb';
}

/// I problemi di una lingua rispetto al riferimento: chiavi che mancano o che sono in più,
/// segnaposto che non coincidono. Vuota = a posto.
List<String> verifica(FileArb riferimento, FileArb lingua) {
  final problemi = <String>[];
  final attese = riferimento.chiavi.toSet();
  for (final k in riferimento.chiavi) {
    final testo = lingua.testo(k);
    if (testo == null) {
      problemi.add('${lingua.codice}: manca la chiave «$k»');
      continue;
    }
    final richiesti = riferimento.segnaposto(k).toSet();
    final trovati = segnapostoNelTesto(testo);
    if (trovati.length != richiesti.length || !trovati.containsAll(richiesti)) {
      problemi.add('${lingua.codice}: «$k» ha segnaposto {${trovati.join(', ')}}, il riferimento {${richiesti.join(', ')}}');
    }
  }
  for (final k in lingua.chiavi) {
    if (!attese.contains(k)) problemi.add('${lingua.codice}: la chiave «$k» non c\'è nel riferimento');
  }
  return problemi;
}

/// Un campo CSV: fra virgolette se contiene il separatore, virgolette o a capo.
String campo(String valore) {
  if (!valore.contains(separatore) && !valore.contains('"') && !valore.contains('\n') && !valore.contains('\r')) return valore;
  return '"${valore.replaceAll('"', '""')}"';
}

/// Le colonne, nell'ordine.
List<String> intestazione(String codiceRiferimento, String codiceLingua) => [
      'chiave',
      'contesto',
      _nomiLingue[codiceRiferimento] ?? codiceRiferimento,
      '${_nomiLingue[codiceLingua] ?? codiceLingua} ($codiceLingua)',
      'correzione',
      'nota',
      'lunghezza',
      'segnaposto',
    ];

/// Il CSV di una lingua: BOM, testata e una riga per chiave del riferimento.
String generaCsv(FileArb riferimento, FileArb lingua) {
  final righe = <List<String>>[intestazione(riferimento.codice, lingua.codice)];
  for (final k in riferimento.chiavi) {
    final testo = lingua.testo(k) ?? '';
    final nelTesto = segnapostoNelTesto(testo);
    righe.add([
      k,
      riferimento.descrizione(k),
      riferimento.testo(k) ?? '',
      testo,
      '',
      '',
      '${testo.runes.length}',
      [for (final p in riferimento.segnaposto(k)) if (nelTesto.contains(p)) p].join(', '),
    ]);
  }
  return _bom + righe.map((r) => r.map(campo).join(separatore)).join(_acapo) + _acapo;
}

/// Legge un CSV generato da questo script: le righe, ognuna con i suoi campi.
List<List<String>> leggiCsv(String contenuto) {
  final testo = contenuto.startsWith(_bom) ? contenuto.substring(1) : contenuto;
  final righe = <List<String>>[];
  var riga = <String>[];
  final campoCorrente = StringBuffer();
  var tra = false;
  for (var i = 0; i < testo.length; i++) {
    final c = testo[i];
    if (tra) {
      if (c == '"') {
        if (i + 1 < testo.length && testo[i + 1] == '"') {
          campoCorrente.write('"');
          i++;
        } else {
          tra = false;
        }
      } else {
        campoCorrente.write(c);
      }
    } else if (c == '"') {
      tra = true;
    } else if (c == separatore) {
      riga.add(campoCorrente.toString());
      campoCorrente.clear();
    } else if (c == '\r' || c == '\n') {
      if (c == '\r' && i + 1 < testo.length && testo[i + 1] == '\n') i++;
      riga.add(campoCorrente.toString());
      campoCorrente.clear();
      righe.add(riga);
      riga = <String>[];
    } else {
      campoCorrente.write(c);
    }
  }
  if (campoCorrente.isNotEmpty || riga.isNotEmpty) {
    riga.add(campoCorrente.toString());
    righe.add(riga);
  }
  return righe;
}

/// Il CSV ha già una `correzione` o una `nota` scritta da un madrelingua?
bool haCorrezioni(String csv) {
  final righe = leggiCsv(csv);
  if (righe.isEmpty) return false;
  final testata = righe.first;
  final iCorrezione = testata.indexOf('correzione');
  final iNota = testata.indexOf('nota');
  for (final r in righe.skip(1)) {
    if (iCorrezione >= 0 && iCorrezione < r.length && r[iCorrezione].trim().isNotEmpty) return true;
    if (iNota >= 0 && iNota < r.length && r[iNota].trim().isNotEmpty) return true;
  }
  return false;
}

/// Scrive i CSV di tutte le lingue. Ritorna il codice di uscita: 0 a posto, 1 segnaposto che non
/// coincidono, 3 file non sovrascritti perché hanno già correzioni.
int prepara({required String cartellaArb, required String cartellaUscita, required String nomeRiferimento, bool forza = false, void Function(String)? log, void Function(String)? errori}) {
  final out = log ?? stdout.writeln;
  final err = errori ?? stderr.writeln;
  final file = Directory(cartellaArb)
      .listSync()
      .whereType<File>()
      .where((f) => RegExp(r'app_\w+\.arb$').hasMatch(f.path))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  final arb = [for (final f in file) leggiArb(f.path)];
  final rif = arb.where((a) => a.codice == _codiceDa(nomeRiferimento, const {})).firstOrNull;
  if (rif == null) {
    err('Non trovo il file di riferimento $nomeRiferimento in $cartellaArb');
    return 2;
  }
  Directory(cartellaUscita).createSync(recursive: true);
  var uscita = 0;
  for (final lingua in arb.where((a) => a.codice != rif.codice)) {
    final problemi = verifica(rif, lingua);
    for (final p in problemi) {
      err(p);
    }
    if (problemi.any((p) => !p.contains('manca la chiave'))) uscita = 1;
    final destinazione = File('$cartellaUscita/revisione-${lingua.codice}.csv');
    if (!forza && destinazione.existsSync() && haCorrezioni(destinazione.readAsStringSync())) {
      err('${destinazione.path}: ha già correzioni o note, non lo sovrascrivo (--forza per farlo)');
      if (uscita == 0) uscita = 3;
      continue;
    }
    destinazione.writeAsStringSync(generaCsv(rif, lingua), encoding: utf8);
    out('${destinazione.path}: ${rif.chiavi.length} chiavi');
  }
  return uscita;
}

void main(List<String> argomenti) {
  var cartellaArb = 'lib/l10n';
  var cartellaUscita = '../docs/traduzioni';
  var forza = false;
  for (var i = 0; i < argomenti.length; i++) {
    switch (argomenti[i]) {
      case '--forza':
        forza = true;
      case '--arb':
        cartellaArb = argomenti[++i];
      case '--out':
        cartellaUscita = argomenti[++i];
      default:
        stderr.writeln('Argomento sconosciuto: ${argomenti[i]}');
        exit(64);
    }
  }
  exit(prepara(
    cartellaArb: cartellaArb,
    cartellaUscita: cartellaUscita,
    nomeRiferimento: arbDiRiferimento('l10n.yaml'),
    forza: forza,
  ));
}
