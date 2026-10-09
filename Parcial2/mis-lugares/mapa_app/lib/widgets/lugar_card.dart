import 'package:flutter/material.dart';
import '../models/lugar_model.dart';

class LugarCard extends StatelessWidget {
  final Lugar lugar;
  final VoidCallback onEdit;

  const LugarCard({super.key, required this.lugar, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: lugar.fotoUrl != null 
              ? Image.network(lugar.fotoUrl!, width: 50, height: 50, fit: BoxFit.cover)
              : Container(width: 50, height: 50, color: Colors.grey.shade300, child: const Icon(Icons.image)),
        ),
        title: Text(lugar.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(lugar.categoria),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
      ),
    );
  }
}