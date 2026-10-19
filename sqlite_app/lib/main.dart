import 'package:flutter/material.dart';
import 'database/database_helper.dart';

void main() {
  runApp(const SQLiteApp());
}

class SQLiteApp extends StatelessWidget {
  const SQLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarefas SQLite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const TarefasScreen(),
    );
  }
}

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  final TextEditingController tarefaController =
      TextEditingController();

  final TextEditingController buscaController =
      TextEditingController();

  List<Map<String, dynamic>> tarefas = [];

  int quantidadeTarefas = 0;

  bool carregando = true;

  String textoBusca = '';

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  @override
  void dispose() {
    tarefaController.dispose();
    buscaController.dispose();
    super.dispose();
  }

  Future<void> carregarTarefas() async {
    setState(() {
      carregando = true;
    });

    List<Map<String, dynamic>> resultado;

    if (textoBusca.isEmpty) {
      resultado = await databaseHelper.listarTarefas();
    } else {
      resultado = await databaseHelper.buscarTarefas(
        textoBusca,
      );
    }

    final quantidade =
        await databaseHelper.contarTarefas();

    if (!mounted) {
      return;
    }

    setState(() {
      tarefas = resultado;
      quantidadeTarefas = quantidade;
      carregando = false;
    });
  }

  Future<void> adicionarTarefa() async {
    final titulo = tarefaController.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite uma tarefa.'),
        ),
      );

      return;
    }

    await databaseHelper.inserirTarefa(titulo);

    tarefaController.clear();

    await carregarTarefas();
  }

  Future<void> alterarConclusao(
    int id,
    String titulo,
    bool concluida,
  ) async {
    await databaseHelper.atualizarTarefa(
      id,
      titulo,
      !concluida,
    );

    await carregarTarefas();
  }

  Future<void> deletarTarefa(int id) async {
    await databaseHelper.deletarTarefa(id);

    await carregarTarefas();
  }

  // Exercício 02:
  // Apaga todas as tarefas do banco.
  Future<void> limparTodasAsTarefas() async {
    if (quantidadeTarefas == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não há tarefas para apagar.',
          ),
        ),
      );

      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Limpar tarefas',
          ),
          content: const Text(
            'Deseja realmente apagar todas as tarefas?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Apagar tudo'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    await databaseHelper.deleteAll();

    await carregarTarefas();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Todas as tarefas foram apagadas.',
        ),
      ),
    );
  }

  // Exercício 03:
  // Busca tarefas pelo título.
  Future<void> buscarTarefas() async {
    setState(() {
      textoBusca = buscaController.text.trim();
    });

    await carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tarefas SQLite',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Exercício 02:
          // Botão para limpar todas as tarefas.
          IconButton(
            onPressed: limparTodasAsTarefas,
            tooltip: 'Limpar todas as tarefas',
            icon: const Icon(
              Icons.delete_sweep,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: tarefaController,
                  decoration: InputDecoration(
                    labelText: 'Nova tarefa',
                    hintText: 'Digite uma tarefa',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: adicionarTarefa,
                      tooltip: 'Adicionar tarefa',
                      icon: const Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                  onSubmitted: (_) {
                    adicionarTarefa();
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: buscaController,
                  decoration: InputDecoration(
                    labelText: 'Buscar tarefa',
                    hintText: 'Digite parte do título',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: IconButton(
                      onPressed: buscarTarefas,
                      tooltip: 'Buscar',
                      icon: const Icon(
                        Icons.search,
                      ),
                    ),
                  ),
                  onChanged: (_) {
                    buscarTarefas();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: carregando
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : tarefas.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma tarefa encontrada.',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        itemCount: tarefas.length,
                        itemBuilder: (context, index) {
                          final tarefa = tarefas[index];

                          final int id =
                              tarefa['id'] as int;

                          final String titulo =
                              tarefa['titulo'] as String;

                          final bool concluida =
                              tarefa['concluida'] == 1;

                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: concluida,
                                onChanged: (_) {
                                  alterarConclusao(
                                    id,
                                    titulo,
                                    concluida,
                                  );
                                },
                              ),
                              title: Text(
                                titulo,
                                style: TextStyle(
                                  decoration: concluida
                                      ? TextDecoration
                                          .lineThrough
                                      : TextDecoration.none,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                concluida
                                    ? 'Concluída'
                                    : 'Pendente',
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  deletarTarefa(id);
                                },
                                tooltip: 'Excluir',
                                icon: const Icon(
                                  Icons.delete,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // Exercício 01:
          // Contador de tarefas no rodapé.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
            ),
            child: Text(
              'Total de tarefas: $quantidadeTarefas',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}