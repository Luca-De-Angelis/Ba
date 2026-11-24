// BaRigaStato: le due righe sotto l'intestazione (task 029, Inventario C2): i
// **fatti della stanza** sopra («3 sul palco») e **le mie preferenze** sotto
// («Sei in coda»). Sono indipendenti e possono mancare separatamente.
//
// **Proposta del task 029** (i prototipi hanno un'altezza fissa e non dicono che
// cosa succede con una riga vuota): una riga che manca non lascia né testo né
// spazio; senza nessuna delle due il componente non occupa niente; fra due righe
// c'è una sola distanza (`BaSpazioTokens.sm`, come dice l'Inventario). Nessun
// conto alla rovescia, nessun contatore che accumula: i testi sono fatti fermi
// scritti dal chiamante. Nessun annuncio dell'ingresso di altri (D-034).
//
// Toni dal prototipo 002: i fatti in `testoSecondo`, le mie preferenze in
// `testoTerzo`.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'marcatore.dart';
import 'tokens.dart';

class BaRigaStato extends StatelessWidget {
  const BaRigaStato({super.key, this.fatti, this.mie});

  /// I fatti della stanza. Nullo o vuoto = la riga non c'è.
  final String? fatti;

  /// Le mie preferenze. Nullo o vuoto = la riga non c'è.
  final String? mie;

  @override
  Widget build(BuildContext context) {
    final haFatti = fatti != null && fatti!.isNotEmpty;
    final haMie = mie != null && mie!.isNotEmpty;
    if (!haFatti && !haMie) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (haFatti) BaMarcatore(testo: fatti!, colore: BaColorTokens.testoSecondo),
        if (haFatti && haMie) const SizedBox(height: BaSpazioTokens.sm),
        if (haMie) BaMarcatore(testo: mie!),
      ],
    );
  }
}
