import 'package:flutter/material.dart';
import 'package:frontend_flutter/auth/login.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final toastContext = ToastContext(); // Crea una instancia de ToastContext
    toastContext.init(context);
    return MaterialApp(
      title: 'Gestión Vacas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginForm(),
    );
  }
}
