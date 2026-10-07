import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Colocamos las credenciales directamente y usamos publishableKey
  await Supabase.initialize(
    url: 'https://sqsirqeuzhlfsotvlilv.supabase.co',
    publishableKey: 'sb_publishable_la35ZIHDQEraWdCKdYLgRA_NwifwaDp', 
  );

  runApp(const SongsApp());
}

class SongsApp extends StatelessWidget {
  const SongsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Canciones Supabase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}