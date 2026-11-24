// BaMarcatore: il marcatore a sé (task 029, Inventario C2): una riga in mono
// maiuscolo che dice un fatto della stanza, del conteggio o dell'orario («entra
// chiunque», «5 sul palco», «dalle 21:40»). **Un solo stato: è un fatto fermo.**
// Nessun timer, nessun ticker, nessun conto alla rovescia: il testo arriva già
// composto dal chiamante e il componente non lo calcola né lo aggiorna.
//
// Il testo si scrive in maiuscolo qui (come `BaPubblico` e `BaPuntoAggancio`) e
// scala fino a `BaScalaTokens.maxMarcatore`; per lo screen reader si legge il
// testo come l'ha scritto il chiamante, non in maiuscolo.
//
// [colore] è il tono, non uno stato: lo dà chi lo usa (l'intestazione
// disconnessa lo spegne, la riga di stato dei fatti lo alza di un passo).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';

class BaMarcatore extends StatelessWidget {
  const BaMarcatore({
    super.key,
    required this.testo,
    this.colore = BaColorTokens.testoTerzo,
    this.semanticsLabel,
  });

  /// Il fatto, già composto e tradotto.
  final String testo;

  /// Il tono del testo: `testoTerzo` di norma.
  final Color colore;

  /// Se manca: [testo].
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticsLabel ?? testo,
      excludeSemantics: true,
      child: Text(
        testo.toUpperCase(),
        textScaler: TextScaler.linear(BaScalaTokens.marcatore(context)),
        style: BaTestoTokens.marcatore.copyWith(color: colore),
      ),
    );
  }
}
