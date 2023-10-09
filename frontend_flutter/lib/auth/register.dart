import 'dart:convert';
import 'dart:io' show InternetAddress;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:frontend_flutter/auth/login.dart';
import 'package:frontend_flutter/database/local/DbHelper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/genLoginSignUpHeader.dart';
import '../components/genTextFormField.dart';
import '../components/msgDialog.dart';
import '../models/User.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = new GlobalKey<FormState>();

  final _conNombres = TextEditingController();
  final _conApellidos = TextEditingController();
  final _conDni = TextEditingController();
  final _conCorreo = TextEditingController();
  final _conPassword = TextEditingController();
  final _conCPassword = TextEditingController();

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

  Future<void> register() async {
    String unombres = _conNombres.text;
    String uapellidos = _conApellidos.text;
    String udni = _conDni.text;
    String ucorreo = _conCorreo.text;
    String upassword = _conPassword.text;
    String cpasswd = _conCPassword.text;

    final formKey = _formKey;

    if (formKey.currentState!.validate()) {
      if (upassword != cpasswd) {
        alertDialog('Contraseña no coincide');
      } else {
        formKey.currentState!.save();

        User uModel = User(
          nombres: unombres,
          apellidos: uapellidos,
          dni: udni,
          correo: ucorreo,
          password: upassword,
        );

        bool isConnected = kIsWeb
            ? await checkWebConnectivity()
            : await checkMobileConnectivity();

        if (isConnected) {
          await _registerWithSpringBoot(uModel);
        } else {
          await _registerWithSqlCipher(uModel);
        }
      }
    }
  }

  Future<void> _registerWithSqlCipher(User user) async {
    try {
      await dbHelper.saveData(user);
      alertDialog("Guardado con éxito");
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginForm()));
    } catch (error) {
      print(error);
      alertDialog("Error: Error al guardar datos");
    }
  }

  Future<void> _registerWithSpringBoot(User user) async {
    try {
      final response = await http.post(
        Uri.parse('http://172.168.1.110:8080/asis/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nombres': user.nombres,
          'apellidos': user.apellidos,
          'dni': user.dni,
          'correo': user.correo,
          'password': user.password,
          'token': "user"
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginForm(),
        ));
      } else {
        print('Error al hacer la solicitud: ${response.statusCode}');
        alertDialog("Error: Error al guardar datos");
      }
    } catch (error) {
      print('Error durante el registro: $error');
      alertDialog("Error: Error al guardar datos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Signup'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                genLoginSignUpHeader('Signup'),
                getTextFormField(
                    controller: _conDni,
                    icon: Icons.person_2_outlined,
                    hintName: 'DNI'),
                const SizedBox(height: 10.0),
                getTextFormField(
                    controller: _conNombres,
                    icon: Icons.person_outline,
                    inputType: TextInputType.name,
                    hintName: 'Nombres'),
                const SizedBox(height: 10.0),
                getTextFormField(
                    controller: _conApellidos,
                    icon: Icons.person_outline,
                    inputType: TextInputType.name,
                    hintName: 'Apellidos'),
                const SizedBox(height: 10.0),
                getTextFormField(
                    controller: _conCorreo,
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    hintName: 'Correo'),
                const SizedBox(height: 10.0),
                getTextFormField(
                  controller: _conPassword,
                  icon: Icons.lock,
                  hintName: 'Contraseña',
                  isObscureText: true,
                ),
                const SizedBox(height: 10.0),
                getTextFormField(
                  controller: _conCPassword,
                  icon: Icons.lock,
                  hintName: 'Confirmar Contraseña',
                  isObscureText: true,
                ),
                Container(
                  margin: const EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Tienes cuenta? '),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginForm()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue, // Color del texto
                      ),
                      child: const Text('Iniciar Sesión'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
