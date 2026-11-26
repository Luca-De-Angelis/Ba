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
    this.stile = BaTestoTokens.controllo,
    this.riempimento = BaSpazioTokens.xl,
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

  /// Lo stile del testo. Il default è `controllo` (16/500), com'è sempre stato; la barra
  /// delle azioni lo cambia per le secondarie (`azione`, 14, task 032). Le misure statiche
  /// qui sotto prendono lo stesso [stile].
  final TextStyle stile;

  /// Il riempimento orizzontale fra il bordo e il testo. Il default è `xl` (20), com'è sempre stato;
  /// la barra delle azioni dà alle secondarie `m` (12, task 036: il design le vuole così). Le misure
  /// statiche qui sotto prendono lo stesso [riempimento].
  final double riempimento;

  // --------------------------------------------------------------- misure
  //
  // Chi mette più pillole in una riga ha bisogno di due risposte prima di
  // costruirle: quanto sarebbe alta ognuna (per dare a tutte quella della più
  // alta) e se la parola più lunga ci entra (altrimenti la riga si dispone in
  // colonna). Si misurano con TextPainter, con lo stesso stile, lo stesso
  // padding e lo stesso TextScaler con cui la pillola disegna.

  static double _bordo(BaVariantePillola variante, bool inattiva) =>
      (variante == BaVariantePillola.chiara && !inattiva) ? 0 : const BorderSide().width;

  static TextPainter _misuratore(BuildContext context, String testo, TextStyle stile) => TextPainter(
        text: TextSpan(text: testo, style: stile),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        textAlign: TextAlign.center,
      );

  /// La larghezza che il testo ha a disposizione in una pillola larga
  /// [larghezza]: tolti il padding orizzontale e il filetto.
  static double _larghezzaUtile(double larghezza, BaVariantePillola variante, bool inattiva, double riempimento) =>
      larghezza - 2 * riempimento - 2 * _bordo(variante, inattiva);

  /// L'altezza che la pillola avrebbe, larga [larghezza], col testo e il testo
  /// di sistema correnti: mai sotto [altezzaMinima].
  static double altezzaNecessaria(
    BuildContext context, {
    required String testo,
    required double larghezza,
    BaVariantePillola variante = BaVariantePillola.attiva,
    bool inattiva = false,
    double altezzaMinima = BaControlloTokens.primario,
    TextStyle stile = BaTestoTokens.controllo,
    double riempimento = BaSpazioTokens.xl,
  }) {
    final m = _misuratore(context, testo, stile)
      ..layout(maxWidth: _larghezzaUtile(larghezza, variante, inattiva, riempimento).clamp(0, double.infinity));
    final h = m.height + 2 * BaSpazioTokens.sm + 2 * _bordo(variante, inattiva);
    m.dispose();
    return h > altezzaMinima ? h : altezzaMinima;
  }

  /// Se la parola più lunga di [testo] entra, intera, in una pillola larga
  /// [larghezza] (al testo di sistema corrente). Una parola spezzata non è un
  /// ripiego accettabile: chi dispone le pillole sceglie un'altra disposizione.
  static bool parolaEntra(
    BuildContext context, {
    required String testo,
    required double larghezza,
    BaVariantePillola variante = BaVariantePillola.attiva,
    bool inattiva = false,
    TextStyle stile = BaTestoTokens.controllo,
    double riempimento = BaSpazioTokens.xl,
  }) {
    final utile = _larghezzaUtile(larghezza, variante, inattiva, riempimento);
    for (final parola in testo.split(RegExp(r'\s+'))) {
      if (parola.isEmpty) continue;
      final m = _misuratore(context, parola, stile)..layout();
      final larga = m.width;
      m.dispose();
      if (larga > utile) return false;
    }
    return true;
  }

  /// La larghezza che la pillola avrebbe con il testo su **una riga**: il testo, il padding
  /// orizzontale e il filetto. Serve a chi dispone le pillole dal contenuto (la barra).
  static double larghezzaNecessaria(
    BuildContext context, {
    required String testo,
    BaVariantePillola variante = BaVariantePillola.attiva,
    bool inattiva = false,
    TextStyle stile = BaTestoTokens.controllo,
    double riempimento = BaSpazioTokens.xl,
  }) {
    final m = _misuratore(context, testo, stile)..layout();
    final w = m.width;
    m.dispose();
    return w + 2 * riempimento + 2 * _bordo(variante, inattiva);
  }

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
      padding: EdgeInsets.symmetric(
        horizontal: riempimento,
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
        style: stile.copyWith(color: colore),
      ),
    );
  }
}
