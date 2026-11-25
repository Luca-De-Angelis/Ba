// La stanza (task 024a, prototipo 002): l'intestazione, la riga di stato, l'alone,
// il palco, il pubblico e la barra delle azioni; la scheda di una persona al tocco
// di una presenza; «Altro». Si entra **come pubblico** (D-006) e si sale **a
// microfono spento** (D-007). Da ascoltatore «Sali sul palco» apre «diventa
// partecipante» (013); da partecipante si sale subito. «Esci» torna all'elenco
// (proposta del task 024: nessun documento dice dove si va).
//
// Il prototipo non ha «sto salendo» (002: lo stato dura fino a 8 secondi, e senza
// timer non si può): si sale subito. Task 024b: a palco pieno «Mettiti in coda» (015), in
// coda il posto offerto, la linea persa e il suo ritorno, il microfono negato (Fase 2), e per
// i DEN creati da chi usa il prototipo «Gestisci» e «Nuovo sotto-DEN» in «Altro».
import 'package:flutter/widgets.dart';

import '../design_system/alone.dart';
import '../design_system/banda_posto.dart';
import '../design_system/barra_azioni.dart';
import '../design_system/fascia_attesa.dart';
import '../design_system/foglio.dart';
import '../design_system/intestazione.dart';
import '../design_system/palco.dart';
import '../design_system/pillola.dart';
import '../design_system/pubblico.dart';
import '../design_system/riga_stato.dart';
import '../design_system/scheda_persona.dart';
import '../design_system/tokens.dart';
import 'fogli_coda.dart';
import 'fogli_creazione.dart';
import 'fogli_gestisci.dart';
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

  /// «Mettiti in coda» (K2, S1). Da ascoltatore prima «diventa partecipante»: si parla dal palco.
  Future<void> _mettitiInCoda(BuildContext context) async {
    final stato = ProtoScope.leggi(context);
    if (stato.account == Account.ascoltatore && !(stato.denCorrente?.codaPiena ?? false)) {
      await _conFoglio(() => apriFoglioPartecipante(context, perCreare: false, alTermine: stato.diventaPartecipante));
      if (!stato.partecipante || !context.mounted) return;
    }
    if (!context.mounted) return;
    await _conFoglio(() => apriMettitiInCoda(context));
  }

  /// Il microfono: acceso solo con il permesso. Negato, il foglio di Fase 2 («Senza microfono non posso farti parlare»).
  void _microfono(BuildContext context) {
    final stato = ProtoScope.leggi(context);
    if (stato.micAcceso || stato.permessoMic) {
      stato.cambiaMic();
      return;
    }
    _conFoglio(() => showBaFoglio<void>(
          context,
          etichettaVelo: T.chiudi,
          builder: (foglio) => BaFoglio.richiesta(
            titolo: T.micFaseTitolo,
            paragrafi: const [T.micFaseP1],
            azioni: [
              azioneFoglio(T.apriLeImpostazioni, () {
                // Simula il ritorno dalle impostazioni del telefono con il permesso dato.
                Navigator.of(foglio).pop();
                stato.impostaPermessoMic(true);
              }),
              azioneFoglio(T.restoAdAscoltare, () => Navigator.of(foglio).pop()),
            ],
          ),
        ));
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
    final den = stato.denCorrente;
    final esci = BaAzioneBarra(
      ruolo: BaRuoloAzione.secondaria,
      testo: T.esci,
      semanticsLabel: T.esci,
      fissa: true,
      onTap: stato.esciDallaStanza,
    );
    // Le voci di «Altro» (015, 027): `inAltro` le manda lì qualunque sia la posizione, così
    // l'ascoltatore ha la primaria, «Esci» e «Altro». «Le tue code» solo se si è in coda da
    // qualche parte; «Gestisci» e «Nuovo sotto-DEN» solo per un DEN creato da chi usa il prototipo.
    BaAzioneBarra inAltro(String testo, VoidCallback onTap) => BaAzioneBarra(
          ruolo: BaRuoloAzione.secondaria,
          inAltro: true,
          testo: testo,
          semanticsLabel: testo,
          onTap: onTap,
        );
    final inAltroVoci = [
      if (stato.code.isNotEmpty) inAltro(T.codeTitolo, () => _conFoglio(() => apriLeTueCode(context))),
      if (den != null && den.creatoDaMe) ...[
        inAltro(T.gestisci, () => _conFoglio(() => apriGestisci(context))),
        inAltro(T.sottoDenNuovo, () => _conFoglio(() => apriSottoDen(context, den.id))),
      ],
      inAltro(T.impostazioniRiga, () => stato.vai(const Rotta(Pagina.impostazioni))),
      inAltro(T.personeBloccate, () => stato.vai(const Rotta(Pagina.bloccate))),
    ];

    if (stato.ruolo == Ruolo.sulPalco) {
      return [
        if (stato.lineaPersa)
          // P1: senza linea il microfono non si accende; l'azione dice che sta riprovando, inattiva.
          BaAzioneBarra(
            ruolo: BaRuoloAzione.primaria,
            testo: T.sentoDiNuovo,
            semanticsLabel: T.sentoDiNuovo,
            variante: BaVariantePillola.spenta,
            fissa: true,
          )
        else
          BaAzioneBarra(
            ruolo: BaRuoloAzione.primaria,
            testo: stato.micAcceso ? T.spegniMic : T.accendiMic,
            semanticsLabel: stato.micAcceso ? T.spegniMic : T.accendiMic,
            // Spento: «Accendi» è il gesto che serve (chiara); acceso: «Spegni» a filetto.
            variante: stato.micAcceso ? BaVariantePillola.attiva : BaVariantePillola.chiara,
            fissa: true,
            onTap: () => _microfono(context),
          ),
        BaAzioneBarra(
          ruolo: BaRuoloAzione.secondaria,
          testo: T.scendiDalPalco,
          semanticsLabel: T.scendiDalPalco,
          fissa: true,
          onTap: stato.scendiDalPalco,
        ),
        esci,
        ...inAltroVoci,
      ];
    }

    final BaAzioneBarra primaria;
    if (stato.ruolo == Ruolo.inCoda) {
      primaria = switch (stato.postoQui) {
        // K4: il posto è offerto, «Sali sul palco» è il gesto che serve.
        Posto.offerto => BaAzioneBarra(
            ruolo: BaRuoloAzione.primaria,
            testo: T.saliSulPalco,
            semanticsLabel: T.saliSulPalco,
            variante: BaVariantePillola.chiara,
            onTap: () => _sali(context),
          ),
        // K4 bis: il posto è passato, si resta in coda: «In coda», inattiva.
        Posto.scaduto => BaAzioneBarra(
            ruolo: BaRuoloAzione.primaria,
            testo: T.inCoda,
            semanticsLabel: T.inCoda,
            variante: BaVariantePillola.spenta,
          ),
        Posto.nessuno => BaAzioneBarra(
            ruolo: BaRuoloAzione.primaria,
            testo: T.esciDallaCoda,
            semanticsLabel: T.esciDallaCoda,
            onTap: () => stato.esciDallaCoda(den?.id ?? ''),
          ),
      };
    } else if (stato.palcoPieno) {
      // Il palco è pieno: ci si mette in coda.
      primaria = BaAzioneBarra(
        ruolo: BaRuoloAzione.primaria,
        testo: T.mettitiInCoda,
        semanticsLabel: T.mettitiInCoda,
        variante: BaVariantePillola.chiara,
        onTap: () => _mettitiInCoda(context),
      );
    } else {
      primaria = BaAzioneBarra(
        ruolo: BaRuoloAzione.primaria,
        testo: T.saliSulPalco,
        semanticsLabel: T.saliSulPalco,
        variante: BaVariantePillola.chiara,
        onTap: () => _sali(context),
      );
    }
    return [primaria, esci, ...inAltroVoci];
  }

  // ------------------------------------------------------------------ la pagina

  /// La banda sopra la barra: la linea persa (P1), il ritorno (P2, P3), il posto offerto (K4) o
  /// passato (K4 bis). Sono fatti fermi, mai un conto alla rovescia, e si annunciano (D-034).
  Widget? _banda(StatoProto stato) {
    if (stato.lineaPersa) {
      return const BaBandaPosto(testo: T.lineaPersaBanda, sottotesto: T.lineaPersaSotto, annuncia: true);
    }
    return switch (stato.ritorno) {
      Ritorno.postoRimasto => const BaBandaPosto(testo: T.ritornoP2, annuncia: true),
      Ritorno.postoPreso => const BaBandaPosto(testo: T.ritornoP3, annuncia: true),
      Ritorno.nessuno => switch (stato.postoQui) {
          Posto.offerto => const BaBandaPosto(testo: T.postoOfferto, annuncia: true),
          Posto.scaduto => const BaBandaPosto(testo: T.postoScaduto, annuncia: true),
          Posto.nessuno => null,
        },
    };
  }

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    // Dopo «Termina il DEN» la pagina può ricostruirsi un'ultima volta senza il DEN.
    final den = stato.den.firstWhere((d) => d.id == widget.den, orElse: () => Den(id: widget.den, nome: '', palco: const [], inAscolto: 0));
    final media = MediaQuery.of(context);
    final larghezza = media.size.width;
    final margine = BaLayoutTokens.margine(larghezza);
    final n = stato.palco.length;
    final sulPalco = stato.ruolo == Ruolo.sulPalco;
    final inCoda = stato.ruolo == Ruolo.inCoda;
    final persa = stato.lineaPersa;

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
                  stato: persa
                      ? BaStatoIntestazione.disconnessa
                      : (den.suInvito ? BaStatoIntestazione.suInvito : BaStatoIntestazione.pubblica),
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
                mie: inCoda ? T.codeStato : (!sulPalco ? T.seiInAscolto : (stato.micAcceso ? T.tuMicAcceso : T.tuMicSpento)),
              ),
            ),
          ),
          if (den.creatoDaMe)
            Padding(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.s, margine, 0),
              child: Align(alignment: Alignment.centerLeft, child: Frase(T.seiAmministratore(den.nome), piccola: true)),
            ),
          for (final nome in stato.sottoDen[den.id] ?? const <String>[])
            Padding(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.xs, margine, 0),
              child: Align(alignment: Alignment.centerLeft, child: Frase(T.sottoDenCreato(nome), piccola: true)),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: margine),
              child: Stack(
                children: [
                  Positioned.fill(child: BaAlone(acceso: !persa)),
                  Positioned.fill(
                    child: BaPalco(
                      persone: persone,
                      larghezzaSchermo: larghezza,
                      semanticsLabel: T.stanzaEtichettaPalco(n),
                      dietro: _dietro,
                      stato: persa ? const BaStatoPalco.congelato() : const BaStatoPalco.vivo(),
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
          if (stato.inGruppo)
            Padding(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.s, margine, 0),
              child: BaFasciaAttesa(
                conteggio: 3,
                tinte: const [3, 4, 5],
                sagome: const [1, 2, 3],
                frase: T.fasciaAttesa,
                // Solo per chi ha la capacità: senza, la riga non c'è e non lascia traccia.
                lasciaTesto: stato.capacitaAspettare ? T.lasciaIlGruppo : null,
                onLascia: stato.capacitaAspettare ? stato.lasciaIlGruppo : null,
              ),
            ),
          if (_banda(stato) case final banda?)
            Padding(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.s, margine, 0),
              child: banda,
            )
          else if (!sulPalco)
            Padding(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.s, margine, 0),
              child: const Frase(T.saliraiMicSpento, piccola: true),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.s, margine, BaSpazioTokens.l),
            child: BaBarraAzioni(
              azioni: azioni,
              onAltro: () => _apriAltro(context, BaBarraAzioni.eccedenti(azioni)),
              semanticsLabelAltro: T.altro,
            ),
          ),
        ],
      ),
    );
  }
}
