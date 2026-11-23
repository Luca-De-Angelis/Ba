// BaFoglioPassi: il foglio a più passi (task 023a, Inventario C4: «Sali sul
// palco», P1–P4 del prototipo 013, R1 e R2 del 014). È UN foglio solo che cresce
// passo per passo: stesso velo, stessa altezza massima (`foglioAltezzaTelefono`
// 0,80 o `foglioAltezzaTablet` 0,62), ciò che sta sopra scorre e le azioni
// restano ancorate in basso (T11). Si apre una volta con `showBaFoglio`; il
// chiamante gli passa un [BaPassoFoglio] e lo cambia quando vuole. **Il design
// system non sa quale passo viene dopo**: nessuna navigazione, nessuna logica di
// flusso, nessuna validazione, nessun timer. La macchina a stati è di chi lo usa.
//
// «Non ora» c'è in ogni passo, senza colpa e senza conseguenze: è un parametro
// obbligatorio ([nonOra]) e il foglio lo mette sempre in fondo, così nessun
// passo può dimenticarlo.
//
// Quando il passo cambia (cambia l'[BaPassoFoglio.id]):
// - il focus va al TITOLO del nuovo passo (anche tornando indietro): il campo
//   del passo prima, se aveva il focus, lo perde e la tastiera si chiude. Il
//   campo del nuovo passo NON prende il focus da solo: la tastiera si apre solo
//   se la persona lo tocca (una tastiera aperta coprirebbe il titolo);
// - il titolo è un'intestazione con regione viva dal secondo passo in poi, così
//   lo screen reader lo legge. Il primo passo no: all'apertura parla già il nome
//   del foglio (`namesRoute` di [BaFoglio]) e si direbbe due volte. Il foglio
//   resta lo stesso, quindi un nuovo `namesRoute` non basta. Senza uno screen
//   reader vero non so se focus e regione viva insieme leggano il titolo una
//   volta o due: da provare con TalkBack e VoiceOver (`docs/handoff/produzione.md`);
// - il corpo torna in alto.
//
// La crescita del foglio non è animata: T8 non prevede un movimento per il
// cambio di passo (proposta del task 023a), ed è già giusto con «riduci
// movimento».
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'campo_codice.dart';
import 'campo_testo.dart';
import 'foglio.dart';
import 'pillola.dart';
import 'tokens.dart';
import 'touchable.dart';

/// Un paragrafo di un passo: [evidenza] lo mette in primo piano (testo primo),
/// come i paragrafi che nel prototipo dicono la cosa che conta.
@immutable
class BaParagrafoPasso {
  const BaParagrafoPasso(this.testo, {this.evidenza = false});

  final String testo;
  final bool evidenza;
}

/// Un passo del foglio: titolo, corpo e azione primaria. Tutti i testi arrivano
/// dal chiamante. I costruttori con nome sono i passi di «diventa partecipante»
/// (P1–P4, R1, R2); il caso «numero già verificato» (P6) non esiste più (D-040).
@immutable
class BaPassoFoglio {
  const BaPassoFoglio({
    required this.id,
    required this.titolo,
    this.corpo = const [],
    this.azione,
    this.altreAzioni = const [],
  });

  /// Avviso (P1; R1 è lo stesso passo con un altro titolo): titolo, paragrafi e
  /// l'azione («Continua»).
  factory BaPassoFoglio.avviso({
    required Object id,
    required String titolo,
    required List<BaParagrafoPasso> paragrafi,
    required BaAzioneFoglio azione,
  }) =>
      BaPassoFoglio(id: id, titolo: titolo, corpo: [for (final p in paragrafi) _Paragrafo(p)], azione: azione);

  /// Numero (P2): un [BaCampoTesto] con il [prefisso] del telefono («+39»: lo dà
  /// il chiamante), la [nota] sotto il campo e l'azione («Ricevi il codice»).
  /// Non valida il numero: mostra l'[errore] che gli si dà.
  factory BaPassoFoglio.numero({
    required Object id,
    required String titolo,
    required TextEditingController controller,
    required String etichetta,
    required String prefisso,
    String? segnaposto,
    String? errore,
    String? nota,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    required BaAzioneFoglio azione,
  }) =>
      BaPassoFoglio(
        id: id,
        titolo: titolo,
        corpo: [
          BaCampoTesto(
            controller: controller,
            focusNode: focusNode,
            etichetta: etichetta,
            prefisso: prefisso,
            segnaposto: segnaposto,
            errore: errore,
            tastiera: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumberNational],
            onChanged: onChanged,
          ),
          if (nota != null) _Nota(nota),
        ],
        azione: azione,
      );

  /// Codice SMS (P3): la [frase] di invio («Mandato al +39 ••• ••• 0000.»), il
  /// [BaCampoCodice] nello [stato] che il chiamante gli dà (con la sua
  /// [fraseStato], obbligatoria per sbagliato, scaduto e attesa: durante
  /// l'attesa è una frase ferma, mai un conto alla rovescia) e l'azione testuale
  /// [mandaDiNuovo] (se è nullo la riga non c'è: nel codice scaduto l'azione che serve è quella primaria, «Manda un nuovo codice»). **Se [onMandaDiNuovo] è nullo l'azione è inattiva**
  /// (durante l'attesa del nuovo invio).
  factory BaPassoFoglio.codice({
    required Object id,
    required String titolo,
    required String frase,
    required String codiceSemanticsLabel,
    TextEditingController? controller,
    FocusNode? focusNode,
    BaStatoCodice stato = BaStatoCodice.scrittura,
    String? fraseStato,
    ValueChanged<String>? onCompleto,
    ValueChanged<String>? onChanged,
    String? mandaDiNuovo,
    VoidCallback? onMandaDiNuovo,
    required BaAzioneFoglio azione,
  }) =>
      BaPassoFoglio(
        id: id,
        titolo: titolo,
        corpo: [
          _Paragrafo(BaParagrafoPasso(frase)),
          BaCampoCodice(
            semanticsLabel: codiceSemanticsLabel,
            controller: controller,
            focusNode: focusNode,
            stato: stato,
            frase: fraseStato,
            onCompleto: onCompleto,
            onChanged: onChanged,
          ),
          if (mandaDiNuovo != null) _AzioneTestuale(testo: mandaDiNuovo, onTap: onMandaDiNuovo),
        ],
        azione: azione,
      );

  /// Consenso (P4, R2): i [paragrafi] e, solo se c'è, la riga [rigaSale]
  /// («Salirai a microfono spento»). In R2 (si crea un DEN) la riga non c'è e
  /// non lascia spazio. Il consenso è un'azione sola: «Acconsento e salgo» o
  /// «Acconsento e continuo».
  factory BaPassoFoglio.consenso({
    required Object id,
    required String titolo,
    required List<BaParagrafoPasso> paragrafi,
    String? rigaSale,
    required BaAzioneFoglio azione,
  }) =>
      BaPassoFoglio(
        id: id,
        titolo: titolo,
        corpo: [
          for (final p in paragrafi) _Paragrafo(p),
          if (rigaSale != null) _Paragrafo(BaParagrafoPasso(rigaSale, evidenza: true)),
        ],
        azione: azione,
      );

  /// Identifica il passo: se cambia, è un passo nuovo (focus e annuncio).
  final Object id;

  final String titolo;

  /// Ciò che sta sotto il titolo e scorre.
  final List<Widget> corpo;

  /// La primaria. Se la sua variante manca è chiara: nei passi di «diventa
  /// partecipante» è il gesto che nessuno può fare al posto della persona
  /// (`BaRegole` 1).
  final BaAzioneFoglio? azione;

  /// Azioni in più, spente, sopra «Non ora» (la galleria ci mette «Indietro»
  /// di prova).
  final List<BaAzioneFoglio> altreAzioni;
}

class BaFoglioPassi extends StatefulWidget {
  const BaFoglioPassi({
    super.key,
    required this.nome,
    required this.passo,
    required this.nonOra,
  });

  /// Il nome del foglio per lo screen reader («Diventa partecipante»), fisso per
  /// tutti i passi, dal chiamante.
  final String nome;

  final BaPassoFoglio passo;

  /// «Non ora»: in fondo a ogni passo, senza colpa e senza conseguenze.
  final BaAzioneFoglio nonOra;

  @override
  State<BaFoglioPassi> createState() => _BaFoglioPassiState();
}

class _BaFoglioPassiState extends State<BaFoglioPassi> {
  final ScrollController _scroll = ScrollController();

  /// Vero dal primo cambio di passo: da lì il titolo è una regione viva.
  bool _haCambiato = false;

  @override
  void didUpdateWidget(BaFoglioPassi vecchio) {
    super.didUpdateWidget(vecchio);
    if (vecchio.passo.id != widget.passo.id) {
      _haCambiato = true;
      if (_scroll.hasClients) _scroll.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Widget _pillola(BaAzioneFoglio a, BaVariantePillola predefinita) => BaPillola(
        testo: a.testo,
        semanticsLabel: a.semanticsLabel,
        onTap: a.onTap,
        variante: a.variante ?? predefinita,
        estensione: const EdgeInsets.symmetric(vertical: BaControlloTokens.areaEstesa),
      );

  @override
  Widget build(BuildContext context) {
    final passo = widget.passo;
    // Il corpo del foglio scorre con un controller nostro, così torna in alto a
    // ogni passo senza toccare BaFoglio (il suo SingleChildScrollView usa il
    // controller primario). Su tutte le piattaforme, non solo sul telefono.
    return PrimaryScrollController(
      controller: _scroll,
      automaticallyInheritForPlatforms: TargetPlatform.values.toSet(),
      child: BaFoglio(
        semanticsLabel: widget.nome,
        corpo: _Passo(
          key: ValueKey<Object>(passo.id),
          titolo: passo.titolo,
          corpo: passo.corpo,
          annuncia: _haCambiato,
        ),
        azioni: [
          if (passo.azione != null) _pillola(passo.azione!, BaVariantePillola.chiara),
          for (final a in passo.altreAzioni) _pillola(a, BaVariantePillola.spenta),
          _pillola(widget.nonOra, BaVariantePillola.spenta),
        ],
      ),
    );
  }
}

/// Un passo: il titolo (intestazione che prende il focus) e il corpo. Con la
/// chiave dell'id del passo nasce di nuovo a ogni cambio di passo, e al primo
/// fotogramma porta il focus sul titolo.
class _Passo extends StatefulWidget {
  const _Passo({super.key, required this.titolo, required this.corpo, required this.annuncia});

  final String titolo;
  final List<Widget> corpo;
  final bool annuncia;

  @override
  State<_Passo> createState() => _PassoState();
}

class _PassoState extends State<_Passo> {
  final FocusNode _titolo = FocusNode(debugLabel: 'titolo del passo');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _titolo.requestFocus();
    });
  }

  @override
  void dispose() {
    _titolo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          focusNode: _titolo,
          child: Semantics(
            header: true,
            liveRegion: widget.annuncia,
            label: widget.titolo,
            excludeSemantics: true,
            child: Text(widget.titolo, style: BaTestoTokens.foglio.copyWith(color: BaColorTokens.testoPrimo)),
          ),
        ),
        for (final w in widget.corpo) ...[
          const SizedBox(height: BaSpazioTokens.m),
          w,
        ],
      ],
    );
  }
}

class _Paragrafo extends StatelessWidget {
  const _Paragrafo(this.paragrafo);

  final BaParagrafoPasso paragrafo;

  @override
  Widget build(BuildContext context) => Text(
        paragrafo.testo,
        style: BaTestoTokens.corpo.copyWith(
          color: paragrafo.evidenza ? BaColorTokens.testoPrimo : BaColorTokens.testoSecondo,
        ),
      );
}

/// Una nota sotto un campo, in corpo minore.
class _Nota extends StatelessWidget {
  const _Nota(this.testo);

  final String testo;

  @override
  Widget build(BuildContext context) =>
      Text(testo, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo));
}

/// «Mandalo di nuovo»: un'azione testuale a 44 dp. Senza [onTap] è inattiva:
/// niente feedback, non si focalizza, e il testo è terzo.
class _AzioneTestuale extends StatelessWidget {
  const _AzioneTestuale({required this.testo, required this.onTap});

  final String testo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: BaTouchable(
        semanticsLabel: testo,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: BaControlloTokens.areaMinima),
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: 1,
            child: Text(
              testo,
              style: BaTestoTokens.azione.copyWith(
                color: onTap == null ? BaColorTokens.testoTerzo : BaColorTokens.testoSecondo,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
