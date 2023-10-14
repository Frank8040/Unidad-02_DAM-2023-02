import 'package:flutter/material.dart';
import 'package:frontend_flutter/constants.dart';

class FormInputField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String hintText;
  final IconData prefixIcon;
  final bool isObscureText;

  const FormInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isObscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  @override
  _FormInputFieldState createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isObscureText && obscureText, // Actualizado aquí
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      cursorColor: kPrimaryColor,
      style: const TextStyle(fontSize: 14.0),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Icon(widget.prefixIcon),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        suffixIcon: widget.isObscureText
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
