// «Crea un DEN» (task 024b, prototipo 014 aggiornato dal 027: C1–C5 e S2) e il sotto-DEN
// (D1). Un foglio a più passi (`BaFoglioPassi` con `BaPassiCreazione`): tipo → nome →
// descrizione, tema e lingua → invitati (solo il privato, con il posto riempito da
// `ganci.dart`) → riepilogo → «Crea il DEN». Il DEN nasce e si entra **come amministratore,
// sul palco, a microfono spento**. Se la creazione non riesce (il pannello l'ha armata) c'è S2
// con «Riprova», che stavolta riesce; i campi restano.
//
// Da ascoltatore si passa prima da «diventa partecipante» (R1…R2): nel prototipo sono due
// fogli di seguito, non uno che cresce (limite dichiarato: il design vuole un foglio solo).
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/foglio_passi.dart';
import '../design_system/fogli_gestione.dart';
import '../design_system/passi_creazione.dart';
import '../design_system/pillola.dart';
import '../design_system/punto_aggancio.dart';
import '../design_system/riga_valore.dart';
import '../design_system/scelta_den.dart';
import 'fogli_partecipante.dart';
import 'ganci.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

/// «Crea un DEN»: da ascoltatore prima «diventa partecipante», poi i passi della creazione.
Future<void> apriCreazione(BuildContext context) async {
  final stato = ProtoScope.leggi(context);
  if (!stato.partecipante) {
    await apriFoglioPartecipante(context, perCreare: true, alTermine: stato.diventaPartecipante);
    if (!stato.partecipante || !context.mounted) return;
  }
  await showBaFoglio<void>(context, etichettaVelo: T.chiudi, builder: (_) => const _CreaDen());
}

enum _Passo { tipo, nome, dettagli, invitati, riepilogo, nonCreato }

class _CreaDen extends StatefulWidget {
  const _CreaDen();

  @override
  State<_CreaDen> createState() => _CreaDenState();
}

class _CreaDenState extends State<_CreaDen> {
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _descrizione = TextEditingController();
  _Passo _passo = _Passo.tipo;
  int? _tipo = 0; // 0 privato, 1 pubblico
  int? _tema = 0;
  int? _lingua = 0;
  String? _erroreNome;
  final List<String> _invitati = [];

  bool get _privato => _tipo == 0;

  List<_Passo> get _percorso => [
        _Passo.tipo,
        _Passo.nome,
        _Passo.dettagli,
        if (_privato) _Passo.invitati,
        _Passo.riepilogo,
      ];

  @override
  void dispose() {
    _nome.dispose();
    _descrizione.dispose();
    super.dispose();
  }

  void _crea() {
    final stato = ProtoScope.leggi(context);
    if (stato.creazioneFallisce) {
      // S2: il prossimo tentativo, «Riprova», riesce.
      stato.armaFallimentoCreazione();
      setState(() => _passo = _Passo.nonCreato);
      return;
    }
    final invitati = [
      for (final p in personeInvitabili)
        if (_invitati.contains(p.persona.id)) p.persona,
    ];
    Navigator.of(context).pop();
    stato.creaDen(
      nome: _nome.text.trim(),
      privato: _privato,
      descrizione: _descrizione.text.trim(),
      invitati: _privato ? invitati : const [],
    );
  }

  void _avanti() {
    if (_passo == _Passo.nome && _nome.text.trim().isEmpty) {
      setState(() => _erroreNome = T.creaNomeErrore);
      return;
    }
    if (_passo == _Passo.riepilogo) {
      _crea();
      return;
    }
    setState(() {
      _erroreNome = null;
      _passo = _percorso[_percorso.indexOf(_passo) + 1];
    });
  }

  void _indietro() {
    setState(() {
      _erroreNome = null;
      _passo = _passo == _Passo.nonCreato ? _Passo.riepilogo : _percorso[_percorso.indexOf(_passo) - 1];
    });
  }

  BaAzioneFoglio _continua(String testo) => azioneFoglio(testo, _avanti);

  void _tocca(Persona p) => setState(() {
        if (!_invitati.remove(p.id)) _invitati.add(p.id);
      });

  BaPassoFoglio get _passoCorrente => switch (_passo) {
        _Passo.tipo => BaPassiCreazione.tipo(
            titolo: T.creaTipoTitolo,
            opzioni: const [
              BaOpzioneScelta(titolo: T.creaPrivato, descrizione: T.creaPrivatoDescr),
              BaOpzioneScelta(titolo: T.creaPubblico, descrizione: T.creaPubblicoDescr),
            ],
            scelta: _tipo,
            onScelta: (i) => setState(() => _tipo = i),
            fraseSotto: T.creaTipoSotto,
            azione: _continua(T.continua),
          ),
        _Passo.nome => BaPassiCreazione.nome(
            titolo: T.creaNomeTitolo,
            controller: _nome,
            etichetta: T.creaNomeEtichetta,
            segnaposto: T.creaNomeSegnaposto,
            errore: _erroreNome,
            onChanged: (_) {
              if (_erroreNome != null) setState(() => _erroreNome = null);
            },
            quando: const BaPuntoAggancio.quando(
              etichetta: T.creaQuando,
              titolo: T.creaQuandoTitolo,
              sottotitolo: T.creaQuandoSotto,
            ),
            azione: _continua(T.continua),
          ),
        _Passo.dettagli => BaPassiCreazione.dettagli(
            titolo: T.creaDettagliTitolo,
            descrizione: _descrizione,
            descrizioneEtichetta: T.creaDescrizione,
            descrizioneSegnaposto: T.creaDescrizioneSegnaposto,
            maxRighe: 6,
            temaEtichetta: T.creaTema,
            temi: T.temi,
            temaScelto: _tema,
            onTema: (i) => setState(() => _tema = i),
            linguaEtichetta: T.creaLingua,
            lingue: T.lingue,
            linguaScelta: _lingua,
            onLingua: (i) => setState(() => _lingua = i),
            azione: _continua(T.continua),
          ),
        // Il posto degli invitati lo riempie `ganci.dart`; si può procedere anche senza invitati (030).
        _Passo.invitati => BaPassiCreazione.invitati(
            titolo: T.creaInvitatiTitolo,
            frase: T.creaInvitatiFrase,
            posto: postoInvitati(scelti: _invitati, alToccare: _tocca),
            azione: _continua(T.continua),
          ),
        _Passo.riepilogo => BaPassiCreazione.riepilogo(
            titolo: T.creaRiepilogoTitolo,
            righe: [
              BaRigaValore(etichetta: T.tipo, valore: _privato ? T.creaPrivato : T.creaPubblico),
              BaRigaValore(etichetta: T.nome, valore: _nome.text.trim()),
              if (_tema != null) BaRigaValore(etichetta: T.creaTema, valore: T.temi[_tema!]),
              if (_lingua != null) BaRigaValore(etichetta: T.creaLingua, valore: T.lingue[_lingua!]),
              if (_privato) BaRigaValore(etichetta: T.invitati, valore: _invitati.isEmpty ? '—' : '${_invitati.length}'),
            ],
            frase: T.saliraiMicSpento,
            azione: _continua(T.creaIlDen),
          ),
        _Passo.nonCreato => BaPassiCreazione.nonCreato(
            titolo: T.nonCreatoTitolo,
            errore: T.nonCreatoErrore,
            nota: T.nonCreatoNota,
            azione: azioneFoglio(T.riprova, _indietro),
          ),
      };

  @override
  Widget build(BuildContext context) {
    var passo = _passoCorrente;
    if (_passo != _Passo.tipo && _passo != _Passo.nonCreato) {
      passo = passo.conAltreAzioni([azioneFoglio(T.indietro, _indietro)]);
    }
    return BaFoglioPassi(
      nome: T.creaNome,
      passo: passo,
      nonOra: azioneFoglio(T.nonOra, () => Navigator.of(context).pop(), variante: BaVariantePillola.spenta),
    );
  }
}

// -------------------------------------------------------------------- sotto-DEN

/// «Nuovo sotto-DEN» (D1): chi crea il DEN crea i sotto-DEN (ipotesi del 014).
Future<void> apriSottoDen(BuildContext context, String denId) =>
    showBaFoglio<void>(context, etichettaVelo: T.chiudi, builder: (_) => _SottoDen(denId: denId));

class _SottoDen extends StatefulWidget {
  const _SottoDen({required this.denId});

  final String denId;

  @override
  State<_SottoDen> createState() => _SottoDenState();
}

class _SottoDenState extends State<_SottoDen> {
  final TextEditingController _nome = TextEditingController();
  String? _errore;

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaFoglioSottoDen(
      titolo: T.sottoDenNuovo,
      controller: _nome,
      etichetta: T.sottoDenEtichetta,
      segnaposto: T.sottoDenSegnaposto,
      errore: _errore,
      onChanged: (_) {
        if (_errore != null) setState(() => _errore = null);
      },
      frase: T.sottoDenFrase,
      nota: T.sottoDenNota,
      crea: azioneFoglio(T.creaSottoDen, () {
        if (_nome.text.trim().isEmpty) {
          setState(() => _errore = T.sottoDenErrore);
        } else {
          ProtoScope.leggi(context).creaSottoDen(widget.denId, _nome.text.trim());
          Navigator.of(context).pop();
        }
      }),
      nonOra: azioneFoglio(T.nonOra, () => Navigator.of(context).pop(), variante: BaVariantePillola.spenta),
    );
  }
}
