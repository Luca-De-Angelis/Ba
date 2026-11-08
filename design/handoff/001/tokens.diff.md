> Superato dal giro 001b: non contiene scheletroOpacitaMin e Max. Fa fede il diff di tokens.dart.

# tokens.diff.md — task 001

Solo le righe cambiate di `design/system/tokens.dart`. `-` tolta, `+` aggiunta. Il file importa sempre e solo `package:flutter/widgets.dart`.

## BaColor — stati della presenza (D-010)

```diff
+  // stati della presenza
+  static const List<Color> neutroBloccata = [Color(0xFF3D3B39), Color(0xFF2A2927)]; // la tinta scompare, l'identità no
+  static const Color veloImmagine = Color(0x57080706); // .34 · tetto di luminanza sulle foto, ColorFiltered
+  static const Color veloMutataImmagine = Color(0xA8080706); // .66 · voce mutata, con immagine
+
   static const Color premutoVelo = Color(0x0FF2EEE9);
```

## BaPresenza

```diff
-  static const double pubblico = 22; // sagoma muta
+  static const double pubblico = 22; // sagoma senza iniziali
```

```diff
   /// Distanza minima fra i centri: diametro + anello (5) + picco (4) + respiro (8).
-  static double distanzaMinima(double d) => d + 17;
+  static double distanzaMinima(double d) =>
+      d + anelloKeyline + anelloTratto + anelloCrescitaPicco + respiro; // = d + 17
```

```diff
-  // anello della voce: spessori fissi a ogni scala, o spariscono a 92
+  // anello della voce: spessori fissi a ogni scala, o spariscono a 88
   static const double anelloKeyline = 3;
   static const double anelloTratto = 2;
+  static const double anelloCrescitaPicco = 4;
+  static const double respiro = 8; // luce oltre il picco, fra un anello e il vicino
+
+  // escursione del respiro, a una voce
+  static const double anelloScalaRiposo = 1.00;
+  static const double anelloScalaPicco = 1.075;
+  static const double anelloOpacitaRiposo = 0.28;
+  static const double anelloOpacitaPicco = 0.95;
+
+  // limiter: con piu' voci l'escursione di ciascun anello si comprime
+  static const double limiterDueScala = 1.042;
+  static const double limiterDueOpacita = 0.66;
+  static const double limiterFattore = 1.12;
+
+  /// Quota dell'escursione a una voce che spetta a ciascun anello con [voci]
+  /// voci insieme. Una voce: 1. Da due in su: limiterFattore / voci, cosi'
+  /// l'energia visiva totale resta quella a due voci. A due da' 0,56, cioe'
+  /// scala 1,042 e opacita' 0,66 (limiterDue*, arrotondati).
+  static double quotaEscursione(int voci) =>
+      voci <= 1 ? 1.0 : limiterFattore / voci;
+
+  /// Tetto di luminanza relativa, sullo stop piu' chiaro di ogni tinta.
+  static const double tettoLuminanza = 0.18;
+
+  // glifo sulla presenza (voce mutata, bloccata)
+  static const double glifo = 28;
+  static const double glifoRipiego = 32; // solo se a 28 non si legge: cresce, non si colora
+  static const double glifoOpacitaSpento = 0.45; // → 1 quando la voce mutata parla
+
+  static const int campionePubblico = 3; // bolle del pubblico, campione stabile
```

```diff
   // filtri di stato
-  static const double abbassataSaturazione = 0.25;
-  static const double abbassataOpacita = 0.78;
+  static const double mutataSaturazione = 0.25;
+  static const double mutataOpacita = 0.78;
+  static const double inizialiMutataOpacita = 0.80;
+  static const double inizialiBloccataOpacita = 0.70;
```

## BaControllo — premuto (D-009)

```diff
   static const double focusStacco = 3;
+
+  /// Premuto di pillole e righe: un valore solo. Una riga larga quanto lo
+  /// schermo, a una scala piu' profonda, stacca il bordo dal margine; a 0,98
+  /// cede e niente si sposta.
+  /// Le presenze non scalano: scuriscono la keyline (BaColor.premutoKeyline).
+  static const double premutoScala = 0.98;
 }
```

## Ordine di cessione (D-009)

```diff
-///   3. le iniziali — sotto i 92 continuano a rimpicciolirsi con la bolla e a
+///   3. le iniziali — sotto gli 88 continuano a rimpicciolirsi con la bolla e a
```

## BaRegole 3 (D-004, D-005)

```diff
   /// 3. Nessun contatore che accumula: si mostrano fatti fermi (l'ora d'inizio,
-  ///    non i minuti trascorsi). Le memorie dichiarate sono tre e non aumentano:
-  ///    il blocco che dai, la rimozione che ricevi — che stanno nella stessa
-  ///    schermata — e il profilo derivato alla registrazione. Tutto il resto
-  ///    dell'app e' senza memoria; dei sottotitoli locali, se un giorno
+  ///    non i minuti trascorsi). In alpha le memorie dichiarate sono tre: il
+  ///    blocco che dai, il profilo derivato alla registrazione e il testo
+  ///    trascritto di chi parla, che resta per un periodo (la voce no: si
+  ///    cancella appena trascritta). La rimozione che ricevi da un DEN e' beta,
+  ///    con i DEN privati: sara' la quarta, nella schermata del blocco. Tutto il
+  ///    resto dell'app e' senza memoria; dei sottotitoli locali, se un giorno
```
