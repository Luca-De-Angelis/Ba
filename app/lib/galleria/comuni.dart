// Pezzi comuni delle pagine della galleria (D-030). Strumento di sviluppo:
// testi fissi, niente l10n. Solo token per colori, misure e durate.
import 'package:flutter/widgets.dart';

import '../design_system/tokens.dart';
import '../design_system/touchable.dart';

/// Un comando della galleria: una pillola (a sua volta un [BaTouchable]) che
/// si accende e si spegne.
Widget galleriaInterruttore(String testo, bool acceso, VoidCallback onTap) {
  return BaTouchable(
    semanticsLabel: testo,
    onTap: onTap,
    builder: (context, stato) => Container(
      constraints: const BoxConstraints(minHeight: BaControlloTokens.areaMinima),
      padding: const EdgeInsets.symmetric(horizontal: BaSpazioTokens.l),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BaRaggioTokens.pillola),
        border: Border.all(
          color: acceso ? BaColorTokens.azioneAttivaBordo : BaColorTokens.filettoBase,
        ),
        gradient: acceso
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: BaColorTokens.azioneAttivaFondo,
              )
            : null,
      ),
      child: Text(testo, style: BaTestoTokens.azione),
    ),
  );
}

/// Titolo di sezione: marcatore maiuscolo.
Widget galleriaTitolo(String testo) {
  return Padding(
    padding: const EdgeInsets.only(bottom: BaSpazioTokens.m),
    child: Text(
      testo.toUpperCase(),
      style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo),
    ),
  );
}
