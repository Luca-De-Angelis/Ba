import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/l10n/app_localizations.dart';

const _lingue = ['it', 'en', 'fr', 'es', 'de'];

Future<AppLocalizations> _carica(String lingua) => AppLocalizations.delegate.load(Locale(lingua));

void main() {
  test('i testi del palco esistono nelle cinque lingue', () async {
    for (final lingua in _lingue) {
      final l = await _carica(lingua);
      expect(l.palcoLibero, isNotEmpty, reason: lingua);
      expect(l.palcoInvito, isNotEmpty, reason: lingua);
      expect(l.palcoEtichetta(3), isNotEmpty, reason: lingua);
      expect(l.presenzaParla('Marta B.'), contains('Marta B.'), reason: lingua);
    }
  });

  test('l\'etichetta del palco ha i casi 0, 1 e più persone in ogni lingua', () async {
    for (final lingua in _lingue) {
      final l = await _carica(lingua);
      final testi = {l.palcoEtichetta(0), l.palcoEtichetta(1), l.palcoEtichetta(2)};
      expect(testi, hasLength(3), reason: '$lingua: 0, 1 e 2 sono tre frasi diverse');
      expect(l.palcoEtichetta(5), contains('5'), reason: lingua);
      expect(l.palcoEtichetta(1), contains('1'), reason: lingua);
    }
  });

  test('italiano e tedesco: i testi del task 002', () async {
    final it = await _carica('it');
    expect(it.palcoLibero, 'Il palco è libero.');
    expect(it.palcoInvito, 'Puoi salire quando vuoi.');
    expect(it.palcoEtichetta(1), 'Palco, 1 persona');
    expect(it.palcoEtichetta(3), 'Palco, 3 persone');
    expect(it.presenzaParla('Marta B.'), 'Marta B., sta parlando');

    // Dal handoff 002 (Stati critici 002.dc.html).
    final de = await _carica('de');
    expect(de.palcoLibero, 'Die Bühne ist frei.');
    expect(de.palcoInvito, 'Du kannst jederzeit aufsteigen.');
    expect(de.palcoEtichetta(8), 'Bühne, 8 Personen');
  });

  test('in francese 0 e 1 non si confondono con il plurale', () async {
    final fr = await _carica('fr');
    expect(fr.palcoEtichetta(0), 'Scène, personne');
    expect(fr.palcoEtichetta(1), 'Scène, 1 personne');
    expect(fr.palcoEtichetta(4), 'Scène, 4 personnes');
  });

  test('le etichette degli stati con glifo esistono nelle cinque lingue (task 012)', () async {
    for (final lingua in _lingue) {
      final l = await _carica(lingua);
      final testi = [
        l.presenzaMutata('Marta B.'),
        l.presenzaBloccata('Marta B.'),
        l.presenzaMicSpento('Marta B.'),
        l.presenzaHaLaParola('Marta B.'),
      ];
      for (final t in testi) {
        expect(t, startsWith('Marta B.'), reason: '$lingua: $t');
      }
      expect(testi.toSet(), hasLength(4), reason: '$lingua: quattro frasi diverse');
    }
  });

  test('italiano e tedesco: i testi dei quattro stati', () async {
    final it = await _carica('it');
    expect(it.presenzaMutata('Marta B.'), 'Marta B., voce mutata da te');
    expect(it.presenzaBloccata('Marta B.'), 'Marta B., bloccata');
    expect(it.presenzaMicSpento('Marta B.'), 'Marta B., microfono spento');
    expect(it.presenzaHaLaParola('Marta B.'), 'Marta B., ha la parola');

    // Dal handoff 002 (Stati critici 002.dc.html): «Mikrofon aus», «hat das Wort».
    final de = await _carica('de');
    expect(de.presenzaMicSpento('Marta B.'), 'Marta B., Mikrofon aus');
    expect(de.presenzaHaLaParola('Marta B.'), 'Marta B., hat das Wort');
  });
}
