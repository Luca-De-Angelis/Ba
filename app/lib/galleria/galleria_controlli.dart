// La galleria dei controlli (task 020): BaPillola, BaAzioniInCoppia,
// BaBarraAzioni e BaPubblico. Strumento di sviluppo: testi fissi, niente l10n.
// Solo token per colori, misure e durate; 360 e 744 sono i dispositivi di
// riferimento (D-022, D-027), 1,0 e 2,0 i due testi di sistema da provare (C6).
import 'package:flutter/widgets.dart';

import '../design_system/azioni_in_coppia.dart';
import '../design_system/barra_azioni.dart';
import '../design_system/pillola.dart';
import '../design_system/pubblico.dart';
import '../design_system/tokens.dart';
import 'comuni.dart';

const double _telefono = 360;
const double _tablet = 744;
const double _testoNormale = 1.0;
const double _testoGrande = BaScalaTokens.maxTesto;

/// Le sei azioni di prova: «Esci» e «Scendi dal palco» e il microfono stanno
/// fra le prime tre (sono le fisse), le altre vanno in «Altro».
const List<String> _testiAzioni = [
  'Spegni il microfono',
  'Esci',
  'Scendi dal palco',
  'Invita',
  'Condividi',
  'Segnala',
];

class GalleriaControlli extends StatefulWidget {
  const GalleriaControlli({super.key});

  @override
  State<GalleriaControlli> createState() => _GalleriaControlliState();
}

class _GalleriaControlliState extends State<GalleriaControlli> {
  double _larghezza = _telefono;
  double _testo = _testoNormale;
  bool _riduciMovimento = false;
  int _azioni = 4;
  int _tocchi = 0;
  int _apertureAltro = 0;

  void _tocca() => setState(() => _tocchi++);

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
                    Text('Controlli', style: BaTestoTokens.stanza),
                    const SizedBox(height: BaSpazioTokens.s),
                    Text(
                      'Pillole, coppia, barra delle azioni e pubblico. Premuto: tocca. '
                      "Focus: tasto Tab. Strumento di sviluppo: non fa parte dell'app.",
                      style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
                    ),
                    const SizedBox(height: sezione),
                    _comandi(),
                    const SizedBox(height: sezione),
                    galleriaTitolo('Pillola · quattro varianti, a riposo e inattive'),
                    _pillole(),
                    const SizedBox(height: sezione),
                    galleriaTitolo('Pillola · etichetta lunga (a 2,0 cresce, non si taglia)'),
                    BaPillola(
                      testo: 'Scendi dal palco e torna in ascolto con tutti gli altri',
                      semanticsLabel: 'Scendi dal palco',
                      onTap: _tocca,
                    ),
                    const SizedBox(height: sezione),
                    galleriaTitolo('Azioni in coppia · due (stessa altezza) e una'),
                    BaAzioniInCoppia(
                      prima: BaAzioneCoppia(testo: 'Esci', semanticsLabel: 'Esci', onTap: _tocca),
                      seconda: BaAzioneCoppia(
                        testo: 'Scendi dal palco',
                        semanticsLabel: 'Scendi dal palco',
                        onTap: _tocca,
                      ),
                    ),
                    const SizedBox(height: BaSpazioTokens.l),
                    BaAzioniInCoppia(
                      prima: BaAzioneCoppia(testo: 'Esci', semanticsLabel: 'Esci', onTap: _tocca),
                    ),
                    const SizedBox(height: sezione),
                    galleriaTitolo('Barra delle azioni · $_azioni azioni (a 2,0 le secondarie vanno in colonna)'),
                    _barra(),
                    const SizedBox(height: sezione),
                    galleriaTitolo('Pubblico · 0, 1, 2, 3 e 14'),
                    for (final n in const [0, 1, 2, 3, 14]) ...[
                      Text('$n', style: BaTestoTokens.nota.copyWith(color: BaColorTokens.testoTerzo)),
                      BaPubblico(
                        conteggio: n,
                        testo: '$n in ascolto',
                        tinte: const [0, 1, 2],
                        sagome: const [0, 1, 2],
                      ),
                      const SizedBox(height: BaSpazioTokens.m),
                    ],
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
        galleriaInterruttore(
          'Azioni −',
          false,
          () => setState(() => _azioni = _azioni > 1 ? _azioni - 1 : 1),
        ),
        galleriaInterruttore(
          'Azioni +',
          false,
          () => setState(() => _azioni = _azioni < _testiAzioni.length ? _azioni + 1 : _azioni),
        ),
        galleriaInterruttore('Tocchi: $_tocchi · Altro: $_apertureAltro', true, () {}),
      ],
    );
  }

  Widget _pillole() {
    Widget riga(String nome, BaVariantePillola v) => Padding(
          padding: const EdgeInsets.only(bottom: BaSpazioTokens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(nome, style: BaTestoTokens.nota.copyWith(color: BaColorTokens.testoTerzo)),
              const SizedBox(height: BaSpazioTokens.s),
              BaPillola(
                testo: nome,
                semanticsLabel: nome,
                variante: v,
                onTap: v == BaVariantePillola.informativa ? null : _tocca,
              ),
              if (v != BaVariantePillola.informativa) ...[
                const SizedBox(height: BaSpazioTokens.s),
                BaPillola(testo: '$nome · inattiva', semanticsLabel: '$nome, inattiva', variante: v),
              ],
            ],
          ),
        );
    return Column(
      children: [
        riga('Informativa', BaVariantePillola.informativa),
        riga('Attiva', BaVariantePillola.attiva),
        riga('Chiara', BaVariantePillola.chiara),
        riga('Spenta', BaVariantePillola.spenta),
      ],
    );
  }

  Widget _barra() {
    return BaBarraAzioni(
      azioni: [
        for (var i = 0; i < _azioni; i++)
          BaAzioneBarra(
            ruolo: i == 0 ? BaRuoloAzione.primaria : BaRuoloAzione.secondaria,
            testo: _testiAzioni[i],
            semanticsLabel: _testiAzioni[i],
            fissa: i < 3,
            onTap: _tocca,
          ),
      ],
      onAltro: () => setState(() => _apertureAltro++),
      semanticsLabelAltro: 'Altro',
    );
  }
}
