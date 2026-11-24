// BaAlone: l'alone dietro il palco (task 029, Inventario C2): l'unica sorgente
// di luce della stanza e l'unica profondità dell'app (token.md T7: niente ombre).
// Acceso o spento (linea persa, ingresso): spento non disegna niente.
//
// Un gradiente radiale da `fondoAlone` a trasparente, centrato a metà larghezza
// e al 42 % dell'altezza, `closest-side`. **Nessuna animazione:** lo sfondo non
// anima, non pulsa, non respira (T8). Riempie il genitore, quindi si mette in uno
// `Stack` dietro il palco; non riceve tocchi e non è nella semantica.
//
// Valori che i token non hanno (segnalati nel report del task 029): la geometria
// del gradiente (il 42 % e il raggio stanno solo nel commento di `fondoAlone`):
// due costanti private di questo file.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';

class BaAlone extends StatelessWidget {
  const BaAlone({super.key, this.acceso = true});

  /// Spento (linea persa, ingresso): niente.
  final bool acceso;

  // Il centro verticale (42 %) e il raggio (la metà del lato più corto:
  // `closest-side` per un genitore più alto che largo).
  static const double _centroVerticale = 0.42;
  static const double _raggio = 0.5;

  @override
  Widget build(BuildContext context) {
    if (!acceso) return const SizedBox.shrink();
    return IgnorePointer(
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, 2 * _centroVerticale - 1),
              radius: _raggio,
              colors: [BaColorTokens.fondoAlone, BaColorTokens.fondoAlone.withAlpha(0)],
            ),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
