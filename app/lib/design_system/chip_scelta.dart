// BaChipScelta: un chip di tema o di lingua del DEN (Inventario C4, C3 di «Crea
// un DEN»). Un chip solo: il gruppo che va a capo lo compone chi lo usa con un
// `Wrap(spacing: BaCreazioneTokens.chipGap, runSpacing: BaCreazioneTokens.chipGap)`,
// così a testo grande la riga cresce e nessun chip si taglia.
//
// **Scelto non è mai il solo colore:** ha il bordo spesso e il SEGNO DI SPUNTA.
// La spunta non è un carattere («✓» dipenderebbe dal font, o da un font di
// ripiego): è un piccolo disegno di due tratti, uguale su ogni piattaforma.
//
// Per lo screen reader è un bottone `selected` quando è scelto. Il testo e
// l'etichetta arrivano dal chiamante.
//
// Valori che i token non hanno (segnalati nel report del task 022): le
// proporzioni della spunta, qui tre punti in frazione del suo lato (private,
// come furono quelle dei glifi prima di `BaGlifoTokens`); il lato della spunta è
// `BaSpazioTokens.l` e il suo tratto `BaCreazioneTokens.sceltaBordoScelta`.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';
import 'touchable.dart';

class BaChipScelta extends StatelessWidget {
  const BaChipScelta({
    super.key,
    required this.testo,
    required this.scelto,
    required this.onTap,
    this.semanticsLabel,
  });

  final String testo;
  final bool scelto;

  /// Nullo = inattivo.
  final VoidCallback? onTap;

  /// Se manca: [testo].
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: scelto,
      child: BaTouchable(
        semanticsLabel: semanticsLabel ?? testo,
        onTap: onTap,
        raggio: BaCreazioneTokens.chipRaggio,
        builder: (context, stato) => Container(
          constraints: const BoxConstraints(minHeight: BaCreazioneTokens.chipAltezza),
          padding: const EdgeInsets.symmetric(
            horizontal: BaSpazioTokens.xl,
            vertical: BaSpazioTokens.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BaCreazioneTokens.chipRaggio),
            border: Border.all(
              color: scelto ? BaColorTokens.azioneChiara : BaColorTokens.filettoMarcato,
              width: scelto ? BaCreazioneTokens.sceltaBordoScelta : BaCreazioneTokens.sceltaBordo,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (scelto) ...[
                const _Spunta(),
                const SizedBox(width: BaSpazioTokens.s),
              ],
              Flexible(
                child: Text(
                  testo,
                  style: BaTestoTokens.controllo.copyWith(
                    color: onTap == null ? BaColorTokens.testoInattivo : BaColorTokens.testoPrimo,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Il segno di spunta: due tratti, disegnati.
class _Spunta extends StatelessWidget {
  const _Spunta();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size.square(BaSpazioTokens.l),
      painter: _PittoreSpunta(),
    );
  }
}

class _PittoreSpunta extends CustomPainter {
  const _PittoreSpunta();

  // I tre punti della spunta, in frazione del lato: l'inizio del tratto corto,
  // il vertice in basso e la fine del tratto lungo.
  static const Offset _inizio = Offset(0.18, 0.54);
  static const Offset _vertice = Offset(0.42, 0.78);
  static const Offset _fine = Offset(0.84, 0.26);

  @override
  void paint(Canvas canvas, Size size) {
    final l = size.width;
    final spunta = Path()
      ..moveTo(_inizio.dx * l, _inizio.dy * l)
      ..lineTo(_vertice.dx * l, _vertice.dy * l)
      ..lineTo(_fine.dx * l, _fine.dy * l);
    canvas.drawPath(
      spunta,
      Paint()
        ..color = BaColorTokens.testoPrimo
        ..style = PaintingStyle.stroke
        ..strokeWidth = BaCreazioneTokens.sceltaBordoScelta
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_PittoreSpunta vecchio) => false;
}
