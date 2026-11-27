// La galleria della scoperta (task 034, prototipo 031): la riga di un DEN con il motivo («Perché: tema
// Cucina») e con «zona abituale», le persone disponibili con «● Disponibile», il punto di aggancio
// della home, «Disponibile a chiacchierare» (la conferma e la riga di stato con «Spegni») e il foglio
// che chiede un permesso, per gli avvisi e per la posizione, con lo stato dopo il rifiuto.
// Strumento di sviluppo: testi fissi in italiano, presi dal prototipo, niente l10n (D-030). Solo token
// per colori, misure e durate; 360 e 744 sono i dispositivi di riferimento (D-022, D-027) e 1,0, 1,4 e
// 2,0 i testi di sistema da provare (il 1,4 è dove la barra e le righe cambiano, 036).
//
// Il design system non sa che cosa succede dopo e non ha logica: qui, e solo qui, i tocchi fanno da
// macchina a stati di prova («Invita» passa a «Nell'invito», «Accendi» accende la disponibilità e
// «Spegni» la spegne). Nessuna pagina intera e nessuna navigazione: sono il 024d.
//
// Nessuno stato di presenza, nessun luogo, nessun contatore: «Disponibile» è dichiarato da chi lo
// accende, e porta sempre la parola.
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/pillola.dart';
import '../design_system/punto_aggancio.dart';
import '../design_system/richiesta_permesso.dart';
import '../design_system/riga_den.dart';
import '../design_system/riga_impostazione.dart';
import '../design_system/riga_persona.dart';
import '../design_system/tokens.dart';
import 'comuni.dart';
import 'galleria_navigator.dart';

const double _telefono = 360;
const double _tablet = 744;
const double _testoNormale = 1.0;
const double _testoIntermedio = 1.4;
const double _testoGrande = BaScalaTokens.maxTesto;

/// L'altezza della schermata finta: un telefono alto.
const double _altezzaSchermata = 760;

typedef _Persona = ({String nome, String alias});

/// Le persone disponibili di prova, in ordine alfabetico (nessun conteggio).
const List<_Persona> _disponibili = [
  (nome: 'Davide', alias: '@davide.r'),
  (nome: 'Marta', alias: '@marta.v'),
  (nome: 'Sara', alias: '@sara.m'),
];

class GalleriaScoperta extends StatefulWidget {
  const GalleriaScoperta({super.key});

  @override
  State<GalleriaScoperta> createState() => _GalleriaScopertaState();
}

class _GalleriaScopertaState extends State<GalleriaScoperta> {
  double _larghezza = _telefono;
  double _testo = _testoNormale;
  bool _riduciMovimento = false;

  /// «Disponibile a chiacchierare»: spento di partenza.
  bool _disponibile = false;

  /// Chi è già nell'invito (le altre mostrano «Invita»).
  final Set<int> _invitate = {};

  String get _etichettaTesto => switch (_testo) {
        _testoNormale => '1,0',
        _testoIntermedio => '1,4',
        _ => '2,0',
      };

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
                Text('Scoperta', style: BaTestoTokens.stanza),
                const SizedBox(height: BaSpazioTokens.s),
                Text(
                  'Le righe e i fogli della scoperta, sulla schermata finta: un DEN con il motivo, le persone disponibili, il '
                  'punto di aggancio, «Disponibile a chiacchierare» e il permesso per gli avvisi e per la posizione. Nessuna '
                  'pagina intera. Nessuna persona è «online» né «in un DEN»: «Disponibile» è dichiarato, e ha sempre la parola. '
                  'Strumento di sviluppo: non fa parte dell\'app.',
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
          'Testo $_etichettaTesto',
          _testo != _testoNormale,
          () => setState(() => _testo = switch (_testo) {
                _testoNormale => _testoIntermedio,
                _testoIntermedio => _testoGrande,
                _ => _testoNormale,
              }),
        ),
        galleriaInterruttore(
          'Riduci movimento',
          _riduciMovimento,
          () => setState(() => _riduciMovimento = !_riduciMovimento),
        ),
      ],
    );
  }

  // ------------------------------------------------------------ la schermata

  Widget _schermata(BuildContext contesto) {
    final margine = BaLayoutTokens.margine(_larghezza);
    const gap = BaSpazioTokens.l;
    return SingleChildScrollView(
      padding: EdgeInsets.all(margine),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          galleriaTitolo('Proposti per te (H1)'),
          _etichetta('il motivo: tema'),
          const BaRigaDen(
            nome: 'Cucina di notte',
            marcatore: 'Entra chiunque · 5 sul palco',
            motivo: 'Perché: tema Cucina',
            presenze: 5,
            tinte: [0, 1, 2],
            sagome: [0, 1, 2],
          ),
          _etichetta('il motivo: lingua, e «zona abituale» nel marcatore'),
          const BaRigaDen(
            nome: 'Serata sul balcone',
            marcatore: 'zona abituale · entra chiunque · 3 sul palco',
            motivo: 'Perché: in italiano',
            presenze: 3,
            tinte: [3, 4, 5],
            sagome: [1, 2, 3],
          ),
          _etichetta('«vicino a te», con una frase'),
          const BaRigaDen(
            nome: 'Chiacchiere in cortile',
            marcatore: 'vicino a te · entra chiunque · 2 sul palco',
            frase: 'Marta sta parlando',
            motivo: 'Perché: tema Musica',
            presenze: 2,
            tinte: [6, 7],
            sagome: [4, 0],
          ),
          const SizedBox(height: gap),
          galleriaTitolo('Nessuna proposta (H3)'),
          _frase('Per ora non ci sono proposte. Scegli un tema o una lingua e ne compaiono.'),
          const SizedBox(height: gap),
          galleriaTitolo('Aperti ora (H1): la riga di sempre'),
          const BaRigaDen(
            nome: 'Famiglia',
            marcatore: 'Entra chiunque · 4 sul palco',
            presenze: 4,
            tinte: [1, 2, 3],
            sagome: [2, 3, 4],
          ),
          const SizedBox(height: gap),
          galleriaTitolo('Punti di aggancio (H5)'),
          _etichetta('un riquadro tratteggiato con il nome della sezione futura: non si tocca'),
          const BaPuntoAggancio(titolo: 'In evidenza ora', sottotitolo: 'G14'),
          const SizedBox(height: BaSpazioTokens.s),
          const BaPuntoAggancio(titolo: 'Avvisi per tema o lingua', sottotitolo: 'G07'),
          const SizedBox(height: BaSpazioTokens.s),
          const BaPuntoAggancio(titolo: 'DEN preferiti', sottotitolo: 'G13'),
          const SizedBox(height: gap),
          galleriaTitolo('Disponibile a chiacchierare (D1–D4)'),
          if (!_disponibile) ...[
            _etichetta('spento: un interruttore; accendere passa da una conferma'),
            BaRigaImpostazione.interruttore(
              titolo: 'Disponibile a chiacchierare',
              descrizione: 'Il tuo nickname e il tuo alias compaiono fra le persone che si possono invitare. Parte spento.',
              acceso: false,
              parolaAcceso: 'Acceso',
              parolaSpento: 'Spento',
              onCambia: (_) => _confermaDisponibile(contesto),
            ),
          ] else ...[
            _etichetta('acceso: la riga di stato, una frase e «Spegni»'),
            BaRigaImpostazione.stato(
              titolo: 'Sei disponibile a chiacchierare',
              frase: 'Compari fra le persone da invitare.',
              azione: 'Spegni',
              onAzione: () => setState(() => _disponibile = false),
            ),
          ],
          const SizedBox(height: BaSpazioTokens.s),
          _etichetta('con «Nessuno» in «Chi può trovarmi» (D5)'),
          _frase('Sei disponibile, ma con «Nessuno» non ti trova nessuno. Scegli «Chi conosco» o «Tutti» per ricevere inviti.', secondaria: true),
          const SizedBox(height: gap),
          galleriaTitolo('Persone disponibili (L1)'),
          _etichetta('in ordine alfabetico, senza conteggio; «● Disponibile» ha sempre la parola'),
          for (var i = 0; i < _disponibili.length; i++) _rigaDisponibile(i),
          const SizedBox(height: gap),
          galleriaTitolo('Il permesso (N1, N2, Z1, Z2)'),
          _pulsanti([
            ('Avvisi: la richiesta', () => _apri(contesto, (foglio) => _avvisi(foglio))),
            ('Avvisi: dopo il rifiuto', () => _apri(contesto, (foglio) => _avvisiDopo(foglio))),
            ('Posizione: la richiesta', () => _apri(contesto, (foglio) => _posizione(foglio))),
            ('Posizione: dopo il rifiuto', () => _apri(contesto, (foglio) => _posizioneDopo(foglio))),
          ]),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- i pezzi

  Widget _etichetta(String testo) => Padding(
        padding: const EdgeInsets.only(bottom: BaSpazioTokens.xs, top: BaSpazioTokens.s),
        child: Text(testo, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoTerzo)),
      );

  Widget _frase(String testo, {bool secondaria = false}) => Text(
        testo,
        style: BaTestoTokens.corpo.copyWith(color: secondaria ? BaColorTokens.testoSecondo : BaColorTokens.testoPrimo),
      );

  Widget _pulsanti(List<(String, VoidCallback)> voci) => Wrap(
        spacing: BaControlloTokens.gapCoppia,
        runSpacing: BaControlloTokens.gapCoppia,
        children: [for (final (testo, onTap) in voci) galleriaInterruttore(testo, false, onTap)],
      );

  /// Una persona disponibile: «Invita» passa a «Nell'invito».
  Widget _rigaDisponibile(int i) {
    final invitata = _invitate.contains(i);
    return BaRigaPersona(
      nome: _disponibili[i].nome,
      alias: _disponibili[i].alias,
      tinta: i,
      sagoma: i,
      disponibile: 'Disponibile',
      voce: invitata ? BaVoceRigaPersona.nellInvito : BaVoceRigaPersona.daAggiungere,
      azione: invitata ? 'Nell\'invito' : 'Invita',
      azioneSemanticsLabel: invitata ? 'Nell\'invito: ${_disponibili[i].nome}' : 'Invita ${_disponibili[i].nome}',
      onAzione: () => setState(() => invitata ? _invitate.remove(i) : _invitate.add(i)),
    );
  }

  void _apri(BuildContext contesto, WidgetBuilder builder) {
    showBaFoglio<void>(contesto, etichettaVelo: 'Chiudi', builder: builder);
  }

  BaAzioneFoglio _chiudi(BuildContext foglio, String testo) =>
      BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: () => Navigator.of(foglio).pop());

  // ------------------------------------------------ la disponibilità (D2)

  /// Accendere passa da una conferma, composta qui: il componente non la conosce. «Accendi» ha il
  /// filetto (`BaRegole` 1: si può non farlo).
  Future<void> _confermaDisponibile(BuildContext contesto) async {
    final accendi = await showBaFoglio<bool>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (foglio) => BaFoglio.richiesta(
        titolo: 'Essere disponibile a chiacchierare',
        paragrafi: const [
          'Mentre sei disponibile, il tuo nickname e il tuo alias compaiono fra le persone che si possono invitare.',
          'Ti trova solo chi può trovarti secondo «Chi può trovarmi»: la visibilità non si allarga da sola.',
        ],
        paragrafiMinori: const ['Si spegne con un tocco, e da solo quando entri in un DEN.'],
        azioni: [
          BaAzioneFoglio(testo: 'Accendi', semanticsLabel: 'Accendi', variante: BaVariantePillola.attiva, onTap: () => Navigator.of(foglio).pop(true)),
          BaAzioneFoglio(testo: 'Non ora', semanticsLabel: 'Non ora', onTap: () => Navigator.of(foglio).pop(false)),
        ],
      ),
    );
    if (accendi == true) setState(() => _disponibile = true);
  }

  // -------------------------------------------------- il permesso (N, Z)

  BaAzioneFoglio _azione(BuildContext foglio, String testo) => _chiudi(foglio, testo);

  Widget _avvisi(BuildContext foglio) => BaRichiestaPermesso(
        titolo: 'Avvisi sui DEN',
        frase: 'BA può avvisarti quando si apre un DEN su un tema o una lingua che scegli. Non avvisa mai per le persone.',
        fraseOpzionale: 'Puoi spegnerli quando vuoi.',
        consenti: _azione(foglio, 'Consenti gli avvisi'),
        nonOra: _azione(foglio, 'Non ora'),
      );

  Widget _avvisiDopo(BuildContext foglio) => BaRichiestaPermesso.dopoIlRifiuto(
        titolo: 'Avvisi spenti',
        frase: 'Va bene così. Gli avvisi sui DEN restano spenti.',
        fraseSeCambiIdea: 'Se cambi idea, li accendi dalle impostazioni del telefono.',
        apriImpostazioni: _azione(foglio, 'Apri le impostazioni del telefono'),
        chiudi: _azione(foglio, 'Chiudi'),
      );

  Widget _posizione(BuildContext foglio) => BaRichiestaPermesso(
        titolo: 'Usa la posizione',
        frase: 'Con la posizione, BA ti mostra i DEN vicini. Si usa solo mentre guardi l\'elenco.',
        fraseOpzionale: 'Nessuno la vede e non ci sono distanze da persone.',
        consenti: _azione(foglio, 'Usa la posizione'),
        nonOra: _azione(foglio, 'Non ora'),
      );

  Widget _posizioneDopo(BuildContext foglio) => BaRichiestaPermesso.dopoIlRifiuto(
        titolo: 'Posizione',
        frase: 'Uso la tua zona abituale: Milano nord. La posizione non è autorizzata.',
        apriImpostazioni: _azione(foglio, 'Apri le impostazioni del telefono'),
        chiudi: _azione(foglio, 'Chiudi'),
      );
}
