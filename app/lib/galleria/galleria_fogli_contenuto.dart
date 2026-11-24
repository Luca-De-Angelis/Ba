// La galleria dei fogli di contenuto (task 023a): il foglio a più passi di
// «diventa partecipante» (013 e 014: P1–P4, R1 e R2) e i contenuti della coda e
// dell'attesa (015: K2, W1, K1, S1, K6). Strumento di sviluppo: testi fissi
// in italiano, presi dai prototipi, niente l10n (D-030). Solo token per colori,
// misure e durate; 360 e 744 sono i dispositivi di riferimento (D-022, D-027),
// 1,0 e 2,0 i due testi di sistema da provare (C6).
//
// Il design system non sa quale passo viene dopo: qui, e solo qui, «Continua» e
// «Indietro (di prova)» fanno da macchina a stati. Il numero e il codice sono
// campi veri, e la galleria non valida niente oltre «il numero non è vuoto».
//
// La «schermata» è una scatola con un Navigator interno (GalleriaNavigator): i
// fogli la coprono, come su un telefono.
import 'package:flutter/widgets.dart';

import '../design_system/campo_codice.dart';
import '../design_system/foglio.dart';
import '../design_system/foglio_passi.dart';
import '../design_system/fogli_coda.dart';
import '../design_system/interruttore_riga.dart';
import '../design_system/riga_coda.dart';
import '../design_system/tokens.dart';
import 'comuni.dart';
import 'galleria_navigator.dart';

const double _telefono = 360;
const double _tablet = 744;
const double _testoNormale = 1.0;
const double _testoGrande = BaScalaTokens.maxTesto;

/// L'altezza della schermata finta: un telefono alto.
const double _altezzaSchermata = 760;

class GalleriaFogliContenuto extends StatefulWidget {
  const GalleriaFogliContenuto({super.key});

  @override
  State<GalleriaFogliContenuto> createState() => _GalleriaFogliContenutoState();
}

class _GalleriaFogliContenutoState extends State<GalleriaFogliContenuto> {
  double _larghezza = _telefono;
  double _testo = _testoNormale;
  bool _riduciMovimento = false;
  BaStatoCodice _statoCodice = BaStatoCodice.scrittura;

  @override
  Widget build(BuildContext context) {
    final base = MediaQuery.of(context);
    const sezione = BaSpazioTokens.xxl;

    return ColoredBox(
      color: BaColorTokens.fondoApp,
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(BaSpazioTokens.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fogli di contenuto', style: BaTestoTokens.stanza),
                const SizedBox(height: BaSpazioTokens.s),
                Text(
                  "Un pulsante per ogni contenuto: lo apre in un foglio sulla schermata finta. I passi si percorrono con "
                  "«Continua» e «Indietro (di prova)», che esistono solo qui. Strumento di sviluppo: non fa parte dell'app.",
                  style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
                ),
                const SizedBox(height: sezione),
                _comandi(),
                const SizedBox(height: sezione),
                Container(
                  width: _larghezza,
                  height: _altezzaSchermata,
                  decoration: BoxDecoration(
                    color: BaColorTokens.fondoApp,
                    border: Border.all(color: BaColorTokens.filettoBase),
                  ),
                  child: MediaQuery(
                    data: base.copyWith(
                      size: Size(_larghezza, _altezzaSchermata),
                      textScaler: TextScaler.linear(_testo),
                      disableAnimations: _riduciMovimento,
                    ),
                    child: GalleriaNavigator(
                      child: Builder(builder: (contesto) => _schermata(contesto)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _comandi() {
    return Wrap(
      spacing: BaControlloTokens.gapCoppia,
      runSpacing: BaControlloTokens.gapCoppia,
      children: [
        galleriaInterruttore(
          'Larghezza ${_larghezza.toInt()}',
          _larghezza == _tablet,
          () => setState(() => _larghezza = _larghezza == _telefono ? _tablet : _telefono),
        ),
        galleriaInterruttore(
          'Testo ${_testo == _testoNormale ? '1,0' : '2,0'}',
          _testo == _testoGrande,
          () => setState(() => _testo = _testo == _testoNormale ? _testoGrande : _testoNormale),
        ),
        galleriaInterruttore(
          'Riduci movimento',
          _riduciMovimento,
          () => setState(() => _riduciMovimento = !_riduciMovimento),
        ),
        galleriaInterruttore(
          'Codice: ${_statoCodice.name}',
          _statoCodice != BaStatoCodice.scrittura,
          () => setState(
            () => _statoCodice = BaStatoCodice.values[(_statoCodice.index + 1) % BaStatoCodice.values.length],
          ),
        ),
      ],
    );
  }

  /// La schermata finta: i pulsanti che aprono i fogli.
  Widget _schermata(BuildContext contesto) {
    final margine = BaLayoutTokens.margine(_larghezza);
    return SingleChildScrollView(
      padding: EdgeInsets.all(margine),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          galleriaTitolo('Diventa partecipante (013, 014)'),
          _pulsanti([
            ('Sali sul palco', () => _percorso(contesto, creaDen: false)),
            ('Crea un DEN', () => _percorso(contesto, creaDen: true)),
          ]),
          const SizedBox(height: BaSpazioTokens.l),
          galleriaTitolo('Coda e attesa (015)'),
          _pulsanti([
            ('Mettiti in coda', () => _mettiti(contesto, conAspetta: false)),
            ('Mettiti in coda, con «Aspetta con altri»', () => _mettiti(contesto, conAspetta: true)),
            ('Aspetta con altri', () => _attesa(contesto)),
            ('Le tue code', () => _code(contesto)),
            ('Coda piena', () => _piena(contesto)),
            ('Vuoi passare di qua?', () => _passa(contesto)),
          ]),
        ],
      ),
    );
  }

  Widget _pulsanti(List<(String, VoidCallback)> voci) => Wrap(
        spacing: BaControlloTokens.gapCoppia,
        runSpacing: BaControlloTokens.gapCoppia,
        children: [for (final (testo, onTap) in voci) galleriaInterruttore(testo, false, onTap)],
      );

  // --------------------------------------------------------------- i fogli

  void _percorso(BuildContext contesto, {required bool creaDen}) {
    showBaFoglio<void>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (_) => _Percorso(creaDen: creaDen, statoCodice: _statoCodice),
    );
  }

  void _mettiti(BuildContext contesto, {required bool conAspetta}) {
    showBaFoglio<void>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (_) => _MettitiInCoda(conAspetta: conAspetta),
    );
  }

  void _attesa(BuildContext contesto) {
    showBaFoglio<void>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (foglio) => BaFoglioAspettaConAltri(
        titolo: 'Aspetta con altri',
        paragrafi: const [
          BaParagrafoPasso(
            'Un gruppo di chi aspetta come te, fino a 8. Sentite il DEN e parlate fra voi. Dal palco nessuno vi sente.',
          ),
          BaParagrafoPasso(
            'Quando si libera un posto, lasci il gruppo e sali sul palco, a microfono spento.',
            evidenza: true,
          ),
        ],
        entra: _azione(foglio, 'Entra nel gruppo'),
        nonOra: _azione(foglio, 'Non ora'),
      ),
    );
  }

  void _code(BuildContext contesto) {
    showBaFoglio<void>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (foglio) => BaFoglioLeTueCode(
        titolo: 'Le tue code',
        frase: 'Ti avvisiamo quando si libera un posto.',
        code: [
          for (final nome in const ['Cucina di notte', 'Fra due turni'])
            BaRigaCoda(
              nome: nome,
              stato: 'In coda · entri a microfono spento',
              uscitaTesto: 'Esci dalla coda',
              onEsci: () => Navigator.of(foglio).pop(),
            ),
        ],
        chiudi: _azione(foglio, 'Chiudi'),
      ),
    );
  }

  void _piena(BuildContext contesto) {
    showBaFoglio<void>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (foglio) => BaFoglioCodaPiena(
        titolo: 'La coda è piena adesso',
        frase: 'Resti nel pubblico e ascolti. Riprova fra poco.',
        haCapito: _azione(foglio, 'Ho capito'),
      ),
    );
  }

  void _passa(BuildContext contesto) {
    showBaFoglio<void>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (foglio) => BaFoglioPassaDiQua(
        titolo: 'Si è liberato un posto in Cucina di notte',
        paragrafi: const [
          BaParagrafoPasso('Vuoi passare di qua? Salirai a microfono spento.'),
          BaParagrafoPasso('Hai pochi secondi per decidere.', evidenza: true),
        ],
        passa: _azione(foglio, 'Passa'),
        restaQui: _azione(foglio, 'Resta qui'),
      ),
    );
  }
}

/// Un'azione che chiude il foglio.
BaAzioneFoglio _azione(BuildContext foglio, String testo) =>
    BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: () => Navigator.of(foglio).pop());

/// «Mettiti in coda» con gli interruttori che cambiano davvero.
class _MettitiInCoda extends StatefulWidget {
  const _MettitiInCoda({required this.conAspetta});

  final bool conAspetta;

  @override
  State<_MettitiInCoda> createState() => _MettitiInCodaState();
}

class _MettitiInCodaState extends State<_MettitiInCoda> {
  bool _ingresso = false;
  bool _aspetta = false;

  @override
  Widget build(BuildContext context) {
    return BaFoglioMettitiInCoda(
      titolo: 'Mettiti in coda',
      frase: 'Il palco è pieno. Se si libera un posto, te lo diciamo.',
      ingressoAutomatico: BaInterruttoreRiga(
        titolo: 'Fammi entrare automaticamente',
        descrizione: _ingresso
            ? 'Quando si libera un posto, sali da solo.'
            : 'Quando si libera un posto, la notifica ti porta alla stanza.',
        acceso: _ingresso,
        parolaAcceso: 'Acceso',
        parolaSpento: 'Spento',
        onCambia: (v) => setState(() => _ingresso = v),
      ),
      aspettaConAltri: widget.conAspetta
          ? BaInterruttoreRiga(
              titolo: 'Aspetta con altri',
              descrizione: 'Un gruppo di chi aspetta, fino a 8. Non è il palco.',
              acceso: _aspetta,
              parolaAcceso: 'Acceso',
              parolaSpento: 'Spento',
              onCambia: (v) => setState(() => _aspetta = v),
            )
          : null,
      rigaSale: 'Salirai a microfono spento.',
      mettitiInCoda: _azione(context, 'Mettiti in coda'),
      nonOra: _azione(context, 'Non ora'),
    );
  }
}

/// Il foglio a più passi: «Continua» e «Indietro (di prova)» fanno da macchina a
/// stati, solo nella galleria. [creaDen] usa R1 e R2 (014) al posto di P1 e P4.
class _Percorso extends StatefulWidget {
  const _Percorso({required this.creaDen, required this.statoCodice});

  final bool creaDen;
  final BaStatoCodice statoCodice;

  @override
  State<_Percorso> createState() => _PercorsoState();
}

class _PercorsoState extends State<_Percorso> {
  static const int _ultimo = 3;

  final TextEditingController _numero = TextEditingController();
  int _passo = 0;
  bool _numeroVuoto = false;

  @override
  void dispose() {
    _numero.dispose();
    super.dispose();
  }

  void _avanti() {
    if (_passo == 1 && _numero.text.trim().isEmpty) {
      // L'unica «validazione» della galleria: il numero non è vuoto.
      setState(() => _numeroVuoto = true);
      return;
    }
    if (_passo == _ultimo) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _numeroVuoto = false;
      _passo++;
    });
  }

  BaAzioneFoglio _continua(String testo) => BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: _avanti);

  BaPassoFoglio get _passoCorrente => switch (_passo) {
        0 => BaPassoFoglio.avviso(
            id: 'avviso',
            titolo: widget.creaDen ? 'Per creare un DEN bisogna diventare partecipante' : 'Vuoi salire sul palco?',
            paragrafi: [
              BaParagrafoPasso(
                widget.creaDen
                    ? 'Servono un numero di telefono verificato e il consenso a parlare.'
                    : 'Per parlare bisogna diventare partecipante. Servono un numero di telefono verificato e il consenso a parlare.',
              ),
              const BaParagrafoPasso(
                'Mentre parli, la tua voce si registra per poco tempo e si trascrive; il testo serve alla moderazione e a costruire il tuo profilo.',
              ),
              const BaParagrafoPasso(
                'Nessuna conversazione si può riascoltare. La voce si cancella dopo la trascrizione, il testo resta per un periodo.',
                evidenza: true,
              ),
            ],
            azione: _continua('Continua'),
          ),
        1 => BaPassoFoglio.numero(
            id: 'numero',
            titolo: 'Il tuo numero',
            controller: _numero,
            etichetta: 'Numero di telefono',
            prefisso: '+39',
            segnaposto: '320 000 0000',
            errore: _numeroVuoto ? 'Scrivi il tuo numero di telefono.' : null,
            nota: 'Ti mandiamo un codice per SMS. Il numero serve solo per parlare.',
            onChanged: (_) {
              if (_numeroVuoto) setState(() => _numeroVuoto = false);
            },
            azione: _continua('Ricevi il codice'),
          ),
        2 => _codice(),
        _ => BaPassoFoglio.consenso(
            id: 'consenso',
            titolo: 'Vuoi parlare?',
            paragrafi: const [
              BaParagrafoPasso('Acconsenti che, mentre parli, la tua voce si registri per poco tempo e si trascriva.'),
              BaParagrafoPasso(
                'Con il consenso il tuo account passa da ascoltatore a partecipante.',
                evidenza: true,
              ),
            ],
            rigaSale: widget.creaDen ? null : 'Salirai a microfono spento.',
            azione: _continua(widget.creaDen ? 'Acconsento e continuo' : 'Acconsento e salgo'),
          ),
      };

  BaPassoFoglio _codice() {
    final stato = widget.statoCodice;
    return BaPassoFoglio.codice(
      id: 'codice',
      titolo: 'Il codice',
      frase: 'Mandato al +39 ••• ••• 0000.',
      codiceSemanticsLabel: 'Codice di sei cifre',
      stato: stato,
      fraseStato: switch (stato) {
        BaStatoCodice.scrittura => null,
        BaStatoCodice.sbagliato => 'Il codice non è giusto. Controlla gli SMS e riprova.',
        BaStatoCodice.scaduto => 'Il codice è scaduto. Te ne mandiamo uno nuovo.',
        BaStatoCodice.attesa => 'Ne puoi chiedere un altro fra poco.',
      },
      // Scaduto: la riga non c'è, l'azione che serve è la primaria. Attesa: la
      // riga c'è ma è inattiva, e una frase ferma dice perché.
      mandaDiNuovo: stato == BaStatoCodice.scaduto ? null : 'Mandalo di nuovo',
      onMandaDiNuovo: stato == BaStatoCodice.attesa || stato == BaStatoCodice.scaduto ? null : () {},
      azione: _continua(stato == BaStatoCodice.scaduto ? 'Manda un nuovo codice' : 'Conferma'),
    );
  }

  @override
  Widget build(BuildContext context) {
    var passo = _passoCorrente;
    if (_passo > 0) {
      passo = passo.conAltreAzioni([
        BaAzioneFoglio(
          testo: 'Indietro (di prova)',
          semanticsLabel: 'Indietro (di prova)',
          onTap: () => setState(() {
            _numeroVuoto = false;
            _passo--;
          }),
        ),
      ]);
    }
    return BaFoglioPassi(
      nome: 'Diventa partecipante',
      passo: passo,
      nonOra: _azione(context, 'Non ora'),
    );
  }
}
