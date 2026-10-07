import 'package:flutter/material.dart';
import '../models/cancion_model.dart';
import '../services/supabase_service.dart';

class CancionFormScreen extends StatefulWidget {
  final Cancion? cancion; // Si es null, es creación. Si tiene datos, es edición.

  const CancionFormScreen({Key? key, this.cancion}) : super(key: key);

  @override
  State<CancionFormScreen> createState() => _CancionFormScreenState();
}

class _CancionFormScreenState extends State<CancionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _db = SupabaseService();
  
  late TextEditingController _tituloController;
  late TextEditingController _artistaController;
  late TextEditingController _albumController;
  late TextEditingController _anioController;
  late TextEditingController _duracionController;
  bool _favorita = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.cancion?.titulo ?? '');
    _artistaController = TextEditingController(text: widget.cancion?.artista ?? '');
    _albumController = TextEditingController(text: widget.cancion?.album ?? '');
    _anioController = TextEditingController(text: widget.cancion?.anio?.toString() ?? '');
    _duracionController = TextEditingController(text: widget.cancion?.duracionSeg?.toString() ?? '');
    _favorita = widget.cancion?.favorita ?? false;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _artistaController.dispose();
    _albumController.dispose();
    _anioController.dispose();
    _duracionController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      final nuevaCancion = Cancion(
        id: widget.cancion?.id, // Mantiene el ID si estamos editando
        titulo: _tituloController.text,
        artista: _artistaController.text,
        album: _albumController.text.isEmpty ? null : _albumController.text,
        anio: int.tryParse(_anioController.text),
        duracionSeg: int.tryParse(_duracionController.text),
        favorita: _favorita,
      );

      try {
        if (widget.cancion == null) {
          await _db.createCancion(nuevaCancion);
        } else {
          await _db.updateCancion(nuevaCancion);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.cancion != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Canción' : 'Nueva Canción'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título*', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _artistaController,
                decoration: const InputDecoration(labelText: 'Artista*', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _albumController,
                decoration: const InputDecoration(labelText: 'Álbum', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _anioController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Año', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _duracionController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Duración (seg)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('¿Es favorita?'),
                value: _favorita,
                onChanged: (val) => setState(() => _favorita = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: _guardar,
                child: const Text('Guardar', style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ),
      ),
    );
  }
}