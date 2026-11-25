// La navigazione del prototipo (task 024): un `Navigator` a `pages` dentro la
// cornice, guidato dalla pila di rotte dello stato finto. Niente dipendenze: il
// Navigator e `Page` stanno in widgets.dart. È la stessa idea di
// `GalleriaNavigator`, riscritta qui perché la galleria non si tocca e non si
// accoppia.
//
// Perché un Navigator dentro la cornice: i fogli si aprono con il Navigator del loro
// contesto, e la «schermata» è una scatola con la sua larghezza (360 o 744), il suo
// testo di sistema e il suo «riduci movimento», che sono override di `MediaQuery`.
// Con un Navigator interno il foglio copre solo la cornice, come su un telefono, e
// vede gli stessi override.
//
// Le pagine cambiano **senza transizione**: T8 non prevede un movimento fra pagine.
// Il gesto «indietro» del sistema chiude il foglio in cima, o toglie la pagina
// (NavigatorPopHandler).
import 'package:flutter/widgets.dart';

import 'pagine.dart';
import 'stato.dart';

class ProtoNavigatore extends StatefulWidget {
  const ProtoNavigatore({super.key});

  @override
  State<ProtoNavigatore> createState() => _ProtoNavigatoreState();
}

class _ProtoNavigatoreState extends State<ProtoNavigatore> {
  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    return NavigatorPopHandler<void>(
      onPopWithResult: (_) => ProtoScope.leggi(context).chiaveNavigatore.currentState?.maybePop(),
      child: Navigator(
        key: stato.chiaveNavigatore,
        pages: [for (final r in stato.pila) _PaginaRotta(r)],
        // La pagina in cima è stata tolta dal Navigator (gesto «indietro»): la pila segue.
        onDidRemovePage: (pagina) => stato.rimossa((pagina as _PaginaRotta).rotta),
      ),
    );
  }
}

class _PaginaRotta extends Page<void> {
  _PaginaRotta(this.rotta) : super(key: ValueKey<Rotta>(rotta));

  final Rotta rotta;

  @override
  Route<void> createRoute(BuildContext context) => _RottaProto(this);
}

class _RottaProto extends PageRoute<void> {
  _RottaProto(_PaginaRotta pagina) : super(settings: pagina);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      costruisciPagina((settings as _PaginaRotta).rotta);

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
