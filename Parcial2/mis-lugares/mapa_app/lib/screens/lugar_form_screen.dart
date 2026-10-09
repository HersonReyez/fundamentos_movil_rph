import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import '../models/lugar_model.dart';
import '../services/supabase_service.dart';

class LugarFormScreen extends StatefulWidget {
  final Lugar? lugar;
  const LugarFormScreen({super.key, this.lugar});

  @override
  State<LugarFormScreen> createState() => _LugarFormScreenState();
}

class _LugarFormScreenState extends State<LugarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _db = SupabaseService();
  
  String _categoria = 'Estudio';
  LatLng? _coordenadasSeleccionadas;
  XFile? _fotoLocal;
  String? _fotoUrlExistente;
  bool _guardando = false;

  final List<String> _categorias = ['Universidad', 'Estudio', 'Comida', 'Deporte', 'Diversión', 'Otro'];

  @override
  void initState() {
    super.initState();
    if (widget.lugar != null) {
      _nombreCtrl.text = widget.lugar!.nombre;
      _categoria = widget.lugar!.categoria;
      _coordenadasSeleccionadas = LatLng(widget.lugar!.latitud, widget.lugar!.longitud);
      _fotoUrlExistente = widget.lugar!.fotoUrl;
    } else {
      _coordenadasSeleccionadas = const LatLng(22.15, -100.97); // Centro por defecto
    }
  }

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _fotoLocal = pickedFile);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _guardando = true);
    try {
      String? fotoFinalUrl = _fotoUrlExistente;
      if (_fotoLocal != null) {
        fotoFinalUrl = await _db.uploadFoto(_fotoLocal!);
      }

      final nuevoLugar = Lugar(
        id: widget.lugar?.id,
        userId: _db.currentUserId,
        nombre: _nombreCtrl.text,
        categoria: _categoria,
        latitud: _coordenadasSeleccionadas!.latitude,
        longitud: _coordenadasSeleccionadas!.longitude,
        fotoUrl: fotoFinalUrl,
      );

      if (widget.lugar == null) {
        await _db.createLugar(nuevoLugar);
      } else {
        await _db.updateLugar(nuevoLugar);
      }
      
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lugar == null ? 'Nuevo Lugar' : 'Editar Lugar')),
      body: _guardando 
        ? const Center(child: CircularProgressIndicator()) 
        : Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre del lugar'),
                  validator: (val) => val!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _categoria,
                  items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => _categoria = val!),
                  decoration: const InputDecoration(labelText: 'Categoría'),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo),
                  label: const Text('Seleccionar Foto'),
                  onPressed: _seleccionarFoto,
                ),
                if (_fotoLocal != null) 
                  const Padding(padding: EdgeInsets.all(8.0), child: Text('Foto seleccionada lista para subir', style: TextStyle(color: Colors.green))),
                const SizedBox(height: 16),
                const Text('Toca en el mapa para marcar la ubicación:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: _coordenadasSeleccionadas!,
                        initialZoom: 15.0,
                        onTap: (tapPosition, point) => setState(() => _coordenadasSeleccionadas = point),
                      ),
                      children: [
                        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _coordenadasSeleccionadas!,
                              width: 40, height: 40,
                              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _guardar,
                  child: const Text('Guardar Lugar'),
                )
              ],
            ),
          ),
    );
  }
}