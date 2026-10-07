class Cancion {
  final int? id;
  final String titulo;
  final String artista;
  final String? album;
  final int? anio;
  final int? duracionSeg;
  final bool favorita;

  Cancion({
    this.id,
    required this.titulo,
    required this.artista,
    this.album,
    this.anio,
    this.duracionSeg,
    this.favorita = false,
  });

  factory Cancion.fromJson(Map<String, dynamic> json) {
    return Cancion(
      id: json['id'],
      titulo: json['titulo'],
      artista: json['artista'],
      album: json['album'],
      anio: json['anio'],
      duracionSeg: json['duracion_seg'],
      favorita: json['favorita'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    // Retiramos el campo 'id' completamente. 
    // Supabase lo generará al crear y no intentará sobreescribirlo al actualizar.
    return {
      'titulo': titulo,
      'artista': artista,
      'album': album,
      'anio': anio,
      'duracion_seg': duracionSeg,
      'favorita': favorita,
    };
  }
}