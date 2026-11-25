// I ganci del prototipo (task 024b): i due punti in cui le persone si scelgono — gli
// invitati di un DEN privato (014 C4) e il co-amministratore (G2) — riempiti con
// `BaSelettorePersone`. Dal task 024c le persone sono quelle **aggiunte** (`persone.dart`), filtrate
// come nel 030. La fonte vera (rubrica, ricerca, inviti) è del prodotto: si sostituiscono queste due
// funzioni e **nient'altro** (i passi e i fogli non cambiano, 033). Nessuna persona è vera.
import 'package:flutter/widgets.dart';

import '../design_system/ricerca_persone.dart';
import '../design_system/selettore_persone.dart';
import 'persone.dart';
import 'stato.dart';
import 'testi.dart';

/// Il posto degli invitati (C4): [scelti] sono gli id già nell'invito; [alToccare] li aggiunge o li toglie.
Widget postoInvitati({
  required List<String> scelti,
  required ValueChanged<Persona> alToccare,
}) =>
    _Selettore(
      scelti: scelti,
      alToccare: alToccare,
      intestazione: T.personeAggiunte,
      parolaScegli: T.invita,
      parolaScelta: T.nellInvito,
      frase: (n) => n == 0 ? T.invitatiNessuno : T.invitatiN(n),
    );

/// Il posto del co-amministratore (G2): il limite è un numero dato da chi chiama, mai un livello.
Widget postoCoAmministratore({
  required List<String> scelti,
  required ValueChanged<Persona> alToccare,
  required int limite,
}) =>
    _Selettore(
      scelti: scelti,
      alToccare: alToccare,
      parolaScegli: T.scegli,
      parolaScelta: T.scelto,
      limite: limite,
      frase: (_) => T.coAmmFraseSelettore,
      fraseLimite: (nome) => T.coAmmLimiteSceglie(nome),
    );

class _Selettore extends StatefulWidget {
  const _Selettore({
    required this.scelti,
    required this.alToccare,
    this.intestazione,
    required this.parolaScegli,
    required this.parolaScelta,
    this.limite,
    required this.frase,
    this.fraseLimite,
  });

  final List<String> scelti;
  final ValueChanged<Persona> alToccare;
  final String? intestazione;
  final String parolaScegli;
  final String parolaScelta;
  final int? limite;
  final String Function(int n) frase;
  final String Function(String nome)? fraseLimite;

  @override
  State<_Selettore> createState() => _SelettoreState();
}

class _SelettoreState extends State<_Selettore> {
  final TextEditingController _ricerca = TextEditingController();

  @override
  void dispose() {
    _ricerca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    // Solo le persone aggiunte (030 S1: «Persone che hai aggiunto»).
    final aggiunte = [for (final c in contatti) if (stato.aggiunte.contains(c.id)) c];
    final sceltiNomi = [for (final c in aggiunte) if (widget.scelti.contains(c.id)) c.nome];
    return BaSelettorePersone(
      ricerca: BaRicercaPersone(
        controller: _ricerca,
        etichetta: T.cerca,
        segnaposto: T.cercaSegnaposto,
        onRicerca: (_) => setState(() {}),
      ),
      intestazione: widget.intestazione,
      persone: [
        for (final p in aggiunte)
          if (BaRicercaPersone.corrisponde(_ricerca.text, nickname: p.nome, alias: p.alias, email: p.email, numero: p.numero))
            BaPersonaSelezionabile(
              nome: p.nome,
              alias: p.alias,
              tinta: p.persona.tinta,
              sagoma: p.persona.sagoma,
              scelta: widget.scelti.contains(p.id),
              semanticsLabel: '${widget.scelti.contains(p.id) ? widget.parolaScelta : widget.parolaScegli} ${p.nome}',
              onTap: () => widget.alToccare(p.persona),
            ),
      ],
      parolaScegli: widget.parolaScegli,
      parolaScelta: widget.parolaScelta,
      limite: widget.limite,
      frase: aggiunte.isEmpty ? T.nessunaPersona : widget.frase(widget.scelti.length),
      fraseLimite: sceltiNomi.isEmpty || widget.fraseLimite == null ? null : widget.fraseLimite!(sceltiNomi.first),
    );
  }
}
