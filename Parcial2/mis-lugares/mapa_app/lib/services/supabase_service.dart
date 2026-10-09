import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/lugar_model.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  // ================= AUTH =================
  Future<void> signUp(String email, String password) async {
    await _client.auth.signUp(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  String get currentUserId => _client.auth.currentUser!.id;

  // ================= CRUD LUGARES =================
  Future<List<Lugar>> getLugares() async {
    final response = await _client.from('lugares').select().order('created_at');
    return (response as List).map((e) => Lugar.fromJson(e)).toList();
  }

  Future<void> createLugar(Lugar lugar) async {
    await _client.from('lugares').insert(lugar.toJson());
  }

  Future<void> updateLugar(Lugar lugar) async {
    await _client.from('lugares').update(lugar.toJson()).eq('id', lugar.id!);
  }

  Future<void> deleteLugar(int id) async {
    await _client.from('lugares').delete().eq('id', id);
  }

  // ================= STORAGE =================
  Future<String?> uploadFoto(XFile image) async {
    try {
      final imageExtension = image.name.split('.').last;
      final imagePath = '${currentUserId}_${DateTime.now().millisecondsSinceEpoch}.$imageExtension';
      
      // readAsBytes es necesario para compatibilidad con Flutter Web
      final imageBytes = await image.readAsBytes(); 

      await _client.storage.from('fotos_lugares').uploadBinary(imagePath, imageBytes);
      return _client.storage.from('fotos_lugares').getPublicUrl(imagePath);
    } catch (e) {
      return null;
    }
  }
}