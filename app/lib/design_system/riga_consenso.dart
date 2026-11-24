// BaRigaConsenso: il richiamo per persona (task 033, Inventario C4; prototipo 030:
// C3 «Chi puoi avvisare» e C5 «Chi può avvisarti»). Una persona con un
// interruttore: acceso o spento, con **la parola** («Acceso», «Spento») e non solo
// la posizione del pallino. È una `BaRigaPersona` con l'interruttore, per il
// principio del 030: nessun valore, qui, mostra lo stato di presenza di una persona né
// dove si trova; il richiamo parte **spento**, e il consenso è uno per persona.
//
// **Il richiamo parte spento:** [acceso] vale falso se non lo si dà.
//
// **La conferma prima di accendere è un foglio che compone il chiamante** (C4:
// «Avvisare Marta?»): toccare una riga spenta chiama `onCambia(true)`, e sta a chi
// usa il componente aprire il foglio e, alla conferma, passare `acceso: true`. Il
// componente non conosce il foglio e non decide niente: «solo per i DEN pubblici»
// e «solo fra persone aggiunte» sono frasi e regole del chiamante (proposte del 030,
// ancora aperte). Per lo screen reader è un interruttore (`toggled`).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'riga_persona.dart';

class BaRigaConsenso extends StatelessWidget {
  const BaRigaConsenso({
    super.key,
    required this.nome,
    this.alias,
    this.tinta = 0,
    this.sagoma = 0,
    this.acceso = false,
    required this.parolaAcceso,
    required this.parolaSpento,
    this.onCambia,
    this.semanticsLabel,
  });

  final String nome;

  /// L'alias che distingue due persone con lo stesso nickname.
  final String? alias;

  /// Gli indici della tinta e della sagoma, dal chiamante.
  final int tinta;
  final int sagoma;

  /// Spento di partenza.
  final bool acceso;

  /// Le parole dell'interruttore, dal chiamante («Acceso», «Spento»).
  final String parolaAcceso;
  final String parolaSpento;

  /// Chiamata col valore voluto. Per accendere, chi usa il componente apre prima
  /// la conferma. Nulla = inattiva.
  final ValueChanged<bool>? onCambia;

  /// Se manca: nome e alias. Lo stato lo dice `toggled`, non il testo.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return BaRigaPersona(
      nome: nome,
      alias: alias,
      tinta: tinta,
      sagoma: sagoma,
      acceso: acceso,
      parolaAcceso: parolaAcceso,
      parolaSpento: parolaSpento,
      onCambia: onCambia,
      azioneSemanticsLabel: semanticsLabel,
    );
  }
}
