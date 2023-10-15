import 'package:flutter/material.dart';
import 'package:frontend_flutter/constants.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccount({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "¿No tienes una cuenta? " : "¿Ya tienes una cuenta? ",
          style: const TextStyle(color: kPrimaryLightColor),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? " Regístrate" : " Iniciar sesión",
            style: const TextStyle(
              color: kPrimaryLightColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
      
    );
  }
}
