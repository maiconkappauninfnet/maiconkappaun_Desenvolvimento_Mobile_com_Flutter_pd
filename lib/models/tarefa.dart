
class Tarefa {
  final String id;
  final String nome;
  final String data;
  final String hora;
  final String endereco_formatado;

  Tarefa({
    required this.id,
    required this.nome,
    required this.data,
    required this.hora,
    required this.endereco_formatado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'data': data,
      'hora': hora,
      'endereco_formatado': endereco_formatado,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      nome: map['nome'],
      data: map['data'],
      hora: map['hora'],
      endereco_formatado: map['endereco_formatado'],
    );
  }
}
