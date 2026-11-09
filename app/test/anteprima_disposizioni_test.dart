// Anteprima delle disposizioni del palco: strumento di lavoro, non un controllo.
//
// Rigenera design/handoff/005/disposizioni.svg (dalla cartella app/):
//
//   GENERA_ANTEPRIMA=1 flutter test test/anteprima_disposizioni_test.dart
//
// (PowerShell: $env:GENERA_ANTEPRIMA=1; flutter test test/anteprima_disposizioni_test.dart)
//
// Senza la variabile il test non scrive nulla: controlla solo che il disegno
// si costruisca. Non tocca disposizione.dart.
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/palco/disposizione.dart';

// (larghezza dello schermo, scatola): telefono 360; tablet 744 con scatola 680 × 520 e 680 × 300.
const _righe = <(double, Size)>[
  (360, Size(320, 420)),
  (744, Size(680, 520)),
  (744, Size(680, 300)),
];
const _intervallo = 24.0; // spazio fra i riquadri
const _intestazione = 28.0; // altezza della scritta sopra ogni riquadro

String _numero(double v) => v.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');

String _disegno() {
  final larghezzaCella = _righe.map((r) => r.$2.width).reduce((a, b) => a > b ? a : b);
  final altezzaCella = _righe.map((r) => r.$2.height).reduce((a, b) => a > b ? a : b);
  const colonne = 8;
  final totaleW = colonne * (larghezzaCella + _intervallo) + _intervallo;
  final totaleH = _righe.length * (altezzaCella + _intestazione + _intervallo) + _intervallo;

  final b = StringBuffer()
    ..writeln('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${_numero(totaleW)} ${_numero(totaleH)}" font-family="sans-serif">')
    ..writeln('<rect width="100%" height="100%" fill="#ffffff"/>');

  for (var r = 0; r < _righe.length; r++) {
    final (schermo, scatola) = _righe[r];
    final y0 = _intervallo + r * (altezzaCella + _intestazione + _intervallo);
    for (var n = 1; n <= colonne; n++) {
      final x0 = _intervallo + (n - 1) * (larghezzaCella + _intervallo);
      final d = disponiPalco(persone: n, scatola: scatola, larghezzaSchermo: schermo);
      final colore = d.sfora ? '#c0392b' : '#444444';
      b.writeln('<text x="${_numero(x0)}" y="${_numero(y0 + 18)}" font-size="16" fill="#222222">'
          '$n · schermo ${_numero(schermo)} · ${_numero(scatola.width)}×${_numero(scatola.height)} · d=${_numero(d.diametro)}'
          '${d.sfora ? ' · sfora' : ''}</text>');
      b.writeln('<rect x="${_numero(x0)}" y="${_numero(y0 + _intestazione)}" '
          'width="${_numero(scatola.width)}" height="${_numero(scatola.height)}" '
          'fill="none" stroke="$colore" stroke-width="1"/>');
      for (var i = 0; i < d.centri.length; i++) {
        final c = d.centri[i];
        final cx = x0 + c.dx, cy = y0 + _intestazione + c.dy;
        b.writeln('<circle cx="${_numero(cx)}" cy="${_numero(cy)}" r="${_numero(d.diametro / 2)}" '
            'fill="#dfe6ee" stroke="$colore" stroke-width="1"/>');
        b.writeln('<text x="${_numero(cx)}" y="${_numero(cy)}" font-size="${_numero(d.diametro * 0.3 < 12 ? 12 : d.diametro * 0.3)}" '
            'text-anchor="middle" dominant-baseline="central" fill="#222222">${i + 1}</text>');
      }
    }
  }
  b.writeln('</svg>');
  return b.toString();
}

void main() {
  test('il disegno si costruisce: 3 righe × 8 riquadri, un cerchio per presenza', () {
    final svg = _disegno();
    // 24 rettangoli di scatola + lo sfondo; 3 × (1+2+…+8) cerchi.
    expect(RegExp('<rect ').allMatches(svg).length, 1 + 24);
    expect(RegExp('<circle ').allMatches(svg).length, 3 * 36);
  });

  test(
    'scrive design/handoff/005/disposizioni.svg',
    () {
      final file = File('${Directory.current.parent.path}/design/handoff/005/disposizioni.svg');
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(_disegno());
      expect(file.existsSync(), isTrue);
    },
    skip: Platform.environment['GENERA_ANTEPRIMA'] == null
        ? 'solo con GENERA_ANTEPRIMA=1 (vedi in cima al file)'
        : false,
  );
}
