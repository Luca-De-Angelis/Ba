// La galleria dei componenti dei task 013, 014 e 015 (task 022): accesso,
// creazione dei DEN, coda e attesa. Strumento di sviluppo: testi fissi, niente
// l10n. Solo token per colori, misure e durate; 360 e 744 sono i dispositivi di
// riferimento (D-022, D-027), 1,0 e 2,0 i due testi di sistema da provare (C6).
//
// Il campo del codice si può scrivere davvero: prova a incollare «481902», o
// «48a1-9», e a cancellare. Il pulsante «Codice» cambia stato (scrittura,
// sbagliato, scaduto, nuovo invio con attesa).
import 'package:flutter/widgets.dart';

import '../design_system/banda_posto.dart';
import '../design_system/campo_codice.dart';
import '../design_system/campo_testo.dart';
import '../design_system/chip_scelta.dart';
import '../design_system/fascia_attesa.dart';
import '../design_system/interruttore_riga.dart';
import '../design_system/punto_aggancio.dart';
import '../design_system/riga_coda.dart';
import '../design_system/scelta_den.dart';
import '../design_system/tokens.dart';
import 'comuni.dart';

const double _telefono = 360;
const double _tablet = 744;
const double _testoNormale = 1.0;
const double _testoGrande = BaScalaTokens.maxTesto;

const List<String> _temi = ['Cucina', 'Musica', 'Sport', 'Libri', 'Viaggi', 'Cinema', 'Notte'];

class GalleriaAccesso extends StatefulWidget {
  const GalleriaAccesso({super.key});

  @override
  State<GalleriaAccesso> createState() => _GalleriaAccessoState();
}

class _GalleriaAccessoState extends State<GalleriaAccesso> {
  double _larghezza = _telefono;
  double _testo = _testoNormale;
  bool _riduciMovimento = false;

  // Campi.
  final _vuoto = TextEditingController();
  final _compilato = TextEditingController(text: 'sara.m@esempio.it');
  final _errore = TextEditingController(text: 'sara.m@esempio');
  final _numero = TextEditingController();
  final _descrizione = TextEditingController();

  // Codice.
  final _codice = TextEditingController();
  BaStatoCodice _statoCodice = BaStatoCodice.scrittura;
  String _completo = '—';

  // Scelta, chip, interruttori.
  int? _tipo = 0;
  int? _tema = 1;
  bool _automatico = true;
  bool _conAltri = false;

  @override
  void dispose() {
    for (final c in [_vuoto, _compilato, _errore, _numero, _descrizione, _codice]) {
      c.dispose();
    }
    super.dispose();
  }

  String get _fraseCodice => switch (_statoCodice) {
        BaStatoCodice.sbagliato => 'Il codice non è giusto. Controlla l\'email e riprova.',
        BaStatoCodice.scaduto => 'Il codice è scaduto. Te ne mandiamo uno nuovo.',
        BaStatoCodice.attesa => 'Ne puoi chiedere un altro fra poco.',
        BaStatoCodice.scrittura => '',
      };

  /// Le frasi della banda del posto: 30 secondi e 5 minuti, composte come le
  /// comporrà il chiamante con `oraDelPosto`.
  String _fraseBanda(Duration durata) {
    final persa = DateTime(2026, 11, 18, 21, 40, 50);
    final ora = BaCodaTokens.oraDelPosto(persa, durata);
    return ora == null
        ? 'Hai perso la linea. Il posto resta tuo ancora per un momento.'
        : 'Hai perso la linea. Il posto resta tuo fino alle ${BaOra.hhmm(ora)}.';
  }

  @override
  Widget build(BuildContext context) {
    final base = MediaQuery.of(context);
    final margine = BaLayoutTokens.margine(_larghezza);
    const sezione = BaSpazioTokens.xxl;

    return ColoredBox(
      color: BaColorTokens.fondoApp,
      child: SingleChildScrollView(
        child: Center(
          child: MediaQuery(
            data: base.copyWith(
              size: Size(_larghezza, base.size.height),
              textScaler: TextScaler.linear(_testo),
              disableAnimations: _riduciMovimento,
            ),
            child: SizedBox(
              width: _larghezza,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: margine, vertical: sezione),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Accesso, creazione e coda', style: BaTestoTokens.stanza),
                    const SizedBox(height: BaSpazioTokens.s),
                    Text(
                      'I componenti dei task 013, 014 e 015, nei loro stati. Il codice si scrive davvero. '
                      "Strumento di sviluppo: non fa parte dell'app.",
                      style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
                    ),
                    const SizedBox(height: sezione),
                    _comandi(),
                    const SizedBox(height: sezione),
                    ..._campi(),
                    const SizedBox(height: sezione),
                    ..._codiceSezione(),
                    const SizedBox(height: sezione),
                    ..._creazione(),
                    const SizedBox(height: sezione),
                    ..._coda(),
                  ],
                ),
              ),
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
      ],
    );
  }

  Widget _gap() => const SizedBox(height: BaSpazioTokens.xl);

  // ------------------------------------------------------------- campi

  List<Widget> _campi() => [
        galleriaTitolo('Campo di testo · vuoto, compilato, errore, numero, descrizione'),
        BaCampoTesto(
          controller: _vuoto,
          etichetta: 'Email',
          segnaposto: 'nome@esempio.it',
          aiuto: 'Ti mandiamo un codice. Niente password.',
          tastiera: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
        ),
        _gap(),
        BaCampoTesto(controller: _compilato, etichetta: 'Email', tastiera: TextInputType.emailAddress),
        _gap(),
        BaCampoTesto(
          controller: _errore,
          etichetta: 'Email',
          errore: 'Questa email non sembra giusta. Controllala e riprova.',
          tastiera: TextInputType.emailAddress,
        ),
        _gap(),
        BaCampoTesto(
          controller: _numero,
          etichetta: 'Numero di telefono',
          prefisso: '+39',
          segnaposto: '320 000 0000',
          tastiera: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumberNational],
        ),
        _gap(),
        BaCampoTesto(
          controller: _descrizione,
          etichetta: 'Descrizione',
          segnaposto: 'Di che cosa si parla?',
          minRighe: 3,
          maxRighe: 6,
        ),
      ];

  // ------------------------------------------------------------- codice

  List<Widget> _codiceSezione() => [
        galleriaTitolo('Codice · si scrive davvero · stato: ${_statoCodice.name}'),
        BaCampoCodice(
          semanticsLabel: 'Codice di sei cifre',
          controller: _codice,
          stato: _statoCodice,
          frase: _statoCodice == BaStatoCodice.scrittura ? null : _fraseCodice,
          onCompleto: (c) => setState(() => _completo = c),
        ),
        const SizedBox(height: BaSpazioTokens.m),
        Text(
          'Completo: $_completo',
          style: BaTestoTokens.nota.copyWith(color: BaColorTokens.testoTerzo),
        ),
        const SizedBox(height: BaSpazioTokens.m),
        Wrap(
          spacing: BaControlloTokens.gapCoppia,
          runSpacing: BaControlloTokens.gapCoppia,
          children: [
            galleriaInterruttore(
              'Codice: ${_statoCodice.name}',
              _statoCodice != BaStatoCodice.scrittura,
              () => setState(() {
                _statoCodice = BaStatoCodice.values[(_statoCodice.index + 1) % BaStatoCodice.values.length];
                // Il codice sbagliato tiene le cifre; lo scaduto le svuota.
                if (_statoCodice == BaStatoCodice.sbagliato && _codice.text.isEmpty) _codice.text = '481902';
              }),
            ),
            galleriaInterruttore('Svuota il codice', false, () => setState(() {
                  _codice.clear();
                  _completo = '—';
                })),
          ],
        ),
      ];

  // ------------------------------------------------------------- creazione

  List<Widget> _creazione() => [
        galleriaTitolo('Scelta del tipo di DEN'),
        BaSceltaDen(
          opzioni: const [
            BaOpzioneScelta(titolo: 'Privato', descrizione: 'Si entra solo su invito.'),
            BaOpzioneScelta(titolo: 'Pubblico', descrizione: 'Entra chiunque.'),
          ],
          scelta: _tipo,
          onScelta: (i) => setState(() => _tipo = i),
          fraseSotto: _tipo == 0
              ? 'Inviti tu chi vuoi: gli altri non lo vedono.'
              : 'Chiunque può entrare nel pubblico e ascoltare.',
        ),
        const SizedBox(height: BaSpazioTokens.xxl),
        galleriaTitolo('Chip di tema e lingua · vanno a capo'),
        Wrap(
          spacing: BaCreazioneTokens.chipGap,
          runSpacing: BaCreazioneTokens.chipGap,
          children: [
            for (var i = 0; i < _temi.length; i++)
              BaChipScelta(testo: _temi[i], scelto: i == _tema, onTap: () => setState(() => _tema = i)),
          ],
        ),
        const SizedBox(height: BaSpazioTokens.xxl),
        galleriaTitolo('Punto di aggancio · solo un posto, mai un\'azione'),
        const BaPuntoAggancio(
          titolo: 'Qui, le persone da invitare',
          sottotitolo: 'La fonte non è ancora decisa',
        ),
        _gap(),
        const BaPuntoAggancio.quando(
          etichetta: 'Quando',
          titolo: 'Adesso',
          sottotitolo: 'Programmare un DEN arriverà dopo',
        ),
      ];

  // ------------------------------------------------------------- coda

  List<Widget> _coda() => [
        galleriaTitolo('Interruttore di riga · acceso e spento'),
        BaInterruttoreRiga(
          titolo: 'Fammi entrare automaticamente',
          descrizione: 'Quando si libera un posto, entri tu, a microfono spento.',
          acceso: _automatico,
          parolaAcceso: 'Acceso',
          parolaSpento: 'Spento',
          onCambia: (v) => setState(() => _automatico = v),
        ),
        BaInterruttoreRiga(
          titolo: 'Aspetta con altri',
          descrizione: 'Un gruppo di chi aspetta nella stessa coda.',
          acceso: _conAltri,
          parolaAcceso: 'Acceso',
          parolaSpento: 'Spento',
          onCambia: (v) => setState(() => _conAltri = v),
        ),
        const SizedBox(height: BaSpazioTokens.xxl),
        galleriaTitolo('Le tue code · nessuna posizione, nessun conteggio'),
        BaRigaCoda(
          nome: 'Cucina di notte',
          stato: 'In coda · entri a microfono spento',
          uscitaTesto: 'Esci dalla coda',
          onEsci: () {},
        ),
        BaRigaCoda(
          nome: 'Fra due turni',
          stato: 'In coda · entri a microfono spento',
          uscitaTesto: 'Esci dalla coda',
          onEsci: () {},
        ),
        const SizedBox(height: BaSpazioTokens.xxl),
        galleriaTitolo('Sotto-DEN d\'attesa · con e senza «Lascia il gruppo»'),
        BaFasciaAttesa(
          conteggio: 4,
          tinte: const [0, 1, 2, 3],
          sagome: const [0, 1, 2, 3],
          frase: 'Parli al gruppo di chi aspetta. Il palco non ti sente.',
          lasciaTesto: 'Lascia il gruppo',
          onLascia: () {},
        ),
        _gap(),
        const BaFasciaAttesa(
          conteggio: 8,
          tinte: [4, 5, 6, 7],
          sagome: [4, 3, 2, 1],
          frase: 'Parli al gruppo di chi aspetta. Il palco non ti sente.',
        ),
        const SizedBox(height: BaSpazioTokens.xxl),
        galleriaTitolo('Banda del posto · 30 secondi e 5 minuti, e la permanenza'),
        BaBandaPosto(
          testo: _fraseBanda(BaCodaTokens.postoConservatoFree),
          sottotesto: 'Il microfono è spento.',
          annuncia: true,
        ),
        _gap(),
        BaBandaPosto(
          testo: _fraseBanda(const Duration(minutes: 5)),
          sottotesto: 'Il microfono è spento.',
          annuncia: true,
        ),
        _gap(),
        const BaBandaPosto(
          testo: 'Puoi restare fino alle 22:40. Poi puoi rientrare.',
          sottotesto: 'Con la stanza piena e la coda.',
          variante: BaVarianteBanda.permanenza,
        ),
      ];
}
