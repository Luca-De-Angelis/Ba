// La galleria di BaPalco (task 011): una stanza finta, con intestazione, il
// palco in un Expanded e una riga sotto. Strumento di sviluppo: i comandi e le
// scritte della stanza sono fissi; i testi del palco (invito, etichette) si
// compongono con le chiavi ARB, così si vedono nelle cinque lingue.
//
// Con 1 persona e testo normale si vede la stanza vuota con una persona a 208 dp.
import 'package:flutter/widgets.dart';

import '../design_system/barra_azioni.dart';
import '../design_system/palco.dart';
import '../design_system/palco/disposizione.dart';
import '../design_system/pubblico.dart';
import '../design_system/tokens.dart';
import '../l10n/app_localizations.dart';
import 'comuni.dart';

/// I due dispositivi di riferimento (D-022, D-027).
const double _telefono = 360;
const double _tablet = 744;

/// Le altezze della stanza finta, dalla più alta: per far cedere il palco
/// senza ridimensionare la finestra. Dati di prova, non misure di design.
/// Scelte per il caso del testo 2,0 con otto persone: intestazione, indicatore,
/// pubblico e barra delle azioni (task 020) prendono circa 740 dp (nei test, con
/// il font di prova, più largo di quello vero: con quello vero il palco ha più
/// spazio), il palco resta con 322, 272, 222 e 172 dp e il diametro scende per
/// gradi senza mai sfiorare. Sotto i 910 il palco avrebbe meno dei 150 dp che
/// servono a otto presenze al minimo e uscirebbe sull'intestazione (`sfora`).
const List<double> _altezze = [1060, 1010, 960, 910];

/// I due testi del testo di sistema da provare (C6: oltre 2,0 non si scala).
const double _testoNormale = 1.0;
const double _testoGrande = BaScalaTokens.maxTesto;

const List<String> _nomi = [
  'Marta B.', 'Luca D.', 'Giulia T.', 'Anna V.', 'Sara P.', 'Elena C.', 'Dario N.', 'Fabio M.', //
];

const List<Locale> _lingue = [
  Locale('it'), Locale('en'), Locale('fr'), Locale('es'), Locale('de'), //
];

/// Quante persone ascoltano nella stanza finta: più di tre, quindi il pubblico
/// mostra il campione e il contatore.
const int _ascoltano = 12;

/// Quante persone possono parlare insieme nella prova: 0–3.
const int _parlanoMax = 3;

/// Gli stati con glifo che si possono dare alla prima persona (task 012).
const List<String> _statiPrimo = [
  'nessuno',
  'mutata',
  'mutata che parla',
  'bloccata',
  'microfono spento',
  'microfono spento (io)',
  'ha la parola',
];

/// Quello che l'indicatore mostra: diametro, scatola del palco e sfora.
typedef _Misura = (double, Size, bool);

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
  int _primo = 0; // indice in _statiPrimo
  final ValueNotifier<_Misura?> _misura = ValueNotifier(null);

  @override
  void dispose() {
    _misura.dispose();
    super.dispose();
  }

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
          'Prima persona: ${_statiPrimo[_primo]}',
          _primo != 0,
          () => setState(() => _primo = (_primo + 1) % _statiPrimo.length),
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

  /// La prima persona porta lo stato scelto con «Prima persona»; le etichette si
  /// compongono con una sola chiave per stato (la combinazione la compone chi
  /// costruisce la riga di palco).
  List<BaPersonaPalco> _gente(AppLocalizations l) => [
        for (var i = 0; i < _persone; i++)
          _persona(l, i),
      ];

  BaPersonaPalco _persona(AppLocalizations l, int i) {
    final nome = _nomi[i];
    final primo = i == 0 ? _primo : 0;
    final etichetta = switch (primo) {
      1 || 2 => l.presenzaMutata(nome),
      3 => l.presenzaBloccata(nome),
      4 || 5 => l.presenzaMicSpento(nome),
      6 => l.presenzaHaLaParola(nome),
      _ => nome,
    };
    return BaPersonaPalco(
      id: 'p$i',
      indiceTinta: i,
      indiceSagoma: i % BaSagomaTokens.mazzo.length,
      iniziali: nome.substring(0, 1) + nome.split(' ').last.substring(0, 1),
      semanticsLabel: etichetta,
      semanticsLabelParla: primo == 0 ? l.presenzaParla(nome) : etichetta,
      parla: i < _parlano || primo == 2,
      ampiezza: 1,
      persa: _persa && i == 0,
      mutata: primo == 1 || primo == 2,
      bloccata: primo == 3,
      microfonoSpento: primo == 4 || primo == 5,
      io: primo == 5,
      haLaParola: primo == 6,
      onTap: () {},
    );
  }

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
            // L'indicatore sta nel flusso, sopra il palco, a altezza naturale e senza
            // scalare col testo: non può sovrapporsi alle presenze né falsare la
            // misura di quanto cede il palco.
            Padding(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.s, margine, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: MediaQuery(
                  data: base.copyWith(
                    size: Size(_larghezza, altezza),
                    textScaler: TextScaler.noScaling,
                  ),
                  child: ValueListenableBuilder<_Misura?>(
                    valueListenable: _misura,
                    builder: (context, m, _) => _indicatore(m),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: margine),
                child: _palco(l),
              ),
            ),
            // In fondo, ancorati: il pubblico e la barra delle azioni veri (task
            // 020). A testo grande crescono loro e il palco, sopra, cede.
            BaPubblico(
              conteggio: _ascoltano,
              testo: '$_ascoltano in ascolto',
              tinte: const [0, 1, 2],
              sagome: const [0, 1, 2],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.s, margine, BaSpazioTokens.l),
              child: _barra(),
            ),
          ],
        ),
      ),
    );
  }

  /// Le azioni della stanza finta: il microfono (attiva: «Spegni il microfono»
  /// non è un gesto senza cui l'app non prosegue), «Esci» e «Scendi dal palco»
  /// fra le prime tre, e una quarta in «Altro».
  Widget _barra() {
    return BaBarraAzioni(
      azioni: [
        BaAzioneBarra(
          ruolo: BaRuoloAzione.primaria,
          testo: 'Microfono',
          semanticsLabel: 'Spegni il microfono',
          fissa: true,
          onTap: () {},
        ),
        BaAzioneBarra(
          ruolo: BaRuoloAzione.secondaria,
          testo: 'Scendi dal palco',
          semanticsLabel: 'Scendi dal palco',
          fissa: true,
          onTap: () {},
        ),
        // L'ultima secondaria sta accanto a «Altro»: la breve, così se la riga
        // va in colonna (testo grande) la parola ci entra.
        BaAzioneBarra(
          ruolo: BaRuoloAzione.secondaria,
          testo: 'Esci',
          semanticsLabel: 'Esci',
          fissa: true,
          onTap: () {},
        ),
        BaAzioneBarra(
          ruolo: BaRuoloAzione.secondaria,
          testo: 'Invita',
          semanticsLabel: 'Invita',
          onTap: () {},
        ),
      ],
      onAltro: () {},
      semanticsLabelAltro: 'Altro',
    );
  }

  Widget _indicatore(_Misura? m) {
    if (m == null) return const SizedBox.shrink();
    final (diametro, scatola, sfora) = m;
    return Text(
      'd = ${diametro.toStringAsFixed(0)} dp · '
      'scatola ${scatola.width.toStringAsFixed(0)} × ${scatola.height.toStringAsFixed(0)} · '
      'sfora: ${sfora ? 'sì' : 'no'}',
      style: BaTestoTokens.nota.copyWith(
        color: sfora ? BaColorTokens.erroreTesto : BaColorTokens.testoTerzo,
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
        // L'indicatore sta fuori dal palco: si aggiorna dopo il frame, solo se cambia.
        final misura = (disposizione.diametro, scatola, disposizione.sfora);
        if (_misura.value != misura) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _misura.value = misura;
          });
        }
        return BaPalco(
          persone: _gente(l),
          larghezzaSchermo: _larghezza,
          stato: _stato,
          semanticsLabel: l.palcoEtichetta(n),
          invitoTitolo: l.palcoLibero,
          invitoTesto: l.palcoInvito,
        );
      },
    );
  }
}
