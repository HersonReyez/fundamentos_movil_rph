import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_model.dart';

class ApiService {
  static const String apiUrl = 'https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard';

  Future<List<Game>> fetchGames() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> events = data['events'] ?? [];
        
        return events.map((eventJson) => Game.fromJson(eventJson)).toList();
      } else {
        throw Exception('Error al conectar con la API de ESPN');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }
}