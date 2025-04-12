import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CombustivelApp());
}

class CombustivelApp extends StatelessWidget {
  const CombustivelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Álcool ou Gasolina?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          errorStyle: const TextStyle(fontSize: 14),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _alcoolController = TextEditingController();
  final _gasolinaController = TextEditingController();
  final _eficienciaAlcoolController = TextEditingController(text: '7.0');
  final _eficienciaGasolinaController = TextEditingController(text: '10.0');

  String _resultado = '';
  Color _resultadoColor = Colors.black;
  bool _showDetails = false;
  double _relacao = 0.0;
  double _custoPorKmAlcool = 0.0;
  double _custoPorKmGasolina = 0.0;

  static String calcularMelhorCombustivel(double alcool, double gasolina) {
    if (gasolina <= 0) return 'GASOLINA';
    return (alcool / gasolina) < 0.7 ? 'ÁLCOOL' : 'GASOLINA';
  }

  static double calcularCustoPorKm(double preco, double eficiencia) {
    return eficiencia > 0 ? preco / eficiencia : 0;
  }

  static double calcularRelacao(double alcool, double gasolina) {
    return gasolina > 0 ? alcool / gasolina : 0;
  }

  bool _validarCampo(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final valor = double.tryParse(value.replaceAll(',', '.'));
    return valor != null && valor > 0;
  }

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      final alcool = double.parse(_alcoolController.text.replaceAll(',', '.'));
      final gasolina =
          double.parse(_gasolinaController.text.replaceAll(',', '.'));
      final eficienciaAlcool =
          double.parse(_eficienciaAlcoolController.text.replaceAll(',', '.'));
      final eficienciaGasolina =
          double.parse(_eficienciaGasolinaController.text.replaceAll(',', '.'));

      setState(() {
        _relacao = calcularRelacao(alcool, gasolina);
        _custoPorKmAlcool = calcularCustoPorKm(alcool, eficienciaAlcool);
        _custoPorKmGasolina = calcularCustoPorKm(gasolina, eficienciaGasolina);

        _resultado =
            'É mais vantajoso abastecer com ${calcularMelhorCombustivel(alcool, gasolina)}';
        _resultadoColor = _relacao < 0.7 ? Colors.green : Colors.blue;
        _showDetails = true;
      });
    }
  }

  void _limpar() {
    _formKey.currentState?.reset();
    _alcoolController.clear();
    _gasolinaController.clear();
    _eficienciaAlcoolController.text = '11.0';
    _eficienciaGasolinaController.text = '13.0';
    setState(() {
      _resultado = '';
      _showDetails = false;
    });
  }

  @override
  void dispose() {
    _alcoolController.dispose();
    _gasolinaController.dispose();
    _eficienciaAlcoolController.dispose();
    _eficienciaGasolinaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Álcool ou Gasolina?'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              _buildCombustivelCard(),
              const SizedBox(height: 20),
              _buildEficienciaCard(),
              const SizedBox(height: 20),
              _buildBotoes(),
              if (_resultado.isNotEmpty) _buildResultado(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCombustivelCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Preços dos Combustíveis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildCampoTexto(_alcoolController, 'Preço do Álcool (R\$)',
                Icons.local_gas_station),
            const SizedBox(height: 16),
            _buildCampoTexto(_gasolinaController, 'Preço da Gasolina (R\$)',
                Icons.local_gas_station),
          ],
        ),
      ),
    );
  }

  Widget _buildEficienciaCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Eficiência do Veículo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildCampoTexto(
                _eficienciaAlcoolController, 'Km/L com Álcool', Icons.speed),
            const SizedBox(height: 16),
            _buildCampoTexto(_eficienciaGasolinaController, 'Km/L com Gasolina',
                Icons.speed),
          ],
        ),
      ),
    );
  }

  Widget _buildCampoTexto(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d,\.]')),
      ],
      validator: (value) => _validarCampo(value) ? null : 'Valor inválido',
    );
  }

  Widget _buildBotoes() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
            ),
            onPressed: _calcular,
            child:
                const Text('CALCULAR', style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.grey,
            ),
            onPressed: _limpar,
            child: const Text('LIMPAR', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildResultado() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Card(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _resultado,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _resultadoColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () => setState(() => _showDetails = !_showDetails),
                  child: Text(
                      _showDetails ? 'Ocultar detalhes' : 'Mostrar detalhes'),
                ),
                if (_showDetails) ...[
                  const SizedBox(height: 10),
                  Text(
                      'Relação Álcool/Gasolina: ${_relacao.toStringAsFixed(3)}'),
                  Text(
                      'Custo por km com Álcool: R\$ ${_custoPorKmAlcool.toStringAsFixed(3)}'),
                  Text(
                      'Custo por km com Gasolina: R\$ ${_custoPorKmGasolina.toStringAsFixed(3)}'),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
