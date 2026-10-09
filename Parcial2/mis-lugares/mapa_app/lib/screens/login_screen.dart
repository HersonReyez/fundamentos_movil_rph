import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'mapa_principal_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _db = SupabaseService();
  bool _isLoading = false;

  Future<void> _handleAuth(bool isLogin) async {
    setState(() => _isLoading = true);
    try {
      if (isLogin) {
        await _db.signIn(_emailCtrl.text, _passwordCtrl.text);
      } else {
        await _db.signUp(_emailCtrl.text, _passwordCtrl.text);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso. Ahora inicia sesión.')),
        );
        setState(() => _isLoading = false);
        return;
      }
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapaPrincipalScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.map, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text('Mis Lugares', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Correo electrónico', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () => _handleAuth(true),
                      child: const Text('Iniciar Sesión'),
                    ),
                    TextButton(
                      onPressed: () => _handleAuth(false),
                      child: const Text('Registrarse'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}