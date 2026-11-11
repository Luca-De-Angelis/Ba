// La galleria di BaPalco (task 011): una stanza finta, con intestazione, il
// palco in un Expanded e una riga sotto. Strumento di sviluppo: i comandi e le
// scritte della stanza sono fissi; i testi del palco (invito, etichette) si
// compongono con le chiavi ARB, così si vedono nelle cinque lingue.
//
// Con 1 persona e testo normale si vede la stanza vuota con una persona a 208 dp.
import 'package:flutter/widgets.dart';

import '../design_system/palco.dart';
import '../design_system/palco/disposizione.dart';
import '../design_system/tokens.dart';
import '../l10n/app_localizations.dart';
import 'comuni.dart';

/// I due dispositivi di riferimento (D-022, D-027).
const double _telefono = 360;
const double _tablet = 744;

/// Le altezze della stanza finta, dalla più alta: per far cedere il palco
/// senza ridimensionare la finestra. Dati di prova, non misure di design.
/// Scelte per il caso del testo 2,0 con otto persone, dove intestazione e riga
/// prendono circa 376 dp: il palco resta con 324, 244, 184 e 144 dp e il
/// diametro scende per gradi (88, 72, 50, 35). Sotto i 520 la stanza non
/// contiene più nemmeno intestazione e riga.
const List<double> _altezze = [700, 620, 560, 520];

/// I due testi del testo di sistema da provare (C6: oltre 2,0 non si scala).
const double _testoNormale = 1.0;
const double _testoGrande = BaScalaTokens.maxTesto;

const List<String> _nomi = [
  'Marta B.', 'Luca D.', 'Giulia T.', 'Anna V.', 'Sara P.', 'Elena C.', 'Dario N.', 'Fabio M.', //
];

const List<Locale> _lingue = [
  Locale('it'), Locale('en'), Locale('fr'), Locale('es'), Locale('de'), //
];

/// Quante persone possono parlare insieme nella prova: 0–3.
const int _parlanoMax = 3;

class GalleriaPalco extends StatefulWidget {
  const GalleriaPalco({super.key});

  @override
  State<GalleriaPalco> createState() => _GalleriaPalcoState();
}

class _GalleriaPalcoState extends State<GalleriaPalco> {
  int _persone = 1;
  int _parlano = 0;
  bool _persa = false;
  bool _scheletro = false;
  bool _congelato = false;
  double _larghezza = _telefono;
  int _altezza = 0; // indice in _altezze
  double _testo = _testoNormale;
  bool _riduciMovimento = false;
  int _lingua = 0;

  @override
  Widget build(BuildContext context) {
    final base = MediaQuery.of(context);
    return ColoredBox(
      color: BaColorTokens.fondoApp,
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(BaSpazioTokens.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BaPalco', style: BaTestoTokens.stanza),
                const SizedBox(height: BaSpazioTokens.s),
                Text(
                  'Il palco riceve una scatola e ne ricava diametro e posizioni. '
                  'Provalo con più persone, con il testo grande e a 744: cede il '
                  "palco, nessuna presenza sparisce. Strumento di sviluppo: non fa parte dell'app.",
                  style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
                ),
                const SizedBox(height: BaSpazioTokens.xxl),
                _controlli(),
                const SizedBox(height: BaSpazioTokens.xxl),
                // La lingua vale solo per la stanza: i comandi restano fissi.
                Localizations.override(
                  context: context,
                  locale: _lingue[_lingua],
                  child: Builder(builder: (context) => _stanza(context, base)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------- controlli

  Widget _controlli() {
    return Wrap(
      spacing: BaControlloTokens.gapCoppia,
      runSpacing: BaControlloTokens.gapCoppia,
      children: [
        galleriaInterruttore(
          'Persone −',
          false,
          () => setState(() => _persone = _persone > 0 ? _persone - 1 : 0),
        ),
        galleriaInterruttore('Persone: $_persone', true, () {}),
        galleriaInterruttore(
          'Persone +',
          false,
          () => setState(() => _persone = _persone < 8 ? _persone + 1 : 8),
        ),
        galleriaInterruttore(
          'Parlano: $_parlano',
          _parlano > 0,
          () => setState(() => _parlano = (_parlano + 1) % (_parlanoMax + 1)),
        ),
        galleriaInterruttore('Persa', _persa, () => setState(() => _persa = !_persa)),
        galleriaInterruttore(
          'Scheletro',
          _scheletro,
          () => setState(() {
            _scheletro = !_scheletro;
            if (_scheletro) _congelato = false;
          }),
        ),
        galleriaInterruttore(
          'Congelato',
          _congelato,
          () => setState(() {
            _congelato = !_congelato;
            if (_congelato) _scheletro = false;
          }),
        ),
        galleriaInterruttore(
          'Larghezza ${_larghezza.toInt()}',
          _larghezza == _tablet,
          () => setState(() => _larghezza = _larghezza == _telefono ? _tablet : _telefono),
        ),
        galleriaInterruttore(
          'Altezza: ${_altezze[_altezza].toInt()}',
          _altezza != 0,
          () => setState(() => _altezza = (_altezza + 1) % _altezze.length),
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
          'Lingua: ${_lingue[_lingua].languageCode.toUpperCase()}',
          _lingua != 0,
          () => setState(() => _lingua = (_lingua + 1) % _lingue.length),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------- stanza

  List<BaPersonaPalco> _gente(AppLocalizations l) => [
        for (var i = 0; i < _persone; i++)
          BaPersonaPalco(
            id: 'p$i',
            indiceTinta: i,
            indiceSagoma: i % BaSagomaTokens.mazzo.length,
            iniziali: _nomi[i].substring(0, 1) + _nomi[i].split(' ').last.substring(0, 1),
            semanticsLabel: _nomi[i],
            semanticsLabelParla: l.presenzaParla(_nomi[i]),
            parla: i < _parlano,
            ampiezza: 1,
            persa: _persa && i == 0,
            onTap: () {},
          ),
      ];

  BaStatoPalco get _stato => _congelato
      ? const BaStatoPalco.congelato()
      : _scheletro
          ? BaStatoPalco.scheletro(_persone)
          : const BaStatoPalco.vivo();

  Widget _stanza(BuildContext context, MediaQueryData base) {
    final l = AppLocalizations.of(context)!;
    final altezza = _altezze[_altezza];
    final margine = BaLayoutTokens.margine(_larghezza);

    return Container(
      width: _larghezza,
      height: altezza,
      decoration: BoxDecoration(
        color: BaColorTokens.fondoApp,
        border: Border.all(color: BaColorTokens.filettoBase),
      ),
      // Il testo di sistema e "riduci movimento" passano da MediaQuery, come li
      // leggono i widget; la larghezza è quella dello schermo (D-027).
      child: MediaQuery(
        data: base.copyWith(
          size: Size(_larghezza, altezza),
          textScaler: TextScaler.linear(_testo),
          disableAnimations: _riduciMovimento,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.l, margine, 0),
              // Titolo sopra e marcatore sotto: a testo grande stanno in colonna e
              // crescono in altezza, e il palco cede.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Serata sul balcone', style: BaTestoTokens.stanza),
                  Text(
                    '$_persone SUL PALCO',
                    style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: margine),
                child: _palco(l),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(margine, 0, margine, BaSpazioTokens.l),
              child: Text(
                'Parli a tutti · 12 in ascolto',
                style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _palco(AppLocalizations l) {
    return LayoutBuilder(
      builder: (context, vincoli) {
        final scatola = vincoli.biggest;
        final n = _persone;
        final disposizione = disponiPalco(
          persone: n,
          scatola: scatola,
          larghezzaSchermo: _larghezza,
        );
        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            BaPalco(
              persone: _gente(l),
              larghezzaSchermo: _larghezza,
              stato: _stato,
              semanticsLabel: l.palcoEtichetta(n),
              invitoTitolo: l.palcoLibero,
              invitoTesto: l.palcoInvito,
            ),
            // Indicatore di sviluppo: diametro, scatola e sfora.
            // left e right: la riga è larga quanto il palco e va a capo dentro di lui
            // (un Positioned senza i due lati non limita la larghezza del figlio).
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: IgnorePointer(
                child: Text(
                  'd = ${disposizione.diametro.toStringAsFixed(0)} dp · '
                  'scatola ${scatola.width.toStringAsFixed(0)} × ${scatola.height.toStringAsFixed(0)} · '
                  'sfora: ${disposizione.sfora ? 'sì' : 'no'}',
                  style: BaTestoTokens.nota.copyWith(
                    color: disposizione.sfora ? BaColorTokens.erroreTesto : BaColorTokens.testoTerzo,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
