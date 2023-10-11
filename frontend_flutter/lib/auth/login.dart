import 'dart:convert';
import 'dart:io' show InternetAddress;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:frontend_flutter/auth/register.dart';
import 'package:frontend_flutter/database/local/DbHelper.dart';
import 'package:frontend_flutter/views/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../components/genLoginSignUpHeader.dart';
import '../components/genTextFormField.dart';
import '../components/msgDialog.dart';
import '../models/User.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  var dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  // Verifica la conectividad en la plataforma web
  Future<bool> checkWebConnectivity() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/doc/swagger-ui/index.html'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Verifica la conectividad en otras plataformas (iOS, Android)
  Future<bool> checkMobileConnectivity() async {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  }

  Future<void> login() async {
    String uid = _conEmail.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      alertDialog("Ingrese su correo");
      return;
    } else if (passwd.isEmpty) {
      alertDialog("Ingrese su contraseña");
      return;
    }

    bool isConnected =
        kIsWeb ? await checkWebConnectivity() : await checkMobileConnectivity();

    if (isConnected) {
      await _loginWithSpringBoot(uid, passwd);
    } else {
      await _loginWithSqlCipher(uid, passwd);
    }
  }

  Future<void> _loginWithSqlCipher(String uid, String passwd) async {
    try {
      final userData = await dbHelper.getLoginUser(uid, passwd);

      if (userData != null) {
        await setSP(userData as User);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        alertDialog("Usuario no encontrado");
      }
    } catch (error) {
      print(error);
      alertDialog("Error al iniciar sesión");
    }
  }

  Future<void> setSP(User user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("correo", user.correo);
    sp.setString("password", user.password);
  }

  Future<void> _loginWithSpringBoot(String uid, String passwd) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.80.82.125:8080/asis/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'correo': uid,
          'password': passwd,
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              genLoginSignUpHeader('Iniciar Sesión'),
              getTextFormField(
                  controller: _conEmail,
                  icon: Icons.person,
                  hintName: 'Correo Electronico'),
              const SizedBox(height: 10.0),
              getTextFormField(
                controller: _conPassword,
                icon: Icons.lock,
                hintName: 'Contraseña',
                isObscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const SizedBox(
                    width: double
                        .infinity, // Para abarcar todo el ancho horizontalmente
                    height: 40,
                    child: Center(
                      child: Text(
                        'Ingresar',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    child: const Text(
                      '¿No tienes cuenta?',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpForm(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Registrate aquí',
                      style: TextStyle(fontSize: 14),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
