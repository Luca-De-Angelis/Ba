// BaRichiestaPermesso: il foglio che chiede un permesso di sistema (task 034, Inventario C4;
// prototipo 031: N1 «Avvisi sui DEN · richiesta del permesso» e Z1 «Posizione · richiesta del
// permesso»). Un titolo, **una frase sul perché** e **due azioni alla pari**, «Consenti» e
// «Non ora»; e lo stato **dopo il rifiuto**: una frase senza colpa («Va bene così. Gli avvisi sui
// DEN restano spenti.»), se serve una seconda («Se cambi idea, li accendi dalle impostazioni del
// telefono.»), «Apri le impostazioni del telefono» e «Chiudi».
//
// **Due azioni alla pari** (`BaRegole` 1): nessuna delle due è «chiara». La chiara è solo dove
// l'app non può proseguire senza il gesto, e qui nessun gesto è obbligato: «Non ora» c'è sempre.
// `BaFoglio.richiesta` renderebbe chiara la prima azione se la variante manca: questo componente
// la **impone** attiva (a filetto) a **tutte e due**, qualunque variante arrivi dal chiamante,
// così «Consenti» e «Non ora» hanno lo stesso peso. Dopo il rifiuto «Apri le impostazioni del
// telefono» è attiva e «Chiudi» è spenta (un'uscita), mai chiara.
//
// Si compone con `BaFoglio.richiesta`, come `BaFoglioInvito` compone le facce di `BaFoglio`:
// nessun foglio nuovo, nessuna navigazione, nessuna logica. Dove va «Consenti» (il permesso del
// sistema) e dove va «Apri le impostazioni» è del chiamante, e tutti i testi arrivano da lui.
// **Il rifiuto non ha colpa**: il componente non scrive e non ha un posto per «sei sicuro?», per
// un tono d'errore né per un colore di avviso.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'foglio.dart';
import 'pillola.dart';

/// In quale stato è la richiesta.
enum BaStatoRichiestaPermesso { richiesta, dopoIlRifiuto }

class BaRichiestaPermesso extends StatelessWidget {
  const BaRichiestaPermesso._({super.key, required this.stato, required this.foglio});

  /// La richiesta: [titolo] («Avvisi sui DEN»), la [frase] sul perché («BA può avvisarti quando si
  /// apre un DEN su un tema o una lingua che scegli. Non avvisa mai per le persone.») e le due
  /// azioni alla pari, [consenti] e [nonOra]. Le loro varianti sono imposte: tutte e due attive.
  BaRichiestaPermesso({
    Key? key,
    required String titolo,
    required String frase,
    required BaAzioneFoglio consenti,
    required BaAzioneFoglio nonOra,
  }) : this._(
          key: key,
          stato: BaStatoRichiestaPermesso.richiesta,
          foglio: BaFoglio.richiesta(
            titolo: titolo,
            paragrafi: [frase],
            azioni: [_conVariante(consenti, BaVariantePillola.attiva), _conVariante(nonOra, BaVariantePillola.attiva)],
          ),
        );

  /// Il permesso è stato rifiutato: [titolo], una [frase] senza colpa, se serve una seconda
  /// ([fraseSeCambiIdea]), «Apri le impostazioni del telefono» ([apriImpostazioni], attiva) e
  /// «Chiudi» ([chiudi], spenta).
  BaRichiestaPermesso.dopoIlRifiuto({
    Key? key,
    required String titolo,
    required String frase,
    String? fraseSeCambiIdea,
    required BaAzioneFoglio apriImpostazioni,
    required BaAzioneFoglio chiudi,
  }) : this._(
          key: key,
          stato: BaStatoRichiestaPermesso.dopoIlRifiuto,
          foglio: BaFoglio.richiesta(
            titolo: titolo,
            paragrafi: [frase, ?fraseSeCambiIdea],
            azioni: [_conVariante(apriImpostazioni, BaVariantePillola.attiva), _conVariante(chiudi, BaVariantePillola.spenta)],
          ),
        );

  final BaStatoRichiestaPermesso stato;
  final BaFoglio foglio;

  static BaAzioneFoglio _conVariante(BaAzioneFoglio a, BaVariantePillola variante) =>
      BaAzioneFoglio(testo: a.testo, semanticsLabel: a.semanticsLabel, onTap: a.onTap, variante: variante);

  @override
  Widget build(BuildContext context) => foglio;
}
