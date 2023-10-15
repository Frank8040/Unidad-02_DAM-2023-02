import 'package:flutter/material.dart';
import 'package:frontend_flutter/components/gradientButton.dart';
import 'package:frontend_flutter/components/formInputField.dart';
import 'package:frontend_flutter/database/remote/UserDB.dart';

import '../../../components/already_have_an_account.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  Future<void> _loginWithSpringBoot() async {
    String uid = _conEmail.text;
    String passwd = _conPassword.text;
    try {
      final response = await postUser(uid, passwd);

      if (response.statusCode == 200) {
        final token = parseTokenFromResponse(response);
        await storeToken(token);
        navigateToDashboard(context);
      } else {
        handleLoginError(response.statusCode);
      }
    } catch (error) {
      handleLoginError(error.toString());
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
            child: Column(
              children: [
                const Text(
                  "ingrese sus credenciales",
                  style: TextStyle(color: kPrimaryLightColor),
                ),
                const SizedBox(height: defaultPadding),
                FormInputField(
                  controller: _conEmail,
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
                const SizedBox(height: 15.0),
                GradientButton(
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color.fromARGB(255, 128, 19, 28),
                      Color.fromARGB(255, 25, 13, 34)
                    ],
                  ),
                  onPressed: () {
                    _loginWithSpringBoot();
                  },
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: defaultPadding),
        AlreadyHaveAnAccount(
          login: true,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SignUpScreen();
                },
              ),
            );
          },
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }
}
