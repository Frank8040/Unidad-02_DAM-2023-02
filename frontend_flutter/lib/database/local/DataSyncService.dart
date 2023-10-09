import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class DataSyncService {
  static Future<void> markDataAsSynchronized(
      Database db, String tableName, int recordId) async {
    try {
      final updatedRows = await db.update(
        tableName,
        {'synced': 1}, // Marcar como sincronizado (1) o no sincronizado (0)
        where: 'id = ?',
        whereArgs: [recordId],
      );

      if (updatedRows != 1) {
        throw Exception(
            'Error al marcar como sincronizado el registro con ID $recordId');
      }
    } catch (e) {
      print('Error al marcar como sincronizado: $e');
    }
  }

  // Define las URL de tus APIs
  static const String apiUrl = 'http://localhost:8080/api/auth';

  // Sincroniza datos con la API 1
  static Future<void> syncDataWithAPI1(List<Map<String, dynamic>> data) async {
    final response =
        await http.post(Uri.parse('$apiUrl/users'), body: jsonEncode(data));

    if (response.statusCode == 200) {
      // Marcamos los datos como sincronizados en tu base de datos local
      for (final record in data) {
        await markDataAsSynchronized(
            getUnsyncedDataForAPI1FromLocalDB() as Database,
            "user",
            record['id']);
      }
      print('Sincronización exitosa con API 1');
    } else {
      print('Error al sincronizar con API 1: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      throw Exception('Error al sincronizar con API 1');
    }
  }

  // Sincroniza datos con la API 2
  static Future<void> syncDataWithAPI2(List<Map<String, dynamic>> data) async {
    final response = await http.post(Uri.parse('$apiUrl/produccion'),
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      // Marcamos los datos como sincronizados en tu base de datos local
      for (final record in data) {
        await markDataAsSynchronized(
            getUnsyncedDataForAPI2FromLocalDB() as Database,
            "produccion",
            record['id']);
      }
      print('Sincronización exitosa con API 2');
    } else {
      print('Error al sincronizar con API 2: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      throw Exception('Error al sincronizar con API 2');
    }
  }

  // Implementa lógica para obtener datos no sincronizados desde tu base de datos local para API 1
  static Future<List<Map<String, dynamic>>>
      getUnsyncedDataForAPI1FromLocalDB() async {
    final db = await openDatabase(
        'test.db'); // Reemplaza con el nombre de tu base de datos local
    final tableName = 'user'; // Reemplaza con el nombre de tu tabla local

    // Consulta la base de datos para obtener datos no sincronizados (synced = 0)
    final unsyncedData = await db.query(
      tableName,
      where: 'synced = ?',
      whereArgs: [0], // Filtra por registros no sincronizados
    );

    await db.close(); // Cierra la conexión con la base de datos

    return unsyncedData;
  }

  // Implementa lógica para obtener datos no sincronizados desde tu base de datos local para API 1
  static Future<List<Map<String, dynamic>>>
      getUnsyncedDataForAPI2FromLocalDB() async {
    final db = await openDatabase(
        'test.db'); // Reemplaza con el nombre de tu base de datos local
    final tableName = 'produccion'; // Reemplaza con el nombre de tu tabla local

    // Consulta la base de datos para obtener datos no sincronizados (synced = 0)
    final unsyncedData = await db.query(
      tableName,
      where: 'synced = ?',
      whereArgs: [0], // Filtra por registros no sincronizados
    );

    await db.close(); // Cierra la conexión con la base de datos

    return unsyncedData;
  }

  static Future<void> deleteSyncedDataFromLocalDB() async {
    final db = await openDatabase(
        'test.db'); // Reemplaza con el nombre de tu base de datos local
    final tableName = 'user'; // Reemplaza con el nombre de tu tabla local

    try {
      await db.delete(
        tableName,
        where: 'synced = ?',
        whereArgs: [1], // Filtra por registros sincronizados (synced = 1)
      );
    } catch (e) {
      print('Error al eliminar datos sincronizados: $e');
    } finally {
      await db.close(); // Cierra la conexión con la base de datos
    }
  }

  // Lógica principal de sincronización
  static Future<void> syncData() async {
    final api1Data = await getUnsyncedDataForAPI1FromLocalDB();
    final api2Data = await getUnsyncedDataForAPI2FromLocalDB();

    try {
      await syncDataWithAPI1(api1Data);
      await syncDataWithAPI2(api2Data);

      // Una vez que ambas API se hayan sincronizado con éxito, eliminamos los datos sincronizados localmente.
      await deleteSyncedDataFromLocalDB();
    } catch (e) {
      print('Error de sincronización: $e');
      throw Exception('Error al sincronizar las API');
    }
  }
}
