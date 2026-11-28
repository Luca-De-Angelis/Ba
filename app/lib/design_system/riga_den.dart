// BaRigaDen: una riga dell'elenco dei DEN (task 029, Inventario C4): il nome, un
// **campione di presenze** (le sagome piccole di `BaPubblico`: indici dal
// chiamante, nessuna iniziale) e la riga di marcatore («Entra chiunque · 5 sul
// palco»). Stati: *viva*, *spenta* (DEN vuoto: niente campione, una frase e una
// **sagoma vuota** a destra) e *su invito*. Gli stati «rimosso» e simili sono
// beta e non ci sono.
//
// **Il componente non stampa nessuna cifra:** il marcatore («5 sul palco») e la
// frase («Marta sta parlando») arrivano già composti, e le sagome del campione
// sono quelle di `BaPubblico.visibili` (da 1 a `campionePubblico`). Niente
// contatori che accumulano, niente anello su chi parla (l'Inventario lo mette fra
// i tagli del primo giro), niente annuncio dell'ingresso di altri (D-034).
//
// **Proposta del task 029:** *su invito* ha lo stesso aspetto di *viva* (nei
// prototipi cambia il testo: «su invito · 2 sul palco»); solo *spenta* è diversa.
// L'Inventario mette il campione di presenze nella riga fra i tagli; il brief lo
// chiede, e qui c'è.
//
// **Il motivo (task 034, 031 H1 «Proposti per te»):** parametro facoltativo `motivo`, una riga in
// più sotto la frase («Perché: tema Cucina», «Perché: in italiano»), a 14 in secondo piano. Senza,
// la riga è **identica** a prima. «Vicino a te» e «zona abituale» **non hanno un parametro**:
// arrivano nel [marcatore] già composto dal chiamante («zona abituale · entra chiunque · 5 sul
// palco»). Nessun segno del pagante, nessun contatore, nessuno stato di presenza e nessun luogo in cui si trova una persona.
//
// Con [onTap] la riga è toccabile (premuta e a fuoco da `BaTouchable`, area almeno
// `areaMinima`); senza, è solo testo. Per lo screen reader un solo elemento:
// nome, marcatore e frase.
//
// Valori che i token non hanno (segnalati nel report del task 029): l'altezza
// minima della riga (nel prototipo nessuna: padding 16 e contenuto) e la sagoma
// vuota (22: `BaPresenzaTokens.pubblico`).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'marcatore.dart';
import 'pubblico.dart';
import 'sagoma.dart';
import 'tokens.dart';
import 'touchable.dart';

enum BaStatoRigaDen { viva, spenta, suInvito }

class BaRigaDen extends StatelessWidget {
  const BaRigaDen({
    super.key,
    required this.nome,
    this.marcatore,
    this.frase,
    this.presenze = 0,
    this.tinte = const [0],
    this.sagome = const [0],
    this.stato = BaStatoRigaDen.viva,
    this.onTap,
    this.semanticsLabel,
    this.motivo,
  });

  final String nome;

  /// La riga di marcatore, già composta («Entra chiunque · 5 sul palco»).
  final String? marcatore;

  /// Una frase sotto («Marta sta parlando», «Vuoto. Puoi restare e ti avviso.»).
  final String? frase;

  /// Quante persone sono sul palco: decide quante sagome ha il campione (al più
  /// `campionePubblico`). Non si stampa mai. Nella riga *spenta* non conta.
  final int presenze;

  /// Indici nel mazzo di `BaTintaTokens` e di `BaSagomaTokens`, stabili.
  final List<int> tinte;
  final List<int> sagome;

  final BaStatoRigaDen stato;

  /// Nullo = la riga non si tocca.
  final VoidCallback? onTap;

  /// Se manca: nome, marcatore, frase e motivo.
  final String? semanticsLabel;

  /// Il motivo per cui un DEN è proposto, già composto dal chiamante («Perché: tema Cucina»): una
  /// riga sotto la frase, a 14. Nullo = nessuna riga e nessuno spazio.
  final String? motivo;

  bool get _spenta => stato == BaStatoRigaDen.spenta;

  @override
  Widget build(BuildContext context) {
    final parole = semanticsLabel ?? [nome, ?marcatore, ?frase, ?motivo].join('. ');
    final contenuto = _Contenuto(riga: this);
    if (onTap == null) {
      return Semantics(container: true, label: parole, excludeSemantics: true, child: contenuto);
    }
    return Semantics(
      container: true,
      child: BaTouchable(
        semanticsLabel: parole,
        onTap: onTap,
        raggio: 0,
        builder: (context, stato) => contenuto,
      ),
    );
  }
}

class _Contenuto extends StatelessWidget {
  const _Contenuto({required this.riga});

  final BaRigaDen riga;

  @override
  Widget build(BuildContext context) {
    final n = riga._spenta ? 0 : BaPubblico.visibili(riga.presenze);
    final haMarcatore = riga.marcatore != null && riga.marcatore!.isNotEmpty;
    return Container(
      constraints: const BoxConstraints(minHeight: BaControlloTokens.areaMinima, minWidth: double.infinity),
      padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.l),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BaColorTokens.filettoDivisorio)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(riga.nome, style: BaTestoTokens.riga.copyWith(color: BaColorTokens.testoPrimo)),
                if (n > 0 || haMarcatore) ...[
                  const SizedBox(height: BaSpazioTokens.s),
                  Wrap(
                    spacing: BaSpazioTokens.sm,
                    runSpacing: BaSpazioTokens.xxs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (n > 0) _Campione(n: n, tinte: riga.tinte, sagome: riga.sagome),
                      if (haMarcatore) BaMarcatore(testo: riga.marcatore!),
                    ],
                  ),
                ],
                if (riga.frase != null) ...[
                  const SizedBox(height: BaSpazioTokens.s),
                  Text(riga.frase!, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
                ],
                if (riga.motivo != null) ...[
                  const SizedBox(height: BaSpazioTokens.s),
                  Text(riga.motivo!, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
                ],
              ],
            ),
          ),
          if (riga._spenta) ...[
            const SizedBox(width: BaSpazioTokens.m),
            const Padding(
              padding: EdgeInsets.only(top: BaSpazioTokens.xxs),
              child: _SagomaVuota(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Il campione: [n] sagome piccole, senza iniziali.
class _Campione extends StatelessWidget {
  const _Campione({required this.n, required this.tinte, required this.sagome});

  final int n;
  final List<int> tinte;
  final List<int> sagome;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < n; i++) ...[
          if (i > 0) const SizedBox(width: BaSpazioTokens.xxs),
          BaSagoma(tinta: tinte[i % tinte.length], sagoma: sagome[i % sagome.length], lato: BaPresenzaTokens.pubblico),
        ],
      ],
    );
  }
}

/// La sagoma vuota della riga spenta: il contorno, senza riempimento.
class _SagomaVuota extends StatelessWidget {
  const _SagomaVuota();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BaSagomaTokens.bordo(0, BaPresenzaTokens.pubblico),
        border: Border.all(color: BaColorTokens.filettoMarcato),
      ),
      child: const SizedBox.square(dimension: BaPresenzaTokens.pubblico),
    );
  }
}
