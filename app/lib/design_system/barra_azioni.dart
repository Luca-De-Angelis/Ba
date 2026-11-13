// BaBarraAzioni: la barra in fondo allo schermo (task 002, punto 12). Tre posti,
// sempre: uno primario e due secondari. Dalla quarta azione compare «Altro»
// (48 × 48), che chiama `onAltro`: il foglio con le azioni rimanenti non è
// qui (arriva con BaFoglio).
//
// Disposizione, come nel prototipo del 002: la primaria sopra, a tutta
// larghezza; sotto, in una riga, le due secondarie e, se c'è, «Altro» a destra.
// Con due azioni c'è una sola secondaria, centrata come in BaAzioniInCoppia; con
// una sola, c'è la primaria.
//
// Le azioni restano ancorate in basso (T11): la barra è una colonna della sua
// altezza, senza scorrimento. A testo grande crescono le pillole, non se ne
// perde nessuna; è chi la usa a far scorrere o cedere quello che sta sopra.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'pillola.dart';
import 'tokens.dart';
import 'touchable.dart';

enum BaRuoloAzione { primaria, secondaria }

/// Un'azione della barra. I testi arrivano dal chiamante (niente l10n qui).
@immutable
class BaAzioneBarra {
  const BaAzioneBarra({
    required this.ruolo,
    required this.testo,
    required this.semanticsLabel,
    this.onTap,
    this.fissa = false,
    this.variante,
  });

  final BaRuoloAzione ruolo;
  final String testo;
  final String semanticsLabel;
  final VoidCallback? onTap;

  /// «Esci», «Scendi dal palco» e il controllo del microfono: stanno sempre in
  /// uno dei tre posti, mai in «Altro».
  final bool fissa;

  /// Se manca: la primaria è `attiva`, le secondarie `spenta`. La `chiara` la
  /// sceglie chi chiama, e solo dove l'app non può proseguire senza quel gesto
  /// («Sali sul palco», «Accendi il microfono»; `BaRegole` 1). «Spegni il
  /// microfono» è `attiva`.
  final BaVariantePillola? variante;

  BaVariantePillola get varianteEffettiva =>
      variante ??
      (ruolo == BaRuoloAzione.primaria ? BaVariantePillola.attiva : BaVariantePillola.spenta);
}

class BaBarraAzioni extends StatelessWidget {
  /// In debug, un assert se: non c'è esattamente una primaria; la primaria o
  /// una azione fissa non sta fra le prime tre (finirebbe in «Altro»); c'è più
  /// di una pillola chiara. Chi chiama ordina le azioni.
  BaBarraAzioni({
    super.key,
    required this.azioni,
    this.onAltro,
    this.semanticsLabelAltro = '',
  }) : assert(_nessunErrore(azioni), _errore(azioni));

  final List<BaAzioneBarra> azioni;

  /// Quello che «Altro» fa: apre il foglio con `azioni.skip(3)`.
  final VoidCallback? onAltro;

  /// Etichetta di «Altro» per lo screen reader, dal chiamante.
  final String semanticsLabelAltro;

  /// Per trovare «Altro» nei test.
  static const Key chiaveAltro = ValueKey('barra-altro');

  static const double _mezzoGap = BaControlloTokens.gapCoppia / 2;

  static String? _problema(List<BaAzioneBarra> azioni) {
    final primarie = [
      for (var i = 0; i < azioni.length; i++)
        if (azioni[i].ruolo == BaRuoloAzione.primaria) i,
    ];
    if (primarie.length != 1) return 'la barra vuole una sola primaria, ne ha ${primarie.length}';
    if (primarie.single >= BaBarraAzioniTokens.posti) {
      return 'la primaria è in posizione ${primarie.single + 1}: finirebbe in «Altro»';
    }
    for (var i = BaBarraAzioniTokens.posti; i < azioni.length; i++) {
      if (azioni[i].fissa) return 'l\'azione fissa «${azioni[i].testo}» finirebbe in «Altro»';
    }
    final chiare = azioni.where((a) => a.variante == BaVariantePillola.chiara).length;
    if (chiare > 1) return 'la barra ha $chiare pillole chiare: BaRegole 1 ne ammette una';
    return null;
  }

  static bool _nessunErrore(List<BaAzioneBarra> azioni) => _problema(azioni) == null;
  static String _errore(List<BaAzioneBarra> azioni) => _problema(azioni) ?? '';

  EdgeInsets _estensione(int i, int n) =>
      EdgeInsets.only(left: i > 0 ? _mezzoGap : 0, right: i < n - 1 ? _mezzoGap : 0);

  Widget _pillola(BaAzioneBarra a, {EdgeInsets estensione = EdgeInsets.zero, bool primaria = false}) =>
      BaPillola(
        testo: a.testo,
        semanticsLabel: a.semanticsLabel,
        onTap: a.onTap,
        variante: a.varianteEffettiva,
        estensione: estensione,
        altezzaMinima: primaria ? BaControlloTokens.primario : BaControlloTokens.coppia,
      );

  @override
  Widget build(BuildContext context) {
    final visibili = azioni.take(BaBarraAzioniTokens.posti).toList();
    final primaria = visibili.firstWhere((a) => a.ruolo == BaRuoloAzione.primaria);
    final secondarie = [
      for (final a in visibili)
        if (!identical(a, primaria)) a,
    ];
    final conAltro = BaBarraAzioniTokens.conAltro(azioni.length);
    final voci = secondarie.length + (conAltro ? 1 : 0); // elementi della riga

    final riga = <Widget>[];
    for (var i = 0; i < secondarie.length; i++) {
      if (i > 0) riga.add(const SizedBox(width: BaControlloTokens.gapCoppia));
      riga.add(Expanded(child: _pillola(secondarie[i], estensione: _estensione(i, voci))));
    }
    if (conAltro) {
      riga.add(const SizedBox(width: BaControlloTokens.gapCoppia));
      riga.add(_Altro(
        semanticsLabel: semanticsLabelAltro,
        onTap: onAltro,
        estensione: _estensione(voci - 1, voci),
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _pillola(primaria, estensione: BaTouchable.estesa, primaria: true),
        if (secondarie.isNotEmpty) ...[
          const SizedBox(height: BaControlloTokens.gapCoppia),
          if (secondarie.length == 1 && !conAltro)
            // Una sola secondaria, centrata, larga come una di due.
            LayoutBuilder(
              builder: (context, vincoli) => Center(
                child: SizedBox(
                  width: (vincoli.maxWidth - BaControlloTokens.gapCoppia) / 2,
                  child: _pillola(secondarie.single, estensione: BaTouchable.estesa),
                ),
              ),
            )
          else
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: riga),
        ],
      ],
    );
  }
}

/// «Altro»: un cerchio di `altroLato` con tre punti.
class _Altro extends StatelessWidget {
  const _Altro({required this.semanticsLabel, required this.onTap, required this.estensione});

  final String semanticsLabel;
  final VoidCallback? onTap;
  final EdgeInsets estensione;

  @override
  Widget build(BuildContext context) {
    // Il prototipo ha punti da 4 con 3 di spazio e un filetto a .30: nessuno
    // dei due ha un token. Uso xxs (4) per punto e spazio e filettoMarcato,
    // e lo segnalo nel report.
    Widget punto() => const DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: BaColorTokens.testoPrimo,
          ),
          child: SizedBox.square(dimension: BaSpazioTokens.xxs),
        );
    return BaTouchable(
      key: BaBarraAzioni.chiaveAltro,
      semanticsLabel: semanticsLabel,
      onTap: onTap,
      estensione: estensione,
      raggio: BaRaggioTokens.pillola,
      child: Container(
        width: BaBarraAzioniTokens.altroLato,
        height: BaBarraAzioniTokens.altroLato,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: BaColorTokens.filettoMarcato),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            punto(),
            const SizedBox(width: BaSpazioTokens.xxs),
            punto(),
            const SizedBox(width: BaSpazioTokens.xxs),
            punto(),
          ],
        ),
      ),
    );
  }
}
