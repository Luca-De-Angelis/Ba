// BaMessaggio: una frase che la schermata dice a chi la usa (Inventario C3).
// Due varianti: neutro (informa) ed errore (qualcosa non è andato). Stati:
// assente (non c'è nel layout) e presente.
//
// **Uno solo per schermata.** Due messaggi insieme si contraddicono o si
// sommano: il chiamante ne mostra al massimo uno. Un assert non è possibile da
// dentro il widget (non sa degli altri), quindi la regola sta qui e nel report.
//
// **L'errore non si riempie mai** (BaRegole 6: non esiste `erroreFondo`):
// riquadro con filetto `erroreFiletto`, segno «!» in un cerchio e testo. Il
// segno e il testo dicono l'errore anche senza il colore: mai il solo colore.
//
// **Annuncio:** un errore si annuncia allo screen reader quando compare o
// cambia (regione viva); un messaggio neutro no, si legge navigando.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';

enum BaVarianteMessaggio { neutro, errore }

class BaMessaggio extends StatelessWidget {
  const BaMessaggio({
    super.key,
    required this.testo,
    this.variante = BaVarianteMessaggio.neutro,
    this.semanticsLabel,
  });

  /// La frase, già tradotta: il design system non conosce l10n. Va a capo a
  /// testo grande, senza tagli (l'altezza è un minimo, non una misura).
  final String testo;

  final BaVarianteMessaggio variante;

  /// Se manca, lo screen reader legge [testo].
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final errore = variante == BaVarianteMessaggio.errore;
    return Semantics(
      container: true,
      liveRegion: errore,
      label: semanticsLabel ?? testo,
      excludeSemantics: true,
      child: DecoratedBox(
        // Mai un fondo: solo il filetto (nessun `color` né gradiente).
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BaRaggioTokens.riquadro),
          border: Border.all(
            color: errore ? BaColorTokens.erroreFiletto : BaColorTokens.filettoBase,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BaSpazioTokens.l,
            vertical: BaSpazioTokens.m,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errore) ...[
                const _SegnoErrore(),
                const SizedBox(width: BaSpazioTokens.m),
              ],
              Expanded(
                child: Text(
                  testo,
                  style: BaTestoTokens.corpo.copyWith(
                    color: errore ? BaColorTokens.erroreTesto : BaColorTokens.testoSecondo,
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

/// Il segno «!»: un cerchio di `erroreSegnoLato` con tratto `erroreSegnoTratto`.
/// Non scala col testo: sta sull'altezza della prima riga.
class _SegnoErrore extends StatelessWidget {
  const _SegnoErrore();

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
