import 'package:asistenciaupeu_frontend/login/login_google.dart';
import 'package:asistenciaupeu_frontend/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

bool shouldUseFirestoreEmulator = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('http://172.18.208.1', 9090);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "UPeU",
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: const MainLogin(),
    );
  }
}
