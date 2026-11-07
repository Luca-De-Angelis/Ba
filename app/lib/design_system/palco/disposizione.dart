import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../tokens.dart';

// La disposizione del palco come funzione pura: (persone, scatola) → diametro
// e centri. Niente stato, niente widget. Fonti: tokens.dart (BaPresenza),
// token.md T6 e T6 bis, inventario C6 e C7.

/// Quante presenze al massimo per riga, in funzione di quante persone ci sono
/// sul palco (indice = persone, 0 incluso). È la disposizione di riferimento
/// della baseline a 360 dp (T6 bis): 1 sola, 2 in diagonale, due per riga fino
/// a sei, tre per riga a sette e otto.
///
/// Il tetto si supera SOLO se serve a non ridurre il diametro (scatola larga e
/// bassa). Il layout tablet (task 004) lo cambia qui, in un punto solo.
const List<int> tettoPerRiga = [0, 1, 2, 2, 2, 2, 2, 3, 3];

/// Anello della voce: keyline 3 + tratto 2, dai token.
const double _anelloTotale = BaPresenza.anelloKeyline + BaPresenza.anelloTratto;

/// Crescita dell'anello al picco, in dp. NON è in tokens.dart (che la nomina
/// solo nei commenti): da portare lì con un task di design.
const double _crescitaAlPicco = 4;

/// Margine esterno di ogni presenza dentro la scatola, per lato: anello più
/// crescita al picco. Sono i 18 (2 × 9) della formula di T6 bis.
const double _margineEsterno = _anelloTotale + _crescitaAlPicco;

/// Tolleranza per i confronti fra misure in virgola mobile.
const double _eps = 1e-9;

/// Risultato di [disponiPalco].
class BaDisposizionePalco {
  const BaDisposizionePalco({
    required this.diametro,
    required this.centri,
    required this.sfora,
  });

  /// Diametro di ogni presenza, in dp. Mai sotto `BaPresenza.minimo`.
  final double diametro;

  /// Centri, relativi all'angolo in alto a sinistra della scatola, dall'alto in
  /// basso e da sinistra a destra: è l'ordine di lettura per lo screen reader.
  /// Il gruppo è centrato nella scatola: chi lo sposta può traslarlo senza
  /// ricalcolare.
  final List<Offset> centri;

  /// Vero se nemmeno a `BaPresenza.minimo` la disposizione entra nella scatola:
  /// nessuna presenza sparisce e nessuna distanza si stringe, si esce dai
  /// margini (su un asse, o su tutti e due se la scatola è minuscola).
  final bool sfora;

  @override
  String toString() =>
      'BaDisposizionePalco(diametro: $diametro, centri: $centri, sfora: $sfora)';
}

/// Dispone da 0 a 8 [persone] in [scatola].
///
/// Ordine in cui prova le opzioni:
///   1. diametro di partenza (`BaPresenza.diametro`), righe entro il tetto
///      [tettoPerRiga];
///   2. stesso diametro, tetto superato di una presenza per riga alla volta;
///   3. diametro ridotto in modo continuo fino a `BaPresenza.minimo`
///      (tetto superabile);
///   4. a `minimo` e ancora fuori: la disposizione più bassa, con `sfora`.
///
/// Fra le disposizioni che entrano sceglie la più bassa; a parità, quella con
/// la riga più larga in alto. Stesso input, stesso output.
///
/// Scatola: un lato infinito vale "spazio illimitato"; un lato negativo o NaN
/// lancia [ArgumentError]; un lato 0 dà `sfora` con la disposizione a `minimo`.
BaDisposizionePalco disponiPalco({
  required int persone,
  required Size scatola,
}) {
  if (persone < 0 || persone > 8) {
    throw ArgumentError.value(persone, 'persone', 'deve essere da 0 a 8');
  }
  final w = scatola.width;
  final h = scatola.height;
  if (w.isNaN || h.isNaN || w < 0 || h < 0) {
    throw ArgumentError.value(
        scatola, 'scatola', 'lati negativi o NaN non sono ammessi');
  }

  final base = BaPresenza.diametro(persone);
  if (persone == 0) {
    return BaDisposizionePalco(
        diametro: base, centri: const <Offset>[], sfora: false);
  }

  final subito = _migliore(persone, base, w, h);
  if (subito != null) return _costruisci(subito, base, w, h, sfora: false);

  const minimo = BaPresenza.minimo;
  if (_migliore(persone, minimo, w, h) == null) {
    final piuBassa = _migliore(persone, minimo, w, h, ignoraScatola: true)!;
    return _costruisci(piuBassa, minimo, w, h, sfora: true);
  }

  // Entra a `minimo`, non a `base`: bisezione. Se entra a d, entra a ogni d
  // più piccolo (ogni misura è lineare e positiva in d), quindi il risultato
  // è continuo e non cresce mai al restringersi della scatola.
  var entra = minimo;
  var nonEntra = base;
  for (var i = 0; i < 60; i++) {
    final medio = (entra + nonEntra) / 2;
    if (_migliore(persone, medio, w, h) != null) {
      entra = medio;
    } else {
      nonEntra = medio;
    }
  }
  return _costruisci(_migliore(persone, entra, w, h)!, entra, w, h,
      sfora: false);
}

// ---------------------------------------------------------------- interno

/// Una disposizione candidata, in coordinate locali: l'origine è il centro in
/// alto a sinistra del gruppo.
class _Candidata {
  _Candidata(this.righe, this.punti, this.corsaX, this.corsaY);

  final List<int> righe;
  final List<Offset> punti;
  final double corsaX; // distanza orizzontale fra i centri più esterni
  final double corsaY; // distanza verticale fra le righe estreme

  double altezza(double d) => corsaY + d + 2 * _margineEsterno;
}

_Candidata? _migliore(
  int n,
  double d,
  double w,
  double h, {
  bool ignoraScatola = false,
}) {
  final passo = BaPresenza.distanzaMinima(d);
  final corsa = w - d - 2 * _margineEsterno; // dove possono stare i centri
  if (corsa < -_eps && !ignoraScatola) return null;

  final int k;
  if (corsa < 0) {
    k = 1;
  } else if (corsa.isInfinite) {
    k = n;
  } else {
    k = math.min(n, (corsa / passo + _eps).floor() + 1);
  }

  // Prima entro il tetto, poi con una presenza in più per riga alla volta,
  // fino a k: il tetto si supera il meno possibile. Con `ignoraScatola`
  // solo la larghezza massima.
  final tetto = math.min(k, tettoPerRiga[n]);
  for (var kMax = ignoraScatola ? k : tetto; kMax <= k; kMax++) {
    final migliore = _cerca(n, kMax, d, passo, corsa, ignoraScatola ? null : h);
    if (migliore != null) return migliore;
  }
  return null;
}

/// Cerca la disposizione più bassa con righe da 1 a [kMax] presenze, righe
/// in qualunque numero e almeno una riga di [kMax] (si prova
/// ogni larghezza massima L, dalla più grande). Le righe con meno di L
/// presenze possono stare centrate o spostate di mezzo passo a sinistra o a
/// destra: togliendo una presenza da un'estremità di una riga si ottiene
/// sempre una disposizione ancora ammessa. Le righe da una sola presenza, se
/// L = 1, vanno a zigzag nella corsa che c'è: è la diagonale della coppia che
/// non sta affiancata.
///
/// L'altezza di ogni riga è la minima che dà distanza ≥ [passo] da tutti i
/// centri già posti: la distanza non si stringe mai. Con [h] non nullo si
/// scartano le disposizioni più alte di [h]. A parità di altezza (entro `_eps`)
/// vince quella con il baricentro orizzontale più vicino all'asse della
/// scatola, cioè la disposizione che non pende; a ulteriore parità, la prima
/// trovata (ordine fisso: riga più larga prima, centrata prima).
_Candidata? _cerca(
  int n,
  int kMax,
  double d,
  double passo,
  double corsa,
  double? h,
) {
  final extra = d + 2 * _margineEsterno;
  _Candidata? migliore;

  for (var larga = kMax; larga >= 1; larga--) {
    final zigzag = larga == 1 && n > 1;
    final corsaX = zigzag
        ? math.min(math.max(corsa, 0.0), passo)
        : (larga - 1) * passo;
    final righe = <int>[];
    final punti = <Offset>[];

    void riga(int resto, double yPrecedente, bool haLarga) {
      if (resto == 0) {
        if (!haLarga) return;
        final altezza = punti.last.dy + extra;
        final m = migliore;
        if (m == null ||
            altezza < m.altezza(d) - _eps ||
            (altezza <= m.altezza(d) + _eps &&
                _sbilanciamento(punti, corsaX) <
                    _sbilanciamento(m.punti, m.corsaX) - _eps)) {
          migliore = _Candidata(
              List.of(righe), List.of(punti), corsaX, punti.last.dy);
        }
        return;
      }
      final i = righe.length;
      for (var c = math.min(larga, resto); c >= 1; c--) {
        final spostamenti = c < larga && !zigzag ? const [0.0, -0.5, 0.5] : const [0.0];
        for (final s in spostamenti) {
          final xs = [
            for (var j = 0; j < c; j++)
              if (zigzag)
                (i.isEven ? 0.0 : corsaX)
              else
                corsaX / 2 + s * passo + (j - (c - 1) / 2) * passo,
          ];
          var y = 0.0;
          if (i > 0) {
            for (final p in punti) {
              for (final x in xs) {
                final dx = (x - p.dx).abs();
                final dy = dx < passo ? math.sqrt(passo * passo - dx * dx) : 0.0;
                y = math.max(y, p.dy + dy);
              }
            }
          }
          final altezza = y + extra;
          if (h != null && altezza > h + _eps) continue;
          if (migliore != null && altezza > migliore!.altezza(d) + _eps) {
            continue; // più alta della migliore: più righe non scendono
          }
          righe.add(c);
          for (final x in xs) {
            punti.add(Offset(x, y));
          }
          riga(resto - c, y, haLarga || c == larga);
          punti.length -= c;
          righe.removeLast();
        }
      }
    }

    riga(n, 0, false);
  }
  return migliore;
}

BaDisposizionePalco _costruisci(
  _Candidata c,
  double d,
  double w,
  double h, {
  required bool sfora,
}) {
  final ingombroX = c.corsaX + d + 2 * _margineEsterno;
  final ingombroY = c.altezza(d);
  // Centrato; con un lato infinito il gruppo parte dal bordo.
  final x0 = (w.isInfinite ? 0.0 : (w - ingombroX) / 2) + _margineEsterno + d / 2;
  final y0 = (h.isInfinite ? 0.0 : (h - ingombroY) / 2) + _margineEsterno + d / 2;

  final centri = [for (final p in c.punti) Offset(x0 + p.dx, y0 + p.dy)]
    ..sort((a, b) {
      final porY = a.dy.compareTo(b.dy);
      return porY != 0 ? porY : a.dx.compareTo(b.dx);
    });
  return BaDisposizionePalco(
    diametro: d,
    centri: List.unmodifiable(centri),
    sfora: sfora,
  );
}

/// Distanza del baricentro orizzontale dei [punti] dall'asse del gruppo
/// (`corsaX / 2`, che [_costruisci] porta sull'asse della scatola).
double _sbilanciamento(List<Offset> punti, double corsaX) {
  var somma = 0.0;
  for (final p in punti) {
    somma += p.dx;
  }
  return (somma / punti.length - corsaX / 2).abs();
}
