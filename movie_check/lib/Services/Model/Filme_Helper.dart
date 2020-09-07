import 'package:movie_checker/Domain/Entities/Filme.dart';
import "package:movie_checker/Interfaces/Model/IBaseRepository.dart";
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FilmeHelper implements IBaseRepository {
  static final _dataBaseName = "MovieChecker.db";
  static final _dataBaseVersion = 1;

  static final table = "Filme";
  static final columnId = "id";
  static final columnNome = "nome";
  static final columnImagem = "imagem";
  static final columnAutor = "autor";
  static final columnAno = "ano";
  static final columnStatus = "status";

  static final FilmeHelper _instance = FilmeHelper.internal();
  factory FilmeHelper() => _instance;
  FilmeHelper.internal();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();

    return _database;
  }

  Future<Database> _initDatabase() async {
    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, _dataBaseName);

    return await openDatabase(path,
        version: _dataBaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnNome TEXT NOT NULL,
            $columnImagem TEXT NOT NULL,
            $columnAutor TEXT NOT NULL,
            $columnAno INTEGER NOT NULL,
            $columnStatus INTEGER NOT NULL
          )
          ''');
  }

  @override
  Future<Filme> insert(Filme filme) async {
    try {
      Database db = await _instance.database;
      filme.id = await db.insert(table, filme.toMap());
      return filme;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future<int> update(Filme filme) async {
    try {
      Database db = await _instance.database;
      return await db.update(table, filme.toMap(),
          where: '$columnId = ?', whereArgs: [filme.id]);
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      Database db = await _instance.database;
      return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future<Filme> getFilme(int id) async {
    try {
      Database db = await _instance.database;

      List<Map> maps = await db.query(table,
          columns: [
            columnId,
            columnNome,
            columnImagem,
            columnAutor,
            columnAno,
            columnStatus
          ],
          where: "$columnId = ?",
          whereArgs: [id]);

      if (maps.length > 0)
        return Filme.fromMap(maps.first);
      else
        return null;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future<List<Filme>> getAllFilmes(bool filmesAssistidos) async {
    try {
      Database db = await _instance.database;
      int status = filmesAssistidos ? 1 : 0;
      List listMap =
          await db.rawQuery("SELECT * FROM $table WHERE STATUS = $status");
      List<Filme> filmes = List();

      for (Map map in listMap) {
        filmes.add(Filme.fromMap(map));
      }

      return filmes;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future close() async {
    Database db = await _instance.database;
    db.close();
  }
}
