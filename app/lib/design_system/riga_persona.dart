// BaRigaPersona: una riga di persona nelle viste di «Gestisci» (task 023b,
// prototipo 014: G2 bis «Co-amministratori» e G3 «Persone nel DEN»): la sagoma
// con la sua tinta, il nome, il ruolo o lo stato («sul palco», «co-amministratore»)
// e, a destra, un'azione testuale («Rimuovi», «Togli»).
//
// **Senza azione la riga non lascia né testo né spazio**: chi è co-amministratore
// non ha «Rimuovi» (prima si toglie il ruolo, D04). Il testo dell'azione e la
// sua etichetta per lo screen reader li dà il chiamante; se c'è il testo ma
// manca [onAzione], l'azione è inattiva.
//
// Sagoma e tinta sono **indici** assegnati da chi usa il componente (come in
// `BaPubblico`): non si calcolano dall'id. Per lo screen reader la riga ha due
// elementi: il nome con lo stato, e il bottone dell'azione.
//
// Valori che i token non hanno (segnalati nel report del task 023b): l'altezza
// minima della riga (56: uso `BaCreazioneTokens.sceltaAltezza`, stesso valore) e
// il lato della sagoma (32: uso `BaCodaTokens.gruppoPresenzaLato`, stesso valore).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';
import 'touchable.dart';

class BaRigaPersona extends StatelessWidget {
  const BaRigaPersona({
    super.key,
    required this.nome,
    required this.stato,
    this.tinta = 0,
    this.sagoma = 0,
    this.azione,
    this.onAzione,
    this.azioneSemanticsLabel,
  });

  final String nome;

  /// Il ruolo o lo stato, già composto dal chiamante («sul palco»).
  final String stato;

  /// Gli indici della tinta e della sagoma, dal chiamante.
  final int tinta;
  final int sagoma;

  /// Il testo dell'azione («Rimuovi»). Nullo = la riga non ha azione: né testo
  /// né spazio.
  final String? azione;

  /// Nullo, con un [azione], = l'azione è inattiva.
  final VoidCallback? onAzione;

  /// Se manca: [azione].
  final String? azioneSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: BaCreazioneTokens.sceltaAltezza,
        minWidth: double.infinity,
      ),
      padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.s),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BaColorTokens.filettoDivisorio)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BaSagomaTokens.bordo(sagoma, BaCodaTokens.gruppoPresenzaLato),
              gradient: BaTintaTokens.mazzo[tinta % BaTintaTokens.mazzo.length].gradiente,
            ),
            child: const SizedBox.square(dimension: BaCodaTokens.gruppoPresenzaLato),
          ),
          const SizedBox(width: BaSpazioTokens.m),
          Expanded(
            child: Semantics(
              container: true,
              label: '$nome. $stato',
              excludeSemantics: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(nome, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
                  const SizedBox(height: BaSpazioTokens.xxs),
                  Text(stato, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
                ],
              ),
            ),
          ),
          if (azione != null) ...[
            const SizedBox(width: BaSpazioTokens.m),
            // container: un nodo suo per lo screen reader, anche se inattiva.
            Semantics(
              container: true,
              child: BaTouchable(
                semanticsLabel: azioneSemanticsLabel ?? azione!,
                onTap: onAzione,
                raggio: 0,
                builder: (context, _) => ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: BaControlloTokens.areaMinima),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      azione!,
                      style: BaTestoTokens.minore.copyWith(
                        color: onAzione == null ? BaColorTokens.testoInattivo : BaColorTokens.testoPrimo,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
