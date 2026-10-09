import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/mapa_principal_screen.dart';

void main() async {
  // Obligatorio al usar plugins nativos antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gkpacvudyhpkmuimjxld.supabase.co',
    publishableKey: 'sb_publishable_CHLP_tyeR5i-lOI70nT9jA_nB_uSohZ',
  );

  runApp(const MisLugaresApp());
}

class MisLugaresApp extends StatelessWidget {
  const MisLugaresApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Verificamos si hay un usuario autenticado para decidir la pantalla inicial
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      title: 'Mis Lugares Favoritos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: session != null ? const MapaPrincipalScreen() : const LoginScreen(),
    );
  }
}