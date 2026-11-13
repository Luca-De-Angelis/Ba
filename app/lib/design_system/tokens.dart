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
// Tema unico, scuro. Nessuna coppia chiaro/scuro.
//
// DUE LIVELLI (D-019, task 004). Le primitive (BaPaletteTokens,
// BaPrimitiveTokens) seguono nomi e passi di Tailwind v4; i token semantici di
// BA ci fanno riferimento e restano gli unici che i widget leggono. Un valore
// che non sta in una primitiva è un'ECCEZIONE: ha un nome che lo dice (un
// numero nel nome, come text22) oppure vive in un token di componente con il
// motivo accanto. Dove Tailwind v4 accetterebbe qualunque intero (border-3,
// scale-98, opacity-28) non si finge una scala: si dichiara l'eccezione.
//
// Nomi (D-021): le classi di token finiscono in Tokens. Ba<Componente> è
// riservato ai widget.
//
// Layout: dipende SOLO dalla larghezza (BaLayoutTokens). Nessuna regola
// sull'orientamento, in nessun file.
//
// L'app importa widgets.dart e MAI material.dart. Senza Material non esistono
// Card, elevation, InkWell né ombre di default: la regola 7 non è una
// convenzione da ricordare, è codice che non compila.

import 'package:flutter/widgets.dart';

typedef _P = BaPaletteTokens;
typedef _S = BaPrimitiveTokens;

// ============================================================== PRIMITIVE

/// Colori primitivi, RGB senza alfa. Famiglie con gradazioni alla Tailwind
/// (50–950): i valori esadecimali sono quelli di prima, ciascuno al suo posto.
/// Le gradazioni senza un valore in uso NON sono dichiarate: nessun colore
/// nuovo. Il tema scuro vive quasi tutto sotto il 900, quindi pietra ha passi
/// intermedi (910…975): Tailwind stesso ha aggiunto il 950 nello stesso modo.
class BaPaletteTokens {
  BaPaletteTokens._();

  // pietra — neutri caldi
  static const int pietra50 = 0xF5F1EC;
  static const int pietra100 = 0xF2EEE9;
  static const int pietra400 = 0xA09890;
  static const int pietra500 = 0x8A837B;
  static const int pietra600 = 0x6E6862;
  static const int pietra700 = 0x5E5952;
  static const int pietra800 = 0x3D3B39;
  static const int pietra850 = 0x2A2927;
  static const int pietra900 = 0x1C1917;
  static const int pietra910 = 0x1A1917;
  static const int pietra920 = 0x171413;
  static const int pietra925 = 0x161412;
  static const int pietra940 = 0x100F0E;
  static const int pietra945 = 0x0B0A09;
  static const int pietra950 = 0x0A0A09; // il fondo dell'app
  static const int pietra975 = 0x080706; // keyline e veli
  static const int nero = 0x000000;
  static const int bianco = 0xFFFFFF;

  // sabbia — l'azione chiara e i suoi fondi
  static const int sabbia100 = 0xEDE7DC;
  static const int sabbia200 = 0xE6DCBE;
  static const int sabbia300 = 0xD9CFA8;
  static const int sabbia400 = 0xD2C9B6;
  static const int sabbia900 = 0x302A25;
  static const int sabbia950 = 0x1F1A15;

  // corallo — solo l'errore
  static const int corallo400 = 0xE4705B;

  // il mazzo delle presenze: 700 lo stop chiaro, 900 lo scuro
  static const int indaco700 = 0x5257AC, indaco900 = 0x33367A;
  static const int mattone700 = 0xA83E2E, mattone900 = 0x6E251C;
  static const int bosco700 = 0x23735A, bosco900 = 0x14473A;
  static const int ocra700 = 0x96621A, ocra900 = 0x5F3C0B;
  static const int mare700 = 0x2A6894, mare900 = 0x1B4463;
  static const int lampone700 = 0xAC3765, lampone900 = 0x72203F;
  static const int oliva700 = 0x557426, oliva900 = 0x374A18;
  static const int viola700 = 0x7A3080, viola900 = 0x4E1F52;
  static const int petrolio700 = 0x1C6E75, petrolio900 = 0x114448;
  static const int malva700 = 0x9B4A6E, malva900 = 0x67304A;
  static const int ruggine700 = 0x8A4A2A, ruggine900 = 0x5A2C16;
  static const int muschio700 = 0x3F7A34, muschio900 = 0x26501F;

  // alfa, come il modificatore /n di Tailwind. Interi in percentuale tranne
  // a5_5, che è l'alone di prima (0x0E) e non si arrotonda.
  static const int opaco = 0xFF000000;
  static const int a5_5 = 0x0E000000, a6 = 0x0F000000, a10 = 0x1A000000;
  static const int a12 = 0x1F000000, a14 = 0x24000000, a32 = 0x52000000;
  static const int a34 = 0x57000000, a42 = 0x6B000000, a55 = 0x8C000000;
  static const int a62 = 0x9E000000, a66 = 0xA8000000, a86 = 0xDB000000;
  static const int a92 = 0xEB000000;
}

/// Misure primitive. Spazio su base 4 (Tailwind v4, --spacing: 4): spN = N × 4.
/// Ci sono solo i passi che BA usa.
class BaPrimitiveTokens {
  BaPrimitiveTokens._();

  // spazio
  static const double sp1 = 4, sp1_5 = 6, sp2 = 8, sp2_5 = 10, sp3 = 12;
  static const double sp3_5 = 14, sp4 = 16, sp5 = 20, sp6 = 24, sp7 = 28;
  static const double sp8 = 32, sp11 = 44, sp12 = 48, sp14 = 56;

  // larghezze massime
  static const double maxWLg = 512; // max-w-lg

  // testo (text-*). Una sola estensione: text22, il titolo della stanza.
  static const double textXs = 12, textSm = 14, textBase = 16;
  static const double textLg = 18, textXl = 20;
  static const double text22 = 22; // fuori scala, fra xl (20) e 2xl (24)

  // interlinea e spaziatura
  static const double leadingTight = 1.25, leadingNormal = 1.5;
  static const double leadingSm = 20 / 14; // l'interlinea di text-sm
  static const double trackingWider = 0.05; // em
  static const double trackingMarcatore = 0.06; // em · estensione: fra wider e widest

  // raggi (rounded-*)
  static const double rounded2xl = 16, rounded3xl = 24;
  static const double rounded22 = 22; // estensione: contenitore di iOS, non nostro
  static const double roundedFull = 999; // Tailwind usa 9999: per una pillola è uguale

  // bordi (border-*)
  static const double border1 = 1, border2 = 2;

  // breakpoint, mobile first: la base è il telefono, da 360 dp
  static const double sm = 600; // estensione: Tailwind sm = 640
}

// ============================================================== SEMANTICI

// ---------------------------------------------------------------- colore

class BaColorTokens {
  BaColorTokens._();

  // fondali e superfici
  static const Color fondoApp = Color(_P.opaco | _P.pietra950);
  static const List<Color> fondoStanza = [
    Color(_P.opaco | _P.pietra920),
    Color(_P.opaco | _P.pietra940), // stop 0.52
    Color(_P.opaco | _P.pietra945),
  ];
  static const List<double> fondoStanzaStop = [0.0, 0.52, 1.0];
  static const Color fondoAlone = Color(_P.a5_5 | _P.sabbia200); // radiale, closest-side, 50%/42%
  static const Color superficieFoglio = Color(_P.opaco | _P.pietra925);
  static const Color superficieSistema = Color(_P.a86 | _P.pietra900); // card Live Activity
  static const Color superficieNotifica = Color(_P.opaco | _P.pietra910); // Android, opaca per obbligo
  static const Color superficieIsola = Color(_P.opaco | _P.nero); // nero vero, non il nostro fondo

  // testo
  static const Color testoPrimo = Color(_P.opaco | _P.pietra100);
  static const Color testoSecondo = Color(_P.opaco | _P.pietra400);
  static const Color testoTerzo = Color(_P.opaco | _P.pietra500);
  static const Color testoSpento = Color(_P.opaco | _P.pietra600);
  static const Color testoInattivo = Color(_P.opaco | _P.pietra700);
  static const Color testoSuTinta = Color(_P.opaco | _P.bianco); // iniziali sulle presenze
  static const Color testoSuChiara = Color(_P.opaco | _P.pietra940);

  // filetti
  static const Color filettoAppena = Color(_P.a6 | _P.pietra100);
  static const Color filettoBase = Color(_P.a10 | _P.pietra100);
  static const Color filettoDivisorio = Color(_P.a12 | _P.pietra100);
  static const Color filettoMarcato = Color(_P.a14 | _P.pietra100);

  // azione — vedi BaRegole.azioneChiara
  static const Color azioneChiara = Color(_P.opaco | _P.sabbia300);
  static const List<Color> azioneChiaraPiena = [Color(_P.opaco | _P.sabbia100), Color(_P.opaco | _P.sabbia400)];
  static const Color azioneAttivaBordo = Color(_P.a42 | _P.sabbia300);
  static const List<Color> azioneAttivaFondo = [Color(_P.opaco | _P.sabbia900), Color(_P.opaco | _P.sabbia950)];

  // errore — testo e filetto soltanto. Non esiste erroreFondo, e non esiste
  // nessun colore "successo": le regole 6 non sono violabili perché il valore
  // che servirebbe a violarle non c'è.
  static const Color erroreTesto = Color(_P.opaco | _P.corallo400);
  static const Color erroreFiletto = Color(_P.a32 | _P.corallo400);

  // la voce
  static const Color voceKeyline = Color(_P.a92 | _P.pietra975); // tratto interno, stacca dalla foto
  static const Color voceTratto = Color(_P.opaco | _P.pietra50); // esterno, dentro l'app
  static const Color voceTrattoFermo = Color(_P.a34 | _P.pietra50); // linea instabile
  static const Color voceTrattoStanza = Color(_P.a62 | _P.pietra50); // fuori dall'app, sulla stanza
  static const Color voceTrattoStanzaTenue = Color(_P.a55 | _P.pietra50); // su superficie/isola

  // tocco e focus
  // stati della presenza
  static const List<Color> neutroBloccata = [Color(_P.opaco | _P.pietra800), Color(_P.opaco | _P.pietra850)]; // la tinta scompare, l'identità no
  static const Color veloImmagine = Color(_P.a34 | _P.pietra975); // .34 · tetto di luminanza sulle foto, ColorFiltered
  static const Color veloMutataImmagine = Color(_P.a66 | _P.pietra975); // .66 · voce mutata, con immagine

  static const Color premutoVelo = Color(_P.a6 | _P.pietra100);
  static const Color premutoKeyline = Color(_P.opaco | _P.pietra975);
  static const Color focusAnello = azioneChiara;
  static const Color focusAnelloSuChiara = Color(_P.opaco | _P.pietra940);

  // Task 002 · microfono spento sul palco, chi mi sente, tacca della parola.
  // Nessun colore nuovo: tutto è composto da primitive e da token già qui.
  // Il segno è una forma (disco con glifo barrato) e non un colore: in scala
  // di grigi si legge uguale. Vedi BaPresenzaTokens.badgeDiametro.
  static const Color glifoTratto = Color(_P.a62 | _P.pietra100); // glifo barrato del disco, per gli altri
  static const Color micSpentoFondo = voceKeyline; // disco scuro: la presenza di un altro
  static const Color micSpentoGlifo = glifoTratto;
  static const Color micSpentoBordo = filettoMarcato;
  static const Color micSpentoIoFondo = azioneChiara; // disco chiaro: la mia presenza, si trova fra gli altri
  static const Color micSpentoIoGlifo = testoSuChiara;
  static const Color parolaTacca = azioneChiara; // chi ha la parola, sotto la sagoma
  static const Color parolaTaccaBordo = voceKeyline;
  static const Color ascoltoGruppoBordo = Color(_P.a32 | _P.pietra100); // fascia e cornice a filo: parlo al mio gruppo
  static const List<Color> ascoltoTuttiFondo = azioneChiaraPiena; // fascia piena: parlo a tutti
  static const Color ascoltoTuttiTesto = testoSuChiara;
  static const Color veloSipario = Color(_P.a62 | _P.pietra975); // dietro un foglio aperto
}

/// Le dodici tinte delle presenze. Un mazzo, non una scala: nessuna ha un ruolo.
/// La stanza ne assegna una all'ingresso; unicità garantita solo sul palco
/// (max 8 su 12). Il pubblico può ripetere. Nessuna informazione dipende dalla
/// sola tinta: sono tenute tutte fra L 0,09 e 0,16 apposta.
class BaTintaTokens {
  final Color chiaro;
  final Color scuro;
  const BaTintaTokens(this.chiaro, this.scuro);

  static const List<BaTintaTokens> mazzo = [
    BaTintaTokens(Color(_P.opaco | _P.indaco700), Color(_P.opaco | _P.indaco900)),
    BaTintaTokens(Color(_P.opaco | _P.mattone700), Color(_P.opaco | _P.mattone900)),
    BaTintaTokens(Color(_P.opaco | _P.bosco700), Color(_P.opaco | _P.bosco900)),
    BaTintaTokens(Color(_P.opaco | _P.ocra700), Color(_P.opaco | _P.ocra900)),
    BaTintaTokens(Color(_P.opaco | _P.mare700), Color(_P.opaco | _P.mare900)),
    BaTintaTokens(Color(_P.opaco | _P.lampone700), Color(_P.opaco | _P.lampone900)),
    BaTintaTokens(Color(_P.opaco | _P.oliva700), Color(_P.opaco | _P.oliva900)),
    BaTintaTokens(Color(_P.opaco | _P.viola700), Color(_P.opaco | _P.viola900)),
    BaTintaTokens(Color(_P.opaco | _P.petrolio700), Color(_P.opaco | _P.petrolio900)),
    BaTintaTokens(Color(_P.opaco | _P.malva700), Color(_P.opaco | _P.malva900)),
    BaTintaTokens(Color(_P.opaco | _P.ruggine700), Color(_P.opaco | _P.ruggine900)),
    BaTintaTokens(Color(_P.opaco | _P.muschio700), Color(_P.opaco | _P.muschio900)),
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
class BaSagomaTokens {
  BaSagomaTokens._();

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

class BaRaggioTokens {
  BaRaggioTokens._();
  static const double pillola = _S.roundedFull;
  static const double foglio = _S.rounded3xl; // era 26: 2 dp su un foglio non si vedono
  static const double cardSistema = _S.rounded22; // eccezione: imita il contenitore della Live Activity
  static const double cardNotifica = _S.rounded3xl;
  static const double riquadro = _S.rounded2xl; // era 14
}

// -------------------------------------------------------------- presenza

class BaPresenzaTokens {
  BaPresenzaTokens._();

  static const double sola = 208;
  static const double xl = 156;
  static const double l = 130;
  static const double m = 112;
  static const double s = 88; // sette e otto: 88 e non 92 per stare in 360 dp (vedi baseline sotto)
  // La scala delle presenze è un token di componente (D-009): nessuno di
  // questi valori prende una primitiva, anche dove coincide (208 = sp52).
  static const double minimo = 32; // dove finisce la scala, e con lei le iniziali
  static const double sistema = 36; // lock screen
  static const double sistemaIsola = 34;
  static const double sistemaNotifica = 32;
  static const double pubblico = 22; // sagoma senza iniziali

  /// Da sm in su la scala del palco cresce di una mezza volta: 312, 234, 195,
  /// 168, 132. Tutti interi, rapporti invariati, una dimensione per volta
  /// (regola 5). Il tablet si guarda da più lontano, spesso appoggiato: alla
  /// misura del telefono il gruppo occupa un terzo della larghezza a 744 dp.
  /// minimo (32) NON scala: è il dominio delle iniziali, non una taglia.
  static const double scalaTablet = 1.5;

  /// Diametro sul palco in funzione di quante persone ci sono e della
  /// larghezza dello schermo. La larghezza è obbligatoria apposta: chi
  /// chiamava diametro(n) deve decidere da dove la prende.
  static double diametro(int nSulPalco, double larghezza) {
    final double base;
    if (nSulPalco <= 1) {
      base = sola;
    } else if (nSulPalco == 2) {
      base = xl;
    } else if (nSulPalco <= 4) {
      base = l;
    } else if (nSulPalco <= 6) {
      base = m;
    } else {
      base = s; // 7 e 8: il palco non va oltre
    }
    return BaLayoutTokens.tablet(larghezza) ? base * scalaTablet : base;
  }

  /// Tetto ASSOLUTO di presenze per riga: 3 sul telefono, 4 sul tablet.
  /// NON è il tetto per conteggio del palco (tettoPerRiga, in codice e non
  /// token, che dice quante ne servono per riga a ogni conteggio: da 0 a 8,
  /// [0,1,2,2,2,2,2,3,3]). Quel tetto resta al palco; perRigaMax serve quando
  /// il palco lo supera perché in una riga più larga non ci starebbe altrimenti.
  /// A 680 dp utili quattro a 132 chiedono 597.
  static int perRigaMax(double larghezza) =>
      BaLayoutTokens.tablet(larghezza) ? 4 : 3;

  /// Distanza minima fra i centri: diametro + anello (5) + picco (4) + respiro (8).
  static double distanzaMinima(double d) =>
      d + anelloKeyline + anelloTratto + anelloCrescitaPicco + respiro; // = d + 17

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
  // va ricampionato a BaMovimentoTokens.campionamentoAmpiezza come quello degli
  // altri. Un anello piu' reattivo sulla propria bolla darebbe alla stessa
  // forma due comportamenti, e il primo a notarlo e' chi parla di se'.
  // anello della voce: spessori fissi a ogni scala, o spariscono a 88
  static const double anelloKeyline = 3; // eccezione: 2 o 4 cambierebbero i 17 di D-009
  static const double anelloTratto = _S.border2;
  static const double anelloCrescitaPicco = _S.sp1;
  static const double respiro = _S.sp2; // luce oltre il picco, fra un anello e il vicino

  // escursione del respiro, a una voce
  static const double anelloScalaRiposo = 1.00;
  static const double anelloScalaPicco = 1.075;
  static const double anelloOpacitaRiposo = 0.28;
  static const double anelloOpacitaPicco = 0.95;

  // limiter: con piu' voci l'escursione di ciascun anello si comprime
  static const double limiterDueScala = 1.042;
  static const double limiterDueOpacita = 0.66;
  static const double limiterFattore = 1.12;

  /// Quota dell'escursione a una voce che spetta a ciascun anello con [voci]
  /// voci insieme. Una voce: 1. Da due in su: limiterFattore / voci, cosi'
  /// l'energia visiva totale resta quella a due voci. A due da' 0,56, cioe'
  /// scala 1,042 e opacita' 0,66 (limiterDue*, arrotondati).
  static double quotaEscursione(int voci) =>
      voci <= 1 ? 1.0 : limiterFattore / voci;

  /// Tetto di luminanza relativa, sullo stop piu' chiaro di ogni tinta.
  static const double tettoLuminanza = 0.18;

  // glifo sulla presenza (voce mutata, bloccata)
  static const double glifo = _S.sp7;
  static const double glifoRipiego = _S.sp8; // solo se a 28 non si legge: cresce, non si colora
  static const double glifoOpacitaSpento = 0.45; // → 1 quando la voce mutata parla

  static const int campionePubblico = 3; // bolle del pubblico, campione stabile

  // Disco del microfono spento (task 002): angolo in basso a destra della
  // sagoma, sul bordo della sagoma e non sul bordo del riquadro. Cresce con la
  // presenza fino a areaMinima (44), sempre >= glifo (28).
  static const double badgeRapporto = 0.2; // eccezione: rapporto col diametro
  static const double badgeMax = _S.sp11;
  static const double badgeCentro = 0.854; // eccezione: 0,5 + 0,5 * cos 45°, il punto del bordo a 45°
  // Bordo del disco: 1,5 dp. Eccezione: border1 sparisce sul disco da 28 e
  // border2 mangia il glifo; Tailwind non ha 1,5. Colore: micSpentoBordo.
  static const double badgeBordo = 1.5;
  static double badgeDiametro(double d) => (d * badgeRapporto).clamp(glifo, badgeMax).toDouble();

  // Tacca della parola (sotto-DEN): una funzione, non un titolo. Sta nella
  // luce di 17 fra le sagome e non sposta il packing.
  static const double parolaTaccaAltezza = _S.sp1_5;
  static const double parolaTaccaRapporto = 0.42; // eccezione: rapporto con il diametro
  static const double parolaTaccaSporge = 9; // eccezione: 6 di tacca + 3 di keyline

  // Opacità e rapporti di stato: eccezioni tutte. Sono decisioni del §7, non
  // passi di una scala; arrotondarli al 5 cambierebbe gli stati.
  // filtri di stato
  static const double mutataSaturazione = 0.25;
  static const double mutataOpacita = 0.78;
  static const double inizialiMutataOpacita = 0.80;
  static const double inizialiBloccataOpacita = 0.70;
  static const double persaOpacita = 0.34; // + grayscale(1)
  static const double scheletroOpacitaMin = 0.30; // sagome vuote mentre entro,
  static const double scheletroOpacitaMax = 0.62; // in BaMovimentoTokens.skeleton
  static const double dietroOpacita = 0.22; // + blur 1.5
  static const double dietroSfocatura = 1.5;
}

// -------------------------------------------------------------- tipografia

/// Instrument Sans per ciò che si legge come una frase; IBM Plex Mono solo per
/// i marcatori — stato, conteggi, orari — sempre maiuscolo, spaziato .06em.
class BaTestoTokens {
  BaTestoTokens._();

  static const String famiglia = 'Instrument Sans';
  static const String famigliaMono = 'IBM Plex Mono';

  // Il tracking dei titoli (-0,26 · -0,30 · -0,18) è ottico, per taglia:
  // eccezione, nessun passo di tracking-* gli somiglia (tight = -0,025em).
  static const TextStyle stanza =
      TextStyle(fontFamily: famiglia, fontSize: _S.text22, fontWeight: FontWeight.w600, letterSpacing: -0.26);
  static const TextStyle foglio =
      TextStyle(fontFamily: famiglia, fontSize: _S.textXl, fontWeight: FontWeight.w600, letterSpacing: -0.30, height: _S.leadingTight);
  static const TextStyle riga =
      TextStyle(fontFamily: famiglia, fontSize: _S.textLg, fontWeight: FontWeight.w600, letterSpacing: -0.18);
  static const TextStyle controllo =
      TextStyle(fontFamily: famiglia, fontSize: _S.textBase, fontWeight: FontWeight.w500);
  static const TextStyle corpo =
      TextStyle(fontFamily: famiglia, fontSize: _S.textBase, height: _S.leadingNormal); // le frasi di BA · era 15
  static const TextStyle azione =
      TextStyle(fontFamily: famiglia, fontSize: _S.textSm);
  static const TextStyle minore =
      TextStyle(fontFamily: famiglia, fontSize: _S.textSm, height: _S.leadingSm); // era 13 / 1,45
  static const TextStyle marcatore = TextStyle(
      fontFamily: famigliaMono, fontSize: _S.textXs,
      letterSpacing: _S.textXs * _S.trackingMarcatore); // + toUpperCase() · era 11
  /// Era 10: sotto il passo più piccolo e sotto la leggibilità. Ora coincide
  /// con marcatore salvo la spaziatura; da fondere in un task successivo.
  static const TextStyle nota = TextStyle(
      fontFamily: famigliaMono, fontSize: _S.textXs,
      letterSpacing: _S.textXs * _S.trackingWider);

  /// Le iniziali NON stanno in questa scala: dipendono dal diametro della
  /// sagoma (BaPresenzaTokens.iniziali), non dal ruolo del testo. Fuori dal dominio
  /// non c'è uno stile: chi disegna deve controllare il null e non scrivere
  /// niente, non ripiegare su una taglia minima.
  static TextStyle? iniziali(double diametro, {bool sistema = false}) {
    final d = BaPresenzaTokens.iniziali(diametro, sistema: sistema);
    if (d == null) return null;
    return TextStyle(
      fontFamily: famiglia,
      fontSize: d,
      fontWeight: FontWeight.w600,
      color: BaColorTokens.testoSuTinta,
    );
  }
}

/// Dynamic Type. Il testo scala, la geometria no — ma la scatola del palco è
/// ciò che avanza, quindi il testo che cresce rimpicciolisce le presenze.
/// Vedi "Inventario componenti · Dynamic Type" per il ragionamento.
/// Eccezioni: rapporti di Dynamic Type, non misure.
class BaScalaTokens {
  BaScalaTokens._();

  static const double maxTesto = 2.0; // frasi, titoli, controlli
  static const double maxMarcatore = 1.6; // mono: etichette accanto a numeri
  static const double iniziali = 1.0; // non scalano mai: sono un ritratto

  static double testo(BuildContext c) =>
      MediaQuery.textScalerOf(c).scale(1.0).clamp(1.0, maxTesto);
  static double marcatore(BuildContext c) =>
      MediaQuery.textScalerOf(c).scale(1.0).clamp(1.0, maxMarcatore);
}

// ------------------------------------------------------------ spazio, controlli

class BaSpazioTokens {
  BaSpazioTokens._();
  // base 4 con i mezzi passi sotto il 16: le card di sistema non starebbero
  // in una scala a passo 8
  static const double xxs = _S.sp1, xs = _S.sp1_5, s = _S.sp2, sm = _S.sp2_5;
  static const double m = _S.sp3, md = _S.sp3_5, l = _S.sp4, xl = _S.sp5;
  static const double xxl = _S.sp6, xxxl = _S.sp8, sezione = _S.sp11;
  static const double margineSchermo = _S.sp5;
}

/// Layout per larghezza, mobile first. La base è il telefono; da sm (600) il
/// tablet. 600 e non 640 (sm di Tailwind) né 768 (md): è la soglia con cui
/// Android classifica i tablet (sw600dp) e oltre la quale, da target 37,
/// ignora il blocco dell'orientamento. L'iPad mini in verticale (744 pt) ci
/// sta dentro. MAI una regola sull'orientamento: un tablet in orizzontale è
/// solo uno schermo più largo, e queste funzioni lo gestiscono già.
class BaLayoutTokens {
  BaLayoutTokens._();

  static const double tabletDa = _S.sm;
  static bool tablet(double larghezza) => larghezza >= tabletDa;
  static bool tabletDi(BuildContext c) => tablet(MediaQuery.sizeOf(c).width);

  /// Testi, elenchi, moduli e azioni stanno in una colonna. Sul telefono è lo
  /// schermo meno i margini; sul tablet si ferma a 512, centrata.
  static const double colonna = _S.maxWLg;
  static const double margineTablet = _S.sp8;

  static double margine(double larghezza) =>
      tablet(larghezza) ? margineTablet : BaSpazioTokens.margineSchermo;

  static double larghezzaColonna(double larghezza) {
    final utile = larghezza - 2 * margine(larghezza);
    return utile < colonna ? utile : colonna;
  }

  /// Il palco NON sta nella colonna: prende la larghezza meno i margini.
  static double larghezzaPalco(double larghezza) =>
      larghezza - 2 * margine(larghezza);
}

class BaControlloTokens {
  BaControlloTokens._();
  static const double primario = _S.sp14; // altezza minima: cresce col testo
  static const double coppia = _S.sp12;
  static const double gapCoppia = _S.sp2_5;
  // eccezioni: misure delle superfici di sistema, non nostre
  static const double sistemaLock = 38;
  static const double sistemaIsola = 34;

  static const double areaMinima = _S.sp11; // mai sotto, per niente
  static const double areaEstesa = _S.sp2; // oltre il bordo visibile
  static const double focusSpessore = _S.border2;
  static const double focusStacco = 3; // eccezione: a 2 tocca la keyline, a 4 si stacca dalla sagoma

  /// Premuto di pillole e righe: un valore solo. Una riga larga quanto lo
  /// schermo, a una scala piu' profonda, stacca il bordo dal margine; a 0,98
  /// cede e niente si sposta.
  /// Le presenze non scalano: scuriscono la keyline (BaColorTokens.premutoKeyline).
  /// Eccezione (D-009): Tailwind ha scale-95 e scale-100, non 98.
  static const double premutoScala = 0.98;
}

// ----------------------------------------------------------------- movimento

/// Tutte le durate dell'app. Due curve più la lineare: se serve una terza,
/// prima serve una ragione. Eccezioni tutte: i tempi seguono il campionamento
/// e la percezione (§7.7, D-009), non la scala duration-* di Tailwind
/// (75 · 100 · 150 · 200 · 300 · 500 · 700 · 1000), con cui coincidono solo 200 e 500.
class BaMovimentoTokens {
  BaMovimentoTokens._();

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
  // Task 002. Il disco del microfono spento entra come il glifo; la fascia di
  // ascolto cambia con il ricompattamento. Niente di continuo: il movimento
  // accompagna il cambio e si ferma.
  static const Duration badgeMicrofono = glifo;
  static const Duration fasciaAscolto = ricompattamento;
  static const Duration salitaAttesaMax = Duration(seconds: 8); // eccezione: oltre, torna «Mettiti in coda»
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
///   2. la scala delle presenze, da 208 giù fino a 88 (sul tablet da 312 a 132)
///   3. le iniziali — sotto gli 88 continuano a rimpicciolirsi con la bolla e a
///      32 escono dal dominio (BaPresenzaTokens.iniziali → null): resta la forma
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
///
/// TABLET (da sm): palco largo quanto lo schermo meno 2*32. A 744 sono 680:
/// quattro a 132 chiedono 3*149 + 150 = 597 e stanno, cinque (746) no; da qui
/// perRigaMax = 4. Tre a 195 chiedono 637, la coppia a 234 affiancata 503. A
/// testo grande il palco si abbassa e la stessa catena cede dal 312 in giù.

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
/// della stanza è fissa (BaSagomaTokens.mazzo[0]) e porta l'anello statico.
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
  ///    non i minuti trascorsi). In alpha le memorie dichiarate sono tre: il
  ///    blocco che dai, il profilo derivato alla registrazione e il testo
  ///    trascritto di chi parla, che resta per un periodo (la voce no: si
  ///    cancella appena trascritta). La rimozione che ricevi da un DEN e' beta,
  ///    con i DEN privati: sara' la quarta, nella schermata del blocco. Tutto il
  ///    resto dell'app e' senza memoria; dei sottotitoli locali, se un giorno
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

// ------------------------------------------------------------ glifi del disco

/// Proporzioni dei tre glifi del disco (§7.17), in frazione del LATO del disco
/// misurato dentro il bordo (badgeBordo). Il lato è badgeDiametro(d), da 28 a
/// 44. Il tratto è lo stesso per tutti e a ogni misura: non scala col disco,
/// perché a 28 un tratto da 1 sparisce e a 44 uno da 3 pesa. Origine: il
/// microfono segue il prototipo; l'altoparlante e il cerchio sono la proposta
/// dello sviluppo, corretta da 012c (anello da 84% a 72%).
class BaGlifoTokens {
  BaGlifoTokens._();
  static const double tratto = _S.border2;

  // barra obliqua che segna lo stato, a -45°, ritagliata dal glifo da un alone
  static const double barraGradi = -45;
  static const double barraLato = 0.84; // microfono e altoparlante: lunghezza lungo la diagonale
  static const double barraAlone = 5; // eccezione: tratto + 3

  // microfono: capsula, culla (arco sotto la capsula) e stelo
  static const double capsulaX = 0.36, capsulaY = 0.14, capsulaL = 0.28, capsulaA = 0.38;
  static const double cullaX = 0.22, cullaY = 0.32, cullaL = 0.56, cullaA = 0.30;
  static const double steloY = 0.61, steloA = 0.15; // centrato, largo quanto il tratto

  // altoparlante: corpo, cono e due onde
  static const double corpoX = 0.20, corpoY = 0.38, corpoL = 0.16, corpoA = 0.24;
  static const double conoX = 0.34, conoY = 0.26, conoL = 0.26, conoA = 0.48;
  static const double conoBocca = 0.44; // lato stretto del cono, in frazione della sua altezza
  static const double ondeCentroX = 0.60; // le onde partono dal bordo destro del cono
  static const double ondaInternaRaggio = 0.12, ondaEsternaRaggio = 0.26; // distanza fra le onde 3,5 dp a 28: più del tratto
  static const double ondeGradi = 40; // da -40° a +40°

  // cerchio barrato: anello e barra hanno lo stesso diametro, la barra finisce sull'anello
  static const double cerchioLato = 0.72;
}

// ------------------------------------------------------------ barra e scheda

/// Regola della barra delle azioni (task 002, punto 12): un posto primario e
/// due secondari; dalla quarta azione compare «Altro», che apre un foglio con
/// le rimanenti nell'ordine in cui sono definite. «Esci» e «Scendi dal palco»
/// hanno un posto fisso e non finiscono mai in «Altro». Stessa regola a 360 e
/// a 744 dp: la colonna è di 512 e il numero di posti non cambia.
class BaBarraAzioniTokens {
  BaBarraAzioniTokens._();
  static const int primari = 1;
  static const int secondari = 2;
  static const int posti = primari + secondari; // tre posti, sempre
  static const double altroLato = _S.sp12;
  // Il controllo del microfono sta sempre in uno dei tre posti, mai in
  // «Altro»: chi chiama ordina le azioni in modo che Esci, Scendi dal palco e
  // il microfono siano fra le prime tre.
  static int visibili(int azioni) => azioni < posti ? azioni : posti;
  static int inAltro(int azioni) => azioni > posti ? azioni - posti : 0;
  static bool conAltro(int azioni) => azioni > posti;
}

/// Scheda di una persona: tre azioni fisse (muta, blocca, segnala) e un gruppo
/// sotto un filetto per le azioni nuove, che cresce verso il basso.
class BaSchedaPersonaTokens {
  BaSchedaPersonaTokens._();
  static const int fisse = 3;
  static const double rigaMinima = _S.sp12;
  static const double rigaFissa = _S.sp14;
}

/// Fascia «chi mi sente adesso» (sotto-DEN): sempre sullo schermo, mai un
/// avviso che sparisce. A filo = parlo al mio gruppo; piena = parlo a tutti.
class BaAscoltoTokens {
  BaAscoltoTokens._();
  static const double altezzaMinima = 72; // eccezione: due righe di testo e il riquadro (sp18 non esiste)
  static const double raggio = BaRaggioTokens.riquadro;
  static const double spessore = _S.border1;
  static const double corniceSpessore = _S.border2;
  // La cornice sta FUORI dalla scatola che il palco riceve dal layout, nel
  // margine dello schermo (sp5 = 20): non toglie larghezza al palco. A 360 dp
  // otto presenze a 88 chiedono 316 su 320, e non c'è margine da cedere.
  static const double corniceRaggio = 28; // eccezione: attorno al palco, sopra le sagome da 22
  static const double corniceSporge = _S.sp2; // quanto esce dalla scatola del palco
}

// ------------------------------------------------------------ aptica e suono

/// Un pattern di vibrazione come lo leggono Android (createWaveform) e iOS
/// (Core Haptics): durate in ms alternate fra pausa e impulso, e ampiezza
/// 0–255 per ogni elemento. Si distinguono per numero e durata degli impulsi,
/// non per forza: con il telefono in tasca la forza non si legge.
class BaPatternApticoTokens {
  final String nome;
  final List<int> ms;
  final List<int> ampiezza;
  const BaPatternApticoTokens(this.nome, this.ms, this.ampiezza);
}

/// Un segnale per ogni evento, nessuno per gli altri. Tabella e motivi in
/// design/handoff/002/suono-e-vibrazione.md.
class BaApticaTokens {
  BaApticaTokens._();
  // uno lungo e pieno: aperto
  static const BaPatternApticoTokens microfonoAcceso = BaPatternApticoTokens('microfonoAcceso', [0, 90], [0, 255]);
  // due corti e leggeri: chiuso
  static const BaPatternApticoTokens microfonoSpento = BaPatternApticoTokens('microfonoSpento', [0, 35, 70, 35], [0, 140, 0, 140]);
  // tre che salgono, pausa, e la firma di «spento»: sei salito, il microfono è spento
  static const BaPatternApticoTokens salitaSulPalco = BaPatternApticoTokens(
      'salitaSulPalco', [0, 25, 50, 25, 50, 60, 450, 35, 70, 35], [0, 90, 0, 150, 0, 220, 0, 140, 0, 140]);
  // tre uguali, alla stessa forza di microfonoAcceso: tutti ti sentono. Vale anche per «Parla a tutti»
  static const BaPatternApticoTokens parolaRicevuta = BaPatternApticoTokens('parolaRicevuta', [0, 50, 90, 50, 90, 50], [0, 255, 0, 255, 0, 255]);
  // uno solo, molto lungo e debole: la parola è passata. Si distingue per
  // durata (250 ms contro 90 di microfonoAcceso) e non conta sull'ampiezza
  static const BaPatternApticoTokens parolaRevocata = BaPatternApticoTokens('parolaRevocata', [0, 250], [0, 120]);
  // uno corto e leggero: ora solo il gruppo («Parla solo al gruppo»)
  static const BaPatternApticoTokens soloGruppo = BaPatternApticoTokens('soloGruppo', [0, 35], [0, 140]);
  // due lunghi e deboli: il filo è caduto
  static const BaPatternApticoTokens connessionePersa = BaPatternApticoTokens('connessionePersa', [0, 200, 150, 200], [0, 90, 0, 90]);
  // la firma di «spento»: dopo una ripresa il microfono torna spento
  static const BaPatternApticoTokens connessioneRipresa = microfonoSpento;
}

/// Tre suoni soltanto. Un suono mentre il microfono è aperto finisce nella
/// stanza: per questo sono tutti e tre a microfono spento, e
/// consentito() rende il caso contrario irrappresentabile. Nel sotto-DEN i
/// microfoni sono due (DEN principale e sotto-DEN): microfonoAcceso vuol dire
/// che ALMENO UNO dei due è aperto, e in quel caso nessun suono.
class BaSuonoTokens {
  final String nome;
  final Duration durata;
  const BaSuonoTokens(this.nome, this.durata);

  static const BaSuonoTokens microfonoSpento = BaSuonoTokens('ba_mic_spento', Duration(milliseconds: 180)); // due note che scendono
  static const BaSuonoTokens connessionePersa = BaSuonoTokens('ba_conn_persa', Duration(milliseconds: 300)); // una nota bassa
  static const BaSuonoTokens connessioneRipresa = BaSuonoTokens('ba_conn_ripresa', Duration(milliseconds: 220)); // due note che salgono
  static const double volumeRelativo = 0.5; // eccezione: metà del volume dei contenuti; rispetta silenzioso e cuffie
  /// microfonoAcceso = almeno uno dei due microfoni è aperto.
  static bool consentito({required bool microfonoAcceso}) => !microfonoAcceso;
}

// ------------------------------------------------------------------ accesso

/// Accesso dell'ascoltatore e verifica del numero (task 013, D-031). Nessun
/// colore nuovo: l'errore usa BaColorTokens.erroreTesto e erroreFiletto, il
/// segno «ipotesi» usa azioneChiara e azioneAttivaBordo. L'errore non è mai
/// affidato al colore: porta il segno «!» e una frase.
class BaAccessoTokens {
  BaAccessoTokens._();

  // campo del codice (BaCampoCodice): sei caselle, email e SMS uguali
  static const int codiceCaselle = 6;
  static const double codiceAltezza = _S.sp14;
  static const double codiceGap = _S.sp2;
  static const double codiceRaggio = _S.rounded2xl;
  static const double codiceBordo = _S.border1;
  static const double codiceBordoAttivo = _S.border2; // la casella in scrittura e quelle in errore

  // campo email e numero: una riga con la linea sotto, non una scatola
  static const double campoAltezza = _S.sp14;
  static const double campoLinea = _S.border2;

  // segno «ipotesi · da confermare»: pillola a filo tratteggiata, si toglie in un punto solo
  static const double segnoBordo = _S.border1;
  static const double segnoRaggio = _S.rounded2xl; // non roundedFull: con il testo a capo la pillola deve crescere e non tagliarlo

  // segno «!» dell'errore del codice: cerchio con il punto esclamativo
  static const double erroreSegnoLato = 22; // eccezione: sta sull'altezza della riga di testo, fra sp5 e sp6
  static const double erroreSegnoTratto = _S.border2;

  // dopo un nuovo invio il codice non si richiede per un po': nessun conto alla
  // rovescia a schermo, solo la frase. Eccezione: il valore lo decide il server.
  static const Duration nuovoInvioAttesa = Duration(seconds: 30);

  // foglio «Sali sul palco» a più passi: una scheda sola, il contenuto scorre,
  // le azioni restano. Altezza massima del foglio in frazione dello schermo.
  static const double foglioAltezzaTelefono = 0.8; // eccezione: lascia visibile il palco
  static const double foglioAltezzaTablet = 0.62; // eccezione
}

// ------------------------------------------------------------------ creare e gestire i DEN

/// Creare e gestire i DEN (task 014: D01, D02, D03, D04, D08). Nessun colore
/// nuovo: la scelta e i chip usano azioneChiara e azioneAttivaBordo, gli
/// errori erroreTesto e erroreFiletto. Lo stato scelto non è mai solo colore:
/// ha il bordo spesso e il cerchio pieno (scelta) o il segno di spunta (chip).
class BaCreazioneTokens {
  BaCreazioneTokens._();

  // scelta del tipo di DEN (privato / pubblico): una riga per tipo
  static const double sceltaAltezza = _S.sp14; // minima: cresce col testo
  static const double sceltaRaggio = _S.rounded2xl;
  static const double sceltaBordo = _S.border1;
  static const double sceltaBordoScelta = _S.border2;
  static const double sceltaSegnoLato = BaAccessoTokens.erroreSegnoLato; // eccezione: la stessa del segno «!», sta sull'altezza della riga di testo

  // chip del tema e della lingua: vanno a capo e restano a vista
  static const double chipAltezza = _S.sp12;
  static const double chipGap = _S.sp2;
  static const double chipRaggio = _S.roundedFull;

  // campo della descrizione: tre righe a 16/24 più il respiro
  static const double descrizioneAltezza = 96; // eccezione: sp24 non esiste

  // punto di aggancio: riga tratteggiata che tiene il posto (invitati, persone)
  static const double aggancioAltezza = _S.sp12;
  static const double aggancioRaggio = _S.rounded2xl;
  static const double aggancioBordo = _S.border1; // tratteggiato

  // campo «quando» spento (D07): l'interruttore c'è già e non si può toccare
  static const double quandoInterruttoreLarghezza = _S.sp11;
  static const double quandoInterruttoreAltezza = 26; // eccezione
  static const double quandoPallino = _S.sp4;

  // co-amministratori (D04): l'interfaccia mostra il limite, mai il livello
  static const int coAmministratoriFree = 1; // eccezione: regola di prodotto, non stile
  static const int coAmministratoriPro = 3; // eccezione: regola di prodotto, non stile
}
