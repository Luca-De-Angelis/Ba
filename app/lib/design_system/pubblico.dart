// BaPubblico: il campione e il contatore di chi ascolta (Inventario C3). Nessuno:
// non si disegna. Da 1 a 3: tante sagome quante sono. Oltre 3: un campione fisso
// di `campionePubblico`. Le sagome sono quelle delle presenze, piccole
// (`BaPresenzaTokens.pubblico`) e senza iniziali; non è una BaPresenza, perché
// non ha anello, banda né semantica da persona.
//
// Nessuna animazione: le sagome compaiono e spariscono, il campione non ruota
// (T8). Una sola etichetta di semantica, quella del contatore.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';

class BaPubblico extends StatelessWidget {
  const BaPubblico({
    super.key,
    required this.conteggio,
    required this.testo,
    required this.tinte,
    required this.sagome,
  });

  /// Quante persone ascoltano. Zero o meno: non si disegna niente.
  final int conteggio;

  /// Il contatore, già composto e tradotto («14 in ascolto»). Si scrive in
  /// maiuscolo (marcatore) e serve anche da etichetta per lo screen reader.
  final String testo;

  /// Indici nel mazzo di `BaTintaTokens` e di `BaSagomaTokens`, uno per sagoma,
  /// scelti dal chiamante e stabili: l'i-esima sagoma usa `tinte[i]` e
  /// `sagome[i]` (si ricomincia da capo se sono meno delle sagome).
  final List<int> tinte;
  final List<int> sagome;

  /// Quante sagome si vedono: da 0 a `campionePubblico`.
  static int visibili(int conteggio) =>
      conteggio <= 0 ? 0 : (conteggio < BaPresenzaTokens.campionePubblico ? conteggio : BaPresenzaTokens.campionePubblico);

  @override
  Widget build(BuildContext context) {
    final n = visibili(conteggio);
    if (n == 0) return const SizedBox.shrink();
    assert(tinte.isNotEmpty && sagome.isNotEmpty, 'BaPubblico vuole almeno una tinta e una sagoma');

    final gruppo = <Widget>[];
    for (var i = 0; i < n; i++) {
      if (i > 0) gruppo.add(const SizedBox(width: BaSpazioTokens.xxs));
      gruppo.add(_Sagoma(
        tinta: tinte[i % tinte.length],
        sagoma: sagome[i % sagome.length],
      ));
    }

    return Semantics(
      label: testo,
      container: true,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: BaControlloTokens.areaMinima),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: gruppo),
            const SizedBox(width: BaSpazioTokens.sm),
            Flexible(
              child: Text(
                testo.toUpperCase(),
                textScaler: TextScaler.linear(BaScalaTokens.marcatore(context)),
                style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sagoma extends StatelessWidget {
  const _Sagoma({required this.tinta, required this.sagoma});

  final int tinta;
  final int sagoma;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BaSagomaTokens.bordo(sagoma, BaPresenzaTokens.pubblico),
        gradient: BaTintaTokens.mazzo[tinta % BaTintaTokens.mazzo.length].gradiente,
      ),
      child: const SizedBox.square(dimension: BaPresenzaTokens.pubblico),
    );
  }
}
