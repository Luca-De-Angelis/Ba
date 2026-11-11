// BaGlifo: il segno dentro il disco di una presenza (C3). Tre glifi, tutti
// barrati, tutti nello stesso disco in basso a destra (§7.17):
//   microfono    → microfono spento
//   altoparlante → voce mutata
//   bloccata     → cerchio barrato, persona bloccata
// Mai al centro della presenza: le iniziali non si coprono.
//
// «A due tratti come l'anello» (C7, §7.9): sotto il tratto chiaro della barra
// c'è un alone scuro, così il segno non dipende da ciò che c'è sotto. Fa
// eccezione il cerchio barrato, che nel prototipo (Stati critici 002) ha la
// barra del solo tratto, senza alone: l'anello non si interrompe.
//
// Geometria: tutte le proporzioni sono in `BaGlifoTokens` (consegna 012c: il
// microfono segue il prototipo del task 002, l'altoparlante e il cerchio sono
// confermati), in frazione del LATO del riquadro del glifo. Qui non ci sono
// numeri di design.
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
  /// piccolo di 28 (il disco cresce con la presenza, `badgeDiametro`). Nel disco
  /// è il lato misurato DENTRO il bordo: `badgeDiametro(d) − 2 × badgeBordo`.
  final double? lato;

  /// Colore del tratto chiaro e dell'alone scuro sotto la barra.
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

class _PittoreGlifo extends CustomPainter {
  const _PittoreGlifo(this.tipo, this.tratto, this.fondo);

  final BaTipoGlifo tipo;
  final Color tratto;
  final Color fondo;

  /// Da gradi (come nei token) a radianti.
  static double _rad(double gradi) => gradi * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final l = size.width;
    final linea = Paint()
      ..color = tratto
      ..style = PaintingStyle.stroke
      ..strokeWidth = BaGlifoTokens.tratto;
    final pieno = Paint()..color = tratto;

    // Lunghezza della barra e alone: microfono e altoparlante hanno la barra
    // lunga `barraLato` con l'alone; il cerchio ha la barra lunga quanto il suo
    // anello, che finisce sull'anello, e nessun alone (prototipo).
    final double barra;
    final bool alone;
    switch (tipo) {
      case BaTipoGlifo.microfono:
        _microfono(canvas, l, linea);
        barra = BaGlifoTokens.barraLato;
        alone = true;
      case BaTipoGlifo.altoparlante:
        _altoparlante(canvas, l, pieno, linea);
        barra = BaGlifoTokens.barraLato;
        alone = true;
      case BaTipoGlifo.bloccata:
        _cerchio(canvas, l, linea);
        barra = BaGlifoTokens.cerchioLato;
        alone = false;
    }
    _barra(canvas, l, barra * l, alone);
  }

  Rect _scala(double x, double y, double larghezza, double altezza, double l) =>
      Rect.fromLTWH(x * l, y * l, larghezza * l, altezza * l);

  void _microfono(Canvas canvas, double l, Paint linea) {
    // Il bordo CSS sta dentro il riquadro: il tratto va a metà spessore.
    final mezzo = BaGlifoTokens.tratto / 2;
    // Capsula: tutta rotonda.
    final c = _scala(BaGlifoTokens.capsulaX, BaGlifoTokens.capsulaY, BaGlifoTokens.capsulaL,
            BaGlifoTokens.capsulaA, l)
        .deflate(mezzo);
    canvas.drawRRect(RRect.fromRectAndRadius(c, Radius.circular(c.shortestSide / 2)), linea);
    // Culla: senza il lato alto, rotonda in basso (semicerchio).
    final u = _scala(BaGlifoTokens.cullaX, BaGlifoTokens.cullaY, BaGlifoTokens.cullaL,
            BaGlifoTokens.cullaA, l)
        .deflate(mezzo);
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
    // Stelo: centrato, largo quanto il tratto.
    canvas.drawLine(
      Offset(l / 2, BaGlifoTokens.steloY * l),
      Offset(l / 2, (BaGlifoTokens.steloY + BaGlifoTokens.steloA) * l),
      linea,
    );
  }

  void _altoparlante(Canvas canvas, double l, Paint pieno, Paint linea) {
    // Corpo: rettangolo pieno.
    canvas.drawRect(
      _scala(BaGlifoTokens.corpoX, BaGlifoTokens.corpoY, BaGlifoTokens.corpoL,
          BaGlifoTokens.corpoA, l),
      pieno,
    );
    // Cono: trapezio pieno nel suo riquadro. A sinistra il lato stretto, alto
    // `conoBocca` dell'altezza e centrato; a destra l'altezza intera.
    final cono = _scala(BaGlifoTokens.conoX, BaGlifoTokens.conoY, BaGlifoTokens.conoL,
        BaGlifoTokens.conoA, l);
    final margine = cono.height * (1 - BaGlifoTokens.conoBocca) / 2;
    canvas.drawPath(
      Path()
        ..moveTo(cono.left, cono.top + margine)
        ..lineTo(cono.right, cono.top)
        ..lineTo(cono.right, cono.bottom)
        ..lineTo(cono.left, cono.bottom - margine)
        ..close(),
      pieno,
    );
    // Onde: due archi a tratto, con il centro al bordo destro del cono.
    final centro = Offset(BaGlifoTokens.ondeCentroX * l, l / 2);
    for (final raggio in [BaGlifoTokens.ondaInternaRaggio, BaGlifoTokens.ondaEsternaRaggio]) {
      canvas.drawArc(
        Rect.fromCircle(center: centro, radius: raggio * l),
        -_rad(BaGlifoTokens.ondeGradi),
        2 * _rad(BaGlifoTokens.ondeGradi),
        false,
        linea,
      );
    }
  }

  void _cerchio(Canvas canvas, double l, Paint linea) {
    // Anello nel suo riquadro: il tratto sta dentro, come il bordo CSS.
    final lato = BaGlifoTokens.cerchioLato * l;
    final r = Rect.fromCenter(center: Offset(l / 2, l / 2), width: lato, height: lato)
        .deflate(BaGlifoTokens.tratto / 2);
    canvas.drawCircle(r.center, r.width / 2, linea);
  }

  /// La barra diagonale, lunga [lunghezza] e centrata, a `barraGradi`. Con
  /// [alone] il tratto chiaro sta sopra un alone scuro di `barraAlone`. Estremi
  /// a capo piatto, come nel prototipo.
  void _barra(Canvas canvas, double l, double lunghezza, bool alone) {
    canvas.save();
    canvas.translate(l / 2, l / 2);
    canvas.rotate(_rad(BaGlifoTokens.barraGradi));
    final da = Offset(-lunghezza / 2, 0);
    final a = Offset(lunghezza / 2, 0);
    if (alone) {
      canvas.drawLine(
        da,
        a,
        Paint()
          ..color = fondo
          ..style = PaintingStyle.stroke
          ..strokeWidth = BaGlifoTokens.barraAlone,
      );
    }
    canvas.drawLine(
      da,
      a,
      Paint()
        ..color = tratto
        ..style = PaintingStyle.stroke
        ..strokeWidth = BaGlifoTokens.tratto,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PittoreGlifo vecchio) =>
      vecchio.tipo != tipo || vecchio.tratto != tratto || vecchio.fondo != fondo;
}
