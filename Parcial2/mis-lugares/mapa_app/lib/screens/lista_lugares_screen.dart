import 'package:flutter/material.dart';
import '../models/lugar_model.dart';
import '../services/supabase_service.dart';
import '../widgets/lugar_card.dart';
import 'lugar_form_screen.dart';

class ListaLugaresScreen extends StatefulWidget {
  const ListaLugaresScreen({super.key});

  @override
  State<ListaLugaresScreen> createState() => _ListaLugaresScreenState();
}

class _ListaLugaresScreenState extends State<ListaLugaresScreen> {
  final SupabaseService _db = SupabaseService();
  List<Lugar> _todosLosLugares = [];
  List<Lugar> _lugaresFiltrados = [];
  
  String _busqueda = '';
  String _categoriaSeleccionada = 'Todas';
  final List<String> _categorias = ['Todas', 'Universidad', 'Estudio', 'Comida', 'Deporte', 'Diversión', 'Otro'];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final datos = await _db.getLugares();
    setState(() {
      _todosLosLugares = datos;
      _aplicarFiltros();
    });
  }

  void _aplicarFiltros() {
    setState(() {
      _lugaresFiltrados = _todosLosLugares.where((l) {
        final coincideNombre = l.nombre.toLowerCase().contains(_busqueda.toLowerCase());
        final coincideCat = _categoriaSeleccionada == 'Todas' || l.categoria == _categoriaSeleccionada;
        return coincideNombre && coincideCat;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Lugares')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(hintText: 'Buscar por nombre...', prefixIcon: Icon(Icons.search)),
                    onChanged: (val) {
                      _busqueda = val;
                      _aplicarFiltros();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _categoriaSeleccionada,
                  items: _categorias.map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (val) {
                    _categoriaSeleccionada = val!;
                    _aplicarFiltros();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _lugaresFiltrados.length,
              itemBuilder: (context, index) {
                final lugar = _lugaresFiltrados[index];
                return Dismissible(
                  key: Key(lugar.id.toString()),
                  background: Container(color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (direction) async {
                    await _db.deleteLugar(lugar.id!);
                  },
                  child: LugarCard(
                    lugar: lugar,
                    onEdit: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => LugarFormScreen(lugar: lugar)));
                      _cargarDatos();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}