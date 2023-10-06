// ignore_for_file: dead_code

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_flutter/views/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Función o método Login
  Future<void> _handleLogin() async {
    final correo = _correoController.text;
    final password = _passwordController.text;

    if (correo.isEmpty || password.isEmpty) {
      setState(() {});
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/asis/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'correo': correo,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print('Respuesta del servidor: ${response.body}');

        final responseData = json.decode(response.body);
        final token = responseData['token'];

        // Almacena el token en el almacenamiento seguro del dispositivo
        WidgetsFlutterBinding.ensureInitialized();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);

        // Verifica si el token se almacenó correctamente
        String storedToken =
            prefs.getString('token') ?? ''; // Obtiene el token almacenado
        print('Token almacenado: $storedToken');

        // Redirige a la vista de Dashboard después de una autenticación exitosa
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const DashboardPage(),
        ));
      } else {
        setState(() {});
        print('Error al hacer la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {});
      print('Error durante el inicio de sesión: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
      title: const Text('Senior Login'),
    ),*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _correoController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: MouseRegion(
                    cursor: SystemMouseCursors
                        .click, // Cambia el cursor a un puntero
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        onHover: (isHovering) {
                          // Define aquí lo que deseas hacer cuando el mouse se desplaza sobre el icono
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Ajusta el tamaño del "hover"
                          child: obscurePassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              obscureText: obscurePassword,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
