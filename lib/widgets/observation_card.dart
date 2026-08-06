import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/observacion.dart';
import 'sky_badge.dart';

class ObservationCard extends StatelessWidget {
  final Observacion observacion;
  final VoidCallback onTap;

  const ObservationCard({super.key, required this.observacion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final fecha = DateTime.tryParse(observacion.fechaHora);
    final fechaTexto = fecha != null
        ? DateFormat('dd/MM/yyyy · HH:mm').format(fecha)
        : observacion.fechaHora;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: SkyBadge(categoria: observacion.categoria),
        title: Text(observacion.titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$fechaTexto · ${observacion.ubicacionTexto ?? "GPS"}'),
        trailing: observacion.fotoPath != null
            ? const Icon(Icons.image_outlined, size: 18)
            : null,
      ),
    );
  }
}