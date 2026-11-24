// BaIntestazione: il nome della stanza e, sotto, il suo marcatore (task 029,
// Inventario C2). Cinque stati: pubblica, su invito, viva, in ingresso,
// disconnessa.
//
// **Proposta del task 029:** nei prototipi i primi quattro non si distinguono per
// l'aspetto ma per il testo del marcatore («entra chiunque», «su invito», «Sto
// entrando»), che arriva dal chiamante; solo *disconnessa* ha un aspetto proprio:
// nome e marcatore **spenti**. Lo stato non è il solo tono: il marcatore che il
// chiamante scrive lo dice a parole («linea persa»). L'enum c'è perché chi usa
// il componente nomini lo stato e perché i test lo provino per intero.
//
// Per lo screen reader un solo elemento, «nome. marcatore», come intestazione.
//
// Valori che i token non hanno (segnalati nel report del task 029): la distanza
// fra nome e marcatore (5 nel prototipo 002: uso `BaSpazioTokens.xs`).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'marcatore.dart';
import 'tokens.dart';

enum BaStatoIntestazione { pubblica, suInvito, viva, inIngresso, disconnessa }

class BaIntestazione extends StatelessWidget {
  const BaIntestazione({
    super.key,
    required this.nome,
    required this.marcatore,
    this.stato = BaStatoIntestazione.viva,
  });

  final String nome;

  /// Il marcatore sotto il nome, già composto («entra chiunque · 5 sul palco»).
  final String marcatore;

  final BaStatoIntestazione stato;

  @override
  Widget build(BuildContext context) {
    final spenta = stato == BaStatoIntestazione.disconnessa;
    return Semantics(
      container: true,
      header: true,
      label: '$nome. $marcatore',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nome,
            style: BaTestoTokens.stanza.copyWith(
              color: spenta ? BaColorTokens.testoTerzo : BaColorTokens.testoPrimo,
            ),
          ),
          const SizedBox(height: BaSpazioTokens.xs),
          BaMarcatore(
            testo: marcatore,
            colore: spenta ? BaColorTokens.testoInattivo : BaColorTokens.testoTerzo,
          ),
        ],
      ),
    );
  }
}
