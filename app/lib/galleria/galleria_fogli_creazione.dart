// La galleria dei fogli di creazione e gestione (task 023b): «Crea un DEN»
// (C1–C5, S2), il sotto-DEN (D1) e «Gestisci» (G1–G5) del prototipo 014 aggiornato
// dal 027. Strumento di sviluppo: testi fissi in italiano, presi dal prototipo,
// niente l10n (D-030). Solo token per colori, misure e durate; 360 e 744 sono i
// dispositivi di riferimento (D-022, D-027), 1,0 e 2,0 i due testi di sistema da
// provare (C6).
//
// Il design system non sa quale passo o vista viene dopo, né valida niente: qui, e
// solo qui, «Continua», «Indietro (di prova)» e le azioni dei fogli fanno da
// macchina a stati, e le uniche «validazioni» sono «il nome non è vuoto» e il
// nome «già usato» che si prova con il controllo. I campi sono campi veri.
// «Crea il DEN» chiude il foglio: la stanza che si apre dopo è il task 024.
//
// Le scelte dei due controlli «Creazione» e «Nome» valgono dalla prossima
// apertura del foglio.
//
// La «schermata» è una scatola con un Navigator interno (GalleriaNavigator): i
// fogli la coprono, come su un telefono.
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/foglio_passi.dart';
import '../design_system/fogli_gestione.dart';
import '../design_system/passi_creazione.dart';
import '../design_system/punto_aggancio.dart';
import '../design_system/riga_persona.dart';
import '../design_system/riga_valore.dart';
import '../design_system/scelta_den.dart';
import '../design_system/tokens.dart';
import 'comuni.dart';
import 'galleria_navigator.dart';

const double _telefono = 360;
const double _tablet = 744;
const double _testoNormale = 1.0;
const double _testoGrande = BaScalaTokens.maxTesto;

/// L'altezza della schermata finta: un telefono alto.
const double _altezzaSchermata = 760;

const String _descrizioneIniziale = 'Due chiacchiere dopo cena, senza un argomento fisso.';

class GalleriaFogliCreazione extends StatefulWidget {
  const GalleriaFogliCreazione({super.key});

  @override
  State<GalleriaFogliCreazione> createState() => _GalleriaFogliCreazioneState();
}

class _GalleriaFogliCreazioneState extends State<GalleriaFogliCreazione> {
  double _larghezza = _telefono;
  double _testo = _testoNormale;
  bool _riduciMovimento = false;
  bool _creazioneRiesce = true;
  bool _nomeUsato = false;

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
                Text('Fogli di creazione e gestione', style: BaTestoTokens.stanza),
                const SizedBox(height: BaSpazioTokens.s),
                Text(
                  "Un pulsante per ogni contenuto: lo apre in un foglio sulla schermata finta. I passi si percorrono con "
                  "«Continua» e «Indietro (di prova)», che esistono solo qui; in «Gestisci» ogni vista si apre dalle sue "
                  "voci e «Chiudi» o «Non ora» tornano al menu (il design system non decide che cosa fanno). I controlli "
                  "«Creazione» e «Nome» valgono dalla prossima apertura. Strumento di sviluppo: non fa parte dell'app.",
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
          'Creazione: ${_creazioneRiesce ? 'riesce' : 'non riesce'}',
          !_creazioneRiesce,
          () => setState(() => _creazioneRiesce = !_creazioneRiesce),
        ),
        galleriaInterruttore(
          'Nome: ${_nomeUsato ? 'già usato' : 'libero'}',
          _nomeUsato,
          () => setState(() => _nomeUsato = !_nomeUsato),
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
          galleriaTitolo('Creare un DEN (014)'),
          _pulsanti([
            ('Crea un DEN', () => _apri(contesto, (_) => _CreaDen(riesce: _creazioneRiesce, nomeUsato: _nomeUsato))),
          ]),
          const SizedBox(height: BaSpazioTokens.l),
          galleriaTitolo('Sotto-DEN (014 · D1)'),
          _pulsanti([('Nuovo sotto-DEN', () => _apri(contesto, (_) => const _SottoDen()))]),
          const SizedBox(height: BaSpazioTokens.l),
          galleriaTitolo('Gestisci (014 · G1–G5)'),
          _pulsanti([
            ('Gestisci, con un posto libero', () => _apri(contesto, (_) => const _Gestisci(alLimite: false))),
            ('Gestisci, al limite', () => _apri(contesto, (_) => const _Gestisci(alLimite: true))),
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

  void _apri(BuildContext contesto, WidgetBuilder builder) {
    showBaFoglio<void>(contesto, etichettaVelo: 'Chiudi', builder: builder);
  }
}

/// Un'azione che chiude il foglio.
BaAzioneFoglio _chiudi(BuildContext foglio, String testo) =>
    BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: () => Navigator.of(foglio).pop());

BaAzioneFoglio _azione(String testo, VoidCallback? onTap) =>
    BaAzioneFoglio(testo: testo, semanticsLabel: testo, onTap: onTap);

// ------------------------------------------------------------------ Crea un DEN

enum _Passo { tipo, nome, dettagli, invitati, riepilogo, nonCreato }

const _temi = ['Chiacchiere', 'Musica', 'Libri', 'Cucina', 'Notte', 'Sport', 'Lavoro', 'Imparare'];
const _lingue = ['Italiano', 'Deutsch'];

/// «Crea un DEN»: C1 → C2 → C3 → [C4 solo il privato] → C5 e, se la creazione non
/// riesce, S2. «Continua» e «Indietro (di prova)» fanno da macchina a stati.
class _CreaDen extends StatefulWidget {
  const _CreaDen({required this.riesce, required this.nomeUsato});

  final bool riesce;
  final bool nomeUsato;

  @override
  State<_CreaDen> createState() => _CreaDenState();
}

class _CreaDenState extends State<_CreaDen> {
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _descrizione = TextEditingController();
  _Passo _passo = _Passo.tipo;
  int? _tipo = 0; // 0 privato, 1 pubblico
  int? _tema = 0;
  int? _lingua = 0;
  String? _erroreNome;
  bool _usatoMostrato = false;

  bool get _privato => _tipo == 0;

  List<_Passo> get _percorso => [
        _Passo.tipo,
        _Passo.nome,
        _Passo.dettagli,
        if (_privato) _Passo.invitati,
        _Passo.riepilogo,
      ];

  @override
  void dispose() {
    _nome.dispose();
    _descrizione.dispose();
    super.dispose();
  }

  void _avanti() {
    if (_passo == _Passo.nome) {
      // Le uniche «validazioni» della galleria: il nome non è vuoto e, se lo si
      // chiede con il controllo, è già usato (una volta: poi lo si cambia).
      if (_nome.text.trim().isEmpty) {
        setState(() => _erroreNome = 'Scrivi un nome per il DEN.');
        return;
      }
      if (widget.nomeUsato && !_usatoMostrato) {
        setState(() {
          _usatoMostrato = true;
          _erroreNome = "C'è già un DEN con questo nome. Cambialo o aggiungi una parola.";
        });
        return;
      }
    }
    final i = _percorso.indexOf(_passo);
    if (_passo == _Passo.riepilogo) {
      // «Crea il DEN»: riesce e si chiude (la stanza è il task 024), o non riesce (S2).
      if (widget.riesce) {
        Navigator.of(context).pop();
      } else {
        setState(() => _passo = _Passo.nonCreato);
      }
      return;
    }
    setState(() {
      _erroreNome = null;
      _passo = _percorso[i + 1];
    });
  }

  void _indietro() {
    setState(() {
      _erroreNome = null;
      if (_passo == _Passo.nonCreato) {
        // «Riprova» riporta al riepilogo: quello che era stato scritto resta.
        _passo = _Passo.riepilogo;
      } else {
        _passo = _percorso[_percorso.indexOf(_passo) - 1];
      }
    });
  }

  BaAzioneFoglio _continua(String testo) => _azione(testo, _avanti);

  BaPassoFoglio get _passoCorrente => switch (_passo) {
        _Passo.tipo => BaPassiCreazione.tipo(
            titolo: 'Che DEN vuoi creare?',
            opzioni: const [
              BaOpzioneScelta(titolo: 'Privato', descrizione: 'Entra chi inviti.'),
              BaOpzioneScelta(titolo: 'Pubblico', descrizione: "Entra chiunque. Si trova nell'elenco."),
            ],
            scelta: _tipo,
            onScelta: (i) => setState(() => _tipo = i),
            fraseSotto: 'Lo gestisci tu, con i co-amministratori che scegli.',
            azione: _continua('Continua'),
          ),
        _Passo.nome => BaPassiCreazione.nome(
            titolo: 'Come si chiama?',
            controller: _nome,
            etichetta: 'Nome del DEN',
            segnaposto: 'Cena senza fretta',
            errore: _erroreNome,
            onChanged: (_) {
              if (_erroreNome != null) setState(() => _erroreNome = null);
            },
            quando: const BaPuntoAggancio.quando(
              etichetta: 'Quando',
              titolo: 'Adesso',
              sottotitolo: 'Spento. Si accende più avanti, per chi crea DEN programmati.',
            ),
            azione: _continua('Continua'),
          ),
        _Passo.dettagli => BaPassiCreazione.dettagli(
            titolo: 'Descrizione, tema e lingua',
            descrizione: _descrizione,
            descrizioneEtichetta: 'Descrizione',
            descrizioneSegnaposto: _descrizioneIniziale,
            maxRighe: 6,
            temaEtichetta: 'Tema',
            temi: _temi,
            temaScelto: _tema,
            onTema: (i) => setState(() => _tema = i),
            linguaEtichetta: 'Lingua',
            lingue: _lingue,
            linguaScelta: _lingua,
            onLingua: (i) => setState(() => _lingua = i),
            azione: _continua('Continua'),
          ),
        _Passo.invitati => BaPassiCreazione.invitati(
            titolo: 'Chi inviti?',
            frase: 'Un DEN privato si apre solo a chi inviti.',
            // Il posto è un widget che il chiamante riempie: oggi un punto di
            // aggancio, domani l'elenco con la ricerca.
            posto: const BaPuntoAggancio(titolo: 'Qui: la fonte degli invitati', sottotitolo: 'punto di aggancio'),
            azione: _continua('Continua'),
          ),
        _Passo.riepilogo => BaPassiCreazione.riepilogo(
            titolo: 'Tutto pronto?',
            righe: [
              BaRigaValore(etichetta: 'Tipo', valore: _privato ? 'Privato' : 'Pubblico'),
              BaRigaValore(etichetta: 'Nome', valore: _nome.text.trim()),
              if (_tema != null) BaRigaValore(etichetta: 'Tema', valore: _temi[_tema!]),
              if (_lingua != null) BaRigaValore(etichetta: 'Lingua', valore: _lingue[_lingua!]),
              if (_privato) const BaRigaValore(etichetta: 'Invitati', valore: '—'),
            ],
            frase: 'Salirai a microfono spento.',
            azione: _continua('Crea il DEN'),
          ),
        _Passo.nonCreato => BaPassiCreazione.nonCreato(
            titolo: 'Il DEN non è stato creato',
            errore: 'Non siamo riusciti ad aprirlo. Controlla la connessione e riprova.',
            nota: 'Quello che hai scritto è ancora qui.',
            azione: _azione('Riprova', _indietro),
          ),
      };

  @override
  Widget build(BuildContext context) {
    var passo = _passoCorrente;
    if (_passo != _Passo.tipo && _passo != _Passo.nonCreato) {
      passo = passo.conAltreAzioni([_azione('Indietro (di prova)', _indietro)]);
    }
    return BaFoglioPassi(
      nome: 'Crea un DEN',
      passo: passo,
      nonOra: _chiudi(context, 'Non ora'),
    );
  }
}

// -------------------------------------------------------------------- sotto-DEN

class _SottoDen extends StatefulWidget {
  const _SottoDen();

  @override
  State<_SottoDen> createState() => _SottoDenState();
}

class _SottoDenState extends State<_SottoDen> {
  final TextEditingController _nome = TextEditingController();
  String? _errore;

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaFoglioSottoDen(
      titolo: 'Nuovo sotto-DEN',
      controller: _nome,
      etichetta: 'Nome del sotto-DEN',
      segnaposto: 'Tavolo 2',
      errore: _errore,
      onChanged: (_) {
        if (_errore != null) setState(() => _errore = null);
      },
      frase: 'Fino a 8 persone. Sente il DEN e parla al proprio gruppo.',
      nota: 'Chi ne fa parte lo scegli dopo, dalla stanza.',
      crea: _azione('Crea il sotto-DEN', () {
        if (_nome.text.trim().isEmpty) {
          setState(() => _errore = 'Scrivi un nome per il sotto-DEN.');
        } else {
          Navigator.of(context).pop();
        }
      }),
      nonOra: _chiudi(context, 'Non ora'),
    );
  }
}

// ---------------------------------------------------------------------- Gestisci

enum _Vista { menu, descrizione, coAmministratori, persone, rimuovi, termina }

/// Una persona del DEN di prova: il nome, lo stato e gli indici di tinta e sagoma.
typedef _Persona = ({String nome, String stato, int indice});

/// «Gestisci»: una sola struttura per i DEN privati e per i pubblici (D-043). Le
/// viste si aprono dalle voci del menu; «Chiudi» e «Non ora» tornano al menu, e dal
/// menu chiudono il foglio (scelta della galleria: il design system non la decide).
class _Gestisci extends StatefulWidget {
  const _Gestisci({required this.alLimite});

  /// Parte con un co-amministratore (il limite è 1) o con un posto libero.
  final bool alLimite;

  @override
  State<_Gestisci> createState() => _GestisciState();
}

class _GestisciState extends State<_Gestisci> {
  static const int _limite = 1;

  final TextEditingController _descrizione = TextEditingController(text: _descrizioneIniziale);
  _Vista _vista = _Vista.menu;
  // Chi è co-amministratore (il limite è 1): nessuno, o Davide.
  late String? _coAmm = widget.alLimite ? 'Davide' : null;
  final List<_Persona> _persone = [
    (nome: 'Marta', stato: 'sul palco', indice: 0),
    (nome: 'Davide', stato: 'nel pubblico', indice: 1),
    (nome: 'Sara', stato: 'nel pubblico', indice: 2),
    (nome: 'Luca', stato: 'nel pubblico', indice: 3),
  ];
  String? _daRimuovere;

  @override
  void dispose() {
    _descrizione.dispose();
    super.dispose();
  }

  void _vai(_Vista v) => setState(() => _vista = v);

  BaAzioneFoglio get _alMenu => _azione('Non ora', () => _vai(_Vista.menu));

  /// Chi è co-amministratore ha il suo ruolo al posto dello stato, e nessun «Rimuovi».
  String _stato(_Persona p) => p.nome == _coAmm ? 'co-amministratore' : p.stato;

  BaRigaPersona _riga(_Persona p, {required String azione, required VoidCallback? onAzione}) => BaRigaPersona(
        nome: p.nome,
        stato: _stato(p),
        tinta: p.indice,
        sagoma: p.indice,
        azione: onAzione == null ? null : azione,
        onAzione: onAzione,
        azioneSemanticsLabel: '$azione ${p.nome}',
      );

  @override
  Widget build(BuildContext context) {
    const nome = 'Gestisci il DEN';
    final n = _coAmm == null ? 0 : 1;
    return switch (_vista) {
      _Vista.menu => BaFoglioGestisci.menu(
          nome: nome,
          titolo: 'Gestisci il DEN',
          descrizione: BaRigaValore(
            etichetta: 'Descrizione',
            sottotitolo: _descrizione.text,
            onTap: () => _vai(_Vista.descrizione),
          ),
          coAmministratori: BaRigaValore(
            etichetta: 'Co-amministratori',
            sottotitolo: 'Chi ti aiuta a gestire il DEN',
            // Il limite, mai il livello: il numero lo dà il chiamante.
            valore: '$n di $_limite',
            onTap: () => _vai(_Vista.coAmministratori),
          ),
          persone: BaRigaValore(
            etichetta: 'Persone nel DEN',
            sottotitolo: 'Rimuovi chi non deve restare',
            onTap: () => _vai(_Vista.persone),
          ),
          termina: BaRigaValore(
            etichetta: 'Termina il DEN',
            sottotitolo: 'Tutte le persone escono dalla stanza.',
            onTap: () => _vai(_Vista.termina),
          ),
          nonOra: _chiudi(context, 'Chiudi'),
        ),
      _Vista.descrizione => BaFoglioGestisci.descrizione(
          nome: nome,
          titolo: 'Descrizione',
          controller: _descrizione,
          etichetta: 'Descrizione',
          maxRighe: 6,
          salva: _azione('Salva', () => _vai(_Vista.menu)),
          nonOra: _alMenu,
        ),
      _Vista.coAmministratori when _coAmm != null => BaFoglioGestisci.coAmministratoriAlLimite(
          nome: nome,
          titolo: 'Co-amministratori',
          persone: [
            _riga(_persone.firstWhere((p) => p.nome == _coAmm), azione: 'Togli', onAzione: () => setState(() => _coAmm = null)),
          ],
          fraseLimite: 'Hai raggiunto il limite di co-amministratori. Per aggiungerne un altro, togli $_coAmm.',
          aggiungi: 'Aggiungi un co-amministratore',
          nonOra: _azione('Chiudi', () => _vai(_Vista.menu)),
        ),
      _Vista.coAmministratori => BaFoglioGestisci.coAmministratori(
          nome: nome,
          titolo: 'Co-amministratori',
          frase: 'Un co-amministratore gestisce il DEN con te. Puoi averne uno.',
          // Come per gli invitati: un widget che il chiamante riempie.
          posto: const BaPuntoAggancio(titolo: 'Qui: le persone fra cui scegliere', sottotitolo: 'punto di aggancio'),
          // Di prova: promuove la prima persona, così si vede il limite.
          aggiungi: _azione(
            'Aggiungi un co-amministratore',
            _persone.isEmpty ? null : () => setState(() => _coAmm = _persone.first.nome),
          ),
          nonOra: _azione('Chiudi', () => _vai(_Vista.menu)),
        ),
      _Vista.persone => BaFoglioGestisci.persone(
          nome: nome,
          titolo: 'Persone nel DEN',
          persone: [
            for (final p in _persone)
              _riga(
                p,
                azione: 'Rimuovi',
                // Chi è co-amministratore non ha «Rimuovi»: prima si toglie il ruolo.
                onAzione: p.nome == _coAmm
                    ? null
                    : () => setState(() {
                          _daRimuovere = p.nome;
                          _vista = _Vista.rimuovi;
                        }),
              ),
          ],
          nonOra: _azione('Chiudi', () => _vai(_Vista.menu)),
        ),
      _Vista.rimuovi => BaFoglioGestisci.conferma(
          nome: nome,
          id: 'rimuovi-$_daRimuovere',
          titolo: 'Rimuovere $_daRimuovere?',
          frase: '$_daRimuovere esce dal DEN.',
          azione: _azione('Rimuovi', () {
            setState(() {
              _persone.removeWhere((p) => p.nome == _daRimuovere);
              _vista = _Vista.persone;
            });
          }),
          nonOra: _azione('Non ora', () => _vai(_Vista.persone)),
        ),
      _Vista.termina => BaFoglioGestisci.conferma(
          nome: nome,
          id: 'termina',
          titolo: 'Terminare il DEN?',
          frase: 'Tutte le persone escono dalla stanza.',
          azione: _chiudi(context, 'Termina il DEN'),
          nonOra: _alMenu,
        ),
    };
  }
}
