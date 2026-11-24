// I contenuti dei fogli della coda e dell'attesa (task 023a, prototipo 015
// aggiornato dal 027): «Mettiti in coda» (K2), «Aspetta con altri» (W1), «Le tue
// code» (K1), «La coda è piena adesso» (S1) e «Vuoi passare di qua?» (K6). Sono
// cinque composizioni di [BaFoglio] con i controlli del task 022: nessuna
// navigazione, nessuna logica di flusso, nessuna posizione in coda, nessun
// conteggio, nessun massimo e **nessun timer o conto alla rovescia** (la finestra
// del posto offerto è la frase ferma «pochi secondi»). Tutti i testi arrivano dal
// chiamante.
//
// Dove la primaria è chiara: solo dove l'app non può proseguire senza quel gesto
// (`BaRegole` 1). Seguo il prototipo: «Entra nel gruppo» (W1) e «Ho capito» (S1)
// sono chiare, «Mettiti in coda» (K2) e «Passa» (K6) sono attive («a filo»). La
// variante di ogni azione si cambia con `BaAzioneFoglio.variante`.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'foglio.dart';
import 'foglio_passi.dart';
import 'interruttore_riga.dart';
import 'pillola.dart';
import 'riga_coda.dart';
import 'tokens.dart';

Widget _pillola(BaAzioneFoglio a, BaVariantePillola predefinita) => BaPillola(
      testo: a.testo,
      semanticsLabel: a.semanticsLabel,
      onTap: a.onTap,
      variante: a.variante ?? predefinita,
      estensione: const EdgeInsets.symmetric(vertical: BaControlloTokens.areaEstesa),
    );

/// Il corpo di un foglio: titolo e voci, a distanza `m` una dall'altra. Una voce
/// che non c'è non lascia traccia: niente spazio, niente etichetta.
Widget _corpo(String titolo, List<Widget> voci) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titolo, style: BaTestoTokens.foglio.copyWith(color: BaColorTokens.testoPrimo)),
        for (final v in voci) ...[
          const SizedBox(height: BaSpazioTokens.m),
          v,
        ],
      ],
    );

Widget _frase(BaParagrafoPasso p) => Text(
      p.testo,
      style: BaTestoTokens.corpo.copyWith(
        color: p.evidenza ? BaColorTokens.testoPrimo : BaColorTokens.testoSecondo,
      ),
    );

/// «Mettiti in coda» (K2, K2 bis, K2 ter): la frase, l'interruttore «Fammi entrare
/// automaticamente» e, **solo per chi ha la capacità**, «Aspetta con altri»;
/// «Salirai a microfono spento»; «Mettiti in coda» e «Non ora».
///
/// [aspettaConAltri] nullo = la riga non esiste: né etichetta, né invito, né
/// spazio vuoto, e nessun segno del pagante. Gli interruttori sono
/// [BaInterruttoreRiga] già composti dal chiamante (con i loro testi e il loro
/// stato): il foglio non sa che cosa significhi accenderli.
class BaFoglioMettitiInCoda extends StatelessWidget {
  const BaFoglioMettitiInCoda({
    super.key,
    required this.titolo,
    required this.frase,
    required this.ingressoAutomatico,
    this.aspettaConAltri,
    required this.rigaSale,
    required this.mettitiInCoda,
    required this.nonOra,
  });

  final String titolo;
  final String frase;
  final BaInterruttoreRiga ingressoAutomatico;
  final BaInterruttoreRiga? aspettaConAltri;

  /// «Salirai a microfono spento.»: in primo piano, come nel prototipo.
  final String rigaSale;

  final BaAzioneFoglio mettitiInCoda;
  final BaAzioneFoglio nonOra;

  @override
  Widget build(BuildContext context) => BaFoglio(
        semanticsLabel: titolo,
        corpo: _corpo(titolo, [
          _frase(BaParagrafoPasso(frase)),
          ingressoAutomatico,
          ?aspettaConAltri,
          _frase(BaParagrafoPasso(rigaSale, evidenza: true)),
        ]),
        azioni: [_pillola(mettitiInCoda, BaVariantePillola.attiva), _pillola(nonOra, BaVariantePillola.spenta)],
      );
}

/// «Aspetta con altri» (W1): la spiegazione del sotto-DEN d'attesa, «Entra nel
/// gruppo» e «Non ora». Il gruppo si sceglie, non è predefinito.
class BaFoglioAspettaConAltri extends StatelessWidget {
  const BaFoglioAspettaConAltri({
    super.key,
    required this.titolo,
    required this.paragrafi,
    required this.entra,
    required this.nonOra,
  });

  final String titolo;
  final List<BaParagrafoPasso> paragrafi;
  final BaAzioneFoglio entra;
  final BaAzioneFoglio nonOra;

  @override
  Widget build(BuildContext context) => BaFoglio(
        semanticsLabel: titolo,
        corpo: _corpo(titolo, [for (final p in paragrafi) _frase(p)]),
        azioni: [_pillola(entra, BaVariantePillola.chiara), _pillola(nonOra, BaVariantePillola.spenta)],
      );
}

/// «Le tue code» (K1): una [BaRigaCoda] per coda e «Chiudi». Un elenco senza
/// posizioni, senza conteggi e senza massimo: l'API di [BaRigaCoda] non li ha.
class BaFoglioLeTueCode extends StatelessWidget {
  const BaFoglioLeTueCode({
    super.key,
    required this.titolo,
    required this.frase,
    required this.code,
    required this.chiudi,
  });

  final String titolo;
  final String frase;
  final List<BaRigaCoda> code;

  /// L'unica azione: spenta, perché non c'è niente da decidere.
  final BaAzioneFoglio chiudi;

  @override
  Widget build(BuildContext context) => BaFoglio(
        semanticsLabel: titolo,
        corpo: _corpo(titolo, [
          _frase(BaParagrafoPasso(frase)),
          // Le righe stanno una sotto l'altra, divise dal loro filetto.
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: code),
        ]),
        azioni: [_pillola(chiudi, BaVariantePillola.spenta)],
      );
}

/// «La coda è piena adesso» (S1): si resta nel pubblico e si ascolta. «Ho capito».
class BaFoglioCodaPiena extends StatelessWidget {
  const BaFoglioCodaPiena({
    super.key,
    required this.titolo,
    required this.frase,
    required this.haCapito,
  });

  final String titolo;
  final String frase;
  final BaAzioneFoglio haCapito;

  @override
  Widget build(BuildContext context) => BaFoglio(
        semanticsLabel: titolo,
        corpo: _corpo(titolo, [_frase(BaParagrafoPasso(frase))]),
        azioni: [_pillola(haCapito, BaVariantePillola.chiara)],
      );
}

/// «Vuoi passare di qua?» (K6): si partecipa a un solo DEN alla volta (D-042), e
/// se un posto si libera mentre si è già in un altro DEN non si entra da soli.
/// Dice dov'è il posto e chiede; «Passa» è attiva, perché si può restare, e «Resta
/// qui» chiude senza effetti. Il tempo è una frase ferma («Hai pochi secondi per
/// decidere»): **nessun conto alla rovescia**, nessun timer, nessun segnale alla
/// scadenza.
class BaFoglioPassaDiQua extends StatelessWidget {
  const BaFoglioPassaDiQua({
    super.key,
    required this.titolo,
    required this.paragrafi,
    required this.passa,
    required this.restaQui,
  });

  final String titolo;
  final List<BaParagrafoPasso> paragrafi;
  final BaAzioneFoglio passa;
  final BaAzioneFoglio restaQui;

  @override
  Widget build(BuildContext context) => BaFoglio(
        semanticsLabel: titolo,
        corpo: _corpo(titolo, [for (final p in paragrafi) _frase(p)]),
        azioni: [_pillola(passa, BaVariantePillola.attiva), _pillola(restaQui, BaVariantePillola.spenta)],
      );
}
