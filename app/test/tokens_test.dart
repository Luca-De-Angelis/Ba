import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/tokens.dart';

void main() {
  group('BaPresenzaTokens.diametro', () {
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
        expect(BaPresenzaTokens.diametro(persone, 360), diametro, reason: '$persone sul palco');
      });
    });

    test('non cresce mai al crescere delle persone', () {
      for (var n = 1; n < 8; n++) {
        expect(BaPresenzaTokens.diametro(n + 1, 360), lessThanOrEqualTo(BaPresenzaTokens.diametro(n, 360)));
      }
    });

    test('la distanza minima fra i centri è diametro + 17', () {
      expect(BaPresenzaTokens.distanzaMinima(88), 105);
    });

    test('distanzaMinima(d) == d + 17 per i cinque diametri della scala', () {
      for (final d in [
        BaPresenzaTokens.sola,
        BaPresenzaTokens.xl,
        BaPresenzaTokens.l,
        BaPresenzaTokens.m,
        BaPresenzaTokens.s,
      ]) {
        expect(BaPresenzaTokens.distanzaMinima(d), d + 17, reason: '$d');
      }
    });
  });

  group('respiro dell\'anello e limiter', () {
    test('quotaEscursione: 1 → 1, 2 → 0,56, 3 → 1,12/3', () {
      expect(BaPresenzaTokens.quotaEscursione(1), 1);
      expect(BaPresenzaTokens.quotaEscursione(2), closeTo(0.56, 1e-9));
      expect(BaPresenzaTokens.quotaEscursione(3), closeTo(1.12 / 3, 1e-9));
    });

    test('con due voci l\'escursione dà i valori del limiter a due voci', () {
      final quota = BaPresenzaTokens.quotaEscursione(2);
      final scala = BaPresenzaTokens.anelloScalaRiposo +
          (BaPresenzaTokens.anelloScalaPicco - BaPresenzaTokens.anelloScalaRiposo) * quota;
      final opacita = BaPresenzaTokens.anelloOpacitaRiposo +
          (BaPresenzaTokens.anelloOpacitaPicco - BaPresenzaTokens.anelloOpacitaRiposo) * quota;
      expect(scala, closeTo(BaPresenzaTokens.limiterDueScala, 0.001));
      expect(opacita, closeTo(BaPresenzaTokens.limiterDueOpacita, 0.01));
    });
  });

  group('stati della presenza e premuto', () {
    test('premutoScala vale 0,98', () {
      expect(BaControlloTokens.premutoScala, 0.98);
    });

    test('neutroBloccata ha due colori', () {
      expect(BaColorTokens.neutroBloccata, hasLength(2));
      expect(BaColorTokens.neutroBloccata[0], isNot(BaColorTokens.neutroBloccata[1]));
    });

    test('i due veli sulle immagini hanno alfa 0,34 e 0,66', () {
      expect(BaColorTokens.veloImmagine.a, closeTo(0.34, 0.005));
      expect(BaColorTokens.veloMutataImmagine.a, closeTo(0.66, 0.005));
    });

    test('la sagoma vuota dello scheletro respira fra un minimo e un massimo', () {
      expect(BaPresenzaTokens.scheletroOpacitaMin, lessThan(BaPresenzaTokens.scheletroOpacitaMax));
    });
  });

  group('layout per larghezza (D-020, D-027)', () {
    test('il tablet comincia a 600 dp', () {
      expect(BaLayoutTokens.tablet(599), isFalse);
      expect(BaLayoutTokens.tablet(600), isTrue);
      expect(BaLayoutTokens.tablet(744), isTrue);
    });

    test('larghezza del palco e della colonna', () {
      expect(BaLayoutTokens.larghezzaPalco(744), 680);
      expect(BaLayoutTokens.larghezzaColonna(744), 512);
      expect(BaLayoutTokens.larghezzaColonna(360), 320);
    });

    test('perRigaMax: 3 sul telefono, 4 sul tablet', () {
      expect(BaPresenzaTokens.perRigaMax(360), 3);
      expect(BaPresenzaTokens.perRigaMax(599), 3);
      expect(BaPresenzaTokens.perRigaMax(600), 4);
      expect(BaPresenzaTokens.perRigaMax(744), 4);
    });

    test('diametro(n, 744) è diametro(n, 360) × 1,5 per n da 1 a 8', () {
      for (var n = 1; n <= 8; n++) {
        expect(BaPresenzaTokens.diametro(n, 744), BaPresenzaTokens.diametro(n, 360) * 1.5, reason: '$n');
      }
    });
  });

  group('tipografia e raggi (D-026)', () {
    test('testo 16, 14, 12, 12', () {
      expect(BaTestoTokens.corpo.fontSize, 16);
      expect(BaTestoTokens.minore.fontSize, 14);
      expect(BaTestoTokens.marcatore.fontSize, 12);
      expect(BaTestoTokens.nota.fontSize, 12);
    });

    test('raggi: foglio 24, riquadro 16', () {
      expect(BaRaggioTokens.foglio, 24);
      expect(BaRaggioTokens.riquadro, 16);
    });
  });

  group('barra delle azioni (task 002, punto 12)', () {
    test('tre posti: un primario e due secondari', () {
      expect(BaBarraAzioniTokens.posti, 3);
    });

    test('visibili(n): n da 1 a 3, poi sempre 3', () {
      for (var n = 1; n <= 3; n++) {
        expect(BaBarraAzioniTokens.visibili(n), n, reason: '$n azioni');
      }
      for (var n = 4; n <= 8; n++) {
        expect(BaBarraAzioniTokens.visibili(n), 3, reason: '$n azioni');
      }
    });

    test('«Altro» raccoglie le azioni oltre i tre posti', () {
      expect(BaBarraAzioniTokens.inAltro(4), 1);
      expect(BaBarraAzioniTokens.inAltro(5), 2);
      expect(BaBarraAzioniTokens.conAltro(3), isFalse);
      expect(BaBarraAzioniTokens.conAltro(4), isTrue);
    });
  });

  group('suono (task 002)', () {
    test('un suono non è mai consentito a microfono acceso', () {
      expect(BaSuonoTokens.consentito(microfonoAcceso: true), isFalse);
      expect(BaSuonoTokens.consentito(microfonoAcceso: false), isTrue);
    });
  });

  group('vibrazione (task 002)', () {
    final pattern = <BaPatternApticoTokens>[
      BaApticaTokens.microfonoAcceso,
      BaApticaTokens.microfonoSpento,
      BaApticaTokens.salitaSulPalco,
      BaApticaTokens.parolaRicevuta,
      BaApticaTokens.parolaRevocata,
      BaApticaTokens.soloGruppo,
      BaApticaTokens.connessionePersa,
      BaApticaTokens.connessioneRipresa,
    ];

    /// Durate degli impulsi: gli elementi in posizione dispari di `ms`
    /// (la posizione 0 è la pausa iniziale). Niente ampiezza: con il telefono
    /// in tasca la forza non si legge.
    List<int> impulsi(BaPatternApticoTokens p) =>
        [for (var i = 1; i < p.ms.length; i += 2) p.ms[i]];

    test('ms e ampiezza hanno la stessa lunghezza, per ogni pattern', () {
      for (final p in pattern) {
        expect(p.ampiezza.length, p.ms.length, reason: p.nome);
      }
    });

    test('i sette segnali si distinguono per numero e durata degli impulsi', () {
      final segnali = <BaPatternApticoTokens>[
        BaApticaTokens.microfonoAcceso,
        BaApticaTokens.microfonoSpento,
        BaApticaTokens.salitaSulPalco,
        BaApticaTokens.parolaRicevuta,
        BaApticaTokens.parolaRevocata,
        BaApticaTokens.soloGruppo,
        BaApticaTokens.connessionePersa,
      ];
      for (var i = 0; i < segnali.length; i++) {
        for (var j = i + 1; j < segnali.length; j++) {
          expect(impulsi(segnali[i]), isNot(impulsi(segnali[j])),
              reason: '${segnali[i].nome} contro ${segnali[j].nome}');
        }
      }
    });

    test('connessioneRipresa è uguale a microfonoSpento, per progetto', () {
      expect(impulsi(BaApticaTokens.connessioneRipresa), impulsi(BaApticaTokens.microfonoSpento));
      expect(BaApticaTokens.connessioneRipresa.ms, BaApticaTokens.microfonoSpento.ms);
      expect(BaApticaTokens.connessioneRipresa.ampiezza, BaApticaTokens.microfonoSpento.ampiezza);
    });
  });

  group('disco del microfono spento (task 002)', () {
    test('badgeDiametro sta fra glifo e badgeMax per ogni diametro della scala', () {
      for (final d in [88.0, 112.0, 130.0, 156.0, 208.0]) {
        final b = BaPresenzaTokens.badgeDiametro(d);
        expect(b, greaterThanOrEqualTo(BaPresenzaTokens.glifo), reason: '$d');
        expect(b, lessThanOrEqualTo(BaPresenzaTokens.badgeMax), reason: '$d');
      }
    });

    test('a 312 (la presenza sola sul tablet) vale badgeMax', () {
      expect(BaPresenzaTokens.badgeDiametro(312), BaPresenzaTokens.badgeMax);
    });

    test('la cornice sporge di 8 dp dalla scatola del palco', () {
      expect(BaAscoltoTokens.corniceSporge, 8);
    });
  });
}
