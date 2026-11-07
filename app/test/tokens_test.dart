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
  });
}
