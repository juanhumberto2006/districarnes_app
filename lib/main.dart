import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'services/supabase_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://neyefaqbgrnhwglefabq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5leWVmYXFiZ3JuaHdnbGVmYWJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIyMDM1ODgsImV4cCI6MjA4Nzc3OTU4OH0.2L2Cod8-jtZKJtiwxZjsvXw_24xYks3p18F4d4qovAM',
  );
  
  await supabaseService.init();
  await authService.init();
  
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
      home: const HomeScreen(),
    );
  }
}
