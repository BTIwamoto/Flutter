import 'package:movie_checker/Domain/Entities/Filme.dart';

class IBaseRepository {
  Future<Filme> insert(Filme filme) async {}

  Future<Filme> getFilme(int id) async {}

  Future<List<Filme>> getAllFilmes(bool filmesAssistidos) async {}

  Future<int> update(Filme filme) async {}

  Future<int> delete(int id) async {}
}
