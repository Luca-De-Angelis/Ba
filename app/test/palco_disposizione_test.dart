import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/palco/disposizione.dart';
import 'package:ba/design_system/tokens.dart';

const _eps = 1e-6;
const _margine = 9.0; // anello 5 + crescita al picco 4

/// Quante presenze per riga, dall'alto in basso.
List<int> _righe(List<Offset> centri) {
  final righe = <double, int>{};
  for (final c in centri) {
    final chiave = righe.keys.firstWhere(
      (y) => (y - c.dy).abs() < _eps,
      orElse: () => c.dy,
    );
    righe[chiave] = (righe[chiave] ?? 0) + 1;
  }
  return righe.values.toList();
}

double _distanzaMinima(List<Offset> c) {
  var minima = double.infinity;
  for (var i = 0; i < c.length; i++) {
    for (var j = i + 1; j < c.length; j++) {
      minima = math.min(minima, (c[i] - c[j]).distance);
    }
  }
  return minima;
}

void _dentro(BaDisposizionePalco r, Size s) {
  final raggio = r.diametro / 2;
  for (final c in r.centri) {
    expect(c.dx - raggio, greaterThanOrEqualTo(_margine - _eps));
    expect(c.dx + raggio, lessThanOrEqualTo(s.width - _margine + _eps));
    expect(c.dy - raggio, greaterThanOrEqualTo(_margine - _eps));
    expect(c.dy + raggio, lessThanOrEqualTo(s.height - _margine + _eps));
  }
}

void main() {
  const base = Size(320, 420);

  group('persone e scatola ammesse', () {
    test('0 persone: nessun centro', () {
      final r = disponiPalco(persone: 0, scatola: base);
      expect(r.centri, isEmpty);
      expect(r.sfora, isFalse);
    });

    test('fuori da 0–8: ArgumentError', () {
      expect(() => disponiPalco(persone: -1, scatola: base), throwsArgumentError);
      expect(() => disponiPalco(persone: 9, scatola: base), throwsArgumentError);
    });

    test('lati negativi o NaN: ArgumentError', () {
      expect(() => disponiPalco(persone: 3, scatola: const Size(-1, 400)),
          throwsArgumentError);
      expect(() => disponiPalco(persone: 3, scatola: const Size(300, -1)),
          throwsArgumentError);
      expect(() => disponiPalco(persone: 3, scatola: const Size(double.nan, 400)),
          throwsArgumentError);
    });

    test('lato 0 (Size.zero): sfora, 32, nessun errore, nessuno sparisce', () {
      final r = disponiPalco(persone: 5, scatola: Size.zero);
      expect(r.sfora, isTrue);
      expect(r.diametro, BaPresenza.minimo);
      expect(r.centri, hasLength(5));
    });

    test('lato infinito = spazio illimitato: diametro di partenza, tetto per riga', () {
      for (final s in const [
        Size.infinite,
        Size(double.infinity, 420),
        Size(320, double.infinity),
      ]) {
        for (var n = 1; n <= 8; n++) {
          final r = disponiPalco(persone: n, scatola: s);
          expect(r.sfora, isFalse);
          expect(r.centri, hasLength(n));
          expect(r.centri.every((c) => c.dx.isFinite && c.dy.isFinite), isTrue);
          if (s.width.isFinite) {
            expect(r.diametro, BaPresenza.diametro(n), reason: '$n in $s');
          }
        }
      }
    });
  });

  group('scatola 320 × 420 (baseline 360 dp)', () {
    test('1 persona: 208, riga da 226 dp, centrata', () {
      final r = disponiPalco(persone: 1, scatola: base);
      expect(r.diametro, 208);
      expect(r.centri, hasLength(1));
      expect(r.centri.single.dx, closeTo(160, _eps));
      expect(r.centri.single.dx - 104 - _margine, closeTo(47, _eps)); // (320−226)/2
      expect(r.centri.single.dy, closeTo(210, _eps));
    });

    test('2 persone: 156, non affiancate (347 dp non ci stanno), in diagonale', () {
      final r = disponiPalco(persone: 2, scatola: base);
      expect(r.diametro, 156);
      expect(_righe(r.centri), [1, 1]);
      final a = r.centri[0], b = r.centri[1];
      expect(a.dx, lessThan(b.dx)); // in diagonale: sinistra in alto, destra in basso
      expect(b.dy, greaterThan(a.dy));
      expect((b - a).distance, greaterThanOrEqualTo(173 - _eps));
      _dentro(r, base);
    });

    test('3 e 4 persone: 130, due per riga (295 dp)', () {
      for (final n in [3, 4]) {
        final r = disponiPalco(persone: n, scatola: base);
        expect(r.diametro, 130, reason: '$n');
        expect(_righe(r.centri).reduce(math.max), 2, reason: '$n');
        _dentro(r, base);
      }
      expect(_righe(disponiPalco(persone: 4, scatola: base).centri), [2, 2]);
    });

    test('5 e 6 persone: 112, due per riga, mai tre (388 dp)', () {
      for (final n in [5, 6]) {
        final r = disponiPalco(persone: n, scatola: base);
        expect(r.diametro, 112, reason: '$n');
        expect(_righe(r.centri).reduce(math.max), 2, reason: '$n');
        _dentro(r, base);
      }
    });

    test('7 e 8 persone: 88, nessuna riga oltre 3 e almeno una da 3 (316 dp)', () {
      for (final n in [7, 8]) {
        final r = disponiPalco(persone: n, scatola: base);
        final righe = _righe(r.centri);
        expect(r.diametro, 88, reason: '$n');
        expect(righe.reduce(math.max), 3, reason: '$n $righe');
        _dentro(r, base);
      }
    });
  });

  group('tetto per riga', () {
    test('scatola larga e bassa (744 × 280, 6 persone): il tetto si supera per tenere il diametro', () {
      const s = Size(744, 280);
      final r = disponiPalco(persone: 6, scatola: s);
      expect(r.diametro, 112);
      expect(_righe(r.centri).reduce(math.max), 3);
      expect(r.sfora, isFalse);
      _dentro(r, s);
    });

    test('scatola larga e alta (744 × 420, 6 persone): il tetto è rispettato', () {
      const s = Size(744, 420);
      final r = disponiPalco(persone: 6, scatola: s);
      expect(r.diametro, 112);
      expect(_righe(r.centri).reduce(math.max), tettoPerRiga[6]);
      _dentro(r, s);
    });

    test('con il tetto rispettato nessun conteggio supera la tabella a 744 × 600', () {
      for (var n = 1; n <= 8; n++) {
        final r = disponiPalco(persone: n, scatola: const Size(744, 600));
        expect(_righe(r.centri).reduce(math.max), lessThanOrEqualTo(tettoPerRiga[n]));
        expect(r.diametro, BaPresenza.diametro(n));
      }
    });
  });

  group('proprietà su larghezze 300, 320, 360, 480, 744', () {
    test('distanze ≥ d + 17, dentro con 9 dp di margine, identico a ogni chiamata', () {
      for (final largh in [300.0, 320.0, 360.0, 480.0, 744.0]) {
        final s = Size(largh, 420);
        for (var n = 1; n <= 8; n++) {
          final r = disponiPalco(persone: n, scatola: s);
          final motivo = '$n persone in $s';
          expect(r.sfora, isFalse, reason: motivo);
          expect(r.centri, hasLength(n), reason: motivo);
          if (n > 1) {
            expect(_distanzaMinima(r.centri),
                greaterThanOrEqualTo(BaPresenza.distanzaMinima(r.diametro) - _eps),
                reason: motivo);
          }
          _dentro(r, s);
          final diNuovo = disponiPalco(persone: n, scatola: s);
          expect(diNuovo.diametro, r.diametro, reason: motivo);
          expect(diNuovo.centri, r.centri, reason: motivo);
        }
      }
    });

    test('ordine di lettura: dall\'alto in basso, da sinistra a destra', () {
      for (var n = 1; n <= 8; n++) {
        final c = disponiPalco(persone: n, scatola: base).centri;
        for (var i = 1; i < c.length; i++) {
          final prima = c[i - 1], dopo = c[i];
          expect(
            prima.dy < dopo.dy - _eps || ((prima.dy - dopo.dy).abs() <= _eps && prima.dx < dopo.dx),
            isTrue,
            reason: '$n: $prima prima di $dopo',
          );
        }
      }
    });
  });

  group('il diametro non cresce', () {
    // Griglia di scatole: lati da 100 a 800 con passo 20.
    final lati = [for (var v = 100.0; v <= 800; v += 20) v];
    final tabella = {
      for (var n = 1; n <= 8; n++)
        n: [
          for (final w in lati)
            [for (final h in lati) disponiPalco(persone: n, scatola: Size(w, h)).diametro]
        ],
    };

    test('se la scatola si restringe', () {
      for (var n = 1; n <= 8; n++) {
        final t = tabella[n]!;
        for (var i = 0; i < lati.length; i++) {
          for (var j = 0; j < lati.length; j++) {
            if (i > 0) {
              expect(t[i - 1][j], lessThanOrEqualTo(t[i][j] + _eps),
                  reason: '$n persone, ${lati[i - 1]} × ${lati[j]} contro ${lati[i]} × ${lati[j]}');
            }
            if (j > 0) {
              expect(t[i][j - 1], lessThanOrEqualTo(t[i][j] + _eps),
                  reason: '$n persone, ${lati[i]} × ${lati[j - 1]} contro ${lati[i]} × ${lati[j]}');
            }
          }
        }
      }
    });

    test('se aumentano le persone', () {
      for (var n = 1; n < 8; n++) {
        for (var i = 0; i < lati.length; i++) {
          for (var j = 0; j < lati.length; j++) {
            expect(tabella[n + 1]![i][j], lessThanOrEqualTo(tabella[n]![i][j] + _eps),
                reason: '${n + 1} contro $n persone in ${lati[i]} × ${lati[j]}');
          }
        }
      }
    });
  });

  group('scatola piccola', () {
    test('otto persone in 150 × 150: non sfora, diametro ≥ 32', () {
      // Margine di soli 2 dp: a 32 dp tre per riga chiedono 2 × 49 + 32 + 18 = 148 dp su 150.
      const s = Size(150, 150);
      final r = disponiPalco(persone: 8, scatola: s);
      expect(r.sfora, isFalse);
      expect(r.diametro, greaterThanOrEqualTo(BaPresenza.minimo));
      expect(r.centri, hasLength(8));
      expect(_distanzaMinima(r.centri),
          greaterThanOrEqualTo(BaPresenza.distanzaMinima(r.diametro) - _eps));
      _dentro(r, s);
    });

    test('più piccola del minimo: sfora, 32, nessun centro in meno, distanze intatte', () {
      for (final s in const [Size(100, 100), Size(150, 100), Size(30, 600), Size(600, 30)]) {
        final r = disponiPalco(persone: 8, scatola: s);
        expect(r.sfora, isTrue, reason: '$s');
        expect(r.diametro, BaPresenza.minimo, reason: '$s');
        expect(r.centri, hasLength(8), reason: '$s');
        expect(_distanzaMinima(r.centri),
            greaterThanOrEqualTo(BaPresenza.distanzaMinima(BaPresenza.minimo) - _eps),
            reason: '$s');
      }
    });
  });
}
