// BaTouchable: il primo widget del design system. Porta premuto, focus e area
// minima a tutto ciò che si tocca (T7 bis, T8; Inventario C7 bis).
//
// ECCEZIONE ALLA REGOLA "in design_system/ solo widgets.dart" (approvata nel
// task 009): questo file importa anche package:flutter/rendering.dart, e solo
// questo. Serve per un RenderObject di poche righe, lo stesso schema che il
// Material usa per i 48 dp minimi: un widget che sporge dai propri confini non
// riceve i tocchi, quindi l'area minima (44) e l'estensione si fanno nel
// hit test. Nessun import di Material o Cupertino.
//
// Limite noto dell'estensione: il genitore taglia comunque i tocchi fuori dai
// propri confini (RenderBox.hitTest). Un'estensione verso l'esterno funziona
// solo se il genitore la contiene (per esempio con un padding uguale).
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'tokens.dart';

/// Come si comporta un elemento toccabile.
enum BaVarianteTocco {
  /// Pillole e righe: il premuto cede a scala 0,98 e scurisce il fondo.
  standard,

  /// Presenze: nessuna scala e nessun velo. Il premuto lo disegna il contenuto
  /// (la keyline diventa `BaColorTokens.premutoKeyline`) tramite il builder.
  suPresenza,
}

/// Lo stato che il builder di [BaTouchable] riceve.
@immutable
class BaStatoTocco {
  const BaStatoTocco({
    this.premuto = false,
    this.aFuoco = false,
    this.inattivo = false,
  });

  final bool premuto;
  final bool aFuoco;
  final bool inattivo;

  @override
  bool operator ==(Object other) =>
      other is BaStatoTocco &&
      other.premuto == premuto &&
      other.aFuoco == aFuoco &&
      other.inattivo == inattivo;

  @override
  int get hashCode => Object.hash(premuto, aFuoco, inattivo);
}

typedef BaTouchableBuilder = Widget Function(
  BuildContext context,
  BaStatoTocco stato,
);

class BaTouchable extends StatefulWidget {
  /// Dà **uno solo** fra [child] e [builder].
  const BaTouchable({
    super.key,
    required this.semanticsLabel,
    this.onTap,
    this.variante = BaVarianteTocco.standard,
    this.suChiara = false,
    this.estensione = EdgeInsets.zero,
    this.raggio = BaRaggioTokens.pillola,
    this.child,
    this.builder,
  }) : assert(
          (child == null) != (builder == null),
          'BaTouchable vuole uno solo fra child e builder',
        );

  /// Etichetta per lo screen reader. Il contenuto visivo è escluso dalla
  /// semantica: l'etichetta è l'unica rappresentazione accessibile.
  final String semanticsLabel;

  /// Nullo = inattivo: nessun feedback, non focalizzabile, `enabled: false`.
  final VoidCallback? onTap;

  final BaVarianteTocco variante;

  /// Il controllo è già chiaro: l'anello di focus prende il colore scuro.
  final bool suChiara;

  /// Quanto l'area toccabile sporge oltre il bordo, lato per lato. In una
  /// coppia ogni pillola estende di mezzo gap verso la vicina, così le aree
  /// non si sovrappongono. [estesa] dà `areaEstesa` su ogni lato.
  final EdgeInsets estensione;

  /// `areaEstesa` (8 dp) su ogni lato.
  static const EdgeInsets estesa = EdgeInsets.all(BaControlloTokens.areaEstesa);

  /// Raggio della forma del contenuto: ritaglia il velo e arrotonda l'anello.
  /// Un cerchio su un quadrato con il raggio pillola resta un cerchio.
  final double raggio;

  final Widget? child;
  final BaTouchableBuilder? builder;

  @override
  State<BaTouchable> createState() => _BaTouchableState();
}

class _BaTouchableState extends State<BaTouchable> {
  static const double _scalaRiposo = 1;

  late final FocusNode _focus = FocusNode(debugLabel: 'BaTouchable');
  bool _premuto = false;
  bool _aFuoco = false;

  bool get _attivo => widget.onTap != null;

  @override
  void didUpdateWidget(BaTouchable vecchio) {
    super.didUpdateWidget(vecchio);
    if (!_attivo && _premuto) _premuto = false;
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void _premi(bool premuto) {
    if (!_attivo || _premuto == premuto) return;
    setState(() => _premuto = premuto);
  }

  @override
  Widget build(BuildContext context) {
    final stato = BaStatoTocco(
      premuto: _premuto && _attivo,
      aFuoco: _aFuoco && _attivo,
      inattivo: !_attivo,
    );
    final suPresenza = widget.variante == BaVarianteTocco.suPresenza;
    final riduciMovimento = MediaQuery.disableAnimationsOf(context);
    final durata = riduciMovimento
        ? Duration.zero
        : (stato.premuto
            ? BaMovimentoTokens.premutoAndata
            : BaMovimentoTokens.premutoRitorno);

    Widget contenuto =
        widget.builder != null ? widget.builder!(context, stato) : widget.child!;

    if (!suPresenza) {
      // Velo e scala stanno insieme: il fondo cede con il contenuto. La scala
      // è una trasformazione, quindi i vicini non si spostano. Con "riduci
      // movimento" la scala si omette e resta il fondo: si taglia la resa,
      // non lo stato.
      final velo = BaColorTokens.premutoVelo;
      contenuto = Stack(
        fit: StackFit.passthrough,
        children: [
          contenuto,
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: durata,
                decoration: BoxDecoration(
                  color: stato.premuto ? velo : velo.withValues(alpha: 0),
                  borderRadius: BorderRadius.circular(widget.raggio),
                ),
              ),
            ),
          ),
        ],
      );
      contenuto = AnimatedScale(
        scale: stato.premuto && !riduciMovimento
            ? BaControlloTokens.premutoScala
            : _scalaRiposo,
        duration: durata,
        curve: BaMovimentoTokens.curvaAssestamento,
        child: contenuto,
      );
    }

    // Anello di focus: singolo, fuori dal contenuto (non cambia il layout),
    // immobile. Si vede ogni volta che il focus c'è, per qualunque via, e non
    // dipende da FocusHighlightMode.
    if (stato.aFuoco) {
      final fuori = BaControlloTokens.focusStacco + BaControlloTokens.focusSpessore;
      contenuto = Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          contenuto,
          Positioned(
            left: -fuori,
            top: -fuori,
            right: -fuori,
            bottom: -fuori,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.raggio + fuori),
                  border: Border.all(
                    color: widget.suChiara
                        ? BaColorTokens.focusAnelloSuChiara
                        : BaColorTokens.focusAnello,
                    width: BaControlloTokens.focusSpessore,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // L'area estesa sta fuori da tutto: ogni antenato che fa hit test taglia i
    // tocchi ai propri confini, quindi chi li allarga deve essere il più
    // esterno. Dentro, ConstrainedBox porta l'area ad almeno areaMinima e
    // Align tiene il contenuto centrato e della sua misura.
    return _AreaEstesa(
      estensione: widget.estensione,
      child: Semantics(
        label: widget.semanticsLabel,
        button: true,
        enabled: _attivo,
        focusable: _attivo,
        focused: _attivo ? stato.aFuoco : null,
        onTap: widget.onTap,
        excludeSemantics: true,
        child: FocusableActionDetector(
          enabled: _attivo,
          focusNode: _focus,
          onFocusChange: (haFuoco) => setState(() => _aFuoco = haFuoco),
          // Enter e spazio: li mappa su ActivateIntent WidgetsApp.defaultShortcuts.
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onTap?.call();
                return null;
              },
            ),
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: BaControlloTokens.areaMinima,
              minHeight: BaControlloTokens.areaMinima,
            ),
            child: Align(
              widthFactor: _scalaRiposo,
              heightFactor: _scalaRiposo,
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (_) => _premi(true),
                onPointerUp: (_) => _premi(false),
                onPointerCancel: (_) => _premi(false),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onTap,
                  onTapCancel: () => _premi(false),
                  child: contenuto,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Estende, nel hit test, l'area del figlio di [estensione] oltre il bordo,
/// senza spostare nulla nel layout. Schema del Material per i 48 dp: i tocchi
/// dentro la zona vengono inoltrati al centro del figlio.
class _AreaEstesa extends SingleChildRenderObjectWidget {
  const _AreaEstesa({required this.estensione, required super.child});

  final EdgeInsets estensione;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderAreaEstesa(estensione);

  @override
  void updateRenderObject(BuildContext context, _RenderAreaEstesa renderObject) {
    renderObject.estensione = estensione;
  }
}

class _RenderAreaEstesa extends RenderProxyBox {
  _RenderAreaEstesa(this._estensione);

  EdgeInsets _estensione;
  set estensione(EdgeInsets valore) {
    if (_estensione == valore) return;
    _estensione = valore;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final zona = Rect.fromLTRB(
      -_estensione.left,
      -_estensione.top,
      size.width + _estensione.right,
      size.height + _estensione.bottom,
    );
    if (!zona.contains(position)) return false;
    final figlio = child;
    if (figlio == null) return false;
    final centro = figlio.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(centro),
      position: centro,
      hitTest: (BoxHitTestResult risultato, Offset posizione) =>
          figlio.hitTest(risultato, position: centro),
    );
  }
}
