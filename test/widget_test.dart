import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alcoolgasolina/main.dart';

void main() {
  testWidgets('Teste de validação de campos vazios', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CombustivelApp()));

    // Limpa os valores padrão dos campos de eficiência
    await tester.enterText(find.byType(TextFormField).at(2), '');
    await tester.enterText(find.byType(TextFormField).at(3), '');

    // Toca no botão calcular sem preencher os campos
    await tester.tap(find.text('CALCULAR'));
    await tester.pumpAndSettle();

    // Verifica mensagens de erro (2 campos de preço + 2 campos de eficiência limpos)
    expect(find.text('Valor inválido'), findsNWidgets(4));
  });

  testWidgets('Teste de presença do título do app', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CombustivelApp()));

    expect(find.text('Álcool ou Gasolina?'), findsOneWidget); // AppBar
    expect(find.text('Preços dos Combustíveis'), findsOneWidget); // Card 1
    expect(find.text('Eficiência do Veículo'), findsOneWidget); // Card 2
  });


}