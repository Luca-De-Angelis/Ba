// L'ossatura di ogni pagina intera del prototipo (task 024): il nome per lo screen
// reader, il focus sul titolo al cambio di pagina e, per le pagine con un corpo, il
// layout «corpo che scorre, azioni ancorate in basso» (T11) con i margini e la
// colonna del layout. Solo token: nessun numero di design a mano.
//
// **Focus e annuncio al cambio di pagina** (come `BaFoglioPassi` al cambio di
// passo): quando la pagina compare, il suo titolo prende il focus ed è
// un'intestazione; la pagina ha un nome (`scopesRoute`, `namesRoute`). **Limite
// dichiarato:** senza TalkBack e VoiceOver veri non so se il nome della pagina e
// il titolo a fuoco, insieme, facciano leggere il titolo una volta o due. Va
// provato su dispositivo (vedi `docs/handoff/prototipo.md`).
import 'package:flutter/widgets.dart';

import '../design_system/tokens.dart';

/// Il guscio di una pagina: nome per lo screen reader e focus sul titolo. [figlio]
/// riceve il `FocusNode` da dare al titolo (con [TitoloPagina]).
class PaginaGuscio extends StatefulWidget {
  const PaginaGuscio({super.key, required this.nome, required this.figlio});

  final String nome;
  final Widget Function(BuildContext context, FocusNode titolo) figlio;

  @override
  State<PaginaGuscio> createState() => _PaginaGuscioState();
}

class _PaginaGuscioState extends State<PaginaGuscio> {
  final FocusNode _titolo = FocusNode(debugLabel: 'titolo della pagina');

  @override
  void initState() {
    super.initState();
    // Dopo il primo fotogramma il titolo prende il focus, e il framework lo
    // porta in vista.
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
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: widget.nome,
      child: ColoredBox(
        color: BaColorTokens.fondoApp,
        child: widget.figlio(context, _titolo),
      ),
    );
  }
}

/// Il titolo di una pagina: prende il focus quando la pagina compare. Un'intestazione
/// per lo screen reader.
class TitoloPagina extends StatelessWidget {
  const TitoloPagina({super.key, required this.focus, required this.testo});

  final FocusNode focus;
  final String testo;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focus,
      child: Semantics(
        header: true,
        label: testo,
        excludeSemantics: true,
        child: Text(
          testo,
          style: BaTestoTokens.stanza.copyWith(color: BaColorTokens.testoPrimo),
        ),
      ),
    );
  }
}

/// Una pagina con un titolo, un corpo che scorre e azioni ancorate in basso.
class PaginaProto extends StatelessWidget {
  const PaginaProto({
    super.key,
    required this.nome,
    this.titolo,
    this.intestazione,
    this.corpo = const [],
    this.azioni = const [],
  }) : assert(titolo != null || intestazione != null, 'la pagina ha un titolo o un titolo composto');

  /// Il nome della pagina per lo screen reader.
  final String nome;

  /// Il titolo di testo. In alternativa [intestazione] (per esempio `BaIntestazione`).
  final String? titolo;

  /// Un titolo già composto: prende il focus come il titolo di testo.
  final Widget? intestazione;


  /// Ciò che sta sotto il titolo e scorre.
  final List<Widget> corpo;

  /// Le azioni ancorate in basso: una sola chiara, dove il gesto è obbligato.
  final List<Widget> azioni;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final larghezza = media.size.width;
    final margine = BaLayoutTokens.margine(larghezza);
    final colonna = BaLayoutTokens.larghezzaColonna(larghezza);
    return PaginaGuscio(
      nome: nome,
      figlio: (context, titoloFocus) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.xxl, margine, BaSpazioTokens.s),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: colonna),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: intestazione != null
                            ? Focus(focusNode: titoloFocus, child: intestazione!)
                            : TitoloPagina(focus: titoloFocus, testo: titolo!),
                      ),
                      for (final w in corpo) ...[
                        const SizedBox(height: BaSpazioTokens.l),
                        w,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (azioni.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.m, margine, BaSpazioTokens.xxl),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: colonna),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < azioni.length; i++) ...[
                        if (i > 0) const SizedBox(height: BaControlloTokens.gapCoppia),
                        azioni[i],
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
