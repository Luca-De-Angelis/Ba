// BaRicercaPersone: il campo di ricerca per aggiungere persone, per scegliere gli
// invitati e il co-amministratore (task 033, Inventario C4; prototipo 030:
// P1–P6, S1–S3). Sta sopra `BaCampoTesto`: una riga con la linea sotto, l'etichetta
// in marcatore sopra («Cerca») e, sotto, l'errore. Il testo (etichetta, segnaposto,
// frase d'errore) arriva dal chiamante.
//
// Stati: **vuoto**, **con testo** e **errore di rete** (la frase passa a
// `BaCampoTesto.errore`: linea, segno «!» e frase annunciata, mai il solo colore).
// «Nessun risultato», «Riprova» e «Invita con un link» sono della superficie che
// lo contiene, non del campo (proposta del task 033).
//
// **Filtra nickname, alias, email e numero, da due caratteri** (`ricercaCaratteriMin`,
// ipotesi del 030): il componente non ha la lista, quindi non filtra niente da sé.
// Avvisa chi lo usa con [onRicerca]: il testo, quando ha almeno due caratteri;
// **vuoto** sotto la soglia (= tornano i suggeriti). Per decidere chi corrisponde
// c'è [corrisponde], una funzione pura.
//
// L'altezza della riga è quella di `BaCampoTesto` (`campoAltezza`, 56: lo stesso
// valore di `BaPersoneTokens.ricercaAltezza`).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'campo_testo.dart';
import 'tokens.dart';

class BaRicercaPersone extends StatelessWidget {
  const BaRicercaPersone({
    super.key,
    required this.controller,
    required this.etichetta,
    this.segnaposto,
    this.focusNode,
    this.onRicerca,
    this.erroreRete,
    this.semanticsLabel,
  });

  final TextEditingController controller;

  /// L'etichetta in marcatore sopra la linea («Cerca»).
  final String etichetta;

  /// Ciò che si vede a campo vuoto («Nickname, alias, email o numero»).
  final String? segnaposto;

  final FocusNode? focusNode;

  /// Chiamata a ogni cambio: con il testo se ha almeno `ricercaCaratteriMin`
  /// caratteri, con una stringa vuota altrimenti.
  final ValueChanged<String>? onRicerca;

  /// L'errore di rete: una frase, già tradotta («Non riusciamo a cercare adesso…»).
  /// Nulla = nessun errore.
  final String? erroreRete;

  /// Se manca: [etichetta].
  final String? semanticsLabel;

  /// Se [testo] basta per filtrare: almeno `ricercaCaratteriMin` caratteri (senza
  /// gli spazi ai bordi).
  static bool attiva(String testo) => testo.trim().length >= BaPersoneTokens.ricercaCaratteriMin;

  /// Se una persona corrisponde alla ricerca [testo]: nickname, alias, email o
  /// numero la contengono, senza distinguere maiuscole né la «@» dell'alias né gli
  /// spazi del numero. Sotto la soglia corrisponde chiunque (nessun filtro).
  static bool corrisponde(
    String testo, {
    String? nickname,
    String? alias,
    String? email,
    String? numero,
  }) {
    if (!attiva(testo)) return true;
    String pulita(String s) => s.toLowerCase().replaceAll('@', '').replaceAll(RegExp(r'\s'), '');
    final cerca = pulita(testo);
    return [nickname, alias, email, numero].whereType<String>().any((c) => pulita(c).contains(cerca));
  }

  @override
  Widget build(BuildContext context) {
    return BaCampoTesto(
      controller: controller,
      focusNode: focusNode,
      etichetta: etichetta,
      segnaposto: segnaposto,
      errore: erroreRete,
      semanticsLabel: semanticsLabel,
      onChanged: (testo) => onRicerca?.call(attiva(testo) ? testo.trim() : ''),
    );
  }
}
