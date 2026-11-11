// BaAnello: l'anello di chi parla (C1, T4, T6 ter, T8). Doppio tratto aderente
// alla sagoma: keyline scura adiacente (3) e tratto chiaro fuori (2), fissi a
// ogni scala. Sta su DUE canali:
//
//   veloce  `parla` (ActiveSpeakersChanged): compare in 70 ms, scompare in
//           140 ms. Regge da solo il significato.
//   lento   `ampiezza` (0–1, campionata dall'SDK ogni 500 ms): il respiro,
//           cioè scala e opacità del tratto fra riposo e picco. Decorazione
//           informata, non informazione.
//
// Dove i documenti tacciono (proposte del task 010, nel report):
//   - il respiro sale con una rampa lineare lunga quanto il campionamento e
//     scende in `voceRilascio`: fra due campioni l'anello è sempre in moto,
//     senza gradini e senza dente di sega;
//   - l'opacità del respiro è sul tratto; la keyline non respira;
//   - il ripiego statico ("riduci movimento") è scala di riposo e tratto pieno.
import 'package:flutter/widgets.dart';

import 'forma.dart';
import 'tokens.dart';

class BaAnello extends StatefulWidget {
  const BaAnello({
    super.key,
    required this.bordo,
    this.parla = false,
    this.ampiezza = 0,
    this.voci = 1,
    this.lineaInstabile = false,
    this.keyline = BaColorTokens.voceKeyline,
  });

  /// Gli angoli della sagoma che l'anello abbraccia. L'anello riempie la
  /// scatola che riceve e disegna fuori da essa, senza toccare il layout.
  final BorderRadius bordo;

  /// Canale veloce: c'è una voce.
  final bool parla;

  /// Canale lento: ampiezza da 0 a 1, già campionata a
  /// `BaMovimentoTokens.campionamentoAmpiezza`.
  final double ampiezza;

  /// Quante voci parlano insieme: oltre una, l'escursione si comprime
  /// (`BaPresenzaTokens.quotaEscursione`).
  final int voci;

  /// "C'è una voce, non ne conosco l'ampiezza": anello fermo a
  /// `voceTrattoFermo`.
  final bool lineaInstabile;

  /// Colore della keyline: `premutoKeyline` quando la presenza è premuta.
  final Color keyline;

  @override
  State<BaAnello> createState() => _BaAnelloState();
}

class _BaAnelloState extends State<BaAnello> with TickerProviderStateMixin {
  // Il rilascio non può scendere sotto il campionamento (T8): con un rilascio
  // più corto l'anello si sgonfierebbe fra un campione e l'altro.
  static const Duration _salita = BaMovimentoTokens.campionamentoAmpiezza;
  static const Duration _discesa = BaMovimentoTokens.voceRilascio;

  /// 0 = anello assente, 1 = presente. Il canale veloce.
  late final AnimationController _presenza = AnimationController(
    vsync: this,
    duration: BaMovimentoTokens.voceAttacco,
    reverseDuration: BaMovimentoTokens.voceScomparsa,
  );

  /// 0 = riposo, 1 = picco a una voce. Il canale lento.
  late final AnimationController _respiro = AnimationController(vsync: this);

  bool _riduciMovimento = false;

  bool get _fermo => _riduciMovimento || widget.lineaInstabile;

  @override
  void initState() {
    super.initState();
    assert(_discesa >= _salita, 'il rilascio non può essere più corto del campionamento');
    // Quando la scomparsa finisce l'anello esce dall'albero.
    _presenza.addStatusListener((s) {
      if (s == AnimationStatus.dismissed && mounted) setState(() {});
    });
    _presenza.value = widget.parla ? 1 : 0;
    _respiro.value = _livello(widget.ampiezza);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final riduci = MediaQuery.disableAnimationsOf(context);
    if (riduci != _riduciMovimento) {
      _riduciMovimento = riduci;
      _allinea(subito: true);
    }
  }

  @override
  void didUpdateWidget(BaAnello vecchio) {
    super.didUpdateWidget(vecchio);
    if (widget.parla != vecchio.parla ||
        widget.ampiezza != vecchio.ampiezza ||
        widget.lineaInstabile != vecchio.lineaInstabile) {
      _allinea(subito: false);
    }
  }

  @override
  void dispose() {
    _presenza.dispose();
    _respiro.dispose();
    super.dispose();
  }

  double _livello(double ampiezza) => ampiezza.clamp(0.0, 1.0).toDouble();

  void _allinea({required bool subito}) {
    // Canale veloce. Con "riduci movimento" l'anello c'è o non c'è, senza
    // dissolvenza: non si taglia lo stato, solo la resa.
    final eraAssente = _presenza.isDismissed;
    final presenza = widget.parla ? 1.0 : 0.0;
    if (subito || _riduciMovimento) {
      _presenza.value = presenza;
    } else if (widget.parla) {
      _presenza.forward();
    } else {
      _presenza.reverse();
    }

    // Canale lento. Fermo (ripiego o linea instabile) o assente: a riposo.
    final bersaglio = (_fermo || !widget.parla) ? 0.0 : _livello(widget.ampiezza);
    if (subito || _fermo) {
      _respiro.value = bersaglio;
    } else if (!widget.parla) {
      // Sta scomparendo: il respiro resta com'è finché esce dall'albero.
    } else if (eraAssente) {
      // L'anello ricompare con l'ampiezza che c'è, non dal riposo.
      _respiro.value = bersaglio;
    } else {
      final sale = bersaglio > _respiro.value;
      _respiro.animateTo(
        bersaglio,
        duration: sale ? _salita : _discesa,
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_presenza.isDismissed && !widget.parla) return const SizedBox.shrink();

    const keylineSp = BaPresenzaTokens.anelloKeyline;
    const trattoSp = BaPresenzaTokens.anelloTratto;
    const banda = keylineSp + trattoSp;
    final quota = BaPresenzaTokens.quotaEscursione(widget.voci);

    final Animation<double> scala;
    final Animation<double> opacitaTratto;
    if (_fermo) {
      scala = const AlwaysStoppedAnimation(BaPresenzaTokens.anelloScalaRiposo);
      opacitaTratto = const AlwaysStoppedAnimation(1.0);
    } else {
      scala = _respiro.drive(Tween(
        begin: BaPresenzaTokens.anelloScalaRiposo,
        end: BaPresenzaTokens.anelloScalaRiposo +
            (BaPresenzaTokens.anelloScalaPicco - BaPresenzaTokens.anelloScalaRiposo) * quota,
      ));
      opacitaTratto = _respiro.drive(Tween(
        begin: BaPresenzaTokens.anelloOpacitaRiposo,
        end: BaPresenzaTokens.anelloOpacitaRiposo +
            (BaPresenzaTokens.anelloOpacitaPicco - BaPresenzaTokens.anelloOpacitaRiposo) * quota,
      ));
    }

    final colorTratto =
        widget.lineaInstabile ? BaColorTokens.voceTrattoFermo : BaColorTokens.voceTratto;

    return ExcludeSemantics(
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _presenza,
          child: ScaleTransition(
            scale: scala,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                // keyline: adiacente alla sagoma, stacca dalla foto
                Positioned(
                  left: -keylineSp,
                  top: -keylineSp,
                  right: -keylineSp,
                  bottom: -keylineSp,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: ingrandisci(widget.bordo, keylineSp),
                      border: Border.all(color: widget.keyline, width: keylineSp),
                    ),
                  ),
                ),
                // tratto: chiaro, fuori dalla keyline
                Positioned(
                  left: -banda,
                  top: -banda,
                  right: -banda,
                  bottom: -banda,
                  child: FadeTransition(
                    opacity: opacitaTratto,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: ingrandisci(widget.bordo, banda),
                        border: Border.all(color: colorTratto, width: trattoSp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
