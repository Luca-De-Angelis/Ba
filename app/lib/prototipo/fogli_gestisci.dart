// «Gestisci» (task 024b, prototipo 014 aggiornato dal 027: G1–G5): **uno solo per i DEN
// privati e per i pubblici creati da un utente** (D-043), dall'«Altro» della stanza. Il menu
// (descrizione, co-amministratori, persone, «Termina il DEN») e le viste che si aprono dalle
// sue voci: la descrizione («Salva»), i co-amministratori (il posto riempito da `ganci.dart`,
// il limite come numero dato da qui), le persone («Rimuovi» con la conferma), «Termina il DEN»
// con la conferma. «Chiudi» e «Non ora» tornano al menu; dal menu chiudono il foglio (il design
// system non decide che cosa fanno, e nessun documento lo dice: proposta del task 023b).
import 'package:flutter/widgets.dart';

import '../design_system/foglio.dart';
import '../design_system/fogli_gestione.dart';
import '../design_system/pillola.dart';
import '../design_system/riga_persona.dart';
import '../design_system/riga_valore.dart';
import 'ganci.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

/// Il limite dei co-amministratori: un numero di prova (014: «0 di 1»).
const int _limiteCoAmm = 1;

Future<void> apriGestisci(BuildContext context) =>
    showBaFoglio<void>(context, etichettaVelo: T.chiudi, builder: (_) => const _Gestisci());

enum _Vista { menu, descrizione, coAmministratori, persone, rimuovi, termina }

class _Gestisci extends StatefulWidget {
  const _Gestisci();

  @override
  State<_Gestisci> createState() => _GestisciState();
}

class _GestisciState extends State<_Gestisci> {
  TextEditingController? _descrizione;
  _Vista _vista = _Vista.menu;
  Persona? _daRimuovere;
  final List<String> _scelto = [];

  @override
  void dispose() {
    _descrizione?.dispose();
    super.dispose();
  }

  void _vai(_Vista v) => setState(() => _vista = v);

  BaAzioneFoglio get _alMenu => azioneFoglio(T.nonOra, () => _vai(_Vista.menu), variante: BaVariantePillola.spenta);

  BaRigaPersona _riga(Persona p, {required String stato, String? azione, VoidCallback? onAzione}) => BaRigaPersona(
        nome: p.nome,
        stato: stato,
        tinta: p.tinta,
        sagoma: p.sagoma,
        azione: onAzione == null ? null : azione,
        onAzione: onAzione,
        azioneSemanticsLabel: '$azione ${p.nome}',
      );

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final den = stato.denCorrente;
    if (den == null) return const SizedBox.shrink();
    final coAmm = stato.coAmministratori[den.id] ?? const <Persona>[];
    final persone = [for (final p in stato.palco) if (p.id != 'io') p];
    bool eCoAmm(Persona p) => coAmm.any((c) => c.id == p.id);

    switch (_vista) {
      case _Vista.menu:
        return BaFoglioGestisci.menu(
          nome: T.gestisciTitolo,
          titolo: T.gestisciTitolo,
          descrizione: BaRigaValore(
            etichetta: T.descrizione,
            sottotitolo: den.descrizione.isEmpty ? null : den.descrizione,
            onTap: () => _vai(_Vista.descrizione),
          ),
          coAmministratori: BaRigaValore(
            etichetta: T.coAmministratori,
            sottotitolo: T.coAmministratoriSotto,
            // Il limite, mai il livello: il numero lo dà il chiamante.
            valore: T.limiteDi(coAmm.length, _limiteCoAmm),
            onTap: () => _vai(_Vista.coAmministratori),
          ),
          persone: BaRigaValore(etichetta: T.personeNelDen, sottotitolo: T.personeNelDenSotto, onTap: () => _vai(_Vista.persone)),
          termina: BaRigaValore(etichetta: T.terminaDen, sottotitolo: T.terminaSotto, onTap: () => _vai(_Vista.termina)),
          nonOra: azioneFoglio(T.chiudi, () => Navigator.of(context).pop(), variante: BaVariantePillola.spenta),
        );
      case _Vista.descrizione:
        _descrizione ??= TextEditingController(text: den.descrizione);
        return BaFoglioGestisci.descrizione(
          nome: T.gestisciTitolo,
          titolo: T.descrizione,
          controller: _descrizione!,
          etichetta: T.descrizione,
          maxRighe: 6,
          salva: azioneFoglio(T.salva, () {
            stato.salvaDescrizione(den.id, _descrizione!.text.trim());
            _vai(_Vista.menu);
          }),
          nonOra: _alMenu,
        );
      case _Vista.coAmministratori:
        if (coAmm.length >= _limiteCoAmm) {
          // G2 bis: al limite, l'azione è inattiva e la frase dice come uscirne.
          return BaFoglioGestisci.coAmministratoriAlLimite(
            nome: T.gestisciTitolo,
            titolo: T.coAmministratori,
            persone: [
              for (final p in coAmm)
                _riga(p, stato: T.coAmministratore, azione: T.togli, onAzione: () => stato.togliCoAmministratore(den.id, p.id)),
            ],
            fraseLimite: T.coAmmLimite(coAmm.first.nome),
            aggiungi: T.aggiungiCoAmm,
            nonOra: azioneFoglio(T.chiudi, () => _vai(_Vista.menu), variante: BaVariantePillola.spenta),
          );
        }
        final scelta = [for (final p in personeInvitabili) if (_scelto.contains(p.persona.id)) p.persona];
        return BaFoglioGestisci.coAmministratori(
          nome: T.gestisciTitolo,
          titolo: T.coAmministratori,
          frase: T.coAmmFrase,
          posto: postoCoAmministratore(
            scelti: _scelto,
            limite: _limiteCoAmm,
            alToccare: (p) => setState(() {
              if (!_scelto.remove(p.id) && _scelto.isEmpty) _scelto.add(p.id);
            }),
          ),
          // Inattiva finché non si sceglie.
          aggiungi: azioneFoglio(
            T.aggiungiCoAmm,
            scelta.isEmpty
                ? null
                : () {
                    stato.aggiungiCoAmministratore(den.id, scelta.first);
                    setState(_scelto.clear);
                  },
          ),
          nonOra: azioneFoglio(T.chiudi, () => _vai(_Vista.menu), variante: BaVariantePillola.spenta),
        );
      case _Vista.persone:
        return BaFoglioGestisci.persone(
          nome: T.gestisciTitolo,
          titolo: T.personeNelDen,
          persone: [
            for (final p in persone)
              _riga(
                p,
                stato: eCoAmm(p) ? T.coAmministratore : T.sulPalco,
                azione: T.rimuovi,
                // Chi è co-amministratore non ha «Rimuovi»: prima si toglie il ruolo.
                onAzione: eCoAmm(p)
                    ? null
                    : () => setState(() {
                          _daRimuovere = p;
                          _vista = _Vista.rimuovi;
                        }),
              ),
          ],
          nonOra: azioneFoglio(T.chiudi, () => _vai(_Vista.menu), variante: BaVariantePillola.spenta),
        );
      case _Vista.rimuovi:
        final p = _daRimuovere;
        if (p == null) return const SizedBox.shrink();
        return BaFoglioGestisci.conferma(
          nome: T.gestisciTitolo,
          id: 'rimuovi-${p.id}',
          titolo: T.rimuoviTitolo(p.nome),
          frase: T.rimuoviFrase(p.nome),
          azione: azioneFoglio(T.rimuovi, () {
            stato.rimuoviPersona(p.id);
            _vai(_Vista.persone);
          }),
          nonOra: azioneFoglio(T.nonOra, () => _vai(_Vista.persone), variante: BaVariantePillola.spenta),
        );
      case _Vista.termina:
        return BaFoglioGestisci.conferma(
          nome: T.gestisciTitolo,
          id: 'termina',
          titolo: T.terminaTitolo,
          frase: T.terminaFrase,
          azione: azioneFoglio(T.terminaDen, () {
            Navigator.of(context).pop();
            stato.terminaDen();
          }),
          nonOra: _alMenu,
        );
    }
  }
}
