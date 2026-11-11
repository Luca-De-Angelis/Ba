// BaPresenza, variante palco (C1): una persona sul palco. Compone sagoma,
// gradiente della tinta, ritratto, anello e BaTouchable in variante
// `suPresenza`. Stati di questo task: ferma, parla, persa, scheletro, premuta,
// a fuoco. Mutata, bloccata, microfono spento e tacca sono del task 012.
//
// Il diametro NON è un parametro: si eredita dal palco (regola 5, C6) da un
// [BaDiametro]. Tinta e sagoma arrivano come indici dall'evento di ingresso:
// le assegna la stanza, non si calcolano dall'id (§7.3).
//
// Layout: la presenza occupa il diametro più la banda dell'anello a riposo
// (3 + 2 per lato). Serve perché l'anello di focus di BaTouchable stia fuori
// dall'anello della voce e non lo copra (T7 bis: "il focus non può somigliare
// alla voce"). Il palco la centra: la distanza minima di d + 17 la contiene.
import 'package:flutter/widgets.dart';

import 'anello.dart';
import 'forma.dart';
import 'ritratto.dart';
import 'tokens.dart';
import 'touchable.dart';

/// Il diametro delle presenze sotto di sé, deciso dal palco (regola 5).
class BaDiametro extends InheritedWidget {
  const BaDiametro({super.key, required this.diametro, required super.child});

  final double diametro;

  /// Il diametro ereditato. Senza un [BaDiametro] sopra è un errore in debug;
  /// in release ripiega sul fondo della scala a testo normale.
  static double of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<BaDiametro>();
    assert(w != null, 'BaPresenza vuole un BaDiametro sopra di sé: il diametro lo decide il palco');
    return w?.diametro ?? BaPresenzaTokens.s;
  }

  @override
  bool updateShouldNotify(BaDiametro vecchio) => diametro != vecchio.diametro;
}

class BaPresenza extends StatelessWidget {
  const BaPresenza({
    super.key,
    required this.semanticsLabel,
    this.semanticsLabelParla,
    required this.indiceTinta,
    required this.indiceSagoma,
    this.iniziali,
    this.immagine,
    this.parla = false,
    this.ampiezza = 0,
    this.voci = 1,
    this.lineaInstabile = false,
    this.persa = false,
    this.scheletro = false,
    this.onTap,
  });

  /// Etichetta per lo screen reader, già composta dal chiamante in lingua
  /// (es. «Marta B.»). Le iniziali non sono la rappresentazione accessibile.
  final String semanticsLabel;

  /// Etichetta quando parla (es. «Marta B., sta parlando»). Se manca vale
  /// [semanticsLabel].
  final String? semanticsLabelParla;

  /// Indici nel mazzo di `BaTintaTokens` e di `BaSagomaTokens`, dall'evento di
  /// ingresso.
  final int indiceTinta;
  final int indiceSagoma;

  final String? iniziali;
  final ImageProvider? immagine;

  /// Canale veloce dell'anello: c'è una voce.
  final bool parla;

  /// Canale lento: ampiezza 0–1 campionata ogni `campionamentoAmpiezza`.
  final double ampiezza;

  /// Quante voci parlano insieme sul palco (limiter).
  final int voci;

  /// Linea instabile: anello fermo a `voceTrattoFermo`.
  final bool lineaInstabile;

  /// Linea caduta: scala di grigi e `persaOpacita`, nessun anello.
  final bool persa;

  /// Sagoma vuota mentre si entra: senza iniziali, respira fra i due valori
  /// dello scheletro. Non si tocca.
  final bool scheletro;

  /// Nullo = non toccabile. Lo scheletro non lo è mai.
  final VoidCallback? onTap;

  /// La banda dell'anello a riposo, per lato: keyline più tratto.
  static const double banda =
      BaPresenzaTokens.anelloKeyline + BaPresenzaTokens.anelloTratto;

  /// Quanto occupa nel layout una presenza di diametro [d]: la sagoma più la
  /// banda su ogni lato. Il palco centra questo riquadro sul centro della
  /// presenza.
  static double ingombro(double d) => d + 2 * banda;

  // Grayscale(1) di T4 (presenza/persa): i pesi di luminanza Rec. 709. Sono la
  // definizione del filtro, non un valore di design; tokens.dart non li ha
  // (segnalato nel report del task 010).
  static const double _pesoR = 0.2126;
  static const double _pesoG = 0.7152;
  static const double _pesoB = 0.0722;
  static const ColorFilter _grigio = ColorFilter.matrix(<double>[
    _pesoR, _pesoG, _pesoB, 0, 0, //
    _pesoR, _pesoG, _pesoB, 0, 0,
    _pesoR, _pesoG, _pesoB, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    final d = BaDiametro.of(context);
    const keyline = BaPresenzaTokens.anelloKeyline;
    final bordo = BaSagomaTokens.bordo(indiceSagoma, d);
    final tinta = BaTintaTokens.mazzo[indiceTinta % BaTintaTokens.mazzo.length];
    final conAnello = parla && !persa && !scheletro;
    final inizialiVisibili = scheletro ? null : iniziali;
    final immagineVisibile = scheletro ? null : immagine;

    Widget sagoma = DecoratedBox(
      decoration: BoxDecoration(borderRadius: bordo, gradient: tinta.gradiente),
      child: ClipRRect(
        borderRadius: bordo,
        child: BaRitratto(diametro: d, iniziali: inizialiVisibili, immagine: immagineVisibile),
      ),
    );
    if (persa) {
      sagoma = Opacity(
        opacity: BaPresenzaTokens.persaOpacita,
        child: ColorFiltered(colorFilter: _grigio, child: sagoma),
      );
    }
    if (scheletro) sagoma = _Scheletro(child: sagoma);

    return BaTouchable(
      semanticsLabel: parla ? (semanticsLabelParla ?? semanticsLabel) : semanticsLabel,
      onTap: scheletro ? null : onTap,
      variante: BaVarianteTocco.suPresenza,
      // Il focus abbraccia la sagoma e la banda dell'anello a riposo.
      bordo: ingrandisci(bordo, banda),
      builder: (context, stato) {
        return SizedBox(
          width: ingombro(d),
          height: ingombro(d),
          child: Padding(
            padding: const EdgeInsets.all(banda),
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                sagoma,
                BaAnello(
                  diametro: d,
                  bordo: bordo,
                  parla: conAnello,
                  ampiezza: ampiezza,
                  voci: voci,
                  lineaInstabile: lineaInstabile,
                  // Premuta: la keyline diventa premutoKeyline, e basta.
                  keyline: stato.premuto
                      ? BaColorTokens.premutoKeyline
                      : BaColorTokens.voceKeyline,
                ),
                // Senza anello la keyline sola, solo da premuta.
                if (stato.premuto && !conAnello)
                  Positioned(
                    left: -keyline,
                    top: -keyline,
                    right: -keyline,
                    bottom: -keyline,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: ingrandisci(bordo, keyline),
                          border: Border.all(
                            color: BaColorTokens.premutoKeyline,
                            width: keyline,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Lo scheletro: l'opacità respira fra `scheletroOpacitaMin` e `Max`, un ciclo
/// completo in `skeleton` (1,8 s), lineare. Con "riduci movimento" è fermo al
/// valore più alto (proposta del task 010, nel report).
class _Scheletro extends StatefulWidget {
  const _Scheletro({required this.child});

  final Widget child;

  @override
  State<_Scheletro> createState() => _ScheletroState();
}

class _ScheletroState extends State<_Scheletro> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 1; // fermo al valore più alto
    } else if (!_controller.isAnimating) {
      // Un verso dura metà ciclo: su e giù fanno 1,8 s.
      _controller.repeat(
        reverse: true,
        period: BaMovimentoTokens.skeleton ~/ 2,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(Tween(
        begin: BaPresenzaTokens.scheletroOpacitaMin,
        end: BaPresenzaTokens.scheletroOpacitaMax,
      )),
      child: widget.child,
    );
  }
}
