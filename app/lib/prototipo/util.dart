// Piccoli aiuti del prototipo (task 024): una pillola con la sua etichetta, un'azione
// di foglio e una frase. Niente di nuovo rispetto al design system: scorciatoie per
// non ripetere gli stessi parametri in ogni pagina.
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/pillola.dart';
import '../design_system/tokens.dart';

/// Una pillola a tutta larghezza. [onTap] nullo = inattiva.
Widget pillola(String testo, VoidCallback? onTap, {BaVariantePillola variante = BaVariantePillola.attiva}) =>
    BaPillola(testo: testo, semanticsLabel: testo, variante: variante, onTap: onTap);

/// Un'azione ancorata di un foglio. Senza [variante], quella che il foglio dà.
BaAzioneFoglio azioneFoglio(String testo, VoidCallback? onTap, {BaVariantePillola? variante}) =>
    BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: onTap, variante: variante);

/// Una frase di una pagina: in secondo piano, o in primo piano ([evidenza]).
class Frase extends StatelessWidget {
  const Frase(this.testo, {super.key, this.evidenza = false, this.piccola = false});

  final String testo;
  final bool evidenza;
  final bool piccola;

  @override
  Widget build(BuildContext context) => Text(
        testo,
        style: (piccola ? BaTestoTokens.minore : BaTestoTokens.corpo).copyWith(
          color: evidenza ? BaColorTokens.testoPrimo : BaColorTokens.testoSecondo,
        ),
      );
}
