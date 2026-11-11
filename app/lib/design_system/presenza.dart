// BaPresenza, variante palco (C1): una persona sul palco. Compone sagoma,
// gradiente della tinta, ritratto, anello, disco, tacca e BaTouchable in
// variante `suPresenza`. Stati: ferma, parla, persa, scheletro, premuta, a
// fuoco (task 010); mutata, mutata che parla, bloccata, microfono spento e la
// tacca della parola (task 012).
//
// Il diametro NON è un parametro: si eredita dal palco (regola 5, C6) da un
// [BaDiametro]. Tinta e sagoma arrivano come indici dall'evento di ingresso:
// le assegna la stanza, non si calcolano dall'id (§7.3).
//
// Layout: la presenza occupa il diametro più la banda dell'anello a riposo
// (3 + 2 per lato). Serve perché l'anello di focus di BaTouchable stia fuori
// dall'anello della voce e non lo copra (T7 bis: "il focus non può somigliare
// alla voce"). Il palco la centra: la distanza minima di d + 17 la contiene.
// La tacca sporge 9 sotto la sagoma, quindi 4 oltre questo riquadro: sta nei
// 17 che il palco riserva fra le presenze e non viene tagliata.
//
// I GLIFI STANNO NEL DISCO (§7.17), non al centro: le iniziali non si coprono
// mai. Un solo disco; precedenza bloccata > mutata > microfono spento.
// Persa è un FILTRO sopra qualunque aspetto (grigio, opacità, nessun anello; il
// disco si attenua insieme). Lo scheletro batte tutto.
import 'package:flutter/widgets.dart';

import 'anello.dart';
import 'forma.dart';
import 'glifo.dart';
import 'ritratto.dart';
import 'tokens.dart';
import 'touchable.dart';

/// Il diametro delle presenze sotto di sé, deciso dal palco (regola 5).
class BaDiametro extends InheritedWidget {
  const BaDiametro({super.key, required this.diametro, required super.child});

  final double diametro;

  /// Il diametro ereditato. Senza un [BaDiametro] sopra è un errore in debug;
  /// in release ripiega sul fondo della scala a testo normale.
  static double of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<BaDiametro>();
    assert(w != null, 'BaPresenza vuole un BaDiametro sopra di sé: il diametro lo decide il palco');
    return w?.diametro ?? BaPresenzaTokens.s;
  }

  @override
  bool updateShouldNotify(BaDiametro vecchio) => diametro != vecchio.diametro;
}

class BaPresenza extends StatelessWidget {
  const BaPresenza({
    super.key,
    required this.semanticsLabel,
    this.semanticsLabelParla,
    required this.indiceTinta,
    required this.indiceSagoma,
    this.iniziali,
    this.immagine,
    this.parla = false,
    this.ampiezza = 0,
    this.voci = 1,
    this.lineaInstabile = false,
    this.persa = false,
    this.scheletro = false,
    this.mutata = false,
    this.bloccata = false,
    this.microfonoSpento = false,
    this.io = false,
    this.haLaParola = false,
    this.onTap,
  });

  /// Etichetta per lo screen reader, già composta dal chiamante in lingua
  /// (es. «Marta B.»). Le iniziali non sono la rappresentazione accessibile.
  final String semanticsLabel;

  /// Etichetta quando parla (es. «Marta B., sta parlando»). Se manca vale
  /// [semanticsLabel].
  final String? semanticsLabelParla;

  /// Indici nel mazzo di `BaTintaTokens` e di `BaSagomaTokens`, dall'evento di
  /// ingresso.
  final int indiceTinta;
  final int indiceSagoma;

  final String? iniziali;
  final ImageProvider? immagine;

  /// Canale veloce dell'anello: c'è una voce. Se la voce è mutata o la persona
  /// è bloccata non c'è anello: con la voce mutata `parla` accende il glifo.
  final bool parla;

  /// Canale lento: ampiezza 0–1 campionata ogni `campionamentoAmpiezza`.
  final double ampiezza;

  /// Quante voci parlano insieme sul palco (limiter).
  final int voci;

  /// Linea instabile: anello fermo a `voceTrattoFermo`.
  final bool lineaInstabile;

  /// Linea caduta: un filtro sopra qualunque aspetto (scala di grigi e
  /// `persaOpacita`), nessun anello; il disco e la tacca si attenuano insieme.
  final bool persa;

  /// Sagoma vuota mentre si entra: senza iniziali, respira fra i due valori
  /// dello scheletro. Non si tocca. Batte tutti gli altri stati.
  final bool scheletro;

  /// Voce mutata da me: sagoma desaturata e più opaca, iniziali a 0,80, disco
  /// con l'altoparlante barrato (spento; acceso mentre parla). Senza anello.
  final bool mutata;

  /// Bloccata: neutra, iniziali a 0,70, disco con il cerchio barrato, mai
  /// l'anello. Batte la mutata.
  final bool bloccata;

  /// Microfono spento: disco con il microfono barrato, sempre acceso.
  final bool microfonoSpento;

  /// La presenza è la mia: il disco del microfono spento è chiaro (fra più
  /// dischi trovo il mio). Vale solo per il microfono spento.
  final bool io;

  /// Chi ha la parola in un sotto-DEN porta la tacca sotto la sagoma.
  /// Indipendente dal disco.
  final bool haLaParola;

  /// Nullo = non toccabile. Lo scheletro non lo è mai.
  final VoidCallback? onTap;

  /// La banda dell'anello a riposo, per lato: keyline più tratto.
  static const double banda =
      BaPresenzaTokens.anelloKeyline + BaPresenzaTokens.anelloTratto;

  /// Quanto occupa nel layout una presenza di diametro [d]: la sagoma più la
  /// banda su ogni lato. Il palco centra questo riquadro sul centro della
  /// presenza.
  static double ingombro(double d) => d + 2 * banda;

  // I pesi di luminanza Rec. 709 (T4: presenza/persa è grayscale(1), la mutata
  // è saturate(mutataSaturazione)). Sono la definizione dei filtri, non un
  // valore di design; tokens.dart non li ha (segnalato nel report del task 010).
  static const double _pesoR = 0.2126;
  static const double _pesoG = 0.7152;
  static const double _pesoB = 0.0722;

  /// Matrice di saturazione: 0 = scala di grigi, 1 = colori invariati.
  static ColorFilter _saturazione(double s) {
    double dia(double peso) => peso * (1 - s) + s;
    return ColorFilter.matrix(<double>[
      dia(_pesoR), _pesoG * (1 - s), _pesoB * (1 - s), 0, 0, //
      _pesoR * (1 - s), dia(_pesoG), _pesoB * (1 - s), 0, 0,
      _pesoR * (1 - s), _pesoG * (1 - s), dia(_pesoB), 0, 0,
      0, 0, 0, 1, 0,
    ]);
  }

  static final ColorFilter _grigio = _saturazione(0);
  static final ColorFilter _desaturata = _saturazione(BaPresenzaTokens.mutataSaturazione);

  @override
  Widget build(BuildContext context) {
    final d = BaDiametro.of(context);
    const keyline = BaPresenzaTokens.anelloKeyline;
    // Lo scheletro batte tutto: nessun altro aspetto, disco o tacca.
    final bloccata = this.bloccata && !scheletro;
    final mutata = this.mutata && !scheletro;
    final microfonoSpento = this.microfonoSpento && !scheletro;
    // Un solo disco: bloccata > mutata > microfono spento.
    final BaTipoGlifo? tipoDisco = bloccata
        ? BaTipoGlifo.bloccata
        : mutata
            ? BaTipoGlifo.altoparlante
            : microfonoSpento
                ? BaTipoGlifo.microfono
                : null;
    final bordo = BaSagomaTokens.bordo(indiceSagoma, d);
    // Bloccata: il neutro prende il posto della tinta (stessa direzione a 155°).
    final tinta = bloccata
        ? BaTintaTokens(BaColorTokens.neutroBloccata[0], BaColorTokens.neutroBloccata[1])
        : BaTintaTokens.mazzo[indiceTinta % BaTintaTokens.mazzo.length];
    final conAnello = parla && !persa && !scheletro && !mutata && !bloccata;
    // Bloccata batte mutata: il resto dell'aspetto segue la bloccata.
    final soloMutata = mutata && !bloccata;
    final inizialiVisibili = scheletro ? null : iniziali;
    // La foto di una persona bloccata non si mostra: neutra, con le iniziali.
    final immagineVisibile = (scheletro || bloccata) ? null : immagine;
    final opacitaIniziali = bloccata
        ? BaPresenzaTokens.inizialiBloccataOpacita
        : soloMutata
            ? BaPresenzaTokens.inizialiMutataOpacita
            : 1.0;

    Widget sagoma = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: bordo,
        gradient: tinta.gradiente,
      ),
      child: ClipRRect(
        borderRadius: bordo,
        child: BaRitratto(
          diametro: d,
          iniziali: inizialiVisibili,
          immagine: immagineVisibile,
          opacitaIniziali: opacitaIniziali,
          velo: soloMutata ? BaColorTokens.veloMutataImmagine : BaColorTokens.veloImmagine,
        ),
      ),
    );
    if (soloMutata) {
      sagoma = Opacity(
        opacity: BaPresenzaTokens.mutataOpacita,
        child: ColorFiltered(colorFilter: _desaturata, child: sagoma),
      );
    }
    if (scheletro) sagoma = _Scheletro(child: sagoma);

    // Disco e tacca stanno fuori dal ritaglio della sagoma, a coordinate della
    // sagoma (origine in alto a sinistra, lato d).
    final disco = BaPresenzaTokens.badgeDiametro(d);
    final centroDisco = BaPresenzaTokens.badgeCentro * d;
    final larghezzaTacca = BaPresenzaTokens.parolaTaccaRapporto * d;
    Widget aspetto = Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        sagoma,
        Positioned(
          left: centroDisco - disco / 2,
          top: centroDisco - disco / 2,
          width: disco,
          height: disco,
          child: BaDiscoGlifo(
            tipo: tipoDisco,
            // Mutata: il glifo si accende mentre parla. Gli altri sono fissi.
            acceso: soloMutata ? parla : true,
            io: io && tipoDisco == BaTipoGlifo.microfono,
          ),
        ),
        if (haLaParola && !scheletro)
          Positioned(
            left: (d - larghezzaTacca) / 2,
            top: d,
            width: larghezzaTacca,
            height: BaPresenzaTokens.parolaTaccaSporge,
            child: const BaTaccaParola(),
          ),
      ],
    );
    // La persa è un filtro sopra qualunque aspetto, disco e tacca compresi.
    if (persa && !scheletro) {
      aspetto = Opacity(
        opacity: BaPresenzaTokens.persaOpacita,
        child: ColorFiltered(colorFilter: _grigio, child: aspetto),
      );
    }

    return BaTouchable(
      semanticsLabel: parla ? (semanticsLabelParla ?? semanticsLabel) : semanticsLabel,
      onTap: scheletro ? null : onTap,
      variante: BaVarianteTocco.suPresenza,
      // Il focus abbraccia la sagoma e la banda dell'anello a riposo.
      bordo: ingrandisci(bordo, banda),
      builder: (context, stato) {
        return SizedBox(
          width: ingombro(d),
          height: ingombro(d),
          child: Padding(
            padding: const EdgeInsets.all(banda),
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                aspetto,
                BaAnello(
                  diametro: d,
                  bordo: bordo,
                  parla: conAnello,
                  ampiezza: ampiezza,
                  voci: voci,
                  lineaInstabile: lineaInstabile,
                  // Premuta: la keyline diventa premutoKeyline, e basta.
                  keyline: stato.premuto
                      ? BaColorTokens.premutoKeyline
                      : BaColorTokens.voceKeyline,
                ),
                // Senza anello la keyline sola, solo da premuta.
                if (stato.premuto && !conAnello)
                  Positioned(
                    left: -keyline,
                    top: -keyline,
                    right: -keyline,
                    bottom: -keyline,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: ingrandisci(bordo, keyline),
                          border: Border.all(
                            color: BaColorTokens.premutoKeyline,
                            width: keyline,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Lo spessore del bordo del disco e della tacca: la tacca sporge
/// `parolaTaccaSporge` (9) ed è alta `parolaTaccaAltezza` (6), il resto sono i
/// due bordi (1,5 l'uno, come nel prototipo). tokens.dart non ha un token per il
/// bordo del disco: uso questo (segnalato nel report del task 012).
const double _bordoSegno =
    (BaPresenzaTokens.parolaTaccaSporge - BaPresenzaTokens.parolaTaccaAltezza) / 2;

/// Il disco in basso a destra della sagoma, con il glifo dello stato dentro
/// (§7.17): microfono barrato (microfono spento), altoparlante barrato (voce
/// mutata) o cerchio barrato (bloccata). Va messo in un riquadro grande
/// `badgeDiametro(d)` e posizionato a `badgeCentro` × d (lo fa BaPresenza).
///
/// Colori «altri» (`micSpentoFondo`, `micSpentoGlifo`, `micSpentoBordo`); la
/// variante [io] (disco chiaro) vale solo per il microfono spento. Con [tipo]
/// nullo il disco esce in 140 ms (`badgeMicrofono`) e lascia l'albero; con
/// «riduci movimento» entra e esce subito. Non è toccabile e non ha semantica.
class BaDiscoGlifo extends StatefulWidget {
  const BaDiscoGlifo({
    super.key,
    required this.tipo,
    this.acceso = true,
    this.io = false,
  });

  /// Il glifo; nullo = nessun disco.
  final BaTipoGlifo? tipo;

  /// Il glifo dentro: spento 0,45, acceso 1 (140 ms).
  final bool acceso;

  /// Disco chiaro, per la mia presenza: solo con il microfono.
  final bool io;

  @override
  State<BaDiscoGlifo> createState() => _BaDiscoGlifoState();
}

class _BaDiscoGlifoState extends State<BaDiscoGlifo> with SingleTickerProviderStateMixin {
  late final AnimationController _presenza = AnimationController(
    vsync: this,
    duration: BaMovimentoTokens.badgeMicrofono,
  );

  /// L'ultimo glifo, per disegnarlo mentre il disco esce.
  BaTipoGlifo? _ultimo;
  bool _riduciMovimento = false;

  @override
  void initState() {
    super.initState();
    _ultimo = widget.tipo;
    _presenza.addStatusListener((s) {
      if (s == AnimationStatus.dismissed && mounted) setState(() {});
    });
    _presenza.value = widget.tipo == null ? 0 : 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _riduciMovimento = MediaQuery.disableAnimationsOf(context);
  }

  @override
  void didUpdateWidget(BaDiscoGlifo vecchio) {
    super.didUpdateWidget(vecchio);
    if (widget.tipo != null) _ultimo = widget.tipo;
    if ((widget.tipo != null) != (vecchio.tipo != null)) {
      final entra = widget.tipo != null;
      if (_riduciMovimento) {
        _presenza.value = entra ? 1 : 0;
      } else if (entra) {
        _presenza.forward();
      } else {
        _presenza.reverse();
      }
    }
  }

  @override
  void dispose() {
    _presenza.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tipo = widget.tipo ?? _ultimo;
    if (tipo == null || (widget.tipo == null && _presenza.isDismissed)) {
      return const SizedBox.shrink();
    }
    final io = widget.io && tipo == BaTipoGlifo.microfono;
    final fondo = io ? BaColorTokens.micSpentoIoFondo : BaColorTokens.micSpentoFondo;
    final bordo = io ? BaColorTokens.voceKeyline : BaColorTokens.micSpentoBordo;
    return ExcludeSemantics(
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _presenza,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fondo,
              border: Border.all(color: bordo, width: _bordoSegno),
            ),
            child: Padding(
              padding: const EdgeInsets.all(_bordoSegno),
              child: LayoutBuilder(
                builder: (context, vincoli) => BaGlifo(
                  tipo: tipo,
                  acceso: widget.acceso,
                  lato: vincoli.biggest.shortestSide,
                  tratto: io ? BaColorTokens.micSpentoIoGlifo : BaColorTokens.micSpentoGlifo,
                  fondo: fondo,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// La tacca della parola (§7.18): una barra sotto la sagoma di chi ha la
/// parola. Colore `parolaTacca`, bordo `parolaTaccaBordo`. Va messa in un
/// riquadro largo `parolaTaccaRapporto` × d e alto `parolaTaccaSporge`, con il
/// bordo alto a filo del bordo basso della sagoma (lo fa BaPresenza).
/// Nessuna animazione: T8 non ne dà. Decorativa: la parola la dice
/// l'etichetta della presenza.
class BaTaccaParola extends StatelessWidget {
  const BaTaccaParola({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: BaColorTokens.parolaTacca,
            borderRadius: BorderRadius.circular(BaRaggioTokens.pillola),
            border: Border.all(color: BaColorTokens.parolaTaccaBordo, width: _bordoSegno),
          ),
        ),
      ),
    );
  }
}

/// Lo scheletro: l'opacità respira fra `scheletroOpacitaMin` e `Max`, un ciclo
/// completo in `skeleton` (1,8 s), lineare. Con "riduci movimento" è fermo al
/// valore più alto (proposta del task 010, nel report).
class _Scheletro extends StatefulWidget {
  const _Scheletro({required this.child});

  final Widget child;

  @override
  State<_Scheletro> createState() => _ScheletroState();
}

class _ScheletroState extends State<_Scheletro> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 1; // fermo al valore più alto
    } else if (!_controller.isAnimating) {
      // Un verso dura metà ciclo: su e giù fanno 1,8 s.
      _controller.repeat(
        reverse: true,
        period: BaMovimentoTokens.skeleton ~/ 2,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(Tween(
        begin: BaPresenzaTokens.scheletroOpacitaMin,
        end: BaPresenzaTokens.scheletroOpacitaMax,
      )),
      child: widget.child,
    );
  }
}
