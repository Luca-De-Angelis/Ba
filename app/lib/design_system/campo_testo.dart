// BaCampoTesto: il campo di testo di BA (task 022; i token sono
// `BaAccessoTokens.campoAltezza` e `campoLinea`, e `BaCreazioneTokens.descrizioneAltezza`).
// Email (A1), numero (P2), nome (A5), descrizione (C3, G5): una riga con **la
// linea sotto, non una scatola**; sopra l'etichetta in marcatore, sotto il testo
// di aiuto.
//
// Si costruisce con `EditableText` di widgets.dart. Il controller e il focus
// sono del chiamante (il focus, se manca, lo crea il componente); il tipo di
// tastiera (`TextInputType`), i suggerimenti di autocompilazione (`AutofillHints`)
// e `onChanged` arrivano dal chiamante.
//
// Stati: vuoto (con il segnaposto), a fuoco (la linea `azioneChiara`),
// compilato, errore (linea `erroreFiletto`, segno «!» e una frase: **mai il solo
// colore**, e annunciata).
//
// **Senza Material né Cupertino non ci sono il menù di selezione né le maniglie**
// (incolla da pressione lunga, taglia, seleziona tutto, e il posizionamento del
// cursore col dito): richiederebbero la toolbar di Material o di Cupertino. Si
// scrive, si incolla dalla tastiera del telefono e da tastiera fisica, e si
// cancella; il resto, in produzione, va aggiunto. Vedi `docs/handoff/produzione.md`.
//
// Valori che i token non hanno (segnalati nel report del task 022): lo stile del
// testo del campo, 20/400 nel prototipo — qui `BaTestoTokens.foglio` (20/600).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';

/// Il segno «!» e una frase: l'errore di un campo o del codice. Non è un
/// riquadro (a quello serve BaMessaggio): sono il segno e la frase, **annunciati**
/// allo screen reader quando compaiono o cambiano.
class BaFraseErrore extends StatelessWidget {
  const BaFraseErrore({super.key, required this.frase});

  /// La frase, già tradotta. Non dice di chi è la colpa.
  final String frase;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: frase,
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: BaColorTokens.erroreTesto,
                width: BaAccessoTokens.erroreSegnoTratto,
              ),
            ),
            child: SizedBox.square(
              dimension: BaAccessoTokens.erroreSegnoLato,
              child: Center(
                child: Text(
                  '!',
                  textScaler: TextScaler.noScaling,
                  style: BaTestoTokens.azione.copyWith(
                    color: BaColorTokens.erroreTesto,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: BaSpazioTokens.sm),
          Expanded(
            child: Text(frase, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.erroreTesto)),
          ),
        ],
      ),
    );
  }
}

class BaCampoTesto extends StatefulWidget {
  const BaCampoTesto({
    super.key,
    required this.controller,
    required this.etichetta,
    this.focusNode,
    this.aiuto,
    this.segnaposto,
    this.prefisso,
    this.errore,
    this.tastiera,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.minRighe = 1,
    this.maxRighe = 1,
    this.semanticsLabel,
  }) : assert(minRighe >= 1 && maxRighe >= minRighe);

  final TextEditingController controller;

  /// Se manca, lo crea e lo libera il componente.
  final FocusNode? focusNode;

  /// L'etichetta in marcatore sopra la linea («Email»).
  final String etichetta;

  /// Il testo di aiuto sotto la linea; sparisce quando c'è un errore.
  final String? aiuto;

  /// Il testo che si vede a campo vuoto.
  final String? segnaposto;

  /// Un testo fisso davanti al valore («+39»).
  final String? prefisso;

  /// L'errore: una frase. Nulla = nessun errore.
  final String? errore;

  /// Il tipo di tastiera (`TextInputType.emailAddress`, `.phone`…).
  final TextInputType? tastiera;

  /// I suggerimenti di autocompilazione (`AutofillHints.email`…).
  final Iterable<String>? autofillHints;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// La descrizione è a più righe: `minRighe` 3, `maxRighe` più alto. Con più
  /// righe il campo non scende sotto `descrizioneAltezza`.
  final int minRighe;
  final int maxRighe;

  /// Se manca: [etichetta].
  final String? semanticsLabel;

  @override
  State<BaCampoTesto> createState() => _BaCampoTestoState();
}

class _BaCampoTestoState extends State<BaCampoTesto> {
  FocusNode? _proprio;
  final GlobalKey<EditableTextState> _chiave = GlobalKey<EditableTextState>();

  FocusNode get _focus => widget.focusNode ?? (_proprio ??= FocusNode(debugLabel: 'BaCampoTesto'));

  bool get _multi => widget.maxRighe > 1;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_cambiato);
    widget.controller.addListener(_cambiato);
  }

  @override
  void didUpdateWidget(BaCampoTesto vecchio) {
    super.didUpdateWidget(vecchio);
    if (vecchio.focusNode != widget.focusNode) {
      (vecchio.focusNode ?? _proprio)?.removeListener(_cambiato);
      _focus.addListener(_cambiato);
    }
    if (vecchio.controller != widget.controller) {
      vecchio.controller.removeListener(_cambiato);
      widget.controller.addListener(_cambiato);
    }
  }

  @override
  void dispose() {
    (widget.focusNode ?? _proprio)?.removeListener(_cambiato);
    widget.controller.removeListener(_cambiato);
    _proprio?.dispose();
    super.dispose();
  }

  void _cambiato() {
    if (mounted) setState(() {});
  }

  /// Un tocco sul campo (la linea, il prefisso, il vuoto) dà il focus e apre la
  /// tastiera.
  void _tocca() {
    _focus.requestFocus();
    _chiave.currentState?.requestKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    final errore = widget.errore;
    final aFuoco = _focus.hasFocus;
    final vuoto = widget.controller.text.isEmpty;

    final Color linea = errore != null
        ? BaColorTokens.erroreFiletto
        : aFuoco
            ? BaColorTokens.azioneChiara
            : BaColorTokens.filettoMarcato;

    final stileTesto = BaTestoTokens.foglio.copyWith(color: BaColorTokens.testoPrimo);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // L'etichetta la legge il campo (`label` sotto): qui è solo visiva.
        ExcludeSemantics(
          child: Text(
            widget.etichetta.toUpperCase(),
            textScaler: TextScaler.linear(BaScalaTokens.marcatore(context)),
            style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo),
          ),
        ),
        const SizedBox(height: BaSpazioTokens.s),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _tocca,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: _multi ? BaCreazioneTokens.descrizioneAltezza : BaAccessoTokens.campoAltezza,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: linea, width: BaAccessoTokens.campoLinea)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: BaSpazioTokens.s),
                child: Row(
                  crossAxisAlignment: _multi ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [
                    if (widget.prefisso != null) ...[
                      ExcludeSemantics(
                        child: Text(
                          widget.prefisso!,
                          style: stileTesto.copyWith(color: BaColorTokens.testoSecondo),
                        ),
                      ),
                      const SizedBox(width: BaSpazioTokens.m),
                    ],
                    Expanded(
                      child: Stack(
                        alignment: _multi ? Alignment.topLeft : Alignment.centerLeft,
                        children: [
                          if (vuoto && widget.segnaposto != null)
                            ExcludeSemantics(
                              child: Text(
                                widget.segnaposto!,
                                style: stileTesto.copyWith(color: BaColorTokens.testoSpento),
                              ),
                            ),
                          Semantics(
                            label: widget.semanticsLabel ?? widget.etichetta,
                            child: EditableText(
                              key: _chiave,
                              controller: widget.controller,
                              focusNode: _focus,
                              style: stileTesto,
                              cursorColor: BaColorTokens.azioneChiara,
                              backgroundCursorColor: BaColorTokens.testoSpento,
                              selectionColor: BaColorTokens.azioneAttivaBordo,
                              keyboardType: widget.tastiera ?? (_multi ? TextInputType.multiline : TextInputType.text),
                              autofillHints: widget.autofillHints,
                              minLines: widget.minRighe,
                              maxLines: widget.maxRighe,
                              onChanged: widget.onChanged,
                              onSubmitted: widget.onSubmitted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (errore != null) ...[
          const SizedBox(height: BaSpazioTokens.s),
          BaFraseErrore(frase: errore),
        ] else if (widget.aiuto != null) ...[
          const SizedBox(height: BaSpazioTokens.s),
          Text(
            widget.aiuto!,
            style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoTerzo),
          ),
        ],
      ],
    );
  }
}
