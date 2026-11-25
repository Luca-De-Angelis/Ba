// Le persone di prova del prototipo (task 024c, prototipo 030): chi si può aggiungere, trovare
// nella rubrica, invitare e avvisare. **Nessuna persona è vera.** I nomi e gli alias sono quelli
// del 030 (Marta `@marta.v`, Davide `@davide.k`, Luca `@luca.r`, le due Sara `@sara.m` e
// `@sara.rossi`, Giulia dalla rubrica, non ancora su BA); le email e i numeri di prova non sono nel
// 030 (proposta del 024c: `@example.it` e `320 000 000N`), servono perché la ricerca filtra anche
// per quelli.
import 'package:flutter/widgets.dart';

import 'stato.dart';

/// Una persona che si può trovare: i suoi dati, se è già su BA, se la propone fra i suggeriti e se sta
/// nella rubrica del telefono di prova.
@immutable
class Contatto {
  const Contatto({
    required this.persona,
    this.alias,
    required this.email,
    required this.numero,
    this.suBa = true,
    this.suggerito = false,
    this.inRubrica = false,
  });

  final Persona persona;

  /// Il nome unico che distingue due persone con lo stesso nickname (`@sara.m`).
  final String? alias;
  final String email;
  final String numero;
  final bool suBa;
  final bool suggerito;
  final bool inRubrica;

  String get id => persona.id;
  String get nome => persona.nome;
}

const List<Contatto> contatti = [
  Contatto(
    persona: Persona('marta', 'Marta', 'M', 1, 1),
    alias: '@marta.v',
    email: 'marta.v@example.it',
    numero: '320 000 0001',
    suggerito: true,
    inRubrica: true,
  ),
  Contatto(
    persona: Persona('davide', 'Davide', 'D', 2, 2),
    alias: '@davide.k',
    email: 'davide.k@example.it',
    numero: '320 000 0002',
    suggerito: true,
    inRubrica: true,
  ),
  Contatto(
    persona: Persona('luca', 'Luca', 'L', 3, 3),
    alias: '@luca.r',
    email: 'luca.r@example.it',
    numero: '320 000 0003',
    suggerito: true,
  ),
  Contatto(persona: Persona('saram', 'Sara', 'S', 4, 4), alias: '@sara.m', email: 'sara.m@example.it', numero: '320 000 0004'),
  Contatto(persona: Persona('sararossi', 'Sara', 'S', 5, 0), alias: '@sara.rossi', email: 'sara.rossi@example.it', numero: '320 000 0005'),
  Contatto(
    persona: Persona('giulia', 'Giulia', 'G', 6, 1),
    email: 'giulia@example.it',
    numero: '320 000 0006',
    suBa: false,
    inRubrica: true,
  ),
];

Contatto? contattoPerId(String id) {
  for (final c in contatti) {
    if (c.id == id) return c;
  }
  return null;
}
