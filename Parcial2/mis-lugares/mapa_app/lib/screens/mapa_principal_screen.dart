import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/lugar_model.dart';
import '../services/supabase_service.dart';
import 'lista_lugares_screen.dart';
import 'lugar_form_screen.dart';
import 'login_screen.dart';

class MapaPrincipalScreen extends StatefulWidget {
  const MapaPrincipalScreen({super.key});

  @override
  State<MapaPrincipalScreen> createState() => _MapaPrincipalScreenState();
}

class _MapaPrincipalScreenState extends State<MapaPrincipalScreen> {
  final MapController _mapController = MapController();
  final SupabaseService _db = SupabaseService();
  
  List<Lugar> _lugares = [];
  LatLng? _miUbicacion;

  @override
  void initState() {
    super.initState();
    _cargarLugares();
  }

  Future<void> _cargarLugares() async {
    final lugares = await _db.getLugares();
    setState(() => _lugares = lugares);
  }

  Future<void> _centrarMiUbicacion() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() => _miUbicacion = LatLng(pos.latitude, pos.longitude));
      _mapController.move(_miUbicacion!, 15.0);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permiso de ubicación denegado')));
    }
  }

  void _cerrarSesion() async {
    await _db.signOut();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const ListaLugaresScreen()));
              _cargarLugares(); // Refrescar pines al volver
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _cerrarSesion),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(22.15, -100.97), // Centro por defecto
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.ejemplo.mislugares',
          ),
          MarkerLayer(
            markers: [
              if (_miUbicacion != null)
                Marker(
                  point: _miUbicacion!,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.my_location, color: Colors.blue, size: 40),
                ),
              ..._lugares.map((lugar) => Marker(
                point: LatLng(lugar.latitud, lugar.longitud),
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
              )),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btnUbicacion",
            onPressed: _centrarMiUbicacion,
            child: const Icon(Icons.gps_fixed),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btnAgregar",
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const LugarFormScreen()));
              _cargarLugares();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}