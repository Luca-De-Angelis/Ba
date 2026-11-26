// BaCampoCodice: il codice a sei caselle (Inventario C4), per l'email (A2) e per
// l'SMS (P3). Sei caselle disegnate, UN CAMPO SOLO per lo screen reader.
//
// **Struttura.** Un solo `EditableText` (testo e cursore trasparenti) sta sotto
// le sei caselle, che leggono il controller. C'è quindi **un solo elemento
// focalizzabile**, non sei: la tastiera, l'incolla e il suggerimento dell'SMS
// (`AutofillHints.oneTimeCode`) scrivono lì. Le caselle e l'`EditableText` sono
// esclusi dalla semantica; il nodo è uno: «campo di testo», con l'etichetta del
// chiamante («codice di sei cifre») e il valore letto **cifra per cifra**
// («4 8 1»). Tutto il blocco è toccabile: un tocco dà il focus e apre la
// tastiera.
//
// **Solo cifre, al massimo sei.** Il valore si ripulisce a ogni cambio: vale per
// la scrittura, per l'incolla («48a1-9» diventa «4819») e per il suggerimento
// dell'IME. Cancellare funziona. `onCompleto` parte **una volta** ogni volta che
// si arriva a sei cifre.
//
// **Stati** (`BaStatoCodice`):
//   scrittura  vuoto o in scrittura: la casella dove si scrive ha il bordo spesso
//              `azioneChiara` (solo con il focus: è anche l'indicatore di focus);
//   sbagliato  bordo `erroreFiletto` spesso su tutte e sei + BaFraseErrore
//              (segno «!» e frase, annunciata): mai il solo colore;
//   scaduto    caselle vuote e spente, campo in sola lettura + BaFraseErrore;
//   attesa     nuovo invio con attesa: caselle normali e **una frase ferma**
//              (senza segno, senza conto alla rovescia: `nuovoInvioAttesa` è solo
//              un valore). L'azione «Mandalo di nuovo» è del chiamante.
//
// **L'errore sta dentro il componente**, non in BaMessaggio: il prototipo ha il
// segno e la frase senza riquadro, e BaMessaggio è un riquadro con filetto.
//
// **Senza Material né Cupertino non ci sono il menù di selezione né le maniglie**
// (incolla da pressione lunga, taglia, seleziona tutto): in produzione vanno
// aggiunti (`docs/handoff/produzione.md`). L'incolla dalla tastiera e dal
// suggerimento dell'SMS funziona.
//
// Le cifre sono `BaTestoTokens.cifra` (22/400, task 032): non è il titolo della stanza.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'campo_testo.dart';
import 'tokens.dart';

enum BaStatoCodice { scrittura, sbagliato, scaduto, attesa }

/// Il campo vero sta sotto le caselle e non si vede: testo, cursore e selezione
/// trasparenti, e un corpo minimo. Non sono valori di design.
const Color _trasparente = Color(0x00000000);
const double _corpoNascosto = 1;

class BaCampoCodice extends StatefulWidget {
  const BaCampoCodice({
    super.key,
    required this.semanticsLabel,
    this.controller,
    this.focusNode,
    this.stato = BaStatoCodice.scrittura,
    this.frase,
    this.onCompleto,
    this.onChanged,
    this.autofillHints = const [AutofillHints.oneTimeCode],
  }) : assert(
          stato == BaStatoCodice.scrittura || frase != null,
          'sbagliato, scaduto e attesa vogliono la loro frase',
        );

  /// Il nome del campo per lo screen reader («Codice di sei cifre»), dal
  /// chiamante. Il valore lo legge il componente, cifra per cifra.
  final String semanticsLabel;

  /// Se manca, lo crea e lo libera il componente. Un controller del chiamante
  /// si ripulisce da solo (solo cifre, al massimo sei).
  final TextEditingController? controller;

  /// Se manca, lo crea e lo libera il componente.
  final FocusNode? focusNode;

  final BaStatoCodice stato;

  /// La frase sotto le caselle (errore per sbagliato e scaduto, attesa per
  /// attesa): già tradotta. In scrittura non si mostra.
  final String? frase;

  /// Chiamata con le sei cifre, una volta ogni volta che si arriva a sei.
  final ValueChanged<String>? onCompleto;

  /// Chiamata con le cifre (già ripulite) a ogni cambio.
  final ValueChanged<String>? onChanged;

  /// Di default il suggerimento del codice a uso singolo (l'SMS).
  final Iterable<String>? autofillHints;

  @override
  State<BaCampoCodice> createState() => _BaCampoCodiceState();
}

class _BaCampoCodiceState extends State<BaCampoCodice> {
  TextEditingController? _proprioController;
  FocusNode? _proprioFocus;
  final GlobalKey<EditableTextState> _chiave = GlobalKey<EditableTextState>();

  bool _ripulendo = false;
  String _ultimo = '';

  TextEditingController get _controller =>
      widget.controller ?? (_proprioController ??= TextEditingController());
  FocusNode get _focus => widget.focusNode ?? (_proprioFocus ??= FocusNode(debugLabel: 'BaCampoCodice'));

  static final RegExp _nonCifre = RegExp(r'\D');

  @override
  void initState() {
    super.initState();
    _ultimo = _cifre(_controller.text);
    _controller.addListener(_cambiato);
    _focus.addListener(_aggiorna);
  }

  @override
  void didUpdateWidget(BaCampoCodice vecchio) {
    super.didUpdateWidget(vecchio);
    if (vecchio.controller != widget.controller) {
      (vecchio.controller ?? _proprioController)?.removeListener(_cambiato);
      _controller.addListener(_cambiato);
    }
    if (vecchio.focusNode != widget.focusNode) {
      (vecchio.focusNode ?? _proprioFocus)?.removeListener(_aggiorna);
      _focus.addListener(_aggiorna);
    }
  }

  @override
  void dispose() {
    (widget.controller ?? _proprioController)?.removeListener(_cambiato);
    (widget.focusNode ?? _proprioFocus)?.removeListener(_aggiorna);
    _proprioController?.dispose();
    _proprioFocus?.dispose();
    super.dispose();
  }

  /// Solo cifre, al massimo sei.
  String _cifre(String testo) {
    final pulito = testo.replaceAll(_nonCifre, '');
    return pulito.length > BaAccessoTokens.codiceCaselle
        ? pulito.substring(0, BaAccessoTokens.codiceCaselle)
        : pulito;
  }

  void _cambiato() {
    if (_ripulendo) return;
    final grezzo = _controller.text;
    final pulito = _cifre(grezzo);
    if (pulito != grezzo) {
      // Ripulisco il valore (incolla sporco, cifre in più, suggerimenti).
      _ripulendo = true;
      _controller.value = TextEditingValue(
        text: pulito,
        selection: TextSelection.collapsed(offset: pulito.length),
      );
      _ripulendo = false;
    }
    if (pulito != _ultimo) {
      final eraCompleto = _ultimo.length == BaAccessoTokens.codiceCaselle;
      _ultimo = pulito;
      widget.onChanged?.call(pulito);
      if (pulito.length == BaAccessoTokens.codiceCaselle && !eraCompleto) {
        widget.onCompleto?.call(pulito);
      }
    }
    _aggiorna();
  }

  void _aggiorna() {
    if (mounted) setState(() {});
  }

  void _tocca() {
    if (widget.stato == BaStatoCodice.scaduto) return;
    _focus.requestFocus();
    _chiave.currentState?.requestKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    final scaduto = widget.stato == BaStatoCodice.scaduto;
    final sbagliato = widget.stato == BaStatoCodice.sbagliato;
    // Le caselle di un codice scaduto sono vuote e spente, qualunque sia il testo.
    final cifre = scaduto ? '' : _cifre(_controller.text);
    final attiva = (_focus.hasFocus && !scaduto && !sbagliato && cifre.length < BaAccessoTokens.codiceCaselle)
        ? cifre.length
        : -1;

    final caselle = Row(
      children: [
        for (var i = 0; i < BaAccessoTokens.codiceCaselle; i++) ...[
          if (i > 0) const SizedBox(width: BaAccessoTokens.codiceGap),
          Expanded(
            child: _Casella(
              cifra: i < cifre.length ? cifre[i] : '',
              bordo: sbagliato
                  ? BaColorTokens.erroreFiletto
                  : scaduto
                      ? BaColorTokens.filettoBase
                      : i == attiva
                          ? BaColorTokens.azioneChiara
                          : BaColorTokens.filettoMarcato,
              spesso: sbagliato || i == attiva,
            ),
          ),
        ],
      ],
    );

    final String? frase = widget.stato == BaStatoCodice.scrittura ? null : widget.frase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Un nodo solo per lo screen reader: il campo, con il valore cifra per
        // cifra. Le caselle e l'EditableText sono esclusi.
        Semantics(
          container: true,
          textField: true,
          label: widget.semanticsLabel,
          value: cifre.split('').join(' '),
          readOnly: scaduto,
          enabled: !scaduto,
          focusable: !scaduto,
          focused: _focus.hasFocus,
          onTap: scaduto ? null : _tocca,
          onSetText: scaduto ? null : (testo) => _controller.text = testo,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _tocca,
            child: ExcludeSemantics(
              child: Stack(
                children: [
                  caselle,
                  // L'unico campo vero: sotto le caselle, invisibile.
                  Positioned.fill(
                    child: IgnorePointer(
                      child: EditableText(
                        key: _chiave,
                        controller: _controller,
                        focusNode: _focus,
                        style: const TextStyle(color: _trasparente, fontSize: _corpoNascosto),
                        cursorColor: _trasparente,
                        backgroundCursorColor: _trasparente,
                        selectionColor: _trasparente,
                        showCursor: false,
                        enableInteractiveSelection: false,
                        readOnly: scaduto,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.number,
                        autofillHints: widget.autofillHints,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (frase != null) ...[
          const SizedBox(height: BaSpazioTokens.m),
          if (widget.stato == BaStatoCodice.attesa)
            // Una frase ferma: nessun segno, nessun conto alla rovescia.
            Text(frase, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoTerzo))
          else
            BaFraseErrore(frase: frase),
        ],
      ],
    );
  }
}

/// Una casella: la cifra (o un vuoto invisibile della stessa altezza) in un
/// riquadro con il bordo.
class _Casella extends StatelessWidget {
  const _Casella({required this.cifra, required this.bordo, required this.spesso});

  final String cifra;
  final Color bordo;
  final bool spesso;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: BaAccessoTokens.codiceAltezza),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BaAccessoTokens.codiceRaggio),
        border: Border.all(
          color: bordo,
          width: spesso ? BaAccessoTokens.codiceBordoAttivo : BaAccessoTokens.codiceBordo,
        ),
      ),
      // Il vuoto è uno spazio non separabile: la casella vuota è alta quanto
      // quella con la cifra, anche a testo grande.
      child: Text(
        cifra.isEmpty ? ' ' : cifra,
        style: BaTestoTokens.cifra.copyWith(color: BaColorTokens.testoPrimo),
      ),
    );
  }
}
