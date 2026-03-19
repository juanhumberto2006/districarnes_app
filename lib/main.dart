import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'services/supabase_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const DistriCarnesApp());
}

class DistriCarnesApp extends StatelessWidget {
  const DistriCarnesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Districarnes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50615),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Work Sans',
      ),
      home: const SplashScreen(),
    );
  }
}
