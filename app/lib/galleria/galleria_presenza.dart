// La galleria di BaPresenza (task 010). Strumento di sviluppo: testi fissi,
// niente l10n. Mostra le presenze ai cinque diametri, le dodici tinte e le
// cinque sagome, con i controlli per ogni stato di questo task.
//
// Per vedere insieme la voce al massimo e il focus sulla stessa presenza, ai
// cinque diametri: «Parla», «Ampiezza 1», poi Tab fino a una presenza.
import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../design_system/presenza.dart';
import '../design_system/tokens.dart';
import 'comuni.dart';

enum _Immagine { nessuna, caricata, fallita }

/// Le tre ampiezze di prova del brief.
const List<double> _ampiezze = [0, 0.5, 1];

/// I cinque diametri del palco, dal più grande.
const List<double> _diametri = [
  BaPresenzaTokens.sola,
  BaPresenzaTokens.xl,
  BaPresenzaTokens.l,
  BaPresenzaTokens.m,
  BaPresenzaTokens.s,
];

const List<String> _iniziali = [
  'MB', 'LR', 'GT', 'AV', 'SP', 'EC', 'DN', 'FM', 'OZ', 'HK', 'IQ', 'UW', //
];

/// Lato dell'immagine sintetica di prova: dati di test, non di design.
const double _latoImmagine = 256;

class GalleriaPresenza extends StatefulWidget {
  const GalleriaPresenza({super.key});

  @override
  State<GalleriaPresenza> createState() => _GalleriaPresenzaState();
}

class _GalleriaPresenzaState extends State<GalleriaPresenza> {
  bool _parla = false;
  double _ampiezza = 1;
  int _voci = 1;
  bool _instabile = false;
  bool _persa = false;
  bool _scheletro = false;
  bool _riduciMovimento = false;
  bool _simula = false;
  _Immagine _immagine = _Immagine.nessuna;
  int _tocchi = 0;

  Timer? _timer;
  final math.Random _caso = math.Random(10);
  ImageProvider? _caricata;
  // Byte che non sono un'immagine: il caricamento fallisce.
  final ImageProvider _fallita = MemoryImage(Uint8List.fromList(const [0]));

  @override
  void initState() {
    super.initState();
    _creaImmagine().then((p) {
      if (mounted) setState(() => _caricata = p);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Un'immagine chiara e sintetica (nessun volto vero): è il caso peggiore per
  /// il tetto di luminanza, quindi mostra bene il velo.
  Future<ImageProvider> _creaImmagine() async {
    final registratore = ui.PictureRecorder();
    final tela = Canvas(registratore);
    const r = Rect.fromLTWH(0, 0, _latoImmagine, _latoImmagine);
    tela.drawRect(
      r,
      Paint()
        ..shader = ui.Gradient.linear(
          r.topLeft,
          r.bottomRight,
          [BaColorTokens.testoPrimo, BaColorTokens.testoSecondo],
        ),
    );
    tela.drawCircle(r.center, _latoImmagine / 4, Paint()..color = BaColorTokens.testoPrimo);
    final img = await registratore.endRecording().toImage(_latoImmagine.toInt(), _latoImmagine.toInt());
    final dati = await img.toByteData(format: ui.ImageByteFormat.png);
    return MemoryImage(dati!.buffer.asUint8List());
  }

  ImageProvider? get _immagineAttuale => switch (_immagine) {
        _Immagine.nessuna => null,
        _Immagine.caricata => _caricata,
        _Immagine.fallita => _fallita,
      };

  void _simulaVoce(bool acceso) {
    _timer?.cancel();
    _timer = null;
    if (acceso) {
      // Una ampiezza nuova a ogni campionamento, come farebbe l'SDK.
      _timer = Timer.periodic(BaMovimentoTokens.campionamentoAmpiezza, (_) {
        setState(() => _ampiezza = _caso.nextDouble());
      });
    }
    setState(() {
      _simula = acceso;
      if (acceso) _parla = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final base = MediaQuery.of(context);
    return ColoredBox(
      color: BaColorTokens.fondoApp,
      child: SingleChildScrollView(
        child: Center(
          child: MediaQuery(
            data: base.copyWith(disableAnimations: _riduciMovimento),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: BaLayoutTokens.margine(base.size.width),
                vertical: BaSpazioTokens.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BaPresenza', style: BaTestoTokens.stanza),
                  const SizedBox(height: BaSpazioTokens.s),
                  Text(
                    'Ferma, parla, persa, scheletro, premuta e a fuoco (tasto Tab). '
                    'Voce e focus insieme: Parla, Ampiezza 1, poi Tab. '
                    "Strumento di sviluppo: non fa parte dell'app.",
                    style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
                  ),
                  const SizedBox(height: BaSpazioTokens.xxl),
                  _controlli(),
                  const SizedBox(height: BaSpazioTokens.xxl),
                  galleriaTitolo('Cinque diametri · tocchi: $_tocchi'),
                  _cinqueDiametri(),
                  const SizedBox(height: BaSpazioTokens.xxl),
                  galleriaTitolo('Dodici tinte · 88'),
                  _dodiciTinte(),
                  const SizedBox(height: BaSpazioTokens.xxl),
                  galleriaTitolo('Cinque sagome · 112'),
                  _cinqueSagome(),
                ],
              ),
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
        galleriaInterruttore('Parla', _parla, () => setState(() => _parla = !_parla)),
        for (final a in _ampiezze)
          galleriaInterruttore(
            'Ampiezza ${a == a.truncateToDouble() ? a.toInt().toString() : a.toString().replaceAll('.', ',')}',
            !_simula && _ampiezza == a,
            () {
              _simulaVoce(false);
              setState(() => _ampiezza = a);
            },
          ),
        for (final n in [1, 2, 3])
          galleriaInterruttore('Voci $n', _voci == n, () => setState(() => _voci = n)),
        galleriaInterruttore(
          'Linea instabile',
          _instabile,
          () => setState(() => _instabile = !_instabile),
        ),
        galleriaInterruttore('Persa', _persa, () => setState(() => _persa = !_persa)),
        galleriaInterruttore(
          'Scheletro',
          _scheletro,
          () => setState(() => _scheletro = !_scheletro),
        ),
        galleriaInterruttore(
          'Immagine caricata',
          _immagine == _Immagine.caricata,
          () => setState(() => _immagine =
              _immagine == _Immagine.caricata ? _Immagine.nessuna : _Immagine.caricata),
        ),
        galleriaInterruttore(
          'Immagine fallita',
          _immagine == _Immagine.fallita,
          () => setState(() => _immagine =
              _immagine == _Immagine.fallita ? _Immagine.nessuna : _Immagine.fallita),
        ),
        galleriaInterruttore(
          'Riduci movimento',
          _riduciMovimento,
          () => setState(() => _riduciMovimento = !_riduciMovimento),
        ),
        galleriaInterruttore('Simula voce', _simula, () => _simulaVoce(!_simula)),
      ],
    );
  }

  // ------------------------------------------------------------- presenze

  Widget _presenza(double d, int tinta, int sagoma, String iniziali) {
    return BaDiametro(
      diametro: d,
      child: BaPresenza(
        semanticsLabel: 'Presenza $iniziali',
        semanticsLabelParla: 'Presenza $iniziali, sta parlando',
        indiceTinta: tinta,
        indiceSagoma: sagoma,
        iniziali: iniziali,
        immagine: _immagineAttuale,
        parla: _parla,
        ampiezza: _ampiezza,
        voci: _voci,
        lineaInstabile: _instabile,
        persa: _persa,
        scheletro: _scheletro,
        onTap: () => setState(() => _tocchi++),
      ),
    );
  }

  Widget _etichettata(String etichetta, Widget presenza) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        presenza,
        Text(etichetta, style: BaTestoTokens.nota.copyWith(color: BaColorTokens.testoTerzo)),
      ],
    );
  }

  Widget _cinqueDiametri() {
    return Wrap(
      spacing: BaSpazioTokens.xl,
      runSpacing: BaSpazioTokens.xl,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        for (var i = 0; i < _diametri.length; i++)
          _etichettata(
            _diametri[i].toInt().toString(),
            _presenza(_diametri[i], i, i, _iniziali[i]),
          ),
      ],
    );
  }

  Widget _dodiciTinte() {
    return Wrap(
      spacing: BaSpazioTokens.l,
      runSpacing: BaSpazioTokens.l,
      children: [
        for (var i = 0; i < BaTintaTokens.mazzo.length; i++)
          _presenza(BaPresenzaTokens.s, i, 0, _iniziali[i]),
      ],
    );
  }

  Widget _cinqueSagome() {
    return Wrap(
      spacing: BaSpazioTokens.xl,
      runSpacing: BaSpazioTokens.xl,
      children: [
        for (var i = 0; i < BaSagomaTokens.mazzo.length; i++)
          _presenza(BaPresenzaTokens.m, 0, i, _iniziali[i]),
      ],
    );
  }
}
