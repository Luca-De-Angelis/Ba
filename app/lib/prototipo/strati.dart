// Gli strati sopra le pagine (task 024b): il banner delle notifiche (015 K3 e K7) e la
// copertura dell'account chiuso (027 B1, B1 bis, B2). Stanno nella cornice, sopra il
// Navigator. Il banner è **una riga senza azioni** (D-025) che al tocco porta dove deve; non
// scompare da solo (niente timer): lo toglie il tocco o il prossimo evento.
import 'package:flutter/widgets.dart';

import '../design_system/foglio_passi.dart';
import '../design_system/schermata_copertura.dart';
import '../design_system/tokens.dart';
import '../design_system/touchable.dart';
import 'fogli_coda.dart';
import 'stato.dart';
import 'testi.dart';

/// Il banner in cima alla cornice.
class BannerNotifica extends StatelessWidget {
  const BannerNotifica({super.key, required this.banner});

  final BannerProto banner;

  static String testo(StatoProto stato, BannerProto b) {
    final nome = stato.denPerId(b.den)?.nome ?? '';
    return b.tipo == TipoBanner.postoLibero ? T.bannerPosto(nome) : T.bannerRichiamo(T.ciccio, nome);
  }

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final margine = BaLayoutTokens.margine(MediaQuery.of(context).size.width);
    final frase = testo(stato, banner);
    return Padding(
      padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.m, margine, 0),
      child: Semantics(
        liveRegion: true,
        child: BaTouchable(
          semanticsLabel: frase,
          onTap: () => usaBanner(stato),
          raggio: BaRaggioTokens.foglio,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: BaSpazioTokens.md, vertical: BaSpazioTokens.m),
            decoration: BoxDecoration(
              color: BaColorTokens.fondoApp,
              borderRadius: BorderRadius.circular(BaRaggioTokens.foglio),
              border: Border.all(color: BaColorTokens.filettoMarcato),
            ),
            child: Text(frase, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
          ),
        ),
      ),
    );
  }
}

/// Il tocco sul banner: porta nel DEN se si è nell'elenco; se si è già in una stanza, «Vuoi passare di qua?»
/// (K6: si partecipa a un solo DEN alla volta, D-042); se si è già lì, toglie solo il banner.
void usaBanner(StatoProto stato) {
  final b = stato.banner;
  if (b == null) return;
  stato.togliBanner();
  final d = stato.denPerId(b.den);
  if (d == null || stato.denCorrente?.id == d.id) return;
  if (stato.denCorrente == null) {
    stato.entraInDen(d);
    return;
  }
  final contesto = stato.chiaveNavigatore.currentContext;
  if (contesto == null) return;
  apriPassaDiQua(
    contesto,
    verso: d,
    titolo: b.tipo == TipoBanner.postoLibero ? T.passaTitolo(d.nome) : T.richiamoTitolo(T.ciccio, d.nome),
    primo: b.tipo == TipoBanner.postoLibero ? T.passaP1 : T.richiamoP1,
  );
}

/// L'account chiuso (B1), il blocco temporaneo (B1 bis) e la revisione richiesta (B2): una
/// copertura sopra tutto, con una sola azione.
class CoperturaAccount extends StatelessWidget {
  const CoperturaAccount({super.key, required this.chiusura});

  final Chiusura chiusura;

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final inviata = stato.revisioneRichiesta;
    final chiuso = chiusura == Chiusura.chiuso;
    return BaSchermataCopertura(
      titolo: inviata ? T.revisioneTitolo : (chiuso ? T.chiusoTitolo : T.sospesoTitolo),
      paragrafi: inviata
          ? const [BaParagrafoPasso(T.revisioneP1)]
          : (chiuso
              ? const [BaParagrafoPasso(T.chiusoP1), BaParagrafoPasso(T.chiusoP2)]
              : const [BaParagrafoPasso(T.sospesoP1), BaParagrafoPasso(T.sospesoP2)]),
      riga: !inviata && !chiuso ? T.sospesoRiga : null,
      richiedi: T.richiediRevisione,
      onRichiedi: stato.richiediRevisione,
      richiestaInviata: inviata,
      inviata: T.richiestaInviata,
    );
  }
}
