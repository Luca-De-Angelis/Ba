// Aggiungere persone e la rubrica (task 024c, prototipo 030: P1–P6 e R1–R3). La pagina «Aggiungi
// persone» ha `BaRicercaPersone` che **filtra davvero** persone di prova (nickname, alias, email,
// numero, da due caratteri) e, sotto, chi hai frequentato di più; «Aggiungi» diventa «Aggiunta» (la
// spunta e la parola), l'aggiunta è privata e **non produce nessun avviso**. Due persone con lo stesso
// nickname si distinguono per l'alias. Nessun risultato: «Invita con un link» (il link è fuori
// dall'app: un foglio breve di prova). Errore di rete: lo provoca il pannello, «Riprova» fa riuscire.
//
// La rubrica: il foglio del permesso (R1) prima di quello di sistema, simulato; il rifiuto è una
// scelta normale, senza colpa (R2); con il permesso, «Su BA» e «Non ancora su BA» con «Invita» (R3).
// L'ingresso «Aggiungi persone» è una riga nell'elenco (proposta: il «+» di D-039 non è disegnato).
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/marcatore.dart';
import '../design_system/pillola.dart';
import '../design_system/ricerca_persone.dart';
import '../design_system/riga_persona.dart';
import '../design_system/tokens.dart';
import 'pagina_base.dart';
import 'persone.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

/// Una riga di persona con «Aggiungi» o «Aggiunta».
Widget rigaPerAggiungere(StatoProto stato, Contatto c) {
  final aggiunta = stato.aggiunte.contains(c.id);
  return BaRigaPersona(
    nome: c.nome,
    alias: c.alias,
    tinta: c.persona.tinta,
    sagoma: c.persona.sagoma,
    voce: aggiunta ? BaVoceRigaPersona.aggiunta : BaVoceRigaPersona.daAggiungere,
    azione: aggiunta ? T.aggiunta : T.aggiungi,
    azioneSemanticsLabel: '${aggiunta ? T.aggiunta : T.aggiungi} ${c.nome}${c.alias == null ? '' : ' ${c.alias}'}',
    onAzione: aggiunta ? null : () => stato.aggiungiPersona(c.id),
  );
}

/// «Invita con un link»: il link è fuori dall'app, qui un foglio breve di prova.
Future<void> apriInvitaConUnLink(BuildContext context) => showBaFoglio<void>(
      context,
      etichettaVelo: T.chiudi,
      builder: (foglio) => BaFoglio.richiesta(
        titolo: T.linkTitolo,
        paragrafi: const [T.linkFrase],
        azioni: [azioneFoglio(T.hoCapito, () => Navigator.of(foglio).pop())],
      ),
    );

class PaginaAggiungiPersone extends StatefulWidget {
  const PaginaAggiungiPersone({super.key});

  @override
  State<PaginaAggiungiPersone> createState() => _PaginaAggiungiPersoneState();
}

class _PaginaAggiungiPersoneState extends State<PaginaAggiungiPersone> {
  final TextEditingController _ricerca = TextEditingController();

  @override
  void dispose() {
    _ricerca.dispose();
    super.dispose();
  }

  /// La rubrica: il foglio del permesso la prima volta, poi la pagina.
  Future<void> _rubrica(BuildContext context) async {
    final stato = ProtoScope.leggi(context);
    if (stato.permessoRubrica == PermessoRubrica.nonChiesto) {
      final consenti = await showBaFoglio<bool>(
        context,
        etichettaVelo: T.chiudi,
        builder: (foglio) => BaFoglio.richiesta(
          titolo: T.rubricaTitolo,
          paragrafi: const [T.rubricaP1, T.rubricaP2],
          azioni: [
            azioneFoglio(T.consentiAccesso, () => Navigator.of(foglio).pop(true), variante: BaVariantePillola.attiva),
            azioneFoglio(T.nonOra, () => Navigator.of(foglio).pop(false), variante: BaVariantePillola.attiva),
          ],
        ),
      );
      if (consenti == null) return;
      stato.impostaPermessoRubrica(consenti ? PermessoRubrica.consentito : PermessoRubrica.rifiutato);
    }
    stato.vai(const Rotta(Pagina.rubrica));
  }

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final testo = _ricerca.text;
    final filtra = BaRicercaPersone.attiva(testo);
    final errore = stato.ricercaFallisce && filtra;
    final risultati = [
      for (final c in contatti)
        if (c.suBa && BaRicercaPersone.corrisponde(testo, nickname: c.nome, alias: c.alias, email: c.email, numero: c.numero)) c,
    ];
    final suggeriti = [for (final c in contatti) if (c.suggerito) c];
    final doppio = risultati.map((c) => c.nome).toSet().length < risultati.length
        ? risultati.firstWhere((c) => risultati.where((x) => x.nome == c.nome).length > 1).nome
        : null;

    final Widget corpo;
    if (errore) {
      corpo = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // L'errore sta nel campo (linea, «!» e frase); «Riprova» fa riuscire la ricerca.
          pillola(T.riprova, stato.cambiaRicercaFallisce, variante: BaVariantePillola.attiva),
        ],
      );
    } else if (filtra) {
      corpo = risultati.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Frase(T.nessunRisultato(testo.trim())),
                const SizedBox(height: BaSpazioTokens.m),
                const Frase(T.senzaBa, evidenza: true),
                const SizedBox(height: BaSpazioTokens.m),
                pillola(T.invitaConUnLink, () => apriInvitaConUnLink(context), variante: BaVariantePillola.attiva),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BaMarcatore(testo: T.risultati(risultati.length)),
                for (final c in risultati) rigaPerAggiungere(stato, c),
                if (doppio != null) ...[
                  const SizedBox(height: BaSpazioTokens.m),
                  Frase(T.stessoNome(doppio), evidenza: true),
                ],
              ],
            );
    } else {
      corpo = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BaMarcatore(testo: T.suggeriti),
          for (final c in suggeriti) rigaPerAggiungere(stato, c),
        ],
      );
    }

    return PaginaProto(
      nome: T.aggiungiPersone,
      titolo: T.aggiungiPersone,
      titoloSchermata: true,
      corpo: [
        BaRicercaPersone(
          controller: _ricerca,
          etichetta: T.cerca,
          segnaposto: T.cercaSegnaposto,
          erroreRete: errore ? T.erroreRete : null,
          onRicerca: (_) => setState(() {}),
        ),
        corpo,
        pillola(T.dallaRubrica, () => _rubrica(context), variante: BaVariantePillola.spenta),
      ],
      azioni: [pillola(T.chiudi, stato.indietro, variante: BaVariantePillola.spenta)],
    );
  }
}

/// La rubrica: R2 se il permesso è stato rifiutato, R3 se è dato.
class PaginaRubrica extends StatelessWidget {
  const PaginaRubrica({super.key});

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    if (stato.permessoRubrica != PermessoRubrica.consentito) {
      return PaginaProto(
        nome: T.rubricaNonCollegata,
        titolo: T.rubricaNonCollegata,
        titoloSchermata: true,
        corpo: const [Frase(T.rubricaR2P1), Frase(T.rubricaR2P2, piccola: true)],
        // Nessun invito a ripensarci: solo la ricerca per nome.
        azioni: [pillola(T.cercaUnaPersona, stato.indietro, variante: BaVariantePillola.attiva)],
      );
    }
    final suBa = [for (final c in contatti) if (c.inRubrica && c.suBa) c];
    final non = [for (final c in contatti) if (c.inRubrica && !c.suBa) c];
    return PaginaProto(
      nome: T.dallaRubrica,
      titolo: T.dallaRubrica,
      titoloSchermata: true,
      corpo: [
        const BaMarcatore(testo: T.suBa),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final c in suBa) rigaPerAggiungere(stato, c)]),
        const BaMarcatore(testo: T.nonAncoraSuBa),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final c in non)
              BaRigaPersona(
                nome: c.nome,
                stato: T.dallaTuaRubrica,
                tinta: c.persona.tinta,
                sagoma: c.persona.sagoma,
                voce: BaVoceRigaPersona.daAggiungere,
                azione: T.invita,
                azioneSemanticsLabel: '${T.invita} ${c.nome}',
                onAzione: () => apriInvitaConUnLink(context),
              ),
          ],
        ),
      ],
      azioni: [pillola(T.chiudi, stato.indietro, variante: BaVariantePillola.spenta)],
    );
  }
}
