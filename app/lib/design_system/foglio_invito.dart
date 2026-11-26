// BaFoglioInvito: il foglio «Hai un invito» (task 033, Inventario C4; prototipo
// 030: I2, I3, I3 bis). Per chi ha BA: «Invito di Marta a Cena senza fretta»,
// una frase e due azioni, «Entra» e «Non ora». Due stati in cui l'invito non
// serve più: **scaduto** («Questo invito è scaduto») e **annullato** («Questo
// invito non è più valido»), con un'azione sola, «Ho capito».
//
// Un invito si accetta ascoltando: «Entra» porta fra il pubblico (D-006, D-041).
// Il foglio **non dice chi ha annullato né perché, e non dice se la persona che
// invita è nel DEN**. L'invito scade dopo 7 giorni (`BaPersoneTokens.invitoScadenza`,
// ipotesi) ma **l'interfaccia non mostra il numero di giorni**: il componente non lo
// conosce. Tutti i testi arrivano dal chiamante.
//
// **Primarie** (task 033): «Entra» è **attiva** (a filetto), come l'invito di
// `BaFoglio.invito`: un invito non blocca niente e «Non ora» c'è sempre (`BaRegole`
// 1); il prototipo la mostra piena (chiara): **differenza da correggere nel
// design**, e si cambia con `BaAzioneFoglio.variante`. «Ho capito» in scaduto e
// annullato è **chiara**, come nel prototipo e in «La coda è piena adesso» (023a).
//
// Si compone con le facce che `BaFoglio` ha già (`invito` e `richiesta`): nessun
// foglio nuovo, nessuna navigazione. La notifica a schermo bloccato (I1) è una
// superficie di sistema, senza azioni (D-025): **non è un widget Flutter**.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'foglio.dart';

enum BaStatoInvito { valido, scaduto, annullato }

class BaFoglioInvito extends StatelessWidget {
  const BaFoglioInvito._({super.key, required this.stato, required this.foglio});

  /// L'invito si può accettare: [titolo] («Invito di Marta a Cena senza
  /// fretta»), la [frase] («Entri ad ascoltare.»), «Entra» e «Non ora».
  BaFoglioInvito.valido({
    Key? key,
    required String titolo,
    required String frase,
    required BaAzioneFoglio entra,
    required BaAzioneFoglio nonOra,
  }) : this._(
          key: key,
          stato: BaStatoInvito.valido,
          foglio: BaFoglio.invito(titolo: titolo, paragrafi: [frase], azioni: [entra, nonOra]),
        );

  /// L'invito è scaduto («Questo invito è scaduto», «Chiedi a Marta di invitarti
  /// di nuovo.»): un'azione sola, «Ho capito».
  BaFoglioInvito.scaduto({
    Key? key,
    required String titolo,
    required String frase,
    required BaAzioneFoglio haCapito,
  }) : this._(
          key: key,
          stato: BaStatoInvito.scaduto,
          foglio: BaFoglio.richiesta(titolo: titolo, paragrafi: [frase], azioni: [haCapito]),
        );

  /// L'invito è stato annullato («Questo invito non è più valido», «Chi lo ha
  /// mandato lo ha annullato.»): un'azione sola, «Ho capito». Non dice chi né
  /// perché.
  BaFoglioInvito.annullato({
    Key? key,
    required String titolo,
    required String frase,
    required BaAzioneFoglio haCapito,
  }) : this._(
          key: key,
          stato: BaStatoInvito.annullato,
          foglio: BaFoglio.richiesta(titolo: titolo, paragrafi: [frase], azioni: [haCapito]),
        );

  final BaStatoInvito stato;
  final BaFoglio foglio;

  @override
  Widget build(BuildContext context) => foglio;
}
