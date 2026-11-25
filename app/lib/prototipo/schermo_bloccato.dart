// Lo schermo bloccato **simulato** (task 024b, prototipo 027 L1–L4, D-050): sopra la cornice,
// con la dicitura «simulazione». Riflette lo stato vero della stanza:
//   L1 sul palco con il microfono acceso: «Spegni il microfono»;
//   L2 sul palco a microfono spento: solo il testo, **nessuna azione per accenderlo** (D-025:
//      dal telefono bloccato il microfono si spegne e non si accende);
//   L3 nel pubblico, in diretta: «Pausa»;
//   L4 nel pubblico, in pausa: «Riprendi dal vivo».
// «Esci» esce dalla stanza; «Prossimo DEN» è inattivo (la fonte è da definire); «Sblocca» chiude
// la simulazione. Non è l'app: è come la vedrebbe chi guarda il telefono bloccato.
import 'package:flutter/widgets.dart';

import '../design_system/marcatore.dart';
import '../design_system/pillola.dart';
import '../design_system/tokens.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

class SchermoBloccato extends StatelessWidget {
  const SchermoBloccato({super.key});

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final margine = BaLayoutTokens.margine(MediaQuery.of(context).size.width);
    final den = stato.denCorrente;
    final sulPalco = stato.ruolo == Ruolo.sulPalco;

    final String fatto;
    final List<Widget> azioni;
    if (den == null) {
      fatto = T.bloccatoNessunDen;
      azioni = const [];
    } else if (sulPalco) {
      fatto = stato.micAcceso ? T.tuMicAcceso : T.micSpentoBloccato;
      // L1: si può spegnere. L2: nessuna azione per accenderlo.
      azioni = [if (stato.micAcceso) pillola(T.spegniMic, stato.spegniMic)];
    } else {
      fatto = stato.inPausa ? T.inPausaFrase : T.inDirettaFrase;
      azioni = [
        pillola(
          stato.inPausa ? T.riprendiDalVivo : T.pausa,
          stato.cambiaPausa,
          variante: stato.inPausa ? BaVariantePillola.chiara : BaVariantePillola.attiva,
        ),
      ];
    }

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: T.bloccatoSimulazione,
      child: ColoredBox(
        color: BaColorTokens.fondoApp,
        child: Padding(
          padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.xxl, margine, BaSpazioTokens.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BaMarcatore(testo: T.bloccatoSimulazione),
              const SizedBox(height: BaSpazioTokens.xxl),
              if (den != null) Text(den.nome, style: BaTestoTokens.stanza.copyWith(color: BaColorTokens.testoPrimo)),
              const SizedBox(height: BaSpazioTokens.s),
              Text(fatto, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoSecondo)),
              const Spacer(),
              for (final a in azioni) ...[a, const SizedBox(height: BaControlloTokens.gapCoppia)],
              if (den != null) ...[
                pillola(T.esci, () {
                  stato.sbloccaLoSchermo();
                  stato.esciDallaStanza();
                }, variante: BaVariantePillola.spenta),
                const SizedBox(height: BaControlloTokens.gapCoppia),
                // La fonte del prossimo DEN non è decisa: inattivo.
                pillola(T.prossimoDen, null, variante: BaVariantePillola.spenta),
                const SizedBox(height: BaControlloTokens.gapCoppia),
              ],
              pillola(T.sblocca2, stato.sbloccaLoSchermo, variante: BaVariantePillola.chiara),
            ],
          ),
        ),
      ),
    );
  }
}
