import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/tarefas_item.dart';
import 'package:flutter_application_2/models/tarefa.dart';

class TarefasLista extends StatelessWidget {
  final double height;
  final bool isPortrait;
  final List<Tarefa> listaTarefas;
  final Function editarProduto;

  const TarefasLista(
      this.listaTarefas,
      this.editarProduto,
      this.height,
      {super.key, this.isPortrait = true});

  Widget gerarItemLista(int index, bool isPortrait) {
    Tarefa tarefa = listaTarefas[index];
    return TarefasItem(tarefa, editarProduto, isPortrait: isPortrait);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.6,
      child: ListView.builder(
          itemCount: listaTarefas.length,
          itemBuilder: (context, index) {
            return gerarItemLista(index, isPortrait);
          }
      ),
    );
  }

}