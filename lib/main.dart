import 'package:flutter/material.dart';
import 'screens/Tela_r.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaR(), // Tela principal do MobileR
    );
  }
}
