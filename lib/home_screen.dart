import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _alcoolController = TextEditingController();
  final TextEditingController _gasolinaController = TextEditingController();
  String _mensagemResultado = '';

  bool _validarCampo(String? value) {
    if (value == null || value.isEmpty) return false;
    final valor = double.tryParse(value.replaceAll(',', '.'));
    return valor != null && valor > 0;
  }

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      final double alcool =
          double.parse(_alcoolController.text.replaceAll(',', '.'));
      final double gasolina =
          double.parse(_gasolinaController.text.replaceAll(',', '.'));

      final resultado = alcool / gasolina;
      setState(() {
        _mensagemResultado =
            resultado < 0.7 ? 'Abasteça com Álcool' : 'Abasteça com Gasolina';
      });
    } else {
      setState(() {
        _mensagemResultado = '';
      });
    }
  }

  @override
  void dispose() {
    _alcoolController.dispose();
    _gasolinaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Álcool ou Gasolina')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('alcoolField'),
                controller: _alcoolController,
                decoration: const InputDecoration(labelText: 'Preço do Álcool'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) =>
                    _validarCampo(value) ? null : 'Preço inválido',
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('gasolinaField'),
                controller: _gasolinaController,
                decoration:
                    const InputDecoration(labelText: 'Preço da Gasolina'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) =>
                    _validarCampo(value) ? null : 'Preço inválido',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('calcularButton'),
                onPressed: _calcular,
                child: const Text('CALCULAR'),
              ),
              const SizedBox(height: 24),
              Text(
                _mensagemResultado,
                key: const Key('resultadoTexto'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
