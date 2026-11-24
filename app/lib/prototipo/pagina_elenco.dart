// L'elenco dei DEN (task 024a, prototipi 013 A6 e 014 E1): l'intestazione «DEN» con
// «sei ascoltatore» o «sei partecipante», le righe (viva, spenta, su invito), la riga
// «Impostazioni ›» e l'azione «Crea un DEN». Il tocco di una riga porta nella stanza
// **come pubblico** (D-006). Un DEN privato su invito si vede solo da partecipante
// (D-041). L'elenco ha **un'azione sola** in fondo (014b); le impostazioni sono una
// riga, non un'azione: proposta del task 024, nessun documento dice da dove si aprono.
//
// «Crea un DEN»: da ascoltatore apre «diventa partecipante» (014 R1–R2) e a fine
// percorso l'account è partecipante; da partecipante è inattivo finché il 024b non
// collega i passi della creazione.
import 'package:flutter/widgets.dart';

import '../design_system/intestazione.dart';
import '../design_system/riga_den.dart';
import '../design_system/riga_impostazione.dart';
import 'fogli_partecipante.dart';
import 'pagina_base.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

class PaginaElenco extends StatelessWidget {
  const PaginaElenco({super.key});

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    return PaginaProto(
      nome: T.elencoNome,
      intestazione: BaIntestazione(
        nome: T.elencoTitolo,
        marcatore: stato.partecipante ? T.seiPartecipante : T.seiAscoltatore,
      ),
      corpo: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final d in stato.denVisibili)
              BaRigaDen(
                nome: d.nome,
                marcatore: T.marcatoreDen(d.suInvito ? 'Su invito' : 'Entra chiunque', d.palco.length),
                frase: d.palco.isEmpty ? d.frase : null,
                presenze: d.palco.length,
                tinte: d.palco.isEmpty ? const [0] : [for (final p in d.palco) p.tinta],
                sagome: d.palco.isEmpty ? const [0] : [for (final p in d.palco) p.sagoma],
                stato: d.suInvito
                    ? BaStatoRigaDen.suInvito
                    : (d.palco.isEmpty ? BaStatoRigaDen.spenta : BaStatoRigaDen.viva),
                onTap: () => stato.entraInDen(d),
              ),
            BaRigaImpostazione.valore(
              titolo: T.impostazioniRiga,
              onTap: () => stato.vai(const Rotta(Pagina.impostazioni)),
            ),
          ],
        ),
      ],
      azioni: [
        pillola(
          T.creaUnDen,
          stato.partecipante
              ? null
              : () => apriFoglioPartecipante(
                    context,
                    perCreare: true,
                    alTermine: stato.diventaPartecipante,
                  ),
        ),
      ],
    );
  }
}
