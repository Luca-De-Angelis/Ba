// Le pagine **fuori dall'app** dell'invito per chi non ha BA (task 024c, prototipo 030: I4 e I5): la
// mail e la pagina d'arrivo. Non sono dell'app: stanno sopra la cornice, marcate «fuori dall'app ·
// simulazione», con le due frasi e il bottone del prototipo. Poi l'accesso con email del 013 (A1–A5, le
// pagine vere del prototipo) e l'ingresso diretto nel DEN (I6), fra il pubblico. La mail non dice se
// chi ha invitato è nel DEN.
import 'package:flutter/widgets.dart';

import '../design_system/marcatore.dart';
import '../design_system/pillola.dart';
import '../design_system/tokens.dart';
import 'persone.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

class PaginaFuoriApp extends StatelessWidget {
  const PaginaFuoriApp({super.key});

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final margine = BaLayoutTokens.margine(MediaQuery.of(context).size.width);
    final mail = stato.fuoriApp == FuoriApp.mail;
    final chi = contattoPerId('marta')?.nome ?? '';
    final den = stato.denPerId('cena')?.nome ?? '';
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: mail ? T.mailMarcatore : T.paginaMarcatore,
      child: ColoredBox(
        color: BaColorTokens.fondoApp,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            margine,
            BaSpazioTokens.xxl,
            margine,
            BaSpazioTokens.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Il testo scorre (a testo grande non entra); il bottone resta ancorato in basso.
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BaMarcatore(testo: T.fuoriApp),
                      const SizedBox(height: BaSpazioTokens.s),
                      BaMarcatore(
                        testo: mail ? T.mailMarcatore : T.paginaMarcatore,
                      ),
                      const SizedBox(height: BaSpazioTokens.l),
                      Semantics(
                        header: true,
                        child: Text(
                          T.invitoTitolo(chi, den),
                          style: BaTestoTokens.stanza.copyWith(
                            color: BaColorTokens.testoPrimo,
                          ),
                        ),
                      ),
                      const SizedBox(height: BaSpazioTokens.l),
                      if (mail)
                        const Frase(T.mailFrase)
                      else ...[
                        const Frase(T.paginaP1),
                        const SizedBox(height: BaSpazioTokens.m),
                        const Frase(T.paginaP2, piccola: true),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: BaSpazioTokens.m),
              pillola(
                mail ? T.apriLInvito : T.continuaConLaEmail,
                mail ? stato.vaiAllaPagina : stato.continuaConLaEmail,
                variante: BaVariantePillola.chiara,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
