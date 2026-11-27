import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'prototipo_aiuti.dart';

// Il pannello dello strumento del prototipo (task 036): il testo ha un terzo valore, 1,4, per
// provare la barra (in italiano ancora in riga; si ripiega da circa 1,55, vedi misure_font_vero_test).

void main() {
  testWidgets('il testo gira 1,0 → 2,0 → 1,4 → 1,0, e il tasto dice il valore; da 1,0 un tocco dà 2,0 come prima', (tester) async {
    await avvia(tester, altezza: 1300);
    final scala = <String, double>{};
    for (final (etichetta, atteso) in [('Testo 1,0', 2.0), ('Testo 2,0', 1.4), ('Testo 1,4', 1.0)]) {
      expect(find.text(etichetta), findsOneWidget, reason: 'il tasto dice il valore di adesso: $etichetta');
      await tocca(tester, etichetta);
      final testo = tester.renderObject<RenderParagraph>(find.text('La tua email').first);
      scala[etichetta] = testo.textScaler.scale(1);
      expect(scala[etichetta], atteso, reason: 'dopo «$etichetta» il testo dell\'app è a $atteso');
    }
    expect(find.text('Testo 1,0'), findsOneWidget, reason: 'tornato a 1,0');
    expect(tester.takeException(), isNull);
  });
}
