// BaAzioniInCoppia: due pillole secondarie affiancate (hairline), oppure una
// sola centrata. Gli stati sono indipendenti: ognuna ha il suo BaTouchable.
//
// Le due pillole hanno la stessa altezza, quella della più alta (misurata con
// BaPillola.altezzaNecessaria).
//
// Aree toccabili: ogni pillola estende la propria area di mezzo gap verso la
// vicina, così le due si toccano nel mezzo del gap e non si sovrappongono (a
// 3 dp dal bordo della sinistra il tocco va a sinistra, a 7 dp a destra). Sugli
// altri lati l'estensione di `areaEstesa` vale solo dove il genitore la
// contiene: è il limite di BaTouchable (RenderBox.hitTest) e qui non si aggira
// con un padding, che sposterebbe le pillole.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'pillola.dart';
import 'tokens.dart';
import 'touchable.dart';

/// Una delle due azioni della coppia.
@immutable
class BaAzioneCoppia {
  const BaAzioneCoppia({
    required this.testo,
    required this.semanticsLabel,
    this.onTap,
  });

  final String testo;
  final String semanticsLabel;

  /// Nullo = inattiva.
  final VoidCallback? onTap;
}

class BaAzioniInCoppia extends StatelessWidget {
  const BaAzioniInCoppia({super.key, required this.prima, this.seconda});

  final BaAzioneCoppia prima;

  /// Se manca, `prima` sta da sola al centro, larga come una delle due.
  final BaAzioneCoppia? seconda;

  static const double _mezzoGap = BaControlloTokens.gapCoppia / 2;

  Widget _pillola(BaAzioneCoppia a, EdgeInsets estensione, [double altezza = BaControlloTokens.coppia]) =>
      BaPillola(
        testo: a.testo,
        semanticsLabel: a.semanticsLabel,
        onTap: a.onTap,
        variante: BaVariantePillola.spenta,
        estensione: estensione,
        altezzaMinima: altezza,
      );

  @override
  Widget build(BuildContext context) {
    final seconda = this.seconda;
    if (seconda == null) {
      return LayoutBuilder(
        builder: (context, vincoli) {
          final larghezza = (vincoli.maxWidth - BaControlloTokens.gapCoppia) / 2;
          return Center(
            child: SizedBox(
              width: larghezza,
              child: _pillola(prima, BaTouchable.estesa),
            ),
          );
        },
      );
    }
    // Le due pillole della riga hanno la stessa altezza: quella della più alta.
    // Si misura prima, con la larghezza che ognuna avrà.
    return LayoutBuilder(
      builder: (context, vincoli) {
        final larghezza = (vincoli.maxWidth - BaControlloTokens.gapCoppia) / 2;
        double altezza(BaAzioneCoppia a) => BaPillola.altezzaNecessaria(
              context,
              testo: a.testo,
              larghezza: larghezza,
              variante: BaVariantePillola.spenta,
              inattiva: a.onTap == null,
              altezzaMinima: BaControlloTokens.coppia,
            );
        final h = altezza(prima) > altezza(seconda) ? altezza(prima) : altezza(seconda);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _pillola(prima, const EdgeInsets.only(right: _mezzoGap), h)),
            const SizedBox(width: BaControlloTokens.gapCoppia),
            Expanded(child: _pillola(seconda, const EdgeInsets.only(left: _mezzoGap), h)),
          ],
        );
      },
    );
  }
}
