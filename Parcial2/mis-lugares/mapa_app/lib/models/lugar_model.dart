class Lugar {
  final int? id;
  final String userId;
  final String nombre;
  final String categoria;
  final double latitud;
  final double longitud;
  final String? fotoUrl;

  Lugar({
    this.id,
    required this.userId,
    required this.nombre,
    required this.categoria,
    required this.latitud,
    required this.longitud,
    this.fotoUrl,
  });

  factory Lugar.fromJson(Map<String, dynamic> json) {
    return Lugar(
      id: json['id'],
      userId: json['user_id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      fotoUrl: json['foto_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'user_id': userId,
      'nombre': nombre,
      'categoria': categoria,
      'latitud': latitud,
      'longitud': longitud,
      'foto_url': fotoUrl,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}