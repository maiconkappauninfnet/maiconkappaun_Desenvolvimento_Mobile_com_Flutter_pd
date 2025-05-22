import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/tarefa.dart';

import '../models/mock_data.dart';

class TarefasProvider with ChangeNotifier {
  final listaTarefas = TAREFAS_MOCK;

  List<Tarefa> getTarefas() {
    return listaTarefas;
  }

  void addNovaTarefa(Tarefa tarefa) {
    listaTarefas.add(tarefa);
    notifyListeners();
  }

  void atualizarTarefa(Tarefa tarefaAtualizada) {
    // Procurar a tarefa pelo id
    final index = listaTarefas.indexWhere((t) => t.id == tarefaAtualizada.id);
    if (index != -1) {
      listaTarefas[index] = tarefaAtualizada;
      notifyListeners();
    }
  }

  void removerTarefa(String id) {
    listaTarefas.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
