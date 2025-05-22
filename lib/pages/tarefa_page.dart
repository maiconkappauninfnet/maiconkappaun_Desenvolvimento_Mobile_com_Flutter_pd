import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/tarefa.dart';
import 'package:flutter_application_2/components/tarefa_form.dart';

class TarefaPage extends StatelessWidget {
  const TarefaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tarefa = ModalRoute.of(context)!.settings.arguments as Tarefa?;
    return Scaffold(
      appBar: AppBar(
        title: Text(tarefa == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      ),
      body: TarefaForm(tarefa: tarefa),
    );
  }
}
