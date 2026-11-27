// BaFoglio: il contenitore di tutto ciò che si apre sopra la stanza (Inventario
// C3): il permesso, la scheda di una persona, l'invito, e in seguito i fogli a
// più passi. Un foglio sale dal basso su un velo, ha il raggio `foglio` in alto
// e `superficieFoglio` come fondo.
//
// Due pezzi: [BaFoglio] è il contenitore (un corpo che SCORRE e le azioni che
// restano ANCORATE in basso, T11) e [showBaFoglio] lo apre con una rotta di
// navigazione costruita con widgets.dart: niente Material né Cupertino.
//
// Altezza massima: la stessa per tutti i fogli, `foglioAltezzaTelefono` (0,80) o
// `foglioAltezzaTablet` (0,62) dello schermo, scelta sulla larghezza (D-027).
// È un tetto: un foglio breve non si alza. Sul tablet il foglio sta nella
// colonna centrale.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'pillola.dart';
import 'tokens.dart';

/// Le tre facce del foglio. Il contenitore è lo stesso: cambia ciò che ci si
/// mette e quale azione è in primo piano.
enum BaVarianteFoglio {
  /// Un permesso: titolo, testo, azioni. La primaria è chiara per default,
  /// perché è dove l'app non prosegue senza un gesto (`BaRegole` 1).
  richiesta,

  /// La scheda di una persona (BaSchedaPersona): il contenuto scorre, in basso
  /// l'azione per chiudere.
  scheda,

  /// Un invito: la struttura della richiesta, ma la primaria è attiva, perché
  /// un invito non blocca niente.
  invito,
}

/// Un'azione ancorata in basso nel foglio: una pillola a tutta larghezza.
@immutable
class BaAzioneFoglio {
  const BaAzioneFoglio({
    required this.testo,
    required this.semanticsLabel,
    this.onTap,
    this.variante,
  });

  final String testo;
  final String semanticsLabel;

  /// Nullo = inattiva.
  final VoidCallback? onTap;

  /// Se manca: la prima azione prende la variante della faccia del foglio
  /// (chiara per la richiesta, attiva per l'invito), le altre sono spente.
  final BaVariantePillola? variante;
}

class BaFoglio extends StatelessWidget {
  /// Il contenitore nudo: [corpo] scorre, [azioni] restano in basso. I contenuti
  /// dei fogli a più passi si compongono qui. [semanticsLabel] è il nome del
  /// foglio per lo screen reader (di solito il titolo), dal chiamante.
  const BaFoglio({
    super.key,
    required this.semanticsLabel,
    required this.corpo,
    this.azioni = const [],
  });

  /// Un permesso: [titolo], un sottotitolo opzionale in marcatore, i
  /// [paragrafi] e le [azioni]. La prima azione è chiara.
  BaFoglio.richiesta({
    Key? key,
    required String titolo,
    String? sottotitolo,
    List<String> paragrafi = const [],
    required List<BaAzioneFoglio> azioni,
  }) : this._faccia(
          key: key,
          variante: BaVarianteFoglio.richiesta,
          titolo: titolo,
          sottotitolo: sottotitolo,
          paragrafi: paragrafi,
          azioni: azioni,
        );

  /// Un invito: come la richiesta, ma la prima azione è attiva.
  BaFoglio.invito({
    Key? key,
    required String titolo,
    String? sottotitolo,
    List<String> paragrafi = const [],
    required List<BaAzioneFoglio> azioni,
  }) : this._faccia(
          key: key,
          variante: BaVarianteFoglio.invito,
          titolo: titolo,
          sottotitolo: sottotitolo,
          paragrafi: paragrafi,
          azioni: azioni,
        );

  /// La scheda di una persona: [corpo] è una BaSchedaPersona, [chiudi] l'azione
  /// in basso (spenta). [semanticsLabel] è il nome della persona.
  BaFoglio.scheda({
    Key? key,
    required String semanticsLabel,
    required Widget corpo,
    required BaAzioneFoglio chiudi,
  }) : this(
          key: key,
          semanticsLabel: semanticsLabel,
          corpo: corpo,
          azioni: [_pillolaDi(chiudi, BaVariantePillola.spenta)],
        );

  BaFoglio._faccia({
    Key? key,
    required BaVarianteFoglio variante,
    required String titolo,
    String? sottotitolo,
    required List<String> paragrafi,
    required List<BaAzioneFoglio> azioni,
  }) : this(
          key: key,
          semanticsLabel: titolo,
          corpo: _CorpoRichiesta(titolo: titolo, sottotitolo: sottotitolo, paragrafi: paragrafi),
          azioni: [
            for (var i = 0; i < azioni.length; i++)
              _pillolaDi(
                azioni[i],
                i == 0
                    ? (variante == BaVarianteFoglio.richiesta
                        ? BaVariantePillola.chiara
                        : BaVariantePillola.attiva)
                    : BaVariantePillola.spenta,
              ),
          ],
        );

  static Widget _pillolaDi(BaAzioneFoglio a, BaVariantePillola predefinita) => BaPillola(
        testo: a.testo,
        semanticsLabel: a.semanticsLabel,
        onTap: a.onTap,
        variante: a.variante ?? predefinita,
        estensione: const EdgeInsets.symmetric(vertical: BaControlloTokens.areaEstesa),
      );

  final String semanticsLabel;
  final Widget corpo;
  final List<Widget> azioni;

  /// L'altezza massima del foglio per uno schermo largo [larghezza] e alto
  /// [altezza]: 0,80 sul telefono, 0,62 dal tablet (da 600 dp, D-027).
  static double altezzaMassima(double larghezza, double altezza) =>
      altezza *
      (BaLayoutTokens.tablet(larghezza)
          ? BaAccessoTokens.foglioAltezzaTablet
          : BaAccessoTokens.foglioAltezzaTelefono);

  /// La larghezza del foglio: tutto lo schermo sul telefono, la colonna
  /// centrale (più i margini) sul tablet.
  static double larghezzaFoglio(double larghezza) {
    final colonna = BaLayoutTokens.larghezzaColonna(larghezza) + 2 * BaLayoutTokens.margine(larghezza);
    return colonna < larghezza ? colonna : larghezza;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final larghezza = media.size.width;
    final margine = BaLayoutTokens.margine(larghezza);
    // Il filetto del foglio non ha il lato in basso: il foglio scende di un
    // filetto sotto il bordo dello schermo e il lato resta fuori.
    final filetto = const BorderSide().width;

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: semanticsLabel,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Transform.translate(
          offset: Offset(0, filetto),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: larghezzaFoglio(larghezza),
              maxHeight: altezzaMassima(larghezza, media.size.height),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: BaColorTokens.superficieFoglio,
                border: Border.all(color: BaColorTokens.filettoDivisorio),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(BaRaggioTokens.foglio)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ciò che sta sopra le azioni scorre.
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.xxl, margine, BaSpazioTokens.s),
                      child: corpo,
                    ),
                  ),
                  // Le azioni restano ancorate in basso (T11).
                  if (azioni.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        margine,
                        BaSpazioTokens.m,
                        margine,
                        BaSpazioTokens.xxl + media.viewPadding.bottom - filetto,
                      ),
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
                    )
                  else
                    SizedBox(height: BaSpazioTokens.xxl + media.viewPadding.bottom - filetto),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Titolo, sottotitolo in marcatore e paragrafi di una richiesta o di un invito.
class _CorpoRichiesta extends StatelessWidget {
  const _CorpoRichiesta({required this.titolo, required this.sottotitolo, required this.paragrafi});

  final String titolo;
  final String? sottotitolo;
  final List<String> paragrafi;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titolo, style: BaTestoTokens.foglio.copyWith(color: BaColorTokens.testoPrimo)),
        if (sottotitolo != null) ...[
          const SizedBox(height: BaSpazioTokens.m),
          Text(
            sottotitolo!.toUpperCase(),
            textScaler: TextScaler.linear(BaScalaTokens.marcatore(context)),
            style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo),
          ),
        ],
        for (final p in paragrafi) ...[
          const SizedBox(height: BaSpazioTokens.m),
          Text(p, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoSecondo)),
        ],
      ],
    );
  }
}

class _RottaFoglio<T> extends PageRouteBuilder<T> {
  _RottaFoglio({
    required WidgetBuilder builder,
    required Duration durata,
    required String? etichettaVelo,
  }) : super(
          opaque: false,
          barrierDismissible: true,
          barrierColor: BaColorTokens.veloSipario,
          barrierLabel: etichettaVelo,
          transitionDuration: durata,
          reverseTransitionDuration: durata,
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: BaMovimentoTokens.curvaFoglio, reverseCurve: BaMovimentoTokens.curvaFoglio.flipped),
            ),
            child: child,
          ),
        );
}

/// Apre un foglio sopra [context]. Sale in 240 ms (`BaMovimentoTokens.foglio`),
/// subito con «riduci movimento». Si chiude toccando il velo, con il gesto
/// «indietro» del sistema o con `Navigator.pop` da un'azione. [etichettaVelo] è
/// l'etichetta del velo per lo screen reader («Chiudi»), dal chiamante.
///
/// Quando il foglio si chiude il focus torna dov'era. Il trascinamento verso
/// il basso non c'è (task 021): confligge con lo scorrimento del corpo e non ha
/// un equivalente per tastiera e screen reader.
Future<T?> showBaFoglio<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? etichettaVelo,
}) async {
  final precedente = FocusManager.instance.primaryFocus;
  final durata = BaMovimentoTokens.durata(context, BaMovimentoTokens.foglio);
  final risultato = await Navigator.of(context).push<T>(
    _RottaFoglio<T>(builder: builder, durata: durata, etichettaVelo: etichettaVelo),
  );
  if (precedente != null && precedente.context != null && precedente.canRequestFocus) {
    precedente.requestFocus();
  }
  return risultato;
}
