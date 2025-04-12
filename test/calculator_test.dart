import 'package:flutter_test/flutter_test.dart';
import 'package:alcoolgasolina/services/fuel_calculator.dart';

void main() {
  group('Testes da Lógica de Cálculo', () {
    test('Deve retornar ÁLCOOL quando relação < 0.7', () {
      expect(FuelCalculator.calcularMelhorCombustivel(3.0, 5.0), 'ÁLCOOL');
    });

    test('Deve retornar GASOLINA quando relação >= 0.7', () {
      expect(FuelCalculator.calcularMelhorCombustivel(3.5, 5.0), 'GASOLINA');
    });

    test('Deve calcular custo por km corretamente', () {
      expect(FuelCalculator.calcularCustoPorKm(3.0, 10.0), 0.3);
      expect(FuelCalculator.calcularCustoPorKm(5.0, 12.5), 0.4);
    });
  });
}