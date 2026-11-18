// Un Navigator dentro una schermata finta della galleria (task 021).
//
// I fogli si aprono con il Navigator del loro contesto. Nell'app vera ce n'è
// uno solo e il foglio copre lo schermo. Nella galleria la «schermata» è una
// scatola con la sua larghezza (360 o 744), il suo testo di sistema (1,0 o 2,0)
// e il suo «riduci movimento», che sono override di MediaQuery: un foglio
// aperto dal Navigator della galleria sarebbe fuori da quella scatola e non li
// leggerebbe. Con un Navigator interno il foglio copre solo la scatola, come su
// un telefono, e vede gli stessi override.
//
// La pagina di base è dichiarativa (`pages`): quando la galleria si ridisegna
// la pagina si aggiorna, e i fogli aperti sopra restano. Il gesto «indietro»
// del sistema chiude il foglio in cima (NavigatorPopHandler).
import 'package:flutter/widgets.dart';

class GalleriaNavigator extends StatefulWidget {
  const GalleriaNavigator({super.key, required this.child});

  final Widget child;

  @override
  State<GalleriaNavigator> createState() => _GalleriaNavigatorState();
}

class _GalleriaNavigatorState extends State<GalleriaNavigator> {
  final GlobalKey<NavigatorState> _navigatore = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler<void>(
      onPopWithResult: (_) => _navigatore.currentState?.maybePop(),
      child: Navigator(
        key: _navigatore,
        pages: [_Pagina(child: widget.child)],
        onDidRemovePage: (_) {},
      ),
    );
  }
}

class _Pagina extends Page<void> {
  const _Pagina({required this.child}) : super(key: const ValueKey('galleria-pagina'));

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) => _Rotta(this);
}

class _Rotta extends PageRoute<void> {
  _Rotta(_Pagina pagina) : super(settings: pagina);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      (settings as _Pagina).child;

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration.zero;
}
