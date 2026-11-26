import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ba/design_system/fascia_attesa.dart';
import 'package:ba/design_system/pubblico.dart';
import 'package:ba/design_system/riga_den.dart';
import 'package:ba/design_system/riga_persona.dart';
import 'package:ba/design_system/sagoma.dart';
import 'package:ba/design_system/tokens.dart';

// La sagoma è disegnata in un solo punto (task 035): il gruppo d'attesa, il pubblico, la fila di
// sagome di una riga del DEN e la riga di una persona usano lo stesso BaSagoma.

Widget _app(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(360, 800)),
        child: Align(alignment: Alignment.topLeft, child: SizedBox(width: 320, child: SingleChildScrollView(child: child))),
      ),
    );

/// La decorazione del quadrato di una sagoma.
BoxDecoration _decorazione(WidgetTester tester, Finder sagoma) =>
    tester.widget<DecoratedBox>(find.descendant(of: sagoma, matching: find.byType(DecoratedBox)).first).decoration as BoxDecoration;

void main() {
  testWidgets('BaFasciaAttesa e BaPubblico usano lo stesso BaSagoma: a pari tinta e sagoma, lo stesso disegno', (tester) async {
    await tester.pumpWidget(_app(const Column(children: [
      BaFasciaAttesa(conteggio: 1, tinte: [2], sagome: [1], frase: 'Aspetti con altri.'),
      BaPubblico(conteggio: 1, testo: '1 in ascolto', tinte: [2], sagome: [1]),
    ])));
    final fascia = find.descendant(of: find.byType(BaFasciaAttesa), matching: find.byType(BaSagoma));
    final pubblico = find.descendant(of: find.byType(BaPubblico), matching: find.byType(BaSagoma));
    expect(fascia, findsOneWidget);
    expect(pubblico, findsOneWidget);
    final a = tester.widget<BaSagoma>(fascia);
    final b = tester.widget<BaSagoma>(pubblico);
    expect((a.tinta, a.sagoma), (b.tinta, b.sagoma));
    // Il gradiente è lo stesso; gli angoli sono quelli della stessa sagoma, in proporzione al lato.
    expect(_decorazione(tester, fascia).gradient, _decorazione(tester, pubblico).gradient);
    expect(_decorazione(tester, fascia).borderRadius, BaSagomaTokens.bordo(1, BaCodaTokens.gruppoPresenzaLato));
    expect(_decorazione(tester, pubblico).borderRadius, BaSagomaTokens.bordo(1, BaPresenzaTokens.pubblico));
  });

  testWidgets('il lato è quello del chiamante, dai suoi token', (tester) async {
    await tester.pumpWidget(_app(const Column(children: [
      BaFasciaAttesa(conteggio: 1, tinte: [0], sagome: [0], frase: 'x'),
      BaPubblico(conteggio: 1, testo: 'x', tinte: [0], sagome: [0]),
    ])));
    expect(tester.getSize(find.descendant(of: find.byType(BaFasciaAttesa), matching: find.byType(BaSagoma))), const Size.square(BaCodaTokens.gruppoPresenzaLato));
    expect(tester.getSize(find.descendant(of: find.byType(BaPubblico), matching: find.byType(BaSagoma))), const Size.square(BaPresenzaTokens.pubblico));
  });

  testWidgets('anche la fila di BaRigaDen e la riga di una persona usano BaSagoma', (tester) async {
    await tester.pumpWidget(_app(const Column(children: [
      BaRigaDen(nome: 'Cucina di notte', marcatore: 'Entra chiunque · 3 sul palco', presenze: 3, tinte: [0, 1, 2], sagome: [0, 1, 2]),
      BaRigaPersona(nome: 'Marta', tinta: 3, sagoma: 2),
    ])));
    expect(find.descendant(of: find.byType(BaRigaDen), matching: find.byType(BaSagoma)), findsNWidgets(3));
    final persona = find.descendant(of: find.byType(BaRigaPersona), matching: find.byType(BaSagoma));
    expect(persona, findsOneWidget);
    expect(tester.getSize(persona), const Size.square(BaPersoneTokens.sagomaLato));
    expect(_decorazione(tester, persona).gradient, BaTintaTokens.mazzo[3 % BaTintaTokens.mazzo.length].gradiente);
  });

  testWidgets('tinta e sagoma vanno a modulo: oltre il mazzo si ricomincia da capo', (tester) async {
    final n = BaTintaTokens.mazzo.length;
    await tester.pumpWidget(_app(Column(children: [
      BaSagoma(tinta: 1, sagoma: 0, lato: 20),
      BaSagoma(tinta: 1 + n, sagoma: 0, lato: 20),
    ])));
    final sagome = find.byType(BaSagoma);
    expect(_decorazione(tester, sagome.at(0)).gradient, _decorazione(tester, sagome.at(1)).gradient);
  });
}
