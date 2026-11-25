// Le impostazioni (task 024a, prototipi 001 5d e 013 T1–T4) e la pagina «Persone
// bloccate» (001 5j). Righe: lingua e microfono (di sola lettura, chiaramente
// inattive), «Persone bloccate», «Torna ascoltatore» con **le due conferme** (T2 e
// T3) e il risultato (T4: la riga diventa un fatto), «Esci da BA» (porta al login:
// proposta del task 024, nessun documento dice dove si va).
//
// «Torna ascoltatore» ritira il consenso a parlare (D-003, D-040): chi parla esce
// dalla stanza. Dopo il cambio non c'è un nuovo accesso: si resta nell'app (ipotesi
// 17 di `aperte.md`: «può servire un nuovo accesso»). Il permesso del microfono
// negato (simulazione del pannello) mostra «Negato» con «Apri» (001).
//
// «Sblocca» toglie la persona dall'elenco subito: lo stato «sblocco in corso» del
// design ha bisogno del tempo, e senza timer non c'è.
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/foglio_passi.dart';
import '../design_system/marcatore.dart';
import '../design_system/pillola.dart';
import '../design_system/riga_bloccata.dart';
import '../design_system/riga_impostazione.dart';
import '../design_system/tokens.dart';
import 'pagina_base.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

// -------------------------------------------------------------- impostazioni

class PaginaImpostazioni extends StatelessWidget {
  const PaginaImpostazioni({super.key});

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    return PaginaProto(
      nome: T.impostazioniNome,
      titolo: T.impostazioniTitolo,
      corpo: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Di sola lettura: nel prototipo la lingua è una e il permesso è dato.
            BaRigaImpostazione.valore(titolo: T.lingua, valore: T.italiano),
            // Il permesso lo cambia il pannello; «Apri» simula il ritorno dalle impostazioni del telefono
            // con il permesso dato.
            if (stato.permessoMic)
              BaRigaImpostazione.valore(titolo: T.microfono, valore: T.consentito)
            else
              BaRigaImpostazione.negata(
                titolo: T.microfono,
                frase: T.micNegata,
                apri: T.apri,
                apriSemanticsLabel: '${T.apri} ${T.microfono}',
                onApri: () => stato.impostaPermessoMic(true),
              ),
            // «Chi può trovarmi» (030 V1): parte «Chi conosco».
            BaRigaImpostazione.valore(
              titolo: T.chiPuoTrovarmi,
              valore: switch (stato.visibilita) {
                Visibilita.nessuno => T.visNessuno,
                Visibilita.conosco => T.visConosco,
                Visibilita.tutti => T.visTutti,
              },
              sottotitolo: T.visConoscoFrase,
              onTap: () => stato.vai(const Rotta(Pagina.chiPuoTrovarmi)),
            ),
            // Il richiamo (030 C1–C2): parte spento; acceso, le due liste di persone.
            BaRigaImpostazione.interruttore(
              titolo: T.richiamo,
              descrizione: stato.richiamoAcceso ? T.richiamoAccesoFrase : T.richiamoSpentoFrase,
              acceso: stato.richiamoAcceso,
              parolaAcceso: T.acceso,
              parolaSpento: T.spento,
              onCambia: stato.impostaRichiamo,
            ),
            if (stato.richiamoAcceso) ...[
              BaRigaImpostazione.valore(
                titolo: T.chiPuoiAvvisare,
                sottotitolo: T.chiPuoiAvvisareSotto,
                valore: T.nPersone(stato.avvisoA.length),
                onTap: () => stato.vai(const Rotta(Pagina.chiPuoiAvvisare)),
              ),
              BaRigaImpostazione.valore(
                titolo: T.chiPuoAvvisarti,
                sottotitolo: T.chiPuoAvvisartiSotto,
                onTap: () => stato.vai(const Rotta(Pagina.chiPuoAvvisarti)),
              ),
              const Padding(padding: EdgeInsets.only(top: BaSpazioTokens.m), child: Frase(T.richiamoRassicura, piccola: true)),
            ],
            BaRigaImpostazione.valore(
              titolo: T.personeBloccate,
              valore: T.nPersone(stato.bloccate.length),
              onTap: () => stato.vai(const Rotta(Pagina.bloccate)),
            ),
            if (stato.partecipante)
              BaRigaImpostazione.azione(
                titolo: T.tornaAscoltatore,
                conseguenza: T.tornaConseguenza,
                onTap: () => apriTornaAscoltatore(context),
              )
            else
              // T4: la riga è diventata un fatto.
              BaRigaImpostazione.valore(titolo: T.seiAscoltatoreRiga, sottotitolo: T.seiAscoltatoreNota),
            BaRigaImpostazione.valore(titolo: T.esciDaBa, onTap: stato.esciDaBa),
          ],
        ),
      ],
      azioni: [pillola(T.indietro, stato.indietro, variante: BaVariantePillola.spenta)],
    );
  }
}

// ------------------------------------------------------------ torna ascoltatore

/// «Torna ascoltatore» (T2 e T3): un foglio che cambia passo, con **due conferme**.
Future<void> apriTornaAscoltatore(BuildContext context) async {
  final stato = ProtoScope.leggi(context);
  final confermato = await showBaFoglio<bool>(
    context,
    etichettaVelo: T.chiudi,
    builder: (_) => const _FoglioTorna(),
  );
  if (confermato == true) stato.tornaAscoltatore();
}

class _FoglioTorna extends StatefulWidget {
  const _FoglioTorna();

  @override
  State<_FoglioTorna> createState() => _FoglioTornaState();
}

class _FoglioTornaState extends State<_FoglioTorna> {
  /// 0 = T2 («Tornare ascoltatore?»), 1 = T3 («Ne sei sicuro?»).
  int _passo = 0;

  @override
  Widget build(BuildContext context) {
    // Le azioni sono a filetto (T2 e T3 del 013): «Non ora» c'è sempre.
    final passo = _passo == 0
        ? BaPassoFoglio.avviso(
            id: 't2',
            titolo: T.t2Titolo,
            paragrafi: const [BaParagrafoPasso(T.t2Frase1), BaParagrafoPasso(T.t2Frase2)],
            azione: azioneFoglio(T.continua, () => setState(() => _passo = 1), variante: BaVariantePillola.attiva),
          )
        : BaPassoFoglio.avviso(
            id: 't3',
            titolo: T.t3Titolo,
            paragrafi: const [BaParagrafoPasso(T.t3Frase)],
            azione: azioneFoglio(T.tornaAscoltatore, () => Navigator.of(context).pop(true), variante: BaVariantePillola.attiva),
          );
    return BaFoglioPassi(
      nome: T.tornaAscoltatore,
      passo: passo,
      nonOra: azioneFoglio(T.nonOra, () => Navigator.of(context).pop(false), variante: BaVariantePillola.spenta),
    );
  }
}

// ------------------------------------------------------------ persone bloccate

class PaginaBloccate extends StatelessWidget {
  const PaginaBloccate({super.key});

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    return PaginaProto(
      nome: T.bloccateNome,
      titolo: T.bloccateTitolo,
      corpo: [
        const BaMarcatore(testo: T.bloccateGruppo),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final p in stato.bloccate)
              BaRigaBloccata(
                nome: p.nome,
                iniziali: p.iniziali,
                tinta: p.tinta,
                sagoma: p.sagoma,
                sbloccaTesto: T.sblocca,
                sbloccaSemanticsLabel: '${T.sblocca} ${p.nome}',
                onSblocca: () => stato.sblocca(p),
              ),
          ],
        ),
        const Frase(T.bloccateNota, piccola: true),
      ],
      azioni: [pillola(T.indietro, stato.indietro, variante: BaVariantePillola.spenta)],
    );
  }
}
