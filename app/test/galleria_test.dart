import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/galleria/main_galleria.dart';

void main() {
  testWidgets('la galleria si costruisce a 360 e a 744, con le aree e senza movimento', (tester) async {
    await tester.pumpWidget(const GalleriaApp());
    await tester.pump();
    expect(find.text('BaTouchable'), findsOneWidget);

    // I tre controlli di sviluppo: nessuna eccezione di layout.
    await tester.tap(find.text('Mostra le aree toccabili'));
    await tester.pump();
    await tester.tap(find.text('Riduci movimento'));
    await tester.pump();
    await tester.tap(find.text('Larghezza 360'));
    await tester.pump();
    expect(find.text('Larghezza 744'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
