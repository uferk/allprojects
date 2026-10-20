import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tarefas_provider_app/main.dart';
import 'package:tarefas_provider_app/providers/tarefa_provider.dart';

void main() {
  testWidgets('Aplicativo de tarefas inicia', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TarefaProvider(),
        child: const TarefasApp(),
      ),
    );

    await tester.pump();

    expect(find.text('Minhas Tarefas'), findsOneWidget);
  });
}
