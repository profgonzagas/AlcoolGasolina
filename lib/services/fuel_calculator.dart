class FuelCalculator {
  static String calcularMelhorCombustivel(double alcool, double gasolina) {
    if (gasolina == 0) return 'GASOLINA';
    return (alcool / gasolina) < 0.7 ? 'ÁLCOOL' : 'GASOLINA';
  }

  static double calcularCustoPorKm(double preco, double eficiencia) {
    if (eficiencia <= 0) return 0;
    return preco / eficiencia;
  }

  static double calcularRelacao(double alcool, double gasolina) {
    if (gasolina == 0) return 0;
    return alcool / gasolina;
  }
}
