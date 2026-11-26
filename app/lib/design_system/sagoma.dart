// BaSagoma: la sagoma di una persona, la forma e la tinta della presenza **senza iniziali**
// (task 035). Era scritta a mano in quattro posti, identica a meno del lato: il gruppo
// d'attesa (`BaFasciaAttesa`), il pubblico (`BaPubblico`), la fila di sagome di `BaRigaDen` e
// la riga di una persona (`BaRigaPersona`). Ora il disegno è qui, uno solo.
//
// Un quadrato di [lato] con gli angoli di `BaSagomaTokens.bordo(sagoma, lato)` e il gradiente
// della tinta `BaTintaTokens.mazzo[tinta]`. Gli indici arrivano dal chiamante e si ricomincia
// da capo se sono più dei posti del mazzo (modulo), come per `BaPresenza`. Non è toccabile e
// non entra nella semantica: chi la usa la accompagna con un nome. Non dice nulla di dove sia
// la persona (D-052, 030): è solo l'immagine di chi c'è.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';

class BaSagoma extends StatelessWidget {
  const BaSagoma({super.key, required this.tinta, required this.sagoma, required this.lato});

  /// Gli indici nel mazzo di `BaTintaTokens` e di `BaSagomaTokens`, dal chiamante.
  final int tinta;
  final int sagoma;

  /// Il lato del quadrato, dai token di chi la usa (`BaPresenzaTokens.pubblico`, …).
  final double lato;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BaSagomaTokens.bordo(sagoma, lato),
        gradient: BaTintaTokens.mazzo[tinta % BaTintaTokens.mazzo.length].gradiente,
      ),
      child: SizedBox.square(dimension: lato),
    );
  }
}
