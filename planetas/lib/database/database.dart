import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BaseDatos {
  static final BaseDatos instance = BaseDatos._privateConstructor();
  static Database? _database;

  BaseDatos._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY,
        nombre TEXT,
        color TEXT
      )
    ''');
  }

  Future<int> create(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('items', row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query('items');
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('items', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
