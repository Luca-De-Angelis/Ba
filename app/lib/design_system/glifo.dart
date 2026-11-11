// BaGlifo: il segno dentro il disco di una presenza (C3). Tre glifi, tutti
// barrati, tutti nello stesso disco in basso a destra (§7.17):
//   microfono   → microfono spento
//   altoparlante → voce mutata
//   bloccata    → cerchio barrato, persona bloccata
// Mai al centro della presenza: le iniziali non si coprono.
//
// «A due tratti come l'anello» (C7, §7.9): sotto il tratto chiaro della barra
// c'è un casing scuro, così il segno non dipende da ciò che c'è sotto.
//
// Geometria: il microfono viene dal prototipo del task 002 (Stati critici
// 002, `bGlifo`/`bFondo`), in percentuale del lato. L'altoparlante e il cerchio
// il prototipo non li disegna: le proporzioni sono una PROPOSTA del task 012,
// da confermare con Claude Design. Le percentuali stanno qui, come costanti
// con nome, perché tokens.dart non le ha (segnalato nel report).
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'tokens.dart';

/// Quale glifo.
enum BaTipoGlifo { microfono, altoparlante, bloccata }

class BaGlifo extends StatelessWidget {
  const BaGlifo({
    super.key,
    required this.tipo,
    this.acceso = false,
    this.ripiego = false,
    this.lato,
    this.tratto = BaColorTokens.glifoTratto,
    this.fondo = BaColorTokens.voceKeyline,
  }) : assert(!(ripiego && lato != null), 'ripiego e lato sono alternativi');

  final BaTipoGlifo tipo;

  /// Spento = opacità `glifoOpacitaSpento` (0,45); acceso = 1. Il passaggio dura
  /// `BaMovimentoTokens.glifo` (140 ms, lineare) e con «riduci movimento» è
  /// immediato.
  final bool acceso;

  /// Lato 32 (`glifoRipiego`) invece di 28 (`glifo`): solo se il chiamante lo
  /// chiede perché a 28 non si legge. Il glifo cresce, non si colora.
  final bool ripiego;

  /// Un lato diverso, per quando il glifo riempie un disco più grande o più
  /// piccolo di 28 (il disco cresce con la presenza, `badgeDiametro`).
  final double? lato;

  /// Colore del tratto chiaro e del casing scuro sotto la barra.
  final Color tratto;
  final Color fondo;

  @override
  Widget build(BuildContext context) {
    final dimensione =
        lato ?? (ripiego ? BaPresenzaTokens.glifoRipiego : BaPresenzaTokens.glifo);
    final riduci = MediaQuery.disableAnimationsOf(context);
    // Decorativo: l'etichetta la porta la presenza.
    return ExcludeSemantics(
      child: AnimatedOpacity(
        opacity: acceso ? 1 : BaPresenzaTokens.glifoOpacitaSpento,
        duration: riduci ? Duration.zero : BaMovimentoTokens.glifo,
        curve: Curves.linear,
        child: SizedBox.square(
          dimension: dimensione,
          child: CustomPaint(painter: _PittoreGlifo(tipo, tratto, fondo)),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------- proporzioni

/// Spessori: il tratto chiaro è quello dell'anello; il casing sotto la barra è
/// keyline + tratto, cioè la banda dell'anello (5).
const double _spessoreTratto = BaPresenzaTokens.anelloTratto;
const double _spessoreCasing = BaPresenzaTokens.anelloKeyline + BaPresenzaTokens.anelloTratto;

// La barra: x 8 %, larga 84 %, a metà altezza, ruotata di −45° (prototipo).
const double _barraX = 0.08;
const double _barraLarghezza = 0.84;
const double _barraAngolo = -math.pi / 4;

// Microfono, in % del lato (prototipo): capsula, culla, stelo.
const Rect _capsula = Rect.fromLTWH(0.36, 0.14, 0.28, 0.38);
const Rect _culla = Rect.fromLTWH(0.22, 0.32, 0.56, 0.30);
const double _steloY = 0.61;
const double _steloAltezza = 0.15;

// Altoparlante (proposta): corpo, cono, due onde.
const double _corpoX = 0.14;
const double _conoX = 0.30;
const double _bordoX = 0.50;
const double _corpoAlto = 0.38;
const double _corpoBasso = 0.62;
const double _conoAlto = 0.22;
const double _conoBasso = 0.78;
const List<double> _onde = [0.14, 0.26];
const double _ondaSemiapertura = 40 * math.pi / 180;

// Cerchio della bloccata (proposta): come la barra, 8 % di margine.
const Rect _cerchio = Rect.fromLTWH(0.08, 0.08, 0.84, 0.84);

class _PittoreGlifo extends CustomPainter {
  const _PittoreGlifo(this.tipo, this.tratto, this.fondo);

  final BaTipoGlifo tipo;
  final Color tratto;
  final Color fondo;

  @override
  void paint(Canvas canvas, Size size) {
    final l = size.width;
    final linea = Paint()
      ..color = tratto
      ..style = PaintingStyle.stroke
      ..strokeWidth = _spessoreTratto;

    switch (tipo) {
      case BaTipoGlifo.microfono:
        _microfono(canvas, l, linea);
      case BaTipoGlifo.altoparlante:
        _altoparlante(canvas, l, linea);
      case BaTipoGlifo.bloccata:
        // Il bordo CSS sta dentro il riquadro: il tratto va a metà spessore.
        final r = _scala(_cerchio, l).deflate(_spessoreTratto / 2);
        canvas.drawCircle(r.center, r.width / 2, linea);
    }
    _barra(canvas, l);
  }

  Rect _scala(Rect r, double l) =>
      Rect.fromLTWH(r.left * l, r.top * l, r.width * l, r.height * l);

  void _microfono(Canvas canvas, double l, Paint linea) {
    final mezzo = _spessoreTratto / 2;
    // Capsula: tutta rotonda.
    final c = _scala(_capsula, l).deflate(mezzo);
    canvas.drawRRect(RRect.fromRectAndRadius(c, Radius.circular(c.shortestSide / 2)), linea);
    // Culla: senza il lato alto, rotonda in basso (semicerchio).
    final u = _scala(_culla, l).deflate(mezzo);
    final raggio = u.width / 2;
    final culla = Path()
      ..moveTo(u.left, u.top)
      ..lineTo(u.left, u.bottom - raggio)
      ..arcTo(
        Rect.fromLTWH(u.left, u.bottom - 2 * raggio, u.width, 2 * raggio),
        math.pi,
        -math.pi,
        false,
      )
      ..lineTo(u.right, u.top);
    canvas.drawPath(culla, linea);
    // Stelo.
    canvas.drawLine(
      Offset(l / 2, _steloY * l),
      Offset(l / 2, (_steloY + _steloAltezza) * l),
      linea,
    );
  }

  void _altoparlante(Canvas canvas, double l, Paint linea) {
    final corpo = Path()
      ..moveTo(_corpoX * l, _corpoAlto * l)
      ..lineTo(_conoX * l, _corpoAlto * l)
      ..lineTo(_bordoX * l, _conoAlto * l)
      ..lineTo(_bordoX * l, _conoBasso * l)
      ..lineTo(_conoX * l, _corpoBasso * l)
      ..lineTo(_corpoX * l, _corpoBasso * l)
      ..close();
    canvas.drawPath(corpo, linea);
    for (final raggio in _onde) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(_bordoX * l, l / 2), radius: raggio * l),
        -_ondaSemiapertura,
        2 * _ondaSemiapertura,
        false,
        linea,
      );
    }
  }

  /// La barra diagonale, a due tratti: il casing scuro sotto, il tratto chiaro
  /// sopra. Estremi a capo piatto, come nel prototipo.
  void _barra(Canvas canvas, double l) {
    canvas.save();
    canvas.translate(l / 2, l / 2);
    canvas.rotate(_barraAngolo);
    final da = Offset((_barraX - 0.5) * l, 0);
    final a = Offset((_barraX + _barraLarghezza - 0.5) * l, 0);
    canvas.drawLine(
      da,
      a,
      Paint()
        ..color = fondo
        ..style = PaintingStyle.stroke
        ..strokeWidth = _spessoreCasing,
    );
    canvas.drawLine(
      da,
      a,
      Paint()
        ..color = tratto
        ..style = PaintingStyle.stroke
        ..strokeWidth = _spessoreTratto,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PittoreGlifo vecchio) =>
      vecchio.tipo != tipo || vecchio.tratto != tratto || vecchio.fondo != fondo;
}
