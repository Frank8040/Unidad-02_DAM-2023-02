import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../modals/Users.dart';

class SqliteDatabaseHelper {
  final String _tableName = "users";

  Future<Database> getDataBase() async {
    return openDatabase(
      join(await getDatabasesPath(), "usersDatabase.db"),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $_tableName (id TEXT PRIMARY KEY, name TEXT, imageUrl TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<User> getUser(String userId) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> user =
        await db.rawQuery("SELECT * FROM $_tableName WHERE id = $userId");
    if (user.length == 1) {
      return User(
          id: user[0]["id"],
          name: user[0]["name"],
          imageUrl: user[0]["imageUrl"]);
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
          name: usersMap[index]["name"],
          imageUrl: usersMap[index]["imageUrl"]);
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
