import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_flutter/components/Button.dart';
import 'package:frontend_flutter/components/Input.dart';
import 'package:frontend_flutter/models/Users.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../already_have_an_account.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _conNombres = TextEditingController();
  final _conApellidos = TextEditingController();
  final _conDni = TextEditingController();
  final _conCorreo = TextEditingController();
  final _conPassword = TextEditingController();
  final _conCPassword = TextEditingController();

  Future<void> _registerWithSpringBoot() async {
    String unombres = _conNombres.text;
    String uapellidos = _conApellidos.text;
    String udni = _conDni.text;
    String ucorreo = _conCorreo.text;
    String upassword = _conPassword.text;
    String cpasswd = _conCPassword.text;

    final formKey = _formKey;

    if (formKey.currentState!.validate()) {
      if (upassword != cpasswd) {
        print('Contraseña no coincide');
      } else {
        formKey.currentState!.save();

        User uModel = User(
          nombres: unombres,
          apellidos: uapellidos,
          dni: udni,
          correo: ucorreo,
          password: upassword,
        );

        try {
          final response = await http.post(
            Uri.parse('http://172.168.1.110:8080/asis/register'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'nombres': uModel.nombres,
              'apellidos': uModel.apellidos,
              'dni': uModel.dni,
              'correo': uModel.correo,
              'password': uModel.password,
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
              builder: (context) => const LoginScreen(),
            ));
          } else {
            print('Error al hacer la solicitud: ${response.statusCode}');
          }
        } catch (error) {
          print('Error durante el registro: $error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FormInputField(
                  controller: _conNombres,
                  hintText: "Nombres",
                  prefixIcon: Icons.people,
                ),
                const SizedBox(height: 10.0),
                FormInputField(
                  controller: _conApellidos,
                  hintText: "Apellidos",
                  prefixIcon: Icons.people,
                ),
                const SizedBox(height: 10.0),
                FormInputField(
                  controller: _conDni,
                  hintText: "DNI",
                  prefixIcon: Icons.add_card,
                ),
                const SizedBox(height: 10.0),
                FormInputField(
                  controller: _conCorreo,
                  hintText: "Correo Electrónico",
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 10.0),
                FormInputField(
                  controller: _conPassword,
                  hintText: "Contraseña",
                  prefixIcon: Icons.lock,
                  isObscureText: true,
                ),
                const SizedBox(height: 10.0),
                FormInputField(
                  controller: _conCPassword,
                  hintText: "Confirmar Contraseña",
                  prefixIcon: Icons.lock,
                  isObscureText: true,
                ),
                const SizedBox(height: 15.0),
                CustomGradientButton(
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color.fromARGB(255, 128, 19, 28),
                      Color.fromARGB(255, 25, 13, 34)
                    ],
                  ),
                  onPressed: () {
                    _registerWithSpringBoot(); // Debe proporcionar un objeto User aquí
                  },
                  child: const Text(
                    'Registrar',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: defaultPadding * 2),
        AlreadyHaveAnAccount(
          login: false,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const LoginScreen();
                },
              ),
            );
          },
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
