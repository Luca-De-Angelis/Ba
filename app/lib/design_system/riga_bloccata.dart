// BaRigaBloccata: una persona bloccata da te, nella schermata «Persone bloccate»
// (task 029, Inventario C4): la sagoma neutra, il nome, una data sfocata in mono
// («in aprile») e «Sblocca». Stati: *bloccata*, *sblocco in corso* e *sbloccata*.
// Gli stati beta («ricevuto», «rimosso») non ci sono.
//
// **Proposte del task 029** (i prototipi disegnano solo la riga bloccata):
//   - *sblocco in corso*: l'azione è inattiva e il suo testo diventa quello che dà
//     il chiamante («Sblocco…»): una frase ferma, nessuno spinner e nessun timer;
//   - *sbloccata*: la persona esce dall'elenco, quindi **la riga non si disegna e
//     non lascia spazio**.
//
// La sagoma è una `BaPresenza` bloccata (tinta che scompare, l'identità no) dentro
// un `BaDiametro` di `BaPresenzaTokens.minimo` (32): il prototipo 001 ha 44, ma il
// diametro di una presenza viene dalla scala, e 32 è il suo fondo. **Differenza
// segnalata nel report del task 029.** Per lo screen reader la riga ha due
// elementi: il nome (con la data) e il bottone.
//
// Valori che i token non hanno: l'altezza minima della riga (72 nel prototipo: uso
// `BaControlloTokens.primario`, 56).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'marcatore.dart';
import 'pillola.dart';
import 'presenza.dart';
import 'tokens.dart';

enum BaStatoRigaBloccata { bloccata, sbloccoInCorso, sbloccata }

class BaRigaBloccata extends StatelessWidget {
  const BaRigaBloccata({
    super.key,
    required this.nome,
    this.iniziali,
    this.tinta = 0,
    this.sagoma = 0,
    this.data,
    this.stato = BaStatoRigaBloccata.bloccata,
    required this.sbloccaTesto,
    this.sbloccoInCorsoTesto,
    this.onSblocca,
    this.sbloccaSemanticsLabel,
  });

  final String nome;

  /// Le iniziali nella sagoma; senza, la sagoma è nuda.
  final String? iniziali;

  /// Gli indici della tinta e della sagoma, dal chiamante.
  final int tinta;
  final int sagoma;

  /// Una data sfocata in mono («in aprile», «stasera»), già composta.
  final String? data;

  final BaStatoRigaBloccata stato;

  /// «Sblocca».
  final String sbloccaTesto;

  /// Il testo dell'azione mentre lo sblocco è in corso («Sblocco…»). Se manca,
  /// resta [sbloccaTesto].
  final String? sbloccoInCorsoTesto;

  /// Nullo = l'azione è inattiva. Con lo sblocco in corso lo è comunque.
  final VoidCallback? onSblocca;

  /// Se manca: [sbloccaTesto].
  final String? sbloccaSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    if (stato == BaStatoRigaBloccata.sbloccata) return const SizedBox.shrink();
    final inCorso = stato == BaStatoRigaBloccata.sbloccoInCorso;
    final testoAzione = inCorso
        ? (sbloccoInCorsoTesto ?? sbloccaTesto)
        : sbloccaTesto;
    return Container(
      constraints: const BoxConstraints(
        minHeight: BaControlloTokens.primario,
        minWidth: double.infinity,
      ),
      padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.m),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BaColorTokens.filettoDivisorio)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: BaSpazioTokens.m,
        runSpacing: BaSpazioTokens.s,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // La sagoma non ha semantica propria: la riga dice già il nome.
              ExcludeSemantics(
                child: BaDiametro(
                  diametro: BaPresenzaTokens.minimo,
                  child: BaPresenza(
                    semanticsLabel: nome,
                    indiceTinta: tinta,
                    indiceSagoma: sagoma,
                    iniziali: iniziali,
                    bloccata: true,
                  ),
                ),
              ),
              const SizedBox(width: BaSpazioTokens.m),
              Flexible(
                child: Semantics(
                  container: true,
                  label: [nome, ?data].join('. '),
                  excludeSemantics: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        nome,
                        style: BaTestoTokens.corpo.copyWith(
                          color: BaColorTokens.testoPrimo,
                        ),
                      ),
                      if (data != null) ...[
                        const SizedBox(height: BaSpazioTokens.xxs),
                        BaMarcatore(testo: data!),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          // container: l'azione è un nodo suo, anche se inattiva.
          Semantics(
            container: true,
            child: IntrinsicWidth(
              child: BaPillola(
                testo: testoAzione,
                semanticsLabel: sbloccaSemanticsLabel ?? testoAzione,
                variante: BaVariantePillola.spenta,
                onTap: inCorso ? null : onSblocca,
                allarga: false,
                altezzaMinima: BaControlloTokens.areaMinima,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
