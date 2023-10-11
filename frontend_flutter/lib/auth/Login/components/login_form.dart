import 'package:flutter/material.dart';
import 'package:frontend_flutter/components/raisedGradientButton.dart';

import '../../already_have_an_account.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

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
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  onSaved: (email) {},
                  style: const TextStyle(fontSize: 14.0),
                  decoration: const InputDecoration(
                    hintText: "Correo Electronico",
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: Icon(Icons.person),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    cursorColor: kPrimaryColor,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Contraseña",
                      prefixIcon: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultPadding),
                        child: Icon(Icons.lock),
                      ),
                    ),
                  ),
                ),
                RaisedGradientButton(
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color.fromARGB(255, 128, 19, 28),
                      Color.fromARGB(255, 25, 13, 34)
                    ],
                  ),
                  onPressed: () {
                    print('button clicked');
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
        const SizedBox(height: defaultPadding * 2),
        AlreadyHaveAnAccount(
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
      ],
    );
  }
}
