// BaBarraAzioni: la barra in fondo allo schermo (task 002, punto 12). Tre posti,
// sempre: uno primario e due secondari. Dalla quarta azione compare «Altro»
// (48 × 48), che chiama `onAltro`: il foglio con le azioni rimanenti non è
// qui (arriva con BaFoglio).
//
// Disposizione, come nel prototipo del 002: la primaria sopra, a tutta
// larghezza; sotto, in una riga, le due secondarie e, se c'è, «Altro» a destra.
// Le pillole della stessa riga hanno la stessa altezza (la più alta). A testo
// grande, se la parola più lunga di una secondaria non entra nella sua pillola,
// le secondarie vanno in colonna e «Altro» sta sulla riga dell’ultima (020b).
// Con due azioni c’è una sola secondaria, centrata come in BaAzioniInCoppia; con
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

  Widget _pillola(BaAzioneBarra a,
          {EdgeInsets estensione = EdgeInsets.zero, bool primaria = false, double? altezza}) =>
      BaPillola(
        testo: a.testo,
        semanticsLabel: a.semanticsLabel,
        onTap: a.onTap,
        variante: a.varianteEffettiva,
        estensione: estensione,
        altezzaMinima: altezza ?? (primaria ? BaControlloTokens.primario : BaControlloTokens.coppia),
      );

  @override
  Widget build(BuildContext context) {
    final visibili = azioni.take(BaBarraAzioniTokens.posti).toList();
    final primaria = visibili.firstWhere((a) => a.ruolo == BaRuoloAzione.primaria);
    final secondarie = [
      for (final a in visibili)
        if (!identical(a, primaria)) a,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _pillola(primaria, estensione: BaTouchable.estesa, primaria: true),
        if (secondarie.isNotEmpty) ...[
          const SizedBox(height: BaControlloTokens.gapCoppia),
          LayoutBuilder(
            builder: (context, vincoli) => _secondarie(context, vincoli.maxWidth, secondarie),
          ),
        ],
      ],
    );
  }

  /// Le secondarie e «Altro». Due disposizioni:
  /// - **affiancate** (la normale): tutte sulla stessa riga, con la stessa
  ///   altezza (quella della più alta); «Altro» resta 48 × 48 e centrato in
  ///   verticale sulla riga;
  /// - **in colonna** (il ripiego): se la parola più lunga di una secondaria non
  ///   entra, intera, nella sua pillola al testo di sistema corrente, le due
  ///   secondarie vanno una sotto l'altra a tutta larghezza e «Altro» sta a
  ///   destra in fondo, sulla riga dell'ultima. Niente parole spezzate. Si decide
  ///   misurando (BaPillola.parolaEntra) con la larghezza che la pillola
  ///   avrebbe affiancata; la riga di «Altro» in colonna non si ricontrolla.
  Widget _secondarie(BuildContext context, double larghezza, List<BaAzioneBarra> secondarie) {
    final conAltro = BaBarraAzioniTokens.conAltro(azioni.length);
    const gap = BaControlloTokens.gapCoppia;

    bool entra(BaAzioneBarra a, double l) => BaPillola.parolaEntra(
          context,
          testo: a.testo,
          larghezza: l,
          variante: a.varianteEffettiva,
          inattiva: a.onTap == null,
        );
    double altezza(BaAzioneBarra a, double l) => BaPillola.altezzaNecessaria(
          context,
          testo: a.testo,
          larghezza: l,
          variante: a.varianteEffettiva,
          inattiva: a.onTap == null,
          altezzaMinima: BaControlloTokens.coppia,
        );

    // Una sola secondaria, senza «Altro»: centrata, larga come una di due; se la
    // sua parola più lunga non entra, a tutta larghezza.
    if (secondarie.length == 1 && !conAltro) {
      final meta = (larghezza - gap) / 2;
      return Center(
        child: SizedBox(
          width: entra(secondarie.single, meta) ? meta : larghezza,
          child: _pillola(secondarie.single, estensione: BaTouchable.estesa),
        ),
      );
    }

    final voci = secondarie.length + (conAltro ? 1 : 0);
    final affiancata = conAltro
        ? (larghezza - secondarie.length * gap - BaBarraAzioniTokens.altroLato) / secondarie.length
        : (larghezza - (secondarie.length - 1) * gap) / secondarie.length;
    final affiancate = secondarie.every((a) => entra(a, affiancata));

    Widget altro(EdgeInsets estensione) =>
        _Altro(semanticsLabel: semanticsLabelAltro, onTap: onAltro, estensione: estensione);

    if (affiancate) {
      final h = secondarie.map((a) => altezza(a, affiancata)).reduce((a, b) => a > b ? a : b);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < secondarie.length; i++) ...[
            if (i > 0) const SizedBox(width: gap),
            Expanded(child: _pillola(secondarie[i], estensione: _estensione(i, voci), altezza: h)),
          ],
          if (conAltro) ...[
            const SizedBox(width: gap),
            altro(_estensione(voci - 1, voci)),
          ],
        ],
      );
    }

    // In colonna: tutte a tutta larghezza; l'ultima con «Altro» a destra.
    final ultima = secondarie.length - 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < ultima; i++) ...[
          _pillola(secondarie[i], estensione: BaTouchable.estesa),
          const SizedBox(height: gap),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _pillola(
                secondarie[ultima],
                estensione: conAltro ? const EdgeInsets.only(right: _mezzoGap) : BaTouchable.estesa,
              ),
            ),
            if (conAltro) ...[
              const SizedBox(width: gap),
              altro(const EdgeInsets.only(left: _mezzoGap)),
            ],
          ],
        ),
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
