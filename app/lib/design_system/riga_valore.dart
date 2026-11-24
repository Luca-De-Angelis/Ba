// BaRigaValore: una riga con un'etichetta a sinistra e un valore a destra
// (task 023b, prototipo 014). Due usi, una forma sola:
//   - il riepilogo di «Crea un DEN» (C5): «Tipo · Privato», «Nome · Cena senza
//     fretta». Non è toccabile: è solo testo;
//   - le voci del menu «Gestisci» (G1): «Descrizione ›», «Co-amministratori ·
//     0 di 1», «Persone nel DEN ›». Toccabile, con un sottotitolo.
// `BaRigaAzione` non ha il posto per un valore e non si modifica: per questo una
// riga a parte.
//
// Senza [onTap] la riga è un testo (per lo screen reader un solo elemento, non un
// bottone: un elemento che sembra un controllo e non lo è sarebbe una bugia).
// Con [onTap] è un bottone e, **se non ha un valore, mostra una freccia**
// disegnata (due tratti, come la spunta di `BaChipScelta`: non il carattere «›»,
// che dipenderebbe dal font). Con un valore («0 di 1») la freccia non c'è, come
// nel prototipo.
//
// Etichetta e valore vanno a capo come il `flex-wrap` del prototipo: a testo
// grande o con un nome lungo il valore scende sotto l'etichetta, nulla si taglia.
//
// Valori che i token non hanno (segnalati nel report del task 023b): l'altezza
// minima (48 nel prototipo: uso `BaControlloTokens.coppia`, stesso valore) e la
// distanza fra etichetta e sottotitolo.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';
import 'touchable.dart';

class BaRigaValore extends StatelessWidget {
  const BaRigaValore({
    super.key,
    required this.etichetta,
    this.valore,
    this.sottotitolo,
    this.onTap,
    this.semanticsLabel,
  });

  final String etichetta;

  /// Il valore, già composto dal chiamante («Privato», «0 di 1»).
  final String? valore;

  /// Una frase sotto l'etichetta, in secondo piano.
  final String? sottotitolo;

  /// Nullo = la riga è solo testo.
  final VoidCallback? onTap;

  /// Se manca: etichetta, sottotitolo e valore, uno di seguito all'altro.
  final String? semanticsLabel;

  bool get _toccabile => onTap != null;

  @override
  Widget build(BuildContext context) {
    final parole = semanticsLabel ?? [etichetta, ?sottotitolo, ?valore].join('. ');
    final contenuto = _Contenuto(
      etichetta: etichetta,
      valore: valore,
      sottotitolo: sottotitolo,
      freccia: _toccabile && valore == null,
    );
    if (!_toccabile) {
      return Semantics(container: true, label: parole, excludeSemantics: true, child: contenuto);
    }
    return Semantics(
      container: true,
      child: BaTouchable(
        semanticsLabel: parole,
        onTap: onTap,
        raggio: 0,
        builder: (context, stato) => contenuto,
      ),
    );
  }
}

class _Contenuto extends StatelessWidget {
  const _Contenuto({
    required this.etichetta,
    required this.valore,
    required this.sottotitolo,
    required this.freccia,
  });

  final String etichetta;
  final String? valore;
  final String? sottotitolo;
  final bool freccia;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: BaControlloTokens.coppia,
        minWidth: double.infinity,
      ),
      padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.s),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BaColorTokens.filettoDivisorio)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: BaSpazioTokens.m,
            children: [
              Text(etichetta, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
              if (valore != null)
                Text(valore!, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoSecondo)),
              if (freccia) const _Freccia(),
            ],
          ),
          if (sottotitolo != null) ...[
            const SizedBox(height: BaSpazioTokens.xxs),
            Text(sottotitolo!, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
          ],
        ],
      ),
    );
  }
}

/// La freccia di una riga che apre qualcosa: due tratti, disegnati.
class _Freccia extends StatelessWidget {
  const _Freccia();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size.square(BaSpazioTokens.l),
      painter: _PittoreFreccia(),
    );
  }
}

class _PittoreFreccia extends CustomPainter {
  const _PittoreFreccia();

  // I tre punti, in frazione del lato: il tratto alto, la punta e il tratto basso.
  static const Offset _alto = Offset(0.38, 0.20);
  static const Offset _punta = Offset(0.68, 0.50);
  static const Offset _basso = Offset(0.38, 0.80);

  @override
  void paint(Canvas canvas, Size size) {
    final l = size.width;
    final freccia = Path()
      ..moveTo(_alto.dx * l, _alto.dy * l)
      ..lineTo(_punta.dx * l, _punta.dy * l)
      ..lineTo(_basso.dx * l, _basso.dy * l);
    canvas.drawPath(
      freccia,
      Paint()
        ..color = BaColorTokens.testoSecondo
        ..style = PaintingStyle.stroke
        ..strokeWidth = BaCreazioneTokens.sceltaBordoScelta
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_PittoreFreccia vecchio) => false;
}
