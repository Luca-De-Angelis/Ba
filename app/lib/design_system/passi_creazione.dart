// BaPassiCreazione: i passi di «Crea un DEN» (task 023b, prototipo 014 aggiornato
// dal 027: C1–C5 e S2). Sono **valori** [BaPassoFoglio] che il chiamante dà allo
// stesso [BaFoglioPassi] di sempre, non un widget: il percorso da ascoltatore è
// R1 → P2 → P3 → R2 → C1 → … → C5, un foglio solo che cresce (T11). Se C1–C5
// fossero un widget a parte, il passaggio da R2 a C1 cambierebbe il tipo del
// widget, lo stato (focus e regione viva) si perderebbe e C1 sarebbe trattato
// come un primo passo.
//
// **Il design system non sa quale passo viene dopo.** Nessuna navigazione,
// nessuna validazione, nessun timer: il privato ha il passo «invitati» e il
// pubblico no, ma lo decide il chiamante. Tutti i testi arrivano dal chiamante, e
// con loro l'errore da mostrare (il componente mostra l'errore che riceve).
//
// La primaria è chiara per default, come nel prototipo (il gesto che nessuno
// può fare al posto della persona, `BaRegole` 1); si cambia con
// `BaAzioneFoglio.variante`. «Non ora» lo mette sempre `BaFoglioPassi`.
//
// Questo file non definisce widget pubblici: per il test sulla documentazione è
// fra gli esenti (come `forma.dart`), con questo motivo.
//
// Importa solo widgets.dart: nessuna eccezione.
import 'package:flutter/widgets.dart';

import 'campo_testo.dart';
import 'chip_scelta.dart';
import 'foglio.dart';
import 'foglio_passi.dart';
import 'messaggio.dart';
import 'punto_aggancio.dart';
import 'riga_valore.dart';
import 'scelta_den.dart';
import 'tokens.dart';

abstract final class BaPassiCreazione {
  /// Gli id dei passi: il chiamante li può confrontare, il foglio li usa per
  /// sapere che il passo è cambiato.
  static const Object idTipo = 'crea-tipo';
  static const Object idNome = 'crea-nome';
  static const Object idDettagli = 'crea-dettagli';
  static const Object idInvitati = 'crea-invitati';
  static const Object idRiepilogo = 'crea-riepilogo';
  static const Object idNonCreato = 'crea-non-creato';

  /// Tipo (C1, C1 bis): le opzioni, la [scelta] (nulla = nessuna ancora) e la
  /// [fraseSotto], che cambia con la scelta. Il componente non sa che cosa si
  /// sceglie: la frase del pubblico **non** dice «senza amministratore» (D-043)
  /// perché il chiamante non gliela dà.
  static BaPassoFoglio tipo({
    required String titolo,
    required List<BaOpzioneScelta> opzioni,
    required int? scelta,
    required ValueChanged<int> onScelta,
    String? fraseSotto,
    required BaAzioneFoglio azione,
  }) =>
      BaPassoFoglio(
        id: idTipo,
        titolo: titolo,
        corpo: [BaSceltaDen(opzioni: opzioni, scelta: scelta, onScelta: onScelta, fraseSotto: fraseSotto)],
        azione: azione,
      );

  /// Nome (C2, C2 bis, C2 ter): un [BaCampoTesto] e, sotto, il campo «Quando»
  /// **spento**. [quando] è un [BaPuntoAggancio] (il tipo c'è perché il «Quando»
  /// non diventi per sbaglio un controllo: non si tocca e non prende il focus).
  /// Non valida il nome: mostra l'[errore] che gli si dà («Scrivi un nome per il
  /// DEN», «C'è già un DEN con questo nome…»).
  static BaPassoFoglio nome({
    required String titolo,
    required TextEditingController controller,
    required String etichetta,
    String? segnaposto,
    String? errore,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    required BaPuntoAggancio quando,
    required BaAzioneFoglio azione,
  }) =>
      BaPassoFoglio(
        id: idNome,
        titolo: titolo,
        corpo: [
          BaCampoTesto(
            controller: controller,
            focusNode: focusNode,
            etichetta: etichetta,
            segnaposto: segnaposto,
            errore: errore,
            onChanged: onChanged,
          ),
          quando,
        ],
        azione: azione,
      );

  /// Descrizione, tema e lingua (C3): un campo a più righe e due gruppi di chip
  /// che **vanno a capo** (a testo grande la riga cresce, nessun chip si
  /// taglia). Le liste dei temi e delle lingue, la scelta e le callback sono del
  /// chiamante; la lista dei temi è di prova (domanda 13 in `aperte.md`).
  /// [maxRighe] è del chiamante: nessun documento fissa fin dove cresce la
  /// descrizione (segnalato nel report del task 023b).
  static BaPassoFoglio dettagli({
    required String titolo,
    required TextEditingController descrizione,
    required String descrizioneEtichetta,
    String? descrizioneSegnaposto,
    FocusNode? descrizioneFocusNode,
    ValueChanged<String>? onDescrizione,
    int minRighe = 3,
    required int maxRighe,
    required String temaEtichetta,
    required List<String> temi,
    required int? temaScelto,
    required ValueChanged<int> onTema,
    required String linguaEtichetta,
    required List<String> lingue,
    required int? linguaScelta,
    required ValueChanged<int> onLingua,
    required BaAzioneFoglio azione,
  }) =>
      BaPassoFoglio(
        id: idDettagli,
        titolo: titolo,
        corpo: [
          BaCampoTesto(
            controller: descrizione,
            focusNode: descrizioneFocusNode,
            etichetta: descrizioneEtichetta,
            segnaposto: descrizioneSegnaposto,
            minRighe: minRighe,
            maxRighe: maxRighe,
            onChanged: onDescrizione,
          ),
          _GruppoChip(etichetta: temaEtichetta, voci: temi, scelta: temaScelto, onScelta: onTema),
          _GruppoChip(etichetta: linguaEtichetta, voci: lingue, scelta: linguaScelta, onScelta: onLingua),
        ],
        azione: azione,
      );

  /// Invitati (C4, solo il privato): la [frase] e il [posto] degli invitati.
  ///
  /// **Il posto è uno spazio che il chiamante riempie**: oggi un
  /// [BaPuntoAggancio] («Qui: la fonte degli invitati»), domani l'elenco con la
  /// ricerca. Il passo non sa che cosa c'è dentro e non cambia quando lo si
  /// sostituisce: titolo, frase e azioni restano quelli. La fonte degli invitati
  /// non è decisa (domanda 8 in `aperte.md`).
  static BaPassoFoglio invitati({
    required String titolo,
    required String frase,
    required Widget posto,
    required BaAzioneFoglio azione,
  }) =>
      BaPassoFoglio(
        id: idInvitati,
        titolo: titolo,
        corpo: [_Frase(frase), posto],
        azione: azione,
      );

  /// Riepilogo (C5): una [BaRigaValore] per voce (per il pubblico la riga
  /// «Invitati» non c'è: lo decide il chiamante) e, se c'è, la [frase] finale
  /// («Salirai a microfono spento.»: in primo piano). L'azione è quella che
  /// crea, «Crea il DEN».
  static BaPassoFoglio riepilogo({
    required String titolo,
    required List<BaRigaValore> righe,
    String? frase,
    required BaAzioneFoglio azione,
  }) =>
      BaPassoFoglio(
        id: idRiepilogo,
        titolo: titolo,
        corpo: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: righe),
          if (frase != null) _Frase(frase, evidenza: true),
        ],
        azione: azione,
      );

  /// «Il DEN non è stato creato» (S2): l'[errore] (una frase, annunciata: è un
  /// [BaMessaggio] di errore, con il segno «!», mai il solo colore), la [nota]
  /// («Quello che hai scritto è ancora qui.»: i controller sono del chiamante,
  /// quindi è vero) e «Riprova».
  static BaPassoFoglio nonCreato({
    required String titolo,
    required String errore,
    String? nota,
    required BaAzioneFoglio azione,
  }) =>
      BaPassoFoglio(
        id: idNonCreato,
        titolo: titolo,
        corpo: [
          BaMessaggio(testo: errore, variante: BaVarianteMessaggio.errore),
          if (nota != null) _Frase(nota, piccola: true),
        ],
        azione: azione,
      );
}

/// Una frase del passo: in secondo piano, o in primo piano ([evidenza]); [piccola]
/// è il corpo minore.
class _Frase extends StatelessWidget {
  const _Frase(this.testo, {this.evidenza = false, this.piccola = false});

  final String testo;
  final bool evidenza;
  final bool piccola;

  @override
  Widget build(BuildContext context) => Text(
        testo,
        style: (piccola ? BaTestoTokens.minore : BaTestoTokens.corpo).copyWith(
          color: evidenza ? BaColorTokens.testoPrimo : BaColorTokens.testoSecondo,
        ),
      );
}

/// Un gruppo di chip a scelta singola: il marcatore («Tema») e i chip, che
/// vanno a capo a distanza `chipGap`.
class _GruppoChip extends StatelessWidget {
  const _GruppoChip({required this.etichetta, required this.voci, required this.scelta, required this.onScelta});

  final String etichetta;
  final List<String> voci;
  final int? scelta;
  final ValueChanged<int> onScelta;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etichetta.toUpperCase(),
          textScaler: TextScaler.linear(BaScalaTokens.marcatore(context)),
          style: BaTestoTokens.marcatore.copyWith(color: BaColorTokens.testoTerzo),
        ),
        const SizedBox(height: BaSpazioTokens.s),
        Wrap(
          spacing: BaCreazioneTokens.chipGap,
          runSpacing: BaCreazioneTokens.chipGap,
          children: [
            for (var i = 0; i < voci.length; i++)
              BaChipScelta(testo: voci[i], scelto: i == scelta, onTap: () => onScelta(i)),
          ],
        ),
      ],
    );
  }
}
