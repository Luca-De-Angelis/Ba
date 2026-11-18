// BaSchedaPersona: il contenuto di un foglio «scheda presenza» (002). In alto il
// nome e lo stato in una riga; poi le TRE righe fisse, sempre nello stesso
// ordine (muta questa voce, blocca, segnala); sotto, dopo un filetto, UNA riga
// per ogni azione nuova, nell'ordine in cui arriva. Il gruppo cresce verso il
// basso e il foglio scorre; le tre fisse non si muovono. Le azioni nuove
// riguardano la persona, non la stanza.
//
// La scheda non esegue niente da sola: ogni riga è una callback. I testi
// arrivano dal chiamante (il design system non conosce l10n).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'tokens.dart';
import 'touchable.dart';

/// Una riga di azione: un titolo e, se l'azione ha una conseguenza, la
/// conseguenza scritta sotto. È un [BaTouchable] a tutta larghezza: area
/// toccabile di almeno `areaMinima`, premuto, focus. La usano la scheda e il
/// foglio di «Altro».
class BaRigaAzione extends StatelessWidget {
  const BaRigaAzione({
    super.key,
    required this.titolo,
    this.spiegazione,
    this.onTap,
    this.semanticsLabel,
    this.altezzaMinima = BaSchedaPersonaTokens.rigaMinima,
  }) : assert(
         altezzaMinima >= BaControlloTokens.areaMinima,
         'una riga non scende mai sotto areaMinima',
       );

  final String titolo;

  /// Al più una riga di spiegazione (può andare a capo a testo grande).
  final String? spiegazione;

  /// Nullo = inattiva: nessun feedback, non si focalizza; la spiegazione resta
  /// scritta, perché dice perché.
  final VoidCallback? onTap;

  /// Se manca: titolo e spiegazione, uno di seguito all'altra.
  final String? semanticsLabel;

  /// Un minimo, non una misura: il testo grande alza la riga, mai la abbassa.
  final double altezzaMinima;

  @override
  Widget build(BuildContext context) {
    final inattiva = onTap == null;
    // container: ogni riga è un nodo suo per lo screen reader, anche quando è
    // inattiva (senza azione, un nodo non si separa da solo e si fonde col vicino).
    return Semantics(
      container: true,
      child: BaTouchable(
        semanticsLabel:
            semanticsLabel ??
            (spiegazione == null ? titolo : '$titolo. $spiegazione'),
        onTap: onTap,
        raggio: 0,
        builder: (context, stato) => Container(
          constraints: BoxConstraints(
            minHeight: altezzaMinima,
            minWidth: double.infinity,
          ),
          padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.s),
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: BaColorTokens.filettoDivisorio),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titolo,
                style: BaTestoTokens.controllo.copyWith(
                  color: inattiva
                      ? BaColorTokens.testoInattivo
                      : BaColorTokens.testoPrimo,
                ),
              ),
              if (spiegazione != null) ...[
                const SizedBox(height: BaSpazioTokens.xxs),
                Text(
                  spiegazione!,
                  style: BaTestoTokens.minore.copyWith(
                    color: BaColorTokens.testoTerzo,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Un'azione nuova della scheda: una riga dopo le tre fisse.
@immutable
class BaAzioneScheda {
  const BaAzioneScheda({
    required this.titolo,
    this.spiegazione,
    required this.onTap,
    this.semanticsLabel,
  });

  final String titolo;
  final String? spiegazione;
  final VoidCallback onTap;
  final String? semanticsLabel;
}

class BaSchedaPersona extends StatelessWidget {
  const BaSchedaPersona({
    super.key,
    required this.nome,
    required this.stato,
    required this.parla,
    required this.mutaTesto,
    required this.mutaNonDisponibile,
    required this.bloccaTesto,
    required this.segnalaTesto,
    this.onMuta,
    this.onBlocca,
    this.onSegnala,
    this.nuove = const [],
  });

  /// Il nome e lo stato («Microfono spento»), già composti dal chiamante.
  final String nome;
  final String stato;

  /// La persona sta parlando: solo allora si può mutare la sua voce (§7.12).
  final bool parla;

  final String mutaTesto;

  /// La riga di spiegazione sotto «Muta questa voce» quando non si può
  /// («Si può mutare solo mentre parla»).
  final String mutaNonDisponibile;
  final String bloccaTesto;
  final String segnalaTesto;

  final VoidCallback? onMuta;
  final VoidCallback? onBlocca;
  final VoidCallback? onSegnala;

  /// Le azioni nuove, una riga ciascuna, dopo le tre fisse e un filetto.
  final List<BaAzioneScheda> nuove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nome e stato in una riga: a testo grande vanno a capo.
        Padding(
          padding: const EdgeInsets.only(bottom: BaSpazioTokens.m),
          child: Wrap(
            spacing: BaSpazioTokens.m,
            runSpacing: BaSpazioTokens.xxs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                nome,
                style: BaTestoTokens.foglio.copyWith(
                  color: BaColorTokens.testoPrimo,
                ),
              ),
              Text(
                stato.toUpperCase(),
                textScaler: TextScaler.linear(BaScalaTokens.marcatore(context)),
                style: BaTestoTokens.marcatore.copyWith(
                  color: BaColorTokens.testoTerzo,
                ),
              ),
            ],
          ),
        ),
        // Le tre fisse, nell'ordine.
        BaRigaAzione(
          titolo: mutaTesto,
          spiegazione: parla ? null : mutaNonDisponibile,
          onTap: parla ? onMuta : null,
          altezzaMinima: BaSchedaPersonaTokens.rigaFissa,
        ),
        BaRigaAzione(
          titolo: bloccaTesto,
          onTap: onBlocca,
          altezzaMinima: BaSchedaPersonaTokens.rigaFissa,
        ),
        BaRigaAzione(
          titolo: segnalaTesto,
          onTap: onSegnala,
          altezzaMinima: BaSchedaPersonaTokens.rigaFissa,
        ),
        // Il gruppo delle azioni nuove: cresce verso il basso.
        for (final a in nuove)
          BaRigaAzione(
            titolo: a.titolo,
            spiegazione: a.spiegazione,
            onTap: a.onTap,
            semanticsLabel: a.semanticsLabel,
          ),
      ],
    );
  }
}
