import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/tokens.dart';

void main() {
  group('BaPresenza.diametro', () {
    test('segue la scala 208, 156, 130, 112, 88 da 1 a 8 persone', () {
      const attesi = {
        1: 208.0,
        2: 156.0,
        3: 130.0,
        4: 130.0,
        5: 112.0,
        6: 112.0,
        7: 88.0,
        8: 88.0,
      };
      attesi.forEach((persone, diametro) {
        expect(BaPresenza.diametro(persone), diametro, reason: '$persone sul palco');
      });
    });

    test('non cresce mai al crescere delle persone', () {
      for (var n = 1; n < 8; n++) {
        expect(BaPresenza.diametro(n + 1), lessThanOrEqualTo(BaPresenza.diametro(n)));
      }
    });

    test('la distanza minima fra i centri è diametro + 17', () {
      expect(BaPresenza.distanzaMinima(88), 105);
    });

    test('distanzaMinima(d) == d + 17 per i cinque diametri della scala', () {
      for (final d in [
        BaPresenza.sola,
        BaPresenza.xl,
        BaPresenza.l,
        BaPresenza.m,
        BaPresenza.s,
      ]) {
        expect(BaPresenza.distanzaMinima(d), d + 17, reason: '$d');
      }
    });
  });

  group('respiro dell\'anello e limiter', () {
    test('quotaEscursione: 1 → 1, 2 → 0,56, 3 → 1,12/3', () {
      expect(BaPresenza.quotaEscursione(1), 1);
      expect(BaPresenza.quotaEscursione(2), closeTo(0.56, 1e-9));
      expect(BaPresenza.quotaEscursione(3), closeTo(1.12 / 3, 1e-9));
    });

    test('con due voci l\'escursione dà i valori del limiter a due voci', () {
      final quota = BaPresenza.quotaEscursione(2);
      final scala = BaPresenza.anelloScalaRiposo +
          (BaPresenza.anelloScalaPicco - BaPresenza.anelloScalaRiposo) * quota;
      final opacita = BaPresenza.anelloOpacitaRiposo +
          (BaPresenza.anelloOpacitaPicco - BaPresenza.anelloOpacitaRiposo) * quota;
      expect(scala, closeTo(BaPresenza.limiterDueScala, 0.001));
      expect(opacita, closeTo(BaPresenza.limiterDueOpacita, 0.01));
    });
  });

  group('stati della presenza e premuto', () {
    test('premutoScala vale 0,98', () {
      expect(BaControllo.premutoScala, 0.98);
    });

    test('neutroBloccata ha due colori', () {
      expect(BaColor.neutroBloccata, hasLength(2));
      expect(BaColor.neutroBloccata[0], isNot(BaColor.neutroBloccata[1]));
    });

    test('i due veli sulle immagini hanno alfa 0,34 e 0,66', () {
      expect(BaColor.veloImmagine.a, closeTo(0.34, 0.005));
      expect(BaColor.veloMutataImmagine.a, closeTo(0.66, 0.005));
    });

    test('la sagoma vuota dello scheletro respira fra un minimo e un massimo', () {
      expect(BaPresenza.scheletroOpacitaMin, lessThan(BaPresenza.scheletroOpacitaMax));
    });
  });
}
