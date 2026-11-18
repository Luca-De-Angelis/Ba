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
// Valori che i token non hanno (segnalati nel report del task 022): il fondo
// dell'interruttore acceso del prototipo (sabbia300 a16: uso `azioneAttivaFondo`,
// la più vicina) e il pallino spento a metà opacità (uso `testoTerzo`).
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
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
                ),
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
              gradient: acceso
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: BaColorTokens.azioneAttivaFondo,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: BaSpazioTokens.xxs),
              child: Align(
                alignment: acceso ? Alignment.centerRight : Alignment.centerLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: colore),
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
