import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/tarefa.dart';
import 'package:flutter_application_2/providers/tarefas_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class TarefaForm extends StatefulWidget {
  final Tarefa? tarefa;

  const TarefaForm({Key? key, this.tarefa}) : super(key: key);

  @override
  State<TarefaForm> createState() => _TarefaFormState();
}

class _TarefaFormState extends State<TarefaForm> {
  final nomeTarefaController = TextEditingController();
  final dataTarefaController = TextEditingController();
  final horaTarefaController = TextEditingController();
  final enderecoFormatadoTarefaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.tarefa != null) {
      nomeTarefaController.text = widget.tarefa!.nome;
      dataTarefaController.text = widget.tarefa!.data;
      horaTarefaController.text = widget.tarefa!.hora;
      enderecoFormatadoTarefaController.text =
          widget.tarefa!.endereco_formatado;
    } else {
      _getLocation()
          .then((placemark) {
            enderecoFormatadoTarefaController.text =
                '${placemark.street}, ${placemark.subLocality}, ${placemark.administrativeArea}';
          })
          .catchError((_) {
            enderecoFormatadoTarefaController.text = 'Sem acesso à localização';
          });
    }
  }

  Future<Placemark> _getLocation() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) return Future.error("Serviço desabilitado.");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return Future.error("Permissão Negada.");
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    return placemarks.first;
  }

  @override
  Widget build(BuildContext context) {
    final tarefasProvider = Provider.of<TarefasProvider>(
      context,
      listen: false,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          TextField(
            controller: nomeTarefaController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              hintText: 'Nome da tarefa',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: dataTarefaController,
            decoration: const InputDecoration(
              labelText: 'Data',
              hintText: 'Data',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _parseDataTarefa(widget.tarefa?.data ?? ''),

                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                String formattedDate =
                    '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
                dataTarefaController.text = formattedDate;
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: horaTarefaController,
            decoration: const InputDecoration(
              labelText: 'Hora',
              hintText: 'Hora',
              suffixIcon: Icon(Icons.access_time),
            ),
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                String hora = pickedTime.hour.toString().padLeft(2, '0');
                String minuto = pickedTime.minute.toString().padLeft(2, '0');
                horaTarefaController.text = '$hora:$minuto';
              }
            },
          ),
          const SizedBox(height: 10),
          widget.tarefa != null
              ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: enderecoFormatadoTarefaController,
                      decoration: const InputDecoration(
                        labelText: 'Endereço',
                        hintText: 'Endereço formatado',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.my_location),
                    tooltip: 'Atualizar com localização atual',
                    onPressed: () async {
                      try {
                        final placemark = await _getLocation();
                        setState(() {
                          enderecoFormatadoTarefaController.text =
                              '${placemark.street}, ${placemark.subLocality}, ${placemark.administrativeArea}';
                        });
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Não foi possível obter a localização.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              )
              : TextField(
                controller: enderecoFormatadoTarefaController,
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                  hintText: 'Endereço formatado',
                ),
              ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final nome = nomeTarefaController.text;
              final data = dataTarefaController.text;
              final hora = horaTarefaController.text;
              final endereco = enderecoFormatadoTarefaController.text;

              if (nome.isEmpty ||
                  data.isEmpty ||
                  hora.isEmpty ||
                  endereco.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, preencha todos os campos'),
                  ),
                );
                return;
              }

              final tarefa = Tarefa(
                id: widget.tarefa?.id ?? nome,
                nome: nome,
                data: data,
                hora: hora,
                endereco_formatado: endereco,
              );

              if (widget.tarefa == null) {
                tarefasProvider.addNovaTarefa(tarefa);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tarefa "${tarefa.nome}" adicionada!'),
                  ),
                );
              } else {
                tarefasProvider.atualizarTarefa(tarefa);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tarefa "${tarefa.nome}" editada!')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  /// Converte data no formato dd/MM/yyyy para yyyy-MM-dd (ISO) para DateTime.parse
  String _formatDataToIso(String data) {
    try {
      final parts = data.split('/');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
      }
    } catch (_) {}
    return data; // fallback
  }

  DateTime _parseDataTarefa(String data) {
    try {
      return DateTime.parse(_formatDataToIso(data));
    } catch (_) {
      return DateTime.now();
    }
  }

  @override
  void dispose() {
    nomeTarefaController.dispose();
    dataTarefaController.dispose();
    horaTarefaController.dispose();
    enderecoFormatadoTarefaController.dispose();
    super.dispose();
  }
}
