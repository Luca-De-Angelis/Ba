// I fogli della coda (task 024b, prototipo 015): «Mettiti in coda» (K2, con e senza
// «Aspetta con altri» K2 ter), «Aspetta con altri» (W1), «Le tue code» (K1), «La coda è
// piena adesso» (S1) e «Vuoi passare di qua?» (K6). Sono i fogli del design system con il
// loro stato finto: gli interruttori cambiano davvero, ma nessuna posizione, nessun
// conteggio e **nessun conto alla rovescia** (il tempo è la frase «pochi secondi»).
//
// «Aspetta con altri» c'è solo per chi ha la capacità (un interruttore del pannello): chi
// non ce l'ha non vede né l'etichetta né una traccia della riga (022).
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/foglio_passi.dart';
import '../design_system/fogli_coda.dart';
import '../design_system/interruttore_riga.dart';
import '../design_system/riga_coda.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

/// «Mettiti in coda» (K2). Con «Aspetta con altri» acceso, «Mettiti in coda» porta a W1.
Future<void> apriMettitiInCoda(BuildContext context) async {
  final stato = ProtoScope.leggi(context);
  final d = stato.denCorrente;
  if (d == null) return;
  if (d.codaPiena) {
    await apriCodaPiena(context);
    return;
  }
  final vai = await showBaFoglio<bool>(
    context,
    etichettaVelo: T.chiudi,
    builder: (_) => const _MettitiInCoda(),
  );
  if (vai != true || !context.mounted) return;
  if (stato.capacitaAspettare && stato.aspettaConAltri) {
    await apriAspetta(context);
  } else {
    stato.mettitiInCoda();
  }
}

class _MettitiInCoda extends StatelessWidget {
  const _MettitiInCoda();

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    return BaFoglioMettitiInCoda(
      titolo: T.mettitiInCoda,
      frase: T.mettitiFrase,
      ingressoAutomatico: BaInterruttoreRiga(
        titolo: T.ingressoTitolo,
        descrizione: stato.ingressoAutomatico ? T.ingressoAcceso : T.ingressoSpento,
        acceso: stato.ingressoAutomatico,
        parolaAcceso: T.acceso,
        parolaSpento: T.spento,
        onCambia: stato.impostaIngressoAutomatico,
      ),
      // Solo per chi ha la capacità: senza, la riga non esiste.
      aspettaConAltri: stato.capacitaAspettare
          ? BaInterruttoreRiga(
              titolo: T.aspettaTitolo,
              descrizione: T.aspettaDescrizione,
              acceso: stato.aspettaConAltri,
              parolaAcceso: T.acceso,
              parolaSpento: T.spento,
              onCambia: stato.impostaAspettaConAltri,
            )
          : null,
      rigaSale: T.saliraiMicSpento,
      mettitiInCoda: azioneFoglio(T.mettitiInCoda, () => Navigator.of(context).pop(true)),
      nonOra: azioneFoglio(T.nonOra, () => Navigator.of(context).pop(false)),
    );
  }
}

/// «Aspetta con altri» (W1): «Entra nel gruppo» mette in coda, nel gruppo d'attesa.
Future<void> apriAspetta(BuildContext context) async {
  final stato = ProtoScope.leggi(context);
  final entra = await showBaFoglio<bool>(
    context,
    etichettaVelo: T.chiudi,
    builder: (foglio) => BaFoglioAspettaConAltri(
      titolo: T.aspettaTitolo,
      paragrafi: const [BaParagrafoPasso(T.aspettaP1), BaParagrafoPasso(T.aspettaP2, evidenza: true)],
      entra: azioneFoglio(T.entraNelGruppo, () => Navigator.of(foglio).pop(true)),
      nonOra: azioneFoglio(T.nonOra, () => Navigator.of(foglio).pop(false)),
    ),
  );
  if (entra == true) stato.mettitiInCoda(ingruppo: true);
}

/// «Le tue code» (K1): una riga per coda, con «Esci dalla coda».
Future<void> apriLeTueCode(BuildContext context) => showBaFoglio<void>(
      context,
      etichettaVelo: T.chiudi,
      builder: (_) => const _LeTueCode(),
    );

class _LeTueCode extends StatelessWidget {
  const _LeTueCode();

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    return BaFoglioLeTueCode(
      titolo: T.codeTitolo,
      frase: T.codeFrase,
      code: [
        for (final id in stato.code)
          if (stato.denPerId(id) != null)
            BaRigaCoda(
              nome: stato.denPerId(id)!.nome,
              stato: T.codeStato,
              uscitaTesto: T.esciDallaCoda,
              uscitaSemanticsLabel: '${T.esciDallaCoda}, ${stato.denPerId(id)!.nome}',
              onEsci: () => stato.esciDallaCoda(id),
            ),
      ],
      chiudi: azioneFoglio(T.chiudi, () => Navigator.of(context).pop()),
    );
  }
}

/// «La coda è piena adesso» (S1): si resta nel pubblico e si ascolta.
Future<void> apriCodaPiena(BuildContext context) => showBaFoglio<void>(
      context,
      etichettaVelo: T.chiudi,
      builder: (foglio) => BaFoglioCodaPiena(
        titolo: T.codaPienaTitolo,
        frase: T.codaPienaFrase,
        haCapito: azioneFoglio(T.hoCapito, () => Navigator.of(foglio).pop()),
      ),
    );

/// «Vuoi passare di qua?» (K6): si partecipa a un solo DEN alla volta (D-042). [titolo] e
/// [primo] dicono perché (un posto che si libera, un richiamo); «Passa» porta nel DEN.
Future<void> apriPassaDiQua(BuildContext context,
    {required Den verso, required String titolo, required String primo, String? invitoDa}) async {
  final stato = ProtoScope.leggi(context);
  final passa = await showBaFoglio<bool>(
    context,
    etichettaVelo: T.chiudi,
    builder: (foglio) => BaFoglioPassaDiQua(
      titolo: titolo,
      paragrafi: [BaParagrafoPasso(primo), const BaParagrafoPasso(T.passaP2, evidenza: true)],
      passa: azioneFoglio(T.passa, () => Navigator.of(foglio).pop(true)),
      restaQui: azioneFoglio(T.restaQui, () => Navigator.of(foglio).pop(false)),
    ),
  );
  if (passa != true) return;
  // Un invito accettato: si entra fra il pubblico e la stanza lo dice.
  if (invitoDa != null) {
    stato.entraPerInvito(verso, invitoDa);
  } else {
    stato.passaA(verso);
  }
}
