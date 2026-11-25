// Lo stato finto del prototipo navigabile (task 024), tutto in memoria: il tipo di
// account, il nickname, i DEN e le persone di prova, la stanza in cui si è e il
// proprio ruolo, il microfono, le persone bloccate e la pila delle pagine.
// **Nessuna persistenza**: ricaricare la pagina riparte dal login.
//
// Niente dipendenze: `ChangeNotifier` e `InheritedNotifier` stanno in widgets.dart.
// Niente timer: ogni cambiamento è una chiamata di un metodo, provocata da un
// tocco nel prodotto o da un tasto del pannello dello strumento.
import 'package:flutter/widgets.dart';

/// Il tipo di account (D-040): un ascoltatore ascolta, un partecipante può
/// parlare; «chiuso» è l'account chiuso dalla moderazione (D-049).
enum Account { ascoltatore, partecipante, chiuso }

/// Il proprio ruolo nella stanza in cui si è.
enum Ruolo { pubblico, inCoda, sulPalco }

/// Il posto offerto a chi è in coda (015 K4): offerto, o scaduto (K4 bis, «il posto è passato alla
/// persona dopo di te»). Nessun conto alla rovescia: scade quando il pannello dice che scade.
enum Posto { nessuno, offerto, scaduto }

/// L'account chiuso dalla moderazione (027): B1 «Account chiuso» o B1 bis «Blocco temporaneo».
enum Chiusura { chiuso, sospeso }

/// Che cosa dice il banner delle notifiche: un posto che si libera (K3) o un richiamo (K7).
enum TipoBanner { postoLibero, richiamo }

/// Dopo la linea persa: il posto c'era ancora (P2) o è stato preso (P3).
enum Ritorno { nessuno, postoRimasto, postoPreso }

/// Le pagine intere del prototipo.
enum Pagina { email, codice, onboarding, termini, nickname, elenco, stanza, impostazioni, bloccate }

/// Una pagina nella pila: la pagina e, per la stanza, il DEN.
@immutable
class Rotta {
  const Rotta(this.pagina, {this.den});

  final Pagina pagina;
  final String? den;

  @override
  bool operator ==(Object other) => other is Rotta && other.pagina == pagina && other.den == den;

  @override
  int get hashCode => Object.hash(pagina, den);
}

/// Una persona di prova: nome, iniziali e gli indici di tinta e sagoma.
@immutable
class Persona {
  const Persona(this.id, this.nome, this.iniziali, this.tinta, this.sagoma);

  final String id;
  final String nome;
  final String iniziali;
  final int tinta;
  final int sagoma;
}

/// Un DEN di prova.
@immutable
class Den {
  const Den({
    required this.id,
    required this.nome,
    required this.palco,
    required this.inAscolto,
    this.suInvito = false,
    this.frase,
    this.codaPiena = false,
    this.creatoDaMe = false,
    this.descrizione = '',
  });

  final String id;
  final String nome;

  /// Chi sta sul palco (da 0 a 8).
  final List<Persona> palco;
  final int inAscolto;
  final bool suInvito;
  final String? frase;

  /// La coda è piena adesso (015 S1): non ci si mette in coda.
  final bool codaPiena;

  /// Creato da chi usa il prototipo: «Gestisci» e il sotto-DEN (014, D-043).
  final bool creatoDaMe;
  final String descrizione;
}

const List<Persona> _personeDiProva = [
  Persona('sl', 'Sara L.', 'SL', 0, 0),
  Persona('mb', 'Marta B.', 'MB', 1, 1),
  Persona('ah', 'Andrea H.', 'AH', 2, 2),
  Persona('tr', 'Tommaso R.', 'TR', 3, 3),
  Persona('gt', 'Giulia T.', 'GT', 4, 4),
  Persona('nv', 'Nico V.', 'NV', 5, 0),
  Persona('lc', 'Luca C.', 'LC', 6, 1),
  Persona('dm', 'Davide M.', 'DM', 7, 2),
];

/// Le tre persone bloccate di partenza (001: «Dario V.», «Giulio R.»).
const List<Persona> _bloccateDiProva = [
  Persona('dv', 'Dario V.', 'DV', 8, 3),
  Persona('gr', 'Giulio R.', 'GR', 9, 4),
  Persona('st', 'Sara T.', 'ST', 10, 0),
];

/// I DEN di prova (013 A6, 004): «Cucina di notte» con cinque sul palco, «Fra due
/// turni» con due, «Radio insonni» vuoto e, solo per un partecipante, «Corridoio
/// lungo» su invito.
final List<Den> denDiProva = [
  Den(
    id: 'cucina',
    nome: 'Cucina di notte',
    palco: _personeDiProva.sublist(0, 5),
    inAscolto: 14,
    frase: 'Marta B. sta parlando',
  ),
  Den(id: 'fra', nome: 'Fra due turni', palco: _personeDiProva.sublist(5, 7), inAscolto: 6),
  const Den(id: 'radio', nome: 'Radio insonni', palco: [], inAscolto: 3, frase: 'Vuoto. Puoi restare e ti avviso.'),
  Den(id: 'corridoio', nome: 'Corridoio lungo', palco: _personeDiProva.sublist(2, 4), inAscolto: 4, suInvito: true),
  // Il palco è pieno (8): «Mettiti in coda» (015 K2). In «Serra» anche la coda è piena (S1).
  Den(id: 'tavolo', nome: 'Tavolo lungo', palco: _personeDiProva, inAscolto: 9),
  Den(id: 'serra', nome: 'Serra', palco: _personeDiProva, inAscolto: 12, codaPiena: true),
  // Il DEN del richiamo (015 K7): pubblico.
  Den(id: 'famiglia', nome: 'Famiglia', palco: _personeDiProva.sublist(0, 2), inAscolto: 5),
];

class StatoProto extends ChangeNotifier {
  StatoProto();

  /// Il Navigator della cornice: serve a chi sta fuori dalle pagine (il banner) per aprire
  /// un foglio **dentro** la cornice e non sopra tutta la finestra.
  final GlobalKey<NavigatorState> chiaveNavigatore = GlobalKey<NavigatorState>();

  // ------------------------------------------------------------- navigazione

  /// La pila delle pagine: l'ultima è quella che si vede. Parte dal login.
  List<Rotta> _pila = const [Rotta(Pagina.email)];
  List<Rotta> get pila => _pila;
  Rotta get corrente => _pila.last;

  void vai(Rotta r) {
    _pila = [..._pila, r];
    notifyListeners();
  }

  void sostituisci(Rotta r) {
    _pila = [..._pila.sublist(0, _pila.length - 1), r];
    notifyListeners();
  }

  /// Toglie la pagina in cima (se non è l'ultima rimasta).
  void indietro() {
    if (_pila.length < 2) return;
    _pila = _pila.sublist(0, _pila.length - 1);
    notifyListeners();
  }

  /// La pagina in cima è stata tolta dal Navigator (gesto «indietro» del sistema).
  void rimossa(Rotta r) {
    if (_pila.length > 1 && _pila.last == r) {
      _pila = _pila.sublist(0, _pila.length - 1);
      notifyListeners();
    }
  }

  void azzera(Rotta r) {
    _pila = [r];
    notifyListeners();
  }

  // ------------------------------------------------------------- l'account

  Account account = Account.ascoltatore;
  String nickname = '';
  String email = '';
  bool onboardingFatto = false;

  bool get partecipante => account == Account.partecipante;

  void impostaEmail(String valore) {
    email = valore;
    notifyListeners();
  }

  /// Dopo il consenso a parlare l'account passa da ascoltatore a partecipante (D-040).
  void diventaPartecipante() {
    if (account == Account.chiuso) return;
    account = Account.partecipante;
    notifyListeners();
  }

  /// «Torna ascoltatore» (D-040): chi parla esce dalla stanza.
  void tornaAscoltatore() {
    account = Account.ascoltatore;
    if (denCorrente != null) esciDallaStanza();
    notifyListeners();
  }

  /// Fine dell'accesso: si arriva all'elenco da ascoltatore (D-031).
  void finisciAccesso(String nome) {
    nickname = nome;
    onboardingFatto = true;
    account = Account.ascoltatore;
    azzera(const Rotta(Pagina.elenco));
  }

  /// «Esci da BA»: si torna al login; lo stato riparte.
  void esciDaBa() {
    account = Account.ascoltatore;
    email = '';
    nickname = '';
    denCorrente = null;
    _azzeraStanza();
    den..clear()..addAll(denDiProva);
    code = [];
    postoDen = null;
    posto = Posto.nessuno;
    banner = null;
    schermoBloccato = false;
    bloccate = [..._bloccateDiProva];
    azzera(const Rotta(Pagina.email));
  }

  // ------------------------------------------------------------- l'elenco e la stanza

  /// I DEN: una copia, perché quelli creati e terminati non cambino i DEN di prova.
  final List<Den> den = [...denDiProva];

  /// I DEN che l'elenco mostra: un privato su invito solo a un partecipante (D-041).
  List<Den> get denVisibili => [for (final d in den) if (!d.suInvito || partecipante || d.creatoDaMe) d];

  Den? denCorrente;

  /// Chi sta sul palco della stanza in cui si è (con me, se sono sul palco).
  List<Persona> palco = const [];
  Ruolo ruolo = Ruolo.pubblico;
  bool micAcceso = false;

  /// Chi sta parlando adesso (l'anello), se qualcuno parla. In «Cucina di notte» parla
  /// Marta B. (004); la simulazione «qualcuno parla» lo cambia.
  String? parla;

  static const int palcoMax = 8;

  /// Il profilo di chi usa il prototipo, sulla sagoma «io».
  Persona get io {
    final lettera = nickname.isEmpty ? 'IO' : nickname.substring(0, 1).toUpperCase();
    return Persona('io', nickname.isEmpty ? 'Tu' : nickname, lettera, 11, 1);
  }

  /// Il palco con cui si entra: se a un posto in coda si è liberato un posto, ne ha uno libero.
  List<Persona> _palcoDi(Den d) {
    if (postoDen == d.id && posto == Posto.offerto && d.palco.length >= palcoMax) {
      return d.palco.sublist(0, d.palco.length - 1);
    }
    return [...d.palco];
  }

  /// Chi prende il posto che si libera o che si perde: la prima persona di prova che non è sul palco.
  Persona? _rimpiazzo() {
    for (final p in _personeDiProva) {
      if (!palco.any((x) => x.id == p.id)) return p;
    }
    return null;
  }

  void _azzeraStanza() {
    palco = const [];
    ruolo = Ruolo.pubblico;
    micAcceso = false;
    parla = null;
    inGruppo = false;
    lineaPersa = false;
    postoPreso = false;
    ritorno = Ritorno.nessuno;
    inPausa = false;
  }

  /// Entra in una stanza **come pubblico** (D-006), con il microfono spento; chi è già in coda lì ci resta.
  void entraInDen(Den d) {
    denCorrente = d;
    _azzeraStanza();
    palco = _palcoDi(d);
    ruolo = code.contains(d.id) ? Ruolo.inCoda : Ruolo.pubblico;
    parla = d.id == 'cucina' ? 'mb' : null;
    if (banner != null && banner!.den == d.id) banner = null;
    vai(Rotta(Pagina.stanza, den: d.id));
  }

  /// Esce dalla stanza e torna all'elenco. Chi è in coda **resta in coda** (015: «Le tue code»).
  void esciDallaStanza() {
    denCorrente = null;
    _azzeraStanza();
    if (corrente.pagina == Pagina.stanza) {
      indietro();
    } else {
      notifyListeners();
    }
  }

  /// «Passa» (015 K6): si lascia questo DEN per quello, a un posto solo alla volta (D-042).
  void passaA(Den d) {
    if (banner != null && banner!.den == d.id) banner = null;
    denCorrente = d;
    _azzeraStanza();
    palco = _palcoDi(d);
    ruolo = code.contains(d.id) ? Ruolo.inCoda : Ruolo.pubblico;
    final r = Rotta(Pagina.stanza, den: d.id);
    if (corrente.pagina == Pagina.stanza) {
      sostituisci(r);
    } else {
      vai(r);
    }
  }

  /// Sale sul palco **a microfono spento** (D-007).
  void saliSulPalco() {
    if (ruolo == Ruolo.sulPalco || palco.length >= palcoMax) return;
    palco = [...palco, io];
    final id = denCorrente?.id;
    if (id != null) {
      code = [for (final c in code) if (c != id) c];
      if (postoDen == id) {
        postoDen = null;
        posto = Posto.nessuno;
      }
      if (banner != null && banner!.den == id) banner = null;
    }
    ruolo = Ruolo.sulPalco;
    micAcceso = false;
    inGruppo = false;
    ritorno = Ritorno.nessuno;
    notifyListeners();
  }

  void scendiDalPalco() {
    palco = [for (final p in palco) if (p.id != 'io') p];
    ruolo = Ruolo.pubblico;
    micAcceso = false;
    lineaPersa = false;
    postoPreso = false;
    notifyListeners();
  }

  /// Accende o spegne il microfono. Dal telefono bloccato **non si accende** (D-025);
  /// senza il permesso non si accende (chi chiama apre il foglio del permesso).
  void cambiaMic() {
    if (ruolo != Ruolo.sulPalco || lineaPersa) return;
    if (!micAcceso && (schermoBloccato || !permessoMic)) return;
    micAcceso = !micAcceso;
    notifyListeners();
  }

  // ------------------------------------------------------------- la coda (015)

  /// I DEN in cui si è in coda, nell'ordine in cui ci si è messi.
  List<String> code = [];

  /// «Fammi entrare automaticamente» (K2): al posto libero si sale da soli, a microfono spento (K5).
  bool ingressoAutomatico = false;

  /// «Aspetta con altri» (K2 ter): scelto nel foglio, e dopo «Entra nel gruppo» (W1) si è nel gruppo.
  bool aspettaConAltri = false;
  bool inGruppo = false;

  /// La capacità di aspettare con altri: solo chi ce l'ha vede la riga (K2 ter). Nel prototipo
  /// è un interruttore del pannello: nessun documento dice da dove viene.
  bool capacitaAspettare = false;

  void cambiaCapacita() {
    capacitaAspettare = !capacitaAspettare;
    if (!capacitaAspettare) aspettaConAltri = false;
    notifyListeners();
  }

  void impostaIngressoAutomatico(bool v) {
    ingressoAutomatico = v;
    notifyListeners();
  }

  void impostaAspettaConAltri(bool v) {
    aspettaConAltri = v;
    notifyListeners();
  }

  /// Il palco è pieno: chi è nel pubblico si può mettere in coda (K2).
  bool get palcoPieno => palco.length >= palcoMax;

  Den? denPerId(String id) {
    for (final d in den) {
      if (d.id == id) return d;
    }
    return null;
  }

  /// «Mettiti in coda»: si resta nel pubblico, in coda. [ingruppo]: dopo «Entra nel gruppo» (W1).
  void mettitiInCoda({bool ingruppo = false}) {
    final d = denCorrente;
    if (d == null || d.codaPiena || ruolo != Ruolo.pubblico) return;
    code = [...code, d.id];
    ruolo = Ruolo.inCoda;
    inGruppo = ingruppo;
    ritorno = Ritorno.nessuno;
    notifyListeners();
  }

  /// «Esci dalla coda»: da K1 o dalla stanza.
  void esciDallaCoda(String id) {
    code = [for (final c in code) if (c != id) c];
    if (denCorrente?.id == id && ruolo == Ruolo.inCoda) {
      ruolo = Ruolo.pubblico;
      inGruppo = false;
    }
    if (postoDen == id) {
      postoDen = null;
      posto = Posto.nessuno;
    }
    if (banner != null && banner!.den == id && banner!.tipo == TipoBanner.postoLibero) banner = null;
    notifyListeners();
  }

  void lasciaIlGruppo() {
    inGruppo = false;
    notifyListeners();
  }

  // ------------------------------------------------------------- il posto offerto (015 K3–K6)

  /// Il DEN in cui si è liberato un posto, e che cosa ne è (offerto o scaduto).
  String? postoDen;
  Posto posto = Posto.nessuno;

  /// Il posto offerto o scaduto di **questa** stanza.
  Posto get postoQui => postoDen != null && postoDen == denCorrente?.id ? posto : Posto.nessuno;

  /// C'è una coda in cui un posto si può liberare.
  bool get puoLiberarePosto => code.isNotEmpty && posto != Posto.offerto;

  /// Simulazione «si libera un posto»: nel primo DEN in cui si è in coda (quello della stanza, se ci si è).
  /// Con l'ingresso automatico, e se si è in quella stanza, si sale subito a microfono spento (K5).
  void siLiberaUnPosto() {
    if (!puoLiberarePosto) return;
    final id = denCorrente != null && code.contains(denCorrente!.id) ? denCorrente!.id : code.first;
    final d = denPerId(id);
    if (d == null) return;
    postoDen = id;
    posto = Posto.offerto;
    if (denCorrente?.id == id) {
      // Un posto libero sul palco della stanza.
      if (palco.length >= palcoMax) palco = palco.sublist(0, palco.length - 1);
      if (ingressoAutomatico) {
        saliSulPalco();
        return;
      }
    }
    banner = BannerProto(TipoBanner.postoLibero, id);
    notifyListeners();
  }

  /// Simulazione «il posto scade» (K4 bis): il posto passa alla persona dopo di te e si resta in coda.
  /// Se si è persa la linea (P1), il posto conservato è stato preso (P3).
  void postoScade() {
    if (lineaPersa && !postoPreso) {
      postoPreso = true;
    } else if (posto == Posto.offerto) {
      posto = Posto.scaduto;
      if (banner != null && banner!.tipo == TipoBanner.postoLibero) banner = null;
      // Il posto passa a un'altra persona: sul palco torna pieno.
      if (denCorrente?.id == postoDen && palco.length < palcoMax) {
        final r = _rimpiazzo();
        if (r != null) palco = [...palco, r];
      }
    }
    notifyListeners();
  }

  bool get puoScadere => posto == Posto.offerto || (lineaPersa && !postoPreso);

  // ------------------------------------------------------------- la linea persa (015 P1–P3)

  bool lineaPersa = false;
  bool postoPreso = false;
  Ritorno ritorno = Ritorno.nessuno;

  bool get puoPerdereLinea => ruolo == Ruolo.sulPalco && !lineaPersa;

  /// Simulazione «perdo la linea»: il palco si congela, il microfono si spegne (P1).
  void perdoLaLinea() {
    if (!puoPerdereLinea) return;
    lineaPersa = true;
    postoPreso = false;
    ritorno = Ritorno.nessuno;
    micAcceso = false;
    notifyListeners();
  }

  /// Simulazione «torno in linea»: il posto c'era (P2) o è stato preso (P3).
  void tornoInLinea() {
    if (!lineaPersa) return;
    lineaPersa = false;
    if (postoPreso) {
      palco = [for (final p in palco) if (p.id != 'io') p];
      // Il posto è stato preso: il palco è di nuovo pieno.
      for (var r = _rimpiazzo(); r != null && palco.length < palcoMax; r = _rimpiazzo()) {
        palco = [...palco, r];
      }
      ruolo = Ruolo.pubblico;
      ritorno = Ritorno.postoPreso;
    } else {
      ritorno = Ritorno.postoRimasto;
    }
    postoPreso = false;
    micAcceso = false;
    notifyListeners();
  }

  /// Simulazione «qualcuno parla»: l'anello passa alla persona successiva sul palco, poi a nessuno.
  void qualcunoParla() {
    final altri = [for (final p in palco) if (p.id != 'io') p.id];
    if (altri.isEmpty) return;
    final i = parla == null ? -1 : altri.indexOf(parla!);
    parla = i + 1 < altri.length ? altri[i + 1] : null;
    notifyListeners();
  }

  // ------------------------------------------------------------- il banner e il richiamo (015 K3, K7)

  BannerProto? banner;

  void togliBanner() {
    banner = null;
    notifyListeners();
  }

  /// Simulazione «arriva un richiamo»: arriva solo da chi ti ha scelto e solo per DEN pubblici (proposta 030).
  void arrivaUnRichiamo() {
    banner = const BannerProto(TipoBanner.richiamo, 'famiglia');
    notifyListeners();
  }

  // ------------------------------------------------------------- creare e gestire un DEN (014)

  /// La prossima «Crea il DEN» non riesce (S2), una volta: «Riprova» riesce.
  bool creazioneFallisce = false;

  void armaFallimentoCreazione() {
    creazioneFallisce = !creazioneFallisce;
    notifyListeners();
  }

  int _creati = 0;

  /// Il DEN nasce e **si entra come amministratore, sul palco, a microfono spento**.
  /// Con la creazione riuscita il fallimento armato si consuma.
  Den creaDen({
    required String nome,
    required bool privato,
    required String descrizione,
    required List<Persona> invitati,
  }) {
    creazioneFallisce = false;
    _creati++;
    final d = Den(
      id: 'mio-$_creati',
      nome: nome,
      palco: invitati.isNotEmpty ? invitati : [_personeDiProva[1], _personeDiProva[2]],
      inAscolto: 0,
      suInvito: privato,
      creatoDaMe: true,
      descrizione: descrizione,
    );
    den.add(d);
    denCorrente = d;
    _azzeraStanza();
    palco = [...d.palco, io];
    ruolo = Ruolo.sulPalco;
    vai(Rotta(Pagina.stanza, den: d.id));
    return d;
  }

  /// I co-amministratori e i sotto-DEN di ogni DEN creato (in memoria).
  final Map<String, List<Persona>> coAmministratori = {};
  final Map<String, List<String>> sottoDen = {};

  void aggiungiCoAmministratore(String denId, Persona p) {
    coAmministratori[denId] = [...?coAmministratori[denId], p];
    notifyListeners();
  }

  void togliCoAmministratore(String denId, String personaId) {
    coAmministratori[denId] = [for (final p in coAmministratori[denId] ?? const <Persona>[]) if (p.id != personaId) p];
    notifyListeners();
  }

  void rimuoviPersona(String id) {
    palco = [for (final p in palco) if (p.id != id) p];
    notifyListeners();
  }

  void creaSottoDen(String denId, String nome) {
    sottoDen[denId] = [...?sottoDen[denId], nome];
    notifyListeners();
  }

  /// «Termina il DEN»: sparisce dall'elenco e si torna all'elenco.
  void terminaDen() {
    final d = denCorrente;
    if (d == null) return;
    den.removeWhere((x) => x.id == d.id);
    coAmministratori.remove(d.id);
    sottoDen.remove(d.id);
    esciDallaStanza();
  }

  void salvaDescrizione(String denId, String testo) {
    final i = den.indexWhere((d) => d.id == denId);
    if (i < 0) return;
    final d = den[i];
    final nuovo = Den(
      id: d.id,
      nome: d.nome,
      palco: d.palco,
      inAscolto: d.inAscolto,
      suInvito: d.suInvito,
      creatoDaMe: d.creatoDaMe,
      descrizione: testo,
    );
    den[i] = nuovo;
    denCorrente = nuovo;
    notifyListeners();
  }

  // ------------------------------------------------------------- il permesso del microfono (001, Fase 2)

  /// Il permesso del microfono: consentito o negato (simulazione del pannello).
  bool permessoMic = true;

  void impostaPermessoMic(bool consentito) {
    permessoMic = consentito;
    notifyListeners();
  }

  // ------------------------------------------------------------- l'account chiuso (027 B1, B1 bis, B2)

  Chiusura? chiusura;
  bool revisioneRichiesta = false;

  void chiudiAccount(Chiusura c) {
    chiusura = c;
    revisioneRichiesta = false;
    notifyListeners();
  }

  void richiediRevisione() {
    revisioneRichiesta = true;
    notifyListeners();
  }

  /// Solo dello strumento: riapre l'account per riprovare.
  void riapriAccount() {
    chiusura = null;
    revisioneRichiesta = false;
    notifyListeners();
  }

  // ------------------------------------------------------------- lo schermo bloccato (027 L1–L4, D-050)

  bool schermoBloccato = false;

  /// Al pubblico e in coda la diretta si mette in pausa (L3 e L4).
  bool inPausa = false;

  bool get puoBloccareLoSchermo => denCorrente != null;

  void bloccaLoSchermo() {
    if (!puoBloccareLoSchermo) return;
    schermoBloccato = true;
    notifyListeners();
  }

  void sbloccaLoSchermo() {
    schermoBloccato = false;
    notifyListeners();
  }

  void cambiaPausa() {
    inPausa = !inPausa;
    notifyListeners();
  }

  /// Dal telefono bloccato il microfono **si spegne** e non si accende (D-025).
  void spegniMic() {
    if (!micAcceso) return;
    micAcceso = false;
    notifyListeners();
  }

  // ------------------------------------------------------------- le persone bloccate

  List<Persona> bloccate = [..._bloccateDiProva];

  void blocca(Persona p) {
    if (bloccate.any((b) => b.id == p.id)) return;
    bloccate = [...bloccate, p];
    notifyListeners();
  }

  void sblocca(Persona p) {
    bloccate = [for (final b in bloccate) if (b.id != p.id) b];
    notifyListeners();
  }
}

/// Il banner delle notifiche (015 K3, K7): una riga in cima alla cornice, senza azioni (D-025),
/// che al tocco porta dove deve. Non scompare da solo: niente timer.
@immutable
class BannerProto {
  const BannerProto(this.tipo, this.den);

  final TipoBanner tipo;
  final String den;
}

/// Mette lo stato a disposizione di tutto l'albero; chi lo legge con [of] si
/// ricostruisce quando cambia.
class ProtoScope extends InheritedNotifier<StatoProto> {
  const ProtoScope({super.key, required StatoProto stato, required super.child}) : super(notifier: stato);

  /// Lo stato, ascoltandolo.
  static StatoProto of(BuildContext context) {
    final s = context.dependOnInheritedWidgetOfExactType<ProtoScope>();
    assert(s != null, 'manca un ProtoScope sopra');
    return s!.notifier!;
  }

  /// Lo stato, senza ascoltarlo (dentro un gestore di tocco).
  static StatoProto leggi(BuildContext context) {
    final s = context.getInheritedWidgetOfExactType<ProtoScope>();
    assert(s != null, 'manca un ProtoScope sopra');
    return s!.notifier!;
  }
}
