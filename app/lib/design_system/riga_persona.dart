// BaRigaPersona: una riga di persona (task 023b, prototipo 014: G2 bis
// «Co-amministratori» e G3 «Persone nel DEN»; esteso dal task 033, prototipo 030:
// persone, rubrica, selettore e richiamo): la sagoma con la sua tinta, il nome,
// l'alias, il ruolo o lo stato e, a destra, **un'azione** o **un interruttore**.
//
// **Come è esteso senza rompere niente (task 033).** Ogni parametro nuovo è
// facoltativo e, se manca, il componente fa esattamente ciò che faceva: senza
// [voce] e senza [acceso] la riga è quella di «Gestisci» (nome, ruolo, azione
// testuale «Rimuovi» o «Togli»), e il suo codice non è cambiato. [stato] è ora
// facoltativo (le chiamate che lo danno funzionano come prima); [alias] aggiunge
// solo una riga di testo.
//
// **Senza azione la riga non lascia né testo né spazio**: chi è co-amministratore
// non ha «Rimuovi» (prima si toglie il ruolo, D04). Il testo dell'azione e la
// sua etichetta per lo screen reader li dà il chiamante; se c'è il testo ma
// manca [onAzione], l'azione è inattiva.
//
// **Le voci del 030** ([voce]): la parola sta in [azione] («Aggiungi», «Invita»,
// «Scegli», «In lista», «Nell'invito»). Mai il solo colore: *da aggiungere* e
// *scegli* sono un'azione **con il contorno** e la parola; *aggiunta* e *nell'invito*
// sono **una spunta disegnata più la parola**, senza contorno (e «Nell'invito» si
// può toccare per toglierla). Dal testo a 1,3 (`azioneSottoDa`) l'azione sta **sotto il
// nome, a sinistra, in ogni riga** (task 032c: prima stava accanto se c'era posto e sotto
// se no, riga per riga); a 1,0 è accanto. Nessuna parola si spezza. **Mai lo stato di presenza né il luogo in cui la
// persona si trova:** nessun parametro lo ammette, e nessun valore di questo file
// serve a mostrarlo.
//
// **L'interruttore** ([acceso], in alternativa all'azione): il richiamo per persona.
// Lo stato è la **parola** («Acceso» o «Spento», dal chiamante) e non solo la
// posizione del pallino; tutta la riga è toccabile e per lo screen reader è un
// interruttore. Il disegno è quello di `BaInterruttoreRiga` (stessi token), qui
// ridisegnato perché il suo è privato; anche la spunta ridisegna quella di
// `BaChipScelta`: due duplicazioni piccole e dichiarate.
//
// Sagoma e tinta sono **indici** assegnati da chi usa il componente (come in
// `BaPubblico`): non si calcolano dall'id. Per lo screen reader la riga ha due
// **«● Disponibile» (task 034, 031 L1 e L3):** parametro facoltativo `disponibile`, la **parola**
// dal chiamante («Disponibile»), sotto l'alias e prima dello stato: un **punto pieno**
// (`BaScopertaTokens.disponibileSegnoLato`) e **sempre la parola**, mai il solo colore né il solo
// punto. È uno stato **dichiarato** da chi lo accende, mai rilevato. Senza il parametro la riga è
// identica a prima.
//
// elementi: il nome (con alias e stato) e l'azione o l'interruttore.
//
// Valore che i token non hanno: la proporzione della spunta (costanti private). Il fondo
// dell'interruttore acceso e il pallino spento sono quelli di `BaInterruttoreRiga` (token del
// task 032); il raggio dell'azione è `azioneRaggio` (24).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'sagoma.dart';
import 'tokens.dart';
import 'touchable.dart';

/// Le voci di una riga di persona nel 030: da aggiungere, aggiunta, nell'invito,
/// scegli. La parola la dà il chiamante in `azione`.
enum BaVoceRigaPersona {
  /// «Aggiungi», «Invita»: un'azione con il contorno.
  daAggiungere,

  /// «In lista»: la spunta e la parola, senza contorno.
  aggiunta,

  /// «Nell'invito»: la spunta e la parola, senza contorno; si può toccare per
  /// toglierla.
  nellInvito,

  /// «Scegli»: un'azione con il contorno.
  scegli,
}

class BaRigaPersona extends StatelessWidget {
  const BaRigaPersona({
    super.key,
    required this.nome,
    this.stato,
    this.alias,
    this.tinta = 0,
    this.sagoma = 0,
    this.azione,
    this.onAzione,
    this.azioneSemanticsLabel,
    this.voce,
    this.acceso,
    this.parolaAcceso,
    this.parolaSpento,
    this.onCambia,
    this.disponibile,
  })  : assert(disponibile == null || disponibile != '', 'il segno «Disponibile» non va mai senza la parola'),
        assert(acceso == null || (voce == null && azione == null), 'l\'interruttore sta al posto dell\'azione'),
        assert(acceso == null || (parolaAcceso != null && parolaSpento != null), 'l\'interruttore ha le sue due parole'),
        assert(voce == null || azione != null, 'la voce ha la sua parola in azione');

  final String nome;

  /// Il ruolo o lo stato, già composto dal chiamante («sul palco»). Facoltativo.
  final String? stato;

  /// La parola dello stato dichiarato («Disponibile»), con il punto pieno davanti, sotto l'alias.
  /// Facoltativa; il segno non esiste senza la parola.
  final String? disponibile;

  /// Il nome unico che distingue due persone con lo stesso nickname (`@sara.m`),
  /// sotto il nome, in secondo piano. Facoltativo.
  final String? alias;

  /// Gli indici della tinta e della sagoma, dal chiamante.
  final int tinta;
  final int sagoma;

  /// Il testo dell'azione («Rimuovi»; con [voce], la parola della voce). Nullo = la
  /// riga non ha azione: né testo né spazio.
  final String? azione;

  /// Nullo, con un [azione], = l'azione è inattiva.
  final VoidCallback? onAzione;

  /// Se manca: [azione].
  final String? azioneSemanticsLabel;

  /// Una delle quattro voci del 030. Con la voce l'azione ha il contorno o la
  /// spunta, e va a capo a testo grande.
  final BaVoceRigaPersona? voce;

  /// L'interruttore, al posto dell'azione: acceso o spento. Nullo = nessun
  /// interruttore.
  final bool? acceso;

  /// Le parole dell'interruttore, dal chiamante («Acceso», «Spento»).
  final String? parolaAcceso;
  final String? parolaSpento;

  /// Chiamata col valore nuovo. Nulla, con un interruttore = inattivo.
  final ValueChanged<bool>? onCambia;

  bool get _nuova => voce != null || acceso != null;

  @override
  Widget build(BuildContext context) {
    if (_nuova) return _costruisciNuova(context);
    return _costruisciClassica();
  }

  /// La sagoma.
  Widget _sagoma() => BaSagoma(tinta: tinta, sagoma: sagoma, lato: BaPersoneTokens.sagomaLato);

  /// Nome, alias e stato, uno sotto l'altro; un elemento solo per lo screen reader.
  Widget _testi() => Semantics(
        container: true,
        label: [nome, ?alias, ?disponibile, ?stato].join('. '),
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(nome, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
            if (alias != null) ...[
              const SizedBox(height: BaSpazioTokens.xxs),
              Text(alias!, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
            ],
            if (disponibile != null) ...[
              const SizedBox(height: BaSpazioTokens.xxs),
              _Disponibile(parola: disponibile!),
            ],
            if (stato != null) ...[
              const SizedBox(height: BaSpazioTokens.xxs),
              Text(stato!, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
            ],
          ],
        ),
      );

  BoxDecoration get _filetto => const BoxDecoration(
        border: Border(top: BorderSide(color: BaColorTokens.filettoDivisorio)),
      );

  // ------------------------------------------------- la riga di «Gestisci»

  Widget _costruisciClassica() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: BaPersoneTokens.rigaAltezza,
        minWidth: double.infinity,
      ),
      padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.s),
      decoration: _filetto,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sagoma(),
          const SizedBox(width: BaPersoneTokens.rigaGap),
          Expanded(child: _testi()),
          if (azione != null) ...[
            const SizedBox(width: BaSpazioTokens.m),
            // container: un nodo suo per lo screen reader, anche se inattiva.
            Semantics(
              container: true,
              child: BaTouchable(
                semanticsLabel: azioneSemanticsLabel ?? azione!,
                onTap: onAzione,
                raggio: 0,
                builder: (context, _) => ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: BaControlloTokens.areaMinima),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      azione!,
                      style: BaTestoTokens.minore.copyWith(
                        color: onAzione == null ? BaColorTokens.testoInattivo : BaColorTokens.testoPrimo,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------- le voci e l'interruttore

  Widget _costruisciNuova(BuildContext context) {
    final interruttore = acceso != null;
    // Dal testo a `azioneSottoDa` l'azione sta sotto il nome in **ogni** riga (task 032c, 030 con testo 2,0):
    // senza questa soglia l'azione stava accanto se c'era posto e sotto se no, riga per riga.
    final sotto = BaScalaTokens.testo(context) >= BaPersoneTokens.azioneSottoDa;
    final riga = Container(
      constraints: const BoxConstraints(
        minHeight: BaPersoneTokens.rigaAltezza,
        minWidth: double.infinity,
      ),
      padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.s),
      decoration: _filetto,
      child: sotto ? _impilata(interruttore) : _affiancata(interruttore),
    );
    if (!interruttore) return riga;
    // L'interruttore: tutta la riga è toccabile, e per lo screen reader è un interruttore.
    return Semantics(
      container: true,
      toggled: acceso,
      child: BaTouchable(
        semanticsLabel: azioneSemanticsLabel ?? [nome, ?alias, ?disponibile].join('. '),
        onTap: onCambia == null ? null : () => onCambia!(!acceso!),
        raggio: 0,
        builder: (context, _) => riga,
      ),
    );
  }

  Widget _destraOInterruttore(bool interruttore) =>
      interruttore ? _Interruttore(acceso: acceso!, parola: acceso! ? parolaAcceso! : parolaSpento!) : _destra();

  /// Testo normale: l'azione accanto al nome (a capo, sotto, solo se non c'è posto).
  Widget _affiancata(bool interruttore) => Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: BaPersoneTokens.rigaGap,
        runSpacing: BaSpazioTokens.s,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sagoma(),
              const SizedBox(width: BaPersoneTokens.rigaGap),
              Flexible(child: _testi()),
            ],
          ),
          _destraOInterruttore(interruttore),
        ],
      );

  /// Testo grande: il nome sopra e l'azione sotto, allineata a sinistra con la sagoma, uguale in ogni riga.
  Widget _impilata(bool interruttore) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _sagoma(),
              const SizedBox(width: BaPersoneTokens.rigaGap),
              Expanded(child: _testi()),
            ],
          ),
          const SizedBox(height: BaSpazioTokens.s),
          _destraOInterruttore(interruttore),
        ],
      );

  /// La parte destra di una voce: l'azione con il contorno, o la spunta e la parola.
  Widget _destra() {
    final etichetta = azioneSemanticsLabel ?? azione!;
    final conContorno = voce == BaVoceRigaPersona.daAggiungere || voce == BaVoceRigaPersona.scegli;
    final contenuto = conContorno
        ? _AzioneContorno(testo: azione!, inattiva: onAzione == null)
        : _SpuntaParola(testo: azione!, toccabile: onAzione != null);
    // container: un nodo suo, anche se inattiva o solo testo.
    if (!conContorno && onAzione == null) {
      return Semantics(container: true, label: etichetta, excludeSemantics: true, child: contenuto);
    }
    return Semantics(
      container: true,
      child: BaTouchable(
        semanticsLabel: etichetta,
        onTap: onAzione,
        raggio: conContorno ? BaPersoneTokens.azioneRaggio : 0,
        builder: (context, _) => contenuto,
      ),
    );
  }
}

/// L'azione con il contorno («Aggiungi», «Scegli»): altezza almeno `azioneAltezza`,
/// raggio `azioneRaggio` e non `roundedFull` (con il testo a capo la pillola cresce).
class _AzioneContorno extends StatelessWidget {
  const _AzioneContorno({required this.testo, required this.inattiva});

  final String testo;
  final bool inattiva;

  @override
  Widget build(BuildContext context) {
    // IntrinsicWidth: il contenitore centra il testo, e senza questo prenderebbe tutta la
    // riga del Wrap; così ha la larghezza della sua parola (e a capo, se non entra).
    return IntrinsicWidth(
      child: Container(
        constraints: const BoxConstraints(minHeight: BaPersoneTokens.azioneAltezza),
        padding: const EdgeInsets.symmetric(horizontal: BaSpazioTokens.l, vertical: BaSpazioTokens.s),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BaPersoneTokens.azioneRaggio),
          border: Border.all(color: BaColorTokens.filettoMarcato, width: BaPersoneTokens.azioneBordo),
        ),
        child: Text(
          testo,
          textAlign: TextAlign.center,
          style: BaTestoTokens.minore.copyWith(
            color: inattiva ? BaColorTokens.testoInattivo : BaColorTokens.testoPrimo,
          ),
        ),
      ),
    );
  }
}

/// La spunta disegnata e la parola («In lista», «Nell'invito»), senza contorno.
class _SpuntaParola extends StatelessWidget {
  const _SpuntaParola({required this.testo, required this.toccabile});

  final String testo;
  final bool toccabile;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: toccabile ? BaControlloTokens.areaMinima : 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomPaint(size: Size.square(BaSpazioTokens.l), painter: _PittoreSpunta()),
          const SizedBox(width: BaSpazioTokens.xs),
          Flexible(
            child: Text(testo, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
          ),
        ],
      ),
    );
  }
}

/// La spunta: due tratti, disegnati (come in `BaChipScelta`).
class _PittoreSpunta extends CustomPainter {
  const _PittoreSpunta();

  // I tre punti, in frazione del lato: l'inizio del tratto corto, il vertice in
  // basso e la fine del tratto lungo.
  static const Offset _inizio = Offset(0.18, 0.54);
  static const Offset _vertice = Offset(0.42, 0.78);
  static const Offset _fine = Offset(0.84, 0.26);

  @override
  void paint(Canvas canvas, Size size) {
    final l = size.width;
    final spunta = Path()
      ..moveTo(_inizio.dx * l, _inizio.dy * l)
      ..lineTo(_vertice.dx * l, _vertice.dy * l)
      ..lineTo(_fine.dx * l, _fine.dy * l);
    canvas.drawPath(
      spunta,
      Paint()
        ..color = BaColorTokens.testoSecondo
        ..style = PaintingStyle.stroke
        ..strokeWidth = BaCreazioneTokens.sceltaBordoScelta
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_PittoreSpunta vecchio) => false;
}

/// L'interruttore e, sotto, la sua parola (come in `BaInterruttoreRiga`, con la
/// forma di `BaPersoneTokens.consensoInterruttore*`).
class _Interruttore extends StatelessWidget {
  const _Interruttore({required this.acceso, required this.parola});

  final bool acceso;
  final String parola;

  @override
  Widget build(BuildContext context) {
    final colore = acceso ? BaColorTokens.azioneChiara : BaColorTokens.testoTerzo;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: BaPersoneTokens.consensoInterruttoreLarghezza,
          height: BaPersoneTokens.consensoInterruttoreAltezza,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BaRaggioTokens.pillola),
              border: Border.all(
                color: acceso ? BaColorTokens.azioneChiara : BaColorTokens.ascoltoGruppoBordo,
                width: acceso ? BaCodaTokens.interruttoreBordoAcceso : BaCodaTokens.interruttoreBordo,
              ),
              // Acceso: il fondo è sabbia300 a16, un colore piatto (task 032); spento, nessun fondo.
              color: acceso ? BaCodaTokens.interruttoreFondoAcceso : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: BaSpazioTokens.xxs),
              child: Align(
                alignment: acceso ? Alignment.centerRight : Alignment.centerLeft,
                child: DecoratedBox(
                  // Spento il pallino è a metà (task 032): il segno di stato è la posizione e la parola.
                  decoration: BoxDecoration(shape: BoxShape.circle, color: acceso ? colore : BaColorTokens.testoPrimo.withValues(alpha: BaCodaTokens.interruttorePallinoSpentoOpacita)),
                  child: const SizedBox.square(dimension: BaCodaTokens.interruttorePallino),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: BaSpazioTokens.xxs),
        Text(
          parola.toUpperCase(),
          textScaler: TextScaler.linear(BaScalaTokens.marcatore(context)),
          style: BaTestoTokens.marcatore.copyWith(color: colore),
        ),
      ],
    );
  }
}

/// «● Disponibile»: il punto pieno e la parola, in sabbia come lo stato acceso delle altre voci. Il punto
/// non scala col testo (è un segno, come la spunta); la parola sì, e va a capo se serve.
class _Disponibile extends StatelessWidget {
  const _Disponibile({required this.parola});

  final String parola;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, color: BaColorTokens.azioneChiara),
          child: SizedBox.square(dimension: BaScopertaTokens.disponibileSegnoLato),
        ),
        const SizedBox(width: BaSpazioTokens.xs),
        Flexible(child: Text(parola, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.azioneChiara))),
      ],
    );
  }
}
