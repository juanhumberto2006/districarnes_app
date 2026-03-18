import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const DistriCarnesApp());
}

class DistriCarnesApp extends StatelessWidget {
  const DistriCarnesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DistriCarnes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50615),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Work Sans',
      ),
      home: const LoginScreen(),
    );
  }
}
