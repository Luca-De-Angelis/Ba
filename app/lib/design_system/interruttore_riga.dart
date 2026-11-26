// BaInterruttoreRiga: una riga con un interruttore («Fammi entrare
// automaticamente», «Aspetta con altri»; Inventario C4). Titolo e descrizione a
// sinistra; a destra l'interruttore con **la parola sotto** («Acceso» /
// «Spento», dal chiamante).
//
// **Acceso non è mai il solo colore:** ha il bordo spesso (`interruttoreBordoAcceso`),
// il pallino dalla parte opposta e la parola. Spento ha il bordo sottile, il
// pallino a sinistra e la sua parola.
//
// Tutta la riga è toccabile (BaTouchable, area ≥ 44): non solo l'interruttore.
// Per lo screen reader è un interruttore (`toggled`). Con testo grande il testo
// va a capo e l'interruttore resta a destra.
//
// Nessuna animazione del pallino: T8 non ne prevede, e lo spostamento è
// immediato, come la comparsa delle presenze.
//
// Il fondo dell'interruttore acceso è `BaCodaTokens.interruttoreFondoAcceso` (sabbia300 a16) e
// il pallino spento è a metà (`interruttorePallinoSpentoOpacita`): token del task 032.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';
import 'touchable.dart';

class BaInterruttoreRiga extends StatelessWidget {
  const BaInterruttoreRiga({
    super.key,
    required this.titolo,
    this.descrizione,
    required this.acceso,
    required this.parolaAcceso,
    required this.parolaSpento,
    this.onCambia,
    this.semanticsLabel,
  });

  final String titolo;

  /// Una riga di spiegazione sotto il titolo; può andare a capo.
  final String? descrizione;

  final bool acceso;

  /// Le parole sotto l'interruttore, dal chiamante («Acceso», «Spento»).
  final String parolaAcceso;
  final String parolaSpento;

  /// Chiamata col valore nuovo. Nulla = inattivo: nessun feedback, non si
  /// focalizza.
  final ValueChanged<bool>? onCambia;

  /// Se manca: titolo e descrizione. Lo stato lo dice `toggled`, non il testo.
  final String? semanticsLabel;

  /// Il titolo e, sotto, la descrizione (che può andare a capo).
  Widget _testi(ValueChanged<bool>? onCambia) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            titolo,
            style: BaTestoTokens.controllo.copyWith(
              color: onCambia == null ? BaColorTokens.testoInattivo : BaColorTokens.testoPrimo,
            ),
          ),
          if (descrizione != null) ...[
            const SizedBox(height: BaSpazioTokens.xxs),
            Text(
              descrizione!,
              style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
            ),
          ],
        ],
      );

  @override
  Widget build(BuildContext context) {
    final onCambia = this.onCambia;
    return Semantics(
      container: true,
      toggled: acceso,
      child: BaTouchable(
        semanticsLabel: semanticsLabel ?? [titolo, ?descrizione].join('. '),
        onTap: onCambia == null ? null : () => onCambia(!acceso),
        raggio: 0,
        builder: (context, stato) => Container(
          constraints: const BoxConstraints(
            minHeight: BaControlloTokens.primario,
            minWidth: double.infinity,
          ),
          padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.m),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: BaColorTokens.filettoDivisorio)),
          ),
          // Dal testo a `azioneSottoDa` (1,3) la disposizione è verticale (task 032c): titolo e
          // descrizione a tutta larghezza (nessuna parola si spezza) e l'interruttore con la sua
          // parola sotto, a sinistra. A testo normale è com'era: l'interruttore a destra.
          child: BaScalaTokens.testo(context) >= BaPersoneTokens.azioneSottoDa
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _testi(onCambia),
                    const SizedBox(height: BaSpazioTokens.s),
                    _Interruttore(acceso: acceso, parola: acceso ? parolaAcceso : parolaSpento),
                  ],
                )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _testi(onCambia),
              ),
              const SizedBox(width: BaSpazioTokens.md),
              _Interruttore(acceso: acceso, parola: acceso ? parolaAcceso : parolaSpento),
            ],
          ),
        ),
      ),
    );
  }
}

/// L'interruttore e, sotto, la sua parola.
class _Interruttore extends StatelessWidget {
  const _Interruttore({required this.acceso, required this.parola});

  final bool acceso;
  final String parola;

  @override
  Widget build(BuildContext context) {
    final colore = acceso ? BaColorTokens.azioneChiara : BaColorTokens.testoTerzo;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: BaCodaTokens.interruttoreLarghezza,
          height: BaCodaTokens.interruttoreAltezza,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BaRaggioTokens.pillola),
              border: Border.all(
                color: acceso ? BaColorTokens.azioneChiara : BaColorTokens.ascoltoGruppoBordo,
                width: acceso ? BaCodaTokens.interruttoreBordoAcceso : BaCodaTokens.interruttoreBordo,
              ),
              // Acceso: il fondo è sabbia300 a16, un colore piatto (task 032); spento, nessun fondo.
              color: acceso ? BaCodaTokens.interruttoreFondoAcceso : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: BaSpazioTokens.xxs),
              child: Align(
                alignment: acceso ? Alignment.centerRight : Alignment.centerLeft,
                child: DecoratedBox(
                  // Spento il pallino è a metà (task 032): il segno di stato è la posizione e la parola.
                  decoration: BoxDecoration(shape: BoxShape.circle, color: acceso ? colore : BaColorTokens.testoPrimo.withValues(alpha: BaCodaTokens.interruttorePallinoSpentoOpacita)),
                  child: const SizedBox.square(dimension: BaCodaTokens.interruttorePallino),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: BaSpazioTokens.xxs),
        Text(
          parola.toUpperCase(),
          textScaler: TextScaler.linear(BaScalaTokens.marcatore(context)),
          style: BaTestoTokens.marcatore.copyWith(color: colore),
        ),
      ],
    );
  }
}
