// «Chi può trovarmi» e il richiamo (task 024c, prototipo 030: V1–V2 e C1–C5). «Chi può trovarmi» ha
// tre scelte (Nessuno, Chi conosco, Tutti), ognuna con la sua conseguenza scritta; il valore di
// partenza è «Chi conosco» (ipotesi del 030). Il richiamo **parte spento**: un avviso quando una persona
// che hai scelto entra in un DEN pubblico e ti chiede di passare. Un consenso per persona, in due
// versi: «Chi puoi avvisare» (accendere apre la conferma «Avvisare Marta?», spegnere è subito) e «Chi
// può avvisarti» (tu decidi se ricevere l'avviso). Nessuna schermata mostra dove sia una persona.
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/pillola.dart';
import '../design_system/riga_consenso.dart';
import '../design_system/scelta_den.dart';
import 'pagina_base.dart';
import 'persone.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

class PaginaChiPuoTrovarmi extends StatefulWidget {
  const PaginaChiPuoTrovarmi({super.key});

  @override
  State<PaginaChiPuoTrovarmi> createState() => _PaginaChiPuoTrovarmiState();
}

class _PaginaChiPuoTrovarmiState extends State<PaginaChiPuoTrovarmi> {
  Visibilita? _scelta;

  static const _opzioni = [
    BaOpzioneScelta(titolo: T.visNessuno, descrizione: T.visNessunoFrase),
    BaOpzioneScelta(titolo: T.visConosco, descrizione: T.visConoscoFrase),
    BaOpzioneScelta(titolo: T.visTutti, descrizione: T.visTuttiFrase),
  ];

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final scelta = _scelta ?? stato.visibilita;
    return PaginaProto(
      nome: T.chiPuoTrovarmi,
      titolo: T.chiPuoTrovarmi,
      titoloSchermata: true,
      corpo: [
        BaSceltaDen(
          opzioni: _opzioni,
          scelta: scelta.index,
          onScelta: (i) => setState(() => _scelta = Visibilita.values[i]),
        ),
      ],
      azioni: [
        pillola(T.salva, () {
          stato.impostaVisibilita(scelta);
          stato.indietro();
        }, variante: BaVariantePillola.attiva),
        pillola(T.nonOra, stato.indietro, variante: BaVariantePillola.spenta),
      ],
    );
  }
}

/// «Chi puoi avvisare» (C3): un `BaRigaConsenso` per persona aggiunta, tutte spente di partenza.
class PaginaChiPuoiAvvisare extends StatelessWidget {
  const PaginaChiPuoiAvvisare({super.key});

  /// Accendere passa da una conferma (C4); spegnere è subito.
  Future<void> _cambia(BuildContext context, Contatto c, bool voluto) async {
    final stato = ProtoScope.leggi(context);
    if (!voluto) {
      stato.impostaAvvisoA(c.id, false);
      return;
    }
    final conferma = await showBaFoglio<bool>(
      context,
      etichettaVelo: T.chiudi,
      builder: (foglio) => BaFoglio.richiesta(
        titolo: T.avvisareTitolo(c.nome),
        paragrafi: [T.avvisareConferma(c.nome)],
        azioni: [
          azioneFoglio(T.avvisaNome(c.nome), () => Navigator.of(foglio).pop(true), variante: BaVariantePillola.attiva),
          azioneFoglio(T.nonOra, () => Navigator.of(foglio).pop(false)),
        ],
      ),
    );
    if (conferma == true) stato.impostaAvvisoA(c.id, true);
  }

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final aggiunte = [for (final c in contatti) if (stato.aggiunte.contains(c.id)) c];
    return PaginaProto(
      nome: T.chiPuoiAvvisare,
      titolo: T.chiPuoiAvvisare,
      titoloSchermata: true,
      corpo: [
        const Frase(T.avvisareFrase),
        if (aggiunte.isEmpty)
          const Frase(T.nessunaPersona, piccola: true)
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final c in aggiunte)
                BaRigaConsenso(
                  nome: c.nome,
                  alias: c.alias,
                  tinta: c.persona.tinta,
                  sagoma: c.persona.sagoma,
                  acceso: stato.avvisoA.contains(c.id),
                  parolaAcceso: T.acceso,
                  parolaSpento: T.spento,
                  onCambia: (v) => _cambia(context, c, v),
                ),
            ],
          ),
      ],
      azioni: [pillola(T.indietro, stato.indietro, variante: BaVariantePillola.spenta)],
    );
  }
}

/// «Chi può avvisarti» (C5): solo chi ha scelto di avvisarti; tu decidi se ricevere l'avviso.
class PaginaChiPuoAvvisarti extends StatelessWidget {
  const PaginaChiPuoAvvisarti({super.key});

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    return PaginaProto(
      nome: T.chiPuoAvvisarti,
      titolo: T.chiPuoAvvisarti,
      titoloSchermata: true,
      corpo: [
        const Frase(T.avvisartiFrase),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final e in stato.avvisoDa.entries)
              if (contattoPerId(e.key) case final c?)
                BaRigaConsenso(
                  nome: c.nome,
                  alias: c.alias,
                  tinta: c.persona.tinta,
                  sagoma: c.persona.sagoma,
                  acceso: e.value,
                  parolaAcceso: T.acceso,
                  parolaSpento: T.spento,
                  onCambia: (v) => stato.impostaAvvisoDa(c.id, v),
                ),
          ],
        ),
        const Frase(T.avvisartiNota, piccola: true),
      ],
      azioni: [pillola(T.indietro, stato.indietro, variante: BaVariantePillola.spenta)],
    );
  }
}
