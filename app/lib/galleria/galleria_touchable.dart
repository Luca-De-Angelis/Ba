// La galleria di BaTouchable (task 009). Strumento di sviluppo: testi fissi,
// niente l10n. Solo token per colori, misure e durate; le due larghezze del
// selettore (360 e 744) sono i dispositivi di riferimento di D-022 e D-027.
import 'package:flutter/widgets.dart';

import '../design_system/tokens.dart';
import '../design_system/touchable.dart';

const double _telefono = 360;
const double _tablet = 744;

class GalleriaTouchable extends StatefulWidget {
  const GalleriaTouchable({super.key});

  @override
  State<GalleriaTouchable> createState() => _GalleriaTouchableState();
}

class _GalleriaTouchableState extends State<GalleriaTouchable> {
  bool _mostraAree = false;
  bool _riduciMovimento = false;
  double _larghezza = _telefono;
  final Map<String, int> _tocchi = {};

  void _tocca(String nome) =>
      setState(() => _tocchi[nome] = (_tocchi[nome] ?? 0) + 1);

  @override
  Widget build(BuildContext context) {
    final base = MediaQuery.of(context);
    final margine = BaLayoutTokens.margine(_larghezza);
    const sezione = BaSpazioTokens.xxl;

    return ColoredBox(
      color: BaColorTokens.fondoApp,
      child: SingleChildScrollView(
        child: Center(
          // La larghezza e "riduci movimento" passano da MediaQuery, come li
          // leggono i token di layout e BaTouchable.
          child: MediaQuery(
            data: base.copyWith(
              size: Size(_larghezza, base.size.height),
              disableAnimations: _riduciMovimento,
            ),
            child: SizedBox(
              width: _larghezza,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: margine, vertical: sezione),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BaTouchable', style: BaTestoTokens.stanza),
                    const SizedBox(height: BaSpazioTokens.s),
                    Text(
                      'Premuto, focus (tasto Tab) e area minima 44 × 44. '
                      "Strumento di sviluppo: non fa parte dell'app.",
                      style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
                    ),
                    const SizedBox(height: sezione),
                    _controlli(),
                    const SizedBox(height: sezione),
                    _titolo('Pillola grande · 56'),
                    _pillolaGrande(),
                    const SizedBox(height: sezione),
                    _titolo('Coppia · 48 · gap 10 · area estesa'),
                    _coppia(),
                    const SizedBox(height: sezione),
                    _titolo('Riga larga quanto lo schermo'),
                    _riga(),
                    const SizedBox(height: sezione),
                    _titolo('Inattiva'),
                    _inattiva(),
                    const SizedBox(height: sezione),
                    _titolo('Su presenza · keyline, senza scala'),
                    _suPresenza(),
                  ],
                ),
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
        _interruttore(
          'Mostra le aree toccabili',
          _mostraAree,
          () => setState(() => _mostraAree = !_mostraAree),
        ),
        _interruttore(
          'Riduci movimento',
          _riduciMovimento,
          () => setState(() => _riduciMovimento = !_riduciMovimento),
        ),
        _interruttore(
          'Larghezza ${_larghezza.toInt()}',
          _larghezza == _tablet,
          () => setState(() => _larghezza = _larghezza == _telefono ? _tablet : _telefono),
        ),
      ],
    );
  }

  Widget _interruttore(String testo, bool acceso, VoidCallback onTap) {
    return BaTouchable(
      semanticsLabel: testo,
      onTap: onTap,
      builder: (context, stato) => Container(
        constraints: const BoxConstraints(minHeight: BaControlloTokens.areaMinima),
        padding: const EdgeInsets.symmetric(horizontal: BaSpazioTokens.l),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BaRaggioTokens.pillola),
          border: Border.all(
            color: acceso ? BaColorTokens.azioneAttivaBordo : BaColorTokens.filettoBase,
          ),
          gradient: acceso
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: BaColorTokens.azioneAttivaFondo,
                )
              : null,
        ),
        child: Text(testo, style: BaTestoTokens.azione),
      ),
    );
  }

  // ------------------------------------------------------------ componenti

  Widget _pillolaGrande() {
    return _ConAree(
      mostra: _mostraAree,
      touchable: BaTouchable(
        semanticsLabel: 'Apri le impostazioni',
        onTap: () => _tocca('grande'),
        suChiara: true,
        builder: (context, stato) => Container(
          constraints: const BoxConstraints(minHeight: BaControlloTokens.primario),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BaRaggioTokens.pillola),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: BaColorTokens.azioneChiaraPiena,
            ),
          ),
          child: Text(
            'Apri le impostazioni',
            style: BaTestoTokens.controllo.copyWith(color: BaColorTokens.testoSuChiara),
          ),
        ),
      ),
      conteggio: _tocchi['grande'] ?? 0,
    );
  }

  Widget _coppia() {
    // L'area estesa sporge anche fuori dalla riga: il genitore deve contenerla,
    // altrimenti i tocchi fuori dai suoi confini si perdono. Mezzo gap verso la
    // vicina, areaEstesa sugli altri lati.
    const mezzoGap = BaControlloTokens.gapCoppia / 2;
    const fuori = BaControlloTokens.areaEstesa;
    return Padding(
      padding: const EdgeInsets.all(fuori),
      child: Row(
        children: [
          Expanded(
            child: _ConAree(
              mostra: _mostraAree,
              touchable: _hairline(
                'Esci',
                () => _tocca('esci'),
                const EdgeInsets.fromLTRB(fuori, fuori, mezzoGap, fuori),
              ),
              conteggio: _tocchi['esci'] ?? 0,
            ),
          ),
          const SizedBox(width: BaControlloTokens.gapCoppia),
          Expanded(
            child: _ConAree(
              mostra: _mostraAree,
              touchable: _hairline(
                'Scendi dal palco',
                () => _tocca('scendi'),
                const EdgeInsets.fromLTRB(mezzoGap, fuori, fuori, fuori),
              ),
              conteggio: _tocchi['scendi'] ?? 0,
            ),
          ),
        ],
      ),
    );
  }

  BaTouchable _hairline(String testo, VoidCallback onTap, EdgeInsets estensione) {
    return BaTouchable(
      semanticsLabel: testo,
      onTap: onTap,
      estensione: estensione,
      builder: (context, stato) => Container(
        constraints: const BoxConstraints(minHeight: BaControlloTokens.coppia),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BaRaggioTokens.pillola),
          border: Border.all(color: BaColorTokens.filettoBase),
        ),
        child: Text(
          testo,
          style: BaTestoTokens.azione.copyWith(color: BaColorTokens.testoSecondo),
        ),
      ),
    );
  }

  Widget _riga() {
    return _ConAree(
      mostra: _mostraAree,
      touchable: BaTouchable(
        semanticsLabel: 'Lingua, italiano',
        onTap: () => _tocca('riga'),
        raggio: BaRaggioTokens.riquadro,
        builder: (context, stato) => Container(
          constraints: const BoxConstraints(minHeight: BaControlloTokens.coppia),
          padding: const EdgeInsets.symmetric(horizontal: BaSpazioTokens.l),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BaRaggioTokens.riquadro),
            border: Border.all(color: BaColorTokens.filettoBase),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lingua', style: BaTestoTokens.corpo),
              Text(
                'ITALIANO',
                style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo),
              ),
            ],
          ),
        ),
      ),
      conteggio: _tocchi['riga'] ?? 0,
    );
  }

  Widget _inattiva() {
    return _ConAree(
      mostra: _mostraAree,
      touchable: BaTouchable(
        semanticsLabel: 'Azione non disponibile',
        builder: (context, stato) => Container(
          constraints: const BoxConstraints(minHeight: BaControlloTokens.coppia),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BaRaggioTokens.pillola),
            border: Border.all(color: BaColorTokens.filettoAppena),
          ),
          child: Text(
            "Non c'è posto sul palco",
            style: BaTestoTokens.azione.copyWith(color: BaColorTokens.testoInattivo),
          ),
        ),
      ),
      conteggio: 0,
    );
  }

  Widget _suPresenza() {
    const diametro = BaPresenzaTokens.s;
    return Align(
      alignment: Alignment.centerLeft,
      child: _ConAree(
        mostra: _mostraAree,
        touchable: BaTouchable(
          semanticsLabel: 'Marta B., presenza di prova',
          onTap: () => _tocca('presenza'),
          variante: BaVarianteTocco.suPresenza,
          builder: (context, stato) => Container(
            width: diametro,
            height: diametro,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: BaTintaTokens.mazzo.first.gradiente,
              // La keyline la disegna il contenuto: scura al premuto.
              border: Border.all(
                color: stato.premuto
                    ? BaColorTokens.premutoKeyline
                    : BaColorTokens.voceKeyline,
                width: BaPresenzaTokens.anelloKeyline,
              ),
            ),
            child: Text('MB', style: BaTestoTokens.iniziali(diametro)),
          ),
        ),
        conteggio: _tocchi['presenza'] ?? 0,
      ),
    );
  }

  Widget _titolo(String testo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: BaSpazioTokens.m),
      child: Text(
        testo.toUpperCase(),
        style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo),
      ),
    );
  }
}

/// Mostra, a richiesta, l'area toccabile vera di un [BaTouchable]: il suo
/// ingombro nel layout (che il widget porta ad almeno 44 × 44) allargato di
/// `estensione`, letta dal widget e non dal token. Sotto, il conteggio dei
/// tocchi. L'ingombro è quello dello Stack, cioè del BaTouchable stesso.
class _ConAree extends StatelessWidget {
  const _ConAree({
    required this.mostra,
    required this.touchable,
    required this.conteggio,
  });

  final bool mostra;
  final BaTouchable touchable;
  final int conteggio;

  @override
  Widget build(BuildContext context) {
    final e = touchable.estensione;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            touchable,
            if (mostra)
              Positioned(
                left: -e.left,
                top: -e.top,
                right: -e.right,
                bottom: -e.bottom,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: BaColorTokens.filettoAppena,
                      border: Border.all(color: BaColorTokens.azioneAttivaBordo),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (conteggio > 0)
          Padding(
            padding: const EdgeInsets.only(top: BaSpazioTokens.xs),
            child: Text(
              'TOCCHI: $conteggio',
              style: BaTestoTokens.nota.copyWith(color: BaColorTokens.testoTerzo),
            ),
          ),
      ],
    );
  }
}
