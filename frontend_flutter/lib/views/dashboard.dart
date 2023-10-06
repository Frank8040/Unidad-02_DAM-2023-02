import 'package:flutter/material.dart';
import 'package:frontend_flutter/auth/login.dart';
import 'package:frontend_flutter/views/finca/list.dart';
import 'package:frontend_flutter/views/producci%C3%B3n/list.dart';
import 'package:frontend_flutter/views/reproducci%C3%B3n/list.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    // Almacena el token en el almacenamiento seguro del dispositivo
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString('token', token);

    // Verifica si el token se almacenó correctamente
    String storedToken =
        prefs.getString('token') ?? ''; // Obtiene el token almacenado
    print('Token almacenado: $storedToken');
    try {
      // Realiza la solicitud HTTP para cerrar la sesión en el servidor
      final response = await http.post(
        Uri.parse('http://localhost:8080/asis/logout'),
        headers: {
          // Si es necesario, incluye el token de autenticación en el encabezado
          'Authorization': 'Bearer $storedToken',
        },
      );

      if (response.statusCode == 200) {
        // Elimina el token de autenticación del almacenamiento seguro
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('token');

        // Navega a la página de inicio de sesión
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const LoginPage(), // Reemplaza con tu página de inicio de sesión
          ),
        );
      } else {
        // Maneja el caso en el que la solicitud de cierre de sesión no se completó con éxito.
        // Puedes mostrar un mensaje de error o realizar otras acciones necesarias.
        print('Error al cerrar sesión: ${response.statusCode}');
      }
    } catch (e) {
      // Maneja cualquier error de red o excepción que pueda ocurrir durante la solicitud.
      print('Error durante el cierre de sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.account_circle_sharp),
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10.0), // Ajusta el radio para cambiar el tamaño del modal
            ),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                _customPopupMenuItem(
                    'Mi Perfil', 32, Icons.account_circle_outlined, Colors.grey,
                    () {
                  Navigator.of(context).pop();
                  // Redirige a la vista correspondiente para la Opción 1
                }),
                _customPopupMenuItem(
                    'Cerrar Sesión', 32, Icons.exit_to_app, Colors.grey, () {
                  _logout(context);
                  Navigator.of(context).pop();
                }),
              ];
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2, // 2 columnas en el grid
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _dashboardButton('REGISTRO DE LECHE', Icons.home, () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ProduccionTable()));
          }),
          _dashboardButton('CAJA', Icons.wallet, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProduccionTable()));
          }),
          _dashboardButton('INVENTARIO DE ÁREAS', Icons.wallet, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FincaTable()));
          }),
          _dashboardButton('CONTROL DE GANADO', Icons.person_3_sharp, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReproduccionTable()));
          }),
          _dashboardButton(
              'PRODUCCIÓN DE PASTO CULTIVADO', Icons.person_3_sharp, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReproduccionTable()));
          }),
          _dashboardButton('PASTURAS CONSERVADAS', Icons.person_3_sharp, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReproduccionTable()));
          }),
          _dashboardButton('REPORTES', Icons.person_3_sharp, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReproduccionTable()));
          }),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                // Llama a la función de cierre de sesión al hacer clic en el ícono en el Drawer
                _logout(context);
              },
            ),
            // Agrega más elementos del menú aquí si es necesario
          ],
        ),
      ),
    );
  }

  PopupMenuItem<T> _customPopupMenuItem<T>(String text, double height,
      IconData iconData, Color iconColor, Function() onTap) {
    return PopupMenuItem<T>(
      child: SizedBox(
        height: height,
        child: GestureDetector(
          onTap: onTap,
          child: InkWell(
            mouseCursor: MouseCursor.defer,
            hoverColor: Colors.transparent,
            child: Row(
              children: <Widget>[
                Icon(
                  iconData,
                  color: iconColor, // Color del icono
                ),
                const SizedBox(width: 8), // Espacio entre el icono y el texto
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dashboardButton(String title, IconData iconData, Function() onTap) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: 48.0, // Tamaño del icono
                color: Colors.blue, // Color del icono
              ),
              const SizedBox(height: 8.0), // Espacio entre el icono y el texto
              Text(
                title,
                textAlign: TextAlign.center, // Alinea el texto al centro
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
