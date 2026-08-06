import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../models/observacion.dart';
import '../services/audio_service.dart';
import '../services/database_service.dart';
import '../widgets/sky_badge.dart';

class DetailScreen extends StatelessWidget {
  final Observacion observacion;
  const DetailScreen({super.key, required this.observacion});

  @override
  Widget build(BuildContext context) {
    final fecha = DateTime.tryParse(observacion.fechaHora);
    final fechaTexto = fecha != null
        ? DateFormat('dd/MM/yyyy · HH:mm').format(fecha)
        : observacion.fechaHora;

    return Scaffold(
      appBar: AppBar(
        title: Text(observacion.titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar observación',
            onPressed: () => _confirmarEliminar(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              SkyBadge(categoria: observacion.categoria),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(observacion.categoria, style: Theme.of(context).textTheme.labelLarge),
                    Text(fechaTexto, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (observacion.fotoPath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(observacion.fotoPath!),
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
          ],

          _Campo(titulo: 'Condiciones del cielo', valor: observacion.condicionesCielo),
          if (observacion.duracionSeg != null)
            _Campo(titulo: 'Duración estimada', valor: '${observacion.duracionSeg} seg'),
          _Campo(titulo: 'Descripción', valor: observacion.descripcion),

          if (observacion.audioPath != null) ...[
            const SizedBox(height: 8),
            Text('Nota de voz', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Reproducir nota de voz'),
              onPressed: () => context.read<AudioService>().reproducir(observacion.audioPath!),
            ),
            const SizedBox(height: 16),
          ],

          Text('Ubicación', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          if (observacion.lat != null && observacion.lng != null)
            SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: ll.LatLng(observacion.lat!, observacion.lng!),
                    initialZoom: 13,
                  ),
                  children: [
                    TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                    MarkerLayer(markers: [
                      Marker(
                        point: ll.LatLng(observacion.lat!, observacion.lng!),
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on, color: Colors.red, size: 36),
                      ),
                    ]),
                  ],
                ),
              ),
            )
          else
            Text(observacion.ubicacionTexto ?? 'Ubicación no registrada'),
        ],
      ),
    );
  }

  Future<void> _confirmarEliminar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar observación'),
        content: const Text('Esta acción no se puede deshacer. ¿Deseas continuar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmar == true && observacion.id != null) {
      await context.read<DatabaseService>().deleteObservacion(observacion.id!);
      if (context.mounted) Navigator.pop(context);
    }
  }
}

class _Campo extends StatelessWidget {
  final String titulo;
  final String valor;
  const _Campo({required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 2),
          Text(valor),
        ],
      ),
    );
  }
}