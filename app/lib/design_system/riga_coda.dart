// BaRigaCoda: una riga di «Le tue code» (Inventario C4, K1): il DEN, lo stato
// («In coda · entri a microfono spento») e l'uscita («Esci dalla coda»).
//
// **Nessuna posizione, nessun conteggio, nessun numero massimo:** l'API non ha
// dove metterli, quindi non si possono passare. Il tempo non è un fatto da
// mostrare qui (regola 3: niente contatori che accumulano).
//
// Layout come il `flex-wrap` del prototipo: nome e stato a sinistra, uscita a
// destra; se non stanno insieme (nome lungo, o testo grande), **l'uscita va a
// capo sotto il nome**. L'uscita è una BaPillola spenta con l'altezza minima
// `uscitaAltezza` (44): non si riscrive il controllo. Differenze dal
// prototipo, segnalate nel report del task 022: il testo dell'uscita è 16 (non
// 14) e il padding è quello della pillola.
//
// I testi arrivano dal chiamante. Per lo screen reader la riga ha due elementi:
// il nome con lo stato, e il bottone di uscita.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'pillola.dart';
import 'tokens.dart';

class BaRigaCoda extends StatelessWidget {
  const BaRigaCoda({
    super.key,
    required this.nome,
    required this.stato,
    required this.uscitaTesto,
    this.onEsci,
    this.uscitaSemanticsLabel,
  });

  /// Il DEN in cui si è in coda.
  final String nome;

  /// Lo stato, già composto («In coda · entri a microfono spento»).
  final String stato;

  /// Il testo dell'uscita («Esci dalla coda»).
  final String uscitaTesto;

  /// Nullo = l'uscita è inattiva.
  final VoidCallback? onEsci;

  /// Se manca: [uscitaTesto].
  final String? uscitaSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: BaCodaTokens.rigaAltezza,
        minWidth: double.infinity,
      ),
      padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.sm),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BaColorTokens.filettoDivisorio)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: BaSpazioTokens.m,
        runSpacing: BaSpazioTokens.s,
        children: [
          Semantics(
            container: true,
            label: '$nome. $stato',
            excludeSemantics: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(nome, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
                const SizedBox(height: BaSpazioTokens.xxs),
                Text(stato, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
              ],
            ),
          ),
          // container: l'uscita è un nodo suo per lo screen reader, anche quando è
          // inattiva (senza azione, un nodo si fonde con quello accanto).
          // IntrinsicWidth: la pillola ha un `alignment` e dentro un Wrap, che dà
          // vincoli limitati ma non stretti, si allargherebbe a tutta la riga e
          // l'uscita finirebbe sempre a capo. Così prende la larghezza del suo
          // testo (e, se non entra, va a capo dentro il limite). BaPillola non
          // si tocca.
          Semantics(
            container: true,
            child: IntrinsicWidth(
              child: BaPillola(
                testo: uscitaTesto,
                semanticsLabel: uscitaSemanticsLabel ?? uscitaTesto,
                variante: BaVariantePillola.spenta,
                onTap: onEsci,
                allarga: false,
                altezzaMinima: BaCodaTokens.uscitaAltezza,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
