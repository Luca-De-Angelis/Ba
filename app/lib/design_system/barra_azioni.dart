// BaBarraAzioni: la barra in fondo allo schermo (task 002, punto 12). Tre posti,
// sempre: uno primario e due secondari. Dalla quarta azione compare «Altro»
// (48 × 48), che chiama `onAltro`: il foglio con le azioni rimanenti non è
// qui (arriva con BaFoglio). **Task 024a:** un'azione segnata `inAltro` va in
// «Altro» qualunque sia la sua posizione, e «Altro» compare se ce n'è almeno una
// (015 e 027: un ascoltatore ha la primaria, «Esci» e «Altro»). Chi non usa
// `inAltro` non vede nessun cambiamento; `BaBarraAzioni.eccedenti` dà le azioni
// da mettere nel foglio.
//
// Disposizione, come nel prototipo del 002: la primaria sopra, a tutta
// larghezza; sotto, in una riga, le due secondarie e, se c'è, «Altro» a destra.
// Le pillole della stessa riga hanno la stessa altezza (la più alta). **Task 032:** le
// secondarie sono a 14 (`BaTestoTokens.azione`, la primaria resta a 16) e, in una riga,
// **non hanno la stessa larghezza**: ognuna parte dalla larghezza del suo testo più il
// riempimento e si divide con le altre l'avanzo (come `flex: 1 1 auto` del prototipo), così
// «Scendi dal palco» sta su una riga a 360 dp e una parola lunga non decide per tutte. Se i
// testi su una riga non entrano, vale la disposizione di prima (020b): a testo grande, se
// la parola più lunga di una secondaria non entra nella sua pillola, le secondarie vanno in
// colonna e «Altro» sta sulla riga dell’ultima.
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
    this.inAltro = false,
  }) : assert(
         !inAltro || (ruolo != BaRuoloAzione.primaria && !fissa),
         'la primaria e le azioni fisse non possono stare in «Altro»',
       );

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

  /// Va in «Altro» **qualunque sia la sua posizione** (task 024a, 015 e 027: un
  /// ascoltatore ha la primaria, «Esci» e «Altro» con «Impostazioni» dentro). «Altro»
  /// compare se ce n'è almeno una, oltre alla regola della quarta azione. Non può
  /// esserlo né la primaria né un'azione fissa (assert in debug, come per i posti).
  /// Default falso: chi non lo usa non vede nessun cambiamento.
  final bool inAltro;

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

  /// Quello che «Altro» fa: apre il foglio con [eccedenti].
  final VoidCallback? onAltro;

  /// Etichetta di «Altro» per lo screen reader, dal chiamante.
  final String semanticsLabelAltro;

  /// Per trovare «Altro» nei test.
  static const Key chiaveAltro = ValueKey('barra-altro');

  static const double _mezzoGap = BaControlloTokens.gapCoppia / 2;

  /// Le secondarie sono a 14, sotto la primaria nella gerarchia (task 032).
  static const TextStyle _stileSecondaria = BaTestoTokens.azione;

  /// Le azioni che finiscono in «Altro»: quelle segnate `inAltro` e quelle che, fra le
  /// altre, stanno oltre i tre posti, nell'ordine in cui sono date. Chi apre il foglio
  /// di «Altro» lo riempie con queste.
  static List<BaAzioneBarra> eccedenti(List<BaAzioneBarra> azioni) {
    final fuori = <BaAzioneBarra>[];
    var posto = 0;
    for (final a in azioni) {
      if (a.inAltro || posto >= BaBarraAzioniTokens.posti) {
        fuori.add(a);
      } else {
        posto++;
      }
    }
    return fuori;
  }

  /// «Altro» compare dalla quarta azione, o se ce n'è almeno una `inAltro`.
  static bool _conAltro(List<BaAzioneBarra> azioni) =>
      BaBarraAzioniTokens.conAltro(azioni.length) || azioni.any((a) => a.inAltro);

  static String? _problema(List<BaAzioneBarra> azioni) {
    final primarie = [
      for (var i = 0; i < azioni.length; i++)
        if (azioni[i].ruolo == BaRuoloAzione.primaria) i,
    ];
    if (primarie.length != 1) return 'la barra vuole una sola primaria, ne ha ${primarie.length}';
    // I posti li hanno le azioni che non sono `inAltro`.
    final conPosto = [for (final a in azioni) if (!a.inAltro) a];
    final iPrimaria = conPosto.indexWhere((a) => a.ruolo == BaRuoloAzione.primaria);
    if (iPrimaria < 0) return 'la primaria non può stare in «Altro»';
    if (iPrimaria >= BaBarraAzioniTokens.posti) {
      return 'la primaria è in posizione ${iPrimaria + 1}: finirebbe in «Altro»';
    }
    for (var i = BaBarraAzioniTokens.posti; i < conPosto.length; i++) {
      if (conPosto[i].fissa) return 'l\'azione fissa «${conPosto[i].testo}» finirebbe in «Altro»';
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
        stile: primaria ? BaTestoTokens.controllo : _stileSecondaria,
        testo: a.testo,
        semanticsLabel: a.semanticsLabel,
        onTap: a.onTap,
        variante: a.varianteEffettiva,
        estensione: estensione,
        altezzaMinima: altezza ?? (primaria ? BaControlloTokens.primario : BaControlloTokens.coppia),
      );

  @override
  Widget build(BuildContext context) {
    final visibili = [for (final a in azioni) if (!a.inAltro) a].take(BaBarraAzioniTokens.posti).toList();
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
        if (secondarie.isNotEmpty || _conAltro(azioni)) ...[
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
    final conAltro = _conAltro(azioni);
    const gap = BaControlloTokens.gapCoppia;

    // Solo la primaria e «Altro» (un'azione `inAltro` e nient'altro): «Altro» da solo, a destra.
    if (secondarie.isEmpty) {
      return Align(
        alignment: Alignment.centerRight,
        child: _Altro(semanticsLabel: semanticsLabelAltro, onTap: onAltro, estensione: EdgeInsets.zero),
      );
    }

    bool entra(BaAzioneBarra a, double l) => BaPillola.parolaEntra(
          context,
          testo: a.testo,
          larghezza: l,
          variante: a.varianteEffettiva,
          inattiva: a.onTap == null,
          stile: _stileSecondaria,
        );
    double altezza(BaAzioneBarra a, double l) => BaPillola.altezzaNecessaria(
          context,
          testo: a.testo,
          larghezza: l,
          variante: a.varianteEffettiva,
          inattiva: a.onTap == null,
          altezzaMinima: BaControlloTokens.coppia,
          stile: _stileSecondaria,
        );
    double contenuto(BaAzioneBarra a) => BaPillola.larghezzaNecessaria(
          context,
          testo: a.testo,
          variante: a.varianteEffettiva,
          inattiva: a.onTap == null,
          stile: _stileSecondaria,
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

    // La riga dal contenuto (task 032): se i testi stanno tutti su una riga, ognuna parte dalla
    // sua larghezza e l'avanzo si divide in parti uguali; stessa altezza per tutte.
    final fisso = (voci - 1) * gap + (conAltro ? BaBarraAzioniTokens.altroLato : 0);
    final larghezze = [for (final a in secondarie) contenuto(a)];
    final somma = larghezze.fold<double>(0, (x, y) => x + y);
    if (somma <= larghezza - fisso) {
      final avanzo = (larghezza - fisso - somma) / secondarie.length;
      final h = [
        for (var i = 0; i < secondarie.length; i++) altezza(secondarie[i], larghezze[i]),
      ].reduce((a, b) => a > b ? a : b);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < secondarie.length; i++) ...[
            if (i > 0) const SizedBox(width: gap),
            SizedBox(
              width: larghezze[i] + avanzo,
              child: _pillola(secondarie[i], estensione: _estensione(i, voci), altezza: h),
            ),
          ],
          if (conAltro) ...[
            const SizedBox(width: gap),
            _Altro(semanticsLabel: semanticsLabelAltro, onTap: onAltro, estensione: _estensione(voci - 1, voci)),
          ],
        ],
      );
    }
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
    // «Altro»: tre punti e un filetto, tutti da BaBarraAzioniTokens (015c).
    Widget punto() => const DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: BaColorTokens.testoPrimo,
          ),
          child: SizedBox.square(dimension: BaBarraAzioniTokens.altroPuntoLato),
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
          border: Border.all(color: BaBarraAzioniTokens.altroBordo),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            punto(),
            const SizedBox(width: BaBarraAzioniTokens.altroPuntoGap),
            punto(),
            const SizedBox(width: BaBarraAzioniTokens.altroPuntoGap),
            punto(),
          ],
        ),
      ),
    );
  }
}
