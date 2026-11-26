// «Hai un invito» per chi ha BA (task 024c, prototipo 030: I2, I3, I3 bis). Il banner (la
// notifica dell'invito, I1) porta al foglio `BaFoglioInvito`: valido («Entra» / «Non ora»), scaduto o
// annullato («Ho capito»). Entrando si sta **fra il pubblico**, mai sul palco, nel DEN privato (D-041,
// D-006). Se si è già in una stanza, l'invito apre «Vuoi passare di qua?» (K6, D-042) invece del foglio.
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/foglio_invito.dart';
import '../design_system/pillola.dart';
import 'fogli_coda.dart';
import 'persone.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

/// Il tocco sul banner di un invito: [contesto] è quello del Navigator della cornice.
Future<void> apriInvito(BuildContext contesto, StatoProto stato, BannerProto b) async {
  final d = stato.denPerId(b.den);
  final chi = contattoPerId(b.chi ?? '')?.nome ?? '';
  if (d == null) return;
  switch (b.invito ?? StatoInvito.valido) {
    case StatoInvito.scaduto:
      await showBaFoglio<void>(
        contesto,
        etichettaVelo: T.chiudi,
        builder: (foglio) => BaFoglioInvito.scaduto(
          titolo: T.invitoScadutoTitolo,
          frase: T.invitoScadutoFrase(chi),
          haCapito: azioneFoglio(T.hoCapito, () => Navigator.of(foglio).pop()),
        ),
      );
    case StatoInvito.annullato:
      await showBaFoglio<void>(
        contesto,
        etichettaVelo: T.chiudi,
        builder: (foglio) => BaFoglioInvito.annullato(
          titolo: T.invitoAnnullatoTitolo,
          frase: T.invitoAnnullatoFrase,
          haCapito: azioneFoglio(T.hoCapito, () => Navigator.of(foglio).pop()),
        ),
      );
    case StatoInvito.valido:
      if (stato.denCorrente?.id == d.id) return;
      if (stato.denCorrente != null) {
        // Già in una stanza: si partecipa a uno solo alla volta (D-042).
        await apriPassaDiQua(contesto, verso: d, titolo: T.invitoTitolo(chi, d.nome), primo: T.invitoPassaP1, invitoDa: b.chi);
        return;
      }
      final entra = await showBaFoglio<bool>(
        contesto,
        etichettaVelo: T.chiudi,
        builder: (foglio) => BaFoglioInvito.valido(
          titolo: T.invitoTitolo(chi, d.nome),
          frase: T.invitoFrase,
          // «Entra» è attiva (a filetto), non piena come nel prototipo 030 (segnalato dal 033).
          entra: azioneFoglio(T.entra, () => Navigator.of(foglio).pop(true), variante: BaVariantePillola.attiva),
          nonOra: azioneFoglio(T.nonOra, () => Navigator.of(foglio).pop(false)),
        ),
      );
      if (entra == true) stato.entraPerInvito(d, b.chi ?? '');
  }
}
