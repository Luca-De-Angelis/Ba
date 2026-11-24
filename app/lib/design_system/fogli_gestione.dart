// I fogli di gestione di un DEN (task 023b, prototipo 014 aggiornato dal 027):
// «Gestisci» (G1–G5) e il foglio del sotto-DEN (D1). Nessuna navigazione,
// nessuna logica di flusso: il design system non sa quale vista viene dopo, né
// se la persona ha il diritto di vedere questo foglio.
//
// **«Gestisci» è uno solo, per i DEN privati e per i pubblici creati da un
// utente** (D-043): nessun parametro li distingue. Il limite dei
// co-amministratori si mostra come un **numero che il chiamante dà** («0 di 1»):
// qui non c'è nessun parametro «livello», «piano» o «Pro».
//
// Come si passa da una vista all'altra: `BaFoglioGestisci` ha **un costruttore
// con nome per vista** e dentro un solo [BaFoglioPassi]. Il chiamante tiene lo
// stato e, quando la vista cambia, ricostruisce `BaFoglioGestisci.<vista>(…)` nello
// stesso punto dell'albero: il tipo del widget non cambia, quindi il foglio resta
// lo stesso e fa ciò che fa ogni cambio di passo (il focus va al titolo, il titolo
// è una regione viva, il corpo torna in alto). Ogni vista ha il suo [BaPassoFoglio.id].
// Che cosa fa «Chiudi» in una sotto-vista (chiude il foglio o torna al menu) non è
// scritto nei documenti: lo decide il chiamante.
//
// Le primarie: chiare come nel prototipo («Salva»), **attive («a filetto») per le
// azioni distruttive «Rimuovi» e «Termina il DEN»** (decisione del task 023b:
// `BaRegole` 1, la chiara solo dove l'app non può proseguire senza il gesto; qui
// c'è sempre «Non ora». È una differenza dal prototipo 014, da correggere nel
// design). «Aggiungi un co-amministratore» è attiva; al limite, inattiva.
//
// Il sotto-DEN (D1) è un foglio a parte: si apre dalla stanza, non da «Gestisci».
// L'Inventario lo nomina sotto `BaFoglioGestisci`: proposta del task 023b.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'campo_testo.dart';
import 'foglio.dart';
import 'foglio_passi.dart';
import 'pillola.dart';
import 'riga_persona.dart';
import 'riga_valore.dart';
import 'tokens.dart';

/// La stessa azione con la variante [predefinita], se il chiamante non ne ha
/// scelta una.
BaAzioneFoglio _conVariante(BaAzioneFoglio a, BaVariantePillola predefinita) => BaAzioneFoglio(
      testo: a.testo,
      semanticsLabel: a.semanticsLabel,
      onTap: a.onTap,
      variante: a.variante ?? predefinita,
    );

Widget _frase(String testo) => Text(
      testo,
      style: BaTestoTokens.corpo.copyWith(color: BaColorTokens.testoSecondo),
    );

Widget _righe(List<Widget> righe) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: righe);

class BaFoglioGestisci extends StatelessWidget {
  const BaFoglioGestisci._({super.key, required this.nome, required this.passo, required this.nonOra});

  /// Il menu (G1): le quattro voci, nell'ordine del prototipo. Ognuna è una
  /// [BaRigaValore] toccabile che il chiamante compone: **il limite dei
  /// co-amministratori è il valore di [coAmministratori]** («0 di 1»), un
  /// numero dato da lui. Nessuna primaria: c'è solo «Chiudi» ([nonOra]).
  BaFoglioGestisci.menu({
    Key? key,
    required String nome,
    required String titolo,
    required BaRigaValore descrizione,
    required BaRigaValore coAmministratori,
    required BaRigaValore persone,
    required BaRigaValore termina,
    required BaAzioneFoglio nonOra,
  }) : this._(
          key: key,
          nome: nome,
          nonOra: nonOra,
          passo: BaPassoFoglio(
            id: idMenu,
            titolo: titolo,
            corpo: [_righe([descrizione, coAmministratori, persone, termina])],
          ),
        );

  /// La descrizione (G5): lo stesso campo del passo C3 e «Salva» (chiara).
  BaFoglioGestisci.descrizione({
    Key? key,
    required String nome,
    required String titolo,
    required TextEditingController controller,
    required String etichetta,
    String? segnaposto,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    int minRighe = 3,
    required int maxRighe,
    required BaAzioneFoglio salva,
    required BaAzioneFoglio nonOra,
  }) : this._(
          key: key,
          nome: nome,
          nonOra: nonOra,
          passo: BaPassoFoglio(
            id: idDescrizione,
            titolo: titolo,
            corpo: [
              BaCampoTesto(
                controller: controller,
                focusNode: focusNode,
                etichetta: etichetta,
                segnaposto: segnaposto,
                minRighe: minRighe,
                maxRighe: maxRighe,
                onChanged: onChanged,
              ),
            ],
            azione: salva,
          ),
        );

  /// I co-amministratori con un posto libero (G2): la [frase], chi lo è già
  /// ([persone], anche nessuno), il [posto] fra cui scegliere (come per gli
  /// invitati: un widget che il chiamante riempie, oggi un `BaPuntoAggancio`) e
  /// «Aggiungi un co-amministratore» ([aggiungi]), attiva (a filetto).
  BaFoglioGestisci.coAmministratori({
    Key? key,
    required String nome,
    required String titolo,
    required String frase,
    List<BaRigaPersona> persone = const [],
    Widget? posto,
    required BaAzioneFoglio aggiungi,
    required BaAzioneFoglio nonOra,
  }) : this._(
          key: key,
          nome: nome,
          nonOra: nonOra,
          passo: BaPassoFoglio(
            id: idCoAmministratori,
            titolo: titolo,
            corpo: [
              _frase(frase),
              if (persone.isNotEmpty) _righe(persone),
              ?posto,
            ],
            azione: _conVariante(aggiungi, BaVariantePillola.attiva),
          ),
        );

  /// I co-amministratori al limite (G2 bis): chi lo è ([persone], con «Togli»),
  /// la [fraseLimite] (la dice il chiamante: «Hai raggiunto il limite di
  /// co-amministratori. Per aggiungerne un altro, togli Davide.») e l'azione
  /// **inattiva**: qui non c'è un `onTap`, quindi non si può toccare.
  BaFoglioGestisci.coAmministratoriAlLimite({
    Key? key,
    required String nome,
    required String titolo,
    required List<BaRigaPersona> persone,
    required String fraseLimite,
    required String aggiungi,
    String? aggiungiSemanticsLabel,
    required BaAzioneFoglio nonOra,
  }) : this._(
          key: key,
          nome: nome,
          nonOra: nonOra,
          passo: BaPassoFoglio(
            id: idCoAmministratori,
            titolo: titolo,
            corpo: [_righe(persone), _frase(fraseLimite)],
            azione: BaAzioneFoglio(
              testo: aggiungi,
              semanticsLabel: aggiungiSemanticsLabel ?? aggiungi,
              variante: BaVariantePillola.attiva,
            ),
          ),
        );

  /// Le persone nel DEN (G3): una [BaRigaPersona] per persona. «Rimuovi» c'è
  /// solo dove il chiamante la dà: chi è co-amministratore non l'ha.
  BaFoglioGestisci.persone({
    Key? key,
    required String nome,
    required String titolo,
    required List<BaRigaPersona> persone,
    required BaAzioneFoglio nonOra,
  }) : this._(
          key: key,
          nome: nome,
          nonOra: nonOra,
          passo: BaPassoFoglio(id: idPersone, titolo: titolo, corpo: [_righe(persone)]),
        );

  /// Una conferma (G3 bis «Rimuovere Marta?», G4 «Terminare il DEN?»): la
  /// conseguenza in una [frase] e l'[azione] col nome di ciò che fa. L'[id] lo
  /// dà il chiamante: due conferme diverse sono due viste. **L'azione è attiva
  /// (a filetto), non chiara**, perché è distruttiva e «Non ora» c'è sempre
  /// (`BaRegole` 1); il chiamante la può cambiare con `BaAzioneFoglio.variante`.
  BaFoglioGestisci.conferma({
    Key? key,
    required String nome,
    required Object id,
    required String titolo,
    required String frase,
    required BaAzioneFoglio azione,
    required BaAzioneFoglio nonOra,
  }) : this._(
          key: key,
          nome: nome,
          nonOra: nonOra,
          passo: BaPassoFoglio(
            id: id,
            titolo: titolo,
            corpo: [_frase(frase)],
            azione: _conVariante(azione, BaVariantePillola.attiva),
          ),
        );

  /// Gli id delle viste (la conferma ha quello che il chiamante le dà).
  static const Object idMenu = 'gestisci-menu';
  static const Object idDescrizione = 'gestisci-descrizione';
  static const Object idCoAmministratori = 'gestisci-co-amministratori';
  static const Object idPersone = 'gestisci-persone';

  /// Il nome del foglio per lo screen reader («Gestisci il DEN»), dal chiamante.
  final String nome;

  final BaPassoFoglio passo;

  /// «Chiudi» o «Non ora», in fondo a ogni vista.
  final BaAzioneFoglio nonOra;

  @override
  Widget build(BuildContext context) => BaFoglioPassi(nome: nome, passo: passo, nonOra: nonOra);
}

/// Il nuovo sotto-DEN (D1): il nome ([BaCampoTesto]), la regola («Fino a 8
/// persone. Sente il DEN e parla al proprio gruppo.»), la nota («Chi ne fa parte
/// lo scegli dopo, dalla stanza.»), «Crea il sotto-DEN» e «Non ora». I membri non
/// si scelgono qui. Non valida il nome: mostra l'[errore] che gli si dà.
class BaFoglioSottoDen extends StatelessWidget {
  const BaFoglioSottoDen({
    super.key,
    required this.titolo,
    required this.controller,
    required this.etichetta,
    this.segnaposto,
    this.errore,
    this.focusNode,
    this.onChanged,
    required this.frase,
    required this.nota,
    required this.crea,
    required this.nonOra,
  });

  final String titolo;
  final TextEditingController controller;
  final String etichetta;
  final String? segnaposto;
  final String? errore;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  /// La regola, in secondo piano.
  final String frase;

  /// La nota, in corpo minore.
  final String nota;

  /// Chiara: il gesto che crea (come nel prototipo).
  final BaAzioneFoglio crea;
  final BaAzioneFoglio nonOra;

  Widget _pillola(BaAzioneFoglio a, BaVariantePillola predefinita) => BaPillola(
        testo: a.testo,
        semanticsLabel: a.semanticsLabel,
        onTap: a.onTap,
        variante: a.variante ?? predefinita,
        estensione: const EdgeInsets.symmetric(vertical: BaControlloTokens.areaEstesa),
      );

  @override
  Widget build(BuildContext context) {
    return BaFoglio(
      semanticsLabel: titolo,
      corpo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titolo, style: BaTestoTokens.foglio.copyWith(color: BaColorTokens.testoPrimo)),
          const SizedBox(height: BaSpazioTokens.m),
          BaCampoTesto(
            controller: controller,
            focusNode: focusNode,
            etichetta: etichetta,
            segnaposto: segnaposto,
            errore: errore,
            onChanged: onChanged,
          ),
          const SizedBox(height: BaSpazioTokens.m),
          _frase(frase),
          const SizedBox(height: BaSpazioTokens.m),
          Text(nota, style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo)),
        ],
      ),
      azioni: [_pillola(crea, BaVariantePillola.chiara), _pillola(nonOra, BaVariantePillola.spenta)],
    );
  }
}
