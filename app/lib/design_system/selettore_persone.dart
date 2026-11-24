// BaSelettorePersone: il selettore delle persone (task 033, Inventario C4;
// prototipo 030: S1–S3). **Lo stesso componente** per gli invitati di un DEN
// privato (il passo «Invita», C4) e per il co-amministratore (G2): cambiano solo le
// parole («Invita» o «Scegli»; «Nell'invito» o «Scelto») e il limite. È il
// `Widget posto` che `BaPassiCreazione.invitati` e `BaFoglioGestisci.coAmministratori`
// accettano già: **le loro API non cambiano**.
//
// Dentro: la ricerca (`BaRicercaPersone`), un'intestazione opzionale («Persone che
// hai aggiunto»), una `BaRigaPersona` per persona e una frase di stato. Gli stati:
//   - **nessuno scelto**: tutte le righe con la parola per scegliere;
//   - **persone scelte**: le scelte con la spunta e la parola («Nell'invito»; toccandole
//     si tolgono), e la [frase] («2 persone nell'invito.»);
//   - **limite raggiunto**: con [limite] e tante persone scelte, le altre righe restano
//     **senza azione** e la [fraseLimite] dice come uscirne. Il limite è **un numero
//     che dà il chiamante**: qui non c'è nessun livello, piano o «Pro».
//
// **L'azione in fondo non è di questo componente:** è del foglio che lo contiene (come
// nei due passi già costruiti). Il selettore espone [haScelto] e [scelti]: chi lo usa
// lega a quello l'azione, **inattiva finché non si sceglie dove serve** («Aggiungi un
// co-amministratore»), e attiva sempre dove si può procedere senza (gli invitati: si
// può invitare anche dopo, ipotesi del 030).
//
// Nessuno stato «online», nessun luogo, nessun contatore che accumula: la frase è
// scritta dal chiamante. Una frase che cambia con le scelte è una regione viva
// cortese. Le righe sono quelle di `BaRigaPersona` (aree ≥ 44, parola e segno).
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'marcatore.dart';
import 'ricerca_persone.dart';
import 'riga_persona.dart';
import 'tokens.dart';

/// Una persona che si può scegliere: i suoi dati, se è già scelta e che cosa succede
/// al tocco (sceglierla o toglierla).
@immutable
class BaPersonaSelezionabile {
  const BaPersonaSelezionabile({
    required this.nome,
    this.alias,
    this.tinta = 0,
    this.sagoma = 0,
    this.scelta = false,
    this.onTap,
    this.semanticsLabel,
  });

  final String nome;
  final String? alias;
  final int tinta;
  final int sagoma;

  /// È già nell'invito (o è la persona scelta come co-amministratore).
  final bool scelta;

  /// Scegliere la persona o, se è già scelta, toglierla.
  final VoidCallback? onTap;

  /// L'etichetta del bottone per lo screen reader («Invita Marta»). Se manca: la parola.
  final String? semanticsLabel;
}

class BaSelettorePersone extends StatelessWidget {
  const BaSelettorePersone({
    super.key,
    required this.ricerca,
    this.intestazione,
    required this.persone,
    required this.parolaScegli,
    required this.parolaScelta,
    this.limite,
    this.frase,
    this.fraseLimite,
  });

  /// La ricerca, composta dal chiamante (controller, testi, errore di rete).
  final BaRicercaPersone ricerca;

  /// Un titolo di gruppo in marcatore («Persone che hai aggiunto»).
  final String? intestazione;

  /// Le persone da mostrare, già filtrate dal chiamante (`BaRicercaPersone.corrisponde`).
  final List<BaPersonaSelezionabile> persone;

  /// La parola per scegliere: «Invita» per gli invitati, «Scegli» per il co-amministratore.
  final String parolaScegli;

  /// La parola di una persona già scelta: «Nell'invito», «Scelto».
  final String parolaScelta;

  /// Quante persone si possono scegliere al più. Un numero dato dal chiamante,
  /// mai un livello. Nullo = nessun limite (gli invitati).
  final int? limite;

  /// La frase di stato («2 persone nell'invito.»); nulla = nessuna.
  final String? frase;

  /// La frase del limite raggiunto («Hai raggiunto il limite…»): sostituisce [frase].
  final String? fraseLimite;

  /// Quante persone sono scelte.
  int get scelti => persone.where((p) => p.scelta).length;

  /// Almeno una persona è scelta: lega a questo l'azione in fondo, dove serve.
  bool get haScelto => scelti > 0;

  /// Il limite è raggiunto: le altre persone non si possono più scegliere.
  bool get limiteRaggiunto => limite != null && scelti >= limite!;

  @override
  Widget build(BuildContext context) {
    final fraseMostrata = limiteRaggiunto && fraseLimite != null ? fraseLimite : frase;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ricerca,
        if (intestazione != null) ...[
          const SizedBox(height: BaSpazioTokens.m),
          Align(alignment: Alignment.centerLeft, child: BaMarcatore(testo: intestazione!)),
        ],
        const SizedBox(height: BaSpazioTokens.s),
        for (final p in persone)
          BaRigaPersona(
            nome: p.nome,
            alias: p.alias,
            tinta: p.tinta,
            sagoma: p.sagoma,
            voce: p.scelta ? BaVoceRigaPersona.nellInvito : BaVoceRigaPersona.scegli,
            azione: p.scelta ? parolaScelta : parolaScegli,
            // Al limite le altre righe restano senza azione: la scelta si toglie, non si aggiunge.
            onAzione: !p.scelta && limiteRaggiunto ? null : p.onTap,
            azioneSemanticsLabel: p.semanticsLabel,
          ),
        if (fraseMostrata != null) ...[
          const SizedBox(height: BaSpazioTokens.m),
          Semantics(
            liveRegion: true,
            child: Text(
              fraseMostrata,
              style: BaTestoTokens.corpo.copyWith(
                color: haScelto || limiteRaggiunto ? BaColorTokens.testoPrimo : BaColorTokens.testoSecondo,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
