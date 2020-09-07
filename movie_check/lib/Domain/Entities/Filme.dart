import 'package:scidart/numdart.dart';

class Filme {
  int id;
  String nome;
  String imagem;
  String autor;
  String ano;
  bool status;

  Filme({this.id, this.nome, this.imagem, this.autor, this.ano, this.status});

  Map toMap() {
    Map<String, dynamic> map = {
      'id': null,
      'nome': nome,
      'imagem': imagem,
      'autor': autor,
      'ano': ano,
      'status': status != null && status ? 1 : 0
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  Filme.fromMap(Map map) {
    id = map["id"];
    nome = map["nome"];
    imagem = map["imagem"];
    autor = map["autor"];
    ano = map["ano"].toString();
    status = map["status"] > 0;
  }
}
