import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/tarefas_lista.dart';
import 'package:flutter_application_2/providers/tarefas_provider.dart';
import 'package:flutter_application_2/routes.dart';
import 'package:provider/provider.dart';
import '../models/tarefa.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() {
    return DashboardPageState();
  }
}

class DashboardPageState extends State<DashboardPage> {
  Tarefa? produtoSelecionado;

  @override
  Widget build(BuildContext context) {
    final tarefasProvider = Provider.of<TarefasProvider>(context);
    final listaTarefas = tarefasProvider.listaTarefas;

    final appBar = AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("To Do do Maicon"),
    );

    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final availableHeight =
        mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body:
          isPortrait
              ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Para excluir, deslize para o lado ou mantenha pressionado',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.swipe_left, color: Colors.grey),
                    ],
                  ),
                  Expanded(
                    child: TarefasLista(
                      listaTarefas,
                      () {},
                      availableHeight,
                      isPortrait: true,
                    ),
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: TarefasLista(
                      listaTarefas,
                      () {},
                      availableHeight,
                      isPortrait: false,
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.TAREFA);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
