// La stanza (task 024a, prototipo 002): l'intestazione, la riga di stato, l'alone,
// il palco, il pubblico e la barra delle azioni; la scheda di una persona al tocco
// di una presenza; «Altro». Si entra **come pubblico** (D-006) e si sale **a
// microfono spento** (D-007). Da ascoltatore «Sali sul palco» apre «diventa
// partecipante» (013); da partecipante si sale subito. «Esci» torna all'elenco
// (proposta del task 024: nessun documento dice dove si va).
//
// Il prototipo non ha «sto salendo» (002: lo stato dura fino a 8 secondi, e senza
// timer non si può): si sale subito. La coda e il palco pieno arrivano con il 024b.
import 'package:flutter/widgets.dart';

import '../design_system/alone.dart';
import '../design_system/barra_azioni.dart';
import '../design_system/foglio.dart';
import '../design_system/intestazione.dart';
import '../design_system/palco.dart';
import '../design_system/pillola.dart';
import '../design_system/pubblico.dart';
import '../design_system/riga_stato.dart';
import '../design_system/scheda_persona.dart';
import '../design_system/tokens.dart';
import 'fogli_partecipante.dart';
import 'pagina_base.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

class PaginaStanza extends StatefulWidget {
  const PaginaStanza({super.key, required this.den});

  final String den;

  @override
  State<PaginaStanza> createState() => _PaginaStanzaState();
}

class _PaginaStanzaState extends State<PaginaStanza> {
  /// Un foglio è aperto: il palco si abbassa e si sfoca dietro di lui.
  bool _dietro = false;

  Future<R?> _conFoglio<R>(Future<R?> Function() apri) async {
    setState(() => _dietro = true);
    final r = await apri();
    if (mounted) setState(() => _dietro = false);
    return r;
  }

  // ------------------------------------------------------------------ i gesti

  void _sali(BuildContext context) {
    final stato = ProtoScope.leggi(context);
    if (stato.account == Account.ascoltatore) {
      // Da ascoltatore: prima «diventa partecipante»; alla fine si sale a microfono spento.
      _conFoglio(() => apriFoglioPartecipante(
            context,
            perCreare: false,
            alTermine: () {
              stato.diventaPartecipante();
              stato.saliSulPalco();
            },
          ));
    } else {
      stato.saliSulPalco();
    }
  }

  void _apriScheda(BuildContext context, Persona p) {
    final stato = ProtoScope.leggi(context);
    if (p.id == 'io') return;
    final parla = stato.parla == p.id;
    _conFoglio(() => showBaFoglio<void>(
          context,
          etichettaVelo: T.chiudi,
          builder: (foglio) => BaFoglio.scheda(
            semanticsLabel: p.nome,
            corpo: BaSchedaPersona(
              nome: p.nome,
              stato: T.schedaSulPalco,
              parla: parla,
              mutaTesto: T.schedaMuta,
              mutaNonDisponibile: T.schedaMutaNonDisponibile,
              bloccaTesto: T.schedaBlocca,
              segnalaTesto: T.schedaSegnala,
              onMuta: () => Navigator.of(foglio).pop(),
              onBlocca: () {
                stato.blocca(p);
                Navigator.of(foglio).pop();
              },
              onSegnala: () => Navigator.of(foglio).pop(),
            ),
            chiudi: azioneFoglio(T.chiudi, () => Navigator.of(foglio).pop()),
          ),
        ));
  }

  /// «Altro» raccoglie le azioni oltre le tre che la barra mostra (002).
  void _apriAltro(BuildContext context, List<BaAzioneBarra> eccedenti) {
    _conFoglio(() => showBaFoglio<void>(
          context,
          etichettaVelo: T.chiudi,
          builder: (foglio) => BaFoglio(
            semanticsLabel: T.altro,
            corpo: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: BaSpazioTokens.m),
                  child: Text(T.altro, style: BaTestoTokens.foglio.copyWith(color: BaColorTokens.testoPrimo)),
                ),
                for (final a in eccedenti)
                  BaRigaAzione(
                    titolo: a.testo,
                    onTap: () {
                      Navigator.of(foglio).pop();
                      a.onTap?.call();
                    },
                  ),
              ],
            ),
            azioni: [pillola(T.chiudi, () => Navigator.of(foglio).pop(), variante: BaVariantePillola.spenta)],
          ),
        ));
  }

  // ------------------------------------------------------------------ la barra

  List<BaAzioneBarra> _azioni(BuildContext context, StatoProto stato) {
    final esci = BaAzioneBarra(
      ruolo: BaRuoloAzione.secondaria,
      testo: T.esci,
      semanticsLabel: T.esci,
      fissa: true,
      onTap: stato.esciDallaStanza,
    );
    // «Impostazioni» sta in «Altro» per ogni ruolo (015, 027). La barra ha tre posti e
    // mostra «Altro» solo dalla quarta azione: per l'ascoltatore il terzo posto è
    // quindi «Persone bloccate» (il 015 e il 027 mostrano solo «Sali sul palco», «Esci»
    // e «Altro»: il componente non lo permette, e non si tocca).
    final impostazioni = BaAzioneBarra(
      ruolo: BaRuoloAzione.secondaria,
      testo: T.impostazioniRiga,
      semanticsLabel: T.impostazioniRiga,
      onTap: () => stato.vai(const Rotta(Pagina.impostazioni)),
    );
    final bloccate = BaAzioneBarra(
      ruolo: BaRuoloAzione.secondaria,
      testo: T.personeBloccate,
      semanticsLabel: T.personeBloccate,
      onTap: () => stato.vai(const Rotta(Pagina.bloccate)),
    );
    if (stato.ruolo == Ruolo.pubblico) {
      return [
        BaAzioneBarra(
          ruolo: BaRuoloAzione.primaria,
          testo: T.saliSulPalco,
          semanticsLabel: T.saliSulPalco,
          variante: BaVariantePillola.chiara,
          onTap: () => _sali(context),
        ),
        esci,
        bloccate,
        impostazioni,
      ];
    }
    return [
      BaAzioneBarra(
        ruolo: BaRuoloAzione.primaria,
        testo: stato.micAcceso ? T.spegniMic : T.accendiMic,
        semanticsLabel: stato.micAcceso ? T.spegniMic : T.accendiMic,
        // Spento: «Accendi» è il gesto che serve (chiara); acceso: «Spegni» a filetto.
        variante: stato.micAcceso ? BaVariantePillola.attiva : BaVariantePillola.chiara,
        fissa: true,
        onTap: stato.cambiaMic,
      ),
      BaAzioneBarra(
        ruolo: BaRuoloAzione.secondaria,
        testo: T.scendiDalPalco,
        semanticsLabel: T.scendiDalPalco,
        fissa: true,
        onTap: stato.scendiDalPalco,
      ),
      esci,
      impostazioni,
      bloccate,
    ];
  }

  // ------------------------------------------------------------------ la pagina

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final den = stato.den.firstWhere((d) => d.id == widget.den);
    final media = MediaQuery.of(context);
    final larghezza = media.size.width;
    final margine = BaLayoutTokens.margine(larghezza);
    final n = stato.palco.length;
    final sulPalco = stato.ruolo == Ruolo.sulPalco;

    final azioni = _azioni(context, stato);
    final persone = [
      for (final p in stato.palco)
        BaPersonaPalco(
          id: p.id,
          indiceTinta: p.tinta,
          indiceSagoma: p.sagoma,
          iniziali: p.iniziali,
          semanticsLabel: p.nome,
          semanticsLabelParla: '${p.nome}, sta parlando',
          parla: stato.parla == p.id,
          // Bloccata dalla scheda: il glifo «bloccata» del design system, oltre alle persone bloccate.
          bloccata: stato.bloccate.any((b) => b.id == p.id),
          ampiezza: 1,
          microfonoSpento: p.id == 'io' ? !stato.micAcceso : false,
          io: p.id == 'io',
          onTap: () => _apriScheda(context, p),
        ),
    ];

    return PaginaGuscio(
      nome: den.nome,
      figlio: (context, focus) => Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.l, margine, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Focus(
                focusNode: focus,
                child: BaIntestazione(
                  nome: den.nome,
                  marcatore: den.suInvito ? 'su invito' : 'entra chiunque',
                  stato: den.suInvito ? BaStatoIntestazione.suInvito : BaStatoIntestazione.pubblica,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.s, margine, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: BaRigaStato(
                fatti: T.suIlPalco(n),
                mie: !sulPalco ? T.seiInAscolto : (stato.micAcceso ? T.tuMicAcceso : T.tuMicSpento),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: margine),
              child: Stack(
                children: [
                  const Positioned.fill(child: BaAlone()),
                  Positioned.fill(
                    child: BaPalco(
                      persone: persone,
                      larghezzaSchermo: larghezza,
                      semanticsLabel: T.stanzaEtichettaPalco(n),
                      dietro: _dietro,
                      invitoTitolo: T.palcoLibero,
                      invitoTesto: T.palcoInvito,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BaPubblico(
            conteggio: den.inAscolto,
            testo: T.inAscolto(den.inAscolto),
            tinte: const [0, 1, 2],
            sagome: const [0, 1, 2],
          ),
          if (!sulPalco)
            Padding(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.s, margine, 0),
              child: const Frase(T.saliraiMicSpento, piccola: true),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.s, margine, BaSpazioTokens.l),
            child: BaBarraAzioni(
              azioni: azioni,
              onAltro: () => _apriAltro(context, azioni.skip(3).toList()),
              semanticsLabelAltro: T.altro,
            ),
          ),
        ],
      ),
    );
  }
}
