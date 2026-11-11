// Geometria condivisa dei contorni che seguono una forma (anello della voce,
// anello di focus, keyline del premuto).
import 'package:flutter/widgets.dart';

/// Gli stessi angoli di [b], ingranditi di [t] su entrambi gli assi: serve al
/// contorno che sta [t] fuori dalla forma. Per gli angoli ellittici è
/// un'approssimazione (l'offset di un'ellisse non è un'ellisse); a pochi dp
/// non si vede.
BorderRadius ingrandisci(BorderRadius b, double t) {
  Radius r(Radius o) => Radius.elliptical(o.x + t, o.y + t);
  return BorderRadius.only(
    topLeft: r(b.topLeft),
    topRight: r(b.topRight),
    bottomRight: r(b.bottomRight),
    bottomLeft: r(b.bottomLeft),
  );
}
