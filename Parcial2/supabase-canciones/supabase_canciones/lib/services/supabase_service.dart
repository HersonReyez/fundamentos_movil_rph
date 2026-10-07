import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cancion_model.dart';

class SupabaseService {
  final _client = Supabase.instance.client;
  final String _table = 'canciones';

  // READ: Obtener todas las canciones
  Future<List<Cancion>> getCanciones() async {
    final response = await _client.from(_table).select().order('id', ascending: true);
    return (response as List).map((e) => Cancion.fromJson(e)).toList();
  }

  // CREATE: Insertar nueva canción
  Future<void> createCancion(Cancion cancion) async {
    await _client.from(_table).insert(cancion.toJson());
  }

  // UPDATE: Actualizar canción existente
  Future<void> updateCancion(Cancion cancion) async {
    await _client.from(_table).update(cancion.toJson()).eq('id', cancion.id!);
  }

  // DELETE: Eliminar canción
  Future<void> deleteCancion(int id) async {
    await _client.from(_table).delete().eq('id', id);
  }
  
  // UPDATE: Cambiar estado de favorito rápidamente
  Future<void> toggleFavorita(int id, bool estadoActual) async {
    await _client.from(_table).update({'favorita': !estadoActual}).eq('id', id);
  }
}