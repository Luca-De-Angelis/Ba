// BaTratteggio: il bordo tratteggiato che disegna un posto (task 022). Flutter
// non ha un bordo tratteggiato: qui il contorno di un rettangolo arrotondato si
// spezza in tratti e vuoti con `Path.computeMetrics()`. Lo condividono
// BaPuntoAggancio (il posto di ciò che non è deciso) e BaBandaPosto (la
// permanenza massima, in revisione). È un widget pubblico perché un painter
// privato non si condivide fra file.
//
// Il tratteggio dice «qui c'è un posto, non un'azione»: non è toccabile e non
// entra nella semantica.
//
// Valori che i token non hanno (segnalati nel report del task 022): la lunghezza
// del tratto e del vuoto — qui `BaSpazioTokens.xs` (6) e `xxs` (4) — e il colore
// del tratteggio, per il quale uso `ascoltoGruppoBordo`, la a32 che c'è già.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';

class BaTratteggio extends StatelessWidget {
  /// Il contorno intero, con gli angoli arrotondati.
  const BaTratteggio({
    super.key,
    this.raggio = BaRaggioTokens.riquadro,
    this.spessore = BaCreazioneTokens.aggancioBordo,
    this.colore = BaColorTokens.ascoltoGruppoBordo,
    this.child,
  }) : soloSopra = false;

  /// Solo il filetto in alto, tratteggiato: una riga che tiene il posto senza
  /// scatola (il «Quando» spento).
  const BaTratteggio.sopra({
    super.key,
    this.spessore = BaCreazioneTokens.aggancioBordo,
    this.colore = BaColorTokens.ascoltoGruppoBordo,
    this.child,
  })  : raggio = 0,
        soloSopra = true;

  /// Raggio degli angoli. `BaRaggioTokens.pillola` dà un contorno a stadio.
  final double raggio;

  /// Spessore del tratto.
  final double spessore;

  final Color colore;

  /// Disegna solo il lato in alto.
  final bool soloSopra;

  /// Ciò che sta dentro il bordo. Il bordo si disegna sopra, ai margini.
  final Widget? child;

  /// Lunghezza di un tratto e di un vuoto.
  static const double tratto = BaSpazioTokens.xs;
  static const double vuoto = BaSpazioTokens.xxs;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _PittoreTratteggio(
        raggio: raggio,
        spessore: spessore,
        colore: colore,
        soloSopra: soloSopra,
      ),
      child: child,
    );
  }
}

class _PittoreTratteggio extends CustomPainter {
  const _PittoreTratteggio({
    required this.raggio,
    required this.spessore,
    required this.colore,
    required this.soloSopra,
  });

  final double raggio;
  final double spessore;
  final Color colore;
  final bool soloSopra;

  @override
  void paint(Canvas canvas, Size size) {
    // Il tratto sta dentro il riquadro, come un bordo CSS: a metà spessore.
    final rettangolo = (Offset.zero & size).deflate(spessore / 2);
    if (soloSopra) {
      if (size.width <= 0) return;
    } else if (rettangolo.isEmpty) {
      return;
    }
    final contorno = Path();
    if (soloSopra) {
      contorno
        ..moveTo(0, spessore / 2)
        ..lineTo(size.width, spessore / 2);
    } else {
      contorno.addRRect(RRect.fromRectAndRadius(rettangolo, Radius.circular(raggio)));
    }

    final tratteggiato = Path();
    for (final metrica in contorno.computeMetrics()) {
      var da = 0.0;
      while (da < metrica.length) {
        final a = da + BaTratteggio.tratto;
        tratteggiato.addPath(
          metrica.extractPath(da, a > metrica.length ? metrica.length : a),
          Offset.zero,
        );
        da = a + BaTratteggio.vuoto;
      }
    }

    canvas.drawPath(
      tratteggiato,
      Paint()
        ..color = colore
        ..style = PaintingStyle.stroke
        ..strokeWidth = spessore,
    );
  }

  @override
  bool shouldRepaint(_PittoreTratteggio vecchio) =>
      vecchio.raggio != raggio ||
      vecchio.spessore != spessore ||
      vecchio.colore != colore ||
      vecchio.soloSopra != soloSopra;
}
