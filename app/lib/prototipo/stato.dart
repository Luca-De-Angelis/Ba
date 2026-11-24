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
enum Ruolo { pubblico, sulPalco }

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
  });

  final String id;
  final String nome;

  /// Chi sta sul palco (da 0 a 8).
  final List<Persona> palco;
  final int inAscolto;
  final bool suInvito;
  final String? frase;
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
];

class StatoProto extends ChangeNotifier {
  StatoProto();

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
    ruolo = Ruolo.pubblico;
    micAcceso = false;
    bloccate = [..._bloccateDiProva];
    azzera(const Rotta(Pagina.email));
  }

  // ------------------------------------------------------------- l'elenco e la stanza

  final List<Den> den = denDiProva;

  /// I DEN che l'elenco mostra: un privato su invito solo a un partecipante (D-041).
  List<Den> get denVisibili => [for (final d in den) if (!d.suInvito || partecipante) d];

  Den? denCorrente;

  /// Chi sta sul palco della stanza in cui si è (con me, se sono sul palco).
  List<Persona> palco = const [];
  Ruolo ruolo = Ruolo.pubblico;
  bool micAcceso = false;

  /// Chi sta parlando adesso (l'anello), se qualcuno parla. In «Cucina di notte» parla
  /// Marta B. (004); le simulazioni del 024b lo cambiano.
  String? parla;

  static const int palcoMax = 8;

  /// Il profilo di chi usa il prototipo, sulla sagoma «io».
  Persona get io {
    final lettera = nickname.isEmpty ? 'IO' : nickname.substring(0, 1).toUpperCase();
    return Persona('io', nickname.isEmpty ? 'Tu' : nickname, lettera, 11, 1);
  }

  /// Entra in una stanza **come pubblico** (D-006), con il microfono spento.
  void entraInDen(Den d) {
    denCorrente = d;
    palco = [...d.palco];
    ruolo = Ruolo.pubblico;
    micAcceso = false;
    parla = d.id == 'cucina' ? 'mb' : null;
    vai(Rotta(Pagina.stanza, den: d.id));
  }

  /// Esce dalla stanza e torna all'elenco.
  void esciDallaStanza() {
    denCorrente = null;
    palco = const [];
    ruolo = Ruolo.pubblico;
    micAcceso = false;
    if (corrente.pagina == Pagina.stanza) {
      indietro();
    } else {
      notifyListeners();
    }
  }

  /// Sale sul palco **a microfono spento** (D-007).
  void saliSulPalco() {
    if (ruolo == Ruolo.sulPalco || palco.length >= palcoMax) return;
    palco = [...palco, io];
    ruolo = Ruolo.sulPalco;
    micAcceso = false;
    notifyListeners();
  }

  void scendiDalPalco() {
    palco = [for (final p in palco) if (p.id != 'io') p];
    ruolo = Ruolo.pubblico;
    micAcceso = false;
    notifyListeners();
  }

  void cambiaMic() {
    if (ruolo != Ruolo.sulPalco) return;
    micAcceso = !micAcceso;
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
