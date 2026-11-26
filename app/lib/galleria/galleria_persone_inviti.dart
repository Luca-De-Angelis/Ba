// La galleria delle persone e degli inviti (task 033): la ricerca, le righe di
// persona nei loro stati, il selettore (nessuno scelto, scelti, limite), il richiamo
// per persona con la sua conferma e «Hai un invito» (foglio, scaduto,
// annullato) del prototipo 030. Strumento di sviluppo: testi fissi in italiano,
// presi dal prototipo, niente l10n (D-030). Solo token per colori, misure e durate;
// 360 e 744 sono i dispositivi di riferimento (D-022, D-027), 1,0 e 2,0 i due testi
// di sistema da provare (C6).
//
// Il design system non sa che cosa succede dopo e non ha logica: qui, e solo qui, i
// tocchi fanno da macchina a stati di prova («Aggiungi» passa a «In lista», «Invita»
// a «Nell'invito», il richiamo si accende dopo la conferma). Il **posto riempito**:
// due pulsanti aprono `BaPassiCreazione.invitati(posto: …)` e
// `BaFoglioGestisci.coAmministratori(posto: …)` con `BaSelettorePersone`, senza
// cambiare le loro API.
//
// Nessuno stato «online», nessun luogo, nessun contatore: lo dice il principio del 030.
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/foglio_invito.dart';
import '../design_system/foglio_passi.dart';
import '../design_system/fogli_gestione.dart';
import '../design_system/passi_creazione.dart';
import '../design_system/pillola.dart';
import '../design_system/ricerca_persone.dart';
import '../design_system/riga_consenso.dart';
import '../design_system/riga_persona.dart';
import '../design_system/selettore_persone.dart';
import '../design_system/tokens.dart';
import 'comuni.dart';
import 'galleria_navigator.dart';

const double _telefono = 360;
const double _tablet = 744;
const double _testoNormale = 1.0;
const double _testoGrande = BaScalaTokens.maxTesto;

/// L'altezza della schermata finta: un telefono alto.
const double _altezzaSchermata = 760;

typedef _Persona = ({String nome, String alias});

const List<_Persona> _persone = [
  (nome: 'Marta', alias: '@marta.v'),
  (nome: 'Davide', alias: '@davide.r'),
  (nome: 'Luca', alias: '@luca.b'),
  (nome: 'Sara', alias: '@sara.m'),
  (nome: 'Sara', alias: '@sara.rossi'),
];

/// Una persona di prova per indice: tinta e sagoma stabili.
BaPersonaSelezionabile _selezionabile(int i, {bool scelta = false, VoidCallback? onTap}) => BaPersonaSelezionabile(
      nome: _persone[i].nome,
      alias: _persone[i].alias,
      tinta: i,
      sagoma: i,
      scelta: scelta,
      onTap: onTap,
      semanticsLabel: _persone[i].nome,
    );

class GalleriaPersoneInviti extends StatefulWidget {
  const GalleriaPersoneInviti({super.key});

  @override
  State<GalleriaPersoneInviti> createState() => _GalleriaPersoneInvitiState();
}

class _GalleriaPersoneInvitiState extends State<GalleriaPersoneInviti> {
  double _larghezza = _telefono;
  double _testo = _testoNormale;
  bool _riduciMovimento = false;

  // La ricerca: quattro campi veri, con i testi del prototipo.
  final TextEditingController _vuoto = TextEditingController();
  final TextEditingController _sar = TextEditingController(text: 'sar');
  final TextEditingController _niente = TextEditingController(text: 'xyzq');
  final TextEditingController _rete = TextEditingController(text: 'sar');
  final TextEditingController _cInvitati = TextEditingController();
  final TextEditingController _cCoAmministratore = TextEditingController();

  // Gli stati di prova.
  final Set<int> _aggiunte = {};
  final Set<int> _nellInvito = {1, 2};
  final Set<String> _richiamo = {'Luca'};

  @override
  void dispose() {
    _vuoto.dispose();
    _sar.dispose();
    _niente.dispose();
    _rete.dispose();
    _cInvitati.dispose();
    _cCoAmministratore.dispose();
    super.dispose();
  }

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
                Text('Persone e inviti', style: BaTestoTokens.stanza),
                const SizedBox(height: BaSpazioTokens.s),
                Text(
                  "La ricerca, le righe di persona, il selettore, il richiamo e «Hai un invito», sulla schermata finta. "
                  "«Aggiungi», «Invita» e il richiamo passano agli stati successivi solo qui. Nessuna persona è «online» o "
                  "«in un DEN»: il principio del 030. Strumento di sviluppo: non fa parte dell'app.",
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
          galleriaTitolo('Aggiungere persone: la ricerca (P1–P6)'),
          _etichetta('vuota: i suggeriti'),
          BaRicercaPersone(controller: _vuoto, etichetta: 'Cerca', segnaposto: 'Nickname, alias, email o numero'),
          for (final i in [0, 1, 2]) _rigaAggiungi(i),
          const SizedBox(height: gap),
          _etichetta('«sar»: due nickname uguali, l\'alias li distingue'),
          BaRicercaPersone(controller: _sar, etichetta: 'Cerca', segnaposto: 'Nickname, alias, email o numero'),
          for (final i in [3, 4]) _rigaAggiungi(i),
          _frase('Due persone si chiamano Sara: l\'alias le distingue.'),
          const SizedBox(height: gap),
          _etichetta('nessun risultato'),
          BaRicercaPersone(controller: _niente, etichetta: 'Cerca', segnaposto: 'Nickname, alias, email o numero'),
          const SizedBox(height: BaSpazioTokens.m),
          _frase('Nessuna persona trovata per «xyzq».'),
          const SizedBox(height: BaSpazioTokens.s),
          _frase('Se non ha BA, puoi invitarla con un link: entrerà ad ascoltare.', secondaria: true),
          const SizedBox(height: BaSpazioTokens.m),
          _pillola('Invita con un link', BaVariantePillola.attiva),
          const SizedBox(height: gap),
          _etichetta('errore di rete'),
          BaRicercaPersone(
            controller: _rete,
            etichetta: 'Cerca',
            segnaposto: 'Nickname, alias, email o numero',
            erroreRete: 'Non riusciamo a cercare adesso. Controlla la connessione e riprova.',
          ),
          const SizedBox(height: BaSpazioTokens.m),
          _pillola('Riprova', BaVariantePillola.chiara),
          const SizedBox(height: gap),
          galleriaTitolo('Le righe di persona nei loro stati'),
          _etichetta('da aggiungere · aggiunta · nell\'invito · scegli'),
          BaRigaPersona(nome: 'Marta', alias: '@marta.v', tinta: 0, sagoma: 0, voce: BaVoceRigaPersona.daAggiungere, azione: 'Aggiungi', onAzione: () {}),
          const BaRigaPersona(nome: 'Davide', alias: '@davide.r', tinta: 1, sagoma: 1, voce: BaVoceRigaPersona.aggiunta, azione: 'In lista'),
          BaRigaPersona(nome: 'Luca', alias: '@luca.b', tinta: 2, sagoma: 2, voce: BaVoceRigaPersona.nellInvito, azione: "Nell'invito", onAzione: () {}),
          BaRigaPersona(nome: 'Sara', alias: '@sara.m', tinta: 3, sagoma: 3, voce: BaVoceRigaPersona.scegli, azione: 'Scegli', onAzione: () {}),
          const SizedBox(height: gap),
          galleriaTitolo('Il selettore (C4, G2)'),
          _etichetta('nessuno scelto'),
          _selettoreInvitati(const {}),
          const SizedBox(height: gap),
          _etichetta('due scelti'),
          _selettoreInvitati(_nellInvito, interattivo: true),
          const SizedBox(height: gap),
          _etichetta('co-amministratore: limite raggiunto (uno)'),
          _selettoreCoAmministratore(const {1}),
          const SizedBox(height: gap),
          _etichetta('il posto riempito, nei fogli che lo accettano già'),
          _pulsanti([
            ('Invita: il posto riempito', () => _apri(contesto, (_) => const _FoglioInvitati())),
            ('Co-amministratore: il posto riempito', () => _apri(contesto, (_) => const _FoglioCoAmministratore())),
          ]),
          const SizedBox(height: gap),
          galleriaTitolo('Il richiamo (C1–C5)'),
          _etichetta('un consenso per persona: parte spento'),
          for (final (i, p) in [(0, _persone[0]), (1, _persone[1]), (2, _persone[2])])
            BaRigaConsenso(
              nome: p.nome,
              alias: p.alias,
              tinta: i,
              sagoma: i,
              acceso: _richiamo.contains(p.nome),
              parolaAcceso: 'Acceso',
              parolaSpento: 'Spento',
              onCambia: (v) => _cambiaRichiamo(contesto, p.nome, v),
            ),
          const SizedBox(height: gap),
          galleriaTitolo('Hai un invito (I2, I3)'),
          _pulsanti([
            ('Hai un invito', () => _apri(contesto, (foglio) => _valido(foglio))),
            ('Invito scaduto', () => _apri(contesto, (foglio) => _scaduto(foglio))),
            ('Invito annullato', () => _apri(contesto, (foglio) => _annullato(foglio))),
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

  Widget _pillola(String testo, BaVariantePillola variante) =>
      BaPillola(testo: testo, semanticsLabel: testo, variante: variante, onTap: () {});

  Widget _pulsanti(List<(String, VoidCallback)> voci) => Wrap(
        spacing: BaControlloTokens.gapCoppia,
        runSpacing: BaControlloTokens.gapCoppia,
        children: [for (final (testo, onTap) in voci) galleriaInterruttore(testo, false, onTap)],
      );

  /// Una riga con «Aggiungi»: al tocco passa a «In lista».
  Widget _rigaAggiungi(int i) {
    final aggiunta = _aggiunte.contains(i);
    return BaRigaPersona(
      nome: _persone[i].nome,
      alias: _persone[i].alias,
      tinta: i,
      sagoma: i,
      voce: aggiunta ? BaVoceRigaPersona.aggiunta : BaVoceRigaPersona.daAggiungere,
      azione: aggiunta ? 'In lista' : 'Aggiungi',
      azioneSemanticsLabel: aggiunta ? 'In lista: ${_persone[i].nome}' : 'Aggiungi ${_persone[i].nome}',
      onAzione: aggiunta ? null : () => setState(() => _aggiunte.add(i)),
    );
  }

  Widget _selettoreInvitati(Set<int> scelti, {bool interattivo = false}) {
    return BaSelettorePersone(
      ricerca: BaRicercaPersone(controller: _cInvitati, etichetta: 'Cerca', segnaposto: 'Nickname, alias, email o numero'),
      intestazione: 'Persone che hai aggiunto',
      persone: [
        for (final i in [0, 1, 2])
          _selezionabile(
            i,
            scelta: scelti.contains(i),
            onTap: interattivo ? () => setState(() => _nellInvito.contains(i) ? _nellInvito.remove(i) : _nellInvito.add(i)) : () {},
          ),
      ],
      parolaScegli: 'Invita',
      parolaScelta: "Nell'invito",
      frase: scelti.isEmpty ? "Nessuno nell'invito. Puoi invitare anche dopo." : '${scelti.length} persone nell\'invito.',
    );
  }

  Widget _selettoreCoAmministratore(Set<int> scelti) {
    return BaSelettorePersone(
      ricerca: BaRicercaPersone(controller: _cCoAmministratore, etichetta: 'Cerca', segnaposto: 'Nickname, alias, email o numero'),
      persone: [for (final i in [0, 1, 2]) _selezionabile(i, scelta: scelti.contains(i), onTap: () {})],
      parolaScegli: 'Scegli',
      parolaScelta: 'Scelto',
      limite: 1,
      frase: 'Puoi averne uno. Sceglilo fra le persone che hai aggiunto.',
      fraseLimite: 'Hai raggiunto il limite di co-amministratori. Per sceglierne un altro, togli Davide.',
    );
  }

  void _apri(BuildContext contesto, WidgetBuilder builder) {
    showBaFoglio<void>(contesto, etichettaVelo: 'Chiudi', builder: builder);
  }

  // ------------------------------------------------------------ il richiamo

  /// Spegnere è subito; accendere passa da una conferma (C4), che qui è un foglio
  /// composto dalla galleria: il componente non lo conosce.
  Future<void> _cambiaRichiamo(BuildContext contesto, String nome, bool voluto) async {
    if (!voluto) {
      setState(() => _richiamo.remove(nome));
      return;
    }
    final confermato = await showBaFoglio<bool>(
      contesto,
      etichettaVelo: 'Chiudi',
      builder: (foglio) => BaFoglio.richiesta(
        titolo: 'Avvisare $nome?',
        paragrafi: [
          '$nome riceve un avviso solo quando entri in un DEN pubblico. Non vede se sei online. Puoi toglierlo quando vuoi.',
        ],
        azioni: [
          BaAzioneFoglio(
            testo: 'Avvisa $nome',
            semanticsLabel: 'Avvisa $nome',
            variante: BaVariantePillola.attiva,
            onTap: () => Navigator.of(foglio).pop(true),
          ),
          BaAzioneFoglio(testo: 'Non ora', semanticsLabel: 'Non ora', onTap: () => Navigator.of(foglio).pop(false)),
        ],
      ),
    );
    if (confermato == true) setState(() => _richiamo.add(nome));
  }

  // ------------------------------------------------------- hai un invito

  BaAzioneFoglio _chiudi(BuildContext foglio, String testo) =>
      BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: () => Navigator.of(foglio).pop());

  Widget _valido(BuildContext foglio) => BaFoglioInvito.valido(
        titolo: 'Invito di Marta a Cena senza fretta',
        frase: 'Entri ad ascoltare.',
        entra: _chiudi(foglio, 'Entra'),
        nonOra: _chiudi(foglio, 'Non ora'),
      );

  Widget _scaduto(BuildContext foglio) => BaFoglioInvito.scaduto(
        titolo: 'Questo invito è scaduto',
        frase: 'Chiedi a Marta di invitarti di nuovo.',
        haCapito: _chiudi(foglio, 'Ho capito'),
      );

  Widget _annullato(BuildContext foglio) => BaFoglioInvito.annullato(
        titolo: 'Questo invito non è più valido',
        frase: 'Chi lo ha mandato lo ha annullato.',
        haCapito: _chiudi(foglio, 'Ho capito'),
      );
}

// ------------------------------------------------- il posto riempito (invitati)

/// «Invita» con il selettore al posto della riga tratteggiata: `BaPassiCreazione.invitati`.
class _FoglioInvitati extends StatefulWidget {
  const _FoglioInvitati();

  @override
  State<_FoglioInvitati> createState() => _FoglioInvitatiState();
}

class _FoglioInvitatiState extends State<_FoglioInvitati> {
  final TextEditingController _ricerca = TextEditingController();
  final Set<int> _scelti = {};

  @override
  void dispose() {
    _ricerca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selettore = BaSelettorePersone(
      ricerca: BaRicercaPersone(controller: _ricerca, etichetta: 'Cerca', segnaposto: 'Nickname, alias, email o numero', onRicerca: (_) => setState(() {})),
      intestazione: 'Persone che hai aggiunto',
      persone: [
        for (var i = 0; i < _persone.length; i++)
          if (BaRicercaPersone.corrisponde(_ricerca.text, nickname: _persone[i].nome, alias: _persone[i].alias))
            _selezionabile(i, scelta: _scelti.contains(i), onTap: () => setState(() => _scelti.contains(i) ? _scelti.remove(i) : _scelti.add(i))),
      ],
      parolaScegli: 'Invita',
      parolaScelta: "Nell'invito",
      frase: _scelti.isEmpty ? "Nessuno nell'invito. Puoi invitare anche dopo." : '${_scelti.length} persone nell\'invito.',
    );
    return BaFoglioPassi(
      nome: 'Crea un DEN',
      passo: BaPassiCreazione.invitati(
        titolo: 'Chi inviti?',
        frase: 'Un DEN privato si apre solo a chi inviti.',
        posto: selettore,
        // Si può procedere anche senza invitati (ipotesi del 030): l'azione è sempre attiva.
        azione: BaAzioneFoglio(testo: 'Continua', semanticsLabel: 'Continua', onTap: () => Navigator.of(context).pop()),
      ),
      nonOra: BaAzioneFoglio(testo: 'Non ora', semanticsLabel: 'Non ora', onTap: () => Navigator.of(context).pop()),
    );
  }
}

// --------------------------------------- il posto riempito (co-amministratore)

/// «Co-amministratori» con il selettore: `BaFoglioGestisci.coAmministratori`. L'azione
/// in fondo è inattiva finché non si sceglie: la lega al selettore chi lo usa.
class _FoglioCoAmministratore extends StatefulWidget {
  const _FoglioCoAmministratore();

  @override
  State<_FoglioCoAmministratore> createState() => _FoglioCoAmministratoreState();
}

class _FoglioCoAmministratoreState extends State<_FoglioCoAmministratore> {
  final TextEditingController _ricerca = TextEditingController();
  int? _scelto;

  @override
  void dispose() {
    _ricerca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selettore = BaSelettorePersone(
      ricerca: BaRicercaPersone(controller: _ricerca, etichetta: 'Cerca', segnaposto: 'Nickname, alias, email o numero', onRicerca: (_) => setState(() {})),
      persone: [
        for (var i = 0; i < 3; i++)
          if (BaRicercaPersone.corrisponde(_ricerca.text, nickname: _persone[i].nome, alias: _persone[i].alias))
            _selezionabile(i, scelta: _scelto == i, onTap: () => setState(() => _scelto = _scelto == i ? null : i)),
      ],
      parolaScegli: 'Scegli',
      parolaScelta: 'Scelto',
      limite: 1,
      frase: 'Puoi averne uno. Sceglilo fra le persone che hai aggiunto.',
      fraseLimite: 'Hai raggiunto il limite di co-amministratori. Per sceglierne un altro, togli ${_scelto == null ? '' : _persone[_scelto!].nome}.',
    );
    return BaFoglioGestisci.coAmministratori(
      nome: 'Gestisci il DEN',
      titolo: 'Co-amministratori',
      frase: 'Un co-amministratore gestisce il DEN con te.',
      posto: selettore,
      aggiungi: BaAzioneFoglio(
        testo: 'Aggiungi un co-amministratore',
        semanticsLabel: 'Aggiungi un co-amministratore',
        // Inattiva finché non si sceglie.
        onTap: selettore.haScelto ? () => Navigator.of(context).pop() : null,
      ),
      nonOra: BaAzioneFoglio(testo: 'Chiudi', semanticsLabel: 'Chiudi', onTap: () => Navigator.of(context).pop()),
    );
  }
}
