// BA · tokens.dart
//
// FONTE DI VERITÀ per ogni valore dell'app: colori, misure, durate, rapporti.
// Se un numero esiste, esiste qui. I documenti di design restano motivazione:
//
//   BA · Token .................. perché quei valori, e le regole d'uso
//   BA · §7 consolidato ......... decisioni sulla rappresentazione
//   BA · Fase 2 schermate ....... esplorazione, non normativa
//   BA · Inventario componenti .. quali widget, con quali stati
//
// In caso di divergenza vince questo file. Chi cambia un valore lo cambia qui
// per primo: se resta scritto solo in un documento, non è stato cambiato.
//
// Tema unico, scuro. Nessuna coppia chiaro/scuro, nessun alias: valori assoluti.
//
// L'app importa widgets.dart e MAI material.dart. Senza Material non esistono
// Card, elevation, InkWell né ombre di default: la regola 7 non è una
// convenzione da ricordare, è codice che non compila.

import 'package:flutter/widgets.dart';

// ---------------------------------------------------------------- colore

class BaColor {
  BaColor._();

  // fondali e superfici
  static const Color fondoApp = Color(0xFF0A0A09);
  static const List<Color> fondoStanza = [
    Color(0xFF171413),
    Color(0xFF100F0E), // stop 0.52
    Color(0xFF0B0A09),
  ];
  static const List<double> fondoStanzaStop = [0.0, 0.52, 1.0];
  static const Color fondoAlone = Color(0x0EE6DCBE); // radiale, closest-side, 50%/42%
  static const Color superficieFoglio = Color(0xFF161412);
  static const Color superficieSistema = Color(0xDB1C1917); // card Live Activity
  static const Color superficieNotifica = Color(0xFF1A1917); // Android, opaca per obbligo
  static const Color superficieIsola = Color(0xFF000000); // nero vero, non il nostro fondo

  // testo
  static const Color testoPrimo = Color(0xFFF2EEE9);
  static const Color testoSecondo = Color(0xFFA09890);
  static const Color testoTerzo = Color(0xFF8A837B);
  static const Color testoSpento = Color(0xFF6E6862);
  static const Color testoInattivo = Color(0xFF5E5952);
  static const Color testoSuTinta = Color(0xFFFFFFFF); // iniziali sulle presenze
  static const Color testoSuChiara = Color(0xFF100F0E);

  // filetti
  static const Color filettoAppena = Color(0x0FF2EEE9); // .06
  static const Color filettoBase = Color(0x1AF2EEE9); // .10
  static const Color filettoDivisorio = Color(0x1FF2EEE9); // .12
  static const Color filettoMarcato = Color(0x24F2EEE9); // .14

  // azione — vedi BaRegole.azioneChiara
  static const Color azioneChiara = Color(0xFFD9CFA8);
  static const List<Color> azioneChiaraPiena = [Color(0xFFEDE7DC), Color(0xFFD2C9B6)];
  static const Color azioneAttivaBordo = Color(0x6BD9CFA8); // .42
  static const List<Color> azioneAttivaFondo = [Color(0xFF302A25), Color(0xFF1F1A15)];

  // errore — testo e filetto soltanto. Non esiste erroreFondo, e non esiste
  // nessun colore "successo": le regole 6 non sono violabili perché il valore
  // che servirebbe a violarle non c'è.
  static const Color erroreTesto = Color(0xFFE4705B);
  static const Color erroreFiletto = Color(0x52E4705B); // .32

  // la voce
  static const Color voceKeyline = Color(0xEB080706); // tratto interno, stacca dalla foto
  static const Color voceTratto = Color(0xFFF5F1EC); // esterno, dentro l'app
  static const Color voceTrattoFermo = Color(0x57F5F1EC); // linea instabile
  static const Color voceTrattoStanza = Color(0x9EF5F1EC); // fuori dall'app, sulla stanza
  static const Color voceTrattoStanzaTenue = Color(0x8CF5F1EC); // su superficie/isola

  // tocco e focus
  static const Color premutoVelo = Color(0x0FF2EEE9);
  static const Color premutoKeyline = Color(0xFF080706);
  static const Color focusAnello = azioneChiara;
  static const Color focusAnelloSuChiara = Color(0xFF100F0E);
}

/// Le dodici tinte delle presenze. Un mazzo, non una scala: nessuna ha un ruolo.
/// La stanza ne assegna una all'ingresso; unicità garantita solo sul palco
/// (max 8 su 12). Il pubblico può ripetere. Nessuna informazione dipende dalla
/// sola tinta: sono tenute tutte fra L 0,09 e 0,16 apposta.
class BaTinta {
  final Color chiaro;
  final Color scuro;
  const BaTinta(this.chiaro, this.scuro);

  static const List<BaTinta> mazzo = [
    BaTinta(Color(0xFF5257AC), Color(0xFF33367A)),
    BaTinta(Color(0xFFA83E2E), Color(0xFF6E251C)),
    BaTinta(Color(0xFF23735A), Color(0xFF14473A)),
    BaTinta(Color(0xFF96621A), Color(0xFF5F3C0B)),
    BaTinta(Color(0xFF2A6894), Color(0xFF1B4463)),
    BaTinta(Color(0xFFAC3765), Color(0xFF72203F)),
    BaTinta(Color(0xFF557426), Color(0xFF374A18)),
    BaTinta(Color(0xFF7A3080), Color(0xFF4E1F52)),
    BaTinta(Color(0xFF1C6E75), Color(0xFF114448)),
    BaTinta(Color(0xFF9B4A6E), Color(0xFF67304A)),
    BaTinta(Color(0xFF8A4A2A), Color(0xFF5A2C16)),
    BaTinta(Color(0xFF3F7A34), Color(0xFF26501F)),
  ];

  /// 155° come in tutte le superfici: la luce viene sempre da in alto a sinistra.
  LinearGradient get gradiente => LinearGradient(
        begin: const Alignment(-0.72, -1.0),
        end: const Alignment(0.72, 1.0),
        colors: [chiaro, scuro],
      );
}

// ------------------------------------------------------------------ forma

/// Cinque sagome irregolari. Le assegna la STANZA, non la persona: la stessa
/// persona ha una forma diversa in un altro DEN (§7.3).
class BaSagoma {
  BaSagoma._();

  /// [oTL, oTR, oBR, oBL, vTL, vTR, vBR, vBL] come frazioni del diametro.
  static const List<List<double>> mazzo = [
    [.56, .44, .51, .49, .47, .53, .53, .47],
    [.47, .53, .58, .42, .55, .45, .42, .58],
    [.52, .48, .42, .58, .43, .57, .54, .46],
    [.44, .56, .47, .53, .57, .43, .51, .49],
    [.54, .46, .52, .48, .50, .50, .55, .45],
  ];

  static BorderRadius bordo(int indice, double d) {
    final s = mazzo[indice % mazzo.length];
    return BorderRadius.only(
      topLeft: Radius.elliptical(d * s[0], d * s[4]),
      topRight: Radius.elliptical(d * s[1], d * s[5]),
      bottomRight: Radius.elliptical(d * s[2], d * s[6]),
      bottomLeft: Radius.elliptical(d * s[3], d * s[7]),
    );
  }
}

class BaRaggio {
  BaRaggio._();
  static const double pillola = 999;
  static const double foglio = 26;
  static const double cardSistema = 22;
  static const double cardNotifica = 24;
  static const double riquadro = 14;
}

// -------------------------------------------------------------- presenza

class BaPresenza {
  BaPresenza._();

  static const double sola = 208;
  static const double xl = 156;
  static const double l = 130;
  static const double m = 112;
  static const double s = 88; // sette e otto: 88 e non 92 per stare in 360 dp (vedi baseline sotto)
  static const double minimo = 32; // dove finisce la scala, e con lei le iniziali
  static const double sistema = 36; // lock screen
  static const double sistemaIsola = 34;
  static const double sistemaNotifica = 32;
  static const double pubblico = 22; // sagoma muta

  /// Diametro sul palco in funzione di quante persone ci sono.
  static double diametro(int nSulPalco) {
    if (nSulPalco <= 1) return sola;
    if (nSulPalco == 2) return xl;
    if (nSulPalco <= 4) return l;
    if (nSulPalco <= 6) return m;
    return s; // 7 e 8: il palco non va oltre
  }

  /// Distanza minima fra i centri: diametro + anello (5) + picco (4) + respiro (8).
  static double distanzaMinima(double d) => d + 17;

  /// Dimensione delle iniziali, CON IL SUO DOMINIO. Le branche vanno lette
  /// insieme: la formula da sola è sbagliata.
  ///   app,     d >= 32 → 0,295   (tutto il palco, a qualunque scala)
  ///   sistema, 32..36  → 0,35    (il testo deve reggere lo schermo bloccato,
  ///                              quindi cresce più della sagoma)
  ///   d < 32           → null    (nessuna iniziale: resta la sola sagoma)
  /// Il rapporto lo decide il CONTESTO, non il diametro: a testo di sistema
  /// grande una presenza sul palco può stare a 34 pt, cioè alla misura del
  /// lock screen, e dedurre il rapporto dalla taglia farebbe crescere le
  /// iniziali mentre la sagoma si rimpicciolisce. Un solo rapporto per tutto
  /// il palco: le iniziali scendono con la bolla, fino a sparire.
  static double? iniziali(double d, {bool sistema = false}) {
    if (d < minimo) return null;
    return (d * (sistema ? 0.35 : 0.295)).roundToDouble();
  }

  // Il livello del partecipante locale e' leggibile a qualunque frequenza:
  // va ricampionato a BaMovimento.campionamentoAmpiezza come quello degli
  // altri. Un anello piu' reattivo sulla propria bolla darebbe alla stessa
  // forma due comportamenti, e il primo a notarlo e' chi parla di se'.
  // anello della voce: spessori fissi a ogni scala, o spariscono a 92
  static const double anelloKeyline = 3;
  static const double anelloTratto = 2;

  // filtri di stato
  static const double abbassataSaturazione = 0.25;
  static const double abbassataOpacita = 0.78;
  static const double persaOpacita = 0.34; // + grayscale(1)
  static const double dietroOpacita = 0.22; // + blur 1.5
  static const double dietroSfocatura = 1.5;
}

// -------------------------------------------------------------- tipografia

/// Instrument Sans per ciò che si legge come una frase; IBM Plex Mono solo per
/// i marcatori — stato, conteggi, orari — sempre maiuscolo, spaziato .06em.
class BaTesto {
  BaTesto._();

  static const String famiglia = 'Instrument Sans';
  static const String famigliaMono = 'IBM Plex Mono';

  static const TextStyle stanza =
      TextStyle(fontFamily: famiglia, fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.26);
  static const TextStyle foglio =
      TextStyle(fontFamily: famiglia, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.30, height: 1.25);
  static const TextStyle riga =
      TextStyle(fontFamily: famiglia, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.18);
  static const TextStyle controllo =
      TextStyle(fontFamily: famiglia, fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle corpo =
      TextStyle(fontFamily: famiglia, fontSize: 15, height: 1.5); // le frasi di BA
  static const TextStyle azione =
      TextStyle(fontFamily: famiglia, fontSize: 14);
  static const TextStyle minore =
      TextStyle(fontFamily: famiglia, fontSize: 13, height: 1.45);
  static const TextStyle marcatore = TextStyle(
      fontFamily: famigliaMono, fontSize: 11, letterSpacing: 0.66); // + toUpperCase()
  static const TextStyle nota =
      TextStyle(fontFamily: famigliaMono, fontSize: 10, letterSpacing: 0.5);

  /// Le iniziali NON stanno in questa scala: dipendono dal diametro della
  /// sagoma (BaPresenza.iniziali), non dal ruolo del testo. Fuori dal dominio
  /// non c'è uno stile: chi disegna deve controllare il null e non scrivere
  /// niente, non ripiegare su una taglia minima.
  static TextStyle? iniziali(double diametro, {bool sistema = false}) {
    final d = BaPresenza.iniziali(diametro, sistema: sistema);
    if (d == null) return null;
    return TextStyle(
      fontFamily: famiglia,
      fontSize: d,
      fontWeight: FontWeight.w600,
      color: BaColor.testoSuTinta,
    );
  }
}

/// Dynamic Type. Il testo scala, la geometria no — ma la scatola del palco è
/// ciò che avanza, quindi il testo che cresce rimpicciolisce le presenze.
/// Vedi "Inventario componenti · Dynamic Type" per il ragionamento.
class BaScala {
  BaScala._();

  static const double maxTesto = 2.0; // frasi, titoli, controlli
  static const double maxMarcatore = 1.6; // mono: etichette accanto a numeri
  static const double iniziali = 1.0; // non scalano mai: sono un ritratto

  static double testo(BuildContext c) =>
      MediaQuery.textScalerOf(c).scale(1.0).clamp(1.0, maxTesto);
  static double marcatore(BuildContext c) =>
      MediaQuery.textScalerOf(c).scale(1.0).clamp(1.0, maxMarcatore);
}

// ------------------------------------------------------------ spazio, controlli

class BaSpazio {
  BaSpazio._();
  // scala a passo 2, non a passo 8: le card di sistema non ci starebbero
  static const double xxs = 4, xs = 6, s = 8, sm = 10, m = 12, md = 14;
  static const double l = 16, xl = 20, xxl = 24, xxxl = 32, sezione = 44;
  static const double margineSchermo = 20;
}

class BaControllo {
  BaControllo._();
  static const double primario = 56; // altezza minima: cresce col testo
  static const double coppia = 48;
  static const double gapCoppia = 10;
  static const double sistemaLock = 38;
  static const double sistemaIsola = 34;

  static const double areaMinima = 44; // mai sotto, per niente
  static const double areaEstesa = 8; // oltre il bordo visibile
  static const double focusSpessore = 2;
  static const double focusStacco = 3;
}

// ----------------------------------------------------------------- movimento

/// Tutte le durate dell'app. Due curve più la lineare: se serve una terza,
/// prima serve una ragione.
class BaMovimento {
  BaMovimento._();

  static const Cubic curvaAssestamento = Cubic(0.22, 0.9, 0.25, 1.0); // si sposta, cambia scala
  static const Cubic curvaScheda = Cubic(0.34, 1.2, 0.64, 1.0); // appare sopra il resto

  // L'anello sta su DUE canali, e i token seguono la divisione.
  //
  // Canale veloce — ActiveSpeakersChanged: l'anello compare e scompare. E' un
  // fatto booleano, arriva presto, e regge da solo tutto il significato
  // ("chi parla"): con il ripiego statico resta solo questo.
  // Canale lento — ampiezza campionata dall'SDK (LiveKit, 500 ms di default):
  // il respiro dell'anello fra il minimo e il picco. E' decorazione informata,
  // non informazione.
  static const Duration campionamentoAmpiezza = Duration(milliseconds: 500);

  static const Duration voceAttacco = Duration(milliseconds: 70); // SOLO comparsa (canale veloce)
  static const Duration voceScomparsa = Duration(milliseconds: 140); // canale veloce
  /// Respiro sul canale lento. Vincolo: >= campionamentoAmpiezza, sempre.
  /// Con un rilascio piu' corto dell'intervallo di campionamento l'anello si
  /// sgonfia fra un campione e l'altro e si rigonfia al successivo: un dente di
  /// sega alla frequenza di campionamento, che non ha piu' niente a che vedere
  /// con la voce. I 600 danno margine al jitter dei pacchetti.
  static const Duration voceRilascio = Duration(milliseconds: 600);
  static const Duration glifo = Duration(milliseconds: 140);
  static const Duration premutoAndata = Duration(milliseconds: 90);
  static const Duration premutoRitorno = Duration(milliseconds: 140);
  static const Duration scheda = Duration(milliseconds: 180);
  static const Duration foglio = Duration(milliseconds: 240);
  static const Duration assestamento = Duration(milliseconds: 320);
  static const Duration ricompattamento = Duration(milliseconds: 200);
  static const Duration comparsa = Duration.zero; // le presenze ci sono o non ci sono

  static const Duration attesaIngresso = Duration(seconds: 4); // debounce prima di assestare
  static const Duration attesaUscita = Duration(seconds: 6);
  static const Duration skeleton = Duration(milliseconds: 1800); // .30 → .62
  static const Duration sogliaInstabile = Duration(seconds: 4);
  static const Duration sogliaPersa = Duration(seconds: 12);
  static const Duration riprovaAutomatica = Duration(seconds: 8);

  /// Ripiego statico: movimento ridotto, screen reader, degrado termico.
  /// Non è una modalità nostra, è quella del telefono.
  static bool statico(BuildContext c) {
    final mq = MediaQuery.of(c);
    return mq.disableAnimations || mq.accessibleNavigation;
  }

  static Duration durata(BuildContext c, Duration d) =>
      statico(c) ? Duration.zero : d;
}

// --------------------------------------------------- quando lo spazio non basta

/// Ordine di cessione, e non ce n'è un altro. A testo di sistema grande su uno
/// schermo piccolo la scatola del palco si stringe; cedono, in quest'ordine:
///
///   1. l'alone e i margini verticali del palco
///   2. la scala delle presenze, da 208 giù fino a 88
///   3. le iniziali — sotto i 92 continuano a rimpicciolirsi con la bolla e a
///      32 escono dal dominio (BaPresenza.iniziali → null): resta la forma
///      colorata, che porta comunque presenza, tinta e anello
///
/// LE SAGOME NON CEDONO MAI. Nessuna presenza passa al contatore per fare
/// spazio, nessuno scambia posto, nessuna priorità da calcolare: chi è sul
/// palco è a schermo. L'88 non è un fondo: era il minimo con le
/// iniziali dentro — togliendo quelle, la scala prosegue.
///
/// La catena finisce a 32, e ci arriva: otto sagome a 32 pt con 17 di respiro
/// stanno in 150×150 pt, meno di quanto avanzi a scala 2,0 sul telefono più
/// piccolo. Il caso che rompeva non esiste più — non perché lo gestiamo, ma
/// perché non lo raggiungiamo.
///
/// BASELINE STRETTA: 360 dp (Android), non 375 pt. Larghezza utile del palco
/// 360 - 2*20 = 320. Una fila di k sagome chiede
///   (k-1)*(d+17) + d + 18   [i 18 sono anello 5 + picco 4 sui due bordi esterni]
/// Da cui, a 320: tre a 92 chiedono 328 e NON stanno (mancano 8); tre a 88
/// chiedono 316 e stanno con 4 di margine. Per questo il fondo del palco e'
/// 88 e non 92. Da cui anche: la coppia a 156 non sta affiancata (347 > 320),
/// e l'impacchettamento la mette in diagonale — vincolo del packing, non una
/// scala nuova.

// ------------------------------------------------------------ tempo, payload

/// L'unico modo in cui l'app dice un tempo. Non esiste un formattatore di
/// durate, e non ci sarà: senza di quello la regola 3 — nessun contatore che
/// accumula — non è violabile per distrazione.
class BaOra {
  BaOra._();
  static String hhmm(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

/// Ciò che viaggia verso le superfici di sistema (Live Activity, notifica).
/// Non ha un campo "chi parla", e non è una dimenticanza: fuori dall'app quel
/// dato non è aggiornabile abbastanza spesso per essere vero, quindi la
/// regola 4 è irrappresentabile a livello di payload.
///
/// Le sagome qui sono ALLINEATE, non impacchettate: nessuna geometria da
/// serializzare, e BaPalco resta un'implementazione sola, in Dart. La sagoma
/// della stanza è fissa (BaSagoma.mazzo[0]) e porta l'anello statico.
class BaPayloadStanza {
  final String stanza;
  final int sulPalco;
  final DateTime inizio;
  final List<int> tinte; // al massimo 4, in ordine di ingresso
  final List<String> iniziali;
  const BaPayloadStanza({
    required this.stanza,
    required this.sulPalco,
    required this.inizio,
    required this.tinte,
    required this.iniziali,
  });
}

// -------------------------------------------------------------------- regole

/// Regole che nessun valore può portare da solo. Stanno qui perché il codice
/// che le viola compila lo stesso.
abstract class BaRegole {
  /// 1. azione/chiara compare SOLO dove l'app non può proseguire senza un gesto
  ///    dell'utente, che nessun altro può fare al posto suo. Una per schermata.
  ///    Tutto il resto è hairline.
  /// 2. Nessuna informazione affidata alla sola tinta.
  /// 3. Nessun contatore che accumula: si mostrano fatti fermi (l'ora d'inizio,
  ///    non i minuti trascorsi). Le memorie dichiarate sono tre e non aumentano:
  ///    il blocco che dai, la rimozione che ricevi — che stanno nella stessa
  ///    schermata — e il profilo derivato alla registrazione. Tutto il resto
  ///    dell'app e' senza memoria; dei sottotitoli locali, se un giorno
  ///    esisteranno, non ne aggiungono una quarta: non si scrivono da nessuna
  ///    parte.
  /// 4. Fuori dall'app l'anello sta sulla STANZA, fermo. Dentro sta sulla
  ///    persona e segue la voce.
  /// 5. Il palco ha una dimensione sola per volta: dimensioni diverse fra le
  ///    persone sono rango.
  /// 6. errore non ha una variante riempita, e non esiste un colore "successo".
  /// 7. Nessuna ombra, nessuna elevazione: le superfici si distinguono per
  ///    fondo e filetto. L'unica profondità è l'alone dietro il palco.
  /// 8. Le sagome non cedono mai. Quando lo spazio non basta cedono, in
  ///    ordine: alone e margini, la scala, le iniziali.
  ///
  /// Di queste, cinque non sono più violabili perché manca lo strumento per
  /// violarle: 3 (nessun formattatore di durate), 4 (nessun campo "chi parla"
  /// nel payload), 6 (nessun colore di riempimento per l'errore, nessun
  /// successo), 7 (nessun import di material.dart), 8 (il palco non ha un
  /// parametro "quante disegnarne": prende le persone sul palco e le disegna
  /// tutte, e le iniziali le dà il dominio, non il chiamante).
  /// Altre due diventano irrappresentabili nel livello dei widget — la 1 con
  /// un solo posto per la richiesta nello scaffold, la 5 con il diametro
  /// ereditato dal palco invece che passato dal chiamante (Inventario, C8).
  /// Resta convenzione la 2, e va guardata in revisione: nessun tipo può
  /// impedire di affidare un significato a una tinta.
}
