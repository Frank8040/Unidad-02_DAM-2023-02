import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class DatabaseSwitcher extends StatefulWidget {
  const DatabaseSwitcher({Key? key}) : super(key: key);

  @override
  _DatabaseSwitcherState createState() => _DatabaseSwitcherState();
}

class _DatabaseSwitcherState extends State<DatabaseSwitcher> {
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    final InternetConnectionStatus status =
        await InternetConnectionChecker().connectionStatus;

    setState(() {
      isOnline = status == InternetConnectionStatus.connected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión Vacas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isOnline
                  ? 'Conexión a Internet disponible'
                  : 'No hay conexión a Internet',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isOnline) {
                  // Acceder a la base de datos remota (Spring Boot)
                  // Ejecuta las operaciones que requieran conexión.
                  // Ejemplo:
                  // fetchDataFromRemoteDatabase();
                } else {
                  // Acceder a la base de datos local (SQLite)
                  // Ejecuta las operaciones locales.
                  // Ejemplo:
                  // fetchLocalData();
                }
              },
              child: Text(isOnline
                  ? 'Acceder a la base remota'
                  : 'Acceder a la base local'),
            ),
          ],
        ),
      ),
    );
  }
}
