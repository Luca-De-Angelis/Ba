// BaPalco: il palco come widget (C1, C6). Riceve una SCATOLA, non una
// dimensione: ne ricava diametro e centri con `disponiPalco` (la funzione pura
// di palco/disposizione.dart) e mette una BaPresenza per persona. È l'unico
// punto dell'app dove un layout decide una misura.
//
// Senza movimento (task 011): le presenze compaiono e spariscono e la
// disposizione si ricalcola subito. L'assestamento animato (320 ms, 200 ms al
// ricompattamento, 4 s e 6 s di attesa) è rimandato.
//
// Chi è sul palco è a schermo: nessuna presenza viene tolta, nemmeno quando la
// scatola è troppo piccola (`sfora`); il palco non scorre mai.
//
// Il palco NON conosce le traduzioni: i testi gli arrivano dal chiamante
// (`semanticsLabel`, `invitoTitolo`, `invitoTesto`).
//
// Le voci insieme: il palco conta chi parla e passa a tutte le presenze lo
// stesso `voci` (il limiter), anche a chi parla: una presenza più piccola delle
// altre si leggerebbe come rango.
//
// L'ORDINE DELLA LISTA DECIDE CHI STA A QUALE CENTRO: la persona i sta nel
// centro i, e `disponiPalco` ordina i centri dall'alto in basso e da sinistra a
// destra, che è anche l'ordine di lettura per lo screen reader. Lo stabilisce
// il chiamante: se qualcuno esce, chi segue scala di un posto.
// ECCEZIONE ALLA REGOLA "in design_system/ solo widgets.dart" (approvata nel
// task 011): questo file importa anche `package:flutter/semantics.dart`, e solo
// per `OrdinalSortKey`, che widgets.dart non esporta. Serve a fissare l'ordine di
// lettura (= ordine dei centri): quello geometrico di Flutter, con le righe
// sfalsate, può leggere le presenze nell'ordine sbagliato.
import 'package:flutter/semantics.dart' show OrdinalSortKey;
import 'package:flutter/widgets.dart';

import 'palco/disposizione.dart';
import 'presenza.dart';
import 'tokens.dart';

/// Una persona sul palco, come arriva dall'evento di ingresso e dalla stanza.
@immutable
class BaPersonaPalco {
  const BaPersonaPalco({
    required this.id,
    required this.indiceTinta,
    required this.indiceSagoma,
    required this.semanticsLabel,
    this.semanticsLabelParla,
    this.iniziali,
    this.immagine,
    this.parla = false,
    this.ampiezza = 0,
    this.persa = false,
    this.onTap,
  });

  /// Identità stabile della persona sul palco: tiene vivo lo stato dell'anello
  /// quando altre persone entrano o escono. Unico fra le persone del palco.
  final String id;

  /// Indici nel mazzo di tinte e di sagome, assegnati dalla stanza.
  final int indiceTinta;
  final int indiceSagoma;

  final String? iniziali;
  final ImageProvider? immagine;

  /// Canale veloce dell'anello: c'è una voce.
  final bool parla;

  /// Canale lento: ampiezza 0–1 campionata ogni `campionamentoAmpiezza`.
  final double ampiezza;

  /// Linea persa per questa persona: scala di grigi, nessun anello.
  final bool persa;

  /// Etichette per lo screen reader, già composte in lingua dal chiamante.
  final String semanticsLabel;
  final String? semanticsLabelParla;

  final VoidCallback? onTap;
}

/// Lo stato del palco.
sealed class BaStatoPalco {
  const BaStatoPalco();

  /// Le persone ci sono e si vedono. Con 0 persone: il palco vuoto.
  const factory BaStatoPalco.vivo() = _BaPalcoVivo;

  /// Sto entrando: [conteggio] sagome vuote che respirano, con la
  /// disposizione di [conteggio] persone. Le `persone` si ignorano.
  const factory BaStatoPalco.scheletro(int conteggio) = _BaPalcoScheletro;

  /// La linea è persa: tutte le presenze in stato persa, la disposizione non
  /// cambia. Quanto dura il posto conservato è logica di un task successivo.
  const factory BaStatoPalco.congelato() = _BaPalcoCongelato;
}

class _BaPalcoVivo extends BaStatoPalco {
  const _BaPalcoVivo();
}

class _BaPalcoScheletro extends BaStatoPalco {
  const _BaPalcoScheletro(this.conteggio);
  final int conteggio;
}

class _BaPalcoCongelato extends BaStatoPalco {
  const _BaPalcoCongelato();
}

class BaPalco extends StatefulWidget {
  const BaPalco({
    super.key,
    required this.persone,
    required this.larghezzaSchermo,
    required this.semanticsLabel,
    this.stato = const BaStatoPalco.vivo(),
    this.invitoTitolo,
    this.invitoTesto,
  });

  /// Da 0 a 8; oltre è un errore (`ArgumentError`). In ordine: vedi sopra.
  final List<BaPersonaPalco> persone;

  /// La larghezza dello SCHERMO, non della scatola: decide telefono o tablet
  /// (D-027). Un tablet da 600 dp ha una scatola di 536 e non è un telefono.
  final double larghezzaSchermo;

  /// Etichetta del palco per lo screen reader (es. «Palco, 3 persone»),
  /// composta dal chiamante.
  final String semanticsLabel;

  final BaStatoPalco stato;

  /// I due testi del palco vuoto, mostrati SOLO in `vivo` con 0 persone. Non
  /// mettono pressione: nessun conto alla rovescia, nessun «tocca a te».
  final String? invitoTitolo;
  final String? invitoTesto;

  @override
  State<BaPalco> createState() => _BaPalcoState();
}

class _BaPalcoState extends State<BaPalco> {
  bool _sfora = false;

  int get _conteggio => switch (widget.stato) {
        _BaPalcoScheletro(:final conteggio) => conteggio,
        _ => widget.persone.length,
      };

  /// Una voce per ogni persona che parla e non ha perso la linea. Nessuna o una:
  /// 1 (nessun limiter).
  int get _voci {
    if (widget.stato is! _BaPalcoVivo) return 1;
    final parlano = widget.persone.where((p) => p.parla && !p.persa).length;
    return parlano < 1 ? 1 : parlano;
  }

  /// Solo in debug, e solo quando cambia.
  void _avvisaSfora(bool sfora, Size scatola, double d) {
    assert(() {
      if (sfora != _sfora) {
        _sfora = sfora;
        if (sfora) {
          debugPrint(
            'BaPalco: la scatola $scatola è troppo piccola per $_conteggio '
            'presenze a $d dp: nessuna viene tolta, il palco esce dai margini.',
          );
        }
      }
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (widget.stato is _BaPalcoScheletro) return true;
      final visti = <String>{};
      for (final p in widget.persone) {
        if (!visti.add(p.id)) {
          throw FlutterError(
            'BaPalco: due persone hanno lo stesso id («${p.id}»). '
            "L'id identifica la persona sul palco ed è unico.",
          );
        }
      }
      return true;
    }());

    return LayoutBuilder(
      builder: (context, vincoli) {
        assert(
          vincoli.hasBoundedWidth && vincoli.hasBoundedHeight,
          'BaPalco riceve una scatola: larghezza e altezza devono essere limitate '
          '(per esempio dentro un Expanded).',
        );
        final scatola = vincoli.biggest;
        final n = _conteggio;
        final disposizione = disponiPalco(
          persone: n,
          scatola: scatola,
          larghezzaSchermo: widget.larghezzaSchermo,
        );
        _avvisaSfora(disposizione.sfora, scatola, disposizione.diametro);

        final d = disposizione.diametro;
        final lato = BaPresenza.ingombro(d);

        return SizedBox.fromSize(
          size: scatola,
          child: Semantics(
            container: true,
            label: widget.semanticsLabel,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (n == 0) _invito(),
                for (var i = 0; i < n; i++)
                  Positioned(
                    key: _chiave(i),
                    left: disposizione.centri[i].dx - lato / 2,
                    top: disposizione.centri[i].dy - lato / 2,
                    width: lato,
                    height: lato,
                    child: BaDiametro(
                      diametro: d,
                      child: Semantics(
                        container: true,
                        sortKey: OrdinalSortKey(i.toDouble()),
                        child: _presenza(i),
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

  Key _chiave(int i) => switch (widget.stato) {
        _BaPalcoScheletro() => ValueKey('scheletro-$i'),
        _ => ValueKey(widget.persone[i].id),
      };

  Widget _presenza(int i) {
    switch (widget.stato) {
      case _BaPalcoScheletro():
        // Sagome vuote: la stanza non ha ancora dato né tinta né forma, quindi
        // tutte uguali; fuori dalla semantica (ingresso morbido).
        return const ExcludeSemantics(
          child: BaPresenza(
            semanticsLabel: '',
            indiceTinta: 0,
            indiceSagoma: 0,
            scheletro: true,
          ),
        );
      case _BaPalcoVivo():
      case _BaPalcoCongelato():
        final congelato = widget.stato is _BaPalcoCongelato;
        final p = widget.persone[i];
        return BaPresenza(
          semanticsLabel: p.semanticsLabel,
          semanticsLabelParla: p.semanticsLabelParla,
          indiceTinta: p.indiceTinta,
          indiceSagoma: p.indiceSagoma,
          iniziali: p.iniziali,
          immagine: p.immagine,
          parla: p.parla,
          ampiezza: p.ampiezza,
          voci: _voci,
          persa: p.persa || congelato,
          onTap: p.onTap,
        );
    }
  }

  /// Il palco vuoto: solo in `vivo`, e solo se il chiamante ha dato i testi.
  Widget _invito() {
    final titolo = widget.invitoTitolo;
    final testo = widget.invitoTesto;
    if (widget.stato is! _BaPalcoVivo || (titolo == null && testo == null)) {
      return const SizedBox.shrink();
    }
    return Positioned.fill(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (titolo != null)
              Text(
                titolo,
                textAlign: TextAlign.center,
                style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo),
              ),
            if (titolo != null && testo != null) const SizedBox(height: BaSpazioTokens.xs),
            if (testo != null)
              Text(
                testo,
                textAlign: TextAlign.center,
                style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
              ),
          ],
        ),
      ),
    );
  }
}
