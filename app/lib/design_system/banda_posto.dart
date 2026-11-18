// BaBandaPosto: la banda del posto conservato e della permanenza massima
// (Inventario C4). Una frase con, al massimo, un sottotesto: **un fatto fermo,
// mai un conto alla rovescia.** Il tempo si dice come un'ora («fino alle
// 21:43») o come «ancora per un momento» sotto i due minuti, e la frase la
// compone chi usa il componente con `BaCodaTokens.oraDelPosto`.
//
// Per questo il componente **riceve il testo già composto e non calcola mai un
// tempo**: non ha timer, non ha ticker, non si ridisegna col passare dei
// secondi. La stessa banda regge 30 secondi e 5 minuti senza cambiare
// schermata, perché cambia solo la frase.
//
// Due varianti:
//   - `posto`       il posto conservato dopo la linea persa (P1): a filo;
//   - `permanenza`  la permanenza massima (B05, in revisione, M1): tratteggiata,
//                   perché è un posto riservato e non una cosa decisa.
//
// **Annuncio.** La linea persa è un cambio di stato di chi usa l'app e D-034
// vuole che si annunci: per il posto conservato chi chiama accende `annuncia`
// (regione viva). La permanenza non si annuncia.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';
import 'tratteggio.dart';

enum BaVarianteBanda { posto, permanenza }

class BaBandaPosto extends StatelessWidget {
  const BaBandaPosto({
    super.key,
    required this.testo,
    this.sottotesto,
    this.variante = BaVarianteBanda.posto,
    this.annuncia = false,
  });

  /// La frase, già composta e tradotta dal chiamante.
  final String testo;

  /// Una riga di spiegazione sotto la frase («Il microfono è spento.»).
  final String? sottotesto;

  final BaVarianteBanda variante;

  /// Annuncia la banda allo screen reader quando compare o cambia (D-034).
  final bool annuncia;

  @override
  Widget build(BuildContext context) {
    final contenuto = Padding(
      padding: const EdgeInsets.symmetric(horizontal: BaSpazioTokens.md, vertical: BaSpazioTokens.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(testo, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
          if (sottotesto != null) ...[
            const SizedBox(height: BaSpazioTokens.xxs),
            Text(sottotesto!, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
          ],
        ],
      ),
    );

    final Widget banda = variante == BaVarianteBanda.permanenza
        ? BaTratteggio(
            raggio: BaCodaTokens.bandaRaggio,
            spessore: BaCodaTokens.bandaBordo,
            colore: BaColorTokens.azioneAttivaBordo,
            child: SizedBox(width: double.infinity, child: contenuto),
          )
        : DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BaCodaTokens.bandaRaggio),
              border: Border.all(
                color: BaColorTokens.ascoltoGruppoBordo,
                width: BaCodaTokens.bandaBordo,
              ),
            ),
            child: SizedBox(width: double.infinity, child: contenuto),
          );

    return Semantics(
      container: true,
      liveRegion: annuncia,
      label: [testo, ?sottotesto].join(' '),
      excludeSemantics: true,
      child: banda,
    );
  }
}
