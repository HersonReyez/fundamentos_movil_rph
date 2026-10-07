class Game {
  final String id;
  final String name;
  final String dateInfo;
  final Team homeTeam;
  final Team awayTeam;

  Game({
    required this.id,
    required this.name,
    required this.dateInfo,
    required this.homeTeam,
    required this.awayTeam,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    var competition = json['competitions'][0];
    var competitors = competition['competitors'] as List;

    // Identificar quién es local y quién es visitante
    var homeJson = competitors.firstWhere((c) => c['homeAway'] == 'home');
    var awayJson = competitors.firstWhere((c) => c['homeAway'] == 'away');

    return Game(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Desconocido',
      dateInfo: json['status']['type']['detail'] ?? 'Fecha por definir',
      homeTeam: Team.fromJson(homeJson),
      awayTeam: Team.fromJson(awayJson),
    );
  }
}

class Team {
  final String name;
  final String abbreviation;
  final String logo;
  final String score;
  final String record;

  Team({
    required this.name,
    required this.abbreviation,
    required this.logo,
    required this.score,
    required this.record,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    // Extraer el récord (ganados-perdidos) si está disponible
    String teamRecord = '';
    if (json['records'] != null && json['records'].isNotEmpty) {
      teamRecord = json['records'][0]['summary'] ?? '';
    }

    return Team(
      name: json['team']['displayName'] ?? 'Equipo',
      abbreviation: json['team']['abbreviation'] ?? '',
      logo: json['team']['logo'] ?? '',
      score: json['score'] ?? '0',
      record: teamRecord,
    );
  }
}