// BaSegnoErrore: il segno «!» di un errore, un cerchio con un punto esclamativo (task 035).
// Era scritto due volte, uguale, in `BaFraseErrore` (campo_testo.dart: il campo e il codice) e
// in `BaMessaggio` (messaggio.dart); ora il disegno è qui, uno solo, e i due lo usano.
//
// Un cerchio di `erroreSegnoLato` con tratto `erroreSegnoTratto`, del colore dell'errore, e
// un «!» in 14/600. **Non scala col testo**: sta sull'altezza della prima riga. Dice l'errore
// anche senza il colore: mai il solo colore. Non è toccabile e non entra nella semantica: la
// frase accanto è quella che si annuncia (regione viva, la mette chi lo usa).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';

class BaSegnoErrore extends StatelessWidget {
  const BaSegnoErrore({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: BaColorTokens.erroreTesto,
          width: BaAccessoTokens.erroreSegnoTratto,
        ),
      ),
      child: SizedBox.square(
        dimension: BaAccessoTokens.erroreSegnoLato,
        child: Center(
          child: Text(
            '!',
            textScaler: TextScaler.noScaling,
            style: BaTestoTokens.azione.copyWith(
              color: BaColorTokens.erroreTesto,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
