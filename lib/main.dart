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
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _alcoolController = TextEditingController();
  final TextEditingController _gasolinaController = TextEditingController();
  final TextEditingController _eficienciaAlcoolController = TextEditingController(text: '0.7');
  final TextEditingController _eficienciaGasolinaController = TextEditingController(text: '1.0');

  String _resultado = '';
  Color _resultadoColor = Colors.black;
  bool _showDetails = false;
  double _relacao = 0.0;
  double _custoPorKmAlcool = 0.0;
  double _custoPorKmGasolina = 0.0;

  @override
  void dispose() {
    _alcoolController.dispose();
    _gasolinaController.dispose();
    _eficienciaAlcoolController.dispose();
    _eficienciaGasolinaController.dispose();
    super.dispose();
  }

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      final alcool = double.parse(_alcoolController.text.replaceAll(',', '.'));
      final gasolina = double.parse(_gasolinaController.text.replaceAll(',', '.'));
      final eficienciaAlcool = double.parse(_eficienciaAlcoolController.text.replaceAll(',', '.'));
      final eficienciaGasolina = double.parse(_eficienciaGasolinaController.text.replaceAll(',', '.'));

      setState(() {
        _relacao = alcool / gasolina;
        _custoPorKmAlcool = alcool / eficienciaAlcool;
        _custoPorKmGasolina = gasolina / eficienciaGasolina;

        if (_relacao < 0.7) {
          _resultado = 'É mais vantajoso abastecer com ÁLCOOL';
          _resultadoColor = Colors.green;
        } else {
          _resultado = 'É mais vantajoso abastecer com GASOLINA';
          _resultadoColor = Colors.blue;
        }

        _showDetails = true;
      });
    }
  }

  void _limpar() {
    _formKey.currentState!.reset();
    _alcoolController.clear();
    _gasolinaController.clear();
    _eficienciaAlcoolController.text = '0.7';
    _eficienciaGasolinaController.text = '1.0';
    setState(() {
      _resultado = '';
      _showDetails = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Álcool ou Gasolina?'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sobre o App'),
                  content: const Text(
                    'Este aplicativo calcula se é mais vantajoso abastecer com álcool ou gasolina '
                        'baseado nos preços e na eficiência do seu veículo.\n\n'
                        'Regra geral: Se o preço do álcool for menor que 70% do preço da gasolina, '
                        'vale a pena abastecer com álcool.',
                  ),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Preços dos Combustíveis',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _alcoolController,
                        decoration: const InputDecoration(
                          labelText: 'Preço do Álcool (R\$)',
                          prefixIcon: Icon(Icons.local_gas_station),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o preço do álcool';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _gasolinaController,
                        decoration: const InputDecoration(
                          labelText: 'Preço da Gasolina (R\$)',
                          prefixIcon: Icon(Icons.local_gas_station),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o preço da gasolina';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Eficiência do Veículo',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _eficienciaAlcoolController,
                        decoration: const InputDecoration(
                          labelText: 'Km/L com Álcool',
                          prefixIcon: Icon(Icons.speed),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a eficiência com álcool';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _eficienciaGasolinaController,
                        decoration: const InputDecoration(
                          labelText: 'Km/L com Gasolina',
                          prefixIcon: Icon(Icons.speed),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a eficiência com gasolina';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: _calcular,
                      child: const Text(
                        'CALCULAR',
                        style: TextStyle(color: Colors.white),
                      ),
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
                      child: const Text(
                        'LIMPAR',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_resultado.isNotEmpty)
                Card(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        const SizedBox(height: 10),
                        Text(
                          'Relação Álcool/Gasolina: ${_relacao.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showDetails = !_showDetails;
                            });
                          },
                          child: Text(
                            _showDetails ? 'Ocultar detalhes' : 'Mostrar detalhes',
                          ),
                        ),
                        if (_showDetails)
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Custo por quilômetro:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Álcool: R\$ ${_custoPorKmAlcool.toStringAsFixed(2)}/km',
                              ),
                              Text(
                                'Gasolina: R\$ ${_custoPorKmGasolina.toStringAsFixed(2)}/km',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Diferença: R\$ ${(_custoPorKmGasolina - _custoPorKmAlcool).abs().toStringAsFixed(2)}/km',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                'Dica:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'Se o preço do álcool for inferior a 70% do preço da gasolina, '
                    'vale a pena abastecer com álcool. Caso contrário, a gasolina é mais vantajosa.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}