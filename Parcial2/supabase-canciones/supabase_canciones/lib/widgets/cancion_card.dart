import 'package:flutter/material.dart';
import '../models/cancion_model.dart';

class CancionCard extends StatelessWidget {
  final Cancion cancion;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const CancionCard({
    Key? key,
    required this.cancion,
    required this.onTap,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatear segundos a MM:SS
    String duracion = "Sin duración";
    if (cancion.duracionSeg != null) {
      int minutos = cancion.duracionSeg! ~/ 60;
      int segundos = cancion.duracionSeg! % 60;
      duracion = "$minutos:${segundos.toString().padLeft(2, '0')}";
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.indigoAccent,
          child: const Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text(cancion.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${cancion.artista} • ${cancion.anio ?? 'N/A'} • $duracion"),
        trailing: IconButton(
          icon: Icon(
            cancion.favorita ? Icons.favorite : Icons.favorite_border,
            color: cancion.favorita ? Colors.red : Colors.grey,
          ),
          onPressed: onToggleFavorite,
        ),
      ),
    );
  }
}