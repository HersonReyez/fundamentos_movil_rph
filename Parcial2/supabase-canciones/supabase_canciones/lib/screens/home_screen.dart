import 'package:flutter/material.dart';
import '../models/cancion_model.dart';
import '../services/supabase_service.dart';
import '../widgets/cancion_card.dart';
import 'cancion_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseService _db = SupabaseService();
  late Future<List<Cancion>> _futureCanciones;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureCanciones = _db.getCanciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Canciones'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Cancion>>(
        future: _futureCanciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay canciones registradas.'));
          }

          final canciones = snapshot.data!;
          return ListView.builder(
            itemCount: canciones.length,
            itemBuilder: (context, index) {
              final cancion = canciones[index];
              return Dismissible(
                key: Key(cancion.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  await _db.deleteCancion(cancion.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${cancion.titulo} eliminada')),
                  );
                },
                child: CancionCard(
                  cancion: cancion,
                  onToggleFavorite: () async {
                    await _db.toggleFavorita(cancion.id!, cancion.favorita);
                    _loadData(); // Recargar tras cambiar el estado
                  },
                  onTap: () async {
                    // Navegar al formulario para editar
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CancionFormScreen(cancion: cancion),
                      ),
                    );
                    _loadData(); // Recargar al volver
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () async {
          // Navegar al formulario para crear
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CancionFormScreen()),
          );
          _loadData(); // Recargar al volver
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}