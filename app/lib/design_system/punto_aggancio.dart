// BaPuntoAggancio: una riga tratteggiata che TIENE IL POSTO di ciò che non è
// ancora deciso (Inventario C4): gli invitati di un DEN privato, le persone fra
// cui scegliere, il campo «Quando» spento. **Solo un posto, mai un'azione.**
// Quando la fonte o la funzione sarà decisa, entra qui senza ridisegnare il
// passo.
//
// Per questo non è toccabile, non prende il focus e non è un bottone per lo
// screen reader: un elemento che sembra un controllo e non lo è sarebbe una
// bugia. Il testo (titolo e sottotitolo) arriva dal chiamante.
//
// Due forme:
//   - `BaPuntoAggancio`        un riquadro tratteggiato (invitati, persone);
//   - `BaPuntoAggancio.quando` il campo «Quando» spento: una riga con il filetto
//     tratteggiato in alto e, a destra, l'interruttore spento che non si tocca.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';
import 'tratteggio.dart';

class BaPuntoAggancio extends StatelessWidget {
  /// Il riquadro tratteggiato: un [titolo] e, sotto, un [sottotitolo] in
  /// marcatore.
  const BaPuntoAggancio({super.key, required this.titolo, this.sottotitolo}) : etichetta = null;

  /// Il campo «Quando» spento: [etichetta] in marcatore, [titolo] e
  /// [sottotitolo], con l'interruttore spento a destra. Tutto attenuato: non si
  /// può usare.
  const BaPuntoAggancio.quando({
    super.key,
    required String this.etichetta,
    required this.titolo,
    this.sottotitolo,
  });

  final String titolo;
  final String? sottotitolo;

  /// Solo per la forma `quando`.
  final String? etichetta;

  bool get _quando => etichetta != null;

  @override
  Widget build(BuildContext context) {
    final marcatore = BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo);
    final scala = TextScaler.linear(BaScalaTokens.marcatore(context));

    final String parole = [?etichetta, titolo, ?sottotitolo].join('. ');
    final Widget corpo = _quando ? _quandoSpento(marcatore, scala) : _riquadro(marcatore, scala);

    // Testo e basta: nessun bottone, nessun focus, nessuna azione.
    return Semantics(container: true, label: parole, excludeSemantics: true, child: corpo);
  }

  Widget _riquadro(TextStyle marcatore, TextScaler scala) {
    return BaTratteggio(
      raggio: BaCreazioneTokens.aggancioRaggio,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: BaCreazioneTokens.aggancioAltezza,
          minWidth: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BaSpazioTokens.md,
            vertical: BaSpazioTokens.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(titolo, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
              if (sottotitolo != null) ...[
                const SizedBox(height: BaSpazioTokens.xxs),
                Text(sottotitolo!.toUpperCase(), textScaler: scala, style: marcatore),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _quandoSpento(TextStyle marcatore, TextScaler scala) {
    final attenuato = BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoTerzo);
    return BaTratteggio.sopra(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: BaControlloTokens.primario,
          minWidth: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(etichetta!.toUpperCase(), textScaler: scala, style: marcatore),
                    Text(titolo, style: attenuato),
                    if (sottotitolo != null) Text(sottotitolo!, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoTerzo)),
                  ],
                ),
              ),
              const SizedBox(width: BaSpazioTokens.m),
              const _InterruttoreSpento(),
            ],
          ),
        ),
      ),
    );
  }
}

/// L'interruttore del «Quando», spento e tratteggiato: c'è, ma non si tocca.
class _InterruttoreSpento extends StatelessWidget {
  const _InterruttoreSpento();

  @override
  Widget build(BuildContext context) {
    return BaTratteggio(
      raggio: BaRaggioTokens.pillola,
      child: SizedBox(
        width: BaCreazioneTokens.quandoInterruttoreLarghezza,
        height: BaCreazioneTokens.quandoInterruttoreAltezza,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: BaSpazioTokens.xxs),
          child: Align(
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: BaColorTokens.ascoltoGruppoBordo),
              ),
              child: const SizedBox.square(dimension: BaCreazioneTokens.quandoPallino),
            ),
          ),
        ),
      ),
    );
  }
}
