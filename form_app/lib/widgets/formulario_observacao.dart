import 'package:flutter/material.dart';
import '../models/observacao.dart';

class FormularioObservacao extends StatefulWidget {
  final Function(Observacao) onAdicionar;

  const FormularioObservacao({super.key, required this.onAdicionar});

  @override
  State<FormularioObservacao> createState() => _FormularioObservacaoState();
}

class _FormularioObservacaoState extends State<FormularioObservacao> {
  final _tituloController = TextEditingController();
  final _especieController = TextEditingController();
  final _localController = TextEditingController();

  void _submeterFormulario() {
    final titulo = _tituloController.text.trim();
    final especie = _especieController.text.trim();
    final local = _localController.text.trim();

    if (titulo.isEmpty || especie.isEmpty || local.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final novaObservacao = Observacao(
      titulo: titulo,
      especie: especie,
      local: local,
      data: DateTime.now(),
    );

    widget.onAdicionar(novaObservacao);

    // Limpa os campos após enviar
    _tituloController.clear();
    _especieController.clear();
    _localController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Observação cadastrada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _especieController.dispose();
    _localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Nova Observação de Campo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título da Observação',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _especieController,
              decoration: const InputDecoration(
                labelText: 'Espécie/Ave',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.pets),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _localController,
              decoration: const InputDecoration(
                labelText: 'Local do Avistamento',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submeterFormulario,
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar Observação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
