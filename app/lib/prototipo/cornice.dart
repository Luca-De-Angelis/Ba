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
// all'inizio) e una riga con i codici di prova. Le simulazioni degli eventi (qualcuno
// parla, si libera un posto, l'account viene chiuso…) arrivano con il 024b.
import 'package:flutter/widgets.dart';

import '../design_system/pillola.dart';
import '../design_system/tokens.dart';
import 'navigatore.dart';
import 'stato.dart';
import 'testi.dart';

const double _telefono = 360;
const double _tablet = 744;
const double _altezzaTelefono = 780;
const double _altezzaTablet = 1133;
const double _larghezzaPannello = 320;

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
            final pannello = SizedBox(
              width: larga ? _larghezzaPannello : strumento.larghezza,
              child: _Pannello(strumento: strumento, tornaAllInizio: tornaAllInizio),
            );
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
    final altezza = strumento.larghezza == _tablet ? _altezzaTablet : _altezzaTelefono;
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
        child: const Stack(
          children: [
            Positioned.fill(child: ProtoNavigatore()),
          ],
        ),
      ),
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
  final VoidCallback onTap;

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
