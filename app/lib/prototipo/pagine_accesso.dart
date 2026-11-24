// Le pagine dell'accesso (task 024a, prototipo 013): email → codice (con i suoi
// errori) → prima di entrare → termini → nickname → elenco. L'account di base è da
// ascoltatore (D-031). Niente autenticazione vera: il codice **123456** è giusto,
// **000000** è scaduto, ogni altro è sbagliato (i documenti non ne definiscono uno:
// proposta del task 024). Il nuovo invio resta in attesa finché si scrive di nuovo:
// niente timer.
import 'package:flutter/widgets.dart';

import '../design_system/campo_codice.dart';
import '../design_system/campo_testo.dart';
import '../design_system/pillola.dart';
import '../design_system/punto_aggancio.dart';
import '../design_system/scheda_persona.dart';
import 'pagina_base.dart';
import 'stato.dart';
import 'testi.dart';
import 'util.dart';

// ------------------------------------------------------------------- email (A1)

class PaginaEmail extends StatefulWidget {
  const PaginaEmail({super.key});

  @override
  State<PaginaEmail> createState() => _PaginaEmailState();
}

class _PaginaEmailState extends State<PaginaEmail> {
  late final TextEditingController _email = TextEditingController(text: ProtoScope.leggi(context).email);
  bool _errore = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _avanti() {
    final testo = _email.text.trim();
    // L'unica «validazione» del prototipo: sembra un'email.
    if (!testo.contains('@') || !testo.contains('.')) {
      setState(() => _errore = true);
      return;
    }
    final stato = ProtoScope.leggi(context);
    stato.impostaEmail(testo);
    stato.vai(const Rotta(Pagina.codice));
  }

  @override
  Widget build(BuildContext context) {
    return PaginaProto(
      nome: T.emailNome,
      titolo: T.emailTitolo,
      corpo: [
        BaCampoTesto(
          controller: _email,
          etichetta: T.emailEtichetta,
          segnaposto: T.emailSegnaposto,
          aiuto: T.emailAiuto,
          errore: _errore ? T.emailErrore : null,
          tastiera: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          onChanged: (_) {
            if (_errore) setState(() => _errore = false);
          },
          onSubmitted: (_) => _avanti(),
        ),
        // Il posto per «Continua con…» dopo l'alpha: un gancio, non una funzione.
        const BaPuntoAggancio(titolo: T.continuaConTitolo, sottotitolo: T.continuaConSottotitolo),
      ],
      azioni: [pillola(T.emailAzione, _avanti, variante: BaVariantePillola.chiara)],
    );
  }
}

// ------------------------------------------------------------------ codice (A2)

class PaginaCodice extends StatefulWidget {
  const PaginaCodice({super.key});

  @override
  State<PaginaCodice> createState() => _PaginaCodiceState();
}

class _PaginaCodiceState extends State<PaginaCodice> {
  final TextEditingController _controller = TextEditingController();
  BaStatoCodice _stato = BaStatoCodice.scrittura;
  bool _nuovoInvio = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? get _fraseStato => switch (_stato) {
        BaStatoCodice.scrittura => null,
        BaStatoCodice.sbagliato => T.codiceSbagliato,
        BaStatoCodice.scaduto => T.codiceScaduto,
        BaStatoCodice.attesa => T.codiceAttesa,
      };

  void _conferma() {
    if (_stato == BaStatoCodice.scaduto) {
      // «Manda un nuovo codice»: il nuovo invio resta in attesa finché si scrive.
      setState(() {
        _controller.clear();
        _nuovoInvio = true;
        _stato = BaStatoCodice.attesa;
      });
      return;
    }
    final codice = _controller.text;
    if (codice == T.codiceGiusto) {
      final stato = ProtoScope.leggi(context);
      stato.vai(Rotta(stato.onboardingFatto ? Pagina.elenco : Pagina.onboarding));
    } else if (codice == T.codiceDiScaduto) {
      setState(() => _stato = BaStatoCodice.scaduto);
    } else {
      setState(() => _stato = BaStatoCodice.sbagliato);
    }
  }

  void _mandaDiNuovo() {
    setState(() {
      _controller.clear();
      _nuovoInvio = true;
      _stato = BaStatoCodice.attesa;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.of(context);
    final scaduto = _stato == BaStatoCodice.scaduto;
    final attesa = _stato == BaStatoCodice.attesa;
    return PaginaProto(
      nome: T.codiceNome,
      titolo: T.codiceTitolo,
      corpo: [
        Frase(_nuovoInvio ? T.codiceFraseNuovo(stato.email) : T.codiceFrase(stato.email)),
        BaCampoCodice(
          semanticsLabel: T.codiceEtichetta,
          controller: _controller,
          stato: _stato,
          frase: _fraseStato,
          onChanged: (_) {
            // Scrivere di nuovo toglie l'errore e finisce l'attesa.
            if (_stato != BaStatoCodice.scrittura && !scaduto) setState(() => _stato = BaStatoCodice.scrittura);
          },
        ),
        // Scaduto: la riga non c'è, l'azione che serve è la primaria.
        if (!scaduto) pillola(T.mandaDiNuovo, attesa ? null : _mandaDiNuovo, variante: BaVariantePillola.spenta),
      ],
      azioni: [
        pillola(
          scaduto ? T.mandaNuovoCodice : T.conferma,
          attesa ? null : _conferma,
          variante: BaVariantePillola.chiara,
        ),
        pillola(T.indietro, stato.indietro, variante: BaVariantePillola.spenta),
      ],
    );
  }
}

// ---------------------------------------------------------- prima di entrare (A3)

class PaginaOnboarding extends StatelessWidget {
  const PaginaOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.leggi(context);
    return PaginaProto(
      nome: T.onboardingNome,
      titolo: T.onboardingTitolo,
      corpo: const [
        Frase(T.onboarding1, evidenza: true),
        Frase(T.onboarding2),
        Frase(T.onboarding3),
      ],
      azioni: [
        pillola(T.hoCapito, () => stato.vai(const Rotta(Pagina.termini)), variante: BaVariantePillola.chiara),
        pillola(T.indietro, stato.indietro, variante: BaVariantePillola.spenta),
      ],
    );
  }
}

// -------------------------------------------------------------------- termini (A4)

class PaginaTermini extends StatelessWidget {
  const PaginaTermini({super.key});

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.leggi(context);
    return PaginaProto(
      nome: T.terminiNome,
      titolo: T.terminiTitolo,
      corpo: const [
        Frase(T.termini1),
        // I due testi non esistono nel prototipo: le righe sono chiaramente inattive.
        BaRigaAzione(titolo: T.leggiTermini),
        BaRigaAzione(titolo: T.leggiInformativa),
        Frase(T.termini2, evidenza: true),
        Frase(T.termini3, piccola: true),
      ],
      azioni: [
        pillola(T.accetto, () => stato.vai(const Rotta(Pagina.nickname)), variante: BaVariantePillola.chiara),
        pillola(T.indietro, stato.indietro, variante: BaVariantePillola.spenta),
      ],
    );
  }
}

// ------------------------------------------------------------------ nickname (A5)

class PaginaNickname extends StatefulWidget {
  const PaginaNickname({super.key});

  @override
  State<PaginaNickname> createState() => _PaginaNicknameState();
}

class _PaginaNicknameState extends State<PaginaNickname> {
  final TextEditingController _nickname = TextEditingController();
  bool _toccato = false;

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  bool get _vuoto => _nickname.text.trim().isEmpty;

  void _continua() {
    if (_vuoto) return;
    ProtoScope.leggi(context).finisciAccesso(_nickname.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final stato = ProtoScope.leggi(context);
    return PaginaProto(
      nome: T.nicknameNome,
      titolo: T.nicknameTitolo,
      corpo: [
        BaCampoTesto(
          controller: _nickname,
          etichetta: T.nicknameEtichetta,
          segnaposto: T.nicknameSegnaposto,
          // A5 bis: vuoto, con la sua frase; l'azione è inattiva.
          errore: _toccato && _vuoto ? T.nicknameErrore : null,
          onChanged: (_) => setState(() => _toccato = true),
          onSubmitted: (_) => _continua(),
        ),
        const Frase(T.nicknameFrase),
      ],
      azioni: [
        pillola(T.continua, _vuoto ? null : _continua, variante: BaVariantePillola.chiara),
        pillola(T.indietro, stato.indietro, variante: BaVariantePillola.spenta),
      ],
    );
  }
}
