// BaRitratto: quello che sta dentro la sagoma di una presenza. Un'immagine, le
// iniziali o la sagoma nuda (C1). Riempie la scatola che riceve: la forma la
// ritaglia chi lo contiene (BaPresenza).
//
// Stati (C1):
//   in carico  → le iniziali (o la sagoma nuda): l'immagine le sostituisce al
//                primo frame, senza dissolvenza (T8: le presenze "ci sono o non
//                ci sono"). Proposta del task 010, non scritta nei documenti.
//   caricata   → l'immagine, con il velo `veloImmagine` (tetto di luminanza, T6 ter)
//   fallita    → le iniziali
//   assente    → le iniziali
// Sotto i 32 dp (BaPresenzaTokens.minimo) non c'è nessuna iniziale: resta la
// sola sagoma (T6).
import 'package:flutter/widgets.dart';

import 'tokens.dart';

class BaRitratto extends StatelessWidget {
  const BaRitratto({
    super.key,
    required this.diametro,
    this.iniziali,
    this.immagine,
  });

  /// Il diametro della sagoma che lo contiene: decide la taglia delle iniziali.
  final double diametro;

  /// Le iniziali, già ricavate dal nome. Le iniziali non sono la
  /// rappresentazione accessibile: la semantica la dà BaPresenza.
  final String? iniziali;

  /// L'immagine, se c'è. Nessuna rete qui: la fornisce il chiamante.
  final ImageProvider? immagine;

  /// Le iniziali, o niente: sotto i 32 dp lo stile non esiste e non si scrive.
  Widget? _scritta() {
    final stile = BaTestoTokens.iniziali(diametro);
    final testo = iniziali;
    if (stile == null || testo == null || testo.isEmpty) return null;
    return ExcludeSemantics(
      child: Center(
        child: Text(
          testo,
          style: stile,
          maxLines: 1,
          softWrap: false,
          // Un ritratto non scala col testo di sistema (BaScalaTokens.iniziali).
          textScaler: TextScaler.noScaling,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scritta = _scritta() ?? const SizedBox.shrink();
    final immagine = this.immagine;
    if (immagine == null) return SizedBox.expand(child: scritta);

    return SizedBox.expand(
      child: Image(
        image: immagine,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        // In carico: iniziali. Al primo frame (o subito, se già in cache)
        // arriva l'immagine, col velo.
        frameBuilder: (context, figlio, frame, sincrona) {
          if (frame == null && !sincrona) return scritta;
          return Stack(
            fit: StackFit.expand,
            children: [
              figlio,
              const ColoredBox(color: BaColorTokens.veloImmagine),
            ],
          );
        },
        // Fallita: iniziali.
        errorBuilder: (context, errore, traccia) => scritta,
      ),
    );
  }
}
