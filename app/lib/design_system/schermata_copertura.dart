// BaSchermataCopertura: la schermata che **copre tutto** quando l'account è chiuso
// dalla moderazione (task 029, Inventario C4; prototipo 027: B1 «Account chiuso»,
// B1 bis «Blocco temporaneo», B2 «Revisione richiesta»). Non è un foglio e non è
// dentro un foglio: riempie lo spazio che riceve (il chiamante la mette sopra
// tutto), con un fondo opaco, quindi niente di ciò che sta sotto resta toccabile.
//
// Dentro: il contenuto **scorre** (titolo, paragrafi, una riga opzionale) e
// **una sola azione**, chiara, resta ancorata in basso (T11): «Richiedi
// revisione» (`BaRegole` 1: è l'unico gesto). Dopo il tocco il chiamante passa
// [richiestaInviata] e l'azione diventa «Richiesta inviata»: **inattiva e spenta**,
// quindi non si tocca due volte, e il cambio si annuncia (regione viva: è un
// cambio di stato di chi usa l'app, D-034). Nessun «Esci», nessun segno d'errore,
// nessun conto alla rovescia: il fatto è nel testo.
//
// **Proposte del task 029** (i documenti tacciono):
//   - la [riga] (la durata del blocco: «Potrai rientrare il 21 novembre alle
//     21:40.», un fatto fermo, in primo piano) sta **dopo il primo paragrafo**,
//     come in B1 bis;
//   - la zona di stato in alto la lascia libera `MediaQuery.viewPadding`, e la
//     colonna è quella del layout (`BaLayoutTokens.larghezzaColonna`);
//   - i paragrafi sono `BaParagrafoPasso` di `foglio_passi.dart` (testo e
//     evidenza): lo stesso tipo dei passi dei fogli.
//
// **Differenza dal prototipo 027, da portare nel consolidamento del design:** il
// titolo è 28 nel prototipo; qui è `BaTestoTokens.stanza` (22), perché **il token
// del titolo di schermata a 28 non esiste**. La distanza fra le voci (18) è
// `BaSpazioTokens.l`.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'foglio_passi.dart';
import 'pillola.dart';
import 'tokens.dart';

class BaSchermataCopertura extends StatelessWidget {
  const BaSchermataCopertura({
    super.key,
    required this.titolo,
    this.paragrafi = const [],
    this.riga,
    required this.richiedi,
    this.richiediSemanticsLabel,
    this.onRichiedi,
    this.richiestaInviata = false,
    required this.inviata,
    this.inviataSemanticsLabel,
  });

  final String titolo;

  /// I paragrafi, in ordine; [BaParagrafoPasso.evidenza] li porta in primo piano.
  final List<BaParagrafoPasso> paragrafi;

  /// La riga opzionale (la durata del blocco), dopo il primo paragrafo.
  final String? riga;

  /// L'azione («Richiedi revisione»): una sola, chiara.
  final String richiedi;
  final String? richiediSemanticsLabel;

  /// Nullo = l'azione è inattiva. Con [richiestaInviata] lo è comunque.
  final VoidCallback? onRichiedi;

  /// La richiesta è partita: l'azione dice [inviata] ed è inattiva.
  final bool richiestaInviata;

  /// Il testo dopo il tocco («Richiesta inviata»).
  final String inviata;
  final String? inviataSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final larghezza = media.size.width;
    final margine = BaLayoutTokens.margine(larghezza);
    final colonna = BaLayoutTokens.larghezzaColonna(larghezza);
    const sopra = BaSpazioTokens.sezione;
    const sotto = BaSpazioTokens.s;

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: titolo,
      child: ColoredBox(
        color: BaColorTokens.fondoApp,
        child: Padding(
          padding: EdgeInsets.only(top: media.viewPadding.top),
          child: Column(
            children: [
              // Il contenuto scorre; centrato in verticale finché sta tutto.
              Expanded(
                child: LayoutBuilder(
                  builder: (context, c) => SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(margine, sopra, margine, sotto),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: c.maxHeight - sopra - sotto),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: colonna),
                          child: _Testi(titolo: titolo, paragrafi: paragrafi, riga: riga),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // L'azione resta ancorata in basso (T11).
              Padding(
                padding: EdgeInsets.fromLTRB(margine, BaSpazioTokens.m, margine, BaSpazioTokens.xxl + media.viewPadding.bottom),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: colonna),
                    child: Semantics(
                      container: true,
                      liveRegion: richiestaInviata,
                      child: BaPillola(
                        testo: richiestaInviata ? inviata : richiedi,
                        semanticsLabel: richiestaInviata
                            ? (inviataSemanticsLabel ?? inviata)
                            : (richiediSemanticsLabel ?? richiedi),
                        variante: richiestaInviata ? BaVariantePillola.spenta : BaVariantePillola.chiara,
                        onTap: richiestaInviata ? null : onRichiedi,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Il titolo (un'intestazione), i paragrafi e, dopo il primo, la riga.
class _Testi extends StatelessWidget {
  const _Testi({required this.titolo, required this.paragrafi, required this.riga});

  final String titolo;
  final List<BaParagrafoPasso> paragrafi;
  final String? riga;

  @override
  Widget build(BuildContext context) {
    Widget paragrafo(BaParagrafoPasso p) => Text(
          p.testo,
          style: BaTestoTokens.corpo.copyWith(
            color: p.evidenza ? BaColorTokens.testoPrimo : BaColorTokens.testoSecondo,
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(titolo, style: BaTestoTokens.stanza.copyWith(color: BaColorTokens.testoPrimo)),
        ),
        for (var i = 0; i < paragrafi.length; i++) ...[
          const SizedBox(height: BaSpazioTokens.l),
          paragrafo(paragrafi[i]),
          // La durata del blocco: un fatto fermo, dopo il primo paragrafo.
          if (i == 0 && riga != null) ...[
            const SizedBox(height: BaSpazioTokens.l),
            Text(riga!, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
          ],
        ],
        // Senza paragrafi la riga segue il titolo.
        if (paragrafi.isEmpty && riga != null) ...[
          const SizedBox(height: BaSpazioTokens.l),
          Text(riga!, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
        ],
      ],
    );
  }
}
