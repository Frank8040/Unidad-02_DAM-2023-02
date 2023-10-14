import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_flutter/views/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response> postUser(String uid, String passwd) async {
  final response = await http.post(
    Uri.parse('http://172.168.1.110:8080/asis/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'correo': uid, 'password': passwd}),
  );
  return response;
}

String parseTokenFromResponse(http.Response response) {
  final responseData = json.decode(response.body);
  return responseData['token'];
}

Future<void> storeToken(String token) async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);

  String storedToken = prefs.getString('token') ?? '';
  print('Token almacenado: $storedToken');
}

void navigateToDashboard(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => const DashboardPage(),
  ));
}

void handleLoginError(dynamic error) {
  print('Error durante el inicio de sesión: $error');
}
