// BaSceltaDen: la scelta del tipo di DEN, privato o pubblico (Inventario C4,
// C1 di «Crea un DEN»). Una riga per tipo; sotto, una frase che cambia con la
// scelta. Il componente non sa che cosa si sceglie: titolo, descrizioni e frase
// arrivano dal chiamante, e le opzioni sono due o più.
//
// **La scelta non è mai il solo colore:** ha il bordo spesso
// (`sceltaBordoScelta`) E un cerchio con un punto pieno; la non scelta ha il
// bordo sottile e il cerchio vuoto.
//
// Per lo screen reader è un gruppo di scelta esclusiva: ogni riga è un bottone
// `inMutuallyExclusiveGroup` e `selected` quando è la scelta. La frase sotto è
// una regione viva cortese: cambiando con la scelta, si legge.
//
// Il punto interno al cerchio è `BaCreazioneTokens.sceltaPuntoLato` (10, task 032).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';
import 'touchable.dart';

/// Un'opzione della scelta: un titolo e, sotto, una descrizione.
@immutable
class BaOpzioneScelta {
  const BaOpzioneScelta({required this.titolo, this.descrizione, this.semanticsLabel});

  final String titolo;
  final String? descrizione;

  /// Se manca: titolo e descrizione.
  final String? semanticsLabel;
}

class BaSceltaDen extends StatelessWidget {
  const BaSceltaDen({
    super.key,
    required this.opzioni,
    required this.scelta,
    required this.onScelta,
    this.fraseSotto,
  }) : assert(opzioni.length >= 2, 'una scelta ha almeno due opzioni');

  final List<BaOpzioneScelta> opzioni;

  /// L'indice dell'opzione scelta; nulla = nessuna scelta ancora.
  final int? scelta;

  final ValueChanged<int> onScelta;

  /// La frase sotto, che cambia con la scelta (dal chiamante).
  final String? fraseSotto;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < opzioni.length; i++) ...[
          if (i > 0) const SizedBox(height: BaControlloTokens.gapCoppia),
          _Riga(opzione: opzioni[i], scelta: i == scelta, onTap: () => onScelta(i)),
        ],
        if (fraseSotto != null) ...[
          const SizedBox(height: BaSpazioTokens.m),
          Semantics(
            liveRegion: true,
            child: Text(
              fraseSotto!,
              style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
            ),
          ),
        ],
      ],
    );
  }
}

class _Riga extends StatelessWidget {
  const _Riga({required this.opzione, required this.scelta, required this.onTap});

  final BaOpzioneScelta opzione;
  final bool scelta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      inMutuallyExclusiveGroup: true,
      selected: scelta,
      child: BaTouchable(
        semanticsLabel: opzione.semanticsLabel ??
            [opzione.titolo, ?opzione.descrizione].join('. '),
        onTap: onTap,
        raggio: BaCreazioneTokens.sceltaRaggio,
        builder: (context, stato) => Container(
          constraints: const BoxConstraints(
            minHeight: BaCreazioneTokens.sceltaAltezza,
            minWidth: double.infinity,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: BaSpazioTokens.l,
            vertical: BaSpazioTokens.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BaCreazioneTokens.sceltaRaggio),
            border: Border.all(
              color: scelta ? BaColorTokens.azioneChiara : BaColorTokens.filettoMarcato,
              width: scelta ? BaCreazioneTokens.sceltaBordoScelta : BaCreazioneTokens.sceltaBordo,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Cerchio(scelta: scelta),
              const SizedBox(width: BaSpazioTokens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      opzione.titolo,
                      style: BaTestoTokens.controllo.copyWith(color: BaColorTokens.testoPrimo),
                    ),
                    if (opzione.descrizione != null) ...[
                      const SizedBox(height: BaSpazioTokens.xxs),
                      Text(
                        opzione.descrizione!,
                        style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Il cerchio della scelta: vuoto se non scelta, con un punto pieno se scelta.
class _Cerchio extends StatelessWidget {
  const _Cerchio({required this.scelta});

  final bool scelta;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: scelta ? BaColorTokens.azioneChiara : BaColorTokens.ascoltoGruppoBordo,
          width: BaCreazioneTokens.sceltaBordoScelta,
        ),
      ),
      child: SizedBox.square(
        dimension: BaCreazioneTokens.sceltaSegnoLato,
        child: Center(
          child: scelta
              ? const DecoratedBox(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: BaColorTokens.azioneChiara),
                  child: SizedBox.square(dimension: BaCreazioneTokens.sceltaPuntoLato),
                )
              : null,
        ),
      ),
    );
  }
}
