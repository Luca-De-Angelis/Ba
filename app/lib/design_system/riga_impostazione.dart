// BaRigaImpostazione: una riga delle impostazioni (task 029, Inventario C4).
// Quattro forme, ognuna con il suo costruttore:
//   - `.valore`      «Lingua · Italiano», «Persone bloccate · 3 persone ›»;
//   - `.interruttore` una riga con un interruttore (la parola «Acceso» o
//     «Spento» sta accanto, mai il solo colore);
//   - `.azione`      un'azione **con la conseguenza scritta** sotto («Torna
//     ascoltatore» e la frase di che cosa succede);
//   - `.negata`      lo stato **negato dal sistema** (il permesso rifiutato) con
//     la sua **via d'uscita** («Apri»).
//   - `.stato`       lo stato **di una scelta dell'utente** (task 034: «Sei disponibile a
//     chiacchierare»): testo a sinistra e azione («Spegni») a destra; dal testo a
//     `azioneSottoDa` l'azione va sotto la frase, a sinistra. Non è un permesso rifiutato.
//
// **Proposta del task 029:** le prime tre riusano i componenti che esistono
// (`BaRigaValore`, `BaInterruttoreRiga`, `BaRigaAzione`): una riga di impostazione
// non ha un aspetto suo, e riscriverne uno dividerebbe l'elenco in due. Solo
// `.negata` è nuova. Nessun prototipo ha una riga con interruttore (l'Inventario la
// elenca): è lì perché il componente la prevede. **Nessuno stato «deciso dalla
// stanza»** (un DEN non impone impostazioni) e **nessun interruttore della
// trascrizione** (D-003): il consenso a parlare si ritira con «Torna all'ascolto».
//
// Il negato sta nelle parole («Negate — senza queste non posso avvisarti»), non nel
// colore: nel prototipo 004 la riga non ha un colore d'errore. La via d'uscita è
// una `BaPillola` spenta alta almeno `areaMinima`, come l'uscita di `BaRigaCoda`.
// Il testo di ogni forma arriva dal chiamante; nessuna logica: dove va «Apri» o
// «Torna all'ascolto» è del prototipo navigabile (task 024).
//
// Valori che i token non hanno (segnalati nel report del task 029): l'altezza
// minima della riga negata (48 come `BaRigaValore`: `BaControlloTokens.coppia`).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'interruttore_riga.dart';
import 'pillola.dart';
import 'riga_valore.dart';
import 'scheda_persona.dart';
import 'tokens.dart';

class BaRigaImpostazione extends StatelessWidget {
  const BaRigaImpostazione._({super.key, required this.figlio});

  /// Titolo e valore («Lingua · Italiano»). Con [onTap] la riga apre qualcosa e,
  /// senza valore, mostra la freccia.
  BaRigaImpostazione.valore({
    Key? key,
    required String titolo,
    String? valore,
    String? sottotitolo,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this._(
          key: key,
          figlio: BaRigaValore(
            etichetta: titolo,
            valore: valore,
            sottotitolo: sottotitolo,
            onTap: onTap,
            semanticsLabel: semanticsLabel,
          ),
        );

  /// Una riga con un interruttore: le parole «Acceso» e «Spento» le dà il
  /// chiamante. Senza [onCambia] è inattiva.
  BaRigaImpostazione.interruttore({
    Key? key,
    required String titolo,
    String? descrizione,
    required bool acceso,
    required String parolaAcceso,
    required String parolaSpento,
    ValueChanged<bool>? onCambia,
    String? semanticsLabel,
  }) : this._(
          key: key,
          figlio: BaInterruttoreRiga(
            titolo: titolo,
            descrizione: descrizione,
            acceso: acceso,
            parolaAcceso: parolaAcceso,
            parolaSpento: parolaSpento,
            onCambia: onCambia,
            semanticsLabel: semanticsLabel,
          ),
        );

  /// Un'azione con la sua **conseguenza scritta** sotto: chi tocca sa che cosa
  /// succede prima di toccare.
  BaRigaImpostazione.azione({
    Key? key,
    required String titolo,
    required String conseguenza,
    required VoidCallback? onTap,
    String? semanticsLabel,
  }) : this._(
          key: key,
          figlio: BaRigaAzione(
            titolo: titolo,
            spiegazione: conseguenza,
            onTap: onTap,
            semanticsLabel: semanticsLabel,
          ),
        );

  /// Lo stato negato dal sistema: il [titolo] («Notifiche», «Microfono»), la
  /// [frase] che dice come stanno le cose e che cosa non si può fare («Negate —
  /// senza queste non posso avvisarti») e la via d'uscita [apri] («Apri»), che il
  /// chiamante collega alle impostazioni del sistema. Senza [onApri] è inattiva.
  BaRigaImpostazione.negata({
    Key? key,
    required String titolo,
    required String frase,
    required String apri,
    VoidCallback? onApri,
    String? apriSemanticsLabel,
  }) : this._(
          key: key,
          figlio: _Negata(
            titolo: titolo,
            frase: frase,
            apri: apri,
            onApri: onApri,
            apriSemanticsLabel: apriSemanticsLabel,
          ),
        );

  /// Lo stato di una scelta dell'utente (non un permesso negato): [titolo] («Sei disponibile a
  /// chiacchierare»), [frase] («Compari fra le persone da invitare.») e l'[azione] («Spegni»).
  /// A testo normale il testo sta a sinistra e l'azione a destra; da `azioneSottoDa` (1,3) l'azione
  /// sta sotto la frase, a sinistra. Senza [onAzione] è inattiva.
  BaRigaImpostazione.stato({
    Key? key,
    required String titolo,
    required String frase,
    required String azione,
    VoidCallback? onAzione,
    String? semanticsLabel,
  }) : this._(
          key: key,
          figlio: _Stato(titolo: titolo, frase: frase, azione: azione, onAzione: onAzione, azioneSemanticsLabel: semanticsLabel),
        );

  final Widget figlio;

  @override
  Widget build(BuildContext context) => figlio;
}

class _Negata extends StatelessWidget {
  const _Negata({
    required this.titolo,
    required this.frase,
    required this.apri,
    required this.onApri,
    required this.apriSemanticsLabel,
  });

  final String titolo;
  final String frase;
  final String apri;
  final VoidCallback? onApri;
  final String? apriSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: BaControlloTokens.coppia, minWidth: double.infinity),
      padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.s),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BaColorTokens.filettoDivisorio)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: BaSpazioTokens.m,
        runSpacing: BaSpazioTokens.s,
        children: [
          Semantics(
            container: true,
            label: '$titolo. $frase',
            excludeSemantics: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(titolo, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
                const SizedBox(height: BaSpazioTokens.xxs),
                Text(frase, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
              ],
            ),
          ),
          // container: la via d'uscita è un nodo suo, anche se inattiva.
          Semantics(
            container: true,
            child: IntrinsicWidth(
              child: BaPillola(
                testo: apri,
                semanticsLabel: apriSemanticsLabel ?? apri,
                variante: BaVariantePillola.spenta,
                onTap: onApri,
                allarga: false,
                altezzaMinima: BaControlloTokens.areaMinima,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// La riga di stato di una scelta (`.stato`): come `_Negata` nei token e nella semantica (titolo e
/// frase letti insieme, l'azione un pulsante suo), ma a testo normale l'azione sta **a destra** sulla
/// stessa riga; da `azioneSottoDa` sta sotto la frase, a sinistra (la regola del 036).
class _Stato extends StatelessWidget {
  const _Stato({
    required this.titolo,
    required this.frase,
    required this.azione,
    required this.onAzione,
    required this.azioneSemanticsLabel,
  });

  final String titolo;
  final String frase;
  final String azione;
  final VoidCallback? onAzione;
  final String? azioneSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final testo = Semantics(
      container: true,
      label: '$titolo. $frase',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(titolo, style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoPrimo)),
          const SizedBox(height: BaSpazioTokens.xxs),
          Text(frase, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
        ],
      ),
    );
    // container: l'azione è un nodo suo, anche se inattiva.
    final pulsante = Semantics(
      container: true,
      child: IntrinsicWidth(
        child: BaPillola(
          testo: azione,
          semanticsLabel: azioneSemanticsLabel ?? azione,
          variante: BaVariantePillola.spenta,
          onTap: onAzione,
          allarga: false,
          altezzaMinima: BaControlloTokens.areaMinima,
        ),
      ),
    );
    final sotto = BaScalaTokens.testo(context) >= BaPersoneTokens.azioneSottoDa;
    return Container(
      constraints: const BoxConstraints(minHeight: BaControlloTokens.coppia, minWidth: double.infinity),
      padding: const EdgeInsets.symmetric(vertical: BaSpazioTokens.s),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BaColorTokens.filettoDivisorio)),
      ),
      child: sotto
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [testo, const SizedBox(height: BaSpazioTokens.s), pulsante],
            )
          : Row(
              // In alto, accanto al titolo; IntrinsicHeight perché la pillola (Container con alignment) in una riga
              // con altezza limitata si allungherebbe fino al tetto (misurato con il font vero, 360 dp).
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Expanded(child: testo), const SizedBox(width: BaSpazioTokens.m), IntrinsicHeight(child: pulsante)],
            ),
    );
  }
}
