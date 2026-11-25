// La cornice e il pannello dello strumento (task 024): il prototipo è una pagina web
// con **una cornice da telefono** al centro e, **fuori dalla cornice, un pannello
// dello strumento**. Quello che sta nella cornice è il prodotto; il pannello no
// (D-030: il web è uno strumento di sviluppo e di dimostrazione, non una piattaforma
// di prodotto).
//
// La cornice è larga 360 dp (il dispositivo di riferimento, D-022) o 744 (il tablet,
// D-027): una scatola con la sua larghezza, il suo testo di sistema (1,0 o 2,0) e il
// suo «riduci movimento», che sono override di `MediaQuery` e li leggono tutti i
// componenti. Le misure della cornice e del pannello sono dello strumento, non del
// prodotto: stanno qui come costanti, come nella galleria.
//
// Il pannello ha i comandi dello strumento (testo, movimento, larghezza, tornare
// all'inizio), una riga con i codici di prova e, dal 024b, le **simulazioni** degli eventi
// (qualcuno parla, si libera un posto, l'account viene chiuso…): ogni tasto è un colpo solo,
// ripetibile; niente tempo che passa. Gli strati sopra le pagine (banner, schermo bloccato,
// account chiuso) stanno nella cornice.
import 'package:flutter/widgets.dart';

import '../design_system/pillola.dart';
import '../design_system/tokens.dart';
import 'navigatore.dart';
import 'schermo_bloccato.dart';
import 'stato.dart';
import 'strati.dart';
import 'testi.dart';

const double _telefono = 360;
const double _tablet = 744;
// 896: l'altezza di un telefono alto (414 × 896); sul palco, con la barra a tre posti e «Altro» e
// il testo a 2,0, la stanza non entra in meno.
const double _altezzaTelefono = 896;
const double _altezzaTablet = 1133;
// A testo 2,0 la stanza con una nota lunga (il posto offerto, la linea persa) non entra in 896: un
// telefono molto alto. Un telefono vero scorrerebbe; la cornice, qui, cresce.
const double _altezzaTelefonoTestoGrande = 1200;
const double _larghezzaPannello = 320;

double _altezza(Strumento s) =>
    s.larghezza == _tablet ? _altezzaTablet : (s.testo > 1.0 ? _altezzaTelefonoTestoGrande : _altezzaTelefono);

/// Le impostazioni dello **strumento**: non sono prodotto e non fanno parte dello
/// stato finto.
class Strumento extends ChangeNotifier {
  double testo = 1.0;
  bool riduciMovimento = false;
  double larghezza = _telefono;

  void cambiaTesto() {
    testo = testo == 1.0 ? BaScalaTokens.maxTesto : 1.0;
    notifyListeners();
  }

  void cambiaMovimento() {
    riduciMovimento = !riduciMovimento;
    notifyListeners();
  }

  void cambiaLarghezza() {
    larghezza = larghezza == _telefono ? _tablet : _telefono;
    notifyListeners();
  }
}

/// L'applicazione del prototipo: lo stato finto, lo strumento, la cornice e il
/// pannello.
class PrototipoApp extends StatefulWidget {
  const PrototipoApp({super.key});

  @override
  State<PrototipoApp> createState() => _PrototipoAppState();
}

class _PrototipoAppState extends State<PrototipoApp> {
  StatoProto _stato = StatoProto();
  final Strumento _strumento = Strumento();

  /// Cambia a ogni «Torna all'inizio»: tutto ciò che sta nella cornice riparte.
  Key _chiave = UniqueKey();

  void _tornaAllInizio() {
    setState(() {
      _stato.dispose();
      _stato = StatoProto();
      _chiave = UniqueKey();
    });
  }

  @override
  void dispose() {
    _stato.dispose();
    _strumento.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: BaColorTokens.fondoApp,
      textStyle: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo),
      pageRouteBuilder: <R>(settings, builder) => PageRouteBuilder<R>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: ProtoScope(
        key: _chiave,
        stato: _stato,
        child: _Schermo(strumento: _strumento, tornaAllInizio: _tornaAllInizio),
      ),
    );
  }
}

/// La finestra: la cornice e il pannello, uno accanto all'altro se c'è posto.
class _Schermo extends StatelessWidget {
  const _Schermo({required this.strumento, required this.tornaAllInizio});

  final Strumento strumento;
  final VoidCallback tornaAllInizio;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BaColorTokens.fondoApp,
      child: LayoutBuilder(
        builder: (context, vincoli) => ListenableBuilder(
          listenable: strumento,
          builder: (context, _) {
            final larga = vincoli.maxWidth >= strumento.larghezza + _larghezzaPannello + 3 * BaSpazioTokens.xxl;
            final cornice = _Cornice(strumento: strumento);
            final pannelloInterno = _Pannello(strumento: strumento, tornaAllInizio: tornaAllInizio);
            // Accanto alla cornice il pannello scorre da solo, alto quanto lei: con le simulazioni è lungo.
            final pannello = larga
                ? SizedBox(
                    width: _larghezzaPannello,
                    height: _altezza(strumento),
                    child: SingleChildScrollView(child: pannelloInterno),
                  )
                : SizedBox(width: strumento.larghezza, child: pannelloInterno);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(BaSpazioTokens.xxl),
              child: Center(
                child: larga
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [cornice, const SizedBox(width: BaSpazioTokens.xxl), pannello],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [cornice, const SizedBox(height: BaSpazioTokens.xxl), pannello],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// La cornice da telefono: ciò che sta dentro è il prodotto.
class _Cornice extends StatelessWidget {
  const _Cornice({required this.strumento});

  final Strumento strumento;

  @override
  Widget build(BuildContext context) {
    final base = MediaQuery.of(context);
    final altezza = _altezza(strumento);
    return Container(
      width: strumento.larghezza,
      height: altezza,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: BaColorTokens.fondoApp,
        border: Border.all(color: BaColorTokens.filettoMarcato),
        borderRadius: BorderRadius.circular(BaRaggioTokens.foglio),
      ),
      child: MediaQuery(
        data: base.copyWith(
          size: Size(strumento.larghezza, altezza),
          textScaler: TextScaler.linear(strumento.testo),
          disableAnimations: strumento.riduciMovimento,
          padding: EdgeInsets.zero,
          viewPadding: EdgeInsets.zero,
          viewInsets: EdgeInsets.zero,
        ),
        child: const _Strati(),
      ),
    );
  }
}

/// Le pagine e, sopra, il banner, lo schermo bloccato simulato e la copertura dell'account chiuso.
class _Strati extends StatelessWidget {
  const _Strati();

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final banner = stato.banner;
    final coperto = stato.schermoBloccato || stato.chiusura != null;
    return Stack(
      children: [
        // Sotto uno strato che copre tutto, le pagine non si toccano, non prendono il focus e non si leggono.
        Positioned.fill(
          child: ExcludeSemantics(
            excluding: coperto,
            child: ExcludeFocus(excluding: coperto, child: const ProtoNavigatore()),
          ),
        ),
        if (banner != null && !stato.schermoBloccato)
          Positioned(top: 0, left: 0, right: 0, child: BannerNotifica(banner: banner)),
        if (stato.schermoBloccato) const Positioned.fill(child: SchermoBloccato()),
        if (stato.chiusura != null) Positioned.fill(child: CoperturaAccount(chiusura: stato.chiusura!)),
      ],
    );
  }
}

/// Il pannello dello strumento, **fuori** dalla cornice.
class _Pannello extends StatelessWidget {
  const _Pannello({required this.strumento, required this.tornaAllInizio});

  final Strumento strumento;
  final VoidCallback tornaAllInizio;

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(T.strumentoTitolo, style: BaTestoTokens.stanza.copyWith(color: BaColorTokens.testoPrimo)),
        const SizedBox(height: BaSpazioTokens.s),
        Text(T.strumentoNota, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
        const SizedBox(height: BaSpazioTokens.l),
        Wrap(
          spacing: BaControlloTokens.gapCoppia,
          runSpacing: BaControlloTokens.gapCoppia,
          children: [
            _Comando(
              testo: '${T.strumentoLarghezza} ${strumento.larghezza.toInt()}',
              acceso: strumento.larghezza == _tablet,
              onTap: strumento.cambiaLarghezza,
            ),
            _Comando(
              testo: '${T.strumentoTesto} ${strumento.testo == 1.0 ? '1,0' : '2,0'}',
              acceso: strumento.testo != 1.0,
              onTap: strumento.cambiaTesto,
            ),
            _Comando(testo: T.strumentoRiduci, acceso: strumento.riduciMovimento, onTap: strumento.cambiaMovimento),
            _Comando(testo: T.strumentoTorna, acceso: false, onTap: tornaAllInizio),
          ],
        ),
        const SizedBox(height: BaSpazioTokens.l),
        // I codici di prova: nessun codice vero, e il pannello non è il prodotto.
        Text(T.strumentoCodici, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
        const SizedBox(height: BaSpazioTokens.l),
        _Simulazioni(stato: stato),
        const SizedBox(height: BaSpazioTokens.l),
        Text(
          '${stato.account.name} · ${stato.corrente.pagina.name}'
          '${stato.denCorrente == null ? '' : ' · ${stato.ruolo.name}'}',
          style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo),
        ),
      ],
    );
  }
}

/// Un comando del pannello: una pillola spenta, a filetto quando è acceso.
class _Comando extends StatelessWidget {
  const _Comando({required this.testo, required this.acceso, required this.onTap});

  final String testo;
  final bool acceso;

  /// Nullo = inattivo: la ragione sta scritta sotto i tasti.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BaPillola(
      testo: testo,
      semanticsLabel: testo,
      variante: acceso ? BaVariantePillola.attiva : BaVariantePillola.spenta,
      onTap: onTap,
      allarga: false,
      altezzaMinima: BaControlloTokens.areaMinima,
    );
  }
}

/// Le simulazioni: un tasto per evento, **a un colpo**, senza timer. Ciò che nei documenti scade
/// da solo ha un secondo tasto («il posto scade»). Un tasto senza niente da simulare è inattivo e
/// la sua ragione sta scritta sotto.
class _Simulazioni extends StatelessWidget {
  const _Simulazioni({required this.stato});

  final StatoProto stato;

  @override
  Widget build(BuildContext context) {
    final ragioni = <String>[];
    VoidCallback? se(bool vale, VoidCallback azione, String ragione) {
      if (vale) return azione;
      ragioni.add(ragione);
      return null;
    }

    final inStanza = stato.denCorrente != null;
    final altri = stato.palco.any((p) => p.id != 'io');
    final comandi = <Widget>[
      _Comando(
        testo: T.simParla,
        acceso: stato.parla != null,
        onTap: se(inStanza && altri, stato.qualcunoParla, '«${T.simParla}»: serve una stanza con qualcuno sul palco'),
      ),
      _Comando(
        testo: T.simLiberaPosto,
        acceso: stato.posto == Posto.offerto,
        onTap: se(stato.puoLiberarePosto, stato.siLiberaUnPosto, '«${T.simLiberaPosto}»: serve una coda (palco pieno, «Mettiti in coda»)'),
      ),
      _Comando(
        testo: T.simPostoScade,
        acceso: stato.posto == Posto.scaduto,
        onTap: se(stato.puoScadere, stato.postoScade, '«${T.simPostoScade}»: serve un posto offerto o la linea persa'),
      ),
      _Comando(
        testo: T.simPerdoLinea,
        acceso: stato.lineaPersa,
        onTap: se(stato.puoPerdereLinea, stato.perdoLaLinea, '«${T.simPerdoLinea}»: serve essere sul palco'),
      ),
      _Comando(
        testo: T.simTornoInLinea,
        acceso: false,
        onTap: se(stato.lineaPersa, stato.tornoInLinea, '«${T.simTornoInLinea}»: serve aver perso la linea'),
      ),
      _Comando(testo: T.simRichiamo, acceso: stato.banner?.tipo == TipoBanner.richiamo, onTap: stato.arrivaUnRichiamo),
      _Comando(testo: T.simChiuso, acceso: stato.chiusura == Chiusura.chiuso, onTap: () => stato.chiudiAccount(Chiusura.chiuso)),
      _Comando(testo: T.simSospeso, acceso: stato.chiusura == Chiusura.sospeso, onTap: () => stato.chiudiAccount(Chiusura.sospeso)),
      if (stato.chiusura != null) _Comando(testo: T.simRiapri, acceso: false, onTap: stato.riapriAccount),
      _Comando(testo: T.simCreazione, acceso: stato.creazioneFallisce, onTap: stato.armaFallimentoCreazione),
      _Comando(testo: T.simMicConsentito, acceso: stato.permessoMic, onTap: () => stato.impostaPermessoMic(true)),
      _Comando(testo: T.simMicNegato, acceso: !stato.permessoMic, onTap: () => stato.impostaPermessoMic(false)),
      _Comando(
        testo: T.simBloccato,
        acceso: stato.schermoBloccato,
        onTap: se(stato.puoBloccareLoSchermo, stato.bloccaLoSchermo, '«${T.simBloccato}»: serve una stanza aperta'),
      ),
      _Comando(testo: T.simCapacita, acceso: stato.capacitaAspettare, onTap: stato.cambiaCapacita),
    ];
    const piccolo = BaTestoTokens.minore;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(T.simulazioniTitolo, style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo)),
        const SizedBox(height: BaSpazioTokens.s),
        Wrap(spacing: BaControlloTokens.gapCoppia, runSpacing: BaControlloTokens.gapCoppia, children: comandi),
        const SizedBox(height: BaSpazioTokens.s),
        // Il richiamo: chi lo manda e per quali DEN (proposta 030).
        Text(T.simRichiamoNota, style: piccolo.copyWith(color: BaColorTokens.testoSecondo)),
        for (final r in ragioni) Text(r, style: piccolo.copyWith(color: BaColorTokens.testoTerzo)),
      ],
    );
  }
}
