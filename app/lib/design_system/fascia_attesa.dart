// BaFasciaAttesa: il sotto-DEN d'attesa (Inventario C4, W2): un gruppo di chi
// aspetta nella stessa coda, fino a 8, che NON è il palco. Presenze piccole, una
// frase («Parli al gruppo di chi aspetta. Il palco non ti sente.») e, solo per
// chi ha la capacità, «Lascia il gruppo».
//
// **Le presenze non portano numeri né segni:** sono sagome, senza iniziali, e per
// lo screen reader non esistono (la frase dice a chi parlo). Non si conta chi
// c'è e non si mostra il conteggio.
//
// **«Lascia il gruppo» c'è solo se c'è `onLascia`.** Senza, la riga non esiste:
// nessuna etichetta, nessuno spazio vuoto, nessuna traccia — chi non ha la
// capacità non sa che esiste.
//
// Bordo e raggio sono quelli della fascia «chi mi sente» (`BaAscoltoTokens`:
// «parlo al mio gruppo»). Le sagome si disegnano qui, in un widget privato,
// come fa BaPubblico (non si tocca BaPubblico); la duplicazione si può
// unificare in un task di rifinitura (segnalata nel report del task 022).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'sagoma.dart';
import 'tokens.dart';
import 'touchable.dart';

class BaFasciaAttesa extends StatelessWidget {
  const BaFasciaAttesa({
    super.key,
    required this.conteggio,
    required this.tinte,
    required this.sagome,
    required this.frase,
    this.lasciaTesto,
    this.onLascia,
    this.lasciaSemanticsLabel,
  })  : assert(conteggio >= 1 && conteggio <= BaCodaTokens.gruppoMax,
            'il gruppo d\'attesa è di 1–8 persone'),
        assert((lasciaTesto == null) == (onLascia == null),
            '«Lascia il gruppo» vuole il testo e la callback insieme, o nessuno dei due');

  /// Quante persone ci sono (da 1 a `BaCodaTokens.gruppoMax`, 8). Disegna
  /// altrettante sagome; non si mostra mai come numero.
  final int conteggio;

  /// Indici nel mazzo di `BaTintaTokens` e di `BaSagomaTokens`, uno per
  /// sagoma, dal chiamante (si ricomincia da capo se sono meno).
  final List<int> tinte;
  final List<int> sagome;

  /// La frase, già tradotta.
  final String frase;

  /// «Lascia il gruppo»: testo e callback, o nessuno dei due. Senza, la riga non
  /// c'è.
  final String? lasciaTesto;
  final VoidCallback? onLascia;

  /// Se manca: [lasciaTesto].
  final String? lasciaSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final n = conteggio.clamp(1, BaCodaTokens.gruppoMax);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BaAscoltoTokens.raggio),
        border: Border.all(
          color: BaColorTokens.ascoltoGruppoBordo,
          width: BaAscoltoTokens.spessore,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: BaAscoltoTokens.altezzaMinima,
          minWidth: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BaSpazioTokens.md,
            vertical: BaSpazioTokens.m,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Le persone non si leggono: la frase dice a chi parlo.
              ExcludeSemantics(
                child: Wrap(
                  spacing: BaCodaTokens.gruppoPresenzaGap,
                  runSpacing: BaCodaTokens.gruppoPresenzaGap,
                  children: [
                    for (var i = 0; i < n; i++)
                      BaSagoma(tinta: tinte[i % tinte.length], sagoma: sagome[i % sagome.length], lato: BaCodaTokens.gruppoPresenzaLato),
                  ],
                ),
              ),
              const SizedBox(height: BaSpazioTokens.s),
              Text(frase, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoPrimo)),
              if (onLascia != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: BaTouchable(
                    semanticsLabel: lasciaSemanticsLabel ?? lasciaTesto!,
                    onTap: onLascia,
                    raggio: BaRaggioTokens.pillola,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: BaControlloTokens.areaMinima),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: 1,
                        child: Text(
                          lasciaTesto!,
                          style: BaTestoTokens.azione.copyWith(color: BaColorTokens.testoSecondo),
                        ),
                      ),
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
