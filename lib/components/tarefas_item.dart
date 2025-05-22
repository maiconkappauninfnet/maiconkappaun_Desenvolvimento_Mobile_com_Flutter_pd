import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/tarefa.dart';
import 'package:flutter_application_2/routes.dart';
import 'package:flutter_application_2/providers/tarefas_provider.dart';
import 'package:provider/provider.dart';

class TarefasItem extends StatelessWidget {
  final Tarefa tarefa;
  final bool isPortrait;
  final Function editarTarefa;

  const TarefasItem(
    this.tarefa,
    this.editarTarefa, {
    super.key,
    this.isPortrait = true,
  });

  @override
  Widget build(BuildContext context) {
    final tarefasProvider = Provider.of<TarefasProvider>(
      context,
      listen: false,
    );

    return Dismissible(
      key: ValueKey(tarefa.id),
      direction:
          DismissDirection.endToStart, // Desliza da direita para esquerda
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        // Confirmação opcional
        return await showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Confirmar exclusão'),
                content: const Text(
                  'Tem certeza que deseja excluir esta tarefa?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text(
                      'Excluir',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        );
      },
      onDismissed: (direction) {
        tarefasProvider.removerTarefa(tarefa.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tarefa "${tarefa.nome}" excluída')),
        );
      },
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Detalhes da Tarefa'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nome: ${tarefa.nome}'),
                      Text('Data: ${tarefa.data}'),
                      Text('Hora: ${tarefa.hora}'),
                      Text('Endereço: ${tarefa.endereco_formatado}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar'),
                    ),
                  ],
                ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Excluir Tarefa'),
                  content: const Text(
                    'Tem certeza que deseja excluir esta tarefa?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        tarefasProvider.removerTarefa(tarefa.id);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Excluir',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
          );
        },
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.check_box_outline_blank),
        ),
        title: Text(tarefa.nome),
        subtitle: Text(tarefa.data),
        trailing: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.TAREFA, arguments: tarefa);
          },
          icon: const Icon(Icons.edit),
        ),
        isThreeLine: !isPortrait,
      ),
    );
  }
}
