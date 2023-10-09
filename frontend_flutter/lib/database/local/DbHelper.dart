import 'package:frontend_flutter/models/User.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DbHelper {
  static Database? _db;

  final String _dbName = 'test.db';
  final String _tableUser = 'user';
  final int version = 1;

  final String _userId = 'id';
  final String _userCorreo = 'correo';
  final String _userPassword = 'password';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    var db = await openDatabase(path, version: version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $_tableUser ("
        " $_userId TEXT, "
        " $_userCorreo TEXT, "
        " $_userPassword TEXT, "
        " PRIMARY KEY ($_userId)"
        ")");
  }

  Future<int?> saveData(User user) async {
    var dbClient = await db;
    var res = await dbClient?.insert(_tableUser, user.toMap());
    return res;
  }

  Future<User?> getLoginUser(String userId, String password) async {
    var dbClient = await db;
    var res = await dbClient?.rawQuery("SELECT * FROM $_tableUser WHERE "
        "$_userId = '$userId' AND "
        "$_userPassword = '$password'");

    if (res != null && res.isNotEmpty) {
      return User.fromMap(res.first);
    }

    return null;
  }

  Future<int?> updateUser(User user) async {
    var dbClient = await db;
    var res = await dbClient?.update(_tableUser, user.toMap(),
        where: '$_userId = ?', whereArgs: [user.dni]);
    return res;
  }

  Future<int?> deleteUser(String id) async {
    var dbClient = await db;
    var res = await dbClient
        ?.delete(_tableUser, where: '$_userId = ?', whereArgs: [id]);
    return res;
  }
}
