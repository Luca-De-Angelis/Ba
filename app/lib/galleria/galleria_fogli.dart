// La galleria dei fogli e dei messaggi (task 021): BaFoglio, BaSchedaPersona e
// BaMessaggio. Strumento di sviluppo: testi fissi, niente l10n. Solo token per
// colori, misure e durate; 360 e 744 sono i dispositivi di riferimento (D-022,
// D-027), 1,0 e 2,0 i due testi di sistema da provare (C6).
//
// La «schermata» è una scatola con un Navigator interno (GalleriaNavigator): i
// fogli la coprono, come su un telefono, e leggono la sua larghezza, il suo
// testo e il suo «riduci movimento».
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/messaggio.dart';
import '../design_system/scheda_persona.dart';
import '../design_system/tokens.dart';
import 'comuni.dart';
import 'galleria_navigator.dart';

const double _telefono = 360;
const double _tablet = 744;
const double _testoNormale = 1.0;
const double _testoGrande = BaScalaTokens.maxTesto;

/// L'altezza della schermata finta: un telefono alto.
const double _altezzaSchermata = 760;

const String _lungo =
    'Questo è un paragrafo lungo, scritto solo per riempire il foglio: serve a '
    'vedere che ciò che sta sopra le azioni scorre e che le azioni restano in basso, '
    'sempre allo stesso posto, anche quando il testo di sistema è al massimo.';

/// Il messaggio della schermata: ne esiste uno solo per volta.
enum _Messaggio { nessuno, neutro, errore }

class GalleriaFogli extends StatefulWidget {
  const GalleriaFogli({super.key});

  @override
  State<GalleriaFogli> createState() => _GalleriaFogliState();
}

class _GalleriaFogliState extends State<GalleriaFogli> {
  double _larghezza = _telefono;
  double _testo = _testoNormale;
  bool _riduciMovimento = false;
  _Messaggio _messaggio = _Messaggio.nessuno;

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
                Text('Fogli e messaggi', style: BaTestoTokens.stanza),
                const SizedBox(height: BaSpazioTokens.s),
                Text(
                  'Un pulsante per ogni foglio, nella schermata finta qui sotto: il foglio la copre. '
                  "Strumento di sviluppo: non fa parte dell'app.",
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
          'Messaggio: ${_messaggio.name}',
          _messaggio != _Messaggio.nessuno,
          () => setState(() => _messaggio = _Messaggio.values[(_messaggio.index + 1) % _Messaggio.values.length]),
        ),
      ],
    );
  }

  /// La schermata finta: i pulsanti che aprono i fogli e, se c'è, il messaggio.
  Widget _schermata(BuildContext contesto) {
    final margine = BaLayoutTokens.margine(_larghezza);
    return SingleChildScrollView(
      padding: EdgeInsets.all(margine),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          galleriaTitolo('Richiesta'),
          _pulsanti([
            ('Corta', () => _richiesta(contesto, lunga: false)),
            ('Lunga', () => _richiesta(contesto, lunga: true)),
          ]),
          const SizedBox(height: BaSpazioTokens.l),
          galleriaTitolo('Invito'),
          _pulsanti([
            ('Corto', () => _invito(contesto, lungo: false)),
            ('Lungo', () => _invito(contesto, lungo: true)),
          ]),
          const SizedBox(height: BaSpazioTokens.l),
          galleriaTitolo('Scheda presenza'),
          _pulsanti([
            ('Senza azioni nuove', () => _scheda(contesto, parla: true, nuove: 0)),
            ('Con azioni nuove', () => _scheda(contesto, parla: true, nuove: 2)),
            ('Con molte azioni', () => _scheda(contesto, parla: true, nuove: 12)),
            ('Non parla', () => _scheda(contesto, parla: false, nuove: 1)),
          ]),
          if (_messaggio != _Messaggio.nessuno) ...[
            const SizedBox(height: BaSpazioTokens.xxl),
            BaMessaggio(
              variante: _messaggio == _Messaggio.errore
                  ? BaVarianteMessaggio.errore
                  : BaVarianteMessaggio.neutro,
              testo: _messaggio == _Messaggio.errore
                  ? 'Il codice non è corretto. Controlla le sei cifre e riprova.'
                  : 'Ti scriviamo un codice di sei cifre: ci vuole un momento.',
            ),
          ],
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

  void _richiesta(BuildContext contesto, {required bool lunga}) {
    showBaFoglio<void>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (foglio) => BaFoglio.richiesta(
        titolo: 'Vuoi salire sul palco?',
        sottotitolo: 'Un solo gesto',
        paragrafi: [
          'Per parlare serve che tu acceda con il microfono acceso.',
          if (lunga) for (var i = 0; i < 6; i++) _lungo,
        ],
        azioni: [
          BaAzioneFoglio(
            testo: 'Sali sul palco',
            semanticsLabel: 'Sali sul palco',
            onTap: () => Navigator.of(foglio).pop(),
          ),
          BaAzioneFoglio(testo: 'Non ora', semanticsLabel: 'Non ora', onTap: () => Navigator.of(foglio).pop()),
        ],
      ),
    );
  }

  void _invito(BuildContext contesto, {required bool lungo}) {
    showBaFoglio<void>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (foglio) => BaFoglio.invito(
        titolo: 'Ti hanno invitato',
        paragrafi: [
          'Marta ti invita nel DEN «Serata sul balcone».',
          if (lungo) for (var i = 0; i < 6; i++) _lungo,
        ],
        azioni: [
          BaAzioneFoglio(testo: 'Entra', semanticsLabel: 'Entra', onTap: () => Navigator.of(foglio).pop()),
          BaAzioneFoglio(testo: 'No, grazie', semanticsLabel: 'No, grazie', onTap: () => Navigator.of(foglio).pop()),
        ],
      ),
    );
  }

  void _scheda(BuildContext contesto, {required bool parla, required int nuove}) {
    showBaFoglio<void>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (foglio) => BaFoglio.scheda(
        semanticsLabel: 'Marta B.',
        corpo: BaSchedaPersona(
          nome: 'Marta B.',
          stato: parla ? 'Parla' : 'Microfono spento',
          parla: parla,
          mutaTesto: 'Muta questa voce',
          mutaNonDisponibile: 'Si può mutare solo mentre parla',
          bloccaTesto: 'Blocca',
          segnalaTesto: 'Segnala',
          onMuta: () => Navigator.of(foglio).pop(),
          onBlocca: () => Navigator.of(foglio).pop(),
          onSegnala: () => Navigator.of(foglio).pop(),
          nuove: [
            for (var i = 1; i <= nuove; i++)
              BaAzioneScheda(
                titolo: 'Azione nuova $i',
                spiegazione: i == 1 ? 'Una conseguenza, scritta sotto' : null,
                onTap: () => Navigator.of(foglio).pop(),
              ),
          ],
        ),
        chiudi: BaAzioneFoglio(
          testo: 'Chiudi',
          semanticsLabel: 'Chiudi',
          onTap: () => Navigator.of(foglio).pop(),
        ),
      ),
    );
  }
}
