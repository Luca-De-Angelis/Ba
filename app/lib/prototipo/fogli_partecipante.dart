// «Diventa partecipante» (task 024a, prototipi 013 P1–P4 e 014 R1–R2): il foglio a
// più passi — avviso, numero, codice, consenso — che si apre quando un ascoltatore
// vuole salire sul palco o creare un DEN. Alla fine l'account passa da
// ascoltatore a partecipante (D-040) e, se si saliva, si sale **a microfono
// spento** (D-007). Il foglio è uno solo che cambia passo (`BaFoglioPassi`): il
// design system non sa quale passo viene dopo, lo sa questo file.
//
// Nessuna autenticazione vera: il codice **123456** è giusto, **000000** è scaduto,
// ogni altro è sbagliato; dopo «Mandalo di nuovo» l'attesa dura finché si scrive di
// nuovo (niente timer). «Indietro» e «Non ora» ci sono in ogni passo.
import 'package:flutter/widgets.dart';

import '../design_system/campo_codice.dart';
import '../design_system/foglio.dart';
import '../design_system/foglio_passi.dart';
import '../design_system/pillola.dart';
import 'testi.dart';
import 'util.dart';

/// Apre il foglio. [alTermine] parte dopo il consenso, a foglio chiuso.
Future<void> apriFoglioPartecipante(
  BuildContext context, {
  required bool perCreare,
  required VoidCallback alTermine,
}) async {
  final concluso = await showBaFoglio<bool>(
    context,
    etichettaVelo: T.chiudi,
    builder: (_) => FoglioPartecipante(perCreare: perCreare),
  );
  if (concluso == true) alTermine();
}

enum _Passo { avviso, numero, codice, consenso }

class FoglioPartecipante extends StatefulWidget {
  const FoglioPartecipante({super.key, required this.perCreare});

  /// Si crea un DEN (R1 e R2) invece di salire sul palco (P1 e P4).
  final bool perCreare;

  @override
  State<FoglioPartecipante> createState() => _FoglioPartecipanteState();
}

class _FoglioPartecipanteState extends State<FoglioPartecipante> {
  final TextEditingController _numero = TextEditingController();
  final TextEditingController _codice = TextEditingController();
  _Passo _passo = _Passo.avviso;
  bool _numeroVuoto = false;
  BaStatoCodice _statoCodice = BaStatoCodice.scrittura;

  @override
  void dispose() {
    _numero.dispose();
    _codice.dispose();
    super.dispose();
  }

  void _vai(_Passo p) => setState(() {
        _numeroVuoto = false;
        _passo = p;
      });

  void _indietro() => _vai(_Passo.values[_passo.index - 1]);

  void _avanti() {
    switch (_passo) {
      case _Passo.avviso:
        _vai(_Passo.numero);
      case _Passo.numero:
        // L'unica «validazione»: il numero non è vuoto.
        if (_numero.text.trim().isEmpty) {
          setState(() => _numeroVuoto = true);
          return;
        }
        setState(() {
          _statoCodice = BaStatoCodice.scrittura;
          _codice.clear();
          _passo = _Passo.codice;
        });
      case _Passo.codice:
        _confermaCodice();
      case _Passo.consenso:
        Navigator.of(context).pop(true);
    }
  }

  void _confermaCodice() {
    if (_statoCodice == BaStatoCodice.scaduto) {
      // «Manda un nuovo codice»: il nuovo invio resta in attesa finché si scrive.
      setState(() {
        _codice.clear();
        _statoCodice = BaStatoCodice.attesa;
      });
    } else if (_codice.text == T.codiceGiusto) {
      _vai(_Passo.consenso);
    } else if (_codice.text == T.codiceDiScaduto) {
      setState(() => _statoCodice = BaStatoCodice.scaduto);
    } else {
      setState(() => _statoCodice = BaStatoCodice.sbagliato);
    }
  }

  BaAzioneFoglio _primaria(String testo, {bool attiva = true}) => azioneFoglio(testo, attiva ? _avanti : null);

  BaPassoFoglio get _passoCorrente {
    final crea = widget.perCreare;
    return switch (_passo) {
      _Passo.avviso => BaPassoFoglio.avviso(
          id: 'avviso',
          titolo: crea ? T.paAvvisoCreaTitolo : T.paAvvisoTitolo,
          paragrafi: [
            BaParagrafoPasso(crea ? T.paAvvisoCrea : T.paAvvisoSali),
            const BaParagrafoPasso(T.paAvviso2),
            const BaParagrafoPasso(T.paAvviso3, evidenza: true),
          ],
          azione: _primaria(T.continua),
        ),
      _Passo.numero => BaPassoFoglio.numero(
          id: 'numero',
          titolo: T.paNumeroTitolo,
          controller: _numero,
          etichetta: T.paNumeroEtichetta,
          prefisso: T.paNumeroPrefisso,
          segnaposto: T.paNumeroSegnaposto,
          errore: _numeroVuoto ? T.paNumeroErrore : null,
          nota: T.paNumeroNota,
          onChanged: (_) {
            if (_numeroVuoto) setState(() => _numeroVuoto = false);
          },
          azione: _primaria(T.paNumeroAzione),
        ),
      _Passo.codice => BaPassoFoglio.codice(
          id: 'codice',
          titolo: T.paCodiceTitolo,
          frase: T.paCodiceFrase,
          codiceSemanticsLabel: T.codiceEtichetta,
          controller: _codice,
          stato: _statoCodice,
          fraseStato: switch (_statoCodice) {
            BaStatoCodice.scrittura => null,
            BaStatoCodice.sbagliato => T.paCodiceSbagliato,
            BaStatoCodice.scaduto => T.codiceScaduto,
            BaStatoCodice.attesa => T.codiceAttesa,
          },
          onChanged: (_) {
            // Scrivere di nuovo toglie l'errore e finisce l'attesa.
            if (_statoCodice == BaStatoCodice.sbagliato || _statoCodice == BaStatoCodice.attesa) {
              setState(() => _statoCodice = BaStatoCodice.scrittura);
            }
          },
          // Scaduto: la riga non c'è, l'azione che serve è la primaria.
          mandaDiNuovo: _statoCodice == BaStatoCodice.scaduto ? null : T.mandaDiNuovo,
          onMandaDiNuovo: _statoCodice == BaStatoCodice.attesa || _statoCodice == BaStatoCodice.scaduto
              ? null
              : () => setState(() {
                    _codice.clear();
                    _statoCodice = BaStatoCodice.attesa;
                  }),
          azione: _primaria(
            _statoCodice == BaStatoCodice.scaduto ? T.mandaNuovoCodice : T.conferma,
            attiva: _statoCodice != BaStatoCodice.attesa,
          ),
        ),
      _Passo.consenso => BaPassoFoglio.consenso(
          id: 'consenso',
          titolo: T.paConsensoTitolo,
          paragrafi: const [
            BaParagrafoPasso(T.paConsenso1),
            BaParagrafoPasso(T.paConsenso2, evidenza: true),
          ],
          rigaSale: crea ? null : T.saliraiMicSpento,
          azione: _primaria(crea ? T.paConsensoCrea : T.paConsensoSali),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var passo = _passoCorrente;
    if (_passo != _Passo.avviso) {
      // «Indietro» c'è in ogni passo dopo il primo.
      passo = passo.conAltreAzioni([azioneFoglio(T.indietro, _indietro)]);
    }
    return BaFoglioPassi(
      nome: T.partecipanteNome,
      passo: passo,
      nonOra: azioneFoglio(T.nonOra, () => Navigator.of(context).pop(false), variante: BaVariantePillola.spenta),
    );
  }
}
