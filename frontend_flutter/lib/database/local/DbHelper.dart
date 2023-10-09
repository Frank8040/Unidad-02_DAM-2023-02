import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/Users.dart';

class DbHelper {
  final String _tableName = "user";

  final String _userCorreo = 'correo';
  final String _userPassword = 'password';

  Future<Database> getDataBase() async {
    return openDatabase(
      join(await getDatabasesPath(), "usersDatabase.db"),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $_tableName (id TEXT PRIMARY KEY, nombres TEXT, apellidos TEXT, dni TEXT, correo TEXT, password TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<User?> getLoginUser(String correo, String password) async {
    var dbClient = await getDataBase();
    var res = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE "
        "$_userCorreo = '$correo' AND "
        "$_userPassword = '$password'");

    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }

    return null;
  }

  Future<User> getUser(String userId) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> user =
        await db.rawQuery("SELECT * FROM $_tableName WHERE id = $userId");
    if (user.length == 1) {
      return User(
          id: user[0]["id"],
          nombres: user[0]["nombres"],
          apellidos: user[0]["apellidos"],
          dni: user[0]["dni"],
          correo: user[0]["correo"],
          password: user[0]["password"]);
    } else {
      return const User();
    }
  }

  Future<List<User>> getAllUsers() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> usersMap = await db.query(_tableName);
    return List.generate(usersMap.length, (index) {
      return User(
          id: usersMap[index]["id"],
          nombres: usersMap[index]["nombres"],
          apellidos: usersMap[index]["apellidos"],
          dni: usersMap[index]["dni"],
          correo: usersMap[index]["correo"],
          password: usersMap[index]["password"]);
    });
  }

  Future<int> insertUser(User user) async {
    int userId = 0;
    Database db = await getDataBase();
    await db.insert(_tableName, user.toMap()).then((value) {
      userId = value;
    });
    return userId;
  }

  Future<void> updateUser(String userId, String name, String imageUrl) async {
    Database db = await getDataBase();
    db.rawUpdate(
        "UPDATE $_tableName SET name = '$name', imageUrl = '$imageUrl' WHERE id = '$userId'");
  }

  Future<void> deleteUser(String userId) async {
    Database db = await getDataBase();
    await db.rawDelete("DELETE FROM $_tableName WHERE id = '$userId'");
  }
}
