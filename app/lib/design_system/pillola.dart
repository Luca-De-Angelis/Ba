// BaPillola: il controllo di BA (Inventario C3). Sta sopra BaTouchable, che le
// dà premuto, focus e area minima; qui ci sono la forma, i colori e le varianti.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';
import 'touchable.dart';

/// Che cosa dice e che cosa fa una pillola.
enum BaVariantePillola {
  /// Dice e non fa niente: non si tocca, non prende il focus, non è un
  /// bottone per lo screen reader. Filetto leggero, testo terzo.
  informativa,

  /// Un'azione: fondo e bordo di `azioneAttiva*`. È la pillola piena di
  /// ordinaria amministrazione («Spegni il microfono»).
  attiva,

  /// L'azione chiara, quella che il fondo `azioneChiaraPiena` mette in primo
  /// piano. `BaRegole` 1: SOLO dove l'app non può proseguire senza un gesto
  /// dell'utente, che nessun altro può fare al posto suo («Sali sul palco»,
  /// «Accendi il microfono»). Una per schermata: tutto il resto è hairline.
  chiara,

  /// Hairline: l'azione secondaria. Solo filetto e testo secondo.
  spenta,
}

class BaPillola extends StatelessWidget {
  const BaPillola({
    super.key,
    required this.testo,
    required this.semanticsLabel,
    this.onTap,
    this.variante = BaVariantePillola.attiva,
    this.estensione = EdgeInsets.zero,
    this.allarga = true,
    this.altezzaMinima = BaControlloTokens.primario,
  }) : assert(
          altezzaMinima >= BaControlloTokens.areaMinima,
          'la pillola non scende mai sotto areaMinima',
        );

  /// Il testo che si vede. Arriva già tradotto: il design system non conosce
  /// l10n.
  final String testo;

  /// Etichetta per lo screen reader, dal chiamante.
  final String semanticsLabel;

  /// Nullo = inattiva (nessun feedback, non focalizzabile). Per la variante
  /// informativa è ignorato: non fa mai niente.
  final VoidCallback? onTap;

  final BaVariantePillola variante;

  /// Quanto l'area toccabile sporge oltre il bordo (vedi [BaTouchable]).
  final EdgeInsets estensione;

  /// Riempie la larghezza che il genitore le dà. Con `false` prende quella del
  /// testo (serve solo dove la larghezza è illimitata, come in un `Row`).
  final bool allarga;

  /// Un minimo, non una misura: il contenuto può alzare la pillola, mai
  /// abbassarla. `primario` per la pillola da sola; le secondarie di una
  /// coppia o di una barra usano `coppia`.
  final double altezzaMinima;

  @override
  Widget build(BuildContext context) {
    if (variante == BaVariantePillola.informativa) {
      return Semantics(
        label: semanticsLabel,
        container: true,
        excludeSemantics: true,
        child: _corpo(inattiva: false, informativa: true),
      );
    }
    return BaTouchable(
      semanticsLabel: semanticsLabel,
      onTap: onTap,
      suChiara: variante == BaVariantePillola.chiara,
      estensione: estensione,
      raggio: BaRaggioTokens.pillola,
      builder: (context, stato) => _corpo(inattiva: stato.inattivo, informativa: false),
    );
  }

  Widget _corpo({required bool inattiva, required bool informativa}) {
    final chiara = variante == BaVariantePillola.chiara && !inattiva;
    final attiva = variante == BaVariantePillola.attiva && !inattiva;

    final Color colore = inattiva
        ? BaColorTokens.testoInattivo
        : informativa
            ? BaColorTokens.testoTerzo
            : switch (variante) {
                BaVariantePillola.chiara => BaColorTokens.testoSuChiara,
                BaVariantePillola.attiva => BaColorTokens.testoPrimo,
                _ => BaColorTokens.testoSecondo,
              };

    final Color? bordo = chiara
        ? null
        : attiva
            ? BaColorTokens.azioneAttivaBordo
            : (informativa || inattiva)
                ? BaColorTokens.filettoBase
                : BaColorTokens.filettoMarcato;

    final List<Color>? fondo = chiara
        ? BaColorTokens.azioneChiaraPiena
        : attiva
            ? BaColorTokens.azioneAttivaFondo
            : null;

    // Il raggio è sempre lo stadio. A testo grande cresce l'altezza (mai sotto
    // `primario`) e il padding orizzontale tiene il testo lontano dalle
    // estremità, così la curva non lo taglia.
    return Container(
      constraints: BoxConstraints(
        minHeight: altezzaMinima,
        minWidth: allarga ? double.infinity : 0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: BaSpazioTokens.xl,
        vertical: BaSpazioTokens.sm,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BaRaggioTokens.pillola),
        border: bordo == null ? null : Border.all(color: bordo),
        gradient: fondo == null
            ? null
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: fondo,
              ),
      ),
      child: Text(
        testo,
        textAlign: TextAlign.center,
        style: BaTestoTokens.controllo.copyWith(color: colore),
      ),
    );
  }
}
